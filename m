Reply-To: kernel-hardening@lists.openwall.com
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 12 Aug 2016 16:27:43 +0100
Message-Id: <1471015666-23125-5-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
References: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] [PATCH 4/7] arm64: Disable TTBR0_EL1 during normal kernel execution
To: linux-arm-kernel@lists.infradead.org
Cc: kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

When the TTBR0 PAN feature is enabled, the kernel entry points need to
disable access to TTBR0_EL1. The PAN status of the interrupted context
is stored as part of the saved pstate, reusing the PSR_PAN_BIT (22).
Restoring access to TTBR0_PAN is done on exception return if returning
to user or returning to a context where PAN was disabled.

Context switching via switch_mm() must defer the update of TTBR0_EL1
until a return to user or an explicit uaccess_enable() call.

Special care needs to be taken for two cases where TTBR0_EL1 is set
outside the normal kernel context switch operation: EFI run-time
services (via efi_set_pgd) and CPU suspend (via cpu_(un)install_idmap).
Code has been added to avoid deferred TTBR0_EL1 switching as in
switch_mm() and restore the reserved TTBR0_EL1 when uninstalling the
special TTBR0_EL1.

Cc: Will Deacon <will.deacon@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/efi.h         | 14 ++++++++
 arch/arm64/include/asm/mmu_context.h |  3 +-
 arch/arm64/include/uapi/asm/ptrace.h |  2 ++
 arch/arm64/kernel/entry.S            | 62 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/suspend.c          | 12 +++----
 arch/arm64/mm/context.c              | 12 ++++++-
 6 files changed, 97 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index a9e54aad15ef..1d7810b88255 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_EFI_H
 #define _ASM_EFI_H
 
+#include <asm/cpufeature.h>
 #include <asm/io.h>
 #include <asm/mmu_context.h>
 #include <asm/neon.h>
@@ -76,6 +77,19 @@ static inline void efifb_setup_from_dmi(struct screen_info *si, const char *opt)
 static inline void efi_set_pgd(struct mm_struct *mm)
 {
 	switch_mm(NULL, mm, NULL);
+
+	/*
+	 * Force TTBR0_EL1 setting. If restoring the active_mm pgd, defer the
+	 * switching after uaccess_enable(). This code is calling
+	 * cpu_switch_mm() directly (instead of uaccess_enable()) to force
+	 * potential errata workarounds.
+	 */
+	if (system_supports_ttbr0_pan()) {
+		if (mm != current->active_mm)
+			cpu_switch_mm(mm->pgd, mm);
+		else
+			cpu_set_reserved_ttbr0();
+	}
 }
 
 void efi_virtmap_load(void);
diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index b1892a0dbcb0..7762125657bf 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -23,6 +23,7 @@
 #include <linux/sched.h>
 
 #include <asm/cacheflush.h>
+#include <asm/cpufeature.h>
 #include <asm/proc-fns.h>
 #include <asm-generic/mm_hooks.h>
 #include <asm/cputype.h>
@@ -113,7 +114,7 @@ static inline void cpu_uninstall_idmap(void)
 	local_flush_tlb_all();
 	cpu_set_default_tcr_t0sz();
 
-	if (mm != &init_mm)
+	if (mm != &init_mm && !system_supports_ttbr0_pan())
 		cpu_switch_mm(mm->pgd, mm);
 }
 
diff --git a/arch/arm64/include/uapi/asm/ptrace.h b/arch/arm64/include/uapi/asm/ptrace.h
index b5c3933ed441..9283e6b247f9 100644
--- a/arch/arm64/include/uapi/asm/ptrace.h
+++ b/arch/arm64/include/uapi/asm/ptrace.h
@@ -52,6 +52,8 @@
 #define PSR_Z_BIT	0x40000000
 #define PSR_N_BIT	0x80000000
 
+#define _PSR_PAN_BIT	22
+
 /*
  * Groups of PSR bits
  */
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 96e4a2b64cc1..b77034f0ffab 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -29,6 +29,7 @@
 #include <asm/esr.h>
 #include <asm/irq.h>
 #include <asm/memory.h>
+#include <asm/ptrace.h>
 #include <asm/thread_info.h>
 #include <asm/unistd.h>
 
@@ -109,6 +110,37 @@
 	mrs	x22, elr_el1
 	mrs	x23, spsr_el1
 	stp	lr, x21, [sp, #S_LR]
+
+#ifdef CONFIG_ARM64_TTBR0_PAN
+	/*
+	 * Set the TTBR0 PAN in SPSR. When the exception is taken from EL0,
+	 * there is no need to check the state of TTBR0_EL1 since accesses are
+	 * always enabled.
+	 * Note that the meaning of this bit differs from the ARMv8.1 PAN
+	 * feature as all TTBR0_EL1 accesses are disabled, not just those to
+	 * user mappings.
+	 */
+alternative_if_not ARM64_HAS_PAN
+	nop
+alternative_else
+	b	1f				// skip TTBR0 PAN
+alternative_endif
+
+	.if	\el != 0
+	mrs	lr, ttbr0_el1
+	tst	lr, #0xffff << 48		// Check for the reserved ASID
+	orr	x23, x23, #PSR_PAN_BIT
+	b.eq	1f				// TTBR0 access already disabled
+	.endif
+
+	uaccess_ttbr0_disable x21
+
+	.if	\el != 0
+	and	x23, x23, #~PSR_PAN_BIT		// TTBR0 access previously enabled
+	.endif
+1:
+#endif
+
 	stp	x22, x23, [sp, #S_PC]
 
 	/*
@@ -168,6 +200,36 @@ alternative_else
 alternative_endif
 #endif
 	.endif
+
+#ifdef CONFIG_ARM64_TTBR0_PAN
+	/*
+	 * Restore access to TTBR0_EL1. If returning to EL0, no need for SPSR
+	 * PAN bit checking.
+	 */
+alternative_if_not ARM64_HAS_PAN
+	nop
+alternative_else
+	b	2f				// skip TTBR0 PAN
+alternative_endif
+
+	.if	\el != 0
+	tbnz	x22, #_PSR_PAN_BIT, 1f		// Only re-enable TTBR0 access if SPSR.PAN == 0
+	.endif
+
+	/*
+	 * Enable errata workarounds only if returning to user. The only
+	 * workaround currently required for TTBR0_EL1 changes are for the
+	 * Cavium erratum 27456 (broadcast TLBI instructions may cause I-cache
+	 * corruption).
+	 */
+	uaccess_ttbr0_enable x0, x1, errata = \el == 0
+
+	.if	\el != 0
+1:	and	x22, x22, #~PSR_PAN_BIT		// ARMv8.0 CPUs do not understand this bit
+	.endif
+2:
+#endif
+
 	msr	elr_el1, x21			// set up the return data
 	msr	spsr_el1, x22
 	ldp	x0, x1, [sp, #16 * 0]
diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
index b616e365cee3..e10993bcaf13 100644
--- a/arch/arm64/kernel/suspend.c
+++ b/arch/arm64/kernel/suspend.c
@@ -35,6 +35,12 @@ void __init cpu_suspend_set_dbg_restorer(void (*hw_bp_restore)(void *))
 void notrace __cpu_suspend_exit(void)
 {
 	/*
+	 * Restore per-cpu offset before any kernel
+	 * subsystem relying on it has a chance to run.
+	 */
+	set_my_cpu_offset(per_cpu_offset(smp_processor_id()));
+
+	/*
 	 * We are resuming from reset with the idmap active in TTBR0_EL1.
 	 * We must uninstall the idmap and restore the expected MMU
 	 * state before we can possibly return to userspace.
@@ -42,12 +48,6 @@ void notrace __cpu_suspend_exit(void)
 	cpu_uninstall_idmap();
 
 	/*
-	 * Restore per-cpu offset before any kernel
-	 * subsystem relying on it has a chance to run.
-	 */
-	set_my_cpu_offset(per_cpu_offset(smp_processor_id()));
-
-	/*
 	 * Restore HW breakpoint registers to sane values
 	 * before debug exceptions are possibly reenabled
 	 * through local_dbg_restore.
diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index f4bdee285774..f7406bd5eb7c 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -226,7 +226,17 @@ void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
 	raw_spin_unlock_irqrestore(&cpu_asid_lock, flags);
 
 switch_mm_fastpath:
-	cpu_switch_mm(mm->pgd, mm);
+#ifdef CONFIG_ARM64_TTBR0_PAN
+	/*
+	 * Defer TTBR0_EL1 setting for user tasks to uaccess_enable() when
+	 * emulating PAN.
+	 */
+	if (system_supports_ttbr0_pan())
+		__this_cpu_write(saved_ttbr0_el1,
+				 virt_to_phys(mm->pgd) | asid << 48);
+	else
+#endif
+		cpu_switch_mm(mm->pgd, mm);
 }
 
 static int asids_init(void)
