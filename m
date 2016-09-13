Reply-To: kernel-hardening@lists.openwall.com
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 13 Sep 2016 18:46:33 +0100
Message-Id: <1473788797-10879-4-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1473788797-10879-1-git-send-email-catalin.marinas@arm.com>
References: <1473788797-10879-1-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] [PATCH v3 3/7] arm64: Introduce uaccess_{disable,enable} functionality based on TTBR0_EL1
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This patch adds the uaccess macros/functions to disable access to user
space by setting TTBR0_EL1 to a reserved zeroed page. Since the value
written to TTBR0_EL1 must be a physical address, for simplicity this
patch introduces a reserved_ttbr0 page at a constant offset from
swapper_pg_dir. The uaccess_disable code uses the ttbr1_el1 value
adjusted by the reserved_ttbr0 offset.

Enabling access to user is done by restoring TTBR0_EL1 with the value
from the struct thread_info ttbr0 variable. Interrupts must be disabled
during the uaccess_ttbr0_enable code to ensure the atomicity of the
thread_info.ttbr0 read and TTBR0_EL1 write. This patch also moves the
get_thread_info asm macro from entry.S to assembler.h for reuse in the
uaccess_ttbr0_* macros.

Cc: Will Deacon <will.deacon@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/assembler.h      | 16 ++++++
 arch/arm64/include/asm/cpufeature.h     |  6 +++
 arch/arm64/include/asm/kernel-pgtable.h |  7 +++
 arch/arm64/include/asm/thread_info.h    |  3 ++
 arch/arm64/include/asm/uaccess.h        | 96 ++++++++++++++++++++++++++++++---
 arch/arm64/kernel/asm-offsets.c         |  3 ++
 arch/arm64/kernel/cpufeature.c          |  1 +
 arch/arm64/kernel/entry.S               |  4 --
 arch/arm64/kernel/head.S                |  6 +--
 arch/arm64/kernel/vmlinux.lds.S         |  5 ++
 10 files changed, 134 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 0a47632787d9..581ee4ab2a34 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -41,6 +41,15 @@
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
@@ -351,6 +360,13 @@ alternative_endif
 	.endm
 
 /*
+ * Return the current thread_info.
+ */
+	.macro	get_thread_info, rd
+	mrs	\rd, sp_el0
+	.endm
+
+/*
  * Errata workaround post TTBR0_EL1 update.
  */
 	.macro	post_ttbr0_update_workaround
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 7099f26e3702..042d49c7b231 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -216,6 +216,12 @@ static inline bool system_supports_mixed_endian_el0(void)
 	return id_aa64mmfr0_mixed_endian_el0(read_system_reg(SYS_ID_AA64MMFR0_EL1));
 }
 
+static inline bool system_uses_ttbr0_pan(void)
+{
+	return IS_ENABLED(CONFIG_ARM64_SW_TTBR0_PAN) &&
+		!cpus_have_cap(ARM64_HAS_PAN);
+}
+
 #endif /* __ASSEMBLY__ */
 
 #endif
diff --git a/arch/arm64/include/asm/kernel-pgtable.h b/arch/arm64/include/asm/kernel-pgtable.h
index 7e51d1b57c0c..7803343e5881 100644
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
 
+#ifdef CONFIG_ARM64_SW_TTBR0_PAN
+#define RESERVED_TTBR0_SIZE	(PAGE_SIZE)
+#else
+#define RESERVED_TTBR0_SIZE	(0)
+#endif
+
 /* Initial memory map size */
 #if ARM64_SWAPPER_USES_SECTION_MAPS
 #define SWAPPER_BLOCK_SHIFT	SECTION_SHIFT
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index abd64bd1f6d9..b3325a9cb90f 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -47,6 +47,9 @@ typedef unsigned long mm_segment_t;
 struct thread_info {
 	unsigned long		flags;		/* low level flags */
 	mm_segment_t		addr_limit;	/* address limit */
+#ifdef CONFIG_ARM64_SW_TTBR0_PAN
+	u64			ttbr0;		/* saved TTBR0_EL1 */
+#endif
 	struct task_struct	*task;		/* main task structure */
 	int			preempt_count;	/* 0 => preemptable, <0 => bug */
 	int			cpu;		/* cpu */
diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index cc6c32d4dcc4..115b5fa8dc3f 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -29,6 +29,7 @@
 
 #include <asm/alternative.h>
 #include <asm/cpufeature.h>
+#include <asm/kernel-pgtable.h>
 #include <asm/ptrace.h>
 #include <asm/sysreg.h>
 #include <asm/errno.h>
@@ -116,16 +117,57 @@ static inline void set_fs(mm_segment_t fs)
 /*
  * User access enabling/disabling.
  */
+#ifdef CONFIG_ARM64_SW_TTBR0_PAN
+static inline void uaccess_ttbr0_disable(void)
+{
+	unsigned long ttbr;
+
+	/* reserved_ttbr0 placed at the end of swapper_pg_dir */
+	ttbr = read_sysreg(ttbr1_el1) + SWAPPER_DIR_SIZE;
+	write_sysreg(ttbr, ttbr0_el1);
+	isb();
+}
+
+static inline void uaccess_ttbr0_enable(void)
+{
+	unsigned long flags;
+
+	/*
+	 * Disable interrupts to avoid preemption between reading the 'ttbr0'
+	 * variable and the MSR. A context switch could trigger an ASID
+	 * roll-over and an update of 'ttbr0'.
+	 */
+	local_irq_save(flags);
+	write_sysreg(current_thread_info()->ttbr0, ttbr0_el1);
+	isb();
+	local_irq_restore(flags);
+}
+#else
+static inline void uaccess_ttbr0_disable(void)
+{
+}
+
+static inline void uaccess_ttbr0_enable(void)
+{
+}
+#endif
+
 #define __uaccess_disable(alt)						\
 do {									\
-	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), alt,			\
-			CONFIG_ARM64_PAN));				\
+	if (system_uses_ttbr0_pan())					\
+		uaccess_ttbr0_disable();				\
+	else								\
+		asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), alt,		\
+				CONFIG_ARM64_PAN));			\
 } while (0)
 
 #define __uaccess_enable(alt)						\
 do {									\
-	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(0), alt,			\
-			CONFIG_ARM64_PAN));				\
+	if (system_uses_ttbr0_pan())					\
+		uaccess_ttbr0_enable();					\
+	else								\
+		asm(ALTERNATIVE("nop", SET_PSTATE_PAN(0), alt,		\
+				CONFIG_ARM64_PAN));			\
 } while (0)
 
 static inline void uaccess_disable(void)
@@ -361,12 +403,39 @@ extern __must_check long strnlen_user(const char __user *str, long n);
 
 #include <asm/alternative.h>
 #include <asm/assembler.h>
+#include <asm/kernel-pgtable.h>
+
+/*
+ * User access enabling/disabling macros.
+ */
+	.macro	uaccess_ttbr0_disable, tmp1
+	mrs	\tmp1, ttbr1_el1		// swapper_pg_dir
+	add	\tmp1, \tmp1, #SWAPPER_DIR_SIZE	// reserved_ttbr0 at the end of swapper_pg_dir
+	msr	ttbr0_el1, \tmp1		// set reserved TTBR0_EL1
+	isb
+	.endm
+
+	.macro	uaccess_ttbr0_enable, tmp1
+	get_thread_info \tmp1
+	ldr	\tmp1, [\tmp1, #TI_TTBR0]	// load saved TTBR0_EL1
+	msr	ttbr0_el1, \tmp1		// set the non-PAN TTBR0_EL1
+	isb
+	.endm
 
 /*
- * User access enabling/disabling macros. These are no-ops when UAO is
- * present.
+ * These macros are no-ops when UAO is present.
  */
 	.macro	uaccess_disable_not_uao, tmp1
+#ifdef CONFIG_ARM64_SW_TTBR0_PAN
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
@@ -375,6 +444,21 @@ alternative_endif
 	.endm
 
 	.macro	uaccess_enable_not_uao, tmp1, tmp2
+#ifdef CONFIG_ARM64_SW_TTBR0_PAN
+alternative_if_not ARM64_HAS_PAN
+	save_and_disable_irq \tmp2		// avoid preemption
+	uaccess_ttbr0_enable \tmp1
+	restore_irq \tmp2
+alternative_else
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
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 05070b72fc28..82f85af070f8 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -38,6 +38,9 @@ int main(void)
   DEFINE(TI_FLAGS,		offsetof(struct thread_info, flags));
   DEFINE(TI_PREEMPT,		offsetof(struct thread_info, preempt_count));
   DEFINE(TI_ADDR_LIMIT,		offsetof(struct thread_info, addr_limit));
+#ifdef CONFIG_ARM64_SW_TTBR0_PAN
+  DEFINE(TI_TTBR0,		offsetof(struct thread_info, ttbr0));
+#endif
   DEFINE(TI_TASK,		offsetof(struct thread_info, task));
   DEFINE(TI_CPU,		offsetof(struct thread_info, cpu));
   BLANK();
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
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 441420ca7d08..be1e3987c07a 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -190,10 +190,6 @@ alternative_endif
 	eret					// return to kernel
 	.endm
 
-	.macro	get_thread_info, rd
-	mrs	\rd, sp_el0
-	.endm
-
 	.macro	irq_stack_entry
 	mov	x19, sp			// preserve the original sp
 
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 3e7b050e99dc..d4188396302f 100644
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
index 659963d40bb4..8c612d30ff3c 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -196,6 +196,11 @@ SECTIONS
 	swapper_pg_dir = .;
 	. += SWAPPER_DIR_SIZE;
 
+#ifdef CONFIG_ARM64_SW_TTBR0_PAN
+	reserved_ttbr0 = .;
+	. += RESERVED_TTBR0_SIZE;
+#endif
+
 	_end = .;
 
 	STABS_DEBUG
