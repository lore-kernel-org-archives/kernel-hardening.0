Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Sun, 26 Jun 2016 14:55:37 -0700
Message-Id: <f0a81fa3f7f81422cca23c9d6c88a555d89787ab.1466974736.git.luto@kernel.org>
In-Reply-To: <cover.1466974736.git.luto@kernel.org>
References: <cover.1466974736.git.luto@kernel.org>
In-Reply-To: <cover.1466974736.git.luto@kernel.org>
References: <cover.1466974736.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v4 15/29] x86/mm/64: Enable vmapped stacks
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

This allows x86_64 kernels to enable vmapped stacks.  There are a
couple of interesting bits.

First, x86 lazily faults in top-level paging entries for the vmalloc
area.  This won't work if we get a page fault while trying to access
the stack: the CPU will promote it to a double-fault and we'll die.
To avoid this problem, probe the new stack when switching stacks and
forcibly populate the pgd entry for the stack when switching mms.

Second, once we have guard pages around the stack, we'll want to
detect and handle stack overflow.

I didn't enable it on x86_32.  We'd need to rework the double-fault
code a bit and I'm concerned about running out of vmalloc virtual
addresses under some workloads.

This patch, by itself, will behave somewhat erratically when the
stack overflows while RSP is still more than a few tens of bytes
above the bottom of the stack.  Specifically, we'll get #PF and make
it to no_context and an oops without triggering a double-fault, and
no_context doesn't know about stack overflows.  The next patch will
improve that case.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/Kconfig                 |  1 +
 arch/x86/include/asm/switch_to.h | 28 +++++++++++++++++++++++++++-
 arch/x86/kernel/traps.c          | 32 ++++++++++++++++++++++++++++++++
 arch/x86/mm/tlb.c                | 15 +++++++++++++++
 4 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d9a94da0c29f..afdcf96ef109 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -92,6 +92,7 @@ config X86
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_EBPF_JIT			if X86_64
+	select HAVE_ARCH_VMAP_STACK		if X86_64
 	select HAVE_CC_STACKPROTECTOR
 	select HAVE_CMPXCHG_DOUBLE
 	select HAVE_CMPXCHG_LOCAL
diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
index 8f321a1b03a1..14e4b20f0aaf 100644
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -8,6 +8,28 @@ struct tss_struct;
 void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		      struct tss_struct *tss);
 
+/* This runs runs on the previous thread's stack. */
+static inline void prepare_switch_to(struct task_struct *prev,
+				     struct task_struct *next)
+{
+#ifdef CONFIG_VMAP_STACK
+	/*
+	 * If we switch to a stack that has a top-level paging entry
+	 * that is not present in the current mm, the resulting #PF will
+	 * will be promoted to a double-fault and we'll panic.  Probe
+	 * the new stack now so that vmalloc_fault can fix up the page
+	 * tables if needed.  This can only happen if we use a stack
+	 * in vmap space.
+	 *
+	 * We assume that the stack is aligned so that it never spans
+	 * more than one top-level paging entry.
+	 *
+	 * To minimize cache pollution, just follow the stack pointer.
+	 */
+	READ_ONCE(*(unsigned char *)next->thread.sp);
+#endif
+}
+
 #ifdef CONFIG_X86_32
 
 #ifdef CONFIG_CC_STACKPROTECTOR
@@ -39,6 +61,8 @@ do {									\
 	 */								\
 	unsigned long ebx, ecx, edx, esi, edi;				\
 									\
+	prepare_switch_to(prev, next);					\
+									\
 	asm volatile("pushl %%ebp\n\t"		/* save    EBP   */	\
 		     "movl %%esp,%[prev_sp]\n\t"	/* save    ESP   */ \
 		     "movl %[next_sp],%%esp\n\t"	/* restore ESP   */ \
@@ -103,7 +127,9 @@ do {									\
  * clean in kernel mode, with the possible exception of IOPL.  Kernel IOPL
  * has no effect.
  */
-#define switch_to(prev, next, last) \
+#define switch_to(prev, next, last)					  \
+	prepare_switch_to(prev, next);					  \
+									  \
 	asm volatile(SAVE_CONTEXT					  \
 	     "movq %%rsp,%P[threadrsp](%[prev])\n\t" /* save RSP */	  \
 	     "movq %P[threadrsp](%[next]),%%rsp\n\t" /* restore RSP */	  \
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 00f03d82e69a..9cb7ea781176 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -292,12 +292,30 @@ DO_ERROR(X86_TRAP_NP,     SIGBUS,  "segment not present",	segment_not_present)
 DO_ERROR(X86_TRAP_SS,     SIGBUS,  "stack segment",		stack_segment)
 DO_ERROR(X86_TRAP_AC,     SIGBUS,  "alignment check",		alignment_check)
 
+#ifdef CONFIG_VMAP_STACK
+static void __noreturn handle_stack_overflow(const char *message,
+					     struct pt_regs *regs,
+					     unsigned long fault_address)
+{
+	printk(KERN_EMERG "BUG: stack guard page was hit at %p (stack is %p..%p)\n",
+		 (void *)fault_address, current->stack,
+		 (char *)current->stack + THREAD_SIZE - 1);
+	die(message, regs, 0);
+
+	/* Be absolutely certain we don't return. */
+	panic(message);
+}
+#endif
+
 #ifdef CONFIG_X86_64
 /* Runs on IST stack */
 dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 {
 	static const char str[] = "double fault";
 	struct task_struct *tsk = current;
+#ifdef CONFIG_VMAP_STACK
+	unsigned long cr2;
+#endif
 
 #ifdef CONFIG_X86_ESPFIX64
 	extern unsigned char native_irq_return_iret[];
@@ -332,6 +350,20 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 	tsk->thread.error_code = error_code;
 	tsk->thread.trap_nr = X86_TRAP_DF;
 
+#ifdef CONFIG_VMAP_STACK
+	/*
+	 * If we overflow the stack into a guard page, the CPU will fail
+	 * to deliver #PF and will send #DF instead.  CR2 will contain
+	 * the linear address of the second fault, which will be in the
+	 * guard page below the bottom of the stack.
+	 */
+	cr2 = read_cr2();
+	if ((unsigned long)tsk->stack - 1 - cr2 < PAGE_SIZE)
+		handle_stack_overflow(
+			"kernel stack overflow (double-fault)",
+			regs, cr2);
+#endif
+
 #ifdef CONFIG_DOUBLEFAULT
 	df_debug(regs, error_code);
 #endif
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 5643fd0b1a7d..fbf036ae72ac 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -77,10 +77,25 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
 	unsigned cpu = smp_processor_id();
 
 	if (likely(prev != next)) {
+		if (IS_ENABLED(CONFIG_VMAP_STACK)) {
+			/*
+			 * If our current stack is in vmalloc space and isn't
+			 * mapped in the new pgd, we'll double-fault.  Forcibly
+			 * map it.
+			 */
+			unsigned int stack_pgd_index =
+				pgd_index(current_stack_pointer());
+			pgd_t *pgd = next->pgd + stack_pgd_index;
+
+			if (unlikely(pgd_none(*pgd)))
+				set_pgd(pgd, init_mm.pgd[stack_pgd_index]);
+		}
+
 #ifdef CONFIG_SMP
 		this_cpu_write(cpu_tlbstate.state, TLBSTATE_OK);
 		this_cpu_write(cpu_tlbstate.active_mm, next);
 #endif
+
 		cpumask_set_cpu(cpu, mm_cpumask(next));
 
 		/*
-- 
2.7.4
