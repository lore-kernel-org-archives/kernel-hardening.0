Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <5254A034.5020700@gmail.com>
Date: Wed, 09 Oct 2013 11:15:48 +1100
From: Ryan Mallon <rmallon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v2] vsprintf: Check real user/group id for %pK
To: Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com, Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com, Joe Perches <joe@perches.com>, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Kees Cook <keescook@chromium.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, George Spelvin <linux@horizon.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Some setuid binaries will allow reading of files which have read
permission by the real user id. This is problematic with files which
use %pK because the file access permission is checked at open() time,
but the kptr_restrict setting is checked at read() time. If a setuid
binary opens a %pK file as an unprivileged user, and then elevates
permissions before reading the file, then kernel pointer values may be
leaked.
    
This happens for example with the setuid pppd application on Ubuntu 12.04:
    
  $ head -1 /proc/kallsyms
  00000000 T startup_32
    
  $ pppd file /proc/kallsyms
  pppd: In file /proc/kallsyms: unrecognized option 'c1000000'
    
This will only leak the pointer value from the first line, but other
setuid binaries may leak more information.
    
Fix this by adding a check that in addition to the current process
having CAP_SYSLOG, that effective user and group ids are equal to the
real ids. If a setuid binary reads the contents of a file which uses
%pK then the pointer values will be printed as NULL if the real user
is unprivileged.
    
Signed-off-by: Ryan Mallon <rmallon@gmail.com>
---
Changes since v1:

 * Fix the description to say 'vsprintf' instead of 'printk'.
 * Clarify the open() vs read() time checks in the patch description and
code comment.
 * Remove comment about 'badly written' setuid binaries. This occurs
with setuids binaries which correctly handle opening files.
 * Added extra people to the Cc list.
---

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 26559bd..c02faf3 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1312,10 +1312,26 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 				spec.field_width = default_width;
 			return string(buf, end, "pK-error", spec);
 		}
-		if (!((kptr_restrict == 0) ||
-		      (kptr_restrict == 1 &&
-		       has_capability_noaudit(current, CAP_SYSLOG))))
-			ptr = NULL;
+
+		/*
+		 * If kptr_restrict is set to 2, then %pK always prints as
+		 * NULL. If it is set to 1, then only print the real pointer
+		 * value if the current proccess has CAP_SYSLOG and is running
+		 * with the same credentials it started with. This is because
+		 * access to files is checked at open() time, but %pK checks
+		 * permission at read() time. We don't want to leak pointer
+		 * values if a binary opens a file using %pK and then elevates
+		 * privileges before reading it.
+		 */
+		{
+			const struct cred *cred = current_cred();
+
+			if (kptr_restrict == 2 || (kptr_restrict == 1 &&
+			     (!has_capability_noaudit(current, CAP_SYSLOG) ||
+			      !uid_eq(cred->euid, cred->uid) ||
+			      !gid_eq(cred->egid, cred->gid))))
+				ptr = NULL;
+		}
 		break;
 	case 'N':
 		switch (fmt[1]) {
