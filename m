From: Matt Brown <matt@nmatt.com>
Date: Tue, 18 Apr 2017 23:45:26 -0400
Message-Id: <20170419034526.18565-1-matt@nmatt.com>
Subject: [kernel-hardening] [PATCH] make TIOCSTI ioctl require CAP_SYS_ADMIN
To: jmorris@namei.org, serge@hallyn.com, gregkh@linuxfoundation.org, jslaby@suse.com, akpm@linux-foundation.org, jannh@google.com, keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Matt Brown <matt@nmatt.com>
List-ID: <kernel-hardening.lists.openwall.com>

This patch reproduces GRKERNSEC_HARDEN_TTY functionality from the grsecurity
project in-kernel.

This will create the Kconfig SECURITY_TIOCSTI_RESTRICT and the corresponding
sysctl kernel.tiocsti_restrict that, when activated, restrict all TIOCSTI
ioctl calls from non CAP_SYS_ADMIN users.

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

Signed-off-by: Matt Brown <matt@nmatt.com>
---
 drivers/tty/tty_io.c |  4 ++++
 include/linux/tty.h  |  2 ++
 kernel/sysctl.c      | 12 ++++++++++++
 security/Kconfig     | 13 +++++++++++++
 4 files changed, 31 insertions(+)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index e6d1a65..31894e8 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2296,11 +2296,15 @@ static int tty_fasync(int fd, struct file *filp, int on)
  *	FIXME: may race normal receive processing
  */
 
+int tiocsti_restrict = IS_ENABLED(CONFIG_SECURITY_TIOCSTI_RESTRICT);
+
 static int tiocsti(struct tty_struct *tty, char __user *p)
 {
 	char ch, mbz = 0;
 	struct tty_ldisc *ld;
 
+	if (tiocsti_restrict && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
 	if ((current->signal->tty != tty) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	if (get_user(ch, p))
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 1017e904..7011102 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -342,6 +342,8 @@ struct tty_file_private {
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
