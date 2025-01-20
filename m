Return-Path: <kernel-hardening-return-21923-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id D6F88C02185
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2025 16:55:11 +0000 (UTC)
Received: (qmail 5349 invoked by uid 550); 20 Jan 2025 16:54:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5312 invoked from network); 20 Jan 2025 16:54:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ethancedwards.com;
	s=MBO0001; t=1737392089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LS+MZG6fzjs7nxyUtXWsT4ov/e2VyX4vAlGsW6xC8Ww=;
	b=WSeZkiEpiH98uSVuU0s7xTbcv6GZJ1hBAp13hQtd9Eyu4sBIR6KDVWRc+JmEgnaRWm+ejR
	NCx2P7o1SPCoNOJWanAX1jLfGA8PSR3sFj+sz9RmJzyZpbfYgor2b8mwFFIx5lC9unS/uV
	fWmbmsSXZxuCJsroyy581WoLsn9yh2Vj0hckVVGwvlwwlK4uUsysF5R64aT1ZQkU2g1pm3
	SwQN/TwSrQOaPOAtrTuinl3f+wqW6nVCR0iqFcVUPKAzsiud2lpLYY6ZQlaZMBs2DBD2xI
	AY44WqgPzgrdkbYEwFWlAdaymTUwsvGZget3Ui43DhJjUCV702pinRS/P/GnAA==
From: Ethan Carter Edwards <ethan@ethancedwards.com>
To: manoj@linux.ibm.com
Cc: linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Ethan Carter Edwards <ethan@ethancedwards.com>,
	Uma Krishnan <ukrishn@linux.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: cxlflash: change kzalloc to kcalloc
Date: Mon, 20 Jan 2025 11:53:55 -0500
Message-ID: <20250120165411.32256-1-ethan@ethancedwards.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We are replacing any instances of kzalloc(size * count, ...) with
kcalloc(count, size, ...) due to risk of overflow [1].

[1] https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments

Link: https://github.com/KSPP/linux/issues/162
Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
---
 drivers/scsi/cxlflash/superpipe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index b375509d1470..fc26e62e0dbf 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -785,8 +785,8 @@ static struct ctx_info *create_context(struct cxlflash_cfg *cfg)
 	struct sisl_rht_entry *rhte;
 
 	ctxi = kzalloc(sizeof(*ctxi), GFP_KERNEL);
-	lli = kzalloc((MAX_RHT_PER_CONTEXT * sizeof(*lli)), GFP_KERNEL);
-	ws = kzalloc((MAX_RHT_PER_CONTEXT * sizeof(*ws)), GFP_KERNEL);
+	lli = kcalloc(MAX_RHT_PER_CONTEXT, sizeof(*lli), GFP_KERNEL);
+	ws = kcalloc(MAX_RHT_PER_CONTEXT, sizeof(*ws), GFP_KERNEL);
 	if (unlikely(!ctxi || !lli || !ws)) {
 		dev_err(dev, "%s: Unable to allocate context\n", __func__);
 		goto err;
-- 
2.48.0

