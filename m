Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 11 Jul 2016 13:54:00 -0700
Message-Id: <d9e7ba98c2ca450660eb5990a2c492c19691f94e.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v5 27/32] x86: Move thread_info into task_struct
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Now that most of the thread_info users have been cleaned up,
this is straightforward.

Most of this code was written by Linus.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/Kconfig                   |  1 +
 arch/x86/entry/entry_64.S          |  9 +++++---
 arch/x86/include/asm/switch_to.h   |  6 ++---
 arch/x86/include/asm/thread_info.h | 46 --------------------------------------
 arch/x86/kernel/asm-offsets.c      |  4 +---
 arch/x86/kernel/irq_64.c           |  3 +--
 arch/x86/kernel/process.c          |  6 ++---
 7 files changed, 13 insertions(+), 62 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index afdcf96ef109..b3002c8efde2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -155,6 +155,7 @@ config X86
 	select SPARSE_IRQ
 	select SRCU
 	select SYSCTL_EXCEPTION_TRACE
+	select THREAD_INFO_IN_TASK
 	select USER_STACKTRACE_SUPPORT
 	select VIRT_TO_BUS
 	select X86_DEV_DMA_OPS			if X86_64
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index b846875aeea6..038d5e0fe940 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -179,7 +179,8 @@ GLOBAL(entry_SYSCALL_64_after_swapgs)
 	 * If we need to do entry work or if we guess we'll need to do
 	 * exit work, go straight to the slow path.
 	 */
-	testl	$_TIF_WORK_SYSCALL_ENTRY|_TIF_ALLWORK_MASK, ASM_THREAD_INFO(TI_flags, %rsp, SIZEOF_PTREGS)
+	movq	PER_CPU_VAR(current_task), %r11
+	testl	$_TIF_WORK_SYSCALL_ENTRY|_TIF_ALLWORK_MASK, TASK_TI_flags(%r11)
 	jnz	entry_SYSCALL64_slow_path
 
 entry_SYSCALL_64_fastpath:
@@ -217,7 +218,8 @@ entry_SYSCALL_64_fastpath:
 	 */
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	testl	$_TIF_ALLWORK_MASK, ASM_THREAD_INFO(TI_flags, %rsp, SIZEOF_PTREGS)
+	movq	PER_CPU_VAR(current_task), %r11
+	testl	$_TIF_ALLWORK_MASK, TASK_TI_flags(%r11)
 	jnz	1f
 
 	LOCKDEP_SYS_EXIT
@@ -368,9 +370,10 @@ END(ptregs_\func)
  * A newly forked process directly context switches into this address.
  *
  * rdi: prev task we switched from
+ * rsi: task we're switching to
  */
 ENTRY(ret_from_fork)
-	LOCK ; btr $TIF_FORK, TI_flags(%r8)
+	LOCK ; btr $TIF_FORK, TASK_TI_flags(%rsi)
 
 	call	schedule_tail			/* rdi: 'prev' task parameter */
 
diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
index 14e4b20f0aaf..5194f4a680ab 100644
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -136,18 +136,16 @@ do {									\
 	     "call __switch_to\n\t"					  \
 	     "movq "__percpu_arg([current_task])",%%rsi\n\t"		  \
 	     __switch_canary						  \
-	     "movq %P[thread_info](%%rsi),%%r8\n\t"			  \
 	     "movq %%rax,%%rdi\n\t" 					  \
-	     "testl  %[_tif_fork],%P[ti_flags](%%r8)\n\t"		  \
+	     "testl  %[_tif_fork],%P[ti_flags](%%rsi)\n\t"		  \
 	     "jnz   ret_from_fork\n\t"					  \
 	     RESTORE_CONTEXT						  \
 	     : "=a" (last)					  	  \
 	       __switch_canary_oparam					  \
 	     : [next] "S" (next), [prev] "D" (prev),			  \
 	       [threadrsp] "i" (offsetof(struct task_struct, thread.sp)), \
-	       [ti_flags] "i" (offsetof(struct thread_info, flags)),	  \
+	       [ti_flags] "i" (offsetof(struct task_struct, thread_info.flags)),	  \
 	       [_tif_fork] "i" (_TIF_FORK),			  	  \
-	       [thread_info] "i" (offsetof(struct task_struct, stack)),   \
 	       [current_task] "m" (current_task)			  \
 	       __switch_canary_iparam					  \
 	     : "memory", "cc" __EXTRA_CLOBBER)
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 7b42c1e462ac..0afc37654ad1 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -52,20 +52,6 @@ struct task_struct;
 #include <asm/cpufeature.h>
 #include <linux/atomic.h>
 
-struct thread_info {
-	struct task_struct	*task;		/* main task structure */
-	__u32			flags;		/* low level flags */
-	__u32			cpu;		/* current CPU */
-};
-
-#define INIT_THREAD_INFO(tsk)			\
-{						\
-	.task		= &tsk,			\
-	.flags		= 0,			\
-	.cpu		= 0,			\
-}
-
-#define init_thread_info	(init_thread_union.thread_info)
 #define init_stack		(init_thread_union.stack)
 
 #else /* !__ASSEMBLY__ */
@@ -159,11 +145,6 @@ struct thread_info {
  */
 #ifndef __ASSEMBLY__
 
-static inline struct thread_info *current_thread_info(void)
-{
-	return (struct thread_info *)(current_top_of_stack() - THREAD_SIZE);
-}
-
 static inline unsigned long current_stack_pointer(void)
 {
 	unsigned long sp;
@@ -181,33 +162,6 @@ static inline unsigned long current_stack_pointer(void)
 # define cpu_current_top_of_stack (cpu_tss + TSS_sp0)
 #endif
 
-/*
- * ASM operand which evaluates to a 'thread_info' address of
- * the current task, if it is known that "reg" is exactly "off"
- * bytes below the top of the stack currently.
- *
- * ( The kernel stack's size is known at build time, it is usually
- *   2 or 4 pages, and the bottom  of the kernel stack contains
- *   the thread_info structure. So to access the thread_info very
- *   quickly from assembly code we can calculate down from the
- *   top of the kernel stack to the bottom, using constant,
- *   build-time calculations only. )
- *
- * For example, to fetch the current thread_info->flags value into %eax
- * on x86-64 defconfig kernels, in syscall entry code where RSP is
- * currently at exactly SIZEOF_PTREGS bytes away from the top of the
- * stack:
- *
- *      mov ASM_THREAD_INFO(TI_flags, %rsp, SIZEOF_PTREGS), %eax
- *
- * will translate to:
- *
- *      8b 84 24 b8 c0 ff ff      mov    -0x3f48(%rsp), %eax
- *
- * which is below the current RSP by almost 16K.
- */
-#define ASM_THREAD_INFO(field, reg, off) ((field)+(off)-THREAD_SIZE)(reg)
-
 #endif
 
 #ifndef __ASSEMBLY__
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index a91a6ead24a2..e900f5e13f22 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -29,9 +29,7 @@
 
 void common(void) {
 	BLANK();
-	OFFSET(TI_flags, thread_info, flags);
-
-	BLANK();
+	OFFSET(TASK_TI_flags, task_struct, thread_info.flags);
 	OFFSET(TASK_addr_limit, task_struct, thread.addr_limit);
 
 	BLANK();
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 206d0b90a3ab..38f9f5678dc8 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -41,8 +41,7 @@ static inline void stack_overflow_check(struct pt_regs *regs)
 	if (user_mode(regs))
 		return;
 
-	if (regs->sp >= curbase + sizeof(struct thread_info) +
-				  sizeof(struct pt_regs) + STACK_TOP_MARGIN &&
+	if (regs->sp >= curbase + sizeof(struct pt_regs) + STACK_TOP_MARGIN &&
 	    regs->sp <= curbase + THREAD_SIZE)
 		return;
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 96becbbb52e0..8f60f810a9e7 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -536,9 +536,7 @@ unsigned long get_wchan(struct task_struct *p)
 	 * PADDING
 	 * ----------- top = topmax - TOP_OF_KERNEL_STACK_PADDING
 	 * stack
-	 * ----------- bottom = start + sizeof(thread_info)
-	 * thread_info
-	 * ----------- start
+	 * ----------- bottom = start
 	 *
 	 * The tasks stack pointer points at the location where the
 	 * framepointer is stored. The data on the stack is:
@@ -549,7 +547,7 @@ unsigned long get_wchan(struct task_struct *p)
 	 */
 	top = start + THREAD_SIZE - TOP_OF_KERNEL_STACK_PADDING;
 	top -= 2 * sizeof(unsigned long);
-	bottom = start + sizeof(struct thread_info);
+	bottom = start;
 
 	sp = READ_ONCE(p->thread.sp);
 	if (sp < bottom || sp > top)
-- 
2.7.4
