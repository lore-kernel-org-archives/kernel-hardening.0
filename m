From: Tycho Andersen <tycho@docker.com>
Date: Wed,  9 Aug 2017 14:07:52 -0600
Message-Id: <20170809200755.11234-8-tycho@docker.com>
In-Reply-To: <20170809200755.11234-1-tycho@docker.com>
References: <20170809200755.11234-1-tycho@docker.com>
Subject: [kernel-hardening] [PATCH v5 07/10] arm64/mm: Don't flush the data cache if the page is unmapped by XPFO
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, Juerg Haefliger <juerg.haefliger@hpe.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Juerg Haefliger <juerg.haefliger@hpe.com>

If the page is unmapped by XPFO, a data cache flush results in a fatal
page fault. So don't flush in that case.

Signed-off-by: Juerg Haefliger <juerg.haefliger@canonical.com>
Tested-by: Tycho Andersen <tycho@docker.com>
---
 arch/arm64/mm/flush.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/flush.c b/arch/arm64/mm/flush.c
index 21a8d828cbf4..e17a063b2df2 100644
--- a/arch/arm64/mm/flush.c
+++ b/arch/arm64/mm/flush.c
@@ -20,6 +20,7 @@
 #include <linux/export.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
+#include <linux/xpfo.h>
 
 #include <asm/cacheflush.h>
 #include <asm/cache.h>
@@ -30,7 +31,9 @@ void sync_icache_aliases(void *kaddr, unsigned long len)
 	unsigned long addr = (unsigned long)kaddr;
 
 	if (icache_is_aliasing()) {
-		__clean_dcache_area_pou(kaddr, len);
+		/* Don't flush if the page is unmapped by XPFO */
+		if (!xpfo_page_is_unmapped(virt_to_page(kaddr)))
+			__clean_dcache_area_pou(kaddr, len);
 		__flush_icache_all();
 	} else {
 		flush_icache_range(addr, addr + len);
-- 
2.11.0
