Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 11 Jan 2016 16:51:04 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160111165103.GA29503@leverpostej>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
 <1452518355-4606-5-git-send-email-ard.biesheuvel@linaro.org>
 <20160111160906.GO6499@leverpostej>
 <CAKv+Gu8KbcJEfpjRMpaQHcsDo0ziv-2xmWowE9Syn_8pOX0WTw@mail.gmail.com>
 <20160111162737.GQ6499@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160111162737.GQ6499@leverpostej>
Subject: [kernel-hardening] Re: [PATCH v3 04/21] arm64: decouple early fixmap init from linear
 mapping
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, kernel-hardening@lists.openwall.com, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Leif Lindholm <leif.lindholm@linaro.org>, Stuart Yoder <stuart.yoder@freescale.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 11, 2016 at 04:27:38PM +0000, Mark Rutland wrote:
> On Mon, Jan 11, 2016 at 05:15:13PM +0100, Ard Biesheuvel wrote:
> > On 11 January 2016 at 17:09, Mark Rutland <mark.rutland@arm.com> wrote:
> > > On Mon, Jan 11, 2016 at 02:18:57PM +0100, Ard Biesheuvel wrote:
> > >> Since the early fixmap page tables are populated using pages that are
> > >> part of the static footprint of the kernel, they are covered by the
> > >> initial kernel mapping, and we can refer to them without using __va/__pa
> > >> translations, which are tied to the linear mapping.
> > >>
> > >> Since the fixmap page tables are disjoint from the kernel mapping up
> > >> to the top level pgd entry, we can refer to bm_pte[] directly, and there
> > >> is no need to walk the page tables and perform __pa()/__va() translations
> > >> at each step.
> > >>
> > >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > >> ---
> > >>  arch/arm64/mm/mmu.c | 32 ++++++--------------
> > >>  1 file changed, 9 insertions(+), 23 deletions(-)
> > >>
> > >> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> > >> index 7711554a94f4..75b5f0dc3bdc 100644
> > >> --- a/arch/arm64/mm/mmu.c
> > >> +++ b/arch/arm64/mm/mmu.c
> > >> @@ -570,38 +570,24 @@ void vmemmap_free(unsigned long start, unsigned long end)
> > >>  #endif       /* CONFIG_SPARSEMEM_VMEMMAP */
> > >>
> > >>  static pte_t bm_pte[PTRS_PER_PTE] __page_aligned_bss;
> > >> -#if CONFIG_PGTABLE_LEVELS > 2
> > >>  static pmd_t bm_pmd[PTRS_PER_PMD] __page_aligned_bss;
> > >> -#endif
> > >> -#if CONFIG_PGTABLE_LEVELS > 3
> > >>  static pud_t bm_pud[PTRS_PER_PUD] __page_aligned_bss;
> > >> -#endif
> > >>
> > >>  static inline pud_t * fixmap_pud(unsigned long addr)
> > >>  {
> > >> -     pgd_t *pgd = pgd_offset_k(addr);
> > >> -
> > >> -     BUG_ON(pgd_none(*pgd) || pgd_bad(*pgd));
> > >> -
> > >> -     return pud_offset(pgd, addr);
> > >> +     return (CONFIG_PGTABLE_LEVELS > 3) ? &bm_pud[pud_index(addr)]
> > >> +                                        : (pud_t *)pgd_offset_k(addr);
> > >
> > > If we move patch 6 earlier, we could use pud_offset_kimg here, and avoid
> > > the cast, at the cost of passing the pgd into fixmap_pud.
> > >
> > > Similarly for fixmap_pmd.
> > >
> > 
> > Is that necessarily an improvement? I know it hides the cast, but I
> > think having an explicit pgd_t* to pud_t* cast that so obviously
> > applies to CONFIG_PGTABLE_LEVELS < 4 only is fine as well.
> 
> True; it's not a big thing either way.

Sorry,  I'm gonig to change my mind on that again. I think using
p?d_offset_kimg is preferable. e.g.

static inline pud_t * fixmap_pud(unsigned long addr)
{
        pgd_t *pgd = pgd_offset_k(addr);

        BUG_ON(pgd_none(*pgd) || pgd_bad(*pgd));

        return pud_offset_kimg(pgd, addr);
}

static inline pmd_t * fixmap_pmd(unsigned long addr)
{
        pud_t *pud = fixmap_pud(addr);

        BUG_ON(pud_none(*pud) || pud_bad(*pud));

        return pmd_offset_kimg(pud, addr);
}

That avoids having to check CONFIG_PGTABLE_LEVELS check and perform a cast,
avoids duplicating details about bm_{pud,pmd}, and keeps the existing structure
so it's easier to reason about the change. I was wrong about having to pass the
pgd or pud in, so callers don't need upating.

>From my PoV that is preferable.

Thanks,
Mark.
