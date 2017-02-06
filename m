Date: Mon, 6 Feb 2017 17:05:00 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170206170500.GE4190@leverpostej>
References: <1486398275-3966-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486398275-3966-5-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486398275-3966-5-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH 4/7] arm64: efi: ensure that the PE/COFF header pointer
 appears at offset 0x3c
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, will.deacon@arm.com, catalin.marinas@arm.com, labbott@fedoraproject.org, kernel-hardening@lists.openwall.com, leif.lindholm@linaro.org, pjones@redhat.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 06, 2017 at 04:24:32PM +0000, Ard Biesheuvel wrote:
> Use a .org directive to ensure that the PE/COFF header pointer appears
> at offset 0x3c. Since the EFI header is now emitted using a macro, this
> helps ensure that the invocation of the macro remains at the correct
> offset.
> 
> At the same time, collapse two adjacent #ifdef CONFIG_EFI blocks into one,
> and replace .word with .long (which are equivalent, but the former is
> never used elsewhere)
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

As with patch 3, I would very much prefer that we left these bits in
head.S.

Thanks,
Mark.

> ---
>  arch/arm64/kernel/efi-header.S | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kernel/efi-header.S b/arch/arm64/kernel/efi-header.S
> index 8c8cd0a8192b..74a25c09a1b8 100644
> --- a/arch/arm64/kernel/efi-header.S
> +++ b/arch/arm64/kernel/efi-header.S
> @@ -22,14 +22,16 @@
>  	.endm
>  
>  	.macro	__EFI_HEADER
> -#ifdef CONFIG_EFI
> -	.long	pe_header - _head		// Offset to the PE header.
> +#ifndef CONFIG_EFI
> +	.long	0				// reserved
>  #else
> -	.word	0				// reserved
> -#endif
> +	/*
> +	 * PE/COFF requires the offset to the PE header
> +	 * to be stored at offset 0x3c into the file.
> +	 */
> +	.org	_head + 0x3c
> +	.long	pe_header - _head		// Offset to the PE header.
>  
> -#ifdef CONFIG_EFI
> -	.align 3
>  pe_header:
>  	.ascii	"PE"
>  	.short 	0
> -- 
> 2.7.4
> 
