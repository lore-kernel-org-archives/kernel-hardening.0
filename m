Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Fri,  3 Jun 2016 11:40:24 -0700
Message-Id: <1464979224-2085-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1464979224-2085-1-git-send-email-keescook@chromium.org>
References: <1464979224-2085-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 2/2] arm: apply more __ro_after_init
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mathias Krause <minipli@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Guided by grsecurity's analogous __read_only markings in arch/arm,
this applies several uses of __ro_after_init to structures that are
only updated during __init.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/kernel/cpuidle.c |  2 +-
 arch/arm/kernel/setup.c   | 10 +++++-----
 arch/arm/kernel/smp.c     |  2 +-
 arch/arm/lib/delay.c      |  2 +-
 arch/arm/mm/mmu.c         |  9 ++-------
 arch/x86/mm/ioremap.c     |  3 +--
 6 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/arm/kernel/cpuidle.c b/arch/arm/kernel/cpuidle.c
index a44b268e12e1..d574708ea20c 100644
--- a/arch/arm/kernel/cpuidle.c
+++ b/arch/arm/kernel/cpuidle.c
@@ -19,7 +19,7 @@ extern struct of_cpuidle_method __cpuidle_method_of_table[];
 static const struct of_cpuidle_method __cpuidle_method_of_table_sentinel
 	__used __section(__cpuidle_method_of_table_end);
 
-static struct cpuidle_ops cpuidle_ops[NR_CPUS];
+static struct cpuidle_ops cpuidle_ops[NR_CPUS] __ro_after_init;
 
 /**
  * arm_cpuidle_simple_enter() - a wrapper to cpu_do_idle()
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 7b5350060612..38196e581d0a 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -115,19 +115,19 @@ EXPORT_SYMBOL(elf_hwcap2);
 
 
 #ifdef MULTI_CPU
-struct processor processor __read_mostly;
+struct processor processor __ro_after_init;
 #endif
 #ifdef MULTI_TLB
-struct cpu_tlb_fns cpu_tlb __read_mostly;
+struct cpu_tlb_fns cpu_tlb __ro_after_init;
 #endif
 #ifdef MULTI_USER
-struct cpu_user_fns cpu_user __read_mostly;
+struct cpu_user_fns cpu_user __ro_after_init;
 #endif
 #ifdef MULTI_CACHE
-struct cpu_cache_fns cpu_cache __read_mostly;
+struct cpu_cache_fns cpu_cache __ro_after_init;
 #endif
 #ifdef CONFIG_OUTER_CACHE
-struct outer_cache_fns outer_cache __read_mostly;
+struct outer_cache_fns outer_cache __ro_after_init;
 EXPORT_SYMBOL(outer_cache);
 #endif
 
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index df90bc59bfce..9902e76fce0d 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -82,7 +82,7 @@ enum ipi_msg_type {
 
 static DECLARE_COMPLETION(cpu_running);
 
-static struct smp_operations smp_ops;
+static struct smp_operations smp_ops __ro_after_init;
 
 void __init smp_set_ops(const struct smp_operations *ops)
 {
diff --git a/arch/arm/lib/delay.c b/arch/arm/lib/delay.c
index 8044591dca72..2cef11884857 100644
--- a/arch/arm/lib/delay.c
+++ b/arch/arm/lib/delay.c
@@ -29,7 +29,7 @@
 /*
  * Default to the loop-based delay implementation.
  */
-struct arm_delay_ops arm_delay_ops = {
+struct arm_delay_ops arm_delay_ops __ro_after_init = {
 	.delay		= __loop_delay,
 	.const_udelay	= __loop_const_udelay,
 	.udelay		= __loop_udelay,
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 62f4d01941f7..5e2acc78175e 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -243,7 +243,7 @@ __setup("noalign", noalign_setup);
 #define PROT_PTE_S2_DEVICE	PROT_PTE_DEVICE
 #define PROT_SECT_DEVICE	PMD_TYPE_SECT|PMD_SECT_AP_WRITE
 
-static struct mem_type mem_types[] = {
+static struct mem_type mem_types[] __ro_after_init = {
 	[MT_DEVICE] = {		  /* Strongly ordered / ARMv6 shared device */
 		.prot_pte	= PROT_PTE_DEVICE | L_PTE_MT_DEV_SHARED |
 				  L_PTE_SHARED,
@@ -1309,16 +1309,11 @@ void __init arm_mm_memblock_reserve(void)
  * Any other function or debugging method which may touch any device _will_
  * crash the kernel.
  */
+static char vectors[PAGE_SIZE * 2] __ro_after_init __aligned(PAGE_SIZE);
 static void __init devicemaps_init(const struct machine_desc *mdesc)
 {
 	struct map_desc map;
 	unsigned long addr;
-	void *vectors;
-
-	/*
-	 * Allocate the vector page early.
-	 */
-	vectors = early_alloc(PAGE_SIZE * 2);
 
 	early_trap_init(vectors);
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 4e5821896eec..f0894910bdd7 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -419,8 +419,7 @@ void unxlate_dev_mem_ptr(phys_addr_t phys, void *addr)
 	iounmap((void __iomem *)((unsigned long)addr & PAGE_MASK));
 }
 
-static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)] __ro_after_init
-					     __aligned(PAGE_SIZE);
+static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)] __page_aligned_bss;
 
 static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
 {
-- 
2.7.4
