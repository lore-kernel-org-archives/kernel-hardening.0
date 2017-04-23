From: Matt Brown <matt@nmatt.com>
Date: Sun, 23 Apr 2017 03:24:57 -0400
Message-Id: <20170423072457.27120-2-matt@nmatt.com>
In-Reply-To: <20170423072457.27120-1-matt@nmatt.com>
References: <20170423072457.27120-1-matt@nmatt.com>
Subject: [kernel-hardening] [PATCH v2 2/2] tiocsti-restrict : make TIOCSTI ioctl require CAP_SYS_ADMIN
To: serge@hallyn.com, jmorris@namei.org, gregkh@linuxfoundation.org, jslaby@suse.com, corbet@lwn.net, keescook@chromium.org
Cc: akpm@linux-foundation.org, jannh@google.com, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Matt Brown <matt@nmatt.com>
List-ID: <kernel-hardening.lists.openwall.com>

This introduces the tiocsti_restrict sysctl, whose default is controlled via
CONFIG_SECURITY_TIOCSTI_RESTRICT. When activated, this control restricts
all TIOCSTI ioctl calls from non CAP_SYS_ADMIN users.

This patch was inspired from GRKERNSEC_HARDEN_TTY.

This patch would have prevented
https://bugzilla.redhat.com/show_bug.cgi?id=1411256 under the following
conditions:
* non-privileged container
* container run inside new user namespace

Possible effects on userland:

There could be a few user programs that would be effected by this
change.
See: <https://codesearch.debian.net/search?q=ioctl%5C%28.*TIOCSTI>
notable programs are: agetty, csh, xemacs and tcsh

However, I still believe that this change is worth it given that the
Kconfig defaults to n. This will be a feature that is turned on for the
same reason that people activate it when using grsecurity. Users of this
opt-in feature will realize that they are choosing security over some OS
features like unprivileged TIOCSTI ioctls, as should be clear in the
Kconfig help message.

Threat Model/Patch Rational:

>From grsecurity's config for GRKERNSEC_HARDEN_TTY.

 | There are very few legitimate uses for this functionality and it
 | has made vulnerabilities in several 'su'-like programs possible in
 | the past.  Even without these vulnerabilities, it provides an
 | attacker with an easy mechanism to move laterally among other
 | processes within the same user's compromised session.

So if one process within a tty session becomes compromised it can follow
that additional processes, that are thought to be in different security
boundaries, can be compromised as a result. When using a program like su
or sudo, these additional processes could be in a tty session where TTY file
descriptors are indeed shared over privilege boundaries.

This is also an excellent writeup about the issue:
<http://www.halfdog.net/Security/2012/TtyPushbackPrivilegeEscalation/>

When user namespaces are in use, the check for the capability
CAP_SYS_ADMIN is done against the user namespace that originally opened
the tty.

Signed-off-by: Matt Brown <matt@nmatt.com>
---
 Documentation/sysctl/kernel.txt | 21 +++++++++++++++++++++
 drivers/tty/tty_io.c            |  6 ++++++
 include/linux/tty.h             |  2 ++
 kernel/sysctl.c                 | 12 ++++++++++++
 security/Kconfig                | 13 +++++++++++++
 5 files changed, 54 insertions(+)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index bac23c1..c15c660 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -89,6 +89,7 @@ show up in /proc/sys/kernel:
 - sysctl_writes_strict
 - tainted
 - threads-max
+- tiocsti_restrict
 - unknown_nmi_panic
 - watchdog
 - watchdog_thresh
@@ -987,6 +988,26 @@ available RAM pages threads-max is reduced accordingly.
 
 ==============================================================
 
+tiocsti_restrict:
+
+This toggle indicates whether unprivileged users are prevented
+from using the TIOCSTI ioctl to inject commands into otherprocesses
+which share a tty session.
+
+When tiocsti_restrict is set to (0) there are no restrictions(accept
+the default restriction of only being able to injection commands into
+one's own tty). When tiocsti_restrict is set to (1), users must
+have CAP_SYS_ADMIN to use the TIOCSTI ioctl.
+
+When user namespaces are in use, the check for the capability
+CAP_SYS_ADMIN is done against the user namespace that originally
+opened the tty.
+
+The kernel config option CONFIG_SECURITY_TIOCSTI_RESTRICT sets the
+default value of tiocsti_restrict.
+
+==============================================================
+
 unknown_nmi_panic:
 
 The value in this file affects behavior of handling NMI. When the
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index e774385..2e15dca 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2296,11 +2296,17 @@ static int tty_fasync(int fd, struct file *filp, int on)
  *	FIXME: may race normal receive processing
  */
 
+int tiocsti_restrict = IS_ENABLED(CONFIG_SECURITY_TIOCSTI_RESTRICT);
+
 static int tiocsti(struct tty_struct *tty, char __user *p)
 {
 	char ch, mbz = 0;
 	struct tty_ldisc *ld;
 
+	if (tiocsti_restrict && !ns_capable(tty->owner_user_ns,CAP_SYS_ADMIN)) {
+		pr_warn_ratelimited("TIOCSTI ioctl call blocked for non-privileged process\n");
+		return -EPERM;
+	}
 	if ((current->signal->tty != tty) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	if (get_user(ch, p))
diff --git a/include/linux/tty.h b/include/linux/tty.h
index d902d42..2fd7f49 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -344,6 +344,8 @@ struct tty_file_private {
 	struct list_head list;
 };
 
+extern int tiocsti_restrict;
+
 /* tty magic number */
 #define TTY_MAGIC		0x5401
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index acf0a5a..68d1363 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -67,6 +67,7 @@
 #include <linux/kexec.h>
 #include <linux/bpf.h>
 #include <linux/mount.h>
+#include <linux/tty.h>
 
 #include <linux/uaccess.h>
 #include <asm/processor.h>
@@ -833,6 +834,17 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &two,
 	},
 #endif
+#if defined CONFIG_TTY
+	{
+		.procname	= "tiocsti_restrict",
+		.data		= &tiocsti_restrict,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax_sysadmin,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+#endif
 	{
 		.procname	= "ngroups_max",
 		.data		= &ngroups_max,
diff --git a/security/Kconfig b/security/Kconfig
index 3ff1bf9..7d13331 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -18,6 +18,19 @@ config SECURITY_DMESG_RESTRICT
 
 	  If you are unsure how to answer this question, answer N.
 
+config SECURITY_TIOCSTI_RESTRICT
+	bool "Restrict unprivileged use of tiocsti command injection"
+	default n
+	help
+	  This enforces restrictions on unprivileged users injecting commands
+	  into other processes which share a tty session using the TIOCSTI
+	  ioctl. This option makes TIOCSTI use require CAP_SYS_ADMIN.
+
+	  If this option is not selected, no restrictions will be enforced
+	  unless the tiocsti_restrict sysctl is explicitly set to (1).
+
+	  If you are unsure how to answer this question, answer N.
+
 config SECURITY
 	bool "Enable different security models"
 	depends on SYSFS
-- 
2.10.2
