Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Tue, 24 Jul 2012 16:29:01 +0100
Message-Id: <1343143742-31229-2-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1343143742-31229-1-git-send-email-tixxdz@opendz.org>
References: <1343143742-31229-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH v2 1/2] proc: environ_read() make sure offset points to environment address range
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Vasiliy Kulikov <segoon@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Solar Designer <solar@openwall.com>, Kees Cook <keescook@chromium.org>, David Rientjes <rientjes@google.com>, Brad Spengler <spender@grsecurity.net>
Cc: Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

Currently the following offset and environment address range check in
environ_read() of /proc/<pid>/environ is buggy:

int this_len = mm->env_end - (mm->env_start + src);
if (this_len <= 0)
	break;

Large or negative offsets on /proc/<pid>/environ converted to 'unsigned
long' may pass this check since '(mm->env_start + src)' can overflow and
'this_len' will be positive.

This can turn /proc/<pid>/environ to act like /proc/<pid>/mem since
(mm->env_start + src) will point and read from another VMA.

There are two fixes here plus some code cleaning:
1) Fix the overflow by checking if the offset that was converted to
unsigned long will always point to the [mm->env_start, mm->env_end] address
range.

2) Remove the truncation that was made to the result of the check, storing
the result in 'int this_len' will alter its value and we can not depend on
it.

For kernels that have commit b409e578d9a4ec95913e06d8f which adds the
appropriate ptrace check and saves the 'mm' at ->open() time, this is not
a security issue.

This patch is taken from the grsecurity patch since it was just made
available.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 2772208..39ee093 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -827,15 +827,16 @@ static ssize_t environ_read(struct file *file, char __user *buf,
 	if (!atomic_inc_not_zero(&mm->mm_users))
 		goto free;
 	while (count > 0) {
-		int this_len, retval, max_len;
+		size_t this_len, max_len;
+		int retval;
 
-		this_len = mm->env_end - (mm->env_start + src);
-
-		if (this_len <= 0)
+		if (src >= (mm->env_end - mm->env_start))
 			break;
 
-		max_len = (count > PAGE_SIZE) ? PAGE_SIZE : count;
-		this_len = (this_len > max_len) ? max_len : this_len;
+		this_len = mm->env_end - (mm->env_start + src);
+
+		max_len = min_t(size_t, PAGE_SIZE, count);
+		this_len = min(max_len, this_len);
 
 		retval = access_remote_vm(mm, (mm->env_start + src),
 			page, this_len, 0);
-- 
1.7.1
