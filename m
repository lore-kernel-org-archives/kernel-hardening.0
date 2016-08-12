Reply-To: kernel-hardening@lists.openwall.com
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 12 Aug 2016 16:27:42 +0100
Message-Id: <1471015666-23125-4-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
References: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] [PATCH 3/7] arm64: Introduce uaccess_{disable,enable} functionality based on TTBR0_EL1
To: linux-arm-kernel@lists.infradead.org
Cc: kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

This patch adds the uaccess macros/functions to disable access to user
space by setting TTBR0_EL1 to a reserved zeroed page. Since the value
written to TTBR0_EL1 must be a physical address, for simplicity this
path introduces a reserved_ttbr0 page at a constant offset from
swapper_pg_dir. The uaccess_disable code uses the ttbr1_el1 value
adjusted by the reserved_ttbr0 offset.

Enabling access to user is done by restoring TTBR0_EL1 with the value
from saved_ttbr0_el1 per-CPU variable. Interrupts are disabled during
the uaccess_enable code to ensure the atomicity of the saved_ttbr0_el1
read and TTBR0_EL1 write.

Cc: Will Deacon <will.deacon@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/assembler.h      | 63 +++++++++++++++++++++++++++++++--
 arch/arm64/include/asm/cpufeature.h     |  6 ++++
 arch/arm64/include/asm/kernel-pgtable.h |  7 ++++
 arch/arm64/include/asm/uaccess.h        | 38 +++++++++++++++++---
 arch/arm64/kernel/cpufeature.c          |  1 +
 arch/arm64/kernel/head.S                |  6 ++--
 arch/arm64/kernel/vmlinux.lds.S         |  5 +++
 arch/arm64/mm/context.c                 | 13 +++++++
 8 files changed, 130 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 039db634a693..45545393f605 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -26,6 +26,7 @@
 #include <asm/alternative.h>
 #include <asm/asm-offsets.h>
 #include <asm/cpufeature.h>
+#include <asm/kernel-pgtable.h>
 #include <asm/page.h>
 #include <asm/pgtable-hwdef.h>
 #include <asm/ptrace.h>
@@ -42,6 +43,15 @@
 	msr	daifclr, #2
 	.endm
 
+	.macro	save_and_disable_irq, flags
+	mrs	\flags, daif
+	msr	daifset, #2
+	.endm
+
+	.macro	restore_irq, flags
+	msr	daif, \flags
+	.endm
+
 /*
  * Enable and disable debug exceptions.
  */
@@ -195,7 +205,7 @@ lr	.req	x30		// link register
 
 	/*
 	 * @sym: The name of the per-cpu variable
-	 * @reg: Result of per_cpu(sym, smp_processor_id())
+	 * @reg: Result of this_cpu_ptr(sym)
 	 * @tmp: scratch register
 	 */
 	.macro this_cpu_ptr, sym, reg, tmp
@@ -204,6 +214,17 @@ lr	.req	x30		// link register
 	add	\reg, \reg, \tmp
 	.endm
 
+	/*
+	 * @sym: The name of the per-cpu variable
+	 * @reg: Result of this_cpu_read(sym)
+	 * @tmp: scratch register
+	 */
+	.macro this_cpu_read, sym, reg, tmp
+	adr_l	\reg, \sym
+	mrs	\tmp, tpidr_el1
+	ldr	\reg, [\reg, \tmp]
+	.endm
+
 /*
  * vma_vm_mm - get mm pointer from vma pointer (vma->vm_mm)
  */
@@ -379,7 +400,28 @@ alternative_endif
 /*
  * User access enabling/disabling macros.
  */
+	.macro	uaccess_ttbr0_disable, tmp1
+	mrs	\tmp1, ttbr1_el1		// swapper_pg_dir
+	add	\tmp1, \tmp1, #SWAPPER_DIR_SIZE	// reserved_ttbr0 at the end of swapper_pg_dir
+	cpu_set_ttbr0 \tmp1			// set reserved TTBR0_EL1
+	.endm
+
+	.macro	uaccess_ttbr0_enable, tmp1, tmp2, errata = 0
+	this_cpu_read saved_ttbr0_el1 \tmp1, \tmp2
+	cpu_set_ttbr0 \tmp1, errata = \errata
+	.endm
+
 	.macro	uaccess_disable, tmp1
+#ifdef CONFIG_ARM64_TTBR0_PAN
+alternative_if_not ARM64_HAS_PAN
+	uaccess_ttbr0_disable \tmp1
+alternative_else
+	nop
+	nop
+	nop
+	nop
+alternative_endif
+#endif
 alternative_if_not ARM64_ALT_PAN_NOT_UAO
 	nop
 alternative_else
@@ -387,7 +429,24 @@ alternative_else
 alternative_endif
 	.endm
 
-	.macro	uaccess_enable, tmp1, tmp2, flags, errata = 0
+	.macro	uaccess_enable, tmp1, tmp2, tmp3
+#ifdef CONFIG_ARM64_TTBR0_PAN
+alternative_if_not ARM64_HAS_PAN
+	save_and_disable_irq \tmp3		// avoid preemption
+	uaccess_ttbr0_enable \tmp1, \tmp2
+	restore_irq \tmp3
+alternative_else
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+alternative_endif
+#endif
 alternative_if_not ARM64_ALT_PAN_NOT_UAO
 	nop
 alternative_else
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 7099f26e3702..023066d9bf7f 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -216,6 +216,12 @@ static inline bool system_supports_mixed_endian_el0(void)
 	return id_aa64mmfr0_mixed_endian_el0(read_system_reg(SYS_ID_AA64MMFR0_EL1));
 }
 
+static inline bool system_supports_ttbr0_pan(void)
+{
+	return IS_ENABLED(CONFIG_ARM64_TTBR0_PAN) &&
+		!cpus_have_cap(ARM64_HAS_PAN);
+}
+
 #endif /* __ASSEMBLY__ */
 
 #endif
diff --git a/arch/arm64/include/asm/kernel-pgtable.h b/arch/arm64/include/asm/kernel-pgtable.h
index 7e51d1b57c0c..f825ffda9c52 100644
--- a/arch/arm64/include/asm/kernel-pgtable.h
+++ b/arch/arm64/include/asm/kernel-pgtable.h
@@ -19,6 +19,7 @@
 #ifndef __ASM_KERNEL_PGTABLE_H
 #define __ASM_KERNEL_PGTABLE_H
 
+#include <asm/pgtable.h>
 #include <asm/sparsemem.h>
 
 /*
@@ -54,6 +55,12 @@
 #define SWAPPER_DIR_SIZE	(SWAPPER_PGTABLE_LEVELS * PAGE_SIZE)
 #define IDMAP_DIR_SIZE		(IDMAP_PGTABLE_LEVELS * PAGE_SIZE)
 
+#ifdef CONFIG_ARM64_TTBR0_PAN
+#define RESERVED_TTBR0_SIZE	(PAGE_SIZE)
+#else
+#define RESERVED_TTBR0_SIZE	(0)
+#endif
+
 /* Initial memory map size */
 #if ARM64_SWAPPER_USES_SECTION_MAPS
 #define SWAPPER_BLOCK_SHIFT	SECTION_SHIFT
diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index f04869630207..e0eccdfd2427 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -22,11 +22,13 @@
  * User space memory access functions
  */
 #include <linux/kasan-checks.h>
+#include <linux/percpu.h>
 #include <linux/string.h>
 #include <linux/thread_info.h>
 
 #include <asm/alternative.h>
 #include <asm/cpufeature.h>
+#include <asm/kernel-pgtable.h>
 #include <asm/ptrace.h>
 #include <asm/sysreg.h>
 #include <asm/errno.h>
@@ -114,16 +116,44 @@ static inline void set_fs(mm_segment_t fs)
 /*
  * User access enabling/disabling.
  */
+DECLARE_PER_CPU(u64, saved_ttbr0_el1);
+
+static inline void uaccess_ttbr0_disable(void)
+{
+	unsigned long ttbr;
+
+	ttbr = read_sysreg(ttbr1_el1) + SWAPPER_DIR_SIZE;
+	write_sysreg(ttbr, ttbr0_el1);
+	isb();
+}
+
+static inline void uaccess_ttbr0_enable(void)
+{
+	unsigned long ttbr, flags;
+
+	local_irq_save(flags);
+	ttbr = per_cpu(saved_ttbr0_el1, smp_processor_id());
+	write_sysreg(ttbr, ttbr0_el1);
+	isb();
+	local_irq_restore(flags);
+}
+
 #define uaccess_disable(alt)						\
 do {									\
-	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), alt,			\
-			CONFIG_ARM64_PAN));				\
+	if (system_supports_ttbr0_pan())				\
+		uaccess_ttbr0_disable();				\
+	else								\
+		asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), alt,		\
+				CONFIG_ARM64_PAN));			\
 } while (0)
 
 #define uaccess_enable(alt)						\
 do {									\
-	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(0), alt,			\
-			CONFIG_ARM64_PAN));				\
+	if (system_supports_ttbr0_pan())				\
+		uaccess_ttbr0_enable();					\
+	else								\
+		asm(ALTERNATIVE("nop", SET_PSTATE_PAN(0), alt,		\
+				CONFIG_ARM64_PAN));			\
 } while (0)
 
 /*
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 62272eac1352..fd0971afd142 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -45,6 +45,7 @@ unsigned int compat_elf_hwcap2 __read_mostly;
 #endif
 
 DECLARE_BITMAP(cpu_hwcaps, ARM64_NCAPS);
+EXPORT_SYMBOL(cpu_hwcaps);
 
 #define __ARM64_FTR_BITS(SIGNED, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL) \
 	{						\
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index b77f58355da1..57ae28e4d8de 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -320,14 +320,14 @@ __create_page_tables:
 	 * dirty cache lines being evicted.
 	 */
 	mov	x0, x25
-	add	x1, x26, #SWAPPER_DIR_SIZE
+	add	x1, x26, #SWAPPER_DIR_SIZE + RESERVED_TTBR0_SIZE
 	bl	__inval_cache_range
 
 	/*
 	 * Clear the idmap and swapper page tables.
 	 */
 	mov	x0, x25
-	add	x6, x26, #SWAPPER_DIR_SIZE
+	add	x6, x26, #SWAPPER_DIR_SIZE + RESERVED_TTBR0_SIZE
 1:	stp	xzr, xzr, [x0], #16
 	stp	xzr, xzr, [x0], #16
 	stp	xzr, xzr, [x0], #16
@@ -406,7 +406,7 @@ __create_page_tables:
 	 * tables again to remove any speculatively loaded cache lines.
 	 */
 	mov	x0, x25
-	add	x1, x26, #SWAPPER_DIR_SIZE
+	add	x1, x26, #SWAPPER_DIR_SIZE + RESERVED_TTBR0_SIZE
 	dmb	sy
 	bl	__inval_cache_range
 
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 659963d40bb4..fe393ccf9352 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -196,6 +196,11 @@ SECTIONS
 	swapper_pg_dir = .;
 	. += SWAPPER_DIR_SIZE;
 
+#ifdef CONFIG_ARM64_TTBR0_PAN
+	reserved_ttbr0 = .;
+	. += PAGE_SIZE;
+#endif
+
 	_end = .;
 
 	STABS_DEBUG
diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index efcf1f7ef1e4..f4bdee285774 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -37,6 +37,11 @@ static DEFINE_PER_CPU(atomic64_t, active_asids);
 static DEFINE_PER_CPU(u64, reserved_asids);
 static cpumask_t tlb_flush_pending;
 
+#ifdef CONFIG_ARM64_TTBR0_PAN
+DEFINE_PER_CPU(u64, saved_ttbr0_el1);
+EXPORT_PER_CPU_SYMBOL(saved_ttbr0_el1);
+#endif
+
 #define ASID_MASK		(~GENMASK(asid_bits - 1, 0))
 #define ASID_FIRST_VERSION	(1UL << asid_bits)
 #define NUM_USER_ASIDS		ASID_FIRST_VERSION
@@ -226,6 +231,8 @@ switch_mm_fastpath:
 
 static int asids_init(void)
 {
+	unsigned int cpu __maybe_unused;
+
 	asid_bits = get_cpu_asid_bits();
 	/*
 	 * Expect allocation after rollover to fail if we don't have at least
@@ -239,6 +246,12 @@ static int asids_init(void)
 		panic("Failed to allocate bitmap for %lu ASIDs\n",
 		      NUM_USER_ASIDS);
 
+#ifdef CONFIG_ARM64_TTBR0_PAN
+	/* Initialise saved_ttbr0_el1 to the reserved TTBR0 and ASID */
+	for_each_possible_cpu(cpu)
+		per_cpu(saved_ttbr0_el1, cpu) = virt_to_phys(empty_zero_page);
+#endif
+
 	pr_info("ASID allocator initialised with %lu entries\n", NUM_USER_ASIDS);
 	return 0;
 }
