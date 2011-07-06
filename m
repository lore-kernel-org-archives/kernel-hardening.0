Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 6 Jul 2011 20:34:14 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110706163412.GA4743@albatros>
References: <20110703103925.GA2283@albatros>
 <CA+55aFwfr-oAa-2L9O_rd9iZDyVr0b+gFQS=_R5PUxmhh3JEsg@mail.gmail.com>
 <20110704201339.GA5645@albatros>
 <20110705141301.0d3594e0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110705141301.0d3594e0.akpm@linux-foundation.org>
Subject: [kernel-hardening] [PATCH v3] proc: fix a race in do_io_accounting()
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, rientjes@google.com, wilsons@start.ca, security@kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

If inode's mode permits to open /proc/PID/io and the resulted file
descriptor is kept across execve() of setuid or similar binary, the
ptrace_may_access() check tries to prevent using this fd against the
task with escalated privileges.  Unfortunately, there is a race of the
check against execve().  If execve() is processed after the ptrace
check, but before the actual io information gathering, io statistics
will be gathered from the privileged process.  At least in theory this
might lead to gathering sensible information (like ssh/ftp password
length) that wouldn't be available otherwise.

Holding task->signal->cred_guard_mutex while gathering the io
information should protect against the race.

The order of locking is similar to the one inside of
ptrace_attach(): first goes cred_guard_mutex, then lock_task_sighand().

v3 - better description.
v2 - use mutex_lock_killable() instead of mutex_lock().

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: stable@kernel.org
---
 fs/proc/base.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 083a4f2..4b9f159 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2711,9 +2711,16 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 {
 	struct task_io_accounting acct = task->ioac;
 	unsigned long flags;
+	int result;
 
-	if (!ptrace_may_access(task, PTRACE_MODE_READ))
-		return -EACCES;
+	result = mutex_lock_killable(&task->signal->cred_guard_mutex);
+	if (result)
+		return result;
+
+	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
+		result = -EACCES;
+		goto out_unlock;
+	}
 
 	if (whole && lock_task_sighand(task, &flags)) {
 		struct task_struct *t = task;
@@ -2724,7 +2731,7 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 
 		unlock_task_sighand(task, &flags);
 	}
-	return sprintf(buffer,
+	result = sprintf(buffer,
 			"rchar: %llu\n"
 			"wchar: %llu\n"
 			"syscr: %llu\n"
@@ -2739,6 +2746,9 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
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
