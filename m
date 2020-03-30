Return-Path: <SRS0=lhHc=5P=lists.openwall.com=kernel-hardening-return-18287-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D89CC43331
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 02:23:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C62B52076A
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 02:23:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C62B52076A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18287-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21521 invoked by uid 550); 30 Mar 2020 02:22:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20384 invoked from network); 30 Mar 2020 02:22:45 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>,
	<oss@buserror.net>
CC: <linux-kernel@vger.kernel.org>, <zhaohongjiang@huawei.com>,
	<dja@axtens.net>, Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v5 4/6] powerpc/fsl_booke/64: do not clear the BSS for the second pass
Date: Mon, 30 Mar 2020 10:20:21 +0800
Message-ID: <20200330022023.3691-5-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200330022023.3691-1-yanaijie@huawei.com>
References: <20200330022023.3691-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected

The BSS section has already cleared out in the first pass. No need to
clear it again. This can save some time when booting with KASLR
enabled.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Cc: Scott Wood <oss@buserror.net>
Cc: Diana Craciun <diana.craciun@nxp.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
---
 arch/powerpc/kernel/head_64.S | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index 454129a3c259..9354c292b709 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -913,6 +913,13 @@ start_here_multiplatform:
 	bl      relative_toc
 	tovirt(r2,r2)
 
+	/* Do not clear the BSS for the second pass if randomized */
+	LOAD_REG_ADDR(r3, kernstart_virt_addr)
+	ld	r3,0(r3)
+	LOAD_REG_IMMEDIATE(r4, KERNELBASE)
+	cmpd	r3,r4
+	bne	4f
+
 	/* Clear out the BSS. It may have been done in prom_init,
 	 * already but that's irrelevant since prom_init will soon
 	 * be detached from the kernel completely. Besides, we need
-- 
2.17.2

