Return-Path: <SRS0=Tqfk=4X=lists.openwall.com=kernel-hardening-return-18096-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C08C3F2D5
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Mar 2020 06:42:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 296C72072D
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Mar 2020 06:42:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 296C72072D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18096-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23785 invoked by uid 550); 6 Mar 2020 06:42:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22478 invoked from network); 6 Mar 2020 06:42:08 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>,
	<oss@buserror.net>
CC: <linux-kernel@vger.kernel.org>, <zhaohongjiang@huawei.com>,
	<dja@axtens.net>, Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v4 2/6] powerpc/fsl_booke/64: introduce reloc_kernel_entry() helper
Date: Fri, 6 Mar 2020 14:40:29 +0800
Message-ID: <20200306064033.3398-3-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200306064033.3398-1-yanaijie@huawei.com>
References: <20200306064033.3398-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected

Like the 32bit code, we introduce reloc_kernel_entry() helper to prepare
for the KASLR 64bit version. And move the C declaration of this function
out of CONFIG_PPC32 and use long instead of int for the parameter 'addr'.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Cc: Scott Wood <oss@buserror.net>
Cc: Diana Craciun <diana.craciun@nxp.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 arch/powerpc/kernel/exceptions-64e.S | 13 +++++++++++++
 arch/powerpc/mm/mmu_decl.h           |  3 ++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
index e4076e3c072d..1b9b174bee86 100644
--- a/arch/powerpc/kernel/exceptions-64e.S
+++ b/arch/powerpc/kernel/exceptions-64e.S
@@ -1679,3 +1679,16 @@ _GLOBAL(setup_ehv_ivors)
 _GLOBAL(setup_lrat_ivor)
 	SET_IVOR(42, 0x340) /* LRAT Error */
 	blr
+
+/*
+ * Return to the start of the relocated kernel and run again
+ * r3 - virtual address of fdt
+ * r4 - entry of the kernel
+ */
+_GLOBAL(reloc_kernel_entry)
+	mfmsr	r7
+	rlwinm	r7, r7, 0, ~(MSR_IS | MSR_DS)
+
+	mtspr	SPRN_SRR0,r4
+	mtspr	SPRN_SRR1,r7
+	rfi
diff --git a/arch/powerpc/mm/mmu_decl.h b/arch/powerpc/mm/mmu_decl.h
index 7097e07a209a..605129b5ccdf 100644
--- a/arch/powerpc/mm/mmu_decl.h
+++ b/arch/powerpc/mm/mmu_decl.h
@@ -140,9 +140,10 @@ extern void adjust_total_lowmem(void);
 extern int switch_to_as1(void);
 extern void restore_to_as0(int esel, int offset, void *dt_ptr, int bootcpu);
 void create_kaslr_tlb_entry(int entry, unsigned long virt, phys_addr_t phys);
-void reloc_kernel_entry(void *fdt, int addr);
 extern int is_second_reloc;
 #endif
+
+void reloc_kernel_entry(void *fdt, long addr);
 extern void loadcam_entry(unsigned int index);
 extern void loadcam_multi(int first_idx, int num, int tmp_idx);
 
-- 
2.17.2

