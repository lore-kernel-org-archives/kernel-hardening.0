From: Tycho Andersen <tycho@docker.com>
Date: Wed,  9 Aug 2017 14:07:49 -0600
Message-Id: <20170809200755.11234-5-tycho@docker.com>
In-Reply-To: <20170809200755.11234-1-tycho@docker.com>
References: <20170809200755.11234-1-tycho@docker.com>
Subject: [kernel-hardening] [PATCH v5 04/10] arm64: Add __flush_tlb_one()
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, Juerg Haefliger <juerg.haefliger@hpe.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Juerg Haefliger <juerg.haefliger@hpe.com>

Add a hook for flushing a single TLB entry on arm64.

Signed-off-by: Juerg Haefliger <juerg.haefliger@canonical.com>
Tested-by: Tycho Andersen <tycho@docker.com>
---
 arch/arm64/include/asm/tlbflush.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index af1c76981911..8e0c49105d3e 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -184,6 +184,14 @@ static inline void flush_tlb_kernel_range(unsigned long start, unsigned long end
 	isb();
 }
 
+static inline void __flush_tlb_one(unsigned long addr)
+{
+	dsb(ishst);
+	__tlbi(vaae1is, addr >> 12);
+	dsb(ish);
+	isb();
+}
+
 /*
  * Used to invalidate the TLB (walk caches) corresponding to intermediate page
  * table levels (pgd/pud/pmd).
-- 
2.11.0
