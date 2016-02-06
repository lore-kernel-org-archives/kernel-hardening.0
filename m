Reply-To: kernel-hardening@lists.openwall.com
From: Scott Bauer <sbauer@eng.utah.edu>
Date: Sat,  6 Feb 2016 16:39:23 -0700
Message-Id: <1454801964-50385-2-git-send-email-sbauer@eng.utah.edu>
In-Reply-To: <1454801964-50385-1-git-send-email-sbauer@eng.utah.edu>
References: <1454801964-50385-1-git-send-email-sbauer@eng.utah.edu>
Subject: [kernel-hardening] [PATCHv2  1/2] SROP Mitigation: Architecture independent code for signal cookies
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, x86@kernel.org, ak@linux.intel.com, luto@amacapital.net, mingo@redhat.com, tglx@linutronix.de, Scott Bauer <sbauer@eng.utah.edu>, Abhiram Balasubramanian <abhiram@cs.utah.edu>
List-ID: <kernel-hardening.lists.openwall.com>

This patch adds a per-process secret to the task struct which
will be used during signal delivery and during a sigreturn.
Also, logic is added in signal.c to generate, place, extract,
clear and verify the signal cookie.

Cc: Abhiram Balasubramanian <abhiram@cs.utah.edu>
Signed-off-by: Scott Bauer <sbauer@eng.utah.edu>
---
 fs/exec.c              |  3 +++
 include/linux/sched.h  |  7 +++++++
 include/linux/signal.h |  2 ++
 kernel/signal.c        | 43 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 55 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index dcd4ac7..3de0a32 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -56,6 +56,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/oom.h>
 #include <linux/compat.h>
+#include <linux/random.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1135,6 +1136,8 @@ void setup_new_exec(struct linux_binprm * bprm)
 	/* This is the point of no return */
 	current->sas_ss_sp = current->sas_ss_size = 0;
 
+	get_random_bytes(&current->sig_cookie, sizeof(current->sig_cookie));
+
 	if (uid_eq(current_euid(), current_uid()) && gid_eq(current_egid(), current_gid()))
 		set_dumpable(current->mm, SUID_DUMP_USER);
 	else
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a10494a..556162f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1497,6 +1497,13 @@ struct task_struct {
 	unsigned long stack_canary;
 #endif
 	/*
+	 * Canary value for signal frames placed on user stack.
+	 * This helps mitigate "Signal Return oriented program"
+	 * exploits in userland.
+	 */
+	unsigned long sig_cookie;
+
+	/*
 	 * pointers to (original) parent process, youngest child, younger sibling,
 	 * older sibling, respectively.  (p->father can be replaced with
 	 * p->real_parent->pid)
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 92557bb..fae0618 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -280,6 +280,8 @@ extern int get_signal(struct ksignal *ksig);
 extern void signal_setup_done(int failed, struct ksignal *ksig, int stepping);
 extern void exit_signals(struct task_struct *tsk);
 extern void kernel_sigaction(int, __sighandler_t);
+extern int set_sigcookie(unsigned long __user *location);
+extern int verify_clear_sigcookie(unsigned long __user *sig_cookie_ptr);
 
 static inline void allow_signal(int sig)
 {
diff --git a/kernel/signal.c b/kernel/signal.c
index 0508544..c3d0503 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2430,6 +2430,49 @@ out:
 	}
 }
 
+static unsigned long gen_sigcookie(unsigned long __user *location)
+{
+
+	unsigned long sig_cookie;
+	sig_cookie = (unsigned long) location ^ current->sig_cookie;
+
+	return sig_cookie;
+}
+
+int set_sigcookie(unsigned long __user *location)
+{
+
+	unsigned long sig_cookie = gen_sigcookie(location);
+
+	return put_user(sig_cookie, location);
+}
+
+int verify_clear_sigcookie(unsigned long __user *sig_cookie_ptr)
+{
+	unsigned long user_cookie;
+	unsigned long calculated_cookie;
+
+	if (!access_ok(VERIFY_WRITE, sig_cookie_ptr, sizeof(*sig_cookie_ptr)))
+		return 1;
+
+	if (get_user(user_cookie, sig_cookie_ptr))
+		return 1;
+
+	calculated_cookie = gen_sigcookie(sig_cookie_ptr);
+
+	if (user_cookie != calculated_cookie) {
+		pr_warn("Signal protector does not match what kernel set it to"\
+			". Possible exploit attempt or buggy program!\n");
+		return 1;
+
+	}
+
+	user_cookie = 0;
+	return put_user(user_cookie, sig_cookie_ptr)
+}
+
+EXPORT_SYMBOL(verify_clear_sigcookie);
+EXPORT_SYMBOL(set_sigcookie);
 EXPORT_SYMBOL(recalc_sigpending);
 EXPORT_SYMBOL_GPL(dequeue_signal);
 EXPORT_SYMBOL(flush_signals);
-- 
1.9.1
