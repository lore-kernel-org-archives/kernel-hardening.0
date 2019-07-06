Return-Path: <SRS0=DtcG=VD=lists.openwall.com=kernel-hardening-return-16356-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,GAPPY_SUBJECT,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D9AC0650E
	for <kernel-hardening@archiver.kernel.org>; Sat,  6 Jul 2019 10:56:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 013DE214AF
	for <kernel-hardening@archiver.kernel.org>; Sat,  6 Jul 2019 10:56:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NXUxTn17"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 013DE214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16356-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25604 invoked by uid 550); 6 Jul 2019 10:55:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24494 invoked from network); 6 Jul 2019 10:55:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=neSAZr0qudklbC2ocAszdo5nTo2RaPTIwxDnwB9Bfh4=;
        b=NXUxTn17ctcRPNOUPFeMmXyn0eMc5qTzqtuYVVw1v6dvr165UiWXaMs4DE0Gnh5MVv
         bSmAUM0J9LX84qgbxFb7OMWQbgk4Zj9SnFo31GaRvl4xate/2l889tHMRthL7t6O8+v0
         YWrdWLxLQeTuX8FAPQ6I2Erh3ZZCnjvGJh4LJ9pTVBsjevF6plRFoJRt34JSKYSyIw4a
         F3dHpzvh68ih2JX84M6FjbQgrFB+SF1w71RWnV66YQ8fNEU1Ev/V4e3ZKjlrM4cnl98V
         FRv2Jw10/VLaxiwa3tk2CmV6tWHEFHWFLtVsaE76fgROy/oxNLZL4oYCldIhKoIb0NTY
         5FSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=neSAZr0qudklbC2ocAszdo5nTo2RaPTIwxDnwB9Bfh4=;
        b=sEHFaa/7H6vM4sqi1LwpYSNS8is5VyT/wdJJap7ibjoVKyc9kPn595vx/LWeNucO5F
         wd311DMDp/hHhZ4xrGyua2cP1nmWnXNFzHAdY+izQV/7HCISZgXB4QYWXNBpWpK3MV9b
         oxZUmqdiVXrkX4zabOykgwk7gki0Pd6Bblht8+Jr9zx2zZ/stye7byZ5MRcz2CyesoIf
         reamKW0VK62iforOBRnYXPPP1ajcZ9/xknpmyhLztkeiDB2nrOD903azyjlq/mTV4yk/
         3atTwe9EDYaw9NbICsYs34wRPXmhn4J6FzvMn9XOz4AKMMUO2GuIu9vLTnxJeGDRhW9P
         f9NQ==
X-Gm-Message-State: APjAAAXCL2YDEeEiDE1tr8XFDwtt2HBXgYZjvjJL6CNchaQUWJlMkvX5
	RPOEUU4xm4QG3qtVlDq+NCS3bvCcT+3S6A==
X-Google-Smtp-Source: APXvYqyj3Y0pdXAI8GwWuFskykzQj2FjjaVQ1LYXAEXUqG5HS9biwJxY0j1BLyCPepJq5qXexxxIzQ==
X-Received: by 2002:a1c:67c3:: with SMTP id b186mr7380497wmc.34.1562410518164;
        Sat, 06 Jul 2019 03:55:18 -0700 (PDT)
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
Subject: [PATCH v5 06/12] S.A.R.A.: WX protection
Date: Sat,  6 Jul 2019 12:54:47 +0200
Message-Id: <1562410493-8661-7-git-send-email-s.mesoraca16@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com>
References: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com>

Introduction of S.A.R.A. WX Protection.
It aims to improve user-space programs security by applying:
- W^X enforcement
- W!->X (once writable never executable) mprotect restriction
- Executable MMAP prevention

All of the above features can be enabled or disabled both system wide
or on a per executable basis through the use of configuration.
W^X enforcement works by blocking any memory allocation or mprotect
invocation with both the WRITE and the EXEC flags enabled.
W!->X restriction works by preventing any mprotect invocation that makes
executable any page that is flagged VM_MAYWRITE.
Additional restrictions are in place for System V shared memory segments:
if a segment was attached as writable (executable) in the past it won't be
allowed to be attached as executable (writable) in the future.
This feature can be configured separately for stack, heap and other
allocations.
Executable MMAP prevention works by preventing any new executable
allocation after the dynamic libraries have been loaded. It works under the
assumption that, when the dynamic libraries have been finished loading, the
RELRO section will be marked read only.

Parts of WX Protection are inspired by some of the features available in
PaX according to my understanding of the code. Changes or omissions from
the original code are mine and don't reflect the original grsecurity/PaX
code.

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 security/sara/Kconfig          |  74 +++++
 security/sara/Makefile         |   1 +
 security/sara/include/wxprot.h |  29 ++
 security/sara/main.c           |   6 +
 security/sara/wxprot.c         | 679 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 789 insertions(+)
 create mode 100644 security/sara/include/wxprot.h
 create mode 100644 security/sara/wxprot.c

diff --git a/security/sara/Kconfig b/security/sara/Kconfig
index b98cf27..54a96e0 100644
--- a/security/sara/Kconfig
+++ b/security/sara/Kconfig
@@ -60,3 +60,77 @@ config SECURITY_SARA_NO_RUNTIME_ENABLE
 
 	  If unsure, answer Y.
 
+config SECURITY_SARA_WXPROT
+	bool "WX Protection: W^X and W!->X protections"
+	depends on SECURITY_SARA
+	default y
+	help
+	  WX Protection aims to improve user-space programs security by applying:
+	    - W^X memory restriction
+	    - W!->X (once writable never executable) mprotect restriction
+	    - Executable MMAP prevention
+	  See Documentation/admin-guide/LSM/SARA.rst. for further information.
+
+	  If unsure, answer Y.
+
+choice
+	prompt "Default action for W^X and W!->X protections"
+	depends on SECURITY_SARA
+	depends on SECURITY_SARA_WXPROT
+	default SECURITY_SARA_WXPROT_DEFAULT_FLAGS_ALL_COMPLAIN_VERBOSE
+
+        help
+	  Choose the default behaviour of WX Protection when no config
+	  rule matches or no rule is loaded.
+	  For further information on available flags and their meaning
+	  see Documentation/admin-guide/LSM/SARA.rst.
+
+	config SECURITY_SARA_WXPROT_DEFAULT_FLAGS_ALL_COMPLAIN_VERBOSE
+		bool "Protections enabled but not enforced."
+		help
+		  All features enabled except "Executable MMAP prevention",
+		  verbose reporting, but no actual enforce: it just complains.
+		  Its numeric value is 0x3f, for more information see
+		  Documentation/admin-guide/LSM/SARA.rst.
+
+        config SECURITY_SARA_WXPROT_DEFAULT_FLAGS_ALL_ENFORCE_VERBOSE
+		bool "Full protection, verbose."
+		help
+		  All features enabled except "Executable MMAP prevention".
+		  The enabled features will be enforced with verbose reporting.
+		  Its numeric value is 0x2f, for more information see
+		  Documentation/admin-guide/LSM/SARA.rst.
+
+        config SECURITY_SARA_WXPROT_DEFAULT_FLAGS_ALL_ENFORCE
+		bool "Full protection, quiet."
+		help
+		  All features enabled except "Executable MMAP prevention".
+		  The enabled features will be enforced quietly.
+		  Its numeric value is 0xf, for more information see
+		  Documentation/admin-guide/LSM/SARA.rst.
+
+	config SECURITY_SARA_WXPROT_DEFAULT_FLAGS_NONE
+		bool "No protection at all."
+		help
+		  All features disabled.
+		  Its numeric value is 0, for more information see
+		  Documentation/admin-guide/LSM/SARA.rst.
+endchoice
+
+config SECURITY_SARA_WXPROT_DISABLED
+	bool "WX protection will be disabled at boot."
+	depends on SECURITY_SARA_WXPROT
+	default n
+	help
+	  If you say Y here WX protection won't be enabled at startup. You can
+	  override this option via user-space utilities or at boot time via
+	  "sara.wxprot_enabled=[0|1]" kernel parameter.
+
+	  If unsure, answer N.
+
+config SECURITY_SARA_WXPROT_DEFAULT_FLAGS
+	hex
+	default "0x3f" if SECURITY_SARA_WXPROT_DEFAULT_FLAGS_ALL_COMPLAIN_VERBOSE
+	default "0x2f" if SECURITY_SARA_WXPROT_DEFAULT_FLAGS_ALL_ENFORCE_VERBOSE
+	default "0xf" if SECURITY_SARA_WXPROT_DEFAULT_FLAGS_ALL_ENFORCE
+	default "0" if SECURITY_SARA_WXPROT_DEFAULT_FLAGS_NONE
diff --git a/security/sara/Makefile b/security/sara/Makefile
index ffa1be1..07751a5 100644
--- a/security/sara/Makefile
+++ b/security/sara/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_SECURITY_SARA) := sara.o
 
 sara-y := main.o securityfs.o utils.o sara_data.o dfa.o
 sara-$(CONFIG_SECURITY_SARA_DFA_TEST) += dfa_test.o
+sara-$(CONFIG_SECURITY_SARA_WXPROT) += wxprot.o
diff --git a/security/sara/include/wxprot.h b/security/sara/include/wxprot.h
new file mode 100644
index 0000000..df8705a
--- /dev/null
+++ b/security/sara/include/wxprot.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * S.A.R.A. Linux Security Module
+ *
+ * Copyright (C) 2017 Salvatore Mesoraca <s.mesoraca16@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __SARA_WXPROT_H
+#define __SARA_WXPROT_H
+
+#ifdef CONFIG_SECURITY_SARA_WXPROT
+
+#include <linux/init.h>
+int sara_wxprot_init(void) __init;
+
+#else /* CONFIG_SECURITY_SARA_WXPROT */
+inline int sara_wxprot_init(void)
+{
+	return 0;
+}
+#endif /* CONFIG_SECURITY_SARA_WXPROT */
+
+#endif /* __SARA_WXPROT_H */
diff --git a/security/sara/main.c b/security/sara/main.c
index 6b09500..676e901 100644
--- a/security/sara/main.c
+++ b/security/sara/main.c
@@ -21,6 +21,7 @@
 #include "include/sara.h"
 #include "include/sara_data.h"
 #include "include/securityfs.h"
+#include "include/wxprot.h"
 
 static const int sara_version = SARA_VERSION;
 
@@ -105,6 +106,11 @@ static int __init sara_init(void)
 		goto error;
 	}
 
+	if (sara_wxprot_init()) {
+		pr_crit("impossible to initialize WX protections.\n");
+		goto error;
+	}
+
 	pr_debug("initialized.\n");
 
 	if (sara_enabled)
diff --git a/security/sara/wxprot.c b/security/sara/wxprot.c
new file mode 100644
index 0000000..8a3d002
--- /dev/null
+++ b/security/sara/wxprot.c
@@ -0,0 +1,679 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * S.A.R.A. Linux Security Module
+ *
+ * Copyright (C) 2017 Salvatore Mesoraca <s.mesoraca16@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifdef CONFIG_SECURITY_SARA_WXPROT
+
+#include <linux/binfmts.h>
+#include <linux/cred.h>
+#include <linux/elf.h>
+#include <linux/kref.h>
+#include <linux/lsm_hooks.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+#include <linux/ratelimit.h>
+#include <linux/spinlock.h>
+
+#include "include/dfa.h"
+#include "include/sara.h"
+#include "include/sara_data.h"
+#include "include/utils.h"
+#include "include/securityfs.h"
+#include "include/wxprot.h"
+
+#define SARA_WXPROT_CONFIG_VERSION 0
+
+#define SARA_WXP_HEAP		0x0001
+#define SARA_WXP_STACK		0x0002
+#define SARA_WXP_OTHER		0x0004
+#define SARA_WXP_WXORX		0x0008
+#define SARA_WXP_COMPLAIN	0x0010
+#define SARA_WXP_VERBOSE	0x0020
+#define SARA_WXP_MMAP		0x0040
+#define SARA_WXP_TRANSFER	0x0200
+#define SARA_WXP_NONE		0x0000
+#define SARA_WXP_MPROTECT	(SARA_WXP_HEAP	| \
+				 SARA_WXP_STACK	| \
+				 SARA_WXP_OTHER)
+#define __SARA_WXP_ALL		(SARA_WXP_MPROTECT	| \
+				 SARA_WXP_MMAP		| \
+				 SARA_WXP_WXORX		| \
+				 SARA_WXP_COMPLAIN	| \
+				 SARA_WXP_VERBOSE)
+#define SARA_WXP_ALL		__SARA_WXP_ALL
+
+struct wxprot_config_container {
+	struct sara_dfa_tables *dfa;
+	struct kref refcount;
+};
+
+static struct wxprot_config_container __rcu *wxprot_config;
+
+static const int wxprot_config_version = SARA_WXPROT_CONFIG_VERSION;
+static int wxprot_enabled __read_mostly = true;
+static DEFINE_SPINLOCK(wxprot_config_lock);
+
+static u16 default_flags __lsm_ro_after_init =
+				CONFIG_SECURITY_SARA_WXPROT_DEFAULT_FLAGS;
+
+static const bool wxprot_emutramp;
+
+static void pr_wxp(char *msg)
+{
+	char *buf, *path;
+
+	path = get_current_path(&buf);
+	pr_notice_ratelimited("WXP: %s in '%s' (%d).\n",
+			      msg, path, current->pid);
+	kvfree(buf);
+}
+
+/**
+ * are_flags_valid - check whether the given combination of flags is valid
+ * @flags: the flags to be checked
+ *
+ * Returns true if flags are valid, false otherwise.
+ *
+ * Rules checked:
+ *   - Unused bits must be set to 0.
+ *   - Any feature in the "MPROTECT" group require "WXORX".
+ *   - "COMPLAIN" and "VERBOSE" can only be used if some other feature is
+ *     enabled.
+ *   - Trampoline emulation can only be used when all "MPROTECT"
+ *     features are active.
+ *   - "MMAP" protection requires SARA_WXP_OTHER
+ */
+static bool are_flags_valid(u16 flags)
+{
+	flags &= ~SARA_WXP_TRANSFER;
+	if (unlikely((flags & SARA_WXP_ALL) != flags))
+		return false;
+	if (unlikely(flags & SARA_WXP_MPROTECT &&
+		     !(flags & SARA_WXP_WXORX)))
+		return false;
+	if (unlikely(flags & (SARA_WXP_COMPLAIN | SARA_WXP_VERBOSE) &&
+		     !(flags & (SARA_WXP_MPROTECT |
+				SARA_WXP_WXORX |
+				SARA_WXP_MMAP))))
+		return false;
+	if (unlikely(flags & SARA_WXP_MMAP &&
+		     !(flags & SARA_WXP_OTHER)))
+		return false;
+	return true;
+}
+
+module_param(wxprot_enabled, int, 0);
+MODULE_PARM_DESC(wxprot_enabled,
+		 "Disable or enable S.A.R.A. WX Protection at boot time.");
+
+static int param_set_wxpflags(const char *val, const struct kernel_param *kp)
+{
+	u16 flags;
+
+	if (!val || kstrtou16(val, 0, &flags) != 0 || !are_flags_valid(flags))
+		return -EINVAL;
+	*(u16 *) kp->arg = flags;
+	return 0;
+}
+
+static struct kernel_param_ops param_ops_wxpflags = {
+	.set = param_set_wxpflags,
+};
+
+#define param_check_wxpflags(name, p) __param_check(name, p, u16)
+
+module_param_named(wxprot_default_flags, default_flags, wxpflags, 0);
+MODULE_PARM_DESC(wxprot_default_flags,
+		 "Disable or enable S.A.R.A. WX Protection at boot time.");
+
+/*
+ * MMAP exec restriction
+ */
+#define PT_GNU_RELRO (PT_LOOS + 0x474e552)
+
+union elfh {
+	struct elf32_hdr c32;
+	struct elf64_hdr c64;
+};
+
+union elfp {
+	struct elf32_phdr c32;
+	struct elf64_phdr c64;
+};
+
+#define find_relro_section(ELFH, ELFP, FILE, RELRO, FOUND) do {		\
+	unsigned long i;						\
+	int _tmp;							\
+	loff_t _pos = 0;						\
+	if (ELFH.e_type == ET_DYN || ELFH.e_type == ET_EXEC) {		\
+		for (i = 0; i < ELFH.e_phnum; ++i) {			\
+			_pos = ELFH.e_phoff + i*sizeof(ELFP);		\
+			_tmp = kernel_read(FILE, &ELFP, sizeof(ELFP),	\
+					   &_pos);			\
+			if (_tmp != sizeof(ELFP))			\
+				break;					\
+			if (ELFP.p_type == PT_GNU_RELRO) {		\
+				RELRO = ELFP.p_offset >> PAGE_SHIFT;	\
+				FOUND = true;				\
+				break;					\
+			}						\
+		}							\
+	}								\
+} while (0)
+
+static int set_relro_page(struct linux_binprm *bprm)
+{
+	union elfh elf_h;
+	union elfp elf_p;
+	unsigned long relro_page = 0;
+	bool relro_page_found = false;
+	int ret;
+	loff_t pos = 0;
+
+	ret = kernel_read(bprm->file, &elf_h, sizeof(elf_h), &pos);
+	if (ret == sizeof(elf_h) &&
+	    strncmp(elf_h.c32.e_ident, ELFMAG, SELFMAG) == 0) {
+		if (elf_h.c32.e_ident[EI_CLASS] == ELFCLASS32) {
+			find_relro_section(elf_h.c32,
+					   elf_p.c32,
+					   bprm->file,
+					   relro_page,
+					   relro_page_found);
+		} else if (IS_ENABLED(CONFIG_64BIT) &&
+			   elf_h.c64.e_ident[EI_CLASS] == ELFCLASS64) {
+			find_relro_section(elf_h.c64,
+					   elf_p.c64,
+					   bprm->file,
+					   relro_page,
+					   relro_page_found);
+		}
+	} else
+		return 2; /* It isn't an ELF */
+
+	if (relro_page_found) {
+		get_sara_relro_page(bprm->cred) = relro_page;
+		get_sara_relro_page_found(bprm->cred) = relro_page_found;
+		get_sara_relro_file(bprm->cred) = bprm->file;
+		return 0;
+	} else
+		return 1; /* It's an ELF without a RELRO section */
+}
+
+static inline int is_relro_page(const struct vm_area_struct *vma)
+{
+	if (get_current_sara_relro_page_found() &&
+	    get_current_sara_relro_page() == vma->vm_pgoff &&
+	    get_current_sara_relro_file() == vma->vm_file)
+		return 1;
+	return 0;
+}
+
+/*
+ * LSM hooks
+ */
+static int sara_bprm_set_creds(struct linux_binprm *bprm)
+{
+	int i;
+	struct wxprot_config_container *c;
+	u16 sara_wxp_flags = default_flags;
+	sara_dfa_output outfl;
+	char *buf = NULL;
+	char *path = NULL;
+	struct cred *current_new;
+
+	sara_wxp_flags = get_sara_wxp_flags(bprm->cred);
+	get_sara_mmap_blocked(bprm->cred) = false;
+	get_sara_relro_page_found(bprm->cred) = false;
+	get_sara_relro_page(bprm->cred) = 0;
+	get_sara_relro_file(bprm->cred) = NULL;
+	get_sara_wxp_flags(bprm->cred) = SARA_WXP_NONE;
+	get_sara_execve_flags(bprm->cred) = SARA_WXP_NONE;
+
+	if (!sara_enabled || !wxprot_enabled)
+		return 0;
+
+	/*
+	 * SARA_WXP_TRANSFER means that the parent
+	 * wants this child to inherit its flags.
+	 */
+	if (!(sara_wxp_flags & SARA_WXP_TRANSFER)) {
+		sara_wxp_flags = default_flags;
+		path = get_absolute_path(&bprm->file->f_path, &buf);
+		if (IS_ERR(path)) {
+			path = (char *) bprm->interp;
+			if (PTR_ERR(path) == -ENAMETOOLONG)
+				pr_warn_ratelimited("WXP: path too long for '%s'. Default flags will be used.\n",
+						path);
+			else
+				pr_warn_ratelimited("WXP: can't find path for '%s'. Default flags will be used.\n",
+						path);
+			goto skip_flags;
+		}
+		SARA_CONFIG_GET_RCU(c, wxprot_config);
+		if (sara_dfa_match(c->dfa, path, &outfl))
+			sara_wxp_flags = (u16) outfl;
+		SARA_CONFIG_PUT_RCU(c);
+	} else
+		path = (char *) bprm->interp;
+
+	if (sara_wxp_flags != default_flags &&
+	    sara_wxp_flags & SARA_WXP_VERBOSE)
+		pr_debug_ratelimited("WXP: '%s' run with flags '0x%x'.\n",
+				     path, sara_wxp_flags);
+
+skip_flags:
+	i = set_relro_page(bprm);
+	/*
+	 * i != 0 means no relro segment
+	 * i == 1 means the file wasn't an ELF
+	 *
+	 * We want to disable SARA_WXP_MMAP when the file is missing
+	 * the RELRO segment.
+	 * We want to verbosely report this case only if the file
+	 * was an ELF.
+	 *
+	 */
+	if (i != 0) {
+		if (sara_wxp_flags & SARA_WXP_VERBOSE &&
+		    sara_wxp_flags & SARA_WXP_MMAP &&
+		    i == 1)
+			pr_notice_ratelimited("WXP: failed to find RELRO section in '%s'.\n",
+					      path);
+		sara_wxp_flags &= ~SARA_WXP_MMAP;
+	}
+	kvfree(buf);
+	get_sara_wxp_flags(bprm->cred) = sara_wxp_flags;
+
+	/*
+	 * Set the flags to be used for validation
+	 * during the execve and discard SARA_WXP_MMAP:
+	 * it doesn't make sense to prevent executable
+	 * mmap during execve.
+	 */
+	current_new = prepare_creds();
+	if (unlikely(current_new == NULL))
+		return -ENOMEM;
+	get_sara_execve_flags(current_new) = sara_wxp_flags & ~SARA_WXP_MMAP;
+	commit_creds(current_new);
+
+	return 0;
+}
+
+#define sara_warn_or_return(err, msg) do {		\
+	if ((sara_wxp_flags & SARA_WXP_VERBOSE))	\
+		pr_wxp(msg);				\
+	if (!(sara_wxp_flags & SARA_WXP_COMPLAIN))	\
+		return -err;				\
+} while (0)
+
+#define sara_warn_or_goto(label, msg) do {		\
+	if ((sara_wxp_flags & SARA_WXP_VERBOSE))	\
+		pr_wxp(msg);				\
+	if (!(sara_wxp_flags & SARA_WXP_COMPLAIN))	\
+		goto label;				\
+} while (0)
+
+static int sara_check_vmflags(vm_flags_t vm_flags)
+{
+	u16 sara_wxp_flags;
+
+	if (!sara_enabled || !wxprot_enabled)
+		return 0;
+
+	/*
+	 * Memory allocations done during an execve should be
+	 * checked against the rules of the new executable,
+	 * instead of those of the current one.
+	 */
+	if (current->in_execve)
+		sara_wxp_flags = get_current_sara_execve_flags();
+	else
+		sara_wxp_flags = get_current_sara_wxp_flags();
+
+	/*
+	 * Be quiet when using security_check_vmflags to decide
+	 * what to do with a PT_GNU_STACK header
+	 */
+	if (current->in_execve && vm_flags == (VM_EXEC|VM_READ|VM_WRITE))
+		sara_wxp_flags &= ~SARA_WXP_VERBOSE;
+
+	/*
+	 * If "W xor X" is active for the current thread
+	 * this function must not allow new allocations that
+	 * have both the VM_WRITE and the VM_EXEC flags.
+	 */
+	if (unlikely(sara_wxp_flags & SARA_WXP_WXORX &&
+		     vm_flags & VM_WRITE &&
+		     vm_flags & VM_EXEC))
+		sara_warn_or_return(EPERM, "W^X");
+	/*
+	 * When the "MMAP" protection is on and shared libraries have
+	 * been already loaded (i.e. get_current_sara_mmap_blocked
+	 * returns true), this function must not allow:
+	 *    - new executable allocations
+	 *    - new non-executable allocations that may become
+	 *      executable bypassing the "MPROTECT" restriction;
+	 *      the "MPROTECT" protection will prevent a non-executable
+	 *      area to became executable only if it has the
+	 *      "VM_MAYWRITE" flag on.
+	 */
+	if (unlikely(sara_wxp_flags & SARA_WXP_MMAP &&
+		     (vm_flags & VM_EXEC ||
+		      (!(vm_flags & VM_MAYWRITE) && (vm_flags & VM_MAYEXEC))) &&
+		     get_current_sara_mmap_blocked()))
+		sara_warn_or_return(EPERM, "executable mmap");
+
+	return 0;
+}
+
+static int sara_shm_shmat(struct kern_ipc_perm *shp,
+			  char __user *shmaddr,
+			  int shmflg)
+{
+	int block = 0;
+	u16 sara_wxp_flags;
+	char buf[TASK_COMM_LEN];
+
+	if (!sara_enabled || !wxprot_enabled)
+		return 0;
+
+	sara_wxp_flags = get_current_sara_wxp_flags();
+
+	/*
+	 * Allow executable mappings if and only if this shm
+	 * was never attached as writable.
+	 *
+	 * Allow writable mappings if and only if this shm
+	 * was never attached as executable.
+	 *
+	 * We don't need to handle the case in which this
+	 * shm is attached as both writable and executable:
+	 * sara_check_vmflags takes care of that.
+	 */
+	if (sara_wxp_flags & SARA_WXP_OTHER) {
+		if (shmflg & SHM_EXEC && shmflg & SHM_RDONLY) {
+			lock_sara_shm(shp);
+			if (unlikely(get_sara_shm_no_exec(shp)))
+				block = 1;
+			else
+				get_sara_shm_no_write(shp) = true;
+			unlock_sara_shm(shp);
+		} else if (!(shmflg & (SHM_EXEC | SHM_RDONLY))) {
+			lock_sara_shm(shp);
+			if (unlikely(get_sara_shm_no_write(shp)))
+				block = 2;
+			else
+				get_sara_shm_no_exec(shp) = true;
+			unlock_sara_shm(shp);
+		}
+	}
+
+	if ((sara_wxp_flags & SARA_WXP_VERBOSE)) {
+		if (unlikely(block)) {
+			get_task_comm(buf, current);
+			if (block == 1)
+				pr_notice_ratelimited("WXP: executable SHM in '%s' (%d).\n",
+						      buf, current->pid);
+			else if (block == 2)
+				pr_notice_ratelimited("WXP: writable SHM in '%s' (%d).\n",
+						      buf, current->pid);
+		}
+	}
+	if (unlikely(block) && !(sara_wxp_flags & SARA_WXP_COMPLAIN))
+		return -EACCES;
+	return 0;
+}
+
+static int sara_file_mprotect(struct vm_area_struct *vma,
+				unsigned long reqprot,
+				unsigned long prot)
+{
+	u16 sara_wxp_flags;
+
+	if (!sara_enabled || !wxprot_enabled)
+		return 0;
+
+	if (current->in_execve)
+		sara_wxp_flags = get_current_sara_execve_flags();
+	else
+		sara_wxp_flags = get_current_sara_wxp_flags();
+
+	/*
+	 * vmas that may have been writable at some time in the past
+	 * (i.e. have the VM_MAYWRITE flag on) shouldn't be allowed
+	 * to be marked executable, unless they already are.
+	 */
+	if (unlikely(sara_wxp_flags & SARA_WXP_MPROTECT &&
+		     prot & PROT_EXEC &&
+		     !(vma->vm_flags & VM_EXEC) &&
+		     vma->vm_flags & VM_MAYWRITE)) {
+		/*
+		 * If every MPROTECT flag is on and verbose reporting
+		 * isn't needed, skip checking where the vma points to.
+		 * Otherwise check if it points to a file mapping,
+		 * to heap, to stack or to anywhere else.
+		 */
+		if ((sara_wxp_flags & SARA_WXP_MPROTECT) == SARA_WXP_MPROTECT &&
+		    !(sara_wxp_flags & SARA_WXP_COMPLAIN) &&
+		    !(sara_wxp_flags & SARA_WXP_VERBOSE))
+			return -EACCES;
+		else if (vma->vm_file) {
+			if (sara_wxp_flags & SARA_WXP_OTHER)
+				sara_warn_or_return(EACCES,
+						    "mprotect on file mmap");
+		} else if (vma->vm_start >= vma->vm_mm->start_brk &&
+			vma->vm_end <= vma->vm_mm->brk) {
+			if (sara_wxp_flags & SARA_WXP_HEAP)
+				sara_warn_or_return(EACCES,
+						    "mprotect on heap");
+		} else if ((vma->vm_start <= vma->vm_mm->start_stack &&
+			    vma->vm_end >= vma->vm_mm->start_stack) ||
+			   vma_is_stack_for_current(vma)) {
+			if (sara_wxp_flags & SARA_WXP_STACK)
+				sara_warn_or_return(EACCES,
+						    "mprotect on stack");
+		} else if (sara_wxp_flags & SARA_WXP_OTHER)
+			sara_warn_or_return(EACCES,
+					    "mprotect on anon mmap");
+	}
+
+	/*
+	 * If "W xor X" is active for the current thread
+	 * VM_EXEC and VM_WRITE can't be turned on at
+	 * the same time, unless they already are.
+	 */
+	if (unlikely(sara_wxp_flags & SARA_WXP_WXORX &&
+		     prot & PROT_EXEC &&
+		     prot & PROT_WRITE &&
+		     (!(vma->vm_flags & VM_EXEC) ||
+		      !(vma->vm_flags & VM_WRITE))))
+		sara_warn_or_return(EACCES, "W^X");
+
+	/*
+	 * If the dynamic loader marks the "relro section" as
+	 * read-only then it has finished loading shared libraries
+	 * and, if the SARA_WXP_MMAP flag is on, new executable
+	 * mmaps will be blocked from now on.
+	 */
+	if (unlikely(vma->vm_flags & VM_WRITE &&
+		     !(prot & PROT_WRITE) &&
+		     is_relro_page(vma)))
+		get_current_sara_mmap_blocked() = true;
+
+	return 0;
+}
+
+static struct security_hook_list wxprot_hooks[] __lsm_ro_after_init = {
+	LSM_HOOK_INIT(bprm_set_creds, sara_bprm_set_creds),
+	LSM_HOOK_INIT(check_vmflags, sara_check_vmflags),
+	LSM_HOOK_INIT(shm_shmat, sara_shm_shmat),
+	LSM_HOOK_INIT(file_mprotect, sara_file_mprotect),
+};
+
+static void config_free(struct wxprot_config_container *data)
+{
+	sara_dfa_free_tables(data->dfa);
+	kfree(data);
+}
+
+static bool are_flags_valid_dfa(sara_dfa_output flags)
+{
+	return are_flags_valid((u16) flags);
+}
+
+static int config_load(const char *buf, size_t buf_len)
+{
+	struct sara_dfa_tables *dfa = NULL;
+	struct wxprot_config_container *new;
+	int ret;
+
+	dfa = sara_dfa_load(buf, buf_len, are_flags_valid_dfa);
+	if (unlikely(IS_ERR_OR_NULL(dfa))) {
+		if (IS_ERR(dfa))
+			ret = PTR_ERR(dfa);
+		else
+			ret = -EINVAL;
+		goto error;
+	}
+	new = kmalloc(sizeof(*new), GFP_KERNEL);
+	if (unlikely(!new)) {
+		ret = -ENOMEM;
+		goto error_dfa;
+	}
+	kref_init(&new->refcount);
+	new->dfa = dfa;
+	SARA_CONFIG_REPLACE(wxprot_config,
+			    new,
+			    config_free,
+			    &wxprot_config_lock);
+	pr_notice("WXP: new rules loaded.\n");
+	return 0;
+error_dfa:
+	sara_dfa_free_tables(dfa);
+error:
+	pr_notice("WXP: failed to load rules.\n");
+	return ret;
+}
+
+static ssize_t config_dump(char **buf)
+{
+	ssize_t ret;
+	struct wxprot_config_container *c;
+
+	SARA_CONFIG_GET(c, wxprot_config);
+	ret = sara_dfa_dump(c->dfa, buf);
+	SARA_CONFIG_PUT(c, config_free);
+	return ret;
+}
+
+static int config_hash(char **buf)
+{
+	int ret;
+	struct wxprot_config_container *config;
+
+	ret = -ENOMEM;
+	*buf = kzalloc(sizeof(config->dfa->hash), GFP_KERNEL);
+	if (unlikely(*buf == NULL))
+		goto out;
+
+	SARA_CONFIG_GET_RCU(config, wxprot_config);
+	memcpy(*buf, config->dfa->hash, sizeof(config->dfa->hash));
+	SARA_CONFIG_PUT_RCU(config);
+
+	ret = 0;
+out:
+	return ret;
+}
+
+static DEFINE_SARA_SECFS_BOOL_FLAG(wxprot_enabled_data,
+				   wxprot_enabled);
+
+static struct sara_secfs_fptrs fptrs __lsm_ro_after_init = {
+	.load = config_load,
+	.dump = config_dump,
+	.hash = config_hash,
+};
+
+static const struct sara_secfs_node wxprot_fs[] __initconst = {
+	{
+		.name = "enabled",
+		.type = SARA_SECFS_BOOL,
+		.data = (void *) &wxprot_enabled_data,
+	},
+	{
+		.name = "version",
+		.type = SARA_SECFS_READONLY_INT,
+		.data = (int *) &wxprot_config_version,
+	},
+	{
+		.name = "default_flags",
+		.type = SARA_SECFS_READONLY_INT,
+		.data = &default_flags,
+	},
+	{
+		.name = "emutramp_available",
+		.type = SARA_SECFS_READONLY_INT,
+		.data = (int *) &wxprot_emutramp,
+	},
+	{
+		.name = ".load",
+		.type = SARA_SECFS_CONFIG_LOAD,
+		.data = &fptrs,
+	},
+	{
+		.name = ".dump",
+		.type = SARA_SECFS_CONFIG_DUMP,
+		.data = &fptrs,
+	},
+	{
+		.name = "hash",
+		.type = SARA_SECFS_CONFIG_HASH,
+		.data = &fptrs,
+	},
+};
+
+
+int __init sara_wxprot_init(void)
+{
+	int ret;
+	struct wxprot_config_container *tmpc = NULL;
+
+	ret = -EINVAL;
+	if (!are_flags_valid(default_flags))
+		goto out_fail;
+	ret = -ENOMEM;
+	tmpc = kzalloc(sizeof(*tmpc), GFP_KERNEL);
+	if (unlikely(tmpc == NULL))
+		goto out_fail;
+	kref_init(&tmpc->refcount);
+	tmpc->dfa = sara_dfa_make_null();
+	if (unlikely(!tmpc->dfa))
+		goto out_fail;
+	wxprot_config = (struct wxprot_config_container __rcu *) tmpc;
+	ret = sara_secfs_subtree_register("wxprot",
+					  wxprot_fs,
+					  ARRAY_SIZE(wxprot_fs));
+	if (unlikely(ret))
+		goto out_fail_dfa;
+	security_add_hooks(wxprot_hooks, ARRAY_SIZE(wxprot_hooks), "sara");
+	return 0;
+
+out_fail_dfa:
+	sara_dfa_free_tables(tmpc->dfa);
+out_fail:
+	kfree(tmpc);
+	return ret;
+}
+
+#endif /* CONFIG_SECURITY_SARA_WXPROT */
-- 
1.9.1

