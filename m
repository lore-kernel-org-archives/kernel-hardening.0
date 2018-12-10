From: Russell Currey <ruscur@russell.cc>
Subject: [PATCH v2 1/3] powerpc/mm/radix: Use KUEP API for Radix MMU
Date: Mon, 10 Dec 2018 18:00:42 +1100
Message-Id: <20181210070044.27503-2-ruscur@russell.cc>
In-Reply-To: <20181210070044.27503-1-ruscur@russell.cc>
References: <20181210070044.27503-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linuxppc-dev@lists.ozlabs.org
Cc: mikey@neuling.org, mpe@ellerman.id.au, benh@kernel.crashing.org, npiggin@gmail.com, christophe.leroy@c-s.fr, kernel-hardening@lists.openwall.com, Russell Currey <ruscur@russell.cc>
List-ID: <kernel-hardening.lists.openwall.com>

Execution protection already exists on radix, this just refactors
the radix init to provide the KUEP setup function instead.

Thus, the only functional change is that it can now be disabled.

Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 arch/powerpc/mm/pgtable-radix.c        | 11 ++++++++---
 arch/powerpc/platforms/Kconfig.cputype |  1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/mm/pgtable-radix.c b/arch/powerpc/mm/pgtable-radix.c
index 931156069a81..3565e266994b 100644
--- a/arch/powerpc/mm/pgtable-radix.c
+++ b/arch/powerpc/mm/pgtable-radix.c
@@ -535,8 +535,14 @@ static void radix_init_amor(void)
 	mtspr(SPRN_AMOR, (3ul << 62));
 }
 
-static void radix_init_iamr(void)
+#ifdef CONFIG_PPC_KUEP
+void __init setup_kuep(bool disabled)
 {
+	if (disabled || !early_radix_enabled())
+		return;
+
+	pr_warn("Activating Kernel Userspace Execution Prevention\n");
+
 	/*
 	 * Radix always uses key0 of the IAMR to determine if an access is
 	 * allowed. We set bit 0 (IBM bit 1) of key0, to prevent instruction
@@ -544,6 +550,7 @@ static void radix_init_iamr(void)
 	 */
 	mtspr(SPRN_IAMR, (1ul << 62));
 }
+#endif
 
 void __init radix__early_init_mmu(void)
 {
@@ -605,7 +612,6 @@ void __init radix__early_init_mmu(void)
 
 	memblock_set_current_limit(MEMBLOCK_ALLOC_ANYWHERE);
 
-	radix_init_iamr();
 	radix_init_pgtable();
 	/* Switch to the guard PID before turning on MMU */
 	radix__switch_mmu_context(NULL, &init_mm);
@@ -627,7 +633,6 @@ void radix__early_init_mmu_secondary(void)
 		      __pa(partition_tb) | (PATB_SIZE_SHIFT - 12));
 		radix_init_amor();
 	}
-	radix_init_iamr();
 
 	radix__switch_mmu_context(NULL, &init_mm);
 	if (cpu_has_feature(CPU_FTR_HVMODE))
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 9997b5ea5693..48cc8df0fdd2 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -335,6 +335,7 @@ config PPC_RADIX_MMU
 	bool "Radix MMU Support"
 	depends on PPC_BOOK3S_64
 	select ARCH_HAS_GIGANTIC_PAGE if (MEMORY_ISOLATION && COMPACTION) || CMA
+	select PPC_HAVE_KUEP
 	default y
 	help
 	  Enable support for the Power ISA 3.0 Radix style MMU. Currently this
-- 
2.19.2
