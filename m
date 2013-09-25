Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Wed, 25 Sep 2013 21:14:39 +0100
Message-Id: <1380140085-29712-7-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1380140085-29712-1-git-send-email-tixxdz@opendz.org>
References: <1380140085-29712-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH 06/12] procfs: make /proc/*/stack 0400
To: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: tixxdz@gmail.com, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

The /proc/*/stack contains sensitive information and currently its mode
is 0444. Change this to 0400 so the VFS will be able to block
unprivileged processes to get file descriptors on arbitrary privileged
/proc/*/stack files.

The /proc/*/stack is a /procfs ONE file that shares the same ->open()
file operation with other ONE files. Doing a ptrace_may_access() check
during open() might break userspace from accessing other ONE files
like /proc/*/stat and /proc/*/statm.

Therfore make it 0400 for now, and improve its check during ->read()
in the next following patch.

Cc: Kees Cook <keescook@chromium.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 8d21316..bb90171 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2710,7 +2710,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	INF("wchan",      S_IRUGO, proc_pid_wchan),
 #endif
 #ifdef CONFIG_STACKTRACE
-	ONE("stack",      S_IRUGO, proc_pid_stack),
+	ONE("stack",      S_IRUSR, proc_pid_stack),
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat",  S_IRUGO, proc_pid_schedstat),
@@ -3048,7 +3048,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	INF("wchan",     S_IRUGO, proc_pid_wchan),
 #endif
 #ifdef CONFIG_STACKTRACE
-	ONE("stack",      S_IRUGO, proc_pid_stack),
+	ONE("stack",      S_IRUSR, proc_pid_stack),
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat", S_IRUGO, proc_pid_schedstat),
-- 
1.7.11.7
