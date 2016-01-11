Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160111162449.GP6499@leverpostej>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
	<1452518355-4606-7-git-send-email-ard.biesheuvel@linaro.org>
	<20160111162449.GP6499@leverpostej>
Date: Mon, 11 Jan 2016 18:28:51 +0100
Message-ID: <CAKv+Gu-T24A4nxP_+4fOSV+HOBM1fSAceOvQ2PtPgVosFBZriQ@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 06/21] arm64: pgtable: implement static
 [pte|pmd|pud]_offset variants
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stuart Yoder <stuart.yoder@freescale.com>, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 11 January 2016 at 17:24, Mark Rutland <mark.rutland@arm.com> wrote:
> On Mon, Jan 11, 2016 at 02:18:59PM +0100, Ard Biesheuvel wrote:
>> The page table accessors pte_offset(), pud_offset() and pmd_offset()
>> rely on __va translations, so they can only be used after the linear
>> mapping has been installed. For the early fixmap and kasan init routines,
>> whose page tables are allocated statically in the kernel image, these
>> functions will return bogus values. So implement pmd_offset_kimg() and
>> pud_offset_kimg(), which can be used instead before any page tables have
>> been allocated dynamically.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> This looks good to me. One possible suggsetion below, but either way:
>
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
>
>> ---
>>  arch/arm64/include/asm/pgtable.h | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index 6129f6755081..7b4e16068c9f 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -449,6 +449,9 @@ static inline phys_addr_t pmd_page_paddr(pmd_t pmd)
>>
>>  #define pmd_page(pmd)                pfn_to_page(__phys_to_pfn(pmd_val(pmd) & PHYS_MASK))
>>
>> +/* use ONLY for statically allocated translation tables */
>> +#define pte_offset_kimg(dir,addr)    ((pte_t *)__phys_to_kimg(pte_offset_phys((dir), (addr))))
>> +
>
> Given that we're probably only going to use this during one-off setup,
> maybe it's worth something like:
>
> #define IN_KERNEL_IMAGE(p) ({                                           \
>         unsigned long __p = (unsigned long)p;                           \
>         KIMAGE_VADDR <= __p && __p < _end;                              \
> })
>
> #define pte_offset_kimg(dir,addr) ({                                    \
>         BUG_ON(!IN_KERNEL_IMAGE(dir));                                  \
>         ((pte_t *)__phys_to_kimg(pte_offset_phys((dir), (addr))));      \
> })
>
> That might be overkill, though, given all it does is turn one runtime
> failure into another runtime failure.
>

Yes. I did consider implementing them out of line, with __init
annotations so you at least get complaints if you refer to them from
non-init code, but I don't see how we would ever need these anywhere
beyond fixmap and kasan anyway

>
>>  /*
>>   * Conversion functions: convert a page and protection to a page entry,
>>   * and a page entry and page directory to the page they refer to.
>> @@ -492,6 +495,9 @@ static inline phys_addr_t pud_page_paddr(pud_t pud)
>>
>>  #define pud_page(pud)                pfn_to_page(__phys_to_pfn(pud_val(pud) & PHYS_MASK))
>>
>> +/* use ONLY for statically allocated translation tables */
>> +#define pmd_offset_kimg(dir,addr)    ((pmd_t *)__phys_to_kimg(pmd_offset_phys((dir), (addr))))
>> +
>>  #else
>>
>>  #define pud_page_paddr(pud)  ({ BUILD_BUG(); 0; })
>> @@ -502,6 +508,8 @@ static inline phys_addr_t pud_page_paddr(pud_t pud)
>>  #define pmd_set_fixmap_offset(pudp, addr)    ((pmd_t *)pudp)
>>  #define pmd_clear_fixmap()
>>
>> +#define pmd_offset_kimg(dir,addr)    ((pmd_t *)dir)
>> +
>>  #endif       /* CONFIG_PGTABLE_LEVELS > 2 */
>>
>>  #if CONFIG_PGTABLE_LEVELS > 3
>> @@ -540,6 +548,9 @@ static inline phys_addr_t pgd_page_paddr(pgd_t pgd)
>>
>>  #define pgd_page(pgd)                pfn_to_page(__phys_to_pfn(pgd_val(pgd) & PHYS_MASK))
>>
>> +/* use ONLY for statically allocated translation tables */
>> +#define pud_offset_kimg(dir,addr)    ((pud_t *)__phys_to_kimg(pud_offset_phys((dir), (addr))))
>> +
>>  #else
>>
>>  #define pgd_page_paddr(pgd)  ({ BUILD_BUG(); 0;})
>> @@ -550,6 +561,8 @@ static inline phys_addr_t pgd_page_paddr(pgd_t pgd)
>>  #define pud_set_fixmap_offset(pgdp, addr)    ((pud_t *)pgdp)
>>  #define pud_clear_fixmap()
>>
>> +#define pud_offset_kimg(dir,addr)    ((pud_t *)dir)
>> +
>>  #endif  /* CONFIG_PGTABLE_LEVELS > 3 */
>>
>>  #define pgd_ERROR(pgd)               __pgd_error(__FILE__, __LINE__, pgd_val(pgd))
>> --
>> 2.5.0
>>
