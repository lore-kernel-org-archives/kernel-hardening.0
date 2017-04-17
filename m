From: Matt Brown <matt@nmatt.com>
Date: Mon, 17 Apr 2017 02:07:06 -0400
Message-Id: <20170417060706.28674-5-matt@nmatt.com>
In-Reply-To: <20170417060706.28674-1-matt@nmatt.com>
References: <20170417060706.28674-1-matt@nmatt.com>
Subject: [kernel-hardening] [PATCH 4/4] added kernel.tiocsti_restrict sysctl
To: jmorris@namei.org, gregkh@linuxfoundation.org, akpm@linux-foundation.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Matt Brown <matt@nmatt.com>
List-ID: <kernel-hardening.lists.openwall.com>

this patch depends on patches 1, 2 and 3

Allow CONFIG_SECURITY_TIOCSTI_RESTRICT to be controlled via sysctl

Signed-off-by: Matt Brown <matt@nmatt.com>
---
 kernel/sysctl.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

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
-- 
2.10.2
