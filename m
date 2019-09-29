Return-Path: <SRS0=1U0/=XY=lists.openwall.com=kernel-hardening-return-16956-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9779C4360C
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:32:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2B7FC217F5
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:32:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Grr2mlM3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B7FC217F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16956-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22403 invoked by uid 550); 29 Sep 2019 16:31:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22339 invoked from network); 29 Sep 2019 16:31:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UVm9m8o/BUbQQckQ6ZDfcyrj76YFpHxpIpCpuA79XaQ=;
        b=Grr2mlM3uMfCZglgqBSkOVDFwNIoMJalxvFzaXTQNExZYHtQ7A/Urb1PF30jauXBDy
         OxjbO4P7+Lv7435Rmhuji9/f0AdO8K5rQzP1nEMvnVimGa2vc9thyeQGIu8+wHEuJHJH
         MX64UcLIY2y/otRmA3OEMEn1OPV5L6y6kN4qoEmyROBPz0PY7xj7MKFr6YoMtJkfCQ9Z
         Uo1aPGwKgN0hVoDtnDh/lHv3ezHAYUVKOPaEv0ZJbfxjfIIXFfNofhdCDu4drqWga8dz
         MpHHOb8kBxZ+ngqUfKsjY/V25nY1M/rSKlB0Lc/YxGJ88LJJz0cOesGPdAMK3Z/XTKGq
         c9Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UVm9m8o/BUbQQckQ6ZDfcyrj76YFpHxpIpCpuA79XaQ=;
        b=ru4Y0oqiwse4493KV2IOqHA3rL4IccovDvcVuPgJE78cykPXqx7c3h2sohthezZ1PB
         tr4SycsrqUVv91jBI+L/pHZs5uA9wPWqq0EAbRguxY18Qk2c0CDkbmKi842ONU4yn3Fe
         jK3TL6MqC7LHE/Lve+lHVMimCFLLVbET/uiUdeUABn8FFkkiI8I682Mb9MdPOvn4/8MJ
         blGDWM0UrfgWOZXvW2rvsoW7+3kMHsW7Wf1X/FqLKC5XwQrIre5rxsaKTzwczAxWmi4m
         93jazFx1sFw64WI0UvTdVa5pBYi00S7mWlwjuiJvfG2WJGOMZEgZnG20uiFSoF9t1B4s
         HYxw==
X-Gm-Message-State: APjAAAV0i7cHkhcUYmVUNUgcXdWyvlGP2UMLoI0/GTor2oklBY0PmbQg
	Txmk4gPHhAp+6rCnnVVzbxi8Slgo
X-Google-Smtp-Source: APXvYqzozlNvUpiwue4yhF1y8tJviWNAbhgt3khcbY1LX3O4+9GF8TM4cGZGW21Ct6wFXnPjpP4qzw==
X-Received: by 2002:a7b:c10c:: with SMTP id w12mr15050876wmi.26.1569774649903;
        Sun, 29 Sep 2019 09:30:49 -0700 (PDT)
From: Romain Perier <romain.perier@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	Romain Perier <romain.perier@gmail.com>,
	Romain Perier <romain.perier@viveris.fr>
Subject: [PRE-REVIEW PATCH 06/16] net: mvpp2: Prepare to use the new tasklet API
Date: Sun, 29 Sep 2019 18:30:18 +0200
Message-Id: <20190929163028.9665-7-romain.perier@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929163028.9665-1-romain.perier@gmail.com>
References: <20190929163028.9665-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Romain Perier <romain.perier@viveris.fr>

The future tasklet API will no longer allow to pass an arbitrary
"unsigned long" data parameter. The tasklet data structure will need to
be embedded into a data structure that will be retrieved from the tasklet
handler. Currently, there are no ways to retrieve the "struct mvpp2_port
*" from a given "struct mvpp2_port_pcpu *". This commit adds a new field
to get the address of the main port for each pcpu context.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 543a310ec102..ca61eb601f15 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -835,6 +835,7 @@ struct mvpp2_port_pcpu {
 	struct hrtimer tx_done_timer;
 	struct net_device *dev;
 	bool timer_scheduled;
+	struct mvpp2_port *port;
 };
 
 struct mvpp2_queue_vector {
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 111b3b8239e1..6cdd68866263 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5353,6 +5353,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 		err = -ENOMEM;
 		goto err_free_txq_pcpu;
 	}
+	port->pcpu->port = port;
 
 	if (!port->has_tx_irqs) {
 		for (thread = 0; thread < priv->nthreads; thread++) {
-- 
2.23.0

