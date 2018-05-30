MIME-Version: 1.0
Sender: rjwysocki@gmail.com
In-Reply-To: <20180529221625.33541-10-thgarnie@google.com>
References: <20180529221625.33541-1-thgarnie@google.com> <20180529221625.33541-10-thgarnie@google.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 30 May 2018 10:19:50 +0200
Message-ID: <CAJZ5v0j8jcCfsq9QF=kZavoXhrGd+4RAuUEMPkupMXR5HNUmJQ@mail.gmail.com>
Subject: Re: [PATCH v4 09/27] x86/acpi: Adapt assembly for PIE support
Content-Type: text/plain; charset="UTF-8"
To: Thomas Garnier <thgarnie@google.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Linux PM <linux-pm@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, May 30, 2018 at 12:15 AM, Thomas Garnier <thgarnie@google.com> wrote:
> Change the assembly code to use only relative references of symbols for the
> kernel to be PIE compatible.
>
> Position Independent Executable (PIE) support will allow to extend the
> KASLR randomization range 0xffffffff80000000.
>
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  arch/x86/kernel/acpi/wakeup_64.S | 31 ++++++++++++++++---------------
>  1 file changed, 16 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kernel/acpi/wakeup_64.S b/arch/x86/kernel/acpi/wakeup_64.S
> index 50b8ed0317a3..472659c0f811 100644
> --- a/arch/x86/kernel/acpi/wakeup_64.S
> +++ b/arch/x86/kernel/acpi/wakeup_64.S
> @@ -14,7 +14,7 @@
>          * Hooray, we are in Long 64-bit mode (but still running in low memory)
>          */
>  ENTRY(wakeup_long64)
> -       movq    saved_magic, %rax
> +       movq    saved_magic(%rip), %rax
>         movq    $0x123456789abcdef0, %rdx
>         cmpq    %rdx, %rax
>         jne     bogus_64_magic
> @@ -25,14 +25,14 @@ ENTRY(wakeup_long64)
>         movw    %ax, %es
>         movw    %ax, %fs
>         movw    %ax, %gs
> -       movq    saved_rsp, %rsp
> +       movq    saved_rsp(%rip), %rsp
>
> -       movq    saved_rbx, %rbx
> -       movq    saved_rdi, %rdi
> -       movq    saved_rsi, %rsi
> -       movq    saved_rbp, %rbp
> +       movq    saved_rbx(%rip), %rbx
> +       movq    saved_rdi(%rip), %rdi
> +       movq    saved_rsi(%rip), %rsi
> +       movq    saved_rbp(%rip), %rbp
>
> -       movq    saved_rip, %rax
> +       movq    saved_rip(%rip), %rax
>         jmp     *%rax
>  ENDPROC(wakeup_long64)
>
> @@ -45,7 +45,7 @@ ENTRY(do_suspend_lowlevel)
>         xorl    %eax, %eax
>         call    save_processor_state
>
> -       movq    $saved_context, %rax
> +       leaq    saved_context(%rip), %rax
>         movq    %rsp, pt_regs_sp(%rax)
>         movq    %rbp, pt_regs_bp(%rax)
>         movq    %rsi, pt_regs_si(%rax)
> @@ -64,13 +64,14 @@ ENTRY(do_suspend_lowlevel)
>         pushfq
>         popq    pt_regs_flags(%rax)
>
> -       movq    $.Lresume_point, saved_rip(%rip)
> +       leaq    .Lresume_point(%rip), %rax
> +       movq    %rax, saved_rip(%rip)
>
> -       movq    %rsp, saved_rsp
> -       movq    %rbp, saved_rbp
> -       movq    %rbx, saved_rbx
> -       movq    %rdi, saved_rdi
> -       movq    %rsi, saved_rsi
> +       movq    %rsp, saved_rsp(%rip)
> +       movq    %rbp, saved_rbp(%rip)
> +       movq    %rbx, saved_rbx(%rip)
> +       movq    %rdi, saved_rdi(%rip)
> +       movq    %rsi, saved_rsi(%rip)
>
>         addq    $8, %rsp
>         movl    $3, %edi
> @@ -82,7 +83,7 @@ ENTRY(do_suspend_lowlevel)
>         .align 4
>  .Lresume_point:
>         /* We don't restore %rax, it must be 0 anyway */
> -       movq    $saved_context, %rax
> +       leaq    saved_context(%rip), %rax
>         movq    saved_context_cr4(%rax), %rbx
>         movq    %rbx, %cr4
>         movq    saved_context_cr3(%rax), %rbx
> --
> 2.17.0.921.gf22659ad46-goog
>
