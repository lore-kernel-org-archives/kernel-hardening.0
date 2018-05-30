From: YaoJun <yaojun8558363@gmail.com>
Subject: [PATCH] arm64: mm: mark tramp_pg_dir read-only
Date: Wed, 30 May 2018 12:48:06 +0800
Message-Id: <20180530044806.18449-1-yaojun8558363@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: catalin.marinas@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

To protect against KSMA(Kernel Space Mirroring Attack), make
tramp_pg_dir read-only. The principle of KSMA is to insert a
carefully constructed PGD entry into the translation table.
The type of this entry is block, which maps the kernel text
and its access permissions bits are 01. The user process can
then modify kernel text directly through this mapping. In this
way, an arbitrary write can be converted to multiple arbitrary
writes.

Signed-off-by: YaoJun <yaojun8558363@gmail.com>
---
 arch/arm64/mm/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 2dbb2c9f1ec1..ac4b22c7e435 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -551,6 +551,10 @@ static int __init map_entry_trampoline(void)
 	__create_pgd_mapping(tramp_pg_dir, pa_start, TRAMP_VALIAS, PAGE_SIZE,
 			     prot, pgd_pgtable_alloc, 0);
 
+	update_mapping_prot(__pa_symbol(tramp_pg_dir),
+				(unsigned long)tramp_pg_dir,
+				PGD_SIZE, PAGE_KERNEL_RO);
+
 	/* Map both the text and data into the kernel page table */
 	__set_fixmap(FIX_ENTRY_TRAMP_TEXT, pa_start, prot);
 	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
-- 
2.17.0
