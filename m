Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 21 Jan 2016 15:42:34 +0000
From: Matt Fleming <matt@codeblueprint.co.uk>
Message-ID: <20160121154234.GE2510@codeblueprint.co.uk>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
 <1452518355-4606-20-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1452518355-4606-20-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v3 18/21] efi: stub: implement efi_get_random_bytes()
 based on EFI_RNG_PROTOCOL
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org, stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 11 Jan, at 02:19:12PM, Ard Biesheuvel wrote:
> This exposes the firmware's implementation of EFI_RNG_PROTOCOL via a new
> function efi_get_random_bytes().
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/firmware/efi/libstub/Makefile  |  2 +-
>  drivers/firmware/efi/libstub/efistub.h |  3 ++
>  drivers/firmware/efi/libstub/random.c  | 35 ++++++++++++++++++++
>  include/linux/efi.h                    |  5 ++-
>  4 files changed, 43 insertions(+), 2 deletions(-)

[...]

> @@ -0,0 +1,35 @@
> +/*
> + * Copyright (C) 2016 Linaro Ltd;  <ard.biesheuvel@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/efi.h>
> +#include <asm/efi.h>
> +
> +#include "efistub.h"
> +
> +struct efi_rng_protocol_t {
> +	efi_status_t (*get_info)(struct efi_rng_protocol_t *,
> +				 unsigned long *, efi_guid_t *);
> +	efi_status_t (*get_rng)(struct efi_rng_protocol_t *,
> +				efi_guid_t *, unsigned long, u8 *out);
> +};

This is not the usual naming convention for EFI structs, it should
either be 'struct efi_rng_protocol' or 'efi_rng_protocol_t'.

But apart from that, this patch looks fine.

Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
