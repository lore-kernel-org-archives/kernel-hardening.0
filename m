Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Wed, 25 Sep 2013 21:14:40 +0100
Message-Id: <1380140085-29712-8-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1380140085-29712-1-git-send-email-tixxdz@opendz.org>
References: <1380140085-29712-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH 07/12] procfs: add permission checks on the file's opener of /proc/*/stack
To: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: tixxdz@gmail.com, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

/proc file descriptors can be passed to a more privileged process
(e.g. a suid-exec) which will pass the classic ptrace_may_access()
permission check during read().

Use proc_same_open_cred() to detect if the cred of current between
->open() and ->read() have changed, if so then call proc_allow_access()
to check if the original file's opener had enough privileges to access
the /proc's task entries during ->read().
The file's opener cred are obtained by seq_f_cred() on seq_file struct.

The ptrace_may_access() + proc_allow_access() check is performed during
->read() time, where the ptrace_may_access() check should also be
performed during ->open(), however currently this is not the case.

This is due to /procfs ONE files that share the same ->open() function
proc_single_open(). Adding the ptrace_may_access() check to
proc_single_open() might break userspace from accessing other ONE files
like /proc/*/stat and /proc/*/statm.

So just perform the checks during ->read() and if current's cred have
changed, then check the file's opener cred with proc_allow_access().
This will block passing the file descriptor to a more privileged
process (e.g. a suid-exec).

Cc: Kees Cook <keescook@chromium.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index bb90171..d6a17b3 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -402,6 +402,8 @@ static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
 	unsigned long *entries;
 	int err;
 	int i;
+	int same_cred;
+	const struct cred *fcred = seq_f_cred(m);
 
 	entries = kmalloc(MAX_STACK_TRACE_DEPTH * sizeof(*entries), GFP_KERNEL);
 	if (!entries)
@@ -412,18 +414,28 @@ static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
 	trace.entries		= entries;
 	trace.skip		= 0;
 
+	same_cred = proc_same_open_cred(fcred);
+
 	err = lock_trace(task);
-	if (!err) {
-		save_stack_trace_tsk(task, &trace);
+	if (err)
+		goto free;
 
-		for (i = 0; i < trace.nr_entries; i++) {
-			seq_printf(m, "[<%pK>] %pS\n",
-				   (void *)entries[i], (void *)entries[i]);
-		}
+	if (!same_cred && !proc_allow_access(fcred, task, PTRACE_MODE_ATTACH)) {
+		err = -EPERM;
 		unlock_trace(task);
+		goto free;
 	}
-	kfree(entries);
 
+	save_stack_trace_tsk(task, &trace);
+	unlock_trace(task);
+
+	for (i = 0; i < trace.nr_entries; i++) {
+		seq_printf(m, "[<%pK>] %pS\n",
+			   (void *)entries[i], (void *)entries[i]);
+	}
+
+free:
+	kfree(entries);
 	return err;
 }
 #endif
-- 
1.7.11.7
