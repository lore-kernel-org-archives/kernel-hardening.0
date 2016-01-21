Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 21 Jan 2016 16:31:49 +0000
From: Matt Fleming <matt@codeblueprint.co.uk>
Message-ID: <20160121163149.GH2510@codeblueprint.co.uk>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
 <1452518355-4606-23-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1452518355-4606-23-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v3 21/21] arm64: efi: invoke EFI_RNG_PROTOCOL to supply
 KASLR randomness
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org, stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 11 Jan, at 02:19:15PM, Ard Biesheuvel wrote:
> Since arm64 does not use a decompressor that supplies an execution
> environment where it is feasible to some extent to provide a source of
> randomness, the arm64 KASLR kernel depends on the bootloader to supply
> some random bits in register x1 upon kernel entry.
> 
> On UEFI systems, we can use the EFI_RNG_PROTOCOL, if supplied, to obtain
> some random bits. At the same time, use it to randomize the offset of the
> kernel Image in physical memory.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/Kconfig                             |  5 ++
>  arch/arm64/kernel/efi-entry.S                  |  7 +-
>  drivers/firmware/efi/libstub/arm-stub.c        | 17 ++---
>  drivers/firmware/efi/libstub/arm64-stub.c      | 67 +++++++++++++++-----
>  drivers/firmware/efi/libstub/efi-stub-helper.c | 10 +++
>  drivers/firmware/efi/libstub/efistub.h         |  2 +
>  6 files changed, 82 insertions(+), 26 deletions(-)

[...]

> diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
> index 2a7a3015d7e0..e8a3b8cd53cc 100644
> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
> @@ -32,6 +32,10 @@
>  
>  static unsigned long __chunk_size = EFI_READ_CHUNK_SIZE;
>  
> +#ifdef CONFIG_RANDOMIZE_BASE
> +bool __nokaslr;
> +#endif
> +
>  /*
>   * Allow the platform to override the allocation granularity: this allows
>   * systems that have the capability to run with a larger page size to deal
> @@ -317,6 +321,12 @@ efi_status_t efi_parse_options(char *cmdline)
>  {
>  	char *str;
>  
> +#ifdef CONFIG_RANDOMIZE_BASE
> +	str = strstr(cmdline, "nokaslr");
> +	if (str && (str == cmdline || *(str - 1) == ' '))
> +		__nokaslr = true;
> +#endif
> +
>  	/*
>  	 * If no EFI parameters were specified on the cmdline we've got
>  	 * nothing to do.

Could we not keep the "nokaslr" parsing inside of arm-stub.c? It's not
really specific to EFI and doesn't make use of any of the code in
efi_parse_options() anyhow.

As an added bonus, __nokaslr could then become static.
