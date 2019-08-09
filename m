Return-Path: <SRS0=Km7M=WF=lists.openwall.com=kernel-hardening-return-16764-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD932C433FF
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Aug 2019 09:52:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3361D2166E
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Aug 2019 09:52:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3361D2166E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16764-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13328 invoked by uid 550); 9 Aug 2019 09:52:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12060 invoked from network); 9 Aug 2019 09:52:12 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<yebin10@huawei.com>, <thunder.leizhen@huawei.com>,
	<jingxiangfeng@huawei.com>, <fanchengyang@huawei.com>,
	<zhaohongjiang@huawei.com>, Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v6 01/12] powerpc: unify definition of M_IF_NEEDED
Date: Fri, 9 Aug 2019 18:07:49 +0800
Message-ID: <20190809100800.5426-2-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190809100800.5426-1-yanaijie@huawei.com>
References: <20190809100800.5426-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected

M_IF_NEEDED is defined too many times. Move it to a common place and
rename it to MAS2_M_IF_NEEDED which is much readable.

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
 arch/powerpc/include/asm/nohash/mmu-book3e.h  | 10 ++++++++++
 arch/powerpc/kernel/exceptions-64e.S          | 12 +-----------
 arch/powerpc/kernel/fsl_booke_entry_mapping.S | 14 ++------------
 arch/powerpc/kernel/misc_64.S                 |  7 +------
 4 files changed, 14 insertions(+), 29 deletions(-)

diff --git a/arch/powerpc/include/asm/nohash/mmu-book3e.h b/arch/powerpc/include/asm/nohash/mmu-book3e.h
index 4c9777d256fb..fa3efc2d310f 100644
--- a/arch/powerpc/include/asm/nohash/mmu-book3e.h
+++ b/arch/powerpc/include/asm/nohash/mmu-book3e.h
@@ -221,6 +221,16 @@
 #define TLBILX_T_CLASS2			6
 #define TLBILX_T_CLASS3			7
 
+/*
+ * The mapping only needs to be cache-coherent on SMP, except on
+ * Freescale e500mc derivatives where it's also needed for coherent DMA.
+ */
+#if defined(CONFIG_SMP) || defined(CONFIG_PPC_E500MC)
+#define MAS2_M_IF_NEEDED	MAS2_M
+#else
+#define MAS2_M_IF_NEEDED	0
+#endif
+
 #ifndef __ASSEMBLY__
 #include <asm/bug.h>
 
diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
index 1cfb3da4a84a..c5bc09b5e281 100644
--- a/arch/powerpc/kernel/exceptions-64e.S
+++ b/arch/powerpc/kernel/exceptions-64e.S
@@ -1342,16 +1342,6 @@ skpinv:	addi	r6,r6,1				/* Increment */
 	sync
 	isync
 
-/*
- * The mapping only needs to be cache-coherent on SMP, except on
- * Freescale e500mc derivatives where it's also needed for coherent DMA.
- */
-#if defined(CONFIG_SMP) || defined(CONFIG_PPC_E500MC)
-#define M_IF_NEEDED	MAS2_M
-#else
-#define M_IF_NEEDED	0
-#endif
-
 /* 6. Setup KERNELBASE mapping in TLB[0]
  *
  * r3 = MAS0 w/TLBSEL & ESEL for the entry we started in
@@ -1364,7 +1354,7 @@ skpinv:	addi	r6,r6,1				/* Increment */
 	ori	r6,r6,(MAS1_TSIZE(BOOK3E_PAGESZ_1GB))@l
 	mtspr	SPRN_MAS1,r6
 
-	LOAD_REG_IMMEDIATE(r6, PAGE_OFFSET | M_IF_NEEDED)
+	LOAD_REG_IMMEDIATE(r6, PAGE_OFFSET | MAS2_M_IF_NEEDED)
 	mtspr	SPRN_MAS2,r6
 
 	rlwinm	r5,r5,0,0,25
diff --git a/arch/powerpc/kernel/fsl_booke_entry_mapping.S b/arch/powerpc/kernel/fsl_booke_entry_mapping.S
index ea065282b303..f4d3eaae54a9 100644
--- a/arch/powerpc/kernel/fsl_booke_entry_mapping.S
+++ b/arch/powerpc/kernel/fsl_booke_entry_mapping.S
@@ -153,16 +153,6 @@ skpinv:	addi	r6,r6,1				/* Increment */
 	tlbivax 0,r9
 	TLBSYNC
 
-/*
- * The mapping only needs to be cache-coherent on SMP, except on
- * Freescale e500mc derivatives where it's also needed for coherent DMA.
- */
-#if defined(CONFIG_SMP) || defined(CONFIG_PPC_E500MC)
-#define M_IF_NEEDED	MAS2_M
-#else
-#define M_IF_NEEDED	0
-#endif
-
 #if defined(ENTRY_MAPPING_BOOT_SETUP)
 
 /* 6. Setup KERNELBASE mapping in TLB1[0] */
@@ -171,8 +161,8 @@ skpinv:	addi	r6,r6,1				/* Increment */
 	lis	r6,(MAS1_VALID|MAS1_IPROT)@h
 	ori	r6,r6,(MAS1_TSIZE(BOOK3E_PAGESZ_64M))@l
 	mtspr	SPRN_MAS1,r6
-	lis	r6,MAS2_VAL(PAGE_OFFSET, BOOK3E_PAGESZ_64M, M_IF_NEEDED)@h
-	ori	r6,r6,MAS2_VAL(PAGE_OFFSET, BOOK3E_PAGESZ_64M, M_IF_NEEDED)@l
+	lis	r6,MAS2_VAL(PAGE_OFFSET, BOOK3E_PAGESZ_64M, MAS2_M_IF_NEEDED)@h
+	ori	r6,r6,MAS2_VAL(PAGE_OFFSET, BOOK3E_PAGESZ_64M, MAS2_M_IF_NEEDED)@l
 	mtspr	SPRN_MAS2,r6
 	mtspr	SPRN_MAS3,r8
 	tlbwe
diff --git a/arch/powerpc/kernel/misc_64.S b/arch/powerpc/kernel/misc_64.S
index b55a7b4cb543..2062a299a22d 100644
--- a/arch/powerpc/kernel/misc_64.S
+++ b/arch/powerpc/kernel/misc_64.S
@@ -432,18 +432,13 @@ kexec_create_tlb:
 	rlwimi	r9,r10,16,4,15		/* Setup MAS0 = TLBSEL | ESEL(r9) */
 
 /* Set up a temp identity mapping v:0 to p:0 and return to it. */
-#if defined(CONFIG_SMP) || defined(CONFIG_PPC_E500MC)
-#define M_IF_NEEDED	MAS2_M
-#else
-#define M_IF_NEEDED	0
-#endif
 	mtspr	SPRN_MAS0,r9
 
 	lis	r9,(MAS1_VALID|MAS1_IPROT)@h
 	ori	r9,r9,(MAS1_TSIZE(BOOK3E_PAGESZ_1GB))@l
 	mtspr	SPRN_MAS1,r9
 
-	LOAD_REG_IMMEDIATE(r9, 0x0 | M_IF_NEEDED)
+	LOAD_REG_IMMEDIATE(r9, 0x0 | MAS2_M_IF_NEEDED)
 	mtspr	SPRN_MAS2,r9
 
 	LOAD_REG_IMMEDIATE(r9, 0x0 | MAS3_SR | MAS3_SW | MAS3_SX)
-- 
2.17.2

