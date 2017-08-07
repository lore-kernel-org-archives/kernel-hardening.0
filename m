From: Mark Rutland <mark.rutland@arm.com>
Date: Mon,  7 Aug 2017 19:36:04 +0100
Message-Id: <1502130965-18710-14-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1502130965-18710-1-git-send-email-mark.rutland@arm.com>
References: <1502130965-18710-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCH 13/14] arm64: add on_accessible_stack()
To: linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, labbott@redhat.com, linux-kernel@vger.kernel.org, luto@amacapital.net, mark.rutland@arm.com, matt@codeblueprint.co.uk, will.deacon@arm.com, kernel-hardening@lists.openwall.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Both unwind_frame() and dump_backtrace() try to check whether a stack
address is sane to access, with very similar logic. Both will need
updating in order to handle overflow stacks.

Factor out this logic into a helper, so that we can avoid further
duplication when we add overflow stacks.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/stacktrace.h | 16 ++++++++++++++++
 arch/arm64/kernel/stacktrace.c      |  7 +------
 arch/arm64/kernel/traps.c           |  3 +--
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index 4c68d8a..92ddb6d 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -57,4 +57,20 @@ static inline bool on_task_stack(struct task_struct *tsk, unsigned long sp)
 	return (low <= sp && sp < high);
 }
 
+/*
+ * We can only safely access per-cpu stacks from current in a non-preemptible
+ * context.
+ */
+static inline bool on_accessible_stack(struct task_struct *tsk, unsigned long sp)
+{
+	if (on_task_stack(tsk, sp))
+		return true;
+	if (tsk != current || preemptible())
+		return false;
+	if (on_irq_stack(sp))
+		return true;
+
+	return false;
+}
+
 #endif	/* __ASM_STACKTRACE_H */
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 54f3463..d9b80eb 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -50,12 +50,7 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 	if (!tsk)
 		tsk = current;
 
-	/*
-	 * Switching between stacks is valid when tracing current and in
-	 * non-preemptible context.
-	 */
-	if (!(tsk == current && !preemptible() && on_irq_stack(fp)) &&
-	    !on_task_stack(tsk, fp))
+	if (!on_accessible_stack(tsk, fp))
 		return -EINVAL;
 
 	frame->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp));
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 9633773..d01c598 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -193,8 +193,7 @@ void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 		if (in_entry_text(frame.pc)) {
 			stack = frame.fp - offsetof(struct pt_regs, stackframe);
 
-			if (on_task_stack(tsk, stack) ||
-			    (tsk == current && !preemptible() && on_irq_stack(stack)))
+			if (on_accessible_stack(tsk, stack))
 				dump_mem("", "Exception stack", stack,
 					 stack + sizeof(struct pt_regs));
 		}
-- 
1.9.1
