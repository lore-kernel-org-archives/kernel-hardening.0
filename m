From: Mark Rutland <mark.rutland@arm.com>
Date: Wed, 12 Jul 2017 23:32:58 +0100
Message-Id: <1499898783-25732-2-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1499898783-25732-1-git-send-email-mark.rutland@arm.com>
References: <1499898783-25732-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [RFC PATCH 1/6] arm64: use tpidr_el1 for current, free sp_el0
To: ard.biesheuvel@linaro.org, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: akashi.takahiro@linaro.org, catalin.marinas@arm.com, dave.martin@arm.com, james.morse@arm.com, labbott@fedoraproject.org, will.deacon@arm.com, keescook@chromium.org, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Today we use TPIDR_EL1 for our percpu offset, and SP_EL0 for current
(and current::thread_info, which is at offset 0).

Using SP_EL0 in this way prevents us from using EL1 thread mode, where
SP_EL0 is not addressable (since it's used as the active SP). It also
means we can't use SP_EL0 for other purposes (e.g. as a
scratch-register).

This patch frees up SP_EL0 for such usage, by storing the percpu offset
in current::thread_info, and using TPIDR_EL1 to store current. As we no
longer need to update SP_EL0 at EL0 exception boundaries, this allows us
to delete some code.

This new organisation means that we need to perform an additional load
to acquire the prcpu offset. However, our assembly constraints allow
current to be cached, and therefore allow the offset to be cached.
Additionally, in most cases where we need the percpu offset, we also
need to fiddle with the preempt count or other data stored in
current::thread_info, so this data should already be hot in the caches.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/include/asm/assembler.h   | 11 ++++++++---
 arch/arm64/include/asm/current.h     |  6 +++---
 arch/arm64/include/asm/percpu.h      | 15 ++++-----------
 arch/arm64/include/asm/thread_info.h |  1 +
 arch/arm64/kernel/asm-offsets.c      |  1 +
 arch/arm64/kernel/entry.S            | 11 ++---------
 arch/arm64/kernel/head.S             |  4 ++--
 arch/arm64/kernel/process.c          | 16 ++++------------
 8 files changed, 25 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 1b67c37..f7da6b5 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -229,6 +229,11 @@
 #endif
 	.endm
 
+	.macro	get_this_cpu_offset dst
+	mrs	\dst, tpidr_el1
+	ldr	\dst, [\dst, #TSK_TI_PCP]
+	.endm
+
 	/*
 	 * @dst: Result of per_cpu(sym, smp_processor_id())
 	 * @sym: The name of the per-cpu variable
@@ -236,7 +241,7 @@
 	 */
 	.macro adr_this_cpu, dst, sym, tmp
 	adr_l	\dst, \sym
-	mrs	\tmp, tpidr_el1
+	get_this_cpu_offset \tmp
 	add	\dst, \dst, \tmp
 	.endm
 
@@ -247,7 +252,7 @@
 	 */
 	.macro ldr_this_cpu dst, sym, tmp
 	adr_l	\dst, \sym
-	mrs	\tmp, tpidr_el1
+	get_this_cpu_offset \tmp
 	ldr	\dst, [\dst, \tmp]
 	.endm
 
@@ -438,7 +443,7 @@
  * Return the current thread_info.
  */
 	.macro	get_thread_info, rd
-	mrs	\rd, sp_el0
+	mrs	\rd, tpidr_el1
 	.endm
 
 /*
diff --git a/arch/arm64/include/asm/current.h b/arch/arm64/include/asm/current.h
index f6580d4..54b271a 100644
--- a/arch/arm64/include/asm/current.h
+++ b/arch/arm64/include/asm/current.h
@@ -13,11 +13,11 @@
  */
 static __always_inline struct task_struct *get_current(void)
 {
-	unsigned long sp_el0;
+	unsigned long cur;
 
-	asm ("mrs %0, sp_el0" : "=r" (sp_el0));
+	asm ("mrs %0, tpidr_el1" : "=r" (cur));
 
-	return (struct task_struct *)sp_el0;
+	return (struct task_struct *)cur;
 }
 
 #define current get_current()
diff --git a/arch/arm64/include/asm/percpu.h b/arch/arm64/include/asm/percpu.h
index 3bd498e..05cf0f8 100644
--- a/arch/arm64/include/asm/percpu.h
+++ b/arch/arm64/include/asm/percpu.h
@@ -18,23 +18,16 @@
 
 #include <asm/stack_pointer.h>
 
+#include <linux/thread_info.h>
+
 static inline void set_my_cpu_offset(unsigned long off)
 {
-	asm volatile("msr tpidr_el1, %0" :: "r" (off) : "memory");
+	current_thread_info()->pcp_offset = off;
 }
 
 static inline unsigned long __my_cpu_offset(void)
 {
-	unsigned long off;
-
-	/*
-	 * We want to allow caching the value, so avoid using volatile and
-	 * instead use a fake stack read to hazard against barrier().
-	 */
-	asm("mrs %0, tpidr_el1" : "=r" (off) :
-		"Q" (*(const unsigned long *)current_stack_pointer));
-
-	return off;
+	return current_thread_info()->pcp_offset;
 }
 #define __my_cpu_offset __my_cpu_offset()
 
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 46c3b93..141f13e9 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -50,6 +50,7 @@ struct thread_info {
 #ifdef CONFIG_ARM64_SW_TTBR0_PAN
 	u64			ttbr0;		/* saved TTBR0_EL1 */
 #endif
+	unsigned long		pcp_offset;
 	int			preempt_count;	/* 0 => preemptable, <0 => bug */
 };
 
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index b3bb7ef..17001be 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -38,6 +38,7 @@ int main(void)
   BLANK();
   DEFINE(TSK_TI_FLAGS,		offsetof(struct task_struct, thread_info.flags));
   DEFINE(TSK_TI_PREEMPT,	offsetof(struct task_struct, thread_info.preempt_count));
+  DEFINE(TSK_TI_PCP,		offsetof(struct task_struct, thread_info.pcp_offset));
   DEFINE(TSK_TI_ADDR_LIMIT,	offsetof(struct task_struct, thread_info.addr_limit));
 #ifdef CONFIG_ARM64_SW_TTBR0_PAN
   DEFINE(TSK_TI_TTBR0,		offsetof(struct task_struct, thread_info.ttbr0));
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index b738880..773b3fea 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -92,7 +92,7 @@
 
 	.if	\el == 0
 	mrs	x21, sp_el0
-	ldr_this_cpu	tsk, __entry_task, x20	// Ensure MDSCR_EL1.SS is clear,
+	get_thread_info tsk			// Ensure MDSCR_EL1.SS is clear,
 	ldr	x19, [tsk, #TSK_TI_FLAGS]	// since we can unmask debug
 	disable_step_tsk x19, x20		// exceptions when scheduling.
 
@@ -147,13 +147,6 @@ alternative_else_nop_endif
 	.endif
 
 	/*
-	 * Set sp_el0 to current thread_info.
-	 */
-	.if	\el == 0
-	msr	sp_el0, tsk
-	.endif
-
-	/*
 	 * Registers that may be useful after this macro is invoked:
 	 *
 	 * x21 - aborted SP
@@ -734,7 +727,7 @@ ENTRY(cpu_switch_to)
 	ldp	x29, x9, [x8], #16
 	ldr	lr, [x8]
 	mov	sp, x9
-	msr	sp_el0, x1
+	msr	tpidr_el1, x1
 	ret
 ENDPROC(cpu_switch_to)
 
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 973df7d..a58ecda 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -324,7 +324,7 @@ __primary_switched:
 	adrp	x4, init_thread_union
 	add	sp, x4, #THREAD_SIZE
 	adr_l	x5, init_task
-	msr	sp_el0, x5			// Save thread_info
+	msr	tpidr_el1, x5			// Save thread_info
 
 	adr_l	x8, vectors			// load VBAR_EL1 with virtual
 	msr	vbar_el1, x8			// vector table address
@@ -615,7 +615,7 @@ __secondary_switched:
 	ldr	x1, [x0, #CPU_BOOT_STACK]	// get secondary_data.stack
 	mov	sp, x1
 	ldr	x2, [x0, #CPU_BOOT_TASK]
-	msr	sp_el0, x2
+	msr	tpidr_el1, x2
 	mov	x29, #0
 	b	secondary_start_kernel
 ENDPROC(__secondary_switched)
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index ae2a835..4212da3 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -323,18 +323,10 @@ void uao_thread_switch(struct task_struct *next)
 	}
 }
 
-/*
- * We store our current task in sp_el0, which is clobbered by userspace. Keep a
- * shadow copy so that we can restore this upon entry from userspace.
- *
- * This is *only* for exception entry from EL0, and is not valid until we
- * __switch_to() a user task.
- */
-DEFINE_PER_CPU(struct task_struct *, __entry_task);
-
-static void entry_task_switch(struct task_struct *next)
+/* Ensure the new task has this CPU's offset */
+void pcp_thread_switch(struct task_struct *next)
 {
-	__this_cpu_write(__entry_task, next);
+	next->thread_info.pcp_offset = current_thread_info()->pcp_offset;
 }
 
 /*
@@ -349,8 +341,8 @@ __notrace_funcgraph struct task_struct *__switch_to(struct task_struct *prev,
 	tls_thread_switch(next);
 	hw_breakpoint_thread_switch(next);
 	contextidr_thread_switch(next);
-	entry_task_switch(next);
 	uao_thread_switch(next);
+	pcp_thread_switch(next);
 
 	/*
 	 * Complete any pending TLB or cache maintenance on this CPU in case
-- 
1.9.1
