Return-Path: <SRS0=ddoy=VO=lists.openwall.com=kernel-hardening-return-16501-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE9AC76186
	for <kernel-hardening@archiver.kernel.org>; Wed, 17 Jul 2019 07:51:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 850C020818
	for <kernel-hardening@archiver.kernel.org>; Wed, 17 Jul 2019 07:51:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 850C020818
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16501-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1180 invoked by uid 550); 17 Jul 2019 07:49:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32558 invoked from network); 17 Jul 2019 07:49:36 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<yebin10@huawei.com>, <thunder.leizhen@huawei.com>,
	<jingxiangfeng@huawei.com>, <fanchengyang@huawei.com>, Jason Yan
	<yanaijie@huawei.com>
Subject: [RFC PATCH 09/10] powerpc/fsl_booke/kaslr: support nokaslr cmdline parameter
Date: Wed, 17 Jul 2019 16:06:20 +0800
Message-ID: <20190717080621.40424-10-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190717080621.40424-1-yanaijie@huawei.com>
References: <20190717080621.40424-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected

One may want to disable kaslr when boot, so provide a cmdline parameter
'nokaslr' to support this.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Cc: Diana Craciun <diana.craciun@nxp.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
---
 arch/powerpc/kernel/kaslr_booke.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/powerpc/kernel/kaslr_booke.c b/arch/powerpc/kernel/kaslr_booke.c
index 00339c05879f..e65a5d9d2ff1 100644
--- a/arch/powerpc/kernel/kaslr_booke.c
+++ b/arch/powerpc/kernel/kaslr_booke.c
@@ -373,6 +373,18 @@ static unsigned long __init kaslr_choose_location(void *dt_ptr, phys_addr_t size
 	return kaslr_offset;
 }
 
+static inline __init bool kaslr_disabled(void)
+{
+	char *str;
+
+	str = strstr(early_command_line, "nokaslr");
+	if ((str == early_command_line) ||
+	    (str > early_command_line && *(str - 1) == ' '))
+		return true;
+
+	return false;
+}
+
 /*
  * To see if we need to relocate the kernel to a random offset
  * void *dt_ptr - address of the device tree
@@ -388,6 +400,8 @@ notrace void __init kaslr_early_init(void *dt_ptr, phys_addr_t size)
 	kernel_sz = (unsigned long)_end - KERNELBASE;
 
 	kaslr_get_cmdline(dt_ptr);
+	if (kaslr_disabled())
+		return;
 
 	offset = kaslr_choose_location(dt_ptr, size, kernel_sz);
 
-- 
2.17.2

