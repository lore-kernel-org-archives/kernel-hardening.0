Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 26 Jan 2016 18:10:33 +0100
Message-Id: <1453828249-14467-7-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v4 06/22] arm64: add support for ioremap() block mappings
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, labbott@fedoraproject.org, matt@codeblueprint.co.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This wires up the existing generic huge-vmap feature, which allows
ioremap() to use PMD or PUD sized block mappings.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 Documentation/features/vm/huge-vmap/arch-support.txt |  2 +-
 arch/arm64/Kconfig                                   |  1 +
 arch/arm64/include/asm/memory.h                      |  6 +++
 arch/arm64/mm/mmu.c                                  | 41 ++++++++++++++++++++
 4 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/Documentation/features/vm/huge-vmap/arch-support.txt b/Documentation/features/vm/huge-vmap/arch-support.txt
index af6816bccb43..df1d1f3c9af2 100644
--- a/Documentation/features/vm/huge-vmap/arch-support.txt
+++ b/Documentation/features/vm/huge-vmap/arch-support.txt
@@ -9,7 +9,7 @@
     |       alpha: | TODO |
     |         arc: | TODO |
     |         arm: | TODO |
-    |       arm64: | TODO |
+    |       arm64: |  ok  |
     |       avr32: | TODO |
     |    blackfin: | TODO |
     |         c6x: | TODO |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 8cc62289a63e..cd767fa3037a 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -49,6 +49,7 @@ config ARM64
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_BITREVERSE
+	select HAVE_ARCH_HUGE_VMAP
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_ARCH_KASAN if SPARSEMEM_VMEMMAP && !(ARM64_16K_PAGES && ARM64_VA_BITS_48)
 	select HAVE_ARCH_KGDB
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index bea9631b34a8..aebc739f5a11 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -106,6 +106,12 @@
 #define MT_S2_NORMAL		0xf
 #define MT_S2_DEVICE_nGnRE	0x1
 
+#ifdef CONFIG_ARM64_4K_PAGES
+#define IOREMAP_MAX_ORDER	(PUD_SHIFT)
+#else
+#define IOREMAP_MAX_ORDER	(PMD_SHIFT)
+#endif
+
 #ifndef __ASSEMBLY__
 
 extern phys_addr_t		memstart_addr;
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index cb3a7bdb4e23..b84915723ea0 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -710,3 +710,44 @@ void *__init fixmap_remap_fdt(phys_addr_t dt_phys)
 
 	return dt_virt;
 }
+
+int __init arch_ioremap_pud_supported(void)
+{
+	/* only 4k granule supports level 1 block mappings */
+	return IS_ENABLED(CONFIG_ARM64_4K_PAGES);
+}
+
+int __init arch_ioremap_pmd_supported(void)
+{
+	return 1;
+}
+
+int pud_set_huge(pud_t *pud, phys_addr_t phys, pgprot_t prot)
+{
+	BUG_ON(phys & ~PUD_MASK);
+	set_pud(pud, __pud(phys | PUD_TYPE_SECT | pgprot_val(mk_sect_prot(prot))));
+	return 1;
+}
+
+int pmd_set_huge(pmd_t *pmd, phys_addr_t phys, pgprot_t prot)
+{
+	BUG_ON(phys & ~PMD_MASK);
+	set_pmd(pmd, __pmd(phys | PMD_TYPE_SECT | pgprot_val(mk_sect_prot(prot))));
+	return 1;
+}
+
+int pud_clear_huge(pud_t *pud)
+{
+	if (!pud_sect(*pud))
+		return 0;
+	pud_clear(pud);
+	return 1;
+}
+
+int pmd_clear_huge(pmd_t *pmd)
+{
+	if (!pmd_sect(*pmd))
+		return 0;
+	pmd_clear(pmd);
+	return 1;
+}
-- 
2.5.0
