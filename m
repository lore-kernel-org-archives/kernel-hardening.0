Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
From: Vasiliy Kulikov <segoon@openwall.com>
Date: Wed, 15 Jun 2011 17:58:14 +0400
Message-Id: <1308146295-12965-1-git-send-email-segoon@openwall.com>
Subject: [kernel-hardening] [RFC 4/5 v3] procfs: Add hidenet/nohidenet procfs mount options.
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, Daniel Lezcano <daniel.lezcano@free.fr>, "Serge E. Hallyn" <serge@hallyn.com>
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
similar always exist and are accessible for all users.  If they look
like in normal situation but contain no information, nothing is broken
and network information access is still successfully restricted.  For
CONFIG_NET_NS=n /proc/net/* are unaccessible.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 fs/proc/inode.c               |    2 ++
 fs/proc/proc_net.c            |   26 ++++++++++++++++++++++++++
 fs/proc/root.c                |   13 ++++++++++++-
 include/linux/pid_namespace.h |    1 +
 4 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 34ab842..08a5a26 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -114,6 +114,8 @@ static int proc_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_printf(seq, ",gid=%lu", (unsigned long)pid->pid_gid);
 	if (pid->hide_pid != 0)
 		seq_printf(seq, ",hidepid=%u", pid->hide_pid);
+	if (pid->hide_net)
+		seq_printf(seq, ",hidenet");
 
 	return 0;
 }
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
diff --git a/fs/proc/root.c b/fs/proc/root.c
index fe6f2c1..6a3fb85 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -37,12 +37,14 @@ static int proc_set_super(struct super_block *sb, void *data)
 }
 
 enum {
-	Opt_gid, Opt_hidepid, Opt_err,
+	Opt_gid, Opt_hidepid, Opt_nohidenet, Opt_hidenet, Opt_err,
 };
 
 static const match_table_t tokens = {
 	{Opt_hidepid, "hidepid=%u"},
 	{Opt_gid, "gid=%u"},
+	{Opt_nohidenet, "nohidenet"},
+	{Opt_hidenet, "hidenet"},
 	{Opt_err, NULL},
 };
 
@@ -79,6 +81,12 @@ static int proc_parse_options(char *options, struct pid_namespace *pid)
 			}
 			pid->hide_pid = option;
 			break;
+		case Opt_hidenet:
+			pid->hide_net = true;
+			break;
+		case Opt_nohidenet:
+			pid->hide_net = false;
+			break;
 		default:
 			pr_err("proc: unrecognized mount option \"%s\" "
 			       "or missing value", p);
@@ -86,6 +94,9 @@ static int proc_parse_options(char *options, struct pid_namespace *pid)
 		}
 	}
 
+	pr_debug("proc: gid = %u, hidepid = %o, hidenet = %d\n",
+		pid->pid_gid, pid->hide_pid, (int)pid->hide_net);
+
 	return 1;
 }
 
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index e7cf666..1c33094 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -32,6 +32,7 @@ struct pid_namespace {
 #endif
 	gid_t pid_gid;
 	int hide_pid;
+	bool hide_net;
 };
 
 extern struct pid_namespace init_pid_ns;
-- 
1.7.0.4
