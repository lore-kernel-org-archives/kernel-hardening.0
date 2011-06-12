Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
From: Vasiliy Kulikov <segoon@openwall.com>
Date: Sun, 12 Jun 2011 18:46:23 +0400
Message-Id: <1307889983-6350-1-git-send-email-segoon@openwall.com>
Subject: [kernel-hardening] [RFC v2 03/04] procfs: add hidenet modes as mount options
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

This patch adds mount options to restrict access to /proc/PID/net/
contents.  The default backward-compatible behaviour is left untouched.

'hidenet' mount option means /proc/PID/net will be accessible to processes
with CAP_NET_ADMIN capability or to members of a special group (gid=
argument).

In current version hidenet works for CONFIG_NET_NS=y via creating a
"fake" net namespace and slipping it to nonauthorized users, resulting
in users observing blank net files (like nobody use the network, which
is true for this fake namespace).  It is a small compatibility
workaround for old programs assuming that files like /proc/net/tcp and
similar always exist and are accessible.  If they look like in normal
situation but contain no information, nothing is broken and network
information access is still successfully restricted.  For
CONFIG_NET_NS=n /proc/net/ simply has no entries.


Similar feature is implemented for old kernels in -ow patches (for
Linux 2.2 and 2.4) and for Linux 2.6 in -grsecurity (but it is
implemented as a configure options, not cofigurable in runtime, and
without fake_net).

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 fs/proc/proc_net.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index 9020ac1..a2a1f08 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -22,10 +22,13 @@
 #include <linux/mount.h>
 #include <linux/nsproxy.h>
 #include <net/net_namespace.h>
+#include <linux/pid_namespace.h>
 #include <linux/seq_file.h>
 
 #include "internal.h"
 
+static struct net *fake_net;
+
 
 static struct net *get_proc_net(const struct inode *inode)
 {
@@ -105,6 +108,15 @@ static struct net *get_proc_task_net(struct inode *dir)
 	struct task_struct *task;
 	struct nsproxy *ns;
 	struct net *net = NULL;
+	struct pid_namespace *pid = dir->i_sb->s_fs_info;
+
+	if (pid->hide_net &&
+	    !in_group_p(pid->pid_gid) &&
+	    !capable(CAP_NET_ADMIN)) {
+		if (fake_net)
+			get_net(fake_net);
+		return fake_net;
+	}
 
 	rcu_read_lock();
 	task = pid_task(proc_pid(dir), PIDTYPE_PID);
@@ -239,3 +251,17 @@ int __init proc_net_init(void)
 
 	return register_pernet_subsys(&proc_net_ns_ops);
 }
+
+#ifdef CONFIG_NET_NS
+int __init proc_net_initcall(void)
+{
+	fake_net = net_create();
+	if (fake_net == NULL)
+		return -ENOMEM;
+
+	get_net(fake_net);
+	return 0;
+}
+
+late_initcall(proc_net_initcall);
+#endif
