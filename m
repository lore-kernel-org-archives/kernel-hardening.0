From: Kees Cook <keescook@chromium.org>
Date: Fri, 26 May 2017 13:17:05 -0700
Message-Id: <1495829844-69341-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1495829844-69341-1-git-send-email-keescook@chromium.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 01/20] NFS: Avoid cross-structure casting
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
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
Acked-by: Trond Myklebust <trond.myklebust@primarydata.com>
---
 fs/nfs/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index 1a224a33a6c2..e5686be67be8 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -246,7 +246,7 @@ struct vfsmount *nfs_do_submount(struct dentry *dentry, struct nfs_fh *fh,
 
 	devname = nfs_devname(dentry, page, PAGE_SIZE);
 	if (IS_ERR(devname))
-		mnt = (struct vfsmount *)devname;
+		mnt = ERR_CAST(devname);
 	else
 		mnt = nfs_do_clone_mount(NFS_SB(dentry->d_sb), devname, &mountdata);
 
-- 
2.7.4
