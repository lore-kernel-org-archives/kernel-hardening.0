Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Wed, 25 Sep 2013 21:14:37 +0100
Message-Id: <1380140085-29712-5-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1380140085-29712-1-git-send-email-tixxdz@opendz.org>
References: <1380140085-29712-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH 04/12] seq_file: Make seq_file able to access the file's opener cred
To: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: tixxdz@gmail.com, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

The f_cred field of the file struct contains the cred of current at
open time. This field can be used to get the context of open, and track
current's cred changes after.

The procfs is one of those fs that need to track current cred changes
in order to implement proper permission checks on each system call.

The procfs make use of seq_file struct and its iterators to step through
/proc objects. These iterators and seq_file helpers must be able to
access the file->f_cred to perform various permission checks at any
time.

Therefor add the f_cred field to the seq_file struct and a helper
seq_f_cred() to return it.

Cc: Kees Cook <keescook@chromium.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 include/linux/seq_file.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 4e32edc..ec07709 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -13,6 +13,7 @@ struct file;
 struct path;
 struct inode;
 struct dentry;
+struct cred;
 struct user_namespace;
 
 struct seq_file {
@@ -26,6 +27,7 @@ struct seq_file {
 	struct mutex lock;
 	const struct seq_operations *op;
 	int poll_event;
+	const struct cred *f_cred;
 #ifdef CONFIG_USER_NS
 	struct user_namespace *user_ns;
 #endif
@@ -133,6 +135,11 @@ int seq_put_decimal_ull(struct seq_file *m, char delimiter,
 int seq_put_decimal_ll(struct seq_file *m, char delimiter,
 			long long num);
 
+static inline const struct cred *seq_f_cred(struct seq_file *seq)
+{
+	return seq->f_cred;
+}
+
 static inline struct user_namespace *seq_user_ns(struct seq_file *seq)
 {
 #ifdef CONFIG_USER_NS
-- 
1.7.11.7
