Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 15 Aug 2016 12:18:58 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160815111857.GA2060@svinekod>
References: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
 <1471015666-23125-5-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1471015666-23125-5-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] Re: [PATCH 4/7] arm64: Disable TTBR0_EL1 during normal kernel
 execution
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, James Morse <james.morse@arm.com>, Will Deacon <will.deacon@arm.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 12, 2016 at 04:27:43PM +0100, Catalin Marinas wrote:
> diff --git a/arch/arm64/include/uapi/asm/ptrace.h b/arch/arm64/include/uapi/asm/ptrace.h
> index b5c3933ed441..9283e6b247f9 100644
> --- a/arch/arm64/include/uapi/asm/ptrace.h
> +++ b/arch/arm64/include/uapi/asm/ptrace.h
> @@ -52,6 +52,8 @@
>  #define PSR_Z_BIT	0x40000000
>  #define PSR_N_BIT	0x80000000
>  
> +#define _PSR_PAN_BIT	22

Given this is under uapi/, shouldn't we lose the leading underscore to align
with other PSR_* definitions?

Or should we not have this under uapi/?

[...]

> +	mrs	lr, ttbr0_el1
> +	tst	lr, #0xffff << 48		// Check for the reserved ASID

Did we not have a regular register spare here? Not a problem, but using the lr
here stands out as unusual.

Thanks,
Mark.
