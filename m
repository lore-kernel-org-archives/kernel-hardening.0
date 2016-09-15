Reply-To: kernel-hardening@lists.openwall.com
From: Mark Rutland <mark.rutland@arm.com>
Date: Thu, 15 Sep 2016 14:49:09 +0100
Message-Id: <1473947349-14521-9-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1473947349-14521-1-git-send-email-mark.rutland@arm.com>
References: <1473947349-14521-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [RFC PATCH 8/8] arm64: split thread_info from task stack
To: linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, keescook@chromium.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, luto@kernel.org, mark.rutland@arm.com, suzuki.poulose@arm.com, takahiro.akashi@linaro.org, will.deacon@arm.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This patch moves arm64's struct thread_info from the task stack into
task_struct. This protects thread_info from corruption in the case of
stack overflows, and makes its address harder to determine if stack
addresses are leaked, making a number of attacks more difficult. Precise
detection and handling of overflow is left for subsequent patches.

Largely, this involves changing code to store the task_struct in sp_el0,
and acquire the thread_info from the task struct (which is the opposite
way around to the current code). Both secondary entry and idle are
updated to stash the sp and task pointer separately.

Userspace clobbers sp_el0, and we can no longer restore this from the
stack. Instead, the current task is cached in a per-cpu variable that we
can safely access from early assembly as interrupts are disabled (and we
are thus not preemptible).

There remain opportunities for improvement. Currently we cannot remove
thread_info::cpu and always use task_struct::cpu, as this would result
in a circular include dependency for raw_smp_processor_id():

  <asm/smp.h> -> <linux/sched.h> -> <linux/smp.h> -> <asm/smp.h>

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/Kconfig                   |  2 ++
 arch/arm64/include/asm/Kbuild        |  1 -
 arch/arm64/include/asm/current.h     | 22 ++++++++++++++++++++++
 arch/arm64/include/asm/smp.h         |  1 +
 arch/arm64/include/asm/thread_info.h | 19 -------------------
 arch/arm64/kernel/asm-offsets.c      |  1 +
 arch/arm64/kernel/entry.S            |  4 ++--
 arch/arm64/kernel/head.S             | 11 +++++------
 arch/arm64/kernel/process.c          | 31 ++++++++++++++++++++++++++-----
 arch/arm64/kernel/smp.c              |  2 ++
 arch/arm64/kernel/stacktrace.c       |  5 +++++
 11 files changed, 66 insertions(+), 33 deletions(-)
 create mode 100644 arch/arm64/include/asm/current.h

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index bc3f00f..9f57318 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -11,6 +11,7 @@ config ARM64
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_SG_CHAIN
+	select ARCH_HAS_OWN_THREAD_INFO
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_SUPPORTS_ATOMIC_RMW
@@ -110,6 +111,7 @@ config ARM64
 	select POWER_SUPPLY
 	select SPARSE_IRQ
 	select SYSCTL_EXCEPTION_TRACE
+	select THREAD_INFO_IN_TASK
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index f43d2c4..a716c6f 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -2,7 +2,6 @@ generic-y += bug.h
 generic-y += bugs.h
 generic-y += clkdev.h
 generic-y += cputime.h
-generic-y += current.h
 generic-y += delay.h
 generic-y += div64.h
 generic-y += dma.h
diff --git a/arch/arm64/include/asm/current.h b/arch/arm64/include/asm/current.h
new file mode 100644
index 0000000..f2bcbe2
--- /dev/null
+++ b/arch/arm64/include/asm/current.h
@@ -0,0 +1,22 @@
+#ifndef __ASM_CURRENT_H
+#define __ASM_CURRENT_H
+
+#include <linux/compiler.h>
+
+#include <asm/sysreg.h>
+
+#ifndef __ASSEMBLY__
+
+struct task_struct;
+
+static __always_inline struct task_struct *get_current(void)
+{
+	return (struct task_struct *)read_sysreg(sp_el0);
+}
+
+#define current get_current()
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* __ASM_CURRENT_H */
+
diff --git a/arch/arm64/include/asm/smp.h b/arch/arm64/include/asm/smp.h
index 0226447..fef90c0 100644
--- a/arch/arm64/include/asm/smp.h
+++ b/arch/arm64/include/asm/smp.h
@@ -73,6 +73,7 @@ asmlinkage void secondary_start_kernel(void);
  */
 struct secondary_data {
 	void *stack;
+	struct task_struct *task;
 	long status;
 };
 
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 796af24..5b16b34 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -46,14 +46,12 @@ typedef unsigned long mm_segment_t;
 struct thread_info {
 	unsigned long		flags;		/* low level flags */
 	mm_segment_t		addr_limit;	/* address limit */
-	struct task_struct	*task;		/* main task structure */
 	int			preempt_count;	/* 0 => preemptable, <0 => bug */
 	int			cpu;		/* cpu */
 };
 
 #define INIT_THREAD_INFO(tsk)						\
 {									\
-	.task		= &tsk,						\
 	.flags		= 0,						\
 	.preempt_count	= INIT_PREEMPT_COUNT,				\
 	.addr_limit	= KERNEL_DS,					\
@@ -66,23 +64,6 @@ struct thread_info {
  */
 register unsigned long current_stack_pointer asm ("sp");
 
-/*
- * how to get the thread information struct from C
- */
-static inline struct thread_info *current_thread_info(void) __attribute_const__;
-
-/*
- * struct thread_info can be accessed directly via sp_el0.
- */
-static inline struct thread_info *current_thread_info(void)
-{
-	unsigned long sp_el0;
-
-	asm ("mrs %0, sp_el0" : "=r" (sp_el0));
-
-	return (struct thread_info *)sp_el0;
-}
-
 #define thread_saved_pc(tsk)	\
 	((unsigned long)(tsk->thread.cpu_context.pc))
 #define thread_saved_sp(tsk)	\
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index ee764eb..242fe909 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -120,6 +120,7 @@ int main(void)
   DEFINE(TZ_DSTTIME,		offsetof(struct timezone, tz_dsttime));
   BLANK();
   DEFINE(CPU_BOOT_STACK,	offsetof(struct secondary_data, stack));
+  DEFINE(CPU_BOOT_TASK,		offsetof(struct secondary_data, task));
   BLANK();
 #ifdef CONFIG_KVM_ARM_HOST
   DEFINE(VCPU_CONTEXT,		offsetof(struct kvm_vcpu, arch.ctxt));
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 52b4241..f844e7f 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -123,6 +123,7 @@
 	 * Set sp_el0 to current thread_info.
 	 */
 	.if	\el == 0
+	ldr_this_cpu	tsk, __entry_task, x21
 	msr	sp_el0, tsk
 	.endif
 
@@ -680,8 +681,7 @@ ENTRY(cpu_switch_to)
 	ldp	x29, x9, [x8], #16
 	ldr	lr, [x8]
 	mov	sp, x9
-	and	x9, x9, #~(THREAD_SIZE - 1)
-	msr	sp_el0, x9
+	msr	sp_el0, x1
 	ret
 ENDPROC(cpu_switch_to)
 
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index b77f583..abc7330 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -433,8 +433,7 @@ __primary_switched:
 	dsb	ishst				// Make zero page visible to PTW
 
 	adr_l	sp, initial_sp, x4
-	mov	x4, sp
-	and	x4, x4, #~(THREAD_SIZE - 1)
+	adr_l	x4, init_task
 	msr	sp_el0, x4			// Save thread_info
 	str_l	x21, __fdt_pointer, x5		// Save FDT pointer
 
@@ -680,10 +679,10 @@ __secondary_switched:
 	isb
 
 	adr_l	x0, secondary_data
-	ldr	x0, [x0, #CPU_BOOT_STACK]	// get secondary_data.stack
-	mov	sp, x0
-	and	x0, x0, #~(THREAD_SIZE - 1)
-	msr	sp_el0, x0			// save thread_info
+	ldr	x1, [x0, #CPU_BOOT_STACK]	// get secondary_data.stack
+	mov	sp, x1
+	ldr	x2, [x0, #CPU_BOOT_TASK]
+	msr	sp_el0, x2
 	mov	x29, #0
 	b	secondary_start_kernel
 ENDPROC(__secondary_switched)
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 6cd2612..e35043d 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -45,6 +45,7 @@
 #include <linux/personality.h>
 #include <linux/notifier.h>
 #include <trace/events/power.h>
+#include <linux/percpu.h>
 
 #include <asm/alternative.h>
 #include <asm/compat.h>
@@ -314,6 +315,17 @@ static void uao_thread_switch(struct task_struct *next)
 }
 
 /*
+ * We store our current task in sp_el0, which is clobbered by userspace. Keep a
+ * shadow copy so that we can restore this upon entry from userspace.
+ */
+DEFINE_PER_CPU(struct task_struct *, __entry_task) = &init_task;
+
+static void entry_task_switch(struct task_struct *next)
+{
+	__this_cpu_write(__entry_task, next);
+}
+
+/*
  * Thread switching.
  */
 struct task_struct *__switch_to(struct task_struct *prev,
@@ -325,6 +337,7 @@ struct task_struct *__switch_to(struct task_struct *prev,
 	tls_thread_switch(next);
 	hw_breakpoint_thread_switch(next);
 	contextidr_thread_switch(next);
+	entry_task_switch(next);
 	uao_thread_switch(next);
 
 	/*
@@ -342,11 +355,14 @@ struct task_struct *__switch_to(struct task_struct *prev,
 unsigned long get_wchan(struct task_struct *p)
 {
 	struct stackframe frame;
-	unsigned long stack_page;
+	unsigned long stack_page, ret = 0;
 	int count = 0;
 	if (!p || p == current || p->state == TASK_RUNNING)
 		return 0;
 
+	if (!try_get_task_stack(p))
+		return 0;
+
 	frame.fp = thread_saved_fp(p);
 	frame.sp = thread_saved_sp(p);
 	frame.pc = thread_saved_pc(p);
@@ -358,11 +374,16 @@ unsigned long get_wchan(struct task_struct *p)
 		if (frame.sp < stack_page ||
 		    frame.sp >= stack_page + THREAD_SIZE ||
 		    unwind_frame(p, &frame))
-			return 0;
-		if (!in_sched_functions(frame.pc))
-			return frame.pc;
+			goto out;
+		if (!in_sched_functions(frame.pc)) {
+			ret = frame.pc;
+			goto out;
+		}
 	} while (count ++ < 16);
-	return 0;
+
+out:
+	put_task_stack(p);
+	return ret;
 }
 
 unsigned long arch_align_stack(unsigned long sp)
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index d93d433..d84be9db 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -146,6 +146,7 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
 	 * We need to tell the secondary core where to find its stack and the
 	 * page tables.
 	 */
+	secondary_data.task = idle;
 	secondary_data.stack = task_stack_page(idle) + THREAD_START_SP;
 	update_cpu_boot_status(CPU_MMU_OFF);
 	__flush_dcache_area(&secondary_data, sizeof(secondary_data));
@@ -170,6 +171,7 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
 		pr_err("CPU%u: failed to boot: %d\n", cpu, ret);
 	}
 
+	secondary_data.task = NULL;
 	secondary_data.stack = NULL;
 	status = READ_ONCE(secondary_data.status);
 	if (ret && status) {
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index d9751a4..4e0efe8 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -157,6 +157,9 @@ void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 	struct stack_trace_data data;
 	struct stackframe frame;
 
+	if (!try_get_task_stack(tsk))
+		return;
+
 	data.trace = trace;
 	data.skip = trace->skip;
 
@@ -178,6 +181,8 @@ void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 	walk_stackframe(tsk, &frame, save_trace, &data);
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
+
+	put_task_stack(tsk);
 }
 
 void save_stack_trace(struct stack_trace *trace)
-- 
1.9.1
