Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Wed, 25 Jul 2012 17:29:08 -0700
Message-Id: <1343262548-21743-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1343262548-21743-1-git-send-email-keescook@chromium.org>
References: <1343262548-21743-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 2/2] fs: add link restriction audit reporting
To: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Doug Ledford <dledford@redhat.com>, Joe Korty <joe.korty@ccur.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>, James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Adds audit messages for unexpected link restriction violations so that
system owners will have some sort of potentially actionable information
about misbehaving processes.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/namei.c            |    2 ++
 include/linux/audit.h |    4 ++++
 kernel/audit.c        |   21 +++++++++++++++++++++
 3 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index e5ad2db..cb3856f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -691,6 +691,7 @@ static inline int may_follow_link(struct path *link, struct nameidata *nd)
 		return 0;
 
 	path_put(&nd->path);
+	audit_log_link_denied("follow_link", link);
 	return -EACCES;
 }
 
@@ -759,6 +760,7 @@ static int may_linkat(struct path *link)
 	    capable(CAP_FOWNER))
 		return 0;
 
+	audit_log_link_denied("linkat", link);
 	return -EPERM;
 }
 
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 22f292a..36abf2a 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -130,6 +130,7 @@
 #define AUDIT_LAST_KERN_ANOM_MSG    1799
 #define AUDIT_ANOM_PROMISCUOUS      1700 /* Device changed promiscuous mode */
 #define AUDIT_ANOM_ABEND            1701 /* Process ended abnormally */
+#define AUDIT_ANOM_LINK		    1702 /* Suspicious use of file links */
 #define AUDIT_INTEGRITY_DATA	    1800 /* Data integrity verification */
 #define AUDIT_INTEGRITY_METADATA    1801 /* Metadata integrity verification */
 #define AUDIT_INTEGRITY_STATUS	    1802 /* Integrity enable status */
@@ -687,6 +688,8 @@ extern void		    audit_log_d_path(struct audit_buffer *ab,
 					     const struct path *path);
 extern void		    audit_log_key(struct audit_buffer *ab,
 					  char *key);
+extern void		    audit_log_link_denied(const char *operation,
+						  struct path *link);
 extern void		    audit_log_lost(const char *message);
 #ifdef CONFIG_SECURITY
 extern void 		    audit_log_secctx(struct audit_buffer *ab, u32 secid);
@@ -716,6 +719,7 @@ extern int audit_enabled;
 #define audit_log_untrustedstring(a,s) do { ; } while (0)
 #define audit_log_d_path(b, p, d) do { ; } while (0)
 #define audit_log_key(b, k) do { ; } while (0)
+#define audit_log_link_denied(o, l) do { ; } while (0)
 #define audit_log_secctx(b,s) do { ; } while (0)
 #define audit_enabled 0
 #endif
diff --git a/kernel/audit.c b/kernel/audit.c
index 4a3f28d..ea3b7b6 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1456,6 +1456,27 @@ void audit_log_key(struct audit_buffer *ab, char *key)
 }
 
 /**
+ * audit_log_link_denied - report a link restriction denial
+ * @operation: specific link opreation
+ * @link: the path that triggered the restriction
+ */
+void audit_log_link_denied(const char *operation, struct path *link)
+{
+	struct audit_buffer *ab;
+
+	ab = audit_log_start(current->audit_context, GFP_KERNEL,
+			     AUDIT_ANOM_LINK);
+	audit_log_format(ab, "op=%s action=denied", operation);
+	audit_log_format(ab, " pid=%d comm=", current->pid);
+	audit_log_untrustedstring(ab, current->comm);
+	audit_log_d_path(ab, " path=", link);
+	audit_log_format(ab, " dev=");
+	audit_log_untrustedstring(ab, link->dentry->d_inode->i_sb->s_id);
+	audit_log_format(ab, " ino=%lu", link->dentry->d_inode->i_ino);
+	audit_log_end(ab);
+}
+
+/**
  * audit_log_end - end one audit record
  * @ab: the audit_buffer
  *
-- 
1.7.0.4
