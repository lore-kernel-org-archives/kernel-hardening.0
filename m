From: Kees Cook <keescook@chromium.org>
Date: Mon, 28 Aug 2017 14:34:47 -0700
Message-Id: <1503956111-36652-7-git-send-email-keescook@chromium.org>
In-Reply-To: <1503956111-36652-1-git-send-email-keescook@chromium.org>
References: <1503956111-36652-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 06/30] vfs: Copy struct mount.mnt_id to userspace using put_user()
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, David Windsor <dave@nullcore.net>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

From: David Windsor <dave@nullcore.net>

The mnt_id field can be copied with put_user(), so there is no need to
use copy_to_user(). In both cases, hardened usercopy is being bypassed
since the size is constant, and not open to runtime manipulation.

This patch is verbatim from Brad Spengler/PaX Team's PAX_USERCOPY
whitelisting code in the last public patch of grsecurity/PaX based on my
understanding of the code. Changes or omissions from the original code are
mine and don't reflect the original grsecurity/PaX code.

Signed-off-by: David Windsor <dave@nullcore.net>
[kees: adjust commit log]
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/fhandle.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/fhandle.c b/fs/fhandle.c
index 58a61f55e0d0..46e00ccca8f0 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -68,8 +68,7 @@ static long do_sys_name_to_handle(struct path *path,
 	} else
 		retval = 0;
 	/* copy the mount id */
-	if (copy_to_user(mnt_id, &real_mount(path->mnt)->mnt_id,
-			 sizeof(*mnt_id)) ||
+	if (put_user(real_mount(path->mnt)->mnt_id, mnt_id) ||
 	    copy_to_user(ufh, handle,
 			 sizeof(struct file_handle) + handle_bytes))
 		retval = -EFAULT;
-- 
2.7.4
