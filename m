Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Wed,  8 Jun 2016 14:11:40 -0700
Message-Id: <1465420302-23754-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1465420302-23754-1-git-send-email-keescook@chromium.org>
References: <1465420302-23754-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 2/4] usercopy: avoid direct copying to userspace
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey.schaufler@intel.com>, Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Some non-whitelisted heap memory has small areas that need to be copied
to userspace. For these cases, explicitly copy the needed contents out
to stack first before sending to userspace. This lets their respective
caches remain un-whitelisted (i.e. no SLAB_USERCOPY), since the bulk of
their contents should not be exposed to userspace.

These changes, based on code by Brad Spengler and PaX Team, were extracted
from grsecurity/PaX on a case-by-case basis as I ran into errors during
testing of CONFIG_HARDENED_USERCOPY_WHITELIST:

Changed exec to use copy of auxv instead of copying from "mm_struct" cache.

Changed signal handling to use an on-stack copy of signal frames instead
of direct copying from "task_struct" cache.

Changed name_to_handle to use put_user (which operates on fixed sizes)
instead of copy_to_user from "mnt_cache" cache.

Changed readlink to use stack for in-struct names to avoid copying from
filesystem cache (e.g. "ext4_inode_cache")

Changed sg ioctl to bounce commands through stack instead of directly
copying to/from "blkdev_requests" cache.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/kernel/signal.c |  6 +++---
 block/scsi_ioctl.c       | 27 +++++++++++++++++++++++++--
 fs/binfmt_elf.c          |  8 +++++++-
 fs/fhandle.c             |  3 +--
 fs/namei.c               | 11 ++++++++++-
 5 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 22cc2f9f8aec..479fb2b9afcd 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -680,8 +680,8 @@ static int
 setup_rt_frame(struct ksignal *ksig, struct pt_regs *regs)
 {
 	int usig = ksig->sig;
-	sigset_t *set = sigmask_to_save();
-	compat_sigset_t *cset = (compat_sigset_t *) set;
+	sigset_t sigcopy = *sigmask_to_save();
+	compat_sigset_t *cset = (compat_sigset_t *)&sigcopy;
 
 	/* Set up the stack frame */
 	if (is_ia32_frame()) {
@@ -692,7 +692,7 @@ setup_rt_frame(struct ksignal *ksig, struct pt_regs *regs)
 	} else if (is_x32_frame()) {
 		return x32_setup_rt_frame(ksig, cset, regs);
 	} else {
-		return __setup_rt_frame(ksig->sig, ksig, set, regs);
+		return __setup_rt_frame(ksig->sig, ksig, &sigcopy, regs);
 	}
 }
 
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 0774799942e0..c14d12a60a4c 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -227,8 +227,20 @@ EXPORT_SYMBOL(blk_verify_command);
 static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
 			     struct sg_io_hdr *hdr, fmode_t mode)
 {
-	if (copy_from_user(rq->cmd, hdr->cmdp, hdr->cmd_len))
+	unsigned char tmpcmd[sizeof(rq->__cmd)];
+	unsigned char *cmdptr;
+
+	if (rq->cmd != rq->__cmd)
+		cmdptr = rq->cmd;
+	else
+		cmdptr = tmpcmd;
+
+	if (copy_from_user(cmdptr, hdr->cmdp, hdr->cmd_len))
 		return -EFAULT;
+
+	if (cmdptr != rq->cmd)
+		memcpy(rq->cmd, cmdptr, hdr->cmd_len);
+
 	if (blk_verify_command(rq->cmd, mode & FMODE_WRITE))
 		return -EPERM;
 
@@ -420,6 +432,8 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 	int err;
 	unsigned int in_len, out_len, bytes, opcode, cmdlen;
 	char *buffer = NULL, sense[SCSI_SENSE_BUFFERSIZE];
+	unsigned char tmpcmd[sizeof(rq->__cmd)];
+	unsigned char *cmdptr;
 
 	if (!sic)
 		return -EINVAL;
@@ -458,9 +472,18 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 	 */
 	err = -EFAULT;
 	rq->cmd_len = cmdlen;
-	if (copy_from_user(rq->cmd, sic->data, cmdlen))
+
+	if (rq->cmd != rq->__cmd)
+		cmdptr = rq->cmd;
+	else
+		cmdptr = tmpcmd;
+
+	if (copy_from_user(cmdptr, sic->data, cmdlen))
 		goto error;
 
+	if (rq->cmd != cmdptr)
+		memcpy(rq->cmd, cmdptr, cmdlen);
+
 	if (in_len && copy_from_user(buffer, sic->data + cmdlen, in_len))
 		goto error;
 
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index e158b22ef32f..84edd23d7fcc 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -167,6 +167,8 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	int ei_index = 0;
 	const struct cred *cred = current_cred();
 	struct vm_area_struct *vma;
+	unsigned long saved_auxv[AT_VECTOR_SIZE];
+	size_t saved_auxv_size;
 
 	/*
 	 * In some cases (e.g. Hyper-Threading), we want to avoid L1
@@ -324,9 +326,13 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 		return -EFAULT;
 	current->mm->env_end = p;
 
+	saved_auxv_size = ei_index * sizeof(elf_addr_t);
+	BUG_ON(saved_auxv_size > sizeof(saved_auxv));
+	memcpy(saved_auxv, elf_info, saved_auxv_size);
+
 	/* Put the elf_info on the stack in the right place.  */
 	sp = (elf_addr_t __user *)envp + 1;
-	if (copy_to_user(sp, elf_info, ei_index * sizeof(elf_addr_t)))
+	if (copy_to_user(sp, saved_auxv, saved_auxv_size))
 		return -EFAULT;
 	return 0;
 }
diff --git a/fs/fhandle.c b/fs/fhandle.c
index ca3c3dd01789..7ccb0a3fc86c 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -67,8 +67,7 @@ static long do_sys_name_to_handle(struct path *path,
 	} else
 		retval = 0;
 	/* copy the mount id */
-	if (copy_to_user(mnt_id, &real_mount(path->mnt)->mnt_id,
-			 sizeof(*mnt_id)) ||
+	if (put_user(real_mount(path->mnt)->mnt_id, mnt_id) ||
 	    copy_to_user(ufh, handle,
 			 sizeof(struct file_handle) + handle_bytes))
 		retval = -EFAULT;
diff --git a/fs/namei.c b/fs/namei.c
index 4c4f95ac8aa5..3ad684dd5c94 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4616,14 +4616,23 @@ EXPORT_SYMBOL(vfs_whiteout);
 
 int readlink_copy(char __user *buffer, int buflen, const char *link)
 {
+	char tmpbuf[64];
+	const char *newlink;
 	int len = PTR_ERR(link);
+
 	if (IS_ERR(link))
 		goto out;
 
 	len = strlen(link);
 	if (len > (unsigned) buflen)
 		len = buflen;
-	if (copy_to_user(buffer, link, len))
+	if (len < sizeof(tmpbuf)) {
+		memcpy(tmpbuf, link, len);
+		newlink = tmpbuf;
+	} else
+		newlink = link;
+
+	if (copy_to_user(buffer, newlink, len))
 		len = -EFAULT;
 out:
 	return len;
-- 
2.7.4
