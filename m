Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Sun, 15 Dec 2013 19:57:14 +0100
Message-Id: <1387133834-31966-3-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1387133834-31966-1-git-send-email-tixxdz@opendz.org>
References: <1387133834-31966-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH 2/2] procfs: make /proc/*/pagemap 0400
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>
Cc: Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

The /proc/*/pagemap contain sensitive information and currently its
mode is 0444. Change this to 0400, so the VFS will prevent unprivileged
processes from getting file descriptors on arbitrary privileged
/proc/*/pagemap files.

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index e69df4b..081d055 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2616,7 +2616,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
 	REG("smaps",      S_IRUGO, proc_pid_smaps_operations),
-	REG("pagemap",    S_IRUGO, proc_pagemap_operations),
+	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
 #endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",       S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
@@ -2954,7 +2954,7 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
 	REG("smaps",     S_IRUGO, proc_tid_smaps_operations),
-	REG("pagemap",    S_IRUGO, proc_pagemap_operations),
+	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
 #endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",      S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
-- 
1.7.11.7
