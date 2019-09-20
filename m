Return-Path: <SRS0=jTJb=XP=lists.openwall.com=kernel-hardening-return-16903-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8465C49ED7
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Sep 2019 09:27:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 47AAE2070C
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Sep 2019 09:27:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47AAE2070C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16903-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32395 invoked by uid 550); 20 Sep 2019 09:25:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32173 invoked from network); 20 Sep 2019 09:25:46 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<yebin10@huawei.com>, <thunder.leizhen@huawei.com>,
	<jingxiangfeng@huawei.com>, <zhaohongjiang@huawei.com>, <oss@buserror.net>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v7 08/12] powerpc/fsl_booke/kaslr: clear the original kernel if randomized
Date: Fri, 20 Sep 2019 17:45:42 +0800
Message-ID: <20190920094546.44948-9-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190920094546.44948-1-yanaijie@huawei.com>
References: <20190920094546.44948-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected

The original kernel still exists in the memory, clear it now.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Cc: Diana Craciun <diana.craciun@nxp.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
Reviewed-by: Diana Craciun <diana.craciun@nxp.com>
Tested-by: Diana Craciun <diana.craciun@nxp.com>
---
 arch/powerpc/mm/mmu_decl.h           |  2 ++
 arch/powerpc/mm/nohash/fsl_booke.c   |  1 +
 arch/powerpc/mm/nohash/kaslr_booke.c | 11 +++++++++++
 3 files changed, 14 insertions(+)

diff --git a/arch/powerpc/mm/mmu_decl.h b/arch/powerpc/mm/mmu_decl.h
index a3a4937c0496..565731475a07 100644
--- a/arch/powerpc/mm/mmu_decl.h
+++ b/arch/powerpc/mm/mmu_decl.h
@@ -151,8 +151,10 @@ extern void loadcam_multi(int first_idx, int num, int tmp_idx);
 
 #ifdef CONFIG_RANDOMIZE_BASE
 void kaslr_early_init(void *dt_ptr, phys_addr_t size);
+void kaslr_late_init(void);
 #else
 static inline void kaslr_early_init(void *dt_ptr, phys_addr_t size) {}
+static inline void kaslr_late_init(void) {}
 #endif
 
 struct tlbcam {
diff --git a/arch/powerpc/mm/nohash/fsl_booke.c b/arch/powerpc/mm/nohash/fsl_booke.c
index 2dc27cf88add..b4eb06ceb189 100644
--- a/arch/powerpc/mm/nohash/fsl_booke.c
+++ b/arch/powerpc/mm/nohash/fsl_booke.c
@@ -269,6 +269,7 @@ notrace void __init relocate_init(u64 dt_ptr, phys_addr_t start)
 	kernstart_addr = start;
 	if (is_second_reloc) {
 		virt_phys_offset = PAGE_OFFSET - memstart_addr;
+		kaslr_late_init();
 		return;
 	}
 
diff --git a/arch/powerpc/mm/nohash/kaslr_booke.c b/arch/powerpc/mm/nohash/kaslr_booke.c
index 7b238fc2c8a9..aa1b60c782e7 100644
--- a/arch/powerpc/mm/nohash/kaslr_booke.c
+++ b/arch/powerpc/mm/nohash/kaslr_booke.c
@@ -381,3 +381,14 @@ notrace void __init kaslr_early_init(void *dt_ptr, phys_addr_t size)
 
 	reloc_kernel_entry(dt_ptr, kernstart_virt_addr);
 }
+
+void __init kaslr_late_init(void)
+{
+	/* If randomized, clear the original kernel */
+	if (kernstart_virt_addr != KERNELBASE) {
+		unsigned long kernel_sz;
+
+		kernel_sz = (unsigned long)_end - kernstart_virt_addr;
+		memzero_explicit((void *)KERNELBASE, kernel_sz);
+	}
+}
-- 
2.17.2

