Date: Fri, 24 Mar 2017 14:15:56 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170324141556.GB29588@leverpostej>
References: <20170324132410.16628-1-ard.biesheuvel@linaro.org>
 <20170324132410.16628-4-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170324132410.16628-4-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH 3/4] efi/libstub: arm/arm64: disable debug prints on
 'quiet' cmdline arg
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, matt@codeblueprint.co.uk, leif.lindholm@linaro.org, rfranz@cavium.com, mingo@kernel.org, bp@alien8.de, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 24, 2017 at 01:24:09PM +0000, Ard Biesheuvel wrote:
> The EFI stub currently prints a number of diagnostic messages that do
> not carry a lot of information. Since these prints are not controlled
> by 'loglevel' or other command line parameters, and since they appear on
> the EFI framebuffer as well (if enabled), it would be nice if we could
> turn them off.
> 
> So let's add support for the 'quiet' command line parameter in the stub,
> and disable the non-error prints if it is passed.
> 
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
> This was previously sent out as a separate patch. The difference is that this
> version looks for 'quiet' rather than 'efi=debug', and preserves the noisy
> console as the default.

This addresses my prior concern, so FWIW:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

>  drivers/firmware/efi/libstub/arm-stub.c        | 12 ++++++------
>  drivers/firmware/efi/libstub/arm32-stub.c      |  2 ++
>  drivers/firmware/efi/libstub/efi-stub-helper.c |  9 +++++++++
>  drivers/firmware/efi/libstub/efistub.h         |  7 +++++++
>  drivers/firmware/efi/libstub/secureboot.c      |  2 ++
>  include/linux/efi.h                            |  3 ---
>  6 files changed, 26 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
> index fcd34057dc1c..6f522e3091af 100644
> --- a/drivers/firmware/efi/libstub/arm-stub.c
> +++ b/drivers/firmware/efi/libstub/arm-stub.c
> @@ -116,8 +116,6 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
>  	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
>  		goto fail;
>  
> -	pr_efi(sys_table, "Booting Linux Kernel...\n");
> -
>  	status = check_platform_features(sys_table);
>  	if (status != EFI_SUCCESS)
>  		goto fail;
> @@ -151,6 +149,12 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
>  		goto fail;
>  	}
>  
> +	status = efi_parse_options(cmdline_ptr);
> +	if (status != EFI_SUCCESS)
> +		pr_efi_err(sys_table, "Failed to parse EFI cmdline options\n");
> +
> +	pr_efi(sys_table, "Booting Linux Kernel...\n");
> +
>  	si = setup_graphics(sys_table);
>  
>  	status = handle_kernel_image(sys_table, image_addr, &image_size,
> @@ -162,10 +166,6 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
>  		goto fail_free_cmdline;
>  	}
>  
> -	status = efi_parse_options(cmdline_ptr);
> -	if (status != EFI_SUCCESS)
> -		pr_efi_err(sys_table, "Failed to parse EFI cmdline options\n");
> -
>  	secure_boot = efi_get_secureboot(sys_table);
>  
>  	/*
> diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware/efi/libstub/arm32-stub.c
> index 18a8b5eb55e7..becbda445913 100644
> --- a/drivers/firmware/efi/libstub/arm32-stub.c
> +++ b/drivers/firmware/efi/libstub/arm32-stub.c
> @@ -9,6 +9,8 @@
>  #include <linux/efi.h>
>  #include <asm/efi.h>
>  
> +#include "efistub.h"
> +
>  efi_status_t check_platform_features(efi_system_table_t *sys_table_arg)
>  {
>  	int block;
> diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
> index 1575b566cd4a..93685f79f9e8 100644
> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
> @@ -33,11 +33,16 @@
>  static unsigned long __chunk_size = EFI_READ_CHUNK_SIZE;
>  
>  static int __section(.data) __nokaslr;
> +static int __section(.data) __quiet;
>  
>  int __pure nokaslr(void)
>  {
>  	return __nokaslr;
>  }
> +int __pure is_quiet(void)
> +{
> +	return __quiet;
> +}
>  
>  #define EFI_MMAP_NR_SLACK_SLOTS	8
>  
> @@ -428,6 +433,10 @@ efi_status_t efi_parse_options(char const *cmdline)
>  	if (str == cmdline || (str && str > cmdline && *(str - 1) == ' '))
>  		__nokaslr = 1;
>  
> +	str = strstr(cmdline, "quiet");
> +	if (str == cmdline || (str && str > cmdline && *(str - 1) == ' '))
> +		__quiet = 1;
> +
>  	/*
>  	 * If no EFI parameters were specified on the cmdline we've got
>  	 * nothing to do.
> diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
> index a7a2a2c3f199..83f268c05007 100644
> --- a/drivers/firmware/efi/libstub/efistub.h
> +++ b/drivers/firmware/efi/libstub/efistub.h
> @@ -25,6 +25,13 @@
>  #endif
>  
>  extern int __pure nokaslr(void);
> +extern int __pure is_quiet(void);
> +
> +#define pr_efi(sys_table, msg)		do {				\
> +	if (!is_quiet()) efi_printk(sys_table, "EFI stub: "msg);	\
> +} while (0)
> +
> +#define pr_efi_err(sys_table, msg) efi_printk(sys_table, "EFI stub: ERROR: "msg)
>  
>  void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
>  
> diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
> index 5da36e56b36a..8c34d50a4d80 100644
> --- a/drivers/firmware/efi/libstub/secureboot.c
> +++ b/drivers/firmware/efi/libstub/secureboot.c
> @@ -12,6 +12,8 @@
>  #include <linux/efi.h>
>  #include <asm/efi.h>
>  
> +#include "efistub.h"
> +
>  /* BIOS variables */
>  static const efi_guid_t efi_variable_guid = EFI_GLOBAL_VARIABLE_GUID;
>  static const efi_char16_t const efi_SecureBoot_name[] = {
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index e485e87615d1..ec36f42a2add 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1435,9 +1435,6 @@ static inline int efi_runtime_map_copy(void *buf, size_t bufsz)
>  
>  /* prototypes shared between arch specific and generic stub code */
>  
> -#define pr_efi(sys_table, msg)     efi_printk(sys_table, "EFI stub: "msg)
> -#define pr_efi_err(sys_table, msg) efi_printk(sys_table, "EFI stub: ERROR: "msg)
> -
>  void efi_printk(efi_system_table_t *sys_table_arg, char *str);
>  
>  void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
> -- 
> 2.9.3
> 
