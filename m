Return-Path: <SRS0=tK88=5P=lists.openwall.com=kernel-hardening-return-18288-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A317C43331
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 02:23:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 75DA42076A
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 02:23:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75DA42076A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18288-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21621 invoked by uid 550); 30 Mar 2020 02:22:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20383 invoked from network); 30 Mar 2020 02:22:45 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>,
	<oss@buserror.net>
CC: <linux-kernel@vger.kernel.org>, <zhaohongjiang@huawei.com>,
	<dja@axtens.net>, Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v5 5/6] powerpc/fsl_booke/64: clear the original kernel if randomized
Date: Mon, 30 Mar 2020 10:20:22 +0800
Message-ID: <20200330022023.3691-6-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200330022023.3691-1-yanaijie@huawei.com>
References: <20200330022023.3691-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected

The original kernel still exists in the memory, clear it now.

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
 arch/powerpc/mm/nohash/kaslr_booke.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/nohash/kaslr_booke.c b/arch/powerpc/mm/nohash/kaslr_booke.c
index 24ad34641869..6c46f24cc53d 100644
--- a/arch/powerpc/mm/nohash/kaslr_booke.c
+++ b/arch/powerpc/mm/nohash/kaslr_booke.c
@@ -382,8 +382,10 @@ notrace void __init kaslr_early_init(void *dt_ptr, phys_addr_t size)
 	unsigned long kernel_sz;
 
 	if (IS_ENABLED(CONFIG_PPC64)) {
-		if (__run_at_load == 1)
+		if (__run_at_load == 1) {
+			kaslr_late_init();
 			return;
+		}
 
 		/* Get the first memblock size */
 		early_get_first_memblock_info(dt_ptr, &size);
-- 
2.17.2

