Return-Path: <SRS0=SXVH=5Q=lists.openwall.com=kernel-hardening-return-18315-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C7DC43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 04:49:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B25B0206EB
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 04:49:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="PZ047Cqx";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Ze8iTVjl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B25B0206EB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18315-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17594 invoked by uid 550); 31 Mar 2020 04:49:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17529 invoked from network); 31 Mar 2020 04:48:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=GUoylZfwGXXUQ
	zXJLlC+XHEoNWZPS5Q278HAm5/6Phc=; b=PZ047Cqxk1ghS8CRCnyaEnzlufyIi
	kRD5EreUfwOEh6+Ybu2mSughuL2Ti36tz5oJnmWPRGp2f+uC7IduMTeiWjr8Ozg6
	T0AzAzayHjwbCrAzrg4hAd9MIoKT5zc8K4aSx+A8ssygx6b4EyqofsGw+xmP4iPM
	EAfUIrpnKC3xx532Cjz1aKhJtmFyiKDMTg8cNnxHI/r8IvPKEvLyqzNKtZm2d5Fv
	w6D9abHlgUD7M9UwvB9l6c2SXhQyTdixNaQBC3t4FlcR6Mnv/as25gTp3m9fY/5o
	Pe8YeFfCCtiPExBlKcMNuECNO6TGcuNyjzc74pJz7lO/ZFg/dxZnrUZ6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=GUoylZfwGXXUQzXJLlC+XHEoNWZPS5Q278HAm5/6Phc=; b=Ze8iTVjl
	FUvP4oO1ObeSpEGLiWxupJ1UcP31ZB0zG4H8HisSE7OHlk1Zvle1fXcXinWGC6HX
	JKrSgWanEua77FEJJocCGXKYcdphWHBV10a5FlPkQRf/s32D7XpeGRUtqcmVVoN5
	z3L8IZGLGv39ill1j5Tcw7c3sq13IlS3hkt5V0AXiZev5zsm2aLWUv/weT4+R/SC
	A21qZ/k7qnPUQ0/DE6e/V2OSX41/SoJjUVSp/GTcN/MuNHGgiz4CH74373bxK+q+
	eSNwmLOXJYR3BZrJsCd2S8mbRsuXg0kOI3m8lJveknGTmP9ivI6M3vOmXBvvJErm
	a6dzhc86iTEivQ==
X-ME-Sender: <xms:rsuCXsvTcVsRxiNuEVZAQ1R4zcV0XWj7ffXHKS9XTm2qzWI4kLpUxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeiiedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdluddtmdenucfjughrpefhvf
    fufffkofgjfhgggfestdekredtredttdenucfhrhhomheptfhushhsvghllhcuvehurhhr
    vgihuceorhhushgtuhhrsehruhhsshgvlhhlrdgttgeqnecukfhppeduvddurdeghedrvd
    duvddrvdefleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehruhhstghurhesrhhushhsvghllhdrtggt
X-ME-Proxy: <xmx:rsuCXsat5IzZ9L44pOMnCx__UEpjlMroJPb9itn0Y2VhVvu6VoG3Eg>
    <xmx:rsuCXv81zrRX4FJYWkJiPhHTJzRVL0iB4l0cLCYCozXFNls6QsgYWQ>
    <xmx:rsuCXuC7XcZFVfj2PzSkk257kwYM8G2AAGURIjumQbwunlbGqO7iTg>
    <xmx:rsuCXshW-lnBMENGNZ73LKHfM7g4I8SjXsHp4x9Fbk9rMtWftQtjOQ>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: Russell Currey <ruscur@russell.cc>,
	christophe.leroy@c-s.fr,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v7 1/7] powerpc/mm: Implement set_memory() routines
Date: Tue, 31 Mar 2020 15:48:19 +1100
Message-Id: <20200331044825.591653-2-ruscur@russell.cc>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331044825.591653-1-ruscur@russell.cc>
References: <20200331044825.591653-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The set_memory_{ro/rw/nx/x}() functions are required for STRICT_MODULE_RWX,
and are generally useful primitives to have.  This implementation is
designed to be completely generic across powerpc's many MMUs.

It's possible that this could be optimised to be faster for specific
MMUs, but the focus is on having a generic and safe implementation for
now.

This implementation does not handle cases where the caller is attempting
to change the mapping of the page it is executing from, or if another
CPU is concurrently using the page being altered.  These cases likely
shouldn't happen, but a more complex implementation with MMU-specific code
could safely handle them, so that is left as a TODO for now.

These functions do nothing if STRICT_KERNEL_RWX is not enabled.

Reviewed-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
v7: Use apply_to_existing_page_range() and check for negative numpages

arch/powerpc/Kconfig                  |  1 +
 arch/powerpc/include/asm/set_memory.h | 32 +++++++++++
 arch/powerpc/mm/Makefile              |  2 +-
 arch/powerpc/mm/pageattr.c            | 81 +++++++++++++++++++++++++++
 4 files changed, 115 insertions(+), 1 deletion(-)
 create mode 100644 arch/powerpc/include/asm/set_memory.h
 create mode 100644 arch/powerpc/mm/pageattr.c

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 497b7d0b2d7e..bd074246e34e 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -129,6 +129,7 @@ config PPC
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_MEMBARRIER_CALLBACKS
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC_BOOK3S_64
+	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !HIBERNATION)
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UACCESS_FLUSHCACHE
diff --git a/arch/powerpc/include/asm/set_memory.h b/arch/powerpc/include/asm/set_memory.h
new file mode 100644
index 000000000000..64011ea444b4
--- /dev/null
+++ b/arch/powerpc/include/asm/set_memory.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_POWERPC_SET_MEMORY_H
+#define _ASM_POWERPC_SET_MEMORY_H
+
+#define SET_MEMORY_RO	0
+#define SET_MEMORY_RW	1
+#define SET_MEMORY_NX	2
+#define SET_MEMORY_X	3
+
+int change_memory_attr(unsigned long addr, int numpages, long action);
+
+static inline int set_memory_ro(unsigned long addr, int numpages)
+{
+	return change_memory_attr(addr, numpages, SET_MEMORY_RO);
+}
+
+static inline int set_memory_rw(unsigned long addr, int numpages)
+{
+	return change_memory_attr(addr, numpages, SET_MEMORY_RW);
+}
+
+static inline int set_memory_nx(unsigned long addr, int numpages)
+{
+	return change_memory_attr(addr, numpages, SET_MEMORY_NX);
+}
+
+static inline int set_memory_x(unsigned long addr, int numpages)
+{
+	return change_memory_attr(addr, numpages, SET_MEMORY_X);
+}
+
+#endif
diff --git a/arch/powerpc/mm/Makefile b/arch/powerpc/mm/Makefile
index 5e147986400d..a998fdac52f9 100644
--- a/arch/powerpc/mm/Makefile
+++ b/arch/powerpc/mm/Makefile
@@ -5,7 +5,7 @@
 
 ccflags-$(CONFIG_PPC64)	:= $(NO_MINIMAL_TOC)
 
-obj-y				:= fault.o mem.o pgtable.o mmap.o \
+obj-y				:= fault.o mem.o pgtable.o mmap.o pageattr.o \
 				   init_$(BITS).o pgtable_$(BITS).o \
 				   pgtable-frag.o ioremap.o ioremap_$(BITS).o \
 				   init-common.o mmu_context.o drmem.o
diff --git a/arch/powerpc/mm/pageattr.c b/arch/powerpc/mm/pageattr.c
new file mode 100644
index 000000000000..2da3fbab6ff7
--- /dev/null
+++ b/arch/powerpc/mm/pageattr.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * MMU-generic set_memory implementation for powerpc
+ *
+ * Copyright 2019, IBM Corporation.
+ */
+
+#include <linux/mm.h>
+#include <linux/set_memory.h>
+
+#include <asm/mmu.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+
+
+/*
+ * Updates the attributes of a page in three steps:
+ *
+ * 1. invalidate the page table entry
+ * 2. flush the TLB
+ * 3. install the new entry with the updated attributes
+ *
+ * This is unsafe if the caller is attempting to change the mapping of the
+ * page it is executing from, or if another CPU is concurrently using the
+ * page being altered.
+ *
+ * TODO make the implementation resistant to this.
+ *
+ * NOTE: can be dangerous to call without STRICT_KERNEL_RWX
+ */
+static int change_page_attr(pte_t *ptep, unsigned long addr, void *data)
+{
+	long action = (long)data;
+	pte_t pte;
+
+	spin_lock(&init_mm.page_table_lock);
+
+	/* invalidate the PTE so it's safe to modify */
+	pte = ptep_get_and_clear(&init_mm, addr, ptep);
+	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
+
+	/* modify the PTE bits as desired, then apply */
+	switch (action) {
+	case SET_MEMORY_RO:
+		pte = pte_wrprotect(pte);
+		break;
+	case SET_MEMORY_RW:
+		pte = pte_mkwrite(pte);
+		break;
+	case SET_MEMORY_NX:
+		pte = pte_exprotect(pte);
+		break;
+	case SET_MEMORY_X:
+		pte = pte_mkexec(pte);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	set_pte_at(&init_mm, addr, ptep, pte);
+	spin_unlock(&init_mm.page_table_lock);
+
+	return 0;
+}
+
+int change_memory_attr(unsigned long addr, int numpages, long action)
+{
+	unsigned long start = ALIGN_DOWN(addr, PAGE_SIZE);
+	unsigned long sz = numpages * PAGE_SIZE;
+
+	if (!IS_ENABLED(CONFIG_STRICT_KERNEL_RWX))
+		return 0;
+
+	if (numpages <= 0)
+		return 0;
+
+	return apply_to_existing_page_range(&init_mm, start, sz,
+					    change_page_attr, (void *)action);
+}
-- 
2.26.0

