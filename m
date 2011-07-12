Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 12 Jul 2011 17:27:23 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110712132723.GA3193@albatros>
References: <20110612130953.GA3709@albatros>
 <20110706173631.GA5431@albatros>
 <CA+55aFyfjG1h2zkkGai_VPM8p5bhWhvNXs1HvuWMgxv4RSywYw@mail.gmail.com>
 <20110706185932.GB3299@albatros>
 <20110707075610.GA3411@albatros>
 <20110707081930.GA4393@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707081930.GA4393@albatros>
Subject: [kernel-hardening] [PATCH] move RLIMIT_NPROC check from set_user() to
 do_execve_common()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, kernel-hardening@lists.openwall.com, Jiri Slaby <jslaby@suse.cz>, James Morris <jmorris@namei.org>, Neil Brown <neilb@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

The patch http://lkml.org/lkml/2003/7/13/226 introduced a RLIMIT_NPROC
check in set_user() to check for NPROC exceeding via setuid() and
similar functions.  Before the check there was a possibility to greatly
exceed the allowed number of processes by an unprivileged user if the
program relied on rlimit only.  But the check created new security
threat: many poorly written programs simply don't check setuid() return
code and believe it cannot fail if executed with root privileges.  So,
the check is removed in this patch because of too often privilege
escalations related to buggy programs.

The NPROC can still be enforced in the common code flow of daemons
spawning user processes.  Most of daemons do fork()+setuid()+execve().
The check introduced in execve() enforces the same limit as in setuid()
and doesn't create similar security issues.

Similar check was introduced in -ow patches.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 fs/exec.c    |   13 +++++++++++++
 kernel/sys.c |    6 ------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index ea5f748..0baf5c9 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1436,6 +1436,19 @@ static int do_execve_common(const char *filename,
 	struct files_struct *displaced;
 	bool clear_in_exec;
 	int retval;
+	const struct cred *cred = current_cred();
+
+	/*
+	 * We check for RLIMIT_NPROC in execve() instead of set_user() because
+	 * too many poorly written programs don't check setuid() return code.
+	 * The check in execve() does the same thing for programs doing
+	 * setuid()+execve(), but without similar security issues.
+	 */
+	if (atomic_read(&cred->user->processes) > rlimit(RLIMIT_NPROC) &&
+	    cred->user != INIT_USER) {
+		retval = -EAGAIN;
+		goto out_ret;
+	}
 
 	retval = unshare_files(&displaced);
 	if (retval)
diff --git a/kernel/sys.c b/kernel/sys.c
index e4128b2..0e7509a 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -591,12 +591,6 @@ static int set_user(struct cred *new)
 	if (!new_user)
 		return -EAGAIN;
 
-	if (atomic_read(&new_user->processes) >= rlimit(RLIMIT_NPROC) &&
-			new_user != INIT_USER) {
-		free_uid(new_user);
-		return -EAGAIN;
-	}
-
 	free_uid(new->user);
 	new->user = new_user;
 	return 0;
-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
