Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Wed, 25 Sep 2013 21:14:36 +0100
Message-Id: <1380140085-29712-4-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1380140085-29712-1-git-send-email-tixxdz@opendz.org>
References: <1380140085-29712-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH 03/12] procfs: Document the proposed solution to protect procfs entries
To: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: tixxdz@gmail.com, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

Note the proposed solution to protect sensitive procfs entries as
code comment.

Cc: Kees Cook <keescook@chromium.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index c29eeae..8d21316 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -102,6 +102,17 @@
  *
  *	The classic example of a problem is opening file descriptors
  *	in /proc for a task before it execs a suid executable.
+ *
+ * Solution for sensitive files:
+ *	At each system call: open(),read(),write()... Perform the
+ *	ptrace_may_access() check.
+ *
+ *	After open() and during each system call: read(),write()...
+ *	If the cred of current have changed then perform the
+ *	proc_allow_access() check after the ptrace_may_access() one.
+ *
+ *	This way we can determine if current has gained more privileges
+ *	by execs a suid executable.
  */
 
 struct pid_entry {
-- 
1.7.11.7
