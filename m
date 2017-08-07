From: Mark Rutland <mark.rutland@arm.com>
Date: Mon,  7 Aug 2017 19:35:57 +0100
Message-Id: <1502130965-18710-7-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1502130965-18710-1-git-send-email-mark.rutland@arm.com>
References: <1502130965-18710-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCH 06/14] arm64: clean up irq stack definitions
To: linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, labbott@redhat.com, linux-kernel@vger.kernel.org, luto@amacapital.net, mark.rutland@arm.com, matt@codeblueprint.co.uk, will.deacon@arm.com, kernel-hardening@lists.openwall.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Before we add yet another stack to the kernel, it would be nice to
ensure that we consistently organise stack definitions and related
helper functions.

This patch moves the basic IRQ stack defintions to <asm/memory.h> to
live with their task stack counterparts. Helpers used for unwinding are
moved into <asm/stacktrace.h>, where subsequent patches will add helpers
for other stacks. Includes are fixed up accordingly.

This patch is a pure refactoring -- there should be no functional
changes as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/irq.h        | 24 ------------------------
 arch/arm64/include/asm/memory.h     |  2 ++
 arch/arm64/include/asm/stacktrace.h | 25 ++++++++++++++++++++++++-
 arch/arm64/kernel/ptrace.c          |  1 +
 4 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/include/asm/irq.h b/arch/arm64/include/asm/irq.h
index 1ebe202..5e6f772 100644
--- a/arch/arm64/include/asm/irq.h
+++ b/arch/arm64/include/asm/irq.h
@@ -1,20 +1,12 @@
 #ifndef __ASM_IRQ_H
 #define __ASM_IRQ_H
 
-#define IRQ_STACK_SIZE			THREAD_SIZE
-
 #ifndef __ASSEMBLER__
 
-#include <linux/percpu.h>
-#include <linux/sched/task_stack.h>
-
 #include <asm-generic/irq.h>
-#include <asm/thread_info.h>
 
 struct pt_regs;
 
-DECLARE_PER_CPU(unsigned long [IRQ_STACK_SIZE/sizeof(long)], irq_stack);
-
 extern void set_handle_irq(void (*handle_irq)(struct pt_regs *));
 
 static inline int nr_legacy_irqs(void)
@@ -22,21 +14,5 @@ static inline int nr_legacy_irqs(void)
 	return 0;
 }
 
-static inline bool on_irq_stack(unsigned long sp)
-{
-	unsigned long low = (unsigned long)raw_cpu_ptr(irq_stack);
-	unsigned long high = low + IRQ_STACK_SIZE;
-
-	return (low <= sp && sp < high);
-}
-
-static inline bool on_task_stack(struct task_struct *tsk, unsigned long sp)
-{
-	unsigned long low = (unsigned long)task_stack_page(tsk);
-	unsigned long high = low + THREAD_SIZE;
-
-	return (low <= sp && sp < high);
-}
-
 #endif /* !__ASSEMBLER__ */
 #endif
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 8ab4774..1fc2453 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -110,6 +110,8 @@
 
 #define THREAD_SIZE		(UL(1) << THREAD_SHIFT)
 
+#define IRQ_STACK_SIZE		THREAD_SIZE
+
 /*
  * Memory types available.
  */
diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index 3bebab3..000e2418 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -16,7 +16,12 @@
 #ifndef __ASM_STACKTRACE_H
 #define __ASM_STACKTRACE_H
 
-struct task_struct;
+#include <linux/percpu.h>
+#include <linux/sched.h>
+#include <linux/sched/task_stack.h>
+
+#include <asm/memory.h>
+#include <asm/ptrace.h>
 
 struct stackframe {
 	unsigned long fp;
@@ -31,4 +36,22 @@ extern void walk_stackframe(struct task_struct *tsk, struct stackframe *frame,
 			    int (*fn)(struct stackframe *, void *), void *data);
 extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk);
 
+DECLARE_PER_CPU(unsigned long [IRQ_STACK_SIZE/sizeof(long)], irq_stack);
+
+static inline bool on_irq_stack(unsigned long sp)
+{
+	unsigned long low = (unsigned long)raw_cpu_ptr(irq_stack);
+	unsigned long high = low + IRQ_STACK_SIZE;
+
+	return (low <= sp && sp < high);
+}
+
+static inline bool on_task_stack(struct task_struct *tsk, unsigned long sp)
+{
+	unsigned long low = (unsigned long)task_stack_page(tsk);
+	unsigned long high = low + THREAD_SIZE;
+
+	return (low <= sp && sp < high);
+}
+
 #endif	/* __ASM_STACKTRACE_H */
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index baf0838..a9f8715 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -42,6 +42,7 @@
 #include <asm/compat.h>
 #include <asm/debug-monitors.h>
 #include <asm/pgtable.h>
+#include <asm/stacktrace.h>
 #include <asm/syscall.h>
 #include <asm/traps.h>
 #include <asm/system_misc.h>
-- 
1.9.1
