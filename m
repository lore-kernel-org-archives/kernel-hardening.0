Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 16 Jun 2016 12:50:36 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
Message-ID: <20160616175036.uoks47kizfavkwzk@treble>
References: <cover.1466036668.git.luto@kernel.org>
 <4e7adb96a576c6ff12d6cc2a972b2bf44ed2319a.1466036668.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4e7adb96a576c6ff12d6cc2a972b2bf44ed2319a.1466036668.git.luto@kernel.org>
Subject: [kernel-hardening] Re: [PATCH 08/13] x86/dumpstack: When OOPSing, rewind the stack
 before do_exit
To: Andy Lutomirski <luto@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, x86@kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 15, 2016 at 05:28:30PM -0700, Andy Lutomirski wrote:
> If we call do_exit with a clean stack, we greatly reduce the risk of
> recursive oopses due to stack overflow in do_exit, and we allow
> do_exit to work even if we OOPS from an IST stack.  The latter gives
> us a much better chance of surviving long enough after we detect a
> stack overflow to write out our logs.
> 
> I intentionally separated this from the preceding patch that
> disables do_exit-on-OOPS on IST stacks.  This way, if we need to
> revert this patch, we still end up in an acceptable state wrt stack
> overflow handling.
> 
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  arch/x86/entry/entry_32.S   | 11 +++++++++++
>  arch/x86/entry/entry_64.S   | 11 +++++++++++
>  arch/x86/kernel/dumpstack.c | 13 +++++++++----
>  3 files changed, 31 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
> index 983e5d3a0d27..1499db695a88 100644
> --- a/arch/x86/entry/entry_32.S
> +++ b/arch/x86/entry/entry_32.S
> @@ -1153,3 +1153,14 @@ ENTRY(async_page_fault)
>  	jmp	error_code
>  END(async_page_fault)
>  #endif
> +
> +ENTRY(rewind_stack_do_exit)
> +	/* Prevent any naive code from trying to unwind to our caller. */
> +	xorl	%ebp, %ebp
> +
> +	movl	PER_CPU_VAR(cpu_current_top_of_stack), %esi
> +	leal	-TOP_OF_KERNEL_STACK_PADDING-PT_OLDSS(%esi), %esp
> +
> +	call	do_exit
> +1:	jmp 1b
> +END(rewind_stack_do_exit)
> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index 9ee0da1807ed..394cad73e890 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -1423,3 +1423,14 @@ ENTRY(ignore_sysret)
>  	mov	$-ENOSYS, %eax
>  	sysret
>  END(ignore_sysret)
> +
> +ENTRY(rewind_stack_do_exit)
> +	/* Prevent any naive code from trying to unwind to our caller. */
> +	xorl	%ebp, %ebp
> +
> +	movq	PER_CPU_VAR(cpu_current_top_of_stack), %rax
> +	leaq	-TOP_OF_KERNEL_STACK_PADDING-SS(%rax), %rsp

I think this should be:

	leaq	-TOP_OF_KERNEL_STACK_PADDING-SIZEOF_PTREGS, %rsp

That way when it calls do_exit(), the stack frame will be placed at the
conventional spot where a smart unwinder would expect to find it.

-- 
Josh
