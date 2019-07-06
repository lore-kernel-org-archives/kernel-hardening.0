Return-Path: <SRS0=Dwod=VD=lists.openwall.com=kernel-hardening-return-16359-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,GAPPY_SUBJECT,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58AE7C0650E
	for <kernel-hardening@archiver.kernel.org>; Sat,  6 Jul 2019 10:57:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 796D3214AF
	for <kernel-hardening@archiver.kernel.org>; Sat,  6 Jul 2019 10:57:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rPg5B9Tq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 796D3214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16359-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25772 invoked by uid 550); 6 Jul 2019 10:55:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25672 invoked from network); 6 Jul 2019 10:55:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2o5CRslS3uRS8RVi/y7cIRyfxfb3HvwyRL/v1ZeEIno=;
        b=rPg5B9TqS7krvMJJliXmsCRezH5NtE0qwL7MshANq/BMIQk+fLCGGDvdN0TqTFS/Hg
         6+JesQatpm70HrH1/sKDHhJW5NuJ9lbPo/Pt3diMYQHeYiUTvped3PnPQZHI+4YJ0jN8
         9/g0eLOYr5OMGYidjZj/2dAXPCxNHpShNsdocDH/i6xFouRHR8c8cHVZsIJgLYUcb0DD
         FQpwJKoiJ419jrwGoHRUHCLQTGHHWLdYLwHvsLFGedgjUlQUYEHsbPU+I9QqdvMXnfZ9
         v9/8/wdff2V5mB4KBlxcXIQv7e6lcDopq/KTB5+TyDiIp+3dMLe+RN3aV4nQOiuYU/ye
         mN5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2o5CRslS3uRS8RVi/y7cIRyfxfb3HvwyRL/v1ZeEIno=;
        b=GZPDj7mPyCZg/JQCf6gmQU6YgOrqwLm+sAdb7BE7WPdsyNhdIAm5A7P2diP584d9KO
         FBAL8zbYIsDSF1FC/ziUKyZYRKG+QZgsWy6RutSHG8QG83jq/51VWz2qU1ay9/6sBV1o
         o5XBAEy+P2keXoH+c+7/sOo802jLpDiLyTvaQLyVZ9Scp2jQ4aAQu+PMof3UfXlVooXI
         JeEHKN1+4v1MfKthYXNUamuWaeRILF0x+gqsEypv1/34enL6fmciHRLRaDO8OTAybuTk
         tFAtlK/JExGvIf+GeQ2zO99Way3BXcezCqOaDTdP+B319I47EMEGQxdYOefCqvAsZy4K
         Kj+g==
X-Gm-Message-State: APjAAAWoj4yxr7ROlHhFLKB5JDM0Nhr+UEhKbmWp3lbsGnjWm2FTwflk
	jzmZpGqMgpqtG+akwbpdmw0=
X-Google-Smtp-Source: APXvYqztD1m1u9aJTdBW5y6FhM7gZEDkT1ZI7+xUeEaha6acs1qD6E71wBnezSnp1EbFzIl12Fdq9g==
X-Received: by 2002:a5d:42c5:: with SMTP id t5mr8328348wrr.5.1562410521889;
        Sat, 06 Jul 2019 03:55:21 -0700 (PDT)
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Brad Spengler <spender@grsecurity.net>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Christoph Hellwig <hch@infradead.org>,
	James Morris <james.l.morris@oracle.com>,
	Jann Horn <jannh@google.com>,
	Kees Cook <keescook@chromium.org>,
	PaX Team <pageexec@freemail.hu>,
	Salvatore Mesoraca <s.mesoraca16@gmail.com>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v5 09/12] S.A.R.A.: WX protection procattr interface
Date: Sat,  6 Jul 2019 12:54:50 +0200
Message-Id: <1562410493-8661-10-git-send-email-s.mesoraca16@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com>
References: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com>

This allow threads to get current WX Protection flags for themselves or
for other threads (if they have CAP_MAC_ADMIN).
It also allow a thread to set itself flags to a stricter set of rules than
the current one.
Via a new wxprot flag (SARA_WXP_FORCE_WXORX) is it possible to ask the
kernel to rescan the memory and remove the VM_WRITE flag from any area
that is marked both writable and executable.
Protections that prevent the runtime creation of executable code
can be troublesome for all those programs that actually need to do it
e.g. programs shipping with a JIT compiler built-in.
This feature can be use to run the JIT compiler with few restrictions while
enforcing full WX Protection in the rest of the program.
To simplify access to this interface a CC0 licensed library is available
here: https://github.com/smeso/libsara

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 fs/proc/base.c         |  11 ++++
 security/sara/wxprot.c | 150 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 161 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 255f675..7873d27 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2612,6 +2612,13 @@ static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,
 LSM_DIR_OPS(smack);
 #endif
 
+#ifdef CONFIG_SECURITY_SARA
+static const struct pid_entry sara_attr_dir_stuff[] = {
+	ATTR("sara", "wxprot", 0666),
+};
+LSM_DIR_OPS(sara);
+#endif
+
 static const struct pid_entry attr_dir_stuff[] = {
 	ATTR(NULL, "current",		0666),
 	ATTR(NULL, "prev",		0444),
@@ -2623,6 +2630,10 @@ static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,
 	DIR("smack",			0555,
 	    proc_smack_attr_dir_inode_ops, proc_smack_attr_dir_ops),
 #endif
+#ifdef CONFIG_SECURITY_SARA
+	DIR("sara",			0555,
+	    proc_sara_attr_dir_inode_ops, proc_sara_attr_dir_ops),
+#endif
 };
 
 static int proc_attr_dir_readdir(struct file *file, struct dir_context *ctx)
diff --git a/security/sara/wxprot.c b/security/sara/wxprot.c
index 9c42bfc..84f7b1e 100644
--- a/security/sara/wxprot.c
+++ b/security/sara/wxprot.c
@@ -14,6 +14,7 @@
 #ifdef CONFIG_SECURITY_SARA_WXPROT
 
 #include <linux/binfmts.h>
+#include <linux/capability.h>
 #include <linux/cred.h>
 #include <linux/elf.h>
 #include <linux/kref.h>
@@ -42,6 +43,7 @@
 #define SARA_WXP_COMPLAIN	0x0010
 #define SARA_WXP_VERBOSE	0x0020
 #define SARA_WXP_MMAP		0x0040
+#define SARA_WXP_FORCE_WXORX	0x0080
 #define SARA_WXP_EMUTRAMP	0x0100
 #define SARA_WXP_TRANSFER	0x0200
 #define SARA_WXP_NONE		0x0000
@@ -540,6 +542,152 @@ static int sara_pagefault_handler(struct pt_regs *regs,
 }
 #endif
 
+static int sara_getprocattr(struct task_struct *p, char *name, char **value)
+{
+	int ret;
+	u16 flags;
+	char *buf;
+
+	ret = -EINVAL;
+	if (strcmp(name, "wxprot") != 0)
+		goto out;
+
+	ret = -EACCES;
+	if (unlikely(current != p &&
+		     !capable(CAP_MAC_ADMIN)))
+		goto out;
+
+	ret = -ENOMEM;
+	buf = kzalloc(8, GFP_KERNEL);
+	if (unlikely(buf == NULL))
+		goto out;
+
+	if (!sara_enabled || !wxprot_enabled) {
+		flags = 0x0;
+	} else {
+		rcu_read_lock();
+		flags = get_sara_wxp_flags(__task_cred(p));
+		rcu_read_unlock();
+	}
+
+	snprintf(buf, 8, "0x%04x\n", flags);
+	ret = strlen(buf);
+	*value = buf;
+
+out:
+	return ret;
+}
+
+static int sara_setprocattr(const char *name, void *value, size_t size)
+{
+	int ret;
+	struct vm_area_struct *vma;
+	struct cred *new = prepare_creds();
+	u16 cur_flags;
+	u16 req_flags;
+	char *buf = NULL;
+
+	ret = -EINVAL;
+	if (!sara_enabled || !wxprot_enabled)
+		goto error;
+	if (unlikely(new == NULL))
+		return -ENOMEM;
+	if (strcmp(name, "wxprot") != 0)
+		goto error;
+	if (unlikely(value == NULL || size == 0 || size > 7))
+		goto error;
+	ret = -ENOMEM;
+	buf = kmalloc(size+1, GFP_KERNEL);
+	if (unlikely(buf == NULL))
+		goto error;
+	buf[size] = '\0';
+	memcpy(buf, value, size);
+	ret = -EINVAL;
+	if (unlikely(strlen(buf) != size))
+		goto error;
+	if (unlikely(kstrtou16(buf, 0, &req_flags) != 0))
+		goto error;
+	/*
+	 * SARA_WXP_FORCE_WXORX is a procattr only flag with a special
+	 * meaning and it isn't recognized by are_flags_valid
+	 */
+	if (unlikely(!are_flags_valid(req_flags & ~SARA_WXP_FORCE_WXORX)))
+		goto error;
+	/*
+	 * Extra checks on requested flags:
+	 *   - SARA_WXP_FORCE_WXORX requires SARA_WXP_WXORX
+	 *   - SARA_WXP_MMAP can only be activated if the program
+	 *     has a relro section
+	 *   - COMPLAIN mode can only be requested if it was already
+	 *     on (procattr can only be used to make protection stricter)
+	 *   - EMUTRAMP can only be activated if it was already on or
+	 *     if MPROTECT and WXORX weren't already on (procattr can
+	 *     only be used to make protection stricter)
+	 *   - VERBOSITY request is ignored
+	 */
+	if (unlikely(req_flags & SARA_WXP_FORCE_WXORX &&
+		     !(req_flags & SARA_WXP_WXORX)))
+		goto error;
+	if (unlikely(!get_current_sara_relro_page_found() &&
+		     req_flags & SARA_WXP_MMAP))
+		goto error;
+	cur_flags = get_current_sara_wxp_flags();
+	if (unlikely((req_flags & SARA_WXP_COMPLAIN) &&
+		     !(cur_flags & SARA_WXP_COMPLAIN)))
+		goto error;
+	if (unlikely((req_flags & SARA_WXP_EMUTRAMP) &&
+		     !(cur_flags & SARA_WXP_EMUTRAMP) &&
+		     (cur_flags & (SARA_WXP_MPROTECT |
+				   SARA_WXP_WXORX))))
+		goto error;
+	if (cur_flags & SARA_WXP_VERBOSE)
+		req_flags |= SARA_WXP_VERBOSE;
+	else
+		req_flags &= ~SARA_WXP_VERBOSE;
+	/*
+	 * Except SARA_WXP_COMPLAIN and SARA_WXP_EMUTRAMP,
+	 * any other flag can't be removed (procattr can
+	 * only be used to make protection stricter).
+	 */
+	if (unlikely(cur_flags & (req_flags ^ cur_flags) &
+		     ~(SARA_WXP_COMPLAIN|SARA_WXP_EMUTRAMP)))
+		goto error;
+	ret = -EINTR;
+	/*
+	 * When SARA_WXP_FORCE_WXORX is on we traverse all the
+	 * memory and remove the write permission from any area
+	 * that is both writable and executable.
+	 */
+	if (req_flags & SARA_WXP_FORCE_WXORX) {
+		if (down_write_killable(&current->mm->mmap_sem))
+			goto error;
+		for (vma = current->mm->mmap; vma; vma = vma->vm_next) {
+			if (vma->vm_flags & VM_EXEC &&
+			    vma->vm_flags & VM_WRITE) {
+				vma->vm_flags &= ~VM_WRITE;
+				vma_set_page_prot(vma);
+				change_protection(vma,
+						  vma->vm_start,
+						  vma->vm_end,
+						  vma->vm_page_prot,
+						  0,
+						  0);
+			}
+		}
+		up_write(&current->mm->mmap_sem);
+	}
+	get_sara_wxp_flags(new) = req_flags & ~SARA_WXP_FORCE_WXORX;
+	commit_creds(new);
+	ret = size;
+	goto out;
+
+error:
+	abort_creds(new);
+out:
+	kfree(buf);
+	return ret;
+}
+
 static struct security_hook_list wxprot_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(bprm_set_creds, sara_bprm_set_creds),
 	LSM_HOOK_INIT(check_vmflags, sara_check_vmflags),
@@ -548,6 +696,8 @@ static int sara_pagefault_handler(struct pt_regs *regs,
 #ifdef CONFIG_SECURITY_SARA_WXPROT_EMUTRAMP
 	LSM_HOOK_INIT(pagefault_handler, sara_pagefault_handler),
 #endif
+	LSM_HOOK_INIT(getprocattr, sara_getprocattr),
+	LSM_HOOK_INIT(setprocattr, sara_setprocattr),
 };
 
 static void config_free(struct wxprot_config_container *data)
-- 
1.9.1

