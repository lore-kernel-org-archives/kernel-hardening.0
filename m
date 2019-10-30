Return-Path: <SRS0=fp8z=YX=lists.openwall.com=kernel-hardening-return-17159-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE9ACA9EAF
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 07:32:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EAB5420874
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 07:32:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="T2jCpgQt";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="axxoW2mW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EAB5420874
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17159-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30458 invoked by uid 550); 30 Oct 2019 07:31:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30285 invoked from network); 30 Oct 2019 07:31:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm3; bh=aWW/U1viip+Ra
	EVEVqbP3tlb6Le1bU34dYIUMpujOsA=; b=T2jCpgQtcVhDZn+DY7h3r1LL4FVJx
	cYt/JY2xTSKhQM537Yghy6QacImI4zf9NFMQMhV0BHcfzm//Lt8Gk28K54/WNEyB
	3KkV8pjonj5SgpxmAPgMHdNff58PWXo2qNB1/g/IOUqI0PWynMKnsQk1TAc0Ak+C
	R/mj11+k7ioDfQLRjGqxhBLMo2ENst7jqn0/OmB5Yar4+cACgRNKPYhv1xA4FOFR
	TDRwc3EZ4r2bBWRr48vIIcQIgyI1w+O1mHOKQz9VsAXs6Eoigzy4lZqCR7ch/968
	dUKokgzR26Xqcdy2V7njvqw1UYhOmRnJ2fyFZocBpEbDpu2Ts7pcW9jTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; bh=aWW/U1viip+RaEVEVqbP3tlb6Le1bU34dYIUMpujOsA=; b=axxoW2mW
	3KF3I4v7sCt/BoDJfQypCMQ+7NpfP9l6AYCY/bxLsR3h3b9duVrosnOpnw/0a7aL
	88ImpHrkBFgvUwqVx5DB5k6nr3f5gkfoYARQOSECjxjdpou2/9fiGiGoGw76wp14
	pWvB2ua4mRw9yrmTtAl6L/BzmmHJqJyOHBemH0r2/6qQI4luQyWU+mesqTTiPiIk
	kEcAf6HUDfKrfssRsBxGCSCnjhzCWQTPz50kbkFDDSajEFJudxTlLeq3ChQJRg95
	yf6RGJxvObYdwH64v6faZ+xb/yVULCZfsBDXjo2TaEo9b7VEeDwdg+EqCDroEm8l
	327MutKjRaIEvA==
X-ME-Sender: <xms:WDy5XQCi3dG6ZDJaR_5v511uAIYPrfb6wi2iGVcqvbqDhs1Tj6A9rg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtvddguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephf
    fvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeftuhhsshgvlhhlucevuhhr
    rhgvhicuoehruhhstghurhesrhhushhsvghllhdrtggtqeenucfkphepuddvvddrleelrd
    ekvddruddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehruhhstghurhesrhhushhsvghl
    lhdrtggtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:WDy5XWzvDnTZkRHyTceMa5OKPB-GaeuSkz9zACGjDgLBfBCa3G0lSw>
    <xmx:WDy5XenlsfY7XDJI3fzxrDiesxpngELov2EMFSSar474UR18j9uf5g>
    <xmx:WDy5XbFDGe51DEzis_zh88JfAzQsgkxeJSQLkFdwvN3K-Jn9CiJzRQ>
    <xmx:WDy5XQL0bvso1E5xq-GyswMviqBuGiOw3hTBEsrLo_APiGxR3dTExA>
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
Subject: [PATCH v5 1/5] powerpc/mm: Implement set_memory() routines
Date: Wed, 30 Oct 2019 18:31:07 +1100
Message-Id: <20191030073111.140493-2-ruscur@russell.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191030073111.140493-1-ruscur@russell.cc>
References: <20191030073111.140493-1-ruscur@russell.cc>
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

Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 arch/powerpc/Kconfig                  |  1 +
 arch/powerpc/include/asm/set_memory.h | 32 +++++++++++
 arch/powerpc/mm/Makefile              |  1 +
 arch/powerpc/mm/pageattr.c            | 77 +++++++++++++++++++++++++++
 4 files changed, 111 insertions(+)
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
index 000000000000..aedd79173a44
--- /dev/null
+++ b/arch/powerpc/mm/pageattr.c
@@ -0,0 +1,77 @@
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
+	int action = *((int *)data);
+	pte_t pte_val;
+	int ret = 0;
+
+	spin_lock(&init_mm.page_table_lock);
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
+		ret = -EINVAL;
+		goto out;
+	}
+
+	set_pte_at(&init_mm, addr, ptep, pte_val);
+out:
+	spin_unlock(&init_mm.page_table_lock);
+	return ret;
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

