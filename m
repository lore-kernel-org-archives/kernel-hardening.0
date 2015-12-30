Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 30 Dec 2015 16:26:02 +0100
Message-Id: <1451489172-17420-4-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v2 03/13] arm64: use more granular reservations for static page table allocations
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Before introducing new statically allocated page tables and increasing
their alignment in subsequent patches, update the reservation logic
so that only pages that are in actual use end up as reserved with
memblock.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/mm/init.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 6bacba847923..8e678d05ad84 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -36,6 +36,7 @@
 #include <linux/swiotlb.h>
 
 #include <asm/fixmap.h>
+#include <asm/kernel-pgtable.h>
 #include <asm/memory.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
@@ -165,11 +166,13 @@ void __init arm64_memblock_init(void)
 	 * Register the kernel text, kernel data, initrd, and initial
 	 * pagetables with memblock.
 	 */
-	memblock_reserve(__pa(_text), _end - _text);
+	memblock_reserve(__pa(_text), __bss_stop - _text);
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (initrd_start)
 		memblock_reserve(__virt_to_phys(initrd_start), initrd_end - initrd_start);
 #endif
+	memblock_reserve(__pa(idmap_pg_dir), IDMAP_DIR_SIZE);
+	memblock_reserve(__pa(swapper_pg_dir), SWAPPER_DIR_SIZE);
 
 	early_init_fdt_scan_reserved_mem();
 
-- 
2.5.0
