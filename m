Return-Path: <SRS0=Jk6E=4O=lists.openwall.com=kernel-hardening-return-17945-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3716CC4BA0A
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:36:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5A8D2206E2
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:36:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="lyAoNQ4q";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="1dpboUZh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A8D2206E2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17945-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13945 invoked by uid 550); 26 Feb 2020 06:36:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13773 invoked from network); 26 Feb 2020 06:36:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=QmRLxlds8fxsD
	uf/8I5NnhplT9+peUfJKPgYWcvn/PE=; b=lyAoNQ4qAGgizBlmFzwX5VFqOEUJy
	ss9guun1yOx+0mkNZRBbMeVAA92gTQBjm76uqDOpfCrFJYTCh0nPVSIS3oTdMOim
	1h7abuvw+jCslJoJLVfF+So+5sPzWqeB/D8bqSuHS9AGaBzJ/qSAn0/dwpQUQEW+
	K8ft4rHgA6l8efDY9Bi9Pc1gm6p+tYNxa9plk/OgDVBwzy9AbNe+jQh1aeYh7Wvp
	A0tuS0UlmrmkEV5J6qJhDVGuPIguQvBwaCZ/QWi4211O7suZ3Aq1nuQkCrf8D8gx
	CASAZOtfvUuYOTdGZ+Oe+ug/b/SWk6e00CE1N+Pex7JC28OajQ801VUCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=QmRLxlds8fxsDuf/8I5NnhplT9+peUfJKPgYWcvn/PE=; b=1dpboUZh
	sketE8niXX3gc4mjKFG79XJS35raLKVuzkiXA9wide2oypr2zn3Ygrefxi9fxik8
	hzXE90chho6mTTPyXSHDNm0QlVNxMSvIUPoIhg/0dc6lZ2uLzuPhmqV1qRO/Q6NU
	CQnKO1y/x2sEXCSujpRi9fy0+/v0lwIa+nblZNN/+4/ThgfJL0gurAAdKr9GZv2/
	aq10BALlgVQR0s0nRSisacLL0CD93hmnfh2v8QCkVKMtztZvyootqiJDw4aW4/PU
	05gam4YVWnRenq6Fmg5PLbbCegwib5CrLTCDCmaIaDS9QwCZb06DTe/AKZkVbrmO
	fj1yPicarkIzWA==
X-ME-Sender: <xms:3hFWXvUA2qQB25mK6aBhc3CPySJMyXsmTcMZfRFcJp1kbmKx6s0lKA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleefgdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdduhedmnecujfgurhephffvufffkffojghfggfgsedtkeertdertddt
    necuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgvhicuoehruhhstghurhesrhhushhsvg
    hllhdrtggtqeenucfkphepuddvvddrleelrdekvddruddtnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomheprhhushgtuhhrsehruhhsshgvlhhlrd
    gttg
X-ME-Proxy: <xmx:3hFWXubrqgnR8qQPVGBCRzTKZcObu0wEjpq516A3KStWhrRxr19j0w>
    <xmx:3hFWXkWrTHf90NVJ-9zQBehXVNr0BZuTN3TsYUQCtFEM-uanuiClAw>
    <xmx:3hFWXtK1In8U6TuW4CrwgIgR9KEAvjri9n-d7JjR96dNFy1tQgikxQ>
    <xmx:3hFWXvKPJeLb1ddao8gDt3w0upBXDE79CI757GGEt1lGqo_Ne_F8Uw>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: jniethe5@gmail.com,
	Christophe Leroy <christophe.leroy@c-s.fr>,
	joel@jms.id.au,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com,
	Russell Currey <ruscur@russell.cc>
Subject: [PATCH v5 1/8] powerpc/mm: Implement set_memory() routines
Date: Wed, 26 Feb 2020 17:35:44 +1100
Message-Id: <20200226063551.65363-2-ruscur@russell.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200226063551.65363-1-ruscur@russell.cc>
References: <20200226063551.65363-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christophe Leroy <christophe.leroy@c-s.fr>

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

Signed-off-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 arch/powerpc/Kconfig                  |  1 +
 arch/powerpc/include/asm/set_memory.h | 32 ++++++++++++
 arch/powerpc/mm/Makefile              |  2 +-
 arch/powerpc/mm/pageattr.c            | 74 +++++++++++++++++++++++++++
 4 files changed, 108 insertions(+), 1 deletion(-)
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
index 000000000000..2b573768a7f7
--- /dev/null
+++ b/arch/powerpc/mm/pageattr.c
@@ -0,0 +1,74 @@
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
+	if (!numpages)
+		return 0;
+
+	return apply_to_page_range(&init_mm, start, sz, change_page_attr, (void *)action);
+}
-- 
2.25.1

