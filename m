Reply-To: kernel-hardening@lists.openwall.com
From: Scott Bauer <sbauer@eng.utah.edu>
Date: Tue, 29 Mar 2016 13:53:26 -0600
Message-Id: <1459281207-24377-4-git-send-email-sbauer@eng.utah.edu>
In-Reply-To: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
References: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
Subject: [kernel-hardening] [PATCH v4 3/4] Sysctl: SROP Mitigation: Add Sysctl argument to disable SROP.
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, x86@kernel.org, ak@linux.intel.com, luto@amacapital.net, mingo@redhat.com, tglx@linutronix.de, wmealing@redhat.com, torvalds@linux-foundation.org, Scott Bauer <sbauer@eng.utah.edu>, Abhiram Balasubramanian <abhiram@cs.utah.edu>, Scott Bauer <sbauer@plzdonthack.me>
List-ID: <kernel-hardening.lists.openwall.com>

This patch adds a sysctl argument to disable SROP protection.

Cc: Abhiram Balasubramanian <abhiram@cs.utah.edu>
Signed-off-by: Scott Bauer <sbauer@plzdonthack.me>
Signed-off-by: Scott Bauer <sbauer@eng.utah.edu>
---
 include/linux/signal.h |  1 +
 kernel/signal.c        | 13 +++++++++++--
 kernel/sysctl.c        |  8 ++++++++
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/signal.h b/include/linux/signal.h
index fae0618..cd7f152 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -9,6 +9,7 @@ struct task_struct;
 
 /* for sysctl */
 extern int print_fatal_signals;
+extern int srop_disabled;
 /*
  * Real Time signals may be queued.
  */
diff --git a/kernel/signal.c b/kernel/signal.c
index 1e4f65c..fbe61d6 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -52,6 +52,7 @@
 static struct kmem_cache *sigqueue_cachep;
 
 int print_fatal_signals __read_mostly;
+int srop_disabled __read_mostly;
 
 static void __user *sig_handler(struct task_struct *t, int sig)
 {
@@ -2452,18 +2453,26 @@ int verify_clear_sigcookie(unsigned long __user *sig_cookie_ptr)
 	unsigned long user_cookie;
 	unsigned long calculated_cookie;
 
+	if (srop_disabled)
+		goto out;
+
 	if (get_user(user_cookie, sig_cookie_ptr))
 		return 1;
 
 	calculated_cookie = gen_sigcookie(sig_cookie_ptr);
 
 	if (user_cookie != calculated_cookie) {
-		pr_warn("Signal protector does not match what kernel set it to"\
-			". Possible exploit attempt or buggy program!\n");
+		pr_warn("kernel/signal.c: Signal protector does not match what"\
+			" kernel set it to.\n"				\
+			"Possible exploit attempt or buggy program!\nIf you"\
+			" believe this is an error you can disable SROP "\
+			" Protection by #echo 1 > /proc/sys/kernel/"\
+			"disable-srop-protection\n");
 		return 1;
 
 	}
 
+out:
 	user_cookie = 0;
 	return put_user(user_cookie, sig_cookie_ptr);
 }
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 725587f..7886634 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -536,6 +536,14 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "disable-srop-protection",
+		.data		= &srop_disabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+
+	},
 #ifdef CONFIG_SPARC
 	{
 		.procname	= "reboot-cmd",
-- 
1.9.1
