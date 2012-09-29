Reply-To: kernel-hardening@lists.openwall.com
From: Richard Weinberger <richard@nod.at>
Date: Sat, 29 Sep 2012 17:43:41 +0200
Message-Id: <1348933421-1298-1-git-send-email-richard@nod.at>
Subject: [kernel-hardening] [Resend][PATCH] Revert "futex: Mark get_robust_list as deprecated"
To: tglx@linutronix.de
Cc: dvhart@linux.intel.com, keescook@chromium.org, paul.gortmaker@windriver.com, hughd@google.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, rob@landley.net, Richard Weinberger <richard@nod.at>, Randy Dunlap <rdunlap@xenotime.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Kosina <jkosina@suse.cz>, "Eric W. Biederman" <ebiederm@xmission.com>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, kernel-hardening@lists.openwall.com, spender@grsecurity.net, Cyrill Gorcunov <gorcunov@openvz.org>, xemul@parallels.com, stable@vger.kernel.org, #
List-ID: <kernel-hardening.lists.openwall.com>

get_robust_list has at least two valid use cases.
1. checkpoint/restore in userspace
2. post mortem analysis

Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: kernel-hardening@lists.openwall.com
Cc: spender@grsecurity.net
Cc: keescook@chromium.org
Cc: tglx@linutronix.de
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: xemul@parallels.com
Cc: <stable@vger.kernel.org> # 3.4.x
Cc: <stable@vger.kernel.org> # 3.5.x
Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Kees Cook <keescook@chromium.org>
---
 Documentation/feature-removal-schedule.txt |   10 ----------
 kernel/futex.c                             |    2 --
 kernel/futex_compat.c                      |    2 --
 3 files changed, 14 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index afaff31..a25482e 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -506,16 +506,6 @@ Who:	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
 
 ----------------------------
 
-What:	get_robust_list syscall
-When:	2013
-Why:	There appear to be no production users of the get_robust_list syscall,
-	and it runs the risk of leaking address locations, allowing the bypass
-	of ASLR. It was only ever intended for debugging, so it should be
-	removed.
-Who:	Kees Cook <keescook@chromium.org>
-
-----------------------------
-
 What:	Removing the pn544 raw driver.
 When:	3.6
 Why:	With the introduction of the NFC HCI and SHDL kernel layers, pn544.c
diff --git a/kernel/futex.c b/kernel/futex.c
index e2b0fb9..d701be5 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2449,8 +2449,6 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
 
-	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
-
 	rcu_read_lock();
 
 	ret = -ESRCH;
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 83e368b..a9642d5 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -142,8 +142,6 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
 
-	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
-
 	rcu_read_lock();
 
 	ret = -ESRCH;
-- 
1.7.10.4
