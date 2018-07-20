From: Laura Abbott <labbott@redhat.com>
Subject: [PATCHv3 1/2] arm64: Add stack information to on_accessible_stack
Date: Fri, 20 Jul 2018 14:41:53 -0700
Message-Id: <20180720214154.2940-2-labbott@redhat.com>
In-Reply-To: <20180720214154.2940-1-labbott@redhat.com>
References: <20180720214154.2940-1-labbott@redhat.com>
To: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Laura Abbott <labbott@redhat.com>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>


In preparation for enabling the stackleak plugin on arm64,
we need a way to get the bounds of the current stack. Extend
on_accessible_stack to get this information.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Laura Abbott <labbott@redhat.com>
---
v3: Switched some logic to reduce if nesting
---
 arch/arm64/include/asm/sdei.h       |  9 ++--
 arch/arm64/include/asm/stacktrace.h | 73 ++++++++++++++++++++++++-----
 arch/arm64/kernel/ptrace.c          |  2 +-
 arch/arm64/kernel/sdei.c            | 51 ++++++++++++++++----
 arch/arm64/kernel/stacktrace.c      |  2 +-
 5 files changed, 112 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/include/asm/sdei.h b/arch/arm64/include/asm/sdei.h
index e073e6886685..ffe47d766c25 100644
--- a/arch/arm64/include/asm/sdei.h
+++ b/arch/arm64/include/asm/sdei.h
@@ -40,15 +40,18 @@ asmlinkage unsigned long __sdei_handler(struct pt_regs *regs,
 unsigned long sdei_arch_get_entry_point(int conduit);
 #define sdei_arch_get_entry_point(x)	sdei_arch_get_entry_point(x)
 
-bool _on_sdei_stack(unsigned long sp);
-static inline bool on_sdei_stack(unsigned long sp)
+struct stack_info;
+
+bool _on_sdei_stack(unsigned long sp, struct stack_info *info);
+static inline bool on_sdei_stack(unsigned long sp,
+				struct stack_info *info)
 {
 	if (!IS_ENABLED(CONFIG_VMAP_STACK))
 		return false;
 	if (!IS_ENABLED(CONFIG_ARM_SDE_INTERFACE))
 		return false;
 	if (in_nmi())
-		return _on_sdei_stack(sp);
+		return _on_sdei_stack(sp, info);
 
 	return false;
 }
diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index 902f9edacbea..e86737b7c924 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -32,6 +32,21 @@ struct stackframe {
 #endif
 };
 
+enum stack_type {
+	STACK_TYPE_UNKNOWN,
+	STACK_TYPE_TASK,
+	STACK_TYPE_IRQ,
+	STACK_TYPE_OVERFLOW,
+	STACK_TYPE_SDEI_NORMAL,
+	STACK_TYPE_SDEI_CRITICAL,
+};
+
+struct stack_info {
+	unsigned long low;
+	unsigned long high;
+	enum stack_type type;
+};
+
 extern int unwind_frame(struct task_struct *tsk, struct stackframe *frame);
 extern void walk_stackframe(struct task_struct *tsk, struct stackframe *frame,
 			    int (*fn)(struct stackframe *, void *), void *data);
@@ -39,7 +54,8 @@ extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk);
 
 DECLARE_PER_CPU(unsigned long *, irq_stack_ptr);
 
-static inline bool on_irq_stack(unsigned long sp)
+static inline bool on_irq_stack(unsigned long sp,
+				struct stack_info *info)
 {
 	unsigned long low = (unsigned long)raw_cpu_read(irq_stack_ptr);
 	unsigned long high = low + IRQ_STACK_SIZE;
@@ -47,46 +63,79 @@ static inline bool on_irq_stack(unsigned long sp)
 	if (!low)
 		return false;
 
-	return (low <= sp && sp < high);
+	if (sp < low || sp >= high)
+		return false;
+
+	if (info) {
+		info->low = low;
+		info->high = high;
+		info->type = STACK_TYPE_IRQ;
+	}
+
+	return true;
 }
 
-static inline bool on_task_stack(struct task_struct *tsk, unsigned long sp)
+static inline bool on_task_stack(struct task_struct *tsk, unsigned long sp,
+				struct stack_info *info)
 {
 	unsigned long low = (unsigned long)task_stack_page(tsk);
 	unsigned long high = low + THREAD_SIZE;
 
-	return (low <= sp && sp < high);
+	if (sp < low || sp >= high)
+		return false;
+
+	if (info) {
+		info->low = low;
+		info->high = high;
+		info->type = STACK_TYPE_TASK;
+	}
+
+	return true;
 }
 
 #ifdef CONFIG_VMAP_STACK
 DECLARE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack);
 
-static inline bool on_overflow_stack(unsigned long sp)
+static inline bool on_overflow_stack(unsigned long sp,
+				struct stack_info *info)
 {
 	unsigned long low = (unsigned long)raw_cpu_ptr(overflow_stack);
 	unsigned long high = low + OVERFLOW_STACK_SIZE;
 
-	return (low <= sp && sp < high);
+	if (sp < low || sp >= high)
+		return false;
+
+	if (info) {
+		info->low = low;
+		info->high = high;
+		info->type = STACK_TYPE_OVERFLOW;
+	}
+
+	return true;
 }
 #else
-static inline bool on_overflow_stack(unsigned long sp) { return false; }
+static inline bool on_overflow_stack(unsigned long sp,
+			struct stack_info *info) { return false; }
 #endif
 
+
 /*
  * We can only safely access per-cpu stacks from current in a non-preemptible
  * context.
  */
-static inline bool on_accessible_stack(struct task_struct *tsk, unsigned long sp)
+static inline bool on_accessible_stack(struct task_struct *tsk,
+					unsigned long sp,
+					struct stack_info *info)
 {
-	if (on_task_stack(tsk, sp))
+	if (on_task_stack(tsk, sp, info))
 		return true;
 	if (tsk != current || preemptible())
 		return false;
-	if (on_irq_stack(sp))
+	if (on_irq_stack(sp, info))
 		return true;
-	if (on_overflow_stack(sp))
+	if (on_overflow_stack(sp, info))
 		return true;
-	if (on_sdei_stack(sp))
+	if (on_sdei_stack(sp, info))
 		return true;
 
 	return false;
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 5c338ce5a7fa..cf94e1498ba6 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -132,7 +132,7 @@ static bool regs_within_kernel_stack(struct pt_regs *regs, unsigned long addr)
 {
 	return ((addr & ~(THREAD_SIZE - 1))  ==
 		(kernel_stack_pointer(regs) & ~(THREAD_SIZE - 1))) ||
-		on_irq_stack(addr);
+		on_irq_stack(addr, NULL);
 }
 
 /**
diff --git a/arch/arm64/kernel/sdei.c b/arch/arm64/kernel/sdei.c
index 6b8d90d5ceae..7154fee1cb2b 100644
--- a/arch/arm64/kernel/sdei.c
+++ b/arch/arm64/kernel/sdei.c
@@ -88,23 +88,58 @@ static int init_sdei_stacks(void)
 	return err;
 }
 
-bool _on_sdei_stack(unsigned long sp)
+bool on_sdei_normal_stack(unsigned long sp,
+			struct stack_info *info)
+{
+	unsigned long low = (unsigned long)raw_cpu_read(sdei_stack_normal_ptr);
+	unsigned long high = low + SDEI_STACK_SIZE;
+
+	if (sp < low || sp >= high)
+		return false;
+
+	if (info) {
+		info->low = low;
+		info->high = high;
+		info->type = STACK_TYPE_SDEI_NORMAL;
+	}
+
+	return true;
+}
+
+bool on_sdei_critical_stack(unsigned long sp,
+			struct stack_info *info)
+{
+	unsigned long low = (unsigned long)raw_cpu_read(sdei_stack_critical_ptr);
+	unsigned long high = low + SDEI_STACK_SIZE;
+
+	if (sp < low || sp >= high)
+		return false;
+
+	if (info) {
+		info->low = low;
+		info->high = high;
+		info->type = STACK_TYPE_SDEI_CRITICAL;
+	}
+
+	return true;
+}
+
+bool _on_sdei_stack(unsigned long sp,
+		unsigned long *stack_low,
+		unsigned long *stack_high)
 {
 	unsigned long low, high;
 
 	if (!IS_ENABLED(CONFIG_VMAP_STACK))
 		return false;
 
-	low = (unsigned long)raw_cpu_read(sdei_stack_critical_ptr);
-	high = low + SDEI_STACK_SIZE;
-
-	if (low <= sp && sp < high)
+	if (on_sdei_critical_stack(sp, info))
 		return true;
 
-	low = (unsigned long)raw_cpu_read(sdei_stack_normal_ptr);
-	high = low + SDEI_STACK_SIZE;
+	if (on_sdei_normal_stack(sp, info))
+		return true;
 
-	return (low <= sp && sp < high);
+	return false;
 }
 
 unsigned long sdei_arch_get_entry_point(int conduit)
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index d5718a060672..4989f7ea1e59 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -50,7 +50,7 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 	if (!tsk)
 		tsk = current;
 
-	if (!on_accessible_stack(tsk, fp))
+	if (!on_accessible_stack(tsk, fp, NULL))
 		return -EINVAL;
 
 	frame->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp));
-- 
2.17.1
