MIME-Version: 1.0
In-Reply-To: <20170120164126.27624-2-thgarnie@google.com>
References: <20170120164126.27624-1-thgarnie@google.com> <20170120164126.27624-2-thgarnie@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 20 Jan 2017 16:57:31 -0800
Message-ID: <CALCETrWpzVD_zQS1doZbzBktAc4qF5Y0CEZQpgCgYPgPYMT8dQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v1 2/3] x86: Remap GDT tables in the Fixmap section
To: Thomas Garnier <thgarnie@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, Brian Gerst <brgerst@gmail.com>, He Chen <he.chen@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>, Chen Yucong <slaoub@gmail.com>, Baoquan He <bhe@redhat.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, kvm list <kvm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 20, 2017 at 8:41 AM, Thomas Garnier <thgarnie@google.com> wrote:
> Each processor holds a GDT in its per-cpu structure. The sgdt
> instruction gives the base address of the current GDT. This address can
> be used to bypass KASLR memory randomization. With another bug, an
> attacker could target other per-cpu structures or deduce the base of
> the main memory section (PAGE_OFFSET).
>
> This patch relocates the GDT table for each processor inside the
> Fixmap section. The space is reserved based on number of supported
> cpus.
>
> For consistency, the remapping is done by default on 32 and 64 bit.
>
> Each processor switches to its remapped GDT at the end of
> initialization. For hibernation, the main processor returns with the
> original GDT and switches back to the remapping at completion.
>
> On 32 bit, the maximum number of processors is now 256. The Fixmap
> section cannot handle the original 512. Additional asserts ensure that
> the Fixmap section cannot grow beyond the space available.
>
> This patch was tested on both architectures. Hibernation and KVM were
> both tested specially for their usage of the GDT.
>
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
> Based on next-20170119
> ---
>  arch/x86/Kconfig                 |  1 +
>  arch/x86/include/asm/fixmap.h    |  4 ++++
>  arch/x86/include/asm/processor.h |  1 +
>  arch/x86/kernel/cpu/common.c     | 18 +++++++++++++++++-
>  arch/x86/mm/init_32.c            |  2 ++
>  arch/x86/power/cpu.c             |  3 +++
>  6 files changed, 28 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index f1d4e8f2131f..b4ed35db10a8 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -912,6 +912,7 @@ config MAXSMP
>  config NR_CPUS
>         int "Maximum number of CPUs" if SMP && !MAXSMP
>         range 2 8 if SMP && X86_32 && !X86_BIGSMP
> +       range 2 256 if SMP && X86_32 && X86_BIGSMP
>         range 2 512 if SMP && !MAXSMP && !CPUMASK_OFFSTACK
>         range 2 8192 if SMP && !MAXSMP && CPUMASK_OFFSTACK && X86_64
>         default "1" if !SMP
> diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
> index c46289799b02..8b913b5e9383 100644
> --- a/arch/x86/include/asm/fixmap.h
> +++ b/arch/x86/include/asm/fixmap.h
> @@ -100,6 +100,10 @@ enum fixed_addresses {
>  #ifdef CONFIG_X86_INTEL_MID
>         FIX_LNW_VRTC,
>  #endif
> +       /* Fixmap entries to remap the GDTs, one per processor. */
> +       FIX_GDT_REMAP_BEGIN,
> +       FIX_GDT_REMAP_END = FIX_GDT_REMAP_BEGIN + NR_CPUS - 1,
> +
>         __end_of_permanent_fixed_addresses,
>
>         /*
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 1be64da0384e..280211ad8be9 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -705,6 +705,7 @@ extern struct desc_ptr              early_gdt_descr;
>
>  extern void cpu_set_gdt(int);
>  extern void switch_to_new_gdt(int);
> +extern void load_remapped_gdt(int);
>  extern void load_percpu_segment(int);
>  extern void cpu_init(void);
>
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index e97ffc8d29f4..7d940b0e805a 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -443,6 +443,19 @@ void load_percpu_segment(int cpu)
>         load_stack_canary_segment();
>  }
>
> +/* Load a fixmap remapping of the per-cpu GDT */
> +void load_remapped_gdt(int cpu)
> +{
> +       struct desc_ptr gdt_descr;
> +       unsigned long idx = FIX_GDT_REMAP_BEGIN + cpu;
> +
> +       __set_fixmap(idx, __pa(get_cpu_gdt_table(cpu)), PAGE_KERNEL);
> +
> +       gdt_descr.address = (long)__fix_to_virt(idx);
> +       gdt_descr.size = GDT_SIZE - 1;
> +       load_gdt(&gdt_descr);
> +}

IMO this should be split into two functions, one to set up the fixmap
entry and one to load the GDT.

Also, would it be possible to rename the various gdt helpers so that
their functionality is more obvious?  For example, get_cpu_gdt_table()
could be get_cpu_direct_gdt_table() and the function to load the gdt
could be load_fixmap_gdt().

--Andy
