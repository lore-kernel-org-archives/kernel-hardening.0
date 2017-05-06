Date: Fri, 5 May 2017 21:07:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170506040709.GC32707@kroah.com>
References: <20170506040641.GA32707@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170506040641.GA32707@kroah.com>
Subject: [kernel-hardening] [RFC 2/6] lib: vsprintf: whitelist stack traces
To: kernel-hardening@lists.openwall.com, Petr Mladek <pmladek@suse.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Dave Weinstein <olorin@google.com>

Use the %pP functionality to explicitly allow kernel
pointers to be logged for stack traces

Cc: William Roberts <william.c.roberts@intel.com>
Cc: Chris Fries <cfries@google.com>
Signed-off-by: Dave Weinstein <olorin@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/traps.c | 4 ++--
 include/linux/kallsyms.h  | 2 +-
 kernel/printk/printk.c    | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index e52be6aa44ee..b127be39011a 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -146,7 +146,7 @@ static void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 	unsigned long irq_stack_ptr;
 	int skip;
 
-	pr_debug("%s(regs = %p tsk = %p)\n", __func__, regs, tsk);
+	pr_debug("%s(regs = %pP tsk = %pP)\n", __func__, regs, tsk);
 
 	if (!tsk)
 		tsk = current;
@@ -252,7 +252,7 @@ static int __die(const char *str, int err, struct pt_regs *regs)
 
 	print_modules();
 	__show_regs(regs);
-	pr_emerg("Process %.*s (pid: %d, stack limit = 0x%p)\n",
+	pr_emerg("Process %.*s (pid: %d, stack limit = 0x%pP)\n",
 		 TASK_COMM_LEN, tsk->comm, task_pid_nr(tsk),
 		 end_of_stack(tsk));
 
diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 6883e197acb9..e4a205debe09 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -122,7 +122,7 @@ static inline void print_symbol(const char *fmt, unsigned long addr)
 
 static inline void print_ip_sym(unsigned long ip)
 {
-	printk("[<%p>] %pS\n", (void *) ip, (void *) ip);
+	printk("[<%pP>] %pS\n", (void *) ip, (void *) ip);
 }
 
 #endif /*_LINUX_KALLSYMS_H*/
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 2984fb0f0257..d32e84e3ab6b 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3110,7 +3110,7 @@ void show_regs_print_info(const char *log_lvl)
 {
 	dump_stack_print_info(log_lvl);
 
-	printk("%stask: %p task.stack: %p\n",
+	printk("%stask: %pP task.stack: %pP\n",
 	       log_lvl, current, task_stack_page(current));
 }
 
-- 
2.12.2
