Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 9 Jun 2016 19:37:14 -0400
From: Rik van Riel <riel@redhat.com>
Message-ID: <20160609193714.0f302022@annuminas.surriel.com>
In-Reply-To: <1465420302-23754-3-git-send-email-keescook@chromium.org>
References: <1465420302-23754-1-git-send-email-keescook@chromium.org>
	<1465420302-23754-3-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 2/4] usercopy: avoid direct copying to userspace
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey.schaufler@intel.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed,  8 Jun 2016 14:11:40 -0700
Kees Cook <keescook@chromium.org> wrote:

> Some non-whitelisted heap memory has small areas that need to be copied
> to userspace. For these cases, explicitly copy the needed contents out
> to stack first before sending to userspace. This lets their respective
> caches remain un-whitelisted (i.e. no SLAB_USERCOPY), since the bulk of
> their contents should not be exposed to userspace.
> 
> These changes, based on code by Brad Spengler and PaX Team, were extracted
> from grsecurity/PaX on a case-by-case basis as I ran into errors during
> testing of CONFIG_HARDENED_USERCOPY_WHITELIST:

You will want this bit as well. It is an adaptation, with
a slight change after digging through XFS code for an hour
and a half or so, of code originally from grsecurity.

With this change, my system boots a usercopy kernel without
any visible issues.

---8<---

Subject: mm,xfs: bounce buffer the file name in xfs_dir2_sf_getdents

"Short form" directories in XFS have the directory content inside the
in-memory inode, or other kernel memory. The directory contents can be
in the same slab object as other, more sensitive, contents.

Instead of marking the xfs_inode slab accessible to copy_from_user and
copy_to_user, bounce buffer the file name when doing getdents on a short
form directory.

This only affects short form directories, which will have a very small
number of entries. Large directories use different code.

Adapted from the grsecurity patch set. Thanks go out to pipacs and spender.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 fs/xfs/xfs_dir2_readdir.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index f44f79996978..bc6c78cbe4c6 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -127,6 +127,7 @@ xfs_dir2_sf_getdents(
 	 */
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	for (i = 0; i < sfp->count; i++) {
+		char name[sfep->namelen];
 		__uint8_t filetype;
 
 		off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
@@ -140,7 +141,14 @@ xfs_dir2_sf_getdents(
 		ino = dp->d_ops->sf_get_ino(sfp, sfep);
 		filetype = dp->d_ops->sf_get_ftype(sfep);
 		ctx->pos = off & 0x7fffffff;
-		if (!dir_emit(ctx, (char *)sfep->name, sfep->namelen, ino,
+		/*
+		 * Short form directories have the file name stored in
+		 * memory that is not directly accessible to copy_to_user.
+		 * Bounce buffer the name, instead of potentially making
+		 * the other data accessible.
+		 */
+		memcpy(name, sfep->name, sfep->namelen);
+		if (!dir_emit(ctx, name, sfep->namelen, ino,
 			    xfs_dir3_get_dtype(dp->i_mount, filetype)))
 			return 0;
 		sfep = dp->d_ops->sf_nextentry(sfp, sfep);
