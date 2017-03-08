Date: Wed, 8 Mar 2017 11:22:04 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170308112203.GC10899@leverpostej>
References: <1488637848-13588-1-git-send-email-ard.biesheuvel@linaro.org>
 <1488637848-13588-7-git-send-email-ard.biesheuvel@linaro.org>
 <20170307164648.GC3514@leverpostej>
 <CAKv+Gu8XBPgsSePG2dc9Z90y79CJsw2p7dKUkRTkzpCd7ch8Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8XBPgsSePG2dc9Z90y79CJsw2p7dKUkRTkzpCd7ch8Qw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v4 6/6] arm64: mm: set the contiguous bit for kernel
 mappings where appropriate
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kernel-hardening@lists.openwall.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Laura Abbott <labbott@fedoraproject.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>, Kees Cook <keescook@chromium.org>, Andre Przywara <andre.przywara@arm.com>, James Morse <james.morse@arm.com>, "Suzuki K. Poulose" <suzuki.poulose@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 08, 2017 at 11:57:22AM +0100, Ard Biesheuvel wrote:
> On 7 March 2017 at 17:46, Mark Rutland <mark.rutland@arm.com> wrote:
> > Note that I've cheated and made alloc_init_pte() take a phys_addr_t
> > rather than a pfn, which I think we should do anyhow for consistency. I
> > have a patch for that, if you agree.
> 
> Yes, absolutely. I did not spot this before you pointed it out, but it
> looks a bit sloppy.

Patch below, based on patch 5 of this series.

Thanks,
Mark.

---->8----
>From 31052898c92711c871ff68aabec01b8b2c415ec1 Mon Sep 17 00:00:00 2001
From: Mark Rutland <mark.rutland@arm.com>
Date: Tue, 7 Mar 2017 15:30:13 +0000
Subject: [PATCH] arm64: mmu: unify alloc_init_p??() prototypes

Currently alloc_init_pte() accepts the physical address as a pfn, rather
than a phys_addr_t as all the other alloc_init_p??() functions do. This
also makes the structure of alloc_init_pte() unnecessarily different to
the other functions.

This patch updates alloc_init_pte() to take a the physical address as a
phys_addr_t, following the same pattern as the other alloc_init_p??()
functions.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/mm/mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 0612573..2aec93ab 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -107,7 +107,7 @@ static bool pgattr_change_is_safe(u64 old, u64 new)
 }
 
 static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
-				  unsigned long end, unsigned long pfn,
+				  unsigned long end, phys_addr_t phys,
 				  pgprot_t prot,
 				  phys_addr_t (*pgtable_alloc)(void))
 {
@@ -128,8 +128,7 @@ static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
 	do {
 		pte_t old_pte = *pte;
 
-		set_pte(pte, pfn_pte(pfn, prot));
-		pfn++;
+		set_pte(pte, pfn_pte(__phys_to_pfn(phys), prot));
 
 		/*
 		 * After the PTE entry has been populated once, we
@@ -137,6 +136,7 @@ static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
 		 */
 		BUG_ON(!pgattr_change_is_safe(pte_val(old_pte), pte_val(*pte)));
 
+		phys += PAGE_SIZE;
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
 	pte_clear_fixmap();
@@ -182,7 +182,7 @@ static void alloc_init_pmd(pud_t *pud, unsigned long addr, unsigned long end,
 			BUG_ON(!pgattr_change_is_safe(pmd_val(old_pmd),
 						      pmd_val(*pmd)));
 		} else {
-			alloc_init_pte(pmd, addr, next, __phys_to_pfn(phys),
+			alloc_init_pte(pmd, addr, next, phys,
 				       prot, pgtable_alloc);
 
 			BUG_ON(pmd_val(old_pmd) != 0 &&
-- 
1.9.1
