MIME-Version: 1.0
In-Reply-To: <20170120164126.27624-3-thgarnie@google.com>
References: <20170120164126.27624-1-thgarnie@google.com> <20170120164126.27624-3-thgarnie@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 20 Jan 2017 17:06:52 -0800
Message-ID: <CALCETrWx9OF7M9+guGqH2fe=Yrt2Q8MN0phuZJndk9uoWr-m6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v1 3/3] x86: Make the GDT remapping read-only on 64 bit
To: Thomas Garnier <thgarnie@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, Brian Gerst <brgerst@gmail.com>, He Chen <he.chen@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>, Chen Yucong <slaoub@gmail.com>, Baoquan He <bhe@redhat.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, kvm list <kvm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 20, 2017 at 8:41 AM, Thomas Garnier <thgarnie@google.com> wrote:
> This patch makes the GDT remapped pages read-only to prevent corruption.
> This change is done only on 64 bit.
>
> The native_load_tr_desc function was adapted to correctly handle a
> read-only GDT. The LTR instruction always writes to the GDT TSS entry.
> This generates a page fault if the GDT is read-only. This change checks
> if the current GDT is a remap and swap GDTs as needed. This function was
> tested by booting multiple machines and checking hibernation works
> properly.
>
> KVM SVM and VMX were adapted to use the writeable GDT. On VMX, the GDT
> description and writeble address were put in two per-cpu variables for
> convenience. For testing, VMs were started and restored on multiple
> configurations.
>
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
> Based on next-20170119
> ---
>  arch/x86/include/asm/desc.h      | 44 +++++++++++++++++++++++++++++++++++-----
>  arch/x86/include/asm/processor.h |  1 +
>  arch/x86/kernel/cpu/common.c     | 36 ++++++++++++++++++++++++++------
>  arch/x86/kvm/svm.c               |  5 ++---
>  arch/x86/kvm/vmx.c               | 23 +++++++++++++--------
>  5 files changed, 86 insertions(+), 23 deletions(-)
>
> diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
> index 12080d87da3b..6ed68d449c7b 100644
> --- a/arch/x86/include/asm/desc.h
> +++ b/arch/x86/include/asm/desc.h
> @@ -50,6 +50,13 @@ static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
>         return per_cpu(gdt_page, cpu).gdt;
>  }
>
> +static inline struct desc_struct *get_current_gdt_table(void)
> +{
> +       return get_cpu_var(gdt_page).gdt;
> +}

This function is poorly named IMO.  Which GDT address does it return?
Can we call it get_current_direct_gdt()?  Also, IIRC
this_cpu_read(gdt_page.gdt) generates better code.

> +
> +struct desc_struct *get_remapped_gdt(int cpu);

And get_current_fixmap_gdt(void) perhaps?  And why isn't it inline?
It's very simple.

> +/*
> + * The LTR instruction marks the TSS GDT entry as busy. In 64bit, the GDT is
> + * a read-only remapping. To prevent a page fault, the GDT is switched to the
> + * original writeable version when needed.
> + */
> +#ifdef CONFIG_X86_64
> +static inline void native_load_tr_desc(void)
> +{
> +       struct desc_ptr gdt;
> +       int cpu = raw_smp_processor_id();
> +       bool restore = false;
> +       struct desc_struct *remapped_gdt;
> +
> +       native_store_gdt(&gdt);
> +       remapped_gdt = get_remapped_gdt(cpu);
> +
> +       /* Swap and restore only if the current GDT is the remap. */
> +       if (gdt.address == (unsigned long)remapped_gdt) {
> +               load_percpu_gdt(cpu);

This line (load_percpu_gdt(cpu)) is hard to understand because of the
poorly named function.

>  /* Load a fixmap remapping of the per-cpu GDT */
>  void load_remapped_gdt(int cpu)
>  {
>         struct desc_ptr gdt_descr;
>         unsigned long idx = FIX_GDT_REMAP_BEGIN + cpu;
>
> -       __set_fixmap(idx, __pa(get_cpu_gdt_table(cpu)), PAGE_KERNEL);
> +       __set_fixmap(idx, __pa(get_cpu_gdt_table(cpu)), GDT_REMAP_PROT);

How about PAGE_FIXMAP_GDT instead of GDT_REMAP_PROT?

> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index d0414f054bdf..da261f231017 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -741,7 +741,6 @@ static int svm_hardware_enable(void)
>
>         struct svm_cpu_data *sd;
>         uint64_t efer;
> -       struct desc_ptr gdt_descr;
>         struct desc_struct *gdt;
>         int me = raw_smp_processor_id();
>
> @@ -763,8 +762,7 @@ static int svm_hardware_enable(void)
>         sd->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
>         sd->next_asid = sd->max_asid + 1;
>
> -       native_store_gdt(&gdt_descr);
> -       gdt = (struct desc_struct *)gdt_descr.address;
> +       gdt = get_current_gdt_table();
>         sd->tss_desc = (struct kvm_ldttss_desc *)(gdt + GDT_ENTRY_TSS);
>
>         wrmsrl(MSR_EFER, efer | EFER_SVME);
> @@ -4251,6 +4249,7 @@ static void reload_tss(struct kvm_vcpu *vcpu)
>
>         struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
>         sd->tss_desc->type = 9; /* available 32/64-bit TSS */
> +
>         load_TR_desc();
>  }

Paulo, are you okay with the performance hit here?  Is there any easy
way to avoid it?

>
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index d2fe3a51876c..acbf78c962d0 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -935,7 +935,8 @@ static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
>   * when a CPU is brought down, and we need to VMCLEAR all VMCSs loaded on it.
>   */
>  static DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
> -static DEFINE_PER_CPU(struct desc_ptr, host_gdt);
> +static DEFINE_PER_CPU(struct desc_ptr, host_gdt_desc);
> +static DEFINE_PER_CPU(unsigned long, host_gdt);

This pair of variables is inscrutible IMO.  It should at least have a
comment, but better names would help even more.

>
>  /*
>   * We maintian a per-CPU linked-list of vCPU, so in wakeup_handler() we
> @@ -1997,10 +1998,9 @@ static void reload_tss(void)
>         /*
>          * VT restores TR but not its size.  Useless.
>          */
> -       struct desc_ptr *gdt = this_cpu_ptr(&host_gdt);
>         struct desc_struct *descs;
>
> -       descs = (void *)gdt->address;
> +       descs = (void *)get_cpu_var(host_gdt);
>         descs[GDT_ENTRY_TSS].type = 9; /* available TSS */
>         load_TR_desc();
>  }
> @@ -2061,7 +2061,6 @@ static bool update_transition_efer(struct vcpu_vmx *vmx, int efer_offset)
>
>  static unsigned long segment_base(u16 selector)
>  {
> -       struct desc_ptr *gdt = this_cpu_ptr(&host_gdt);
>         struct desc_struct *d;
>         unsigned long table_base;
>         unsigned long v;
> @@ -2069,7 +2068,7 @@ static unsigned long segment_base(u16 selector)
>         if (!(selector & ~3))
>                 return 0;
>
> -       table_base = gdt->address;
> +       table_base = get_cpu_var(host_gdt);

this_cpu_read() if possible, please.  But can't this just use the
generic accessor instead of a KVM-specific percpu variable?

>
>         if (selector & 4) {           /* from ldt */
>                 u16 ldt_selector = kvm_read_ldt();
> @@ -2185,7 +2184,7 @@ static void __vmx_load_host_state(struct vcpu_vmx *vmx)
>  #endif
>         if (vmx->host_state.msr_host_bndcfgs)
>                 wrmsrl(MSR_IA32_BNDCFGS, vmx->host_state.msr_host_bndcfgs);
> -       load_gdt(this_cpu_ptr(&host_gdt));
> +       load_gdt(this_cpu_ptr(&host_gdt_desc));
>  }

I assume the intent is to have the VM exit restore the direct GDT,
then to load the new TR, then to load the fixmap GDT.  Is that indeed
the case?.

>
>  static void vmx_load_host_state(struct vcpu_vmx *vmx)
> @@ -2287,7 +2286,7 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>         }
>
>         if (!already_loaded) {
> -               struct desc_ptr *gdt = this_cpu_ptr(&host_gdt);
> +               unsigned long gdt = get_cpu_var(host_gdt);
>                 unsigned long sysenter_esp;
>
>                 kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
> @@ -2297,7 +2296,7 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>                  * processors.
>                  */
>                 vmcs_writel(HOST_TR_BASE, kvm_read_tr_base()); /* 22.2.4 */
> -               vmcs_writel(HOST_GDTR_BASE, gdt->address);   /* 22.2.4 */
> +               vmcs_writel(HOST_GDTR_BASE, gdt);   /* 22.2.4 */
>
>                 rdmsrl(MSR_IA32_SYSENTER_ESP, sysenter_esp);
>                 vmcs_writel(HOST_IA32_SYSENTER_ESP, sysenter_esp); /* 22.2.3 */
> @@ -3523,7 +3522,13 @@ static int hardware_enable(void)
>                 ept_sync_global();
>         }
>
> -       native_store_gdt(this_cpu_ptr(&host_gdt));
> +       native_store_gdt(this_cpu_ptr(&host_gdt_desc));
> +
> +       /*
> +        * The GDT is remapped and can be read-only, use the underlying memory
> +        * that is always writeable.
> +        */
> +       per_cpu(host_gdt, cpu) = (unsigned long)get_current_gdt_table();

this_cpu_write().  Better yet, just get rid of this entirely.

--Andy
