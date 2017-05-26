From: Kees Cook <keescook@chromium.org>
Date: Fri, 26 May 2017 13:17:20 -0700
Message-Id: <1495829844-69341-17-git-send-email-keescook@chromium.org>
In-Reply-To: <1495829844-69341-1-git-send-email-keescook@chromium.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 16/20] ntfs: Use ERR_CAST() to avoid cross-structure cast
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Anton Altaparmakov <anton@tuxera.com>, Andrew Morton <akpm@linux-foundation.org>, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

When trying to propagate an error result, the error return path attempts
to retain the error, but does this with an open cast across very different
types, which the upcoming structure layout randomization plugin flags as
being potentially dangerous in the face of randomization. This is a false
positive, but what this code actually wants to do is use ERR_CAST() to
retain the error value.

Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/ntfs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
index 358258364616..4690cd75d8d7 100644
--- a/fs/ntfs/namei.c
+++ b/fs/ntfs/namei.c
@@ -159,7 +159,7 @@ static struct dentry *ntfs_lookup(struct inode *dir_ino, struct dentry *dent,
 					PTR_ERR(dent_inode));
 		kfree(name);
 		/* Return the error code. */
-		return (struct dentry *)dent_inode;
+		return ERR_CAST(dent_inode);
 	}
 	/* It is guaranteed that @name is no longer allocated at this point. */
 	if (MREF_ERR(mref) == -ENOENT) {
-- 
2.7.4
