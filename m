From: "Tobin C. Harding" <me@tobin.cc>
Date: Sun,  1 Oct 2017 11:06:46 +1100
Message-Id: <1506816410-10230-3-git-send-email-me@tobin.cc>
In-Reply-To: <1506816410-10230-1-git-send-email-me@tobin.cc>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [RFC V2 2/6] lib: vsprintf: whitelist stack traces
To: Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

Use the %pP functionality to explicitly allow kernel
pointers to be logged for stack traces.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 arch/arm64/kernel/traps.c | 4 ++--
 kernel/printk/printk.c    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 5ea4b85..fe09660 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -147,7 +147,7 @@ void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 	struct stackframe frame;
 	int skip;
 
-	pr_debug("%s(regs = %p tsk = %p)\n", __func__, regs, tsk);
+	pr_debug("%s(regs = %pP tsk = %pP)\n", __func__, regs, tsk);
 
 	if (!tsk)
 		tsk = current;
@@ -233,7 +233,7 @@ static int __die(const char *str, int err, struct pt_regs *regs)
 
 	print_modules();
 	__show_regs(regs);
-	pr_emerg("Process %.*s (pid: %d, stack limit = 0x%p)\n",
+	pr_emerg("Process %.*s (pid: %d, stack limit = 0x%pP)\n",
 		 TASK_COMM_LEN, tsk->comm, task_pid_nr(tsk),
 		 end_of_stack(tsk));
 
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 512f7c2..af0bc8e 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3142,7 +3142,7 @@ void show_regs_print_info(const char *log_lvl)
 {
 	dump_stack_print_info(log_lvl);
 
-	printk("%stask: %p task.stack: %p\n",
+	printk("%stask: %pP task.stack: %pP\n",
 	       log_lvl, current, task_stack_page(current));
 }
 
-- 
2.7.4
