Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 2 Sep 2011 20:48:41 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
Message-ID: <20110902164841.GA3818@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] proc: fix task_struct leak in proc_pid_fd_link_getattr()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-hardening@lists.openwall.com, Cyrill Gorcunov <gorcunov@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, David Rientjes <rientjes@google.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

In the patch "proc: fix races against execve() of /proc/PID/fd**"
proc_pid_fd_link_getattr() leaked task_struct if ptrace check fails.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Reported-by: Cyrill Gorcunov <gorcunov@gmail.com>
--
 fs/proc/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index b65bd88..d44c701 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1681,9 +1681,9 @@ static int proc_pid_fd_link_getattr(struct vfsmount *mnt, struct dentry *dentry,
 
 	generic_fillattr(inode, stat);
 	unlock_trace(task);
-	put_task_struct(task);
 	rc = 0;
 out_task:
+	put_task_struct(task);
 	return rc;
 }
 
-- 
Vasiliy
