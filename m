Return-Path: <SRS0=+Dnw=6N=lists.openwall.com=kernel-hardening-return-18671-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE094C83001
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Apr 2020 02:04:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 32AB120731
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Apr 2020 02:04:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32AB120731
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=informatik.wtf
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18671-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17819 invoked by uid 550); 29 Apr 2020 02:04:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17690 invoked from network); 29 Apr 2020 02:04:26 -0000
From: "Christopher M. Riedl" <cmr@informatik.wtf>
To: linuxppc-dev@lists.ozlabs.org,
	kernel-hardening@lists.openwall.com
Subject: [RFC PATCH v2 2/5] powerpc/lib: Initialize a temporary mm for code patching
Date: Tue, 28 Apr 2020 21:05:28 -0500
Message-Id: <20200429020531.20684-3-cmr@informatik.wtf>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200429020531.20684-1-cmr@informatik.wtf>
References: <20200429020531.20684-1-cmr@informatik.wtf>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP

When code patching a STRICT_KERNEL_RWX kernel the page containing the
address to be patched is temporarily mapped with permissive memory
protections. Currently, a per-cpu vmalloc patch area is used for this
purpose. While the patch area is per-cpu, the temporary page mapping is
inserted into the kernel page tables for the duration of the patching.
The mapping is exposed to CPUs other than the patching CPU - this is
undesirable from a hardening perspective.

Use the `poking_init` init hook to prepare a temporary mm and patching
address. Initialize the temporary mm by copying the init mm. Choose a
randomized patching address inside the temporary mm userspace address
portion. The next patch uses the temporary mm and patching address for
code patching.

Based on x86 implementation:

commit 4fc19708b165
("x86/alternatives: Initialize temporary mm for patching")

Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
---
 arch/powerpc/lib/code-patching.c | 33 ++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
index 3345f039a876..259c19480a85 100644
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -11,6 +11,8 @@
 #include <linux/cpuhotplug.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/sched/task.h>
+#include <linux/random.h>
 
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
@@ -39,6 +41,37 @@ int raw_patch_instruction(unsigned int *addr, unsigned int instr)
 }
 
 #ifdef CONFIG_STRICT_KERNEL_RWX
+
+static struct mm_struct *patching_mm __ro_after_init;
+static unsigned long patching_addr __ro_after_init;
+
+void __init poking_init(void)
+{
+	spinlock_t *ptl; /* for protecting pte table */
+	pte_t *ptep;
+
+	/*
+	 * Some parts of the kernel (static keys for example) depend on
+	 * successful code patching. Code patching under STRICT_KERNEL_RWX
+	 * requires this setup - otherwise we cannot patch at all. We use
+	 * BUG_ON() here and later since an early failure is preferred to
+	 * buggy behavior and/or strange crashes later.
+	 */
+	patching_mm = copy_init_mm();
+	BUG_ON(!patching_mm);
+
+	/*
+	 * In hash we cannot go above DEFAULT_MAP_WINDOW easily.
+	 * XXX: Do we want additional bits of entropy for radix?
+	 */
+	patching_addr = (get_random_long() & PAGE_MASK) %
+		(DEFAULT_MAP_WINDOW - PAGE_SIZE);
+
+	ptep = get_locked_pte(patching_mm, patching_addr, &ptl);
+	BUG_ON(!ptep);
+	pte_unmap_unlock(ptep, ptl);
+}
+
 static DEFINE_PER_CPU(struct vm_struct *, text_poke_area);
 
 static int text_area_cpu_up(unsigned int cpu)
-- 
2.26.1

