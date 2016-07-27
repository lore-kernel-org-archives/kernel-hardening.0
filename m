Reply-To: kernel-hardening@lists.openwall.com
From: Jeff Vander Stoep <jeffv@google.com>
Date: Wed, 27 Jul 2016 07:46:23 -0700
Message-Id: <1469630783-32413-1-git-send-email-jeffv@google.com>
Subject: [kernel-hardening] [PATCH 2/2] security, perf: Add config option to restrict perf_event_open
To: kernel-hardening@lists.openwall.com
Cc: peterz@infradead.org, mingo@redhat.com, acme@kernel.org, alexander.shishkin@linux.intel.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Vander Stoep <jeffv@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

When CONFIG_SECURITY_PERF_EVENTS_RESTRICT=y kernel.perf_event_paranoid
sysctl will be set to 3 by default, and no unprivileged use of the
perf_event_open syscall will be permitted unless it is changed.

This new level of restriction is intended to reduce the attack
surface of the kernel. It allows for a safe default to be set on
production systems at build time while leaving a simple means for
developers to grant access.

Signed-off-by: Jeff Vander Stoep <jeffv@google.com>
---
 Documentation/sysctl/kernel.txt | 3 ++-
 kernel/events/core.c            | 4 ++++
 security/Kconfig                | 9 +++++++++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index fac9798..52daff6 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -659,7 +659,8 @@ allowed to execute.
 perf_event_paranoid:
 
 Controls use of the performance events system by unprivileged
-users (without CAP_SYS_ADMIN).  The default value is 2.
+users (without CAP_SYS_ADMIN).  The default value is 3 if
+CONFIG_SECURITY_PERF_EVENTS_RESTRICT is set, or 2 otherwise.
 
  -1: Allow use of (almost) all events by all users
 >=0: Disallow raw tracepoint access by users without CAP_IOC_LOCK
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 52bd100..df9df87 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -355,7 +355,11 @@ static struct srcu_struct pmus_srcu;
  *   2 - disallow kernel profiling for unpriv
  *   3 - disallow all unpriv perf event use
  */
+#ifdef CONFIG_SECURITY_PERF_EVENTS_RESTRICT
+int sysctl_perf_event_paranoid __read_mostly = 3;
+#else
 int sysctl_perf_event_paranoid __read_mostly = 2;
+#endif
 
 /* Minimum for 512 kiB + 1 user control page */
 int sysctl_perf_event_mlock __read_mostly = 512 + (PAGE_SIZE / 1024); /* 'free' kiB per user */
diff --git a/security/Kconfig b/security/Kconfig
index df28f2b..2a93551 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -18,6 +18,15 @@ config SECURITY_DMESG_RESTRICT
 
 	  If you are unsure how to answer this question, answer N.
 
+config SECURITY_PERF_EVENTS_RESTRICT
+	bool "Restrict unprivileged use of performance events"
+	depends on PERF_EVENTS
+	help
+	  If you say Y here, the kernel.perf_event_paranoid sysctl
+	  will be set to 3 by default, and no unprivileged use of the
+	  perf_event_open syscall will be permitted unless it is
+	  changed.
+
 config SECURITY
 	bool "Enable different security models"
 	depends on SYSFS
-- 
2.8.0.rc3.226.g39d4020
