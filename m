Subject: Patch "x86/entry/64: Remove the SYSCALL64 fast path" has been added to the 4.9-stable tree
From: <gregkh@linuxfoundation.org>
Date: Thu, 08 Feb 2018 03:38:19 +0100
Message-ID: <1518057499111245@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
To: luto@kernel.org, bp@alien8.de, dwmw@amazon.co.uk, gregkh@linuxfoundation.org, kernel-hardening@lists.openwall.com, mingo@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org
Cc: stable@vger.kernel.org, stable-commits@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


This is a note to let you know that I've just added the patch titled

    x86/entry/64: Remove the SYSCALL64 fast path

to the 4.9-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     x86-entry-64-remove-the-syscall64-fast-path.patch
and it can be found in the queue-4.9 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From foo@baz Thu Feb  8 03:30:27 CET 2018
From: Andy Lutomirski <luto@kernel.org>
Date: Sun, 28 Jan 2018 10:38:49 -0800
Subject: x86/entry/64: Remove the SYSCALL64 fast path

From: Andy Lutomirski <luto@kernel.org>

(cherry picked from commit 21d375b6b34ff511a507de27bf316b3dde6938d9)

The SYCALLL64 fast path was a nice, if small, optimization back in the good
old days when syscalls were actually reasonably fast.  Now there is PTI to
slow everything down, and indirect branches are verboten, making everything
messier.  The retpoline code in the fast path is particularly nasty.

Just get rid of the fast path. The slow path is barely slower.

[ tglx: Split out the 'push all extra regs' part ]

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Link: https://lkml.kernel.org/r/462dff8d4d64dfbfc851fbf3130641809d980ecd.1517164461.git.luto@kernel.org
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_64.S   |  123 --------------------------------------------
 arch/x86/entry/syscall_64.c |    7 --
 2 files changed, 3 insertions(+), 127 deletions(-)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -179,94 +179,11 @@ GLOBAL(entry_SYSCALL_64_after_swapgs)
 	pushq	%r11				/* pt_regs->r11 */
 	sub	$(6*8), %rsp			/* pt_regs->bp, bx, r12-15 not saved */
 
-	/*
-	 * If we need to do entry work or if we guess we'll need to do
-	 * exit work, go straight to the slow path.
-	 */
-	movq	PER_CPU_VAR(current_task), %r11
-	testl	$_TIF_WORK_SYSCALL_ENTRY|_TIF_ALLWORK_MASK, TASK_TI_flags(%r11)
-	jnz	entry_SYSCALL64_slow_path
-
-entry_SYSCALL_64_fastpath:
-	/*
-	 * Easy case: enable interrupts and issue the syscall.  If the syscall
-	 * needs pt_regs, we'll call a stub that disables interrupts again
-	 * and jumps to the slow path.
-	 */
-	TRACE_IRQS_ON
-	ENABLE_INTERRUPTS(CLBR_NONE)
-#if __SYSCALL_MASK == ~0
-	cmpq	$__NR_syscall_max, %rax
-#else
-	andl	$__SYSCALL_MASK, %eax
-	cmpl	$__NR_syscall_max, %eax
-#endif
-	ja	1f				/* return -ENOSYS (already in pt_regs->ax) */
-	movq	%r10, %rcx
-
-	/*
-	 * This call instruction is handled specially in stub_ptregs_64.
-	 * It might end up jumping to the slow path.  If it jumps, RAX
-	 * and all argument registers are clobbered.
-	 */
-#ifdef CONFIG_RETPOLINE
-	movq	sys_call_table(, %rax, 8), %rax
-	call	__x86_indirect_thunk_rax
-#else
-	call	*sys_call_table(, %rax, 8)
-#endif
-.Lentry_SYSCALL_64_after_fastpath_call:
-
-	movq	%rax, RAX(%rsp)
-1:
-
-	/*
-	 * If we get here, then we know that pt_regs is clean for SYSRET64.
-	 * If we see that no exit work is required (which we are required
-	 * to check with IRQs off), then we can go straight to SYSRET64.
-	 */
-	DISABLE_INTERRUPTS(CLBR_NONE)
-	TRACE_IRQS_OFF
-	movq	PER_CPU_VAR(current_task), %r11
-	testl	$_TIF_ALLWORK_MASK, TASK_TI_flags(%r11)
-	jnz	1f
-
-	LOCKDEP_SYS_EXIT
-	TRACE_IRQS_ON		/* user mode is traced as IRQs on */
-	movq	RIP(%rsp), %rcx
-	movq	EFLAGS(%rsp), %r11
-	RESTORE_C_REGS_EXCEPT_RCX_R11
-	/*
-	 * This opens a window where we have a user CR3, but are
-	 * running in the kernel.  This makes using the CS
-	 * register useless for telling whether or not we need to
-	 * switch CR3 in NMIs.  Normal interrupts are OK because
-	 * they are off here.
-	 */
-	SWITCH_USER_CR3
-	movq	RSP(%rsp), %rsp
-	USERGS_SYSRET64
-
-1:
-	/*
-	 * The fast path looked good when we started, but something changed
-	 * along the way and we need to switch to the slow path.  Calling
-	 * raise(3) will trigger this, for example.  IRQs are off.
-	 */
-	TRACE_IRQS_ON
-	ENABLE_INTERRUPTS(CLBR_NONE)
-	SAVE_EXTRA_REGS
-	movq	%rsp, %rdi
-	call	syscall_return_slowpath	/* returns with IRQs disabled */
-	jmp	return_from_SYSCALL_64
-
-entry_SYSCALL64_slow_path:
 	/* IRQs are off. */
 	SAVE_EXTRA_REGS
 	movq	%rsp, %rdi
 	call	do_syscall_64		/* returns with IRQs disabled */
 
-return_from_SYSCALL_64:
 	RESTORE_EXTRA_REGS
 	TRACE_IRQS_IRETQ		/* we're about to change IF */
 
@@ -339,6 +256,7 @@ return_from_SYSCALL_64:
 syscall_return_via_sysret:
 	/* rcx and r11 are already restored (see code above) */
 	RESTORE_C_REGS_EXCEPT_RCX_R11
+
 	/*
 	 * This opens a window where we have a user CR3, but are
 	 * running in the kernel.  This makes using the CS
@@ -363,45 +281,6 @@ opportunistic_sysret_failed:
 	jmp	restore_c_regs_and_iret
 END(entry_SYSCALL_64)
 
-ENTRY(stub_ptregs_64)
-	/*
-	 * Syscalls marked as needing ptregs land here.
-	 * If we are on the fast path, we need to save the extra regs,
-	 * which we achieve by trying again on the slow path.  If we are on
-	 * the slow path, the extra regs are already saved.
-	 *
-	 * RAX stores a pointer to the C function implementing the syscall.
-	 * IRQs are on.
-	 */
-	cmpq	$.Lentry_SYSCALL_64_after_fastpath_call, (%rsp)
-	jne	1f
-
-	/*
-	 * Called from fast path -- disable IRQs again, pop return address
-	 * and jump to slow path
-	 */
-	DISABLE_INTERRUPTS(CLBR_NONE)
-	TRACE_IRQS_OFF
-	popq	%rax
-	jmp	entry_SYSCALL64_slow_path
-
-1:
-	JMP_NOSPEC %rax				/* Called from C */
-END(stub_ptregs_64)
-
-.macro ptregs_stub func
-ENTRY(ptregs_\func)
-	leaq	\func(%rip), %rax
-	jmp	stub_ptregs_64
-END(ptregs_\func)
-.endm
-
-/* Instantiate ptregs_stub for each ptregs-using syscall */
-#define __SYSCALL_64_QUAL_(sym)
-#define __SYSCALL_64_QUAL_ptregs(sym) ptregs_stub sym
-#define __SYSCALL_64(nr, sym, qual) __SYSCALL_64_QUAL_##qual(sym)
-#include <asm/syscalls_64.h>
-
 /*
  * %rdi: prev task
  * %rsi: next task
--- a/arch/x86/entry/syscall_64.c
+++ b/arch/x86/entry/syscall_64.c
@@ -6,14 +6,11 @@
 #include <asm/asm-offsets.h>
 #include <asm/syscall.h>
 
-#define __SYSCALL_64_QUAL_(sym) sym
-#define __SYSCALL_64_QUAL_ptregs(sym) ptregs_##sym
-
-#define __SYSCALL_64(nr, sym, qual) extern asmlinkage long __SYSCALL_64_QUAL_##qual(sym)(unsigned long, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long);
+#define __SYSCALL_64(nr, sym, qual) extern asmlinkage long sym(unsigned long, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long);
 #include <asm/syscalls_64.h>
 #undef __SYSCALL_64
 
-#define __SYSCALL_64(nr, sym, qual) [nr] = __SYSCALL_64_QUAL_##qual(sym),
+#define __SYSCALL_64(nr, sym, qual) [nr] = sym,
 
 extern long sys_ni_syscall(unsigned long, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long);
 


Patches currently in stable-queue which might be from luto@kernel.org are

queue-4.9/x86-entry-64-push-extra-regs-right-away.patch
queue-4.9/kvm-vmx-allow-direct-access-to-msr_ia32_spec_ctrl.patch
queue-4.9/kvm-x86-add-ibpb-support.patch
queue-4.9/kvm-svm-allow-direct-access-to-msr_ia32_spec_ctrl.patch
queue-4.9/x86-paravirt-remove-noreplace-paravirt-cmdline-option.patch
queue-4.9/x86-asm-move-status-from-thread_struct-to-thread_info.patch
queue-4.9/kvm-x86-make-indirect-calls-in-emulator-speculation-safe.patch
queue-4.9/x86-entry-64-remove-the-syscall64-fast-path.patch
queue-4.9/x86-asm-fix-inline-asm-call-constraints-for-gcc-4.4.patch
queue-4.9/kvm-vmx-make-indirect-call-speculation-safe.patch
queue-4.9/x86-spectre-fix-spelling-mistake-vunerable-vulnerable.patch
queue-4.9/x86-get_user-use-pointer-masking-to-limit-speculation.patch
queue-4.9/x86-syscall-sanitize-syscall-table-de-references-under-speculation.patch
queue-4.9/x86-pti-make-unpoison-of-pgd-for-trusted-boot-work-for-real.patch
queue-4.9/x86-pti-mark-constant-arrays-as-__initconst.patch
queue-4.9/kvm-vmx-emulate-msr_ia32_arch_capabilities.patch
