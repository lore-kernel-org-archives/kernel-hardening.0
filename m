From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC/PoC PATCH 1/3] arm64: use wrapper macro for bl/blx instructions from asm code
Date: Thu,  2 Aug 2018 15:21:30 +0200
Message-Id: <20180802132133.23999-2-ard.biesheuvel@linaro.org>
In-Reply-To: <20180802132133.23999-1-ard.biesheuvel@linaro.org>
References: <20180802132133.23999-1-ard.biesheuvel@linaro.org>
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, christoffer.dall@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, labbott@fedoraproject.org, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

In preparation of enabling a feature that temporarily clears the
sign bit in the stack pointer register across a subroutine return,
switch to bl_c/blr_c macros for making such calls from assembler
source. They will be updated in a subsequent patch to conditionally
incorporate the restore sequence for the stack pointer register.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/assembler.h            | 12 ++-
 arch/arm64/kernel/entry-ftrace.S              |  6 +-
 arch/arm64/kernel/entry.S                     | 86 ++++++++++----------
 arch/arm64/kernel/head.S                      |  4 +-
 arch/arm64/kernel/probes/kprobes_trampoline.S |  2 +-
 arch/arm64/kernel/sleep.S                     |  6 +-
 6 files changed, 62 insertions(+), 54 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 0bcc98dbba56..346ada4de48a 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -687,8 +687,8 @@ USER(\label, ic	ivau, \tmp2)			// invalidate I line PoU
 	.endm
 
 	.macro		do_cond_yield_neon
-	bl		kernel_neon_end
-	bl		kernel_neon_begin
+	bl_c		kernel_neon_end
+	bl_c		kernel_neon_begin
 	.endm
 
 	.macro		endif_yield_neon, lbl
@@ -701,4 +701,12 @@ USER(\label, ic	ivau, \tmp2)			// invalidate I line PoU
 .Lyield_out_\@ :
 	.endm
 
+	.macro		bl_c, target
+	bl		\target
+	.endm
+
+	.macro		blr_c, reg
+	blr		\reg
+	.endm
+
 #endif	/* __ASM_ASSEMBLER_H */
diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
index 1175f5827ae1..4691eef0dc65 100644
--- a/arch/arm64/kernel/entry-ftrace.S
+++ b/arch/arm64/kernel/entry-ftrace.S
@@ -106,7 +106,7 @@ ENTRY(_mcount)
 
 	mcount_get_pc	x0		//       function's pc
 	mcount_get_lr	x1		//       function's lr (= parent's pc)
-	blr	x2			//   (*ftrace_trace_function)(pc, lr);
+	blr_c	x2			//   (*ftrace_trace_function)(pc, lr);
 
 skip_ftrace_call:			// }
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -200,7 +200,7 @@ ENTRY(ftrace_graph_caller)
 	mcount_get_lr_addr	  x0	//     pointer to function's saved lr
 	mcount_get_pc		  x1	//     function's pc
 	mcount_get_parent_fp	  x2	//     parent's fp
-	bl	prepare_ftrace_return	// prepare_ftrace_return(&lr, pc, fp)
+	bl_c	prepare_ftrace_return	// prepare_ftrace_return(&lr, pc, fp)
 
 	mcount_exit
 ENDPROC(ftrace_graph_caller)
@@ -215,7 +215,7 @@ ENDPROC(ftrace_graph_caller)
 ENTRY(return_to_handler)
 	save_return_regs
 	mov	x0, x29			//     parent's fp
-	bl	ftrace_return_to_handler// addr = ftrace_return_to_hander(fp);
+	bl_c	ftrace_return_to_handler// addr = ftrace_return_to_hander(fp);
 	mov	x30, x0			// restore the original return address
 	restore_return_regs
 	ret
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 28ad8799406f..eba5b6b528ea 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -43,7 +43,7 @@
  */
 	.macro ct_user_exit, syscall = 0
 #ifdef CONFIG_CONTEXT_TRACKING
-	bl	context_tracking_user_exit
+	bl_c	context_tracking_user_exit
 	.if \syscall == 1
 	/*
 	 * Save/restore needed during syscalls.  Restore syscall arguments from
@@ -59,7 +59,7 @@
 
 	.macro ct_user_enter
 #ifdef CONFIG_CONTEXT_TRACKING
-	bl	context_tracking_user_enter
+	bl_c	context_tracking_user_enter
 #endif
 	.endm
 
@@ -305,7 +305,7 @@ alternative_else_nop_endif
 	 * Cavium erratum 27456 (broadcast TLBI instructions may cause I-cache
 	 * corruption).
 	 */
-	bl	post_ttbr_update_workaround
+	bl_c	post_ttbr_update_workaround
 	.endif
 1:
 	.if	\el != 0
@@ -425,7 +425,7 @@ tsk	.req	x28		// current thread_info
 	ldr_l	x1, handle_arch_irq
 	mov	x0, sp
 	irq_stack_entry
-	blr	x1
+	blr_c	x1
 	irq_stack_exit
 	.endm
 
@@ -490,7 +490,7 @@ __bad_stack:
 	mov	x0, sp
 
 	/* Time to die */
-	bl	handle_bad_stack
+	bl_c	handle_bad_stack
 	ASM_BUG()
 #endif /* CONFIG_VMAP_STACK */
 
@@ -502,7 +502,7 @@ __bad_stack:
 	mov	x0, sp
 	mov	x1, #\reason
 	mrs	x2, esr_el1
-	bl	bad_mode
+	bl_c	bad_mode
 	ASM_BUG()
 	.endm
 
@@ -580,7 +580,7 @@ el1_da:
 	inherit_daif	pstate=x23, tmp=x2
 	clear_address_tag x0, x3
 	mov	x2, sp				// struct pt_regs
-	bl	do_mem_abort
+	bl_c	do_mem_abort
 
 	kernel_exit 1
 el1_sp_pc:
@@ -590,7 +590,7 @@ el1_sp_pc:
 	mrs	x0, far_el1
 	inherit_daif	pstate=x23, tmp=x2
 	mov	x2, sp
-	bl	do_sp_pc_abort
+	bl_c	do_sp_pc_abort
 	ASM_BUG()
 el1_undef:
 	/*
@@ -598,7 +598,7 @@ el1_undef:
 	 */
 	inherit_daif	pstate=x23, tmp=x2
 	mov	x0, sp
-	bl	do_undefinstr
+	bl_c	do_undefinstr
 	ASM_BUG()
 el1_dbg:
 	/*
@@ -609,7 +609,7 @@ el1_dbg:
 	tbz	x24, #0, el1_inv		// EL1 only
 	mrs	x0, far_el1
 	mov	x2, sp				// struct pt_regs
-	bl	do_debug_exception
+	bl_c	do_debug_exception
 	kernel_exit 1
 el1_inv:
 	// TODO: add support for undefined instructions in kernel mode
@@ -617,7 +617,7 @@ el1_inv:
 	mov	x0, sp
 	mov	x2, x1
 	mov	x1, #BAD_SYNC
-	bl	bad_mode
+	bl_c	bad_mode
 	ASM_BUG()
 ENDPROC(el1_sync)
 
@@ -626,7 +626,7 @@ el1_irq:
 	kernel_entry 1
 	enable_da_f
 #ifdef CONFIG_TRACE_IRQFLAGS
-	bl	trace_hardirqs_off
+	bl_c	trace_hardirqs_off
 #endif
 
 	irq_handler
@@ -636,11 +636,11 @@ el1_irq:
 	cbnz	w24, 1f				// preempt count != 0
 	ldr	x0, [tsk, #TSK_TI_FLAGS]	// get flags
 	tbz	x0, #TIF_NEED_RESCHED, 1f	// needs rescheduling?
-	bl	el1_preempt
+	bl_c	el1_preempt
 1:
 #endif
 #ifdef CONFIG_TRACE_IRQFLAGS
-	bl	trace_hardirqs_on
+	bl_c	trace_hardirqs_on
 #endif
 	kernel_exit 1
 ENDPROC(el1_irq)
@@ -648,7 +648,7 @@ ENDPROC(el1_irq)
 #ifdef CONFIG_PREEMPT
 el1_preempt:
 	mov	x24, lr
-1:	bl	preempt_schedule_irq		// irq en/disable is done inside
+1:	bl_c	preempt_schedule_irq		// irq en/disable is done inside
 	ldr	x0, [tsk, #TSK_TI_FLAGS]	// get new tasks TI_FLAGS
 	tbnz	x0, #TIF_NEED_RESCHED, 1b	// needs rescheduling?
 	ret	x24
@@ -749,7 +749,7 @@ el0_da:
 	clear_address_tag x0, x26
 	mov	x1, x25
 	mov	x2, sp
-	bl	do_mem_abort
+	bl_c	do_mem_abort
 	b	ret_to_user
 el0_ia:
 	/*
@@ -758,13 +758,13 @@ el0_ia:
 	mrs	x26, far_el1
 	enable_da_f
 #ifdef CONFIG_TRACE_IRQFLAGS
-	bl	trace_hardirqs_off
+	bl_c	trace_hardirqs_off
 #endif
 	ct_user_exit
 	mov	x0, x26
 	mov	x1, x25
 	mov	x2, sp
-	bl	do_el0_ia_bp_hardening
+	bl_c	do_el0_ia_bp_hardening
 	b	ret_to_user
 el0_fpsimd_acc:
 	/*
@@ -774,7 +774,7 @@ el0_fpsimd_acc:
 	ct_user_exit
 	mov	x0, x25
 	mov	x1, sp
-	bl	do_fpsimd_acc
+	bl_c	do_fpsimd_acc
 	b	ret_to_user
 el0_sve_acc:
 	/*
@@ -784,7 +784,7 @@ el0_sve_acc:
 	ct_user_exit
 	mov	x0, x25
 	mov	x1, sp
-	bl	do_sve_acc
+	bl_c	do_sve_acc
 	b	ret_to_user
 el0_fpsimd_exc:
 	/*
@@ -794,7 +794,7 @@ el0_fpsimd_exc:
 	ct_user_exit
 	mov	x0, x25
 	mov	x1, sp
-	bl	do_fpsimd_exc
+	bl_c	do_fpsimd_exc
 	b	ret_to_user
 el0_sp_pc:
 	/*
@@ -803,13 +803,13 @@ el0_sp_pc:
 	mrs	x26, far_el1
 	enable_da_f
 #ifdef CONFIG_TRACE_IRQFLAGS
-	bl	trace_hardirqs_off
+	bl_c	trace_hardirqs_off
 #endif
 	ct_user_exit
 	mov	x0, x26
 	mov	x1, x25
 	mov	x2, sp
-	bl	do_sp_pc_abort
+	bl_c	do_sp_pc_abort
 	b	ret_to_user
 el0_undef:
 	/*
@@ -818,7 +818,7 @@ el0_undef:
 	enable_daif
 	ct_user_exit
 	mov	x0, sp
-	bl	do_undefinstr
+	bl_c	do_undefinstr
 	b	ret_to_user
 el0_sys:
 	/*
@@ -828,7 +828,7 @@ el0_sys:
 	ct_user_exit
 	mov	x0, x25
 	mov	x1, sp
-	bl	do_sysinstr
+	bl_c	do_sysinstr
 	b	ret_to_user
 el0_dbg:
 	/*
@@ -838,7 +838,7 @@ el0_dbg:
 	mrs	x0, far_el1
 	mov	x1, x25
 	mov	x2, sp
-	bl	do_debug_exception
+	bl_c	do_debug_exception
 	enable_daif
 	ct_user_exit
 	b	ret_to_user
@@ -848,7 +848,7 @@ el0_inv:
 	mov	x0, sp
 	mov	x1, #BAD_SYNC
 	mov	x2, x25
-	bl	bad_el0_sync
+	bl_c	bad_el0_sync
 	b	ret_to_user
 ENDPROC(el0_sync)
 
@@ -858,19 +858,19 @@ el0_irq:
 el0_irq_naked:
 	enable_da_f
 #ifdef CONFIG_TRACE_IRQFLAGS
-	bl	trace_hardirqs_off
+	bl_c	trace_hardirqs_off
 #endif
 
 	ct_user_exit
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 	tbz	x22, #55, 1f
-	bl	do_el0_irq_bp_hardening
+	bl_c	do_el0_irq_bp_hardening
 1:
 #endif
 	irq_handler
 
 #ifdef CONFIG_TRACE_IRQFLAGS
-	bl	trace_hardirqs_on
+	bl_c	trace_hardirqs_on
 #endif
 	b	ret_to_user
 ENDPROC(el0_irq)
@@ -880,7 +880,7 @@ el1_error:
 	mrs	x1, esr_el1
 	enable_dbg
 	mov	x0, sp
-	bl	do_serror
+	bl_c	do_serror
 	kernel_exit 1
 ENDPROC(el1_error)
 
@@ -890,7 +890,7 @@ el0_error_naked:
 	mrs	x1, esr_el1
 	enable_dbg
 	mov	x0, sp
-	bl	do_serror
+	bl_c	do_serror
 	enable_daif
 	ct_user_exit
 	b	ret_to_user
@@ -920,9 +920,9 @@ ret_fast_syscall_trace:
  */
 work_pending:
 	mov	x0, sp				// 'regs'
-	bl	do_notify_resume
+	bl_c	do_notify_resume
 #ifdef CONFIG_TRACE_IRQFLAGS
-	bl	trace_hardirqs_on		// enabled while in userspace
+	bl_c	trace_hardirqs_on		// enabled while in userspace
 #endif
 	ldr	x1, [tsk, #TSK_TI_FLAGS]	// re-check for single-step
 	b	finish_ret_to_user
@@ -980,11 +980,11 @@ el0_svc_naked:					// compat entry point
 	b.hs	ni_sys
 	mask_nospec64 xscno, xsc_nr, x19	// enforce bounds for syscall number
 	ldr	x16, [stbl, xscno, lsl #3]	// address in the syscall table
-	blr	x16				// call sys_* routine
+	blr_c	x16				// call sys_* routine
 	b	ret_fast_syscall
 ni_sys:
 	mov	x0, sp
-	bl	do_ni_syscall
+	bl_c	do_ni_syscall
 	b	ret_fast_syscall
 ENDPROC(el0_svc)
 
@@ -998,7 +998,7 @@ __sys_trace:
 	mov	x0, #-ENOSYS			// set default errno if so
 	str	x0, [sp, #S_X0]
 1:	mov	x0, sp
-	bl	syscall_trace_enter
+	bl_c	syscall_trace_enter
 	cmp	w0, #NO_SYSCALL			// skip the syscall?
 	b.eq	__sys_trace_return_skipped
 	mov	wscno, w0			// syscall number (possibly new)
@@ -1010,18 +1010,18 @@ __sys_trace:
 	ldp	x4, x5, [sp, #S_X4]
 	ldp	x6, x7, [sp, #S_X6]
 	ldr	x16, [stbl, xscno, lsl #3]	// address in the syscall table
-	blr	x16				// call sys_* routine
+	blr_c	x16				// call sys_* routine
 
 __sys_trace_return:
 	str	x0, [sp, #S_X0]			// save returned x0
 __sys_trace_return_skipped:
 	mov	x0, sp
-	bl	syscall_trace_exit
+	bl_c	syscall_trace_exit
 	b	ret_to_user
 
 __ni_sys_trace:
 	mov	x0, sp
-	bl	do_ni_syscall
+	bl_c	do_ni_syscall
 	b	__sys_trace_return
 
 	.popsection				// .entry.text
@@ -1182,10 +1182,10 @@ NOKPROBE(cpu_switch_to)
  * This is how we return from a fork.
  */
 ENTRY(ret_from_fork)
-	bl	schedule_tail
+	bl_c	schedule_tail
 	cbz	x19, 1f				// not a kernel thread
 	mov	x0, x20
-	blr	x19
+	blr_c	x19
 1:	get_thread_info tsk
 	b	ret_to_user
 ENDPROC(ret_from_fork)
@@ -1337,7 +1337,7 @@ ENTRY(__sdei_asm_handler)
 
 	add	x0, x19, #SDEI_EVENT_INTREGS
 	mov	x1, x19
-	bl	__sdei_handler
+	bl_c	__sdei_handler
 
 	msr	sp_el0, x28
 	/* restore regs >x17 that we clobbered */
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index b0853069702f..10414bbbeecb 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -432,13 +432,13 @@ __primary_switched:
 	dsb	ishst				// Make zero page visible to PTW
 
 #ifdef CONFIG_KASAN
-	bl	kasan_early_init
+	bl_c	kasan_early_init
 #endif
 #ifdef CONFIG_RANDOMIZE_BASE
 	tst	x23, ~(MIN_KIMG_ALIGN - 1)	// already running randomized?
 	b.ne	0f
 	mov	x0, x21				// pass FDT address in x0
-	bl	kaslr_early_init		// parse FDT for KASLR options
+	bl_c	kaslr_early_init		// parse FDT for KASLR options
 	cbz	x0, 0f				// KASLR disabled? just proceed
 	orr	x23, x23, x0			// record KASLR offset
 	ldp	x29, x30, [sp], #16		// we must enable KASLR, return
diff --git a/arch/arm64/kernel/probes/kprobes_trampoline.S b/arch/arm64/kernel/probes/kprobes_trampoline.S
index 45dce03aaeaf..0b195b727dc7 100644
--- a/arch/arm64/kernel/probes/kprobes_trampoline.S
+++ b/arch/arm64/kernel/probes/kprobes_trampoline.S
@@ -67,7 +67,7 @@ ENTRY(kretprobe_trampoline)
 	save_all_base_regs
 
 	mov x0, sp
-	bl trampoline_probe_handler
+	bl_c trampoline_probe_handler
 	/*
 	 * Replace trampoline address in lr with actual orig_ret_addr return
 	 * address.
diff --git a/arch/arm64/kernel/sleep.S b/arch/arm64/kernel/sleep.S
index bebec8ef9372..6ced3a8bb528 100644
--- a/arch/arm64/kernel/sleep.S
+++ b/arch/arm64/kernel/sleep.S
@@ -90,7 +90,7 @@ ENTRY(__cpu_suspend_enter)
 	str	x0, [x1]
 	add	x0, x0, #SLEEP_STACK_DATA_SYSTEM_REGS
 	stp	x29, lr, [sp, #-16]!
-	bl	cpu_do_suspend
+	bl_c	cpu_do_suspend
 	ldp	x29, lr, [sp], #16
 	mov	x0, #1
 	ret
@@ -129,11 +129,11 @@ ENTRY(_cpu_resume)
 	/*
 	 * cpu_do_resume expects x0 to contain context address pointer
 	 */
-	bl	cpu_do_resume
+	bl_c	cpu_do_resume
 
 #ifdef CONFIG_KASAN
 	mov	x0, sp
-	bl	kasan_unpoison_task_stack_below
+	bl_c	kasan_unpoison_task_stack_below
 #endif
 
 	ldp	x19, x20, [x29, #16]
-- 
2.18.0
