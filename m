From: Kees Cook <keescook@chromium.org>
Date: Thu,  6 Apr 2017 14:18:21 -0700
Message-Id: <1491513513-84351-7-git-send-email-keescook@chromium.org>
In-Reply-To: <1491513513-84351-1-git-send-email-keescook@chromium.org>
References: <1491513513-84351-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 06/18] NFS: Avoid cross-structure casting
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Michael Leibowitz <michael.leibowitz@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

When the call to nfs_devname() fails, the error path attempts to retain
the error via the mnt variable, but this requires a cast across very
different types (char * to struct vfsmount *), which the upcoming
structure layout randomization plugin flags as being potentially
dangerous in the face of randomization. This is a false positive, but
what this code actually wants to do is retain the error value, so this
patch explicitly sets it, instead of using what seems to be an
unexpected cast.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/nfs/namespace.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index 786f17580582..8ca5d147124d 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -259,9 +259,10 @@ struct vfsmount *nfs_do_submount(struct dentry *dentry, struct nfs_fh *fh,
 	if (page == NULL)
 		goto out;
 	devname = nfs_devname(dentry, page, PAGE_SIZE);
-	mnt = (struct vfsmount *)devname;
-	if (IS_ERR(devname))
+	if (IS_ERR(devname)) {
+		mnt = ERR_CAST(devname);
 		goto free_page;
+	}
 	mnt = nfs_do_clone_mount(NFS_SB(dentry->d_sb), devname, &mountdata);
 free_page:
 	free_page((unsigned long)page);
-- 
2.7.4
