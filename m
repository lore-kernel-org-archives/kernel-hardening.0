Return-Path: <SRS0=XoTh=WT=lists.openwall.com=kernel-hardening-return-16797-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF4C1C3A5A2
	for <kernel-hardening@archiver.kernel.org>; Fri, 23 Aug 2019 12:17:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F30DC233A0
	for <kernel-hardening@archiver.kernel.org>; Fri, 23 Aug 2019 12:17:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.com header.i=@yandex.com header.b="xKm6CFbe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F30DC233A0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=yandex.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16797-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3138 invoked by uid 550); 23 Aug 2019 12:17:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23704 invoked from network); 23 Aug 2019 11:11:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.com; s=mail; t=1566558673;
	bh=aIMtKPvtOA4JKs3oqqbbhmM1kkt4Hr+atU7ZXFdK22I=;
	h=Date:Subject:To:From:Message-Id;
	b=xKm6CFbe/xPfJ+hReBvqYcuDqXXkKBfIQ0hLp+/zNpe5AM0KKM5mE/+/I2KThnqgv
	 kc/a6q0LZs2NGl0YM/xU21GpfLisMa+GQmFWnDQWVydFlHnUHu+nz7ZV92mWNKRksV
	 6tddFx+/Qp5W4wNdL+LH9H77MbedveND6NAphIko=
Authentication-Results: mxback5o.mail.yandex.net; dkim=pass header.i=@yandex.com
From: Lev Olshvang <levonshe@yandex.com>
To: kernel-hardening@lists.openwall.com
Subject: [RFC] Refuse write to read_only pages of a target process. Target process is not a current process. It is foreign process. Typically  debuggers,such as gdb,  write to read-only code[text] sections of target. kernel hardening configuration option will stop attacks modifying code or jump tables. New logic denies to accept page fault caused by page protection violation.
Date: Fri, 23 Aug 2019 07:11:07 -0400
Message-Id: <1566558667-1678-1-git-send-email-levonshe@yandex.com>
X-Mailer: git-send-email 2.7.4

Separatly applied for x86,powerpc and unicore32
arch_vma_access_permitted() function is not referenced in unicore32 and um
architectures and seems to be obsolete,IMHO.

Tested on x86_64 and ARM(QEMU) with dd command which writes to
/proc/PID/mem in r--p or r--xp of vma area addresses range

dd reports IO failure when tries to write to adress taken from
from /proc/PID/maps (PLT or code section)

Signed-off-by: Lev Olshvang <levonshe@yandex.com>
---
 arch/powerpc/include/asm/mmu_context.h   |  7 +++++++
 arch/powerpc/mm/book3s64/pkeys.c         |  6 ++++++
 arch/um/include/asm/mmu_context.h        |  6 ++++++
 arch/unicore32/include/asm/mmu_context.h |  8 +++++++-
 arch/x86/include/asm/mmu_context.h       | 10 +++++++++-
 include/asm-generic/mm_hooks.h           |  6 ++++++
 security/Kconfig                         | 11 +++++++++++
 7 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/mmu_context.h b/arch/powerpc/include/asm/mmu_context.h
index 58efca9..db37c61 100644
--- a/arch/powerpc/include/asm/mmu_context.h
+++ b/arch/powerpc/include/asm/mmu_context.h
@@ -251,6 +251,13 @@ void arch_dup_pkeys(struct mm_struct *oldmm, struct mm_struct *mm);
 static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
+#ifdef CONFIG_PROTECT_READONLY_USER_MEMORY
+	if (write && foreign && (!(vma->vm_flags & VM_WRITE))) {
+		/* Forbid write to PROT_READ pages of foreign process */
+		return false;
+	}
+#endif
+
 	/* by default, allow everything */
 	return true;
 }
diff --git a/arch/powerpc/mm/book3s64/pkeys.c b/arch/powerpc/mm/book3s64/pkeys.c
index ae7fca4..b70fdfd 100644
--- a/arch/powerpc/mm/book3s64/pkeys.c
+++ b/arch/powerpc/mm/book3s64/pkeys.c
@@ -406,6 +406,12 @@ static inline bool vma_is_foreign(struct vm_area_struct *vma)
 bool arch_vma_access_permitted(struct vm_area_struct *vma, bool write,
 			       bool execute, bool foreign)
 {
+#ifdef CONFIG_PROTECT_READONLY_USER_MEMORY
+	if (write && foreign && (!(vma->vm_flags & VM_WRITE))) {
+		/* Forbid write to PROT_READ pages of foreign process */
+		return false;
+	}
+#endif
 	if (static_branch_likely(&pkey_disabled))
 		return true;
 	/*
diff --git a/arch/um/include/asm/mmu_context.h b/arch/um/include/asm/mmu_context.h
index 00cefd3..2c56ce9 100644
--- a/arch/um/include/asm/mmu_context.h
+++ b/arch/um/include/asm/mmu_context.h
@@ -33,6 +33,12 @@ static inline void arch_bprm_mm_init(struct mm_struct *mm,
 static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
+#ifdef CONFIG_PROTECT_READONLY_USER_MEMORY
+	if (write && foreign && (!(vma->vm_flags & VM_WRITE))) {
+		/* Forbid write to PROT_READ pages of foreign process */
+		return false;
+	}
+#endif
 	/* by default, allow everything */
 	return true;
 }
diff --git a/arch/unicore32/include/asm/mmu_context.h b/arch/unicore32/include/asm/mmu_context.h
index 247a07a..730997c 100644
--- a/arch/unicore32/include/asm/mmu_context.h
+++ b/arch/unicore32/include/asm/mmu_context.h
@@ -97,7 +97,13 @@ static inline void arch_bprm_mm_init(struct mm_struct *mm,
 static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
+#ifdef CONFIG_PROTECT_READONLY_USER_MEMORY
+	if (write && foreign && (!(vma->vm_flags & VM_WRITE))) {
+		/* Forbid write to PROT_READ pages of foreign process */
+		return false;
+	}
+#endif
 	/* by default, allow everything */
 	return true;
 }
-#endif
+#endif /*__UNICORE_MMU_CONTEXT_H__*/
diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 9024236..77b2801 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -329,12 +329,20 @@ static inline bool vma_is_foreign(struct vm_area_struct *vma)
 static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
-	/* pkeys never affect instruction fetches */
+
+#ifdef CONFIG_PROTECT_READONLY_USER_MEMORY
+	if (write && foreign && (!(vma->vm_flags & VM_WRITE))) {
+		/* Forbid write to PROT_READ pages of foreign process */
+		return false;
+	}
+#endif
+	/* Don't check PKRU since pkeys never affect instruction fetches */
 	if (execute)
 		return true;
 	/* allow access if the VMA is not one from this process */
 	if (foreign || vma_is_foreign(vma))
 		return true;
+
 	return __pkru_allows_pkey(vma_pkey(vma), write);
 }
 
diff --git a/include/asm-generic/mm_hooks.h b/include/asm-generic/mm_hooks.h
index 6736ed2..31dae5a 100644
--- a/include/asm-generic/mm_hooks.h
+++ b/include/asm-generic/mm_hooks.h
@@ -30,6 +30,12 @@ static inline void arch_bprm_mm_init(struct mm_struct *mm,
 static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
+#ifdef CONFIG_PROTECT_READONLY_USER_MEMORY
+	if (write && foreign && (!(vma->vm_flags & VM_WRITE))) {
+		/* Forbid write to PROT_READ pages of foreign process */
+		return false;
+	}
+#endif
 	/* by default, allow everything */
 	return true;
 }
diff --git a/security/Kconfig b/security/Kconfig
index 0d65594..03ff948 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -143,6 +143,17 @@ config LSM_MMAP_MIN_ADDR
 	  this low address space will need the permission specific to the
 	  systems running LSM.
 
+config PROTECT_READONLY_USER_MEMORY
+	bool "protect read only process memory"
+	depends on !(CONFIG_CROSS_MEMORY_ATTACH)
+	help
+	  Protects read only memory of process code and PLT table from possible attack
+	  through /proc/PID/mem.
+	  Forbid writes to READ ONLY user pages of foreign process
+	  Mostly advised for embedded and production system.
+	  Disables process_vm_writev() syscall used in MP computing.
+
+
 config HAVE_HARDENED_USERCOPY_ALLOCATOR
 	bool
 	help
-- 
2.7.4

