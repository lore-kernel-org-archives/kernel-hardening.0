Return-Path: <SRS0=zElj=YH=lists.openwall.com=kernel-hardening-return-17013-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA70C4CECE
	for <kernel-hardening@archiver.kernel.org>; Mon, 14 Oct 2019 05:14:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 87E712083B
	for <kernel-hardening@archiver.kernel.org>; Mon, 14 Oct 2019 05:14:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="TmJFP6kp";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MAJ10Txl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 87E712083B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17013-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9293 invoked by uid 550); 14 Oct 2019 05:14:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8090 invoked from network); 14 Oct 2019 05:14:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm3; bh=2+HlUQKeP5NUw
	AG28BrzwAWEjn5cqHZMQi5EL+7gFgI=; b=TmJFP6kpW2a04aZ9AUAfbnClxYDWz
	SikmJbvzLHJjxVE8IOPFXcPlMtswSwmQALOcWwNp4OsqZBSrq6LsL3fi5bbee5EI
	Duyy68mPazV7X5dlr4g4EQJG4XeqMuvBnjjvKZ/63LIgnS2QM4kv6VfrcQOegzK/
	PmOgll+lNlIsYwjN6ErYp7VNJ2vYwzOKC0VPeXtvflFZtHYWMk+X0qD/q+qL8yoo
	09FaM4fu6H302my3Y3YGygdBChLKmWDX9GIiP5vwzE2c0P+EBHi84Qe08jc0JvZ/
	jkORoOOsTiLxD9X1LsIrGGGzUKM+iQFfmbh8PfYT2DUEr6qlMFk63JM6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; bh=2+HlUQKeP5NUwAG28BrzwAWEjn5cqHZMQi5EL+7gFgI=; b=MAJ10Txl
	1DvN2K78EYsrlriivzsIBoZmJbbaNwGQ2gNFUI2yMi6855EjXh4uoatFcyJKvSM/
	rXYTYse6FUbgDmh1ekIGI7X2cMTuLi1iDcbqUJ9fLO0mSmotufyNzB/Gp89KbA0j
	PxIMyG5L11wwR67OfbtOqbmZwhUpe+t3nL9PRj/Oip5jVCttY3SV/vnVPdKxWh9Y
	E4e8ODYOishLNLlgamL1LkRIF9zSSKh3EoApupoOaO+KU1yeJ97jeuVyXH4x6ew8
	GAesMv42Lbdmw7ZT9jz61bExBjZZvR7RD+1K4JL0kEm+4rKHnj7WNMOB4E81FTmo
	YDqXf5zYohWGLw==
X-ME-Sender: <xms:DQSkXV5_9gnBjXKA84HXc2i1EKUfJ7BUCNQB_a0LlkDLXFfLAyBcEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjedtgdelgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephffvuf
    ffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgv
    hicuoehruhhstghurhesrhhushhsvghllhdrtggtqeenucfkphepuddvvddrleelrdekvd
    druddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehruhhstghurhesrhhushhsvghllhdr
    tggtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:DQSkXeZBHUYZ9j-vBmU1y3pnAY3vK9I-i8CG2dhaLjepIv0DlcV56Q>
    <xmx:DQSkXS7dUt22hfCKeZCNiQjuhYq3RXpFqor4FT563FwF6_QQUeXzkA>
    <xmx:DQSkXZA9fa7Ndetv-uvpSJ2BUuV9PVef0-dSEqitB_reWbfQTVOfqw>
    <xmx:DQSkXedzoRfeftHXbBnFUTAgNnXrZZ36c0ZYBgYFP8ncwAiohiOMNA>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: Russell Currey <ruscur@russell.cc>,
	christophe.leroy@c-s.fr,
	joel@jms.id.au,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v4 1/4] powerpc/mm: Implement set_memory() routines
Date: Mon, 14 Oct 2019 16:13:17 +1100
Message-Id: <20191014051320.158682-2-ruscur@russell.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191014051320.158682-1-ruscur@russell.cc>
References: <20191014051320.158682-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The set_memory_{ro/rw/nx/x}() functions are required for STRICT_MODULE_RWX,
and are generally useful primitives to have.  This implementation is
designed to be completely generic across powerpc's many MMUs.

It's possible that this could be optimised to be faster for specific
MMUs, but the focus is on having a generic and safe implementation for
now.

Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 arch/powerpc/Kconfig                  |  1 +
 arch/powerpc/include/asm/set_memory.h | 32 ++++++++++++++
 arch/powerpc/mm/Makefile              |  1 +
 arch/powerpc/mm/pageattr.c            | 60 +++++++++++++++++++++++++++
 4 files changed, 94 insertions(+)
 create mode 100644 arch/powerpc/include/asm/set_memory.h
 create mode 100644 arch/powerpc/mm/pageattr.c

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 3e56c9c2f16e..8f7005f0d097 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -133,6 +133,7 @@ config PPC
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_MEMBARRIER_CALLBACKS
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC_BOOK3S_64
+	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !RELOCATABLE && !HIBERNATION)
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UACCESS_FLUSHCACHE
diff --git a/arch/powerpc/include/asm/set_memory.h b/arch/powerpc/include/asm/set_memory.h
new file mode 100644
index 000000000000..5230ddb2fefd
--- /dev/null
+++ b/arch/powerpc/include/asm/set_memory.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_POWERPC_SET_MEMORY_H
+#define _ASM_POWERPC_SET_MEMORY_H
+
+#define SET_MEMORY_RO	1
+#define SET_MEMORY_RW	2
+#define SET_MEMORY_NX	3
+#define SET_MEMORY_X	4
+
+int change_memory_attr(unsigned long addr, int numpages, int action);
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
index 5e147986400d..d0a0bcbc9289 100644
--- a/arch/powerpc/mm/Makefile
+++ b/arch/powerpc/mm/Makefile
@@ -20,3 +20,4 @@ obj-$(CONFIG_HIGHMEM)		+= highmem.o
 obj-$(CONFIG_PPC_COPRO_BASE)	+= copro_fault.o
 obj-$(CONFIG_PPC_PTDUMP)	+= ptdump/
 obj-$(CONFIG_KASAN)		+= kasan/
+obj-$(CONFIG_ARCH_HAS_SET_MEMORY) += pageattr.o
diff --git a/arch/powerpc/mm/pageattr.c b/arch/powerpc/mm/pageattr.c
new file mode 100644
index 000000000000..fe3ecbfb8e10
--- /dev/null
+++ b/arch/powerpc/mm/pageattr.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * MMU-generic set_memory implementation for powerpc
+ *
+ * Author: Russell Currey <ruscur@russell.cc>
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
+static int change_page_attr(pte_t *ptep, unsigned long addr, void *data)
+{
+	int action = *((int *)data);
+	pte_t pte_val;
+
+	// invalidate the PTE so it's safe to modify
+	pte_val = ptep_get_and_clear(&init_mm, addr, ptep);
+	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
+
+	// modify the PTE bits as desired, then apply
+	switch (action) {
+	case SET_MEMORY_RO:
+		pte_val = pte_wrprotect(pte_val);
+		break;
+	case SET_MEMORY_RW:
+		pte_val = pte_mkwrite(pte_val);
+		break;
+	case SET_MEMORY_NX:
+		pte_val = pte_exprotect(pte_val);
+		break;
+	case SET_MEMORY_X:
+		pte_val = pte_mkexec(pte_val);
+		break;
+	default:
+		WARN_ON(true);
+		return -EINVAL;
+	}
+
+	set_pte_at(&init_mm, addr, ptep, pte_val);
+
+	return 0;
+}
+
+int change_memory_attr(unsigned long addr, int numpages, int action)
+{
+	unsigned long start = ALIGN_DOWN(addr, PAGE_SIZE);
+	unsigned long size = numpages * PAGE_SIZE;
+
+	if (!numpages)
+		return 0;
+
+	return apply_to_page_range(&init_mm, start, size, change_page_attr, &action);
+}
-- 
2.23.0

