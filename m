Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Wed, 25 Sep 2013 21:14:45 +0100
Message-Id: <1380140085-29712-13-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1380140085-29712-1-git-send-email-tixxdz@opendz.org>
References: <1380140085-29712-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH 12/12] user_ns: seq_file: use the user_ns that is embedded in the f_cred struct
To: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: tixxdz@gmail.com, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

seq_file struct now has a reference on the file->f_cred struct which
includes a pointer on user_ns. So remove the user_ns field from seq_file
struct and use the one provided by seq_file->f_cred.

Update seq_user_ns() to return the user_ns of seq_file->f_cred.

Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/seq_file.c            | 3 ---
 include/linux/seq_file.h | 6 ++----
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index a5e5b98..ee1c36d 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -58,9 +58,6 @@ int seq_open(struct file *file, const struct seq_operations *op)
 	mutex_init(&p->lock);
 	p->op = op;
 	p->f_cred = file->f_cred;
-#ifdef CONFIG_USER_NS
-	p->user_ns = file->f_cred->user_ns;
-#endif
 
 	/*
 	 * Wrappers around seq_open(e.g. swaps_open) need to be
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index ec07709..5db1e39 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -7,6 +7,7 @@
 #include <linux/mutex.h>
 #include <linux/cpumask.h>
 #include <linux/nodemask.h>
+#include <linux/cred.h>
 
 struct seq_operations;
 struct file;
@@ -28,9 +29,6 @@ struct seq_file {
 	const struct seq_operations *op;
 	int poll_event;
 	const struct cred *f_cred;
-#ifdef CONFIG_USER_NS
-	struct user_namespace *user_ns;
-#endif
 	void *private;
 };
 
@@ -143,7 +141,7 @@ static inline const struct cred *seq_f_cred(struct seq_file *seq)
 static inline struct user_namespace *seq_user_ns(struct seq_file *seq)
 {
 #ifdef CONFIG_USER_NS
-	return seq->user_ns;
+	return seq_f_cred(seq)->user_ns;
 #else
 	extern struct user_namespace init_user_ns;
 	return &init_user_ns;
-- 
1.7.11.7
