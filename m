Date: Fri, 10 Feb 2017 10:49:43 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170210104942.GF28753@leverpostej>
References: <1486554947-3964-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486554947-3964-9-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486554947-3964-9-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v2 08/14] arm64: efi: split Image code and data into
 separate PE/COFF sections
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, leif.lindholm@linaro.org, catalin.marinas@arm.com, linux@armlinux.org.uk, kernel-hardening@lists.openwall.com, labbott@fedoraproject.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 08, 2017 at 11:55:41AM +0000, Ard Biesheuvel wrote:
> To prevent unintended modifications to the kernel text (malicious or
> otherwise) while running the EFI stub, describe the kernel image as
> two separate sections: a .text section with read-execute permissions,
> covering .text, .rodata and .init.text, and a .data section with
> read-write permissions, covering .init.data, .data and .bss.
> 
> This relies on the firmware to actually take the section permission
> flags into account, but this is something that is currently being
> implemented in EDK2, which means we will likely start seeing it in
> the wild between one and two years from now.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> index b8deffa9e1bf..a93cc2b6f50b 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -149,6 +149,9 @@ SECTIONS
>  		ARM_EXIT_KEEP(EXIT_TEXT)
>  	}
>  
> +	. = ALIGN(SZ_4K);
> +	__pecoff_data_start = .;
> +

I understand that the stub needs to split the init text/data since
unlike the kernel it'll map those with separate permissions, but it
feels odd to do this specifically for the EFI stub.

Yould it perhaps make more sense to always use separate segments for
init/exit text/data, and also apply the permission split in the kernel?

With that, I don't think we'd need additional stub-specific linker
script changes.

Thanks,
Mark.

>  	.init.data : {
>  		INIT_DATA
>  		INIT_SETUP(16)
> @@ -206,6 +209,7 @@ SECTIONS
>  	}
>  
>  	PECOFF_EDATA_PADDING
> +	__pecoff_data_rawsize = ABSOLUTE(. - __pecoff_data_start);
>  	_edata = .;
>  
>  	BSS_SECTION(0, 0, 0)
> @@ -221,6 +225,7 @@ SECTIONS
>  	. += RESERVED_TTBR0_SIZE;
>  #endif
>  
> +	__pecoff_data_size = ABSOLUTE(. - __pecoff_data_start);
>  	_end = .;
>  
>  	STABS_DEBUG
> -- 
> 2.7.4
> 
