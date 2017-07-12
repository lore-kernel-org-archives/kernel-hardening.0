From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 12 Jul 2017 15:44:23 +0100
Message-Id: <20170712144424.19528-11-ard.biesheuvel@linaro.org>
In-Reply-To: <20170712144424.19528-1-ard.biesheuvel@linaro.org>
References: <20170712144424.19528-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [RFC PATCH 10/10] arm64: kernel: add support for virtually mapped stacks
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
Cc: mark.rutland@arm.com, labbott@fedoraproject.org, will.deacon@arm.com, dave.martin@arm.com, catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Add code that checks whether an exception taken from EL1 was caused
by a faulting stack access before proceeding to save the interrupted
context to the stack.

This involves checking whether the faulting address coincides with the
guard page below the task stack of 'current'. This uses tpidrro_el0 and
sp_el0 as scratch registers, so we can free up a couple of general
purpose registers for use in the code that performs this check. If it
turns out we are dealing with a stack overflow, switch to a special
per-CPU overflow stack so we can at least call panic().

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Kconfig                   |  1 +
 arch/arm64/include/asm/thread_info.h |  2 +
 arch/arm64/kernel/entry.S            | 49 ++++++++++++++++++++
 arch/arm64/mm/fault.c                |  9 ++++
 4 files changed, 61 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b52db8bb1270..50caf63099c8 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -73,6 +73,7 @@ config ARM64
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
+	select HAVE_ARCH_VMAP_STACK
 	select HAVE_ARM_SMCCC
 	select HAVE_EBPF_JIT
 	select HAVE_C_RECORDMCOUNT
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 46c3b93cf865..1c3e0a3bf87a 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -32,6 +32,8 @@
 #define THREAD_SIZE		16384
 #define THREAD_START_SP		(THREAD_SIZE - 16)
 
+#define OVERFLOW_STACK_SIZE	1024
+
 #ifndef __ASSEMBLY__
 
 struct task_struct;
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 2ba3185b1c78..4c3e82d6e2f2 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -392,6 +392,20 @@ ENDPROC(el1_error_invalid)
  */
 	.align	6
 el1_sync:
+#ifdef CONFIG_VMAP_STACK
+	/*
+	 * When taking an exception from EL1, we need to check whether it is
+	 * caused by a faulting out-of-bounds access to the virtually mapped
+	 * stack before we can attempt to preserve the interrupted context.
+	 */
+	msr	tpidrro_el0, x0			// stash x0
+	mrs	x0, far_el1			// get faulting address
+	tbnz	x0, #63, .Lcheck_stack_ovf	// check if not user address
+
+.Lcheck_stack_resume:
+	mrs	x0, tpidrro_el0			// restore x0
+#endif
+
 	kernel_entry 1
 	mrs	x1, esr_el1			// read the syndrome register
 	lsr	x24, x1, #ESR_ELx_EC_SHIFT	// exception class
@@ -411,6 +425,41 @@ el1_sync:
 	b.ge	el1_dbg
 	b	el1_inv
 
+#ifdef CONFIG_VMAP_STACK
+.Lcheck_stack_ovf:
+	/*
+	 * Check if the faulting address is above PAGE_OFFSET, which rules out
+	 * the vmapped stacks living in the VMALLOC region.
+	 */
+	tbnz	x0, #(VA_BITS - 2), .Lcheck_stack_resume
+
+	/*
+	 * Check whether the faulting address hit a guard page below our
+	 * virtually mapped stack. This is a strong hint that we may be
+	 * dealing with a stack overflow.
+	 */
+	msr	sp_el0, x1			// stash x1
+	ldr	x1, [tsk, #TSK_STACK]		// get task's stack base
+	sub	x1, x1, x0			// subtract FAR from stack base
+	tst	x1, #~(PAGE_SIZE - 1)		// disregard bits within page
+	mrs	x1, sp_el0			// restore x1
+	b.ne	.Lcheck_stack_resume		// proceed if no stack overflow
+
+	/*
+	 * We are not going to recover from a stack overflow in kernel mode,
+	 * but we would like to report this condition to the user, which means
+	 * we need another stack.
+	 */
+	mov	x0, sp
+	msr	sp_el0, x0			// stash the faulting sp
+
+	adr_l	x0, overflow_stack + OVERFLOW_STACK_SIZE
+	sub	sp, x0, #S_FRAME_SIZE
+	mrs	x0, tpidr_el1
+	add	sp, sp, x0
+	b	.Lcheck_stack_resume
+#endif
+
 el1_ia:
 	/*
 	 * Fall through to the Data abort case
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index b3317e5ff5dd..9ecd47572656 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -45,6 +45,11 @@
 
 #include <acpi/ghes.h>
 
+#ifdef CONFIG_VMAP_STACK
+DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
+	 __aligned(16);
+#endif
+
 struct fault_info {
 	int	(*fn)(unsigned long addr, unsigned int esr,
 		      struct pt_regs *regs);
@@ -234,6 +239,10 @@ static void __do_kernel_fault(unsigned long addr, unsigned int esr,
 	 */
 	if (addr >= (u64)current->stack - PAGE_SIZE &&
 	    addr < (u64)current->stack) {
+
+		/* fix up regs->sp, we stashed the faulting value in sp_el0 */
+		regs->sp = read_sysreg(sp_el0);
+
 		printk(KERN_EMERG "BUG: stack guard page was hit at %p (stack is %p..%p)\n",
 			 (void *)addr, current->stack,
 			 (char *)current->stack + THREAD_SIZE - 1);
-- 
2.9.3
