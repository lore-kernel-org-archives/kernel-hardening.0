Return-Path: <SRS0=rnyd=6A=lists.openwall.com=kernel-hardening-return-18526-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C84C2BB85
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Apr 2020 15:59:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 92E8D22253
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Apr 2020 15:59:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n8QCGLZU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 92E8D22253
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18526-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21504 invoked by uid 550); 16 Apr 2020 15:59:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20328 invoked from network); 16 Apr 2020 15:59:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PcoNYv1CKHPIME5jbmyn/e51urUFkVxFXVgUciQy3c4=;
        b=n8QCGLZU0gzjftVaj7IQnsAKhl5O89KpZ5cub7vlutR5L77Nvc+XLAI7jnjBTPuEaE
         i6RQ/tu2HaS8R5I5tO+F6N/Y+RPNW/fr+5NTwP3G3zhMfP+NsaPrFGje6yRdJA0ywK7z
         Or5zyrQjU0y2afdyZNS0Gd7GcxWByi7HsLO0jsg7rD7kcAyDI1DchhbD4cWloDbVte1p
         cicXBil+iwn+lPvBP06drJoz8cvUVGrKFI/R+MyHUmOpNA0VWBj+c6Aj9oF2fDWBfhZn
         7JOcY0zD0gAys1ROnHb1KII2AhBB1/YCXzcrGzuocpJYS9CPMzEFMvUOWB4p9BThVP17
         ryeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PcoNYv1CKHPIME5jbmyn/e51urUFkVxFXVgUciQy3c4=;
        b=BJ3UW0IgkZsCCDJ4Ezz79ulwKRV0qOMlO/dT7MmAIptsoUY2Veupn9ZUNNG48WuFr3
         p9VV2ZyzFOalvpVE+4dtwfjXy2JpSjyCUXK4kQGkNzZm+boANC+bcUkxzne2I+DCLqLN
         XA78T9c5pzl3m6jZmfFyoin22LYCoK/6D8hKdWup/4eubQplQn0f9xlI7eKSm61lfS0O
         Dg8m+GwljLGPkaOVVO4xwyTcFjB1G/a/GiNkOPTHBk2N7t65k16gKihRE+XVBxBS7sOM
         cJtMguqMuehcVHb5nBBMj3iHeb41S6oBzsIMKNjPNLlp1mJgg98kjGDyJazFykYUnhtF
         OoJQ==
X-Gm-Message-State: AGi0Puap1nJ6tNWp81NXRNA3IKRwHAgznGZEIdo0+cxT6wYmKnDLUNmO
	+7a5F7XUGxXa5Y5rHM5f6yZ8wExpxHs=
X-Google-Smtp-Source: APiQypJ5mEi5f+Jzbmva/aQFaJ7MuBp+PdKqlsXbQb6kFqlBfuMF1Ge74j9yAiJfU+R5NpA/E6uhCA==
X-Received: by 2002:a05:600c:2255:: with SMTP id a21mr5608098wmm.150.1587052763781;
        Thu, 16 Apr 2020 08:59:23 -0700 (PDT)
From: Lev Olshvang <levonshe@gmail.com>
To: keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com,
	Lev Olshvang <levonshe@gmail.com>
Subject: [PATCH v4 1/2] hardening : prevent write to read-only pages of user process
Date: Thu, 16 Apr 2020 18:59:16 +0300
Message-Id: <20200416155917.28536-2-levonshe@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200416155917.28536-1-levonshe@gmail.com>
References: <20200416155917.28536-1-levonshe@gmail.com>

The purpose of this patch is produce hardened kernel for Embedded
or Production systems.
This patch shouild close issue 37 opened by Kees Cook in KSPP project

Typically debuggers, such as gdb, write to read-only code [text]
sections of target process.(ptrace)
This kind of page protectiion violation raises minor page fault, but
kernel's fault handler allows it by default.
This is clearly attack surface for adversary.

The proposed kernel hardening configuration option checks the type of
protection of the foreign vma and blocks writes to read only vma.

When enabled, it will stop attacks modifying code or jump tables, etc.

Code of arch_vma_access_permitted() function was extended to
check foreign vma flags.

Tested on x86_64 and ARM(QEMU) with dd command which writes to
/proc/PID/mem in r--p or r--xp of vma area address range

dd reports IO failure when tries to write to address taken from
from /proc/PID/maps (PLT or code section)

Signed-off-by: Lev Olshvang <levonshe@gmail.com>
---
 include/asm-generic/mm_hooks.h |  7 ++++++-
 include/linux/mm.h             | 21 ++++++++++++++++++++-
 kernel/sysctl.c                | 29 +++++++++++++++++++----------
 mm/util.c                      |  2 ++
 security/Kconfig               | 18 ++++++++++++++++++
 5 files changed, 65 insertions(+), 12 deletions(-)

diff --git a/include/asm-generic/mm_hooks.h b/include/asm-generic/mm_hooks.h
index 4dbb177d1150..7f7f9fa6a17e 100644
--- a/include/asm-generic/mm_hooks.h
+++ b/include/asm-generic/mm_hooks.h
@@ -26,6 +26,11 @@ static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
 	/* by default, allow everything */
-	return true;
+	if (likely(vma_write_allowed(vma, write, foreign)))
+		return true;
+
+	pr_err_once("Error : PID[%d] %s writes to read only memory\n",
+		    current->tgid, current->comm);
+	return false;
 }
 #endif	/* _ASM_GENERIC_MM_HOOKS_H */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5a323422d783..9f259ef35011 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5,7 +5,6 @@
 #include <linux/errno.h>
 
 #ifdef __KERNEL__
-
 #include <linux/mmdebug.h>
 #include <linux/gfp.h>
 #include <linux/bug.h>
@@ -603,6 +602,26 @@ struct vm_operations_struct {
 					  unsigned long addr);
 };
 
+extern int sysctl_forbid_write_ro_mem __read_mostly;
+
+static inline bool vma_write_allowed(struct vm_area_struct *vma,
+		bool write, bool foreign)
+{
+	if (likely(sysctl_forbid_write_ro_mem == 0))
+		return true;
+
+	/* This function was called when write is true */
+	if (likely(write && (!(vma->vm_flags & VM_WRITE)))) {
+		/* Forbid write to PROT_READ pages from any process*/
+		if (sysctl_forbid_write_ro_mem == 2)
+			return false;
+		/* Forbid write to PROT_READ pages from foreign process*/
+		if (sysctl_forbid_write_ro_mem == 1 && foreign)
+			return false;
+	}
+
+	return true;
+}
 static inline void vma_init(struct vm_area_struct *vma, struct mm_struct *mm)
 {
 	static const struct vm_operations_struct dummy_vm_ops = {};
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8a176d8727a3..3df5c3223c19 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1320,7 +1320,7 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= overcommit_kbytes_handler,
 	},
 	{
-		.procname	= "page-cluster", 
+		.procname	= "page-cluster",
 		.data		= &page_cluster,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
@@ -1553,6 +1553,15 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= proc_dointvec,
 		.extra1		= SYSCTL_ZERO,
 	},
+	{
+		.procname	= "forbid_write_ro_mem",
+		.data		= &sysctl_forbid_write_ro_mem,
+		.maxlen		= sizeof(sysctl_forbid_write_ro_mem),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero_ul,
+		.extra2		= &two,
+	},
 #if defined(HAVE_ARCH_PICK_MMAP_LAYOUT) || \
     defined(CONFIG_ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT)
 	{
@@ -1838,7 +1847,7 @@ static struct ctl_table fs_table[] = {
 		.mode		= 0555,
 		.child		= inotify_table,
 	},
-#endif	
+#endif
 #ifdef CONFIG_EPOLL
 	{
 		.procname	= "epoll",
@@ -2319,12 +2328,12 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 	int *i, vleft, first = 1, err = 0;
 	size_t left;
 	char *kbuf = NULL, *p;
-	
+
 	if (!tbl_data || !table->maxlen || !*lenp || (*ppos && !write)) {
 		*lenp = 0;
 		return 0;
 	}
-	
+
 	i = (int *) tbl_data;
 	vleft = table->maxlen / sizeof(*i);
 	left = *lenp;
@@ -2550,7 +2559,7 @@ static int do_proc_douintvec(struct ctl_table *table, int write,
  * @ppos: file position
  *
  * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
- * values from/to the user buffer, treated as an ASCII string. 
+ * values from/to the user buffer, treated as an ASCII string.
  *
  * Returns 0 on success.
  */
@@ -3087,7 +3096,7 @@ static int do_proc_dointvec_ms_jiffies_conv(bool *negp, unsigned long *lvalp,
  * @ppos: file position
  *
  * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
- * values from/to the user buffer, treated as an ASCII string. 
+ * values from/to the user buffer, treated as an ASCII string.
  * The values read are assumed to be in seconds, and are converted into
  * jiffies.
  *
@@ -3109,8 +3118,8 @@ int proc_dointvec_jiffies(struct ctl_table *table, int write,
  * @ppos: pointer to the file position
  *
  * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
- * values from/to the user buffer, treated as an ASCII string. 
- * The values read are assumed to be in 1/USER_HZ seconds, and 
+ * values from/to the user buffer, treated as an ASCII string.
+ * The values read are assumed to be in 1/USER_HZ seconds, and
  * are converted into jiffies.
  *
  * Returns 0 on success.
@@ -3132,8 +3141,8 @@ int proc_dointvec_userhz_jiffies(struct ctl_table *table, int write,
  * @ppos: the current position in the file
  *
  * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
- * values from/to the user buffer, treated as an ASCII string. 
- * The values read are assumed to be in 1/1000 seconds, and 
+ * values from/to the user buffer, treated as an ASCII string.
+ * The values read are assumed to be in 1/1000 seconds, and
  * are converted into jiffies.
  *
  * Returns 0 on success.
diff --git a/mm/util.c b/mm/util.c
index 988d11e6c17c..99366829c759 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -911,3 +911,5 @@ int memcmp_pages(struct page *page1, struct page *page2)
 	kunmap_atomic(addr1);
 	return ret;
 }
+
+int sysctl_forbid_write_ro_mem __read_mostly = CONFIG_PROTECT_READONLY_USER_MEMORY;
diff --git a/security/Kconfig b/security/Kconfig
index cd3cc7da3a55..3d4ffcd8ec24 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -143,6 +143,24 @@ config LSM_MMAP_MIN_ADDR
 	  this low address space will need the permission specific to the
 	  systems running LSM.
 
+
+config PROTECT_READONLY_USER_MEMORY
+	int "Protect read only process memory 0 - 2"
+	default 0
+	range 0 2
+	help
+	  Protects read only memory of process code and PLT/GOT table
+	  from possible attack. Attack vector might be /proc/PID/mem, /dev/mem
+	  or process_vm_write() or ptrace() syscalls.
+	  Mostly advised for embedded and production system.
+	  Controlled by sysctl_forbid_write_ro_mem.
+	  Select 0 to allow write to read only memory
+	  Select 1 to forbid write to read only memory from other processes.
+	  As en effect, GDB will refuse to insert a breakpoints.
+	  Select 2 to forbid write to read only memory from any process including itself
+	  As en effect, will stop self modifing code
+
+
 config HAVE_HARDENED_USERCOPY_ALLOCATOR
 	bool
 	help
-- 
2.17.1

