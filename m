Reply-To: kernel-hardening@lists.openwall.com
From: Mark Rutland <mark.rutland@arm.com>
Date: Thu, 15 Sep 2016 14:49:07 +0100
Message-Id: <1473947349-14521-7-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1473947349-14521-1-git-send-email-mark.rutland@arm.com>
References: <1473947349-14521-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [RFC PATCH 6/8] arm64: traps: use task_struct instead of thread_info
To: linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, keescook@chromium.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, luto@kernel.org, mark.rutland@arm.com, suzuki.poulose@arm.com, takahiro.akashi@linaro.org, will.deacon@arm.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

In arm64's die and __die routines we pass around a thread_info, and
subsequently use this to determine either the relevant task_struct, or
the end of the thread's stack. This will shortly become problematic when
we move the thread_info out of the thread's stack.

Instead, pass around the task_struct, and use the new end_of_stack
helper, which will work regardless of where thread_info is located.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/kernel/traps.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index e04f838..e9409a9 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -227,10 +227,9 @@ void show_stack(struct task_struct *tsk, unsigned long *sp)
 #endif
 #define S_SMP " SMP"
 
-static int __die(const char *str, int err, struct thread_info *thread,
+static int __die(const char *str, int err, struct task_struct *tsk,
 		 struct pt_regs *regs)
 {
-	struct task_struct *tsk = thread->task;
 	static int die_counter;
 	int ret;
 
@@ -245,7 +244,8 @@ static int __die(const char *str, int err, struct thread_info *thread,
 	print_modules();
 	__show_regs(regs);
 	pr_emerg("Process %.*s (pid: %d, stack limit = 0x%p)\n",
-		 TASK_COMM_LEN, tsk->comm, task_pid_nr(tsk), thread + 1);
+		 TASK_COMM_LEN, tsk->comm, task_pid_nr(tsk),
+		 end_of_stack(tsk));
 
 	if (!user_mode(regs)) {
 		dump_mem(KERN_EMERG, "Stack: ", regs->sp,
@@ -264,7 +264,7 @@ static DEFINE_RAW_SPINLOCK(die_lock);
  */
 void die(const char *str, struct pt_regs *regs, int err)
 {
-	struct thread_info *thread = current_thread_info();
+	struct task_struct *tsk = current;
 	int ret;
 
 	oops_enter();
@@ -272,9 +272,9 @@ void die(const char *str, struct pt_regs *regs, int err)
 	raw_spin_lock_irq(&die_lock);
 	console_verbose();
 	bust_spinlocks(1);
-	ret = __die(str, err, thread, regs);
+	ret = __die(str, err, tsk, regs);
 
-	if (regs && kexec_should_crash(thread->task))
+	if (regs && kexec_should_crash(tsk))
 		crash_kexec(regs);
 
 	bust_spinlocks(0);
-- 
1.9.1
