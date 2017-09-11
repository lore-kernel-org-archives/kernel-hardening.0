From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Mon, 11 Sep 2017 21:50:26 +0200
Message-Id: <1505159427-11747-9-git-send-email-s.mesoraca16@gmail.com>
In-Reply-To: <1505159427-11747-1-git-send-email-s.mesoraca16@gmail.com>
References: <1505159427-11747-1-git-send-email-s.mesoraca16@gmail.com>
Subject: [kernel-hardening] [RFC v3 8/9] Allowing for stacking procattr support in S.A.R.A.
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>
List-ID: <kernel-hardening.lists.openwall.com>

This allow S.A.R.A. to use the procattr interface without interfering
with other LSMs.
This part should be reimplemented as soon as upstream procattr stacking
support is available.

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 fs/proc/base.c      | 38 ++++++++++++++++++++++++++++++++++++++
 security/security.c | 20 ++++++++++++++++++--
 2 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index e5d89a0..3b10452 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2559,6 +2559,40 @@ static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,
 	.llseek		= generic_file_llseek,
 };
 
+#ifdef CONFIG_SECURITY_SARA
+static const struct pid_entry sara_attr_dir_stuff[] = {
+	REG("wxprot", 0666, proc_pid_attr_operations),
+};
+
+static int proc_sara_attr_dir_readdir(struct file *file,
+				      struct dir_context *ctx)
+{
+	return proc_pident_readdir(file, ctx,
+				   sara_attr_dir_stuff,
+				   ARRAY_SIZE(sara_attr_dir_stuff));
+}
+
+static const struct file_operations proc_sara_attr_dir_ops = {
+	.read		= generic_read_dir,
+	.iterate_shared	= proc_sara_attr_dir_readdir,
+	.llseek		= generic_file_llseek,
+};
+
+static struct dentry *proc_sara_attr_dir_lookup(struct inode *dir,
+				struct dentry *dentry, unsigned int flags)
+{
+	return proc_pident_lookup(dir, dentry,
+				  sara_attr_dir_stuff,
+				  ARRAY_SIZE(sara_attr_dir_stuff));
+};
+
+static const struct inode_operations proc_sara_attr_dir_inode_ops = {
+	.lookup		= proc_sara_attr_dir_lookup,
+	.getattr	= pid_getattr,
+	.setattr	= proc_setattr,
+};
+#endif /* CONFIG_SECURITY_SARA */
+
 static const struct pid_entry attr_dir_stuff[] = {
 	REG("current",    S_IRUGO|S_IWUGO, proc_pid_attr_operations),
 	REG("prev",       S_IRUGO,	   proc_pid_attr_operations),
@@ -2566,6 +2600,10 @@ static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,
 	REG("fscreate",   S_IRUGO|S_IWUGO, proc_pid_attr_operations),
 	REG("keycreate",  S_IRUGO|S_IWUGO, proc_pid_attr_operations),
 	REG("sockcreate", S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+#ifdef CONFIG_SECURITY_SARA
+	DIR("sara", 0555, proc_sara_attr_dir_inode_ops,
+				proc_sara_attr_dir_ops),
+#endif
 };
 
 static int proc_attr_dir_readdir(struct file *file, struct dir_context *ctx)
diff --git a/security/security.c b/security/security.c
index 4f50dc5..a27cfa8 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1277,12 +1277,28 @@ void security_d_instantiate(struct dentry *dentry, struct inode *inode)
 
 int security_getprocattr(struct task_struct *p, char *name, char **value)
 {
-	return call_int_hook(getprocattr, -EINVAL, p, name, value);
+	struct security_hook_list *hp;
+	int rc;
+
+	list_for_each_entry(hp, &security_hook_heads.getprocattr, list) {
+		rc = hp->hook.getprocattr(p, name, value);
+		if (rc != -EINVAL)
+			return rc;
+	}
+	return -EINVAL;
 }
 
 int security_setprocattr(const char *name, void *value, size_t size)
 {
-	return call_int_hook(setprocattr, -EINVAL, name, value, size);
+	struct security_hook_list *hp;
+	int rc;
+
+	list_for_each_entry(hp, &security_hook_heads.setprocattr, list) {
+		rc = hp->hook.setprocattr(name, value, size);
+		if (rc != -EINVAL)
+			return rc;
+	}
+	return -EINVAL;
 }
 
 int security_netlink_send(struct sock *sk, struct sk_buff *skb)
-- 
1.9.1
