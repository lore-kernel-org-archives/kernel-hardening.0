Date: Mon, 26 Nov 2018 18:49:45 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] x86/fpu: XRSTOR is expected to raise #GP
Message-ID: <20181126174945.r2ubrlg2gzwog2ez@linutronix.de>
References: <20181126172706.184008-1-jannh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20181126172706.184008-1-jannh@google.com>
To: Jann Horn <jannh@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, kernel-hardening@lists.openwall.com, "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 2018-11-26 18:27:06 [+0100], Jann Horn wrote:
> commit 75045f77f7a7 ("x86/extable: Introduce _ASM_EXTABLE_UA for uaccess
> fixups") incorrectly replaced the fixup entry for XSTATE_OP with a
> user-#PF-only fixup. However, XRSTOR can also raise #GP when the supplied
> address points to userspace memory. Change it back.

The #GP is raised if the xstate content is invalid. But I guess the
details don't matter.

> Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Fixes: 75045f77f7a7 ("x86/extable: Introduce _ASM_EXTABLE_UA for uaccess fixups")
> Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

> ---
>  arch/x86/include/asm/fpu/internal.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
> index 5f7290e6e954..69dcdf195b61 100644
> --- a/arch/x86/include/asm/fpu/internal.h
> +++ b/arch/x86/include/asm/fpu/internal.h
> @@ -226,7 +226,7 @@ static inline void copy_fxregs_to_kernel(struct fpu *fpu)
>  		     "3: movl $-2,%[err]\n\t"				\
>  		     "jmp 2b\n\t"					\
>  		     ".popsection\n\t"					\
> -		     _ASM_EXTABLE_UA(1b, 3b)				\
> +		     _ASM_EXTABLE(1b, 3b)				\

So you revert to what we had before. That works, tested.

>  		     : [err] "=r" (err)					\
>  		     : "D" (st), "m" (*st), "a" (lmask), "d" (hmask)	\
>  		     : "memory")
> -- 
> 2.20.0.rc0.387.gc7a69e6b6c-goog

Sebastian
