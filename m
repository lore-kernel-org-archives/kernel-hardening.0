Return-Path: <SRS0=ltHM=XP=lists.openwall.com=kernel-hardening-return-16898-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 916DBC49ED7
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Sep 2019 09:26:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E51112070C
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Sep 2019 09:26:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E51112070C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16898-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32128 invoked by uid 550); 20 Sep 2019 09:25:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31966 invoked from network); 20 Sep 2019 09:25:41 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<yebin10@huawei.com>, <thunder.leizhen@huawei.com>,
	<jingxiangfeng@huawei.com>, <zhaohongjiang@huawei.com>, <oss@buserror.net>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v7 04/12] powerpc/fsl_booke/32: introduce create_kaslr_tlb_entry() helper
Date: Fri, 20 Sep 2019 17:45:38 +0800
Message-ID: <20190920094546.44948-5-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190920094546.44948-1-yanaijie@huawei.com>
References: <20190920094546.44948-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected

Add a new helper create_kaslr_tlb_entry() to create a tlb entry by the
virtual and physical address. This is a preparation to support boot kernel
at a randomized address.

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
 arch/powerpc/kernel/head_fsl_booke.S | 35 ++++++++++++++++++++++++++++
 arch/powerpc/mm/mmu_decl.h           |  1 +
 2 files changed, 36 insertions(+)

diff --git a/arch/powerpc/kernel/head_fsl_booke.S b/arch/powerpc/kernel/head_fsl_booke.S
index adf0505dbe02..8c1928176ffe 100644
--- a/arch/powerpc/kernel/head_fsl_booke.S
+++ b/arch/powerpc/kernel/head_fsl_booke.S
@@ -1114,6 +1114,41 @@ __secondary_hold_acknowledge:
 	.long	-1
 #endif
 
+/*
+ * Create a 64M tlb by address and entry
+ * r3 - entry
+ * r4 - virtual address
+ * r5/r6 - physical address
+ */
+_GLOBAL(create_kaslr_tlb_entry)
+	lis     r7,0x1000               /* Set MAS0(TLBSEL) = 1 */
+	rlwimi  r7,r3,16,4,15           /* Setup MAS0 = TLBSEL | ESEL(r6) */
+	mtspr   SPRN_MAS0,r7            /* Write MAS0 */
+
+	lis     r3,(MAS1_VALID|MAS1_IPROT)@h
+	ori     r3,r3,(MAS1_TSIZE(BOOK3E_PAGESZ_64M))@l
+	mtspr   SPRN_MAS1,r3            /* Write MAS1 */
+
+	lis     r3,MAS2_EPN_MASK(BOOK3E_PAGESZ_64M)@h
+	ori     r3,r3,MAS2_EPN_MASK(BOOK3E_PAGESZ_64M)@l
+	and     r3,r3,r4
+	ori	r3,r3,MAS2_M_IF_NEEDED@l
+	mtspr   SPRN_MAS2,r3            /* Write MAS2(EPN) */
+
+#ifdef CONFIG_PHYS_64BIT
+	ori     r8,r6,(MAS3_SW|MAS3_SR|MAS3_SX)
+	mtspr   SPRN_MAS3,r8            /* Write MAS3(RPN) */
+	mtspr	SPRN_MAS7,r5
+#else
+	ori     r8,r5,(MAS3_SW|MAS3_SR|MAS3_SX)
+	mtspr   SPRN_MAS3,r8            /* Write MAS3(RPN) */
+#endif
+
+	tlbwe                           /* Write TLB */
+	isync
+	sync
+	blr
+
 /*
  * Create a tlb entry with the same effective and physical address as
  * the tlb entry used by the current running code. But set the TS to 1.
diff --git a/arch/powerpc/mm/mmu_decl.h b/arch/powerpc/mm/mmu_decl.h
index 32c1a191c28a..a492ece08f64 100644
--- a/arch/powerpc/mm/mmu_decl.h
+++ b/arch/powerpc/mm/mmu_decl.h
@@ -142,6 +142,7 @@ extern unsigned long calc_cam_sz(unsigned long ram, unsigned long virt,
 extern void adjust_total_lowmem(void);
 extern int switch_to_as1(void);
 extern void restore_to_as0(int esel, int offset, void *dt_ptr, int bootcpu);
+void create_kaslr_tlb_entry(int entry, unsigned long virt, phys_addr_t phys);
 #endif
 extern void loadcam_entry(unsigned int index);
 extern void loadcam_multi(int first_idx, int num, int tmp_idx);
-- 
2.17.2

