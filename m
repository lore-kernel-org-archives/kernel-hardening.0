Return-Path: <SRS0=Angt=6C=lists.openwall.com=kernel-hardening-return-18549-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC50AC2BA19
	for <kernel-hardening@archiver.kernel.org>; Sat, 18 Apr 2020 06:39:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 18CED214D8
	for <kernel-hardening@archiver.kernel.org>; Sat, 18 Apr 2020 06:39:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 18CED214D8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18549-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19863 invoked by uid 550); 18 Apr 2020 06:39:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19817 invoked from network); 18 Apr 2020 06:39:18 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <keescook@chromium.org>, <re.emese@gmail.com>,
	<kernel-hardening@lists.openwall.com>, <linux-kernel@vger.kernel.org>
CC: Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] gcc-plugins: latent_entropy: remove unneeded semicolon
Date: Sat, 18 Apr 2020 15:05:21 +0800
Message-ID: <20200418070521.10931-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected

Fix the following coccicheck warning:

scripts/gcc-plugins/latent_entropy_plugin.c:539:2-3: Unneeded semicolon

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 scripts/gcc-plugins/latent_entropy_plugin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gcc-plugins/latent_entropy_plugin.c b/scripts/gcc-plugins/latent_entropy_plugin.c
index cbe1d6c4b1a5..5c304061ad2a 100644
--- a/scripts/gcc-plugins/latent_entropy_plugin.c
+++ b/scripts/gcc-plugins/latent_entropy_plugin.c
@@ -536,7 +536,7 @@ static unsigned int latent_entropy_execute(void)
 	while (bb != EXIT_BLOCK_PTR_FOR_FN(cfun)) {
 		perturb_local_entropy(bb, local_entropy);
 		bb = bb->next_bb;
-	};
+	}
 
 	/* 4. mix local entropy into the global entropy variable */
 	perturb_latent_entropy(local_entropy);
-- 
2.21.1

