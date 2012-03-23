Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 23 Mar 2012 10:58:55 -0700
From: Kees Cook <keescook@chromium.org>
Message-ID: <20120323175855.GA23668@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1203230043470.2542@ionos>
Subject: [kernel-hardening] [PATCH] futex: mark get_robust_list as deprecated
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Darren Hart <dvhart@linux.intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, "Eric W. Biederman" <ebiederm@xmission.com>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, kernel-hardening@lists.openwall.com, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

Notify get_robust_list users that the syscall is going away.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/futex.c        |    2 ++
 kernel/futex_compat.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 439440d..545d7a3 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2449,6 +2449,8 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
 
+	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
+
 	rcu_read_lock();
 
 	ret = -ESRCH;
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index a9642d5..83e368b 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -142,6 +142,8 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
 
+	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
+
 	rcu_read_lock();
 
 	ret = -ESRCH;
-- 
1.7.0.4

-- 
Kees Cook
ChromeOS Security
