Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Tue, 24 Jul 2012 16:29:02 +0100
Message-Id: <1343143742-31229-3-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1343143742-31229-1-git-send-email-tixxdz@opendz.org>
References: <1343143742-31229-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH v2 2/2] proc: do not allow negative offsets on /proc/<pid>/environ
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Vasiliy Kulikov <segoon@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Solar Designer <solar@openwall.com>, Kees Cook <keescook@chromium.org>, David Rientjes <rientjes@google.com>, Brad Spengler <spender@grsecurity.net>
Cc: Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

__mem_open() which is called by both /proc/<pid>/environ and
/proc/<pid>/mem ->open() handlers will allow the use of negative offsets.
/proc/<pid>/mem has negative offsets but not /proc/<pid>/environ.

Clean this by moving the 'force FMODE_UNSIGNED_OFFSET flag' to mem_open()
to allow negative offsets only on /proc/<pid>/mem.

Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 39ee093..1b6c84c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -695,8 +695,6 @@ static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
 		mmput(mm);
 	}
 
-	/* OK to pass negative loff_t, we can catch out-of-range */
-	file->f_mode |= FMODE_UNSIGNED_OFFSET;
 	file->private_data = mm;
 
 	return 0;
@@ -704,7 +702,12 @@ static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
 
 static int mem_open(struct inode *inode, struct file *file)
 {
-	return __mem_open(inode, file, PTRACE_MODE_ATTACH);
+	int ret = __mem_open(inode, file, PTRACE_MODE_ATTACH);
+
+	/* OK to pass negative loff_t, we can catch out-of-range */
+	file->f_mode |= FMODE_UNSIGNED_OFFSET;
+
+	return ret;
 }
 
 static ssize_t mem_rw(struct file *file, char __user *buf,
-- 
1.7.1
