Return-Path: <SRS0=uhXz=WU=lists.openwall.com=kernel-hardening-return-16800-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92CCC3A59E
	for <kernel-hardening@archiver.kernel.org>; Sat, 24 Aug 2019 06:32:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1382B2082F
	for <kernel-hardening@archiver.kernel.org>; Sat, 24 Aug 2019 06:32:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.com header.i=@yandex.com header.b="gxNWXLsR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1382B2082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=yandex.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16800-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17754 invoked by uid 550); 24 Aug 2019 06:32:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17722 invoked from network); 24 Aug 2019 06:32:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.com; s=mail; t=1566628310;
	bh=j/QPdatxmoLyMV0H9NJY41gjvuREoqnCFD9W1EnTPMc=;
	h=Subject:To:From:Date:Message-Id;
	b=gxNWXLsRtamLTFxmACHFen1hnOgpAW5i3gmHFCqpqnagZJReBdf8d+kqRMlYEJ5fm
	 qNbDXxV0VuU0X2gTGffc9HmbEF1AoOpZx+ddA7lxF5/ajAbNzIW8WsRIUumOhog6kq
	 foz0sVzPdiSJCzTCzU/dXwTdrrHfdGRv5+zjLMAc=
Authentication-Results: mxback24j.mail.yandex.net; dkim=pass header.i=@yandex.com
From: Lev Olshvang <levonshe@yandex.com>
To: kernel-hardening@lists.openwall.com
Subject: [RFC v2] security hardening: block write to read_only pages of a target process.
Date: Sat, 24 Aug 2019 02:31:44 -0400
Message-Id: <1566628304-1754-1-git-send-email-levonshe@yandex.com>
X-Mailer: git-send-email 2.7.4

The purpose of this patch is produce hardened kernel for Embedded
or Production systems.

Typically debuggers, such as gdb, write to read-only code [text]
sections of target process.(ptrace)
This kind of page protectiion violation raises minor page fault, but
kernel's fault handler allows it by default.
This is clearly attack surface for adversary.

The proposed kernel hardening configuration option checks the type of
protection of the foregn vma and blocks writes to read only vma.

When enabled, it will stop attacks modifying code or jump tables, etc.

Code of arch_vma_access_permitted() function was extended to
check foreign vma flags.

Tested on x86_64 and ARM(QEMU) with dd command which writes to
/proc/PID/mem in r--p or r--xp of vma area addresses range

dd reports IO failure when tries to write to adress taken from
from /proc/PID/maps (PLT or code section)

Signed-off-by: Lev Olshvang <levonshe@yandex.com>
---
 arch/powerpc/include/asm/mmu_context.h   |  8 +++++++-
 arch/powerpc/mm/book3s64/pkeys.c         |  6 ++++++
 arch/um/include/asm/mmu_context.h        |  8 ++++++--
 arch/unicore32/include/asm/mmu_context.h |  8 +++++++-
 arch/x86/include/asm/mmu_context.h       | 10 +++++++++-
 include/asm-generic/mm_hooks.h           |  6 ++++++
 security/Kconfig                         | 10 ++++++++++
 7 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/mmu_context.h b/arch/powerpc/include/asm/mmu_context.h
index 58efca9..85ff84f 100644
--- a/arch/powerpc/include/asm/mmu_context.h
+++ b/arch/powerpc/include/asm/mmu_context.h
@@ -251,10 +251,16 @@ void arch_dup_pkeys(struct mm_struct *oldmm, struct mm_struct *mm);
 static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
+#ifdef CONFIG_PROTECT_READONLY_USER_MEMORY
+	/* Forbid write to PROT_READ pages of foreign process */
+	if (write && foreign && (!(vma->vm_flags & VM_WRITE))) {
+		return false;
+	}
+#endif
 	/* by default, allow everything */
 	return true;
 }
-
+#endif
 #define pkey_mm_init(mm)
 #define thread_pkey_regs_save(thread)
 #define thread_pkey_regs_restore(new_thread, old_thread)
diff --git a/arch/powerpc/mm/book3s64/pkeys.c b/arch/powerpc/mm/book3s64/pkeys.c
index ae7fca4..af63182 100644
--- a/arch/powerpc/mm/book3s64/pkeys.c
+++ b/arch/powerpc/mm/book3s64/pkeys.c
@@ -406,6 +406,12 @@ static inline bool vma_is_foreign(struct vm_area_struct *vma)
 bool arch_vma_access_permitted(struct vm_area_struct *vma, bool write,
 			       bool execute, bool foreign)
 {
+#ifdef CONFIG_PROTECT_READONLY_USER_MEMORY
+	/* Forbid write to PROT_READ pages of foreign process */
+	if (write && foreign && (!(vma->vm_flags & VM_WRITE))) {
+		return false;
+	}
+#endif
 	if (static_branch_likely(&pkey_disabled))
 		return true;
 	/*
diff --git a/arch/um/include/asm/mmu_context.h b/arch/um/include/asm/mmu_context.h
index 00cefd3..e4c9bb2 100644
--- a/arch/um/include/asm/mmu_context.h
+++ b/arch/um/include/asm/mmu_context.h
@@ -29,14 +29,18 @@ static inline void arch_bprm_mm_init(struct mm_struct *mm,
 				     struct vm_area_struct *vma)
 {
 }
-
 static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
+#ifdef CONFIG_PROTECT_READONLY_USER_MEMORY
+	/* Forbid write to PROT_READ pages of foreign process */
+	if (write && foreign && (!(vma->vm_flags & VM_WRITE))) {
+		return false;
+	}
+#endif
 	/* by default, allow everything */
 	return true;
 }
-
 /*
  * end asm-generic/mm_hooks.h functions
  */
diff --git a/arch/unicore32/include/asm/mmu_context.h b/arch/unicore32/include/asm/mmu_context.h
index 247a07a..db657f7 100644
--- a/arch/unicore32/include/asm/mmu_context.h
+++ b/arch/unicore32/include/asm/mmu_context.h
@@ -97,7 +97,13 @@ static inline void arch_bprm_mm_init(struct mm_struct *mm,
 static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
+#ifdef CONFIG_PROTECT_READONLY_USER_MEMORY
+	/* Forbid write to PROT_READ pages of foreign process */
+	if (write && foreign && (!(vma->vm_flags & VM_WRITE))) {
+		return false;
+	}
+#endif
 	/* by default, allow everything */
 	return true;
 }
-#endif
+#endif /*__UNICORE_MMU_CONTEXT_H__*/
diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 9024236..06bb03d 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -329,12 +329,20 @@ static inline bool vma_is_foreign(struct vm_area_struct *vma)
 static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
-	/* pkeys never affect instruction fetches */
+#ifdef CONFIG_PROTECT_READONLY_USER_MEMORY
+	/* Forbid write to PROT_READ pages of foreign process */
+	if (write && foreign && (!(vma->vm_flags & VM_WRITE))) {
+		return false;
+	}
+#endif
+	/* Don't check PKRU since pkeys never affect instruction fetches */
 	if (execute)
 		return true;
+
 	/* allow access if the VMA is not one from this process */
 	if (foreign || vma_is_foreign(vma))
 		return true;
+
 	return __pkru_allows_pkey(vma_pkey(vma), write);
 }
 
diff --git a/include/asm-generic/mm_hooks.h b/include/asm-generic/mm_hooks.h
index 6736ed2..be3b14f 100644
--- a/include/asm-generic/mm_hooks.h
+++ b/include/asm-generic/mm_hooks.h
@@ -30,6 +30,12 @@ static inline void arch_bprm_mm_init(struct mm_struct *mm,
 static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
+#ifdef CONFIG_PROTECT_READONLY_USER_MEMORY
+	/* Forbid write to PROT_READ pages of foreign process */
+	if (write && foreign && (!(vma->vm_flags & VM_WRITE))) {
+		return false;
+	}
+#endif
 	/* by default, allow everything */
 	return true;
 }
diff --git a/security/Kconfig b/security/Kconfig
index 0d65594..61e81cf 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -143,6 +143,16 @@ config LSM_MMAP_MIN_ADDR
 	  this low address space will need the permission specific to the
 	  systems running LSM.
 
+config PROTECT_READONLY_USER_MEMORY
+	bool "Protect read only process memory"
+	help
+	  Protects read only memory of process code and PLT table from possible attack
+	  through /proc/PID/mem or through /dev/mem.
+	  Disables breakpoints of debuggers(prtace,gdb)
+	  Forbid writes to READ ONLY user pages of foreign process
+	  Mostly advised for embedded and production system.
+
+
 config HAVE_HARDENED_USERCOPY_ALLOCATOR
 	bool
 	help
-- 
2.7.4

