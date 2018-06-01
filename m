From: Jun Yao <yaojun8558363@gmail.com>
Subject: [PATCH 2/4] arm64/mm: introduce variable to save new swapper_pg_dir address
Date: Fri,  1 Jun 2018 16:08:48 +0800
Message-Id: <20180601080848.11813-1-yaojun8558363@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, greg@kroah.com
List-ID: <kernel-hardening.lists.openwall.com>

Prepare for migrating swapper_pg_dir, introduce new_swapper_pg_dir
to save virtual address of swapper_pg_dir.

Signed-off-by: Jun Yao <yaojun8558363@gmail.com>
---
 arch/arm64/include/asm/mmu_context.h | 2 +-
 arch/arm64/include/asm/pgtable.h     | 1 +
 arch/arm64/mm/kasan_init.c           | 2 +-
 arch/arm64/mm/mmu.c                  | 1 +
 4 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index 3eddb871f251..481c2d16adeb 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -57,7 +57,7 @@ static inline void cpu_set_reserved_ttbr0(void)
 
 static inline void cpu_switch_mm(pgd_t *pgd, struct mm_struct *mm)
 {
-	BUG_ON(pgd == swapper_pg_dir);
+	BUG_ON(pgd == new_swapper_pg_dir);
 	cpu_set_reserved_ttbr0();
 	cpu_do_switch_mm(virt_to_phys(pgd),mm);
 }
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 14ba344b1af7..7abec25cedd2 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -723,6 +723,7 @@ extern pgd_t swapper_pg_end[];
 extern pgd_t idmap_pg_dir[PTRS_PER_PGD];
 extern pgd_t tramp_pg_dir[PTRS_PER_PGD];
 extern phys_addr_t __pa_swapper_pg_dir;
+extern pgd_t *new_swapper_pg_dir;
 
 /*
  * Encode and decode a swap entry:
diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index dd4f28c19165..08bcaae4725e 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -197,7 +197,7 @@ void __init kasan_init(void)
 	 * tmp_pg_dir used to keep early shadow mapped until full shadow
 	 * setup will be finished.
 	 */
-	memcpy(tmp_pg_dir, swapper_pg_dir, sizeof(tmp_pg_dir));
+	memcpy(tmp_pg_dir, new_swapper_pg_dir, sizeof(tmp_pg_dir));
 	dsb(ishst);
 	cpu_replace_ttbr1(__pa_symbol(tmp_pg_dir));
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 41eee333f91a..26ba3e70a91c 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -56,6 +56,7 @@ u64 kimage_voffset __ro_after_init;
 EXPORT_SYMBOL(kimage_voffset);
 
 phys_addr_t __pa_swapper_pg_dir;
+pgd_t *new_swapper_pg_dir = swapper_pg_dir;
 
 /*
  * Empty_zero_page is a special page that is used for zero-initialized data
-- 
2.17.0
