Date: Fri, 10 Feb 2017 10:11:52 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170210101152.GC28753@leverpostej>
References: <1486554947-3964-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486554947-3964-5-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486554947-3964-5-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v2 04/14] arm64: efi: clean up Image header after PE
 header has been split off
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, leif.lindholm@linaro.org, catalin.marinas@arm.com, linux@armlinux.org.uk, kernel-hardening@lists.openwall.com, labbott@fedoraproject.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 08, 2017 at 11:55:37AM +0000, Ard Biesheuvel wrote:
> After having split off the PE header, clean up the bits that remain:
> use .long consistently, merge two adjacent #ifdef CONFIG_EFI blocks,
> fix the offset of the PE header pointer and remove the redundant .align
> that follows it.
> 
> Also, since we will be eliminating all open coded constants from the
> EFI header in subsequent patches, let's replace the open coded "ARM\x64"
> magic number with its .ascii equivalent.
> 
> No changes to the resulting binary image are intended.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/kernel/head.S | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index f779a7483736..aa8f6cd8c33f 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -91,20 +91,19 @@ _head:
>  	.quad	0				// reserved
>  	.quad	0				// reserved
>  	.quad	0				// reserved
> -	.byte	0x41				// Magic number, "ARM\x64"
> -	.byte	0x52
> -	.byte	0x4d
> -	.byte	0x64
> +	.ascii	"ARM\x64"			// Magic number
>  #ifdef CONFIG_EFI
> +	/*
> +	 * PE/COFF requires the offset to the PE header
> +	 * to be stored at offset 0x3c into the file.
> +	 */
> +	.org	_head + 0x3c
>  	.long	pe_header - _head		// Offset to the PE header.


Do we really need the .org? We expect all the other fields to stay in
place without one, and it seems odd to special-case the PE header.

Otherwise, this looks good to me.

Thanks,
Mark.

> -#else
> -	.word	0				// reserved
> -#endif
>  
> -#ifdef CONFIG_EFI
> -	.align 3
>  pe_header:
>  	__EFI_PE_HEADER
> +#else
> +	.long	0				// reserved
>  #endif
>  
>  	__INIT
> -- 
> 2.7.4
> 
