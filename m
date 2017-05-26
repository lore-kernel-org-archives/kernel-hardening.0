From: Kees Cook <keescook@chromium.org>
Date: Fri, 26 May 2017 13:17:21 -0700
Message-Id: <1495829844-69341-18-git-send-email-keescook@chromium.org>
In-Reply-To: <1495829844-69341-1-git-send-email-keescook@chromium.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 17/20] ocfs2: Use ERR_CAST() to avoid cross-structure cast
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Mark Fasheh <mfasheh@versity.com>, Joel Becker <jlbec@evilplan.org>, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

When trying to propagate an error result, the error return path attempts
to retain the error, but does this with an open cast across very different
types, which the upcoming structure layout randomization plugin flags as
being potentially dangerous in the face of randomization. This is a false
positive, but what this code actually wants to do is use ERR_CAST() to
retain the error value.

Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/ocfs2/export.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index 827fc9809bc2..9f88188060db 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -119,7 +119,7 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
 
 	if (IS_ERR(inode)) {
 		mlog_errno(PTR_ERR(inode));
-		result = (void *)inode;
+		result = ERR_CAST(inode);
 		goto bail;
 	}
 
-- 
2.7.4
