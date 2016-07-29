Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Fri, 29 Jul 2016 10:34:39 +0300
Message-Id: <1469777680-3687-5-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
References: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFC] [PATCH 4/5] invoke path_chroot() LSM hook on mntns_install()
To: kernel-hardening@lists.openwall.com
Cc: linux-security-module@vger.kernel.org, keescook@chromium.org, spender@grsecurity.net, jmorris@namei.org, casey.schaufler@intel.com, michael.leibowitz@intel.com, william.c.roberts@intel.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

This adds an additional invocation of the
security_path_chroot LSM hook inside mntns_install().
Currently only capabilities are checked at this point,
while process root actually changes.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 fs/namespace.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 419f746..c5dcb09 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3325,6 +3325,7 @@ static int mntns_install(struct nsproxy *nsproxy, struct ns_common *ns)
 	struct fs_struct *fs = current->fs;
 	struct mnt_namespace *mnt_ns = to_mnt_ns(ns);
 	struct path root;
+	int retval;
 
 	if (!ns_capable(mnt_ns->user_ns, CAP_SYS_ADMIN) ||
 	    !ns_capable(current_user_ns(), CAP_SYS_CHROOT) ||
@@ -3334,10 +3335,6 @@ static int mntns_install(struct nsproxy *nsproxy, struct ns_common *ns)
 	if (fs->users != 1)
 		return -EINVAL;
 
-	get_mnt_ns(mnt_ns);
-	put_mnt_ns(nsproxy->mnt_ns);
-	nsproxy->mnt_ns = mnt_ns;
-
 	/* Find the root */
 	root.mnt    = &mnt_ns->root->mnt;
 	root.dentry = mnt_ns->root->mnt.mnt_root;
@@ -3345,6 +3342,16 @@ static int mntns_install(struct nsproxy *nsproxy, struct ns_common *ns)
 	while(d_mountpoint(root.dentry) && follow_down_one(&root))
 		;
 
+	retval = security_path_chroot(&root);
+	if (retval) {
+		path_put(&root);
+		return retval;
+	}
+
+	get_mnt_ns(mnt_ns);
+	put_mnt_ns(nsproxy->mnt_ns);
+	nsproxy->mnt_ns = mnt_ns;
+
 	/* Update the pwd and root */
 	set_fs_pwd(fs, &root);
 	set_fs_root(fs, &root);
-- 
1.9.1
