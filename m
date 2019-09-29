Return-Path: <SRS0=8bU4=XY=lists.openwall.com=kernel-hardening-return-16953-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A807C4360C
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:31:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 73124217F5
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:31:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NzYq+lt8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 73124217F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16953-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21882 invoked by uid 550); 29 Sep 2019 16:30:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21799 invoked from network); 29 Sep 2019 16:30:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fjVch9LRt2ejbJ91rcWtAg0Nw/eSiIJNJLlwVd04KNA=;
        b=NzYq+lt85LayRmCrcgVTesFYaHFQnL1zp4Mk1u+mGdAWnn0eWLABobuCliO8wafBfV
         ZG7f3doYAOJtQExdxS6af0/iZp6wwRhPIEsHxo8eogAx2OKnV2wH1fpKSWluuwMU6Kp4
         F9KvJKzZO+LD/5sqlfmZ8v6+cS53FiytWyQpAZPyQPv8ivvHRjaU5UHHC/TdgwvBCUJ7
         T7R3fIO3AS0GOJsSRSD5kN7PN4nnsm8urmiNOGnA1e7pU9l0Iqj+NlXBIhHh1vqyc0/P
         NaYVHShiPAJQ8UtHNuCkslfS/KWVL6gLt9JrmHK2mcicpZyYzXhZ970jHW+xRQ6YfrnW
         eRcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fjVch9LRt2ejbJ91rcWtAg0Nw/eSiIJNJLlwVd04KNA=;
        b=ADQEyzagk/gQFgwhDYqx1q12LpnlJjoe+WGMmuneIwcOZ/5qsM+ML//by7Pp6abm4d
         s6J15AWu683Sq18+BbSFTs8iXzFowRYoV+4TstRtE5N8NXsEjEV7Xh2Xn69egX1T4uvJ
         TMOFsbBewMN6wN55qhwUlhHZk0f5e/lY1thdC/P/20oFIyaYRF+CvwFXDiYF0ooyj74k
         6lOtk8n+8T5Zxsf+s7ytta0zNs9ACzepnb+KtSjPGe+o/vAa/mQ3J6zkfuxRY+NYyDgQ
         AIVKXD9IXL3rfCHh7zh0FfBbthGRtCqm+xUicXgVVEILMzMx4125CfkYCCTd8kV7yuDb
         AiBw==
X-Gm-Message-State: APjAAAXDOcjALU+pwaFr398Rppu/JJrDswV6qKQ/k83+36yE/B+buQjo
	d7jvC7PAMGsrjfZqBCm7iA8=
X-Google-Smtp-Source: APXvYqz//bKP+ahAdZw2i6WI9XnI6lgdyqABk1QAmrnYQWaT9Zt6fHI670r4aAxC6k69/jjFDiIJbw==
X-Received: by 2002:a1c:1d85:: with SMTP id d127mr14955906wmd.14.1569774643923;
        Sun, 29 Sep 2019 09:30:43 -0700 (PDT)
From: Romain Perier <romain.perier@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	Romain Perier <romain.perier@gmail.com>,
	Romain Perier <romain.perier@viveris.fr>
Subject: [PRE-REVIEW PATCH 03/16] mmc: renesas_sdhi: Prepare to use the new tasklet API
Date: Sun, 29 Sep 2019 18:30:15 +0200
Message-Id: <20190929163028.9665-4-romain.perier@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929163028.9665-1-romain.perier@gmail.com>
References: <20190929163028.9665-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Romain Perier <romain.perier@viveris.fr>

The future tasklet API will no longer allow to pass an arbitrary
"unsigned long" data parameter. The tasklet data structure will need to
be embedded into a data structure that will be retrieved from the tasklet
handler. Then, all other data structure that must be retrieved from the
handler (by using the tasklet as root object) must be retrievable via
container_of(). This commits adds a field to get the address of the
device binded to this driver, so the corresponding platform_device and
its drvdata can be retrieved from the tasklet handler.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 drivers/mmc/host/renesas_sdhi.h      | 1 +
 drivers/mmc/host/renesas_sdhi_core.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/mmc/host/renesas_sdhi.h b/drivers/mmc/host/renesas_sdhi.h
index c0504aa90857..01ef8ff5b525 100644
--- a/drivers/mmc/host/renesas_sdhi.h
+++ b/drivers/mmc/host/renesas_sdhi.h
@@ -42,6 +42,7 @@ struct tmio_mmc_dma {
 };
 
 struct renesas_sdhi {
+	struct platform_device *pdev;
 	struct clk *clk;
 	struct clk *clk_cd;
 	struct tmio_mmc_data mmc_data;
diff --git a/drivers/mmc/host/renesas_sdhi_core.c b/drivers/mmc/host/renesas_sdhi_core.c
index d4ada5cca2d1..ceb3b0af1470 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -843,6 +843,8 @@ int renesas_sdhi_probe(struct platform_device *pdev,
 		goto eirq;
 	}
 
+	priv->pdev = pdev;
+
 	dev_info(&pdev->dev, "%s base at 0x%08lx max clock rate %u MHz\n",
 		 mmc_hostname(host->mmc), (unsigned long)
 		 (platform_get_resource(pdev, IORESOURCE_MEM, 0)->start),
-- 
2.23.0

