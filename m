Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 11 Jan 2016 17:31:54 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160111173154.GB6105@leverpostej>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
 <1452518355-4606-7-git-send-email-ard.biesheuvel@linaro.org>
 <20160111162449.GP6499@leverpostej>
 <CAKv+Gu-T24A4nxP_+4fOSV+HOBM1fSAceOvQ2PtPgVosFBZriQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-T24A4nxP_+4fOSV+HOBM1fSAceOvQ2PtPgVosFBZriQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3 06/21] arm64: pgtable: implement static
 [pte|pmd|pud]_offset variants
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stuart Yoder <stuart.yoder@freescale.com>, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 11, 2016 at 06:28:51PM +0100, Ard Biesheuvel wrote:
> On 11 January 2016 at 17:24, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Mon, Jan 11, 2016 at 02:18:59PM +0100, Ard Biesheuvel wrote:
> >> The page table accessors pte_offset(), pud_offset() and pmd_offset()
> >> rely on __va translations, so they can only be used after the linear
> >> mapping has been installed. For the early fixmap and kasan init routines,
> >> whose page tables are allocated statically in the kernel image, these
> >> functions will return bogus values. So implement pmd_offset_kimg() and
> >> pud_offset_kimg(), which can be used instead before any page tables have
> >> been allocated dynamically.
> >>
> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >
> > This looks good to me. One possible suggsetion below, but either way:
> >
> > Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> >
> >> ---
> >>  arch/arm64/include/asm/pgtable.h | 13 +++++++++++++
> >>  1 file changed, 13 insertions(+)
> >>
> >> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> >> index 6129f6755081..7b4e16068c9f 100644
> >> --- a/arch/arm64/include/asm/pgtable.h
> >> +++ b/arch/arm64/include/asm/pgtable.h
> >> @@ -449,6 +449,9 @@ static inline phys_addr_t pmd_page_paddr(pmd_t pmd)
> >>
> >>  #define pmd_page(pmd)                pfn_to_page(__phys_to_pfn(pmd_val(pmd) & PHYS_MASK))
> >>
> >> +/* use ONLY for statically allocated translation tables */
> >> +#define pte_offset_kimg(dir,addr)    ((pte_t *)__phys_to_kimg(pte_offset_phys((dir), (addr))))
> >> +
> >
> > Given that we're probably only going to use this during one-off setup,
> > maybe it's worth something like:
> >
> > #define IN_KERNEL_IMAGE(p) ({                                           \
> >         unsigned long __p = (unsigned long)p;                           \
> >         KIMAGE_VADDR <= __p && __p < _end;                              \
> > })
> >
> > #define pte_offset_kimg(dir,addr) ({                                    \
> >         BUG_ON(!IN_KERNEL_IMAGE(dir));                                  \
> >         ((pte_t *)__phys_to_kimg(pte_offset_phys((dir), (addr))));      \
> > })
> >
> > That might be overkill, though, given all it does is turn one runtime
> > failure into another runtime failure.
> >
> 
> Yes. I did consider implementing them out of line, with __init
> annotations so you at least get complaints if you refer to them from
> non-init code, but I don't see how we would ever need these anywhere
> beyond fixmap and kasan anyway

Ok. Let's forget about that for now then. :)

Mark.
