Return-Path: <SRS0=sAcH=HY=lists.openwall.com=kernel-hardening-return-20784-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98714C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:13:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B443664E77
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:13:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B443664E77
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20784-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22275 invoked by uid 550); 22 Feb 2021 15:12:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22176 invoked from network); 22 Feb 2021 15:12:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YByzcYLbOT1FbVq7W/iPz1yV9tO4yNodoZHiZ+8vsb4=;
        b=R5bTKuwSZfiTHw6sQBKH/77xOM7ENB9Wls1sA2mT5ciYD1/ZMOeou2Exj8X3p+MbPY
         cUoivQD3TUa4RigPCyw3YoC3o1vIfe8umtW75zeiIxpZfHKb/h6bxwZVexAZHXWmDLBm
         OEcua6ZvtH4jIMiyhrS56W0+nTqUXMm7bN5XC1qRoxtiJiKLYdQD7gTbCoNU3lS1l0E2
         gIRp+GBzjvJxR3vo1aYTFOBh4bfPnPbk7dx5MsQeOya+siDPjpnDs26vCPWnenTSPN/v
         yVHVAt/sq16RjIBcpQYcl9AiT1IKbIeB3AC7Y+i4njEdWtdOqL0QAaG43ySBwD+7AMlJ
         fI6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YByzcYLbOT1FbVq7W/iPz1yV9tO4yNodoZHiZ+8vsb4=;
        b=bKKoo/oE25Vs053n1onBTh51wxn5ypAMc+s3+6/UtCNh7iGBdpR0W76Gi42HbDhbCd
         6UmUomI1Y4TlTo9sYTSGfqz45pKopPt2AY2tOvUGAsBzHlRJ0KXMA/ELA2nW/t6henR+
         7Es8pzWHsI/gMsFOG7Ya5e2SMQrxFYKHLx/9c/yJAQT6CoijHSlmJ7bTZtSfI/y5F3/C
         DKY1ZsyKSGNE4QRM5orf+NILTfvutG1STGEnupgOv9L0UFfvrfaoQz7S5RDbY2rft8i0
         0NiEBpVmgZs/unVXKUnePyWRzkj1CFc86g5XgXfvZUoLHmjrJdUgaB0f/DLqTdzYkytB
         Vc8g==
X-Gm-Message-State: AOAM532PEhMUA6R2xdmXXehKweuXtRfGZ3xPx9LpWKTDrGpV4Vk/r7cx
	GuPppYnGG+0CzsIo10iEN3o=
X-Google-Smtp-Source: ABdhPJxU2vGpa+8wC1SXGOcCy8k2fmqGbntcVq+4bVDVPsoZbAKl5HHMxz/ILTdabK3Q5VQIwNIKDw==
X-Received: by 2002:a7b:c184:: with SMTP id y4mr13880282wmi.1.1614006766877;
        Mon, 22 Feb 2021 07:12:46 -0800 (PST)
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Romain Perier <romain.perier@gmail.com>,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 04/20] dma-buf: Manual replacement of the deprecated strlcpy() with return values
Date: Mon, 22 Feb 2021 16:12:15 +0100
Message-Id: <20210222151231.22572-5-romain.perier@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210222151231.22572-1-romain.perier@gmail.com>
References: <20210222151231.22572-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The strlcpy() reads the entire source buffer first, it is dangerous if
the source buffer lenght is unbounded or possibility non NULL-terminated.
It can lead to linear read overflows, crashes, etc...

As recommended in the deprecated interfaces [1], it should be replaced
by strscpy.

This commit replaces all calls to strlcpy that handle the return values
by the corresponding strscpy calls with new handling of the return
values (as it is quite different between the two functions).

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 drivers/dma-buf/dma-buf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index f264b70c383e..515192f2f404 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -42,12 +42,12 @@ static char *dmabuffs_dname(struct dentry *dentry, char *buffer, int buflen)
 {
 	struct dma_buf *dmabuf;
 	char name[DMA_BUF_NAME_LEN];
-	size_t ret = 0;
+	ssize_t ret = 0;
 
 	dmabuf = dentry->d_fsdata;
 	spin_lock(&dmabuf->name_lock);
 	if (dmabuf->name)
-		ret = strlcpy(name, dmabuf->name, DMA_BUF_NAME_LEN);
+		ret = strscpy(name, dmabuf->name, DMA_BUF_NAME_LEN);
 	spin_unlock(&dmabuf->name_lock);
 
 	return dynamic_dname(dentry, buffer, buflen, "/%s:%s",

