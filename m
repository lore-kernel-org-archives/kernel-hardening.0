Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 3 Jul 2011 14:39:25 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110703103925.GA2283@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] proc: fix a race in do_io_accounting()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, viro@zeniv.linux.org.uk, rientjes@google.com, wilsons@start.ca, security@kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

There is a ptrace_may_access() check in do_io_accounting() to prevent
gathering information of setuid'ed and similar binaries.  However, there
is a race against execve().  Holding task->signal->cred_guard_mutex
while gathering the information should protect against the race.

The order of locking is similar to the one inside of
ptrace_attach(): first goes cred_guard_mutex, then lock_task_sighand().

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: stable@kernel.org
---
 fs/proc/base.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 083a4f2..c605ee1 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2711,9 +2711,12 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 {
 	struct task_io_accounting acct = task->ioac;
 	unsigned long flags;
+	int result = -EACCES;
+
+	mutex_lock(&task->signal->cred_guard_mutex);
 
 	if (!ptrace_may_access(task, PTRACE_MODE_READ))
-		return -EACCES;
+		goto out_unlock;
 
 	if (whole && lock_task_sighand(task, &flags)) {
 		struct task_struct *t = task;
@@ -2724,7 +2727,7 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 
 		unlock_task_sighand(task, &flags);
 	}
-	return sprintf(buffer,
+	result = sprintf(buffer,
 			"rchar: %llu\n"
 			"wchar: %llu\n"
 			"syscr: %llu\n"
@@ -2739,6 +2742,9 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 			(unsigned long long)acct.read_bytes,
 			(unsigned long long)acct.write_bytes,
 			(unsigned long long)acct.cancelled_write_bytes);
+out_unlock:
+	mutex_unlock(&task->signal->cred_guard_mutex);
+	return result;
 }
 
 static int proc_tid_io_accounting(struct task_struct *task, char *buffer)
-- 
1.7.0.4
