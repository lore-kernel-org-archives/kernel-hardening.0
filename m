Reply-To: kernel-hardening@lists.openwall.com
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri,  2 Sep 2016 16:02:10 +0100
Message-Id: <1472828533-28197-5-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1472828533-28197-1-git-send-email-catalin.marinas@arm.com>
References: <1472828533-28197-1-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] [PATCH v2 4/7] arm64: Disable TTBR0_EL1 during normal kernel execution
To: linux-arm-kernel@lists.infradead.org
Cc: kernel-hardening@lists.openwall.com, AKASHI Takahiro <takahiro.akashi@linaro.org>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>
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
 arch/arm64/include/asm/mmu_context.h | 32 +++++++++++++----
 arch/arm64/include/asm/ptrace.h      |  2 ++
 arch/arm64/kernel/entry.S            | 67 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/setup.c            |  8 +++++
 arch/arm64/mm/context.c              |  7 +++-
 6 files changed, 122 insertions(+), 8 deletions(-)

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
index b1892a0dbcb0..cab90250daae 100644
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
 
@@ -180,14 +181,11 @@ enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
  * actually changed.
  */
 static inline void
-switch_mm(struct mm_struct *prev, struct mm_struct *next,
-	  struct task_struct *tsk)
+__switch_mm(struct mm_struct *prev, struct mm_struct *next,
+	    struct task_struct *tsk)
 {
 	unsigned int cpu = smp_processor_id();
 
-	if (prev == next)
-		return;
-
 	/*
 	 * init_mm.pgd does not contain any user mappings and it is always
 	 * active for kernel addresses in TTBR1. Just set the reserved TTBR0.
@@ -200,8 +198,28 @@ switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	check_and_switch_context(next, cpu);
 }
 
+static inline void
+switch_mm(struct mm_struct *prev, struct mm_struct *next,
+	  struct task_struct *tsk)
+{
+	if (prev != next)
+		__switch_mm(prev, next, tsk);
+
+#ifdef CONFIG_ARM64_TTBR0_PAN
+	/*
+	 * Update the saved TTBR0_EL1 of the scheduled-in task as the previous
+	 * value may have not been initialised yet (activate_mm caller) or the
+	 * ASID has changed since the last run (following the context switch
+	 * of another thread of the same process).
+	 */
+	if (tsk && system_supports_ttbr0_pan())
+		task_thread_info(tsk)->ttbr0 =
+			virt_to_phys(next->pgd) | ASID(next) << 48;
+#endif
+}
+
 #define deactivate_mm(tsk,mm)	do { } while (0)
-#define activate_mm(prev,next)	switch_mm(prev, next, NULL)
+#define activate_mm(prev,next)	switch_mm(prev, next, current)
 
 void verify_cpu_asid_bits(void);
 
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index ada08b5b036d..458773ac5ec9 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -21,6 +21,8 @@
 
 #include <uapi/asm/ptrace.h>
 
+#define _PSR_PAN_BIT		22
+
 /* Current Exception Level values, as contained in CurrentEL */
 #define CurrentEL_EL1		(1 << 2)
 #define CurrentEL_EL2		(2 << 2)
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index be1e3987c07a..e87cfeda5da5 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -29,7 +29,9 @@
 #include <asm/esr.h>
 #include <asm/irq.h>
 #include <asm/memory.h>
+#include <asm/ptrace.h>
 #include <asm/thread_info.h>
+#include <asm/uaccess.h>
 #include <asm/unistd.h>
 
 /*
@@ -109,6 +111,34 @@
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
+	mrs	x21, ttbr0_el1
+	tst	x21, #0xffff << 48		// Check for the reserved ASID
+	orr	x23, x23, #PSR_PAN_BIT		// Set the emulated PAN in the saved SPSR
+	b.eq	1f				// TTBR0 access already disabled
+	and	x23, x23, #~PSR_PAN_BIT		// Clear the emulated PAN in the saved SPSR
+	.endif
+
+	uaccess_ttbr0_disable x21
+1:
+#endif
+
 	stp	x22, x23, [sp, #S_PC]
 
 	/*
@@ -147,6 +177,42 @@
 	ldp	x21, x22, [sp, #S_PC]		// load ELR, SPSR
 	.if	\el == 0
 	ct_user_enter
+	.endif
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
+	tbnz	x22, #_PSR_PAN_BIT, 1f		// Skip re-enabling TTBR0 access if previously disabled
+	.endif
+
+	uaccess_ttbr0_enable x0
+
+	.if	\el == 0
+	/*
+	 * Enable errata workarounds only if returning to user. The only
+	 * workaround currently required for TTBR0_EL1 changes are for the
+	 * Cavium erratum 27456 (broadcast TLBI instructions may cause I-cache
+	 * corruption).
+	 */
+	post_ttbr0_update_workaround
+	.endif
+1:
+	.if	\el != 0
+	and	x22, x22, #~PSR_PAN_BIT		// ARMv8.0 CPUs do not understand this bit
+	.endif
+2:
+#endif
+
+	.if	\el == 0
 	ldr	x23, [sp, #S_SP]		// load return stack pointer
 	msr	sp_el0, x23
 #ifdef CONFIG_ARM64_ERRATUM_845719
@@ -168,6 +234,7 @@ alternative_else
 alternative_endif
 #endif
 	.endif
+
 	msr	elr_el1, x21			// set up the return data
 	msr	spsr_el1, x22
 	ldp	x0, x1, [sp, #16 * 0]
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 536dce22fe76..4a4aaa47f869 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -228,6 +228,14 @@ void __init setup_arch(char **cmdline_p)
 {
 	pr_info("Boot CPU: AArch64 Processor [%08x]\n", read_cpuid_id());
 
+#ifdef CONFIG_ARM64_TTBR0_PAN
+	/*
+	 * uaccess_enable() may be called on the init thread, so make sure
+	 * the saved TTBR0_EL1 always generates translation faults.
+	 */
+	init_thread_info.ttbr0 = virt_to_phys(empty_zero_page);
+#endif
+
 	sprintf(init_utsname()->machine, ELF_PLATFORM);
 	init_mm.start_code = (unsigned long) _text;
 	init_mm.end_code   = (unsigned long) _etext;
diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index efcf1f7ef1e4..d120a7911d22 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -221,7 +221,12 @@ void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
 	raw_spin_unlock_irqrestore(&cpu_asid_lock, flags);
 
 switch_mm_fastpath:
-	cpu_switch_mm(mm->pgd, mm);
+	/*
+	 * Defer TTBR0_EL1 setting for user threads to uaccess_enable() when
+	 * emulating PAN.
+	 */
+	if (!system_supports_ttbr0_pan())
+		cpu_switch_mm(mm->pgd, mm);
 }
 
 static int asids_init(void)
