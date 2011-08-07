Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 7 Aug 2011 15:00:25 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110807110025.GA3778@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
Cc: Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Solar, Will, all -

The new sysctl is introduced, abi.bitness_locked.  If set to 1, it locks
all tasks inside of current pid namespace to the bitness of init task
(pid_ns->child_reaper).  After that (1) all syscalls of other bitness
return -ENOSYS and (2) loading ELF binaries of another bitness is
prohibited (as if the corresponding CONFIG_BINFMT_*=N).  If there is any
task which differs in bitness, the lockup fails.

TODO:

 * Fix a race of sysctl against fork().
 * Denied syscall should behave as if it doesn't exist.

The patch was tested very roughly.

diff --git a/arch/x86/kernel/syscall_restrict.c b/arch/x86/kernel/syscall_restrict.c
index 1a2bf1c..b2bfd8f 100644
--- a/arch/x86/kernel/syscall_restrict.c
+++ b/arch/x86/kernel/syscall_restrict.c
@@ -31,8 +31,8 @@ static int task_get_bitness(struct task_struct *task)
 static bool pidns_locked(struct pid_namespace *pid_ns)
 {
 	struct task_struct *init = pid_ns->child_reaper;
-	return (test_ti_thread_flag(task_thread_info(task), TIF_SYSCALL32_DENIED) ||
-		test_ti_thread_flag(task_thread_info(task), TIF_SYSCALL64_DENIED));
+	return (test_ti_thread_flag(task_thread_info(init), TIF_SYSCALL32_DENIED) ||
+		test_ti_thread_flag(task_thread_info(init), TIF_SYSCALL64_DENIED));
 }
 
 static int bits_to_flags(int bits)
@@ -69,7 +69,7 @@ static int __pidns_may_lock_bitness(struct pid_namespace *pid_ns, int bits)
 }
 
 /* Called with hold tasklist_lock and rcu */
-static int __change_syscall_restrict(struct pid_namespace *pid_ns, int bits)
+static int __bitness_lock(struct pid_namespace *pid_ns, int bits)
 {
 	u32 clear_bit_nr;
 	struct task_struct *p, *thread;
@@ -90,7 +90,7 @@ static int __change_syscall_restrict(struct pid_namespace *pid_ns, int bits)
 	return 0;
 }
 
-static int syscall_bitness_lock(struct pid_namespace *pid_ns)
+static int bitness_lock(struct pid_namespace *pid_ns)
 {
 	int rc, new_bits;
 
@@ -100,14 +100,14 @@ static int syscall_bitness_lock(struct pid_namespace *pid_ns)
 	new_bits = task_get_bitness(pid_ns->child_reaper);
 	rc = __pidns_may_lock_bitness(pid_ns, new_bits);
 	if (!rc)
-		rc = __change_syscall_restrict(pid_ns, new_bits);
+		rc = __bitness_lock(pid_ns, new_bits);
 
 	write_unlock_irq(&tasklist_lock);
 	rcu_read_unlock();
 	return rc;
 }
 
-static int syscall_bitness_locked_handler(struct ctl_table *table, int write,
+static int bitness_locked_handler(struct ctl_table *table, int write,
 				void __user *buffer, size_t *lenp,
 				loff_t *ppos)
 {
@@ -128,14 +128,14 @@ static int syscall_bitness_locked_handler(struct ctl_table *table, int write,
 		return -EACCES;
 	if (new_bits && old_bits)
 		return 0;
-	return syscall_bitness_lock(current->nsproxy->pid_ns);
+	return bitness_lock(current->nsproxy->pid_ns);
 }
 
 static struct ctl_table abi_syscall_restrict[] = {
 	{
-		.procname = "syscall_bitness_locked",
+		.procname = "bitness_locked",
 		.mode = 0644,
-		.proc_handler = syscall_bitness_locked_handler
+		.proc_handler = bitness_locked_handler
 	},
 	{}
 };
---
