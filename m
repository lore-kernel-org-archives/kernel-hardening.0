Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 16 Feb 2016 18:22:35 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20160216182235.GE19413@e104818-lin.cambridge.arm.com>
References: <1455141142-6838-1-git-send-email-david.brown@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1455141142-6838-1-git-send-email-david.brown@linaro.org>
Subject: [kernel-hardening] Re: [PATCH] arm64: vdso: Mark vDSO code as read-only
To: David Brown <david.brown@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 10, 2016 at 01:52:22PM -0800, David Brown wrote:
> diff --git a/arch/arm64/kernel/vdso/vdso.S b/arch/arm64/kernel/vdso/vdso.S
> index 60c1db5..db7c0f2 100644
> --- a/arch/arm64/kernel/vdso/vdso.S
> +++ b/arch/arm64/kernel/vdso/vdso.S
> @@ -24,6 +24,7 @@
>  	__PAGE_ALIGNED_DATA
>  
>  	.globl vdso_start, vdso_end
> +	.section .rodata
>  	.balign PAGE_SIZE
>  vdso_start:
>  	.incbin "arch/arm64/kernel/vdso/vdso.so"
> -- 
> 2.7.1

Patch applied (and removed __PAGE_ALIGNED_DATA as well). Thanks.

-- 
Catalin
