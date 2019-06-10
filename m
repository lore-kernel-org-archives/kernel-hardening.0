Date: Mon, 10 Jun 2019 14:33:05 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v7 04/12] x86: relocate_kernel - Adapt assembly for PIE
 support
Message-ID: <201906101433.0A1A27960@keescook>
References: <20190520231948.49693-1-thgarnie@chromium.org>
 <20190520231948.49693-5-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520231948.49693-5-thgarnie@chromium.org>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com, Thomas Garnier <thgarnie@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 20, 2019 at 04:19:29PM -0700, Thomas Garnier wrote:
> From: Thomas Garnier <thgarnie@google.com>
> 
> Change the assembly code to use only absolute references of symbols for the
> kernel to be PIE compatible.
> 
> Position Independent Executable (PIE) support will allow to extend the
> KASLR randomization range below 0xffffffff80000000.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/x86/kernel/relocate_kernel_64.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
> index 11eda21eb697..3320368b6ec9 100644
> --- a/arch/x86/kernel/relocate_kernel_64.S
> +++ b/arch/x86/kernel/relocate_kernel_64.S
> @@ -208,7 +208,7 @@ identity_mapped:
>  	movq	%rax, %cr3
>  	lea	PAGE_SIZE(%r8), %rsp
>  	call	swap_pages
> -	movq	$virtual_mapped, %rax
> +	movabsq	$virtual_mapped, %rax
>  	pushq	%rax
>  	ret
>  
> -- 
> 2.21.0.1020.gf2820cf01a-goog
> 

-- 
Kees Cook
