Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 4 Jul 2016 20:45:00 +0200
From: Borislav Petkov <bp@alien8.de>
Message-ID: <20160704184500.GD7261@pd.tnic>
References: <cover.1466974736.git.luto@kernel.org>
 <b05602fd545f3ddbb2c3e2bfd2ef5d18e85edd50.1466974736.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b05602fd545f3ddbb2c3e2bfd2ef5d18e85edd50.1466974736.git.luto@kernel.org>
Subject: [kernel-hardening] Re: [PATCH v4 11/29] x86/dumpstack: When OOPSing, rewind the stack
 before do_exit
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 26, 2016 at 02:55:33PM -0700, Andy Lutomirski wrote:
> If we call do_exit with a clean stack, we greatly reduce the risk of

Nits:	    do_exit()

> recursive oopses due to stack overflow in do_exit, and we allow

s/ in do_exit//

> do_exit to work even if we OOPS from an IST stack.  The latter gives

Append "()" to the function names.

> us a much better chance of surviving long enough after we detect a
> stack overflow to write out our logs.
> 
> I intentionally separated this from the preceding patch that
> disables do_exit-on-OOPS on IST stacks.  This way, if we need to
> revert this patch, we still end up in an acceptable state wrt stack
> overflow handling.
> 
> Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---

...

> diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
> index 352f022cfd5b..0d05f113805e 100644
> --- a/arch/x86/kernel/dumpstack.c
> +++ b/arch/x86/kernel/dumpstack.c
> @@ -226,6 +226,8 @@ unsigned long oops_begin(void)
>  EXPORT_SYMBOL_GPL(oops_begin);
>  NOKPROBE_SYMBOL(oops_begin);
>  
> +extern void __noreturn rewind_stack_do_exit(int signr);

You don't need the "extern" here.

> +
>  void oops_end(unsigned long flags, struct pt_regs *regs, int signr)
>  {
>  	if (regs && kexec_should_crash(current))
-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
