Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1452518355-4606-16-git-send-email-ard.biesheuvel@linaro.org>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
	<1452518355-4606-16-git-send-email-ard.biesheuvel@linaro.org>
Date: Mon, 11 Jan 2016 14:26:28 +0100
Message-ID: <CAKv+Gu-dcH-2jpTQSgqq9NHuvVbwzB=gni-5Le6aNFyP7Pw2bg@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 14/21] arm64: [re]define SWAPPER_TABLE_[SHIFT|SIZE] for
 use in asm code
To: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Stuart Yoder <stuart.yoder@freescale.com>, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Please disregard this patch, I accidentally sent out two versions of
14/21, and this is the wrong one.


On 11 January 2016 at 14:19, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> The current definition of SWAPPER_TABLE_SHIFT can only be used in
> asm code if the configured number of translation levels defines
> PUD_SHIFT and/or PMD_SHIFT natively (4KB and 16KB/64KB granule,
> respectively). Otherwise, it depends on the nopmd/nopud fixup
> headers, which can only be included in C code.
>
> So redefine SWAPPER_TABLE_SHIFT in a way that is independent of the
> number of configured translation levels. Define SWAPPER_TABLE_SIZE
> as well, we will need it later.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/include/asm/kernel-pgtable.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kernel-pgtable.h b/arch/arm64/include/asm/kernel-pgtable.h
> index daa8a7b9917a..eaac46097359 100644
> --- a/arch/arm64/include/asm/kernel-pgtable.h
> +++ b/arch/arm64/include/asm/kernel-pgtable.h
> @@ -57,13 +57,14 @@
>  #if ARM64_SWAPPER_USES_SECTION_MAPS
>  #define SWAPPER_BLOCK_SHIFT    SECTION_SHIFT
>  #define SWAPPER_BLOCK_SIZE     SECTION_SIZE
> -#define SWAPPER_TABLE_SHIFT    PUD_SHIFT
>  #else
>  #define SWAPPER_BLOCK_SHIFT    PAGE_SHIFT
>  #define SWAPPER_BLOCK_SIZE     PAGE_SIZE
> -#define SWAPPER_TABLE_SHIFT    PMD_SHIFT
>  #endif
>
> +#define SWAPPER_TABLE_SHIFT    (SWAPPER_BLOCK_SHIFT + PAGE_SHIFT - 3)
> +#define SWAPPER_TABLE_SIZE     (1 << SWAPPER_TABLE_SHIFT)
> +
>  /* The size of the initial kernel direct mapping */
>  #define SWAPPER_INIT_MAP_SIZE  (_AC(1, UL) << SWAPPER_TABLE_SHIFT)
>
> --
> 2.5.0
>
