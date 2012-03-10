Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Sun, 11 Mar 2012 00:25:12 +0100
Message-Id: <1331421919-15499-3-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH 2/9] proc: add proc_file_private struct to store private information
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

In order to store and to track the private information specific to each
procfs opened file we convert the 'proc_maps_private' struct which is used
by the /proc/$pid/{maps,smaps,numa_maps} files to 'proc_file_private'
which can now be used by all the /proc/<pid>/* and even other /proc/* files
to store private information that must be kept across syscalls.

The proc_file_private struct includes an exec_id member which can be used
to track and to protect special and sensitive procfs files. In general it
will be set at open time to the task's exec_id to bind the file to this
task.

The proc_file_private struct offers the way to make the checks and to
bind special procfs files to the appropriate task in a consistent and
unified way.

Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Solar Designer <solar@openwall.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/internal.h |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 2925775..a8968f6 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -61,10 +61,19 @@ extern const struct file_operations proc_pagemap_operations;
 extern const struct file_operations proc_net_operations;
 extern const struct inode_operations proc_net_inode_operations;
 
-struct proc_maps_private {
+/*
+ * Internal proc_file_private is used to track procfs files being
+ * processed especially the ones that varies during runtime.
+ */
+struct proc_file_private {
+	/* The Execve ID of the task, use this to protect special procfs
+	 * files. Must be set at open time. */
+	u64 exec_id;
 	struct pid *pid;
+	struct inode *inode;
 	struct task_struct *task;
 #ifdef CONFIG_MMU
+	/* For /proc/pid/{maps,smaps...} */
 	struct vm_area_struct *tail_vma;
 #endif
 };
-- 
1.7.1
