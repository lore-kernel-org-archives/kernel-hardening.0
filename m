MIME-Version: 1.0
In-Reply-To: <20170718223333.110371-7-thgarnie@google.com>
References: <20170718223333.110371-1-thgarnie@google.com> <20170718223333.110371-7-thgarnie@google.com>
From: Brian Gerst <brgerst@gmail.com>
Date: Tue, 18 Jul 2017 22:49:15 -0400
Message-ID: <CAMzpN2gF7QxDbVG-6ad3Qarcn1N_JT5tit9CMvQL95LQGeZivA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC 06/22] kvm: Adapt assembly for PIE support
To: Thomas Garnier <thgarnie@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Christopher Li <sparse@chrisli.org>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Peter Foley <pefoley2@pefoley.com>, Steven Rostedt <rostedt@goodmis.org>, Tim Chen <tim.c.chen@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xen-devel@lists.xenproject.org, kvm@vger.kernel.org, linux-pm <linux-pm@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-sparse@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 18, 2017 at 6:33 PM, Thomas Garnier <thgarnie@google.com> wrote:
> Change the assembly code to use only relative references of symbols for the
> kernel to be PIE compatible. The new __ASM_GET_PTR_PRE macro is used to
> get the address of a symbol on both 32 and 64-bit with PIE support.
>
> Position Independent Executable (PIE) support will allow to extended the
> KASLR randomization range below the -2G memory limit.
>
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 6 ++++--
>  arch/x86/kernel/kvm.c           | 6 ++++--
>  arch/x86/kvm/svm.c              | 4 ++--
>  3 files changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 87ac4fba6d8e..3041201a3aeb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1352,9 +1352,11 @@ asmlinkage void kvm_spurious_fault(void);
>         ".pushsection .fixup, \"ax\" \n" \
>         "667: \n\t" \
>         cleanup_insn "\n\t"                   \
> -       "cmpb $0, kvm_rebooting \n\t"         \
> +       "cmpb $0, kvm_rebooting" __ASM_SEL(,(%%rip)) " \n\t" \
>         "jne 668b \n\t"                       \
> -       __ASM_SIZE(push) " $666b \n\t"        \
> +       __ASM_SIZE(push) "%%" _ASM_AX " \n\t"           \
> +       __ASM_GET_PTR_PRE(666b) "%%" _ASM_AX "\n\t"     \
> +       "xchg %%" _ASM_AX ", (%%" _ASM_SP ") \n\t"      \
>         "call kvm_spurious_fault \n\t"        \
>         ".popsection \n\t" \
>         _ASM_EXTABLE(666b, 667b)
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 71c17a5be983..53b8ad162589 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -618,8 +618,10 @@ asm(
>  ".global __raw_callee_save___kvm_vcpu_is_preempted;"
>  ".type __raw_callee_save___kvm_vcpu_is_preempted, @function;"
>  "__raw_callee_save___kvm_vcpu_is_preempted:"
> -"movq  __per_cpu_offset(,%rdi,8), %rax;"
> -"cmpb  $0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
> +"leaq  __per_cpu_offset(%rip), %rax;"
> +"movq  (%rax,%rdi,8), %rax;"
> +"addq  " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rip), %rax;"

This doesn't look right.  It's accessing a per-cpu variable.  The
per-cpu section is an absolute, zero-based section and not subject to
relocation.

> +"cmpb  $0, (%rax);
>  "setne %al;"
>  "ret;"
>  ".popsection");

--
Brian Gerst
