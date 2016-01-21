Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160121154234.GE2510@codeblueprint.co.uk>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
	<1452518355-4606-20-git-send-email-ard.biesheuvel@linaro.org>
	<20160121154234.GE2510@codeblueprint.co.uk>
Date: Thu, 21 Jan 2016 17:12:42 +0100
Message-ID: <CAKv+Gu8JgCiKkq9CgoXY8b8LAzhBp_6K_qtJv5OBszwPPVEgTw@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 18/21] efi: stub: implement efi_get_random_bytes()
 based on EFI_RNG_PROTOCOL
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stuart Yoder <stuart.yoder@freescale.com>, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 21 January 2016 at 16:42, Matt Fleming <matt@codeblueprint.co.uk> wrote:
> On Mon, 11 Jan, at 02:19:12PM, Ard Biesheuvel wrote:
>> This exposes the firmware's implementation of EFI_RNG_PROTOCOL via a new
>> function efi_get_random_bytes().
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>  drivers/firmware/efi/libstub/Makefile  |  2 +-
>>  drivers/firmware/efi/libstub/efistub.h |  3 ++
>>  drivers/firmware/efi/libstub/random.c  | 35 ++++++++++++++++++++
>>  include/linux/efi.h                    |  5 ++-
>>  4 files changed, 43 insertions(+), 2 deletions(-)
>
> [...]
>
>> @@ -0,0 +1,35 @@
>> +/*
>> + * Copyright (C) 2016 Linaro Ltd;  <ard.biesheuvel@linaro.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + */
>> +
>> +#include <linux/efi.h>
>> +#include <asm/efi.h>
>> +
>> +#include "efistub.h"
>> +
>> +struct efi_rng_protocol_t {
>> +     efi_status_t (*get_info)(struct efi_rng_protocol_t *,
>> +                              unsigned long *, efi_guid_t *);
>> +     efi_status_t (*get_rng)(struct efi_rng_protocol_t *,
>> +                             efi_guid_t *, unsigned long, u8 *out);
>> +};
>
> This is not the usual naming convention for EFI structs, it should
> either be 'struct efi_rng_protocol' or 'efi_rng_protocol_t'.
>

OK, I will change that.

> But apart from that, this patch looks fine.
>
> Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>

Thanks
