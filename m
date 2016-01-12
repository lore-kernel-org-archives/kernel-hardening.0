Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160111174018.GC6105@leverpostej>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
	<1452518355-4606-4-git-send-email-ard.biesheuvel@linaro.org>
	<20160111174018.GC6105@leverpostej>
Date: Tue, 12 Jan 2016 18:25:23 +0100
Message-ID: <CAKv+Gu_89_e1yaz-k=rzqEts+fHdTfb7WE4+C_mbFPfH0wdBrQ@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 03/21] arm64: pgtable: add dummy pud_index() and
 pmd_index() definitions
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stuart Yoder <stuart.yoder@freescale.com>, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 11 January 2016 at 18:40, Mark Rutland <mark.rutland@arm.com> wrote:
> On Mon, Jan 11, 2016 at 02:18:56PM +0100, Ard Biesheuvel wrote:
>> Add definitions of pud_index() and pmd_index() for configurations with
>> fewer than 4 resp. 3 translation levels. This makes it easier to keep
>> the users (e.g., the fixmap init code) generic.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>  arch/arm64/include/asm/pgtable.h | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index fe9bf47db5d3..6129f6755081 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -495,6 +495,7 @@ static inline phys_addr_t pud_page_paddr(pud_t pud)
>>  #else
>>
>>  #define pud_page_paddr(pud)  ({ BUILD_BUG(); 0; })
>> +#define pmd_index(addr)              ({ BUILD_BUG(); 0; })
>>
>>  /* Match pmd_offset folding in <asm/generic/pgtable-nopmd.h> */
>>  #define pmd_set_fixmap(addr)         NULL
>> @@ -542,6 +543,7 @@ static inline phys_addr_t pgd_page_paddr(pgd_t pgd)
>>  #else
>>
>>  #define pgd_page_paddr(pgd)  ({ BUILD_BUG(); 0;})
>> +#define pud_index(addr)              ({ BUILD_BUG(); 0;})
>
> I think we don't need these if we use p??_ofset_kimg for the fixmap
> initialisation.
>
> Regardless, these look good conceptually, so if they're useful
> elsewhere:
>
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
>

Thanks, but this can indeed be dropped after the proposed changes have
been made to the fixmap init code.

-- 
Ard.
