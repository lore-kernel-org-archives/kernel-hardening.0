Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Wed, 25 Sep 2013 21:14:38 +0100
Message-Id: <1380140085-29712-6-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1380140085-29712-1-git-send-email-tixxdz@opendz.org>
References: <1380140085-29712-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH 05/12] seq_file: set the seq_file->f_cred during seq_open()
To: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: tixxdz@gmail.com, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

The f_cred field of the file struct contains the cred of current at
open time. This field can be used to get the context of open, and track
current's cred changes after.
The procfs is one of those fs that need to track current cred changes
in order to implement proper permission checks on each system call.

Set the seq_file->f_cred to file->f_cred during seq_open().

Cc: Kees Cook <keescook@chromium.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/seq_file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 3135c25..a5e5b98 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -57,6 +57,7 @@ int seq_open(struct file *file, const struct seq_operations *op)
 	memset(p, 0, sizeof(*p));
 	mutex_init(&p->lock);
 	p->op = op;
+	p->f_cred = file->f_cred;
 #ifdef CONFIG_USER_NS
 	p->user_ns = file->f_cred->user_ns;
 #endif
-- 
1.7.11.7
