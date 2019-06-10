Date: Mon, 10 Jun 2019 14:34:54 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v7 06/12] x86: pm-trace - Adapt assembly for PIE support
Message-ID: <201906101434.D20FDB0A9@keescook>
References: <20190520231948.49693-1-thgarnie@chromium.org>
 <20190520231948.49693-7-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520231948.49693-7-thgarnie@chromium.org>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com, Thomas Garnier <thgarnie@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 20, 2019 at 04:19:31PM -0700, Thomas Garnier wrote:
> From: Thomas Garnier <thgarnie@google.com>
> 
> Change assembly to use the new _ASM_MOVABS macro instead of _ASM_MOV for
> the assembly to be PIE compatible.
> 
> Position Independent Executable (PIE) support will allow to extend the
> KASLR randomization range below 0xffffffff80000000.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/x86/include/asm/pm-trace.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/pm-trace.h b/arch/x86/include/asm/pm-trace.h
> index bfa32aa428e5..972070806ce9 100644
> --- a/arch/x86/include/asm/pm-trace.h
> +++ b/arch/x86/include/asm/pm-trace.h
> @@ -8,7 +8,7 @@
>  do {								\
>  	if (pm_trace_enabled) {					\
>  		const void *tracedata;				\
> -		asm volatile(_ASM_MOV " $1f,%0\n"		\
> +		asm volatile(_ASM_MOVABS " $1f,%0\n"		\
>  			     ".section .tracedata,\"a\"\n"	\
>  			     "1:\t.word %c1\n\t"		\
>  			     _ASM_PTR " %c2\n"			\
> -- 
> 2.21.0.1020.gf2820cf01a-goog
> 

-- 
Kees Cook
