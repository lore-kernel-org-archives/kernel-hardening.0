From: "Tobin C. Harding" <me@tobin.cc>
Date: Thu,  2 Nov 2017 17:16:30 +1100
Message-Id: <1509603390-7587-3-git-send-email-me@tobin.cc>
In-Reply-To: <1509603390-7587-1-git-send-email-me@tobin.cc>
References: <1509603390-7587-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [RFC 2/2] seq_file: sanitize for non-privileged processes
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>
List-ID: <kernel-hardening.lists.openwall.com>

Kernel addresses should not be leaked to user space. Currently the only
mechanism we have to restrict kernel addresses from leaking is the
sysctl kptr_restrict. We don't need to rely on this mechanism, we can
sanitize kernel addresses in seq_files whenever a non-privileged
process attempts to show them.

Call vsnprintf_sanitize() for non-privileged processes.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 fs/seq_file.c            | 13 ++++++++++++-
 include/linux/seq_file.h |  1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index dc7c2be963ed..740980339b7f 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -46,6 +46,7 @@ static void *seq_buf_alloc(unsigned long size)
  */
 int seq_open(struct file *file, const struct seq_operations *op)
 {
+	const struct cred *cred = current_cred();
 	struct seq_file *p;
 
 	WARN_ON(file->private_data);
@@ -80,6 +81,12 @@ int seq_open(struct file *file, const struct seq_operations *op)
 	 * file.open() which calls seq_open() and then sets FMODE_PWRITE.
 	 */
 	file->f_mode &= ~FMODE_PWRITE;
+
+	p->sanitize = true;
+	if (uid_eq(cred->uid, GLOBAL_ROOT_UID) ||
+	    uid_eq(cred->euid, GLOBAL_ROOT_UID)) {
+		p->sanitize = false;
+	}
 	return 0;
 }
 EXPORT_SYMBOL(seq_open);
@@ -391,9 +398,13 @@ EXPORT_SYMBOL(seq_escape);
 void seq_vprintf(struct seq_file *m, const char *f, va_list args)
 {
 	int len;
+	int (*fn)(char *, size_t, const char *, va_list) = vsnprintf_sanitize;
+
+	if (m->sanitize == false)
+		fn = vsnprintf;
 
 	if (m->count < m->size) {
-		len = vsnprintf(m->buf + m->count, m->size - m->count, f, args);
+		len = fn(m->buf + m->count, m->size - m->count, f, args);
 		if (m->count + len < m->size) {
 			m->count += len;
 			return;
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index e305b66a9fb9..45840c866e26 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -25,6 +25,7 @@ struct seq_file {
 	const struct seq_operations *op;
 	int poll_event;
 	const struct file *file;
+	bool sanitize;
 	void *private;
 };
 
-- 
2.7.4
