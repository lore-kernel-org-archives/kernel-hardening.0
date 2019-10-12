Return-Path: <SRS0=jOlo=YF=lists.openwall.com=kernel-hardening-return-17011-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A095C10F14
	for <kernel-hardening@archiver.kernel.org>; Sat, 12 Oct 2019 12:30:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B391121850
	for <kernel-hardening@archiver.kernel.org>; Sat, 12 Oct 2019 12:30:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZEe0bJ+1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B391121850
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17011-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3643 invoked by uid 550); 12 Oct 2019 12:30:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3609 invoked from network); 12 Oct 2019 12:30:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CUVTcUa5b8bKD7FsmBN2tFeSI1tiWWw4BFpLw9k7yCs=;
        b=ZEe0bJ+1FUWHAd7hQeuzlNX/YuaFs6XETmII7Fd2roFyVU7ZxUZYSJZhvRfCSh+oHF
         r8e8KobZ2Zq4aJTgsCnVidrK+K/dMHb5sBZjt10nA6Q9jNReWqzoN5bfqw4nUYd7fxQA
         Y1zLqclmF7IIT8xZCXLaBwjHUzcAUQXayGM1/rlc58V1KcjSqPQrLVs45eA2ylNa6LCp
         YbrrnOQxWJIi5GLbiiv2MhgkrevEbQMHw0FwbzryLbL/cYAqRlLMGBF0JQ5jDsS7cs38
         Swn1LU0gK6Uywm6QOej3PSgbkqGk8NUU9DofCGqnR4mvK/O31ju8G/C9VulR78+z3ElB
         IGjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CUVTcUa5b8bKD7FsmBN2tFeSI1tiWWw4BFpLw9k7yCs=;
        b=WW1dLmFxYb/cLz2l5l/YdizE7/P3rIXQN+sxZLQdXEawOb/kyy3uhVropNGTd11bjd
         29luoCaoAp3Fs74+o6HHXKx/41pFazUfZxR+ZZZ8bwNa2btQGScz646K5+lbQeCoYTSz
         ys/a+ymYnOw3LcKz/6ia5RXIX464Tsw1dMn5E1tvp7ehcr358WhqSfMjkyUfYdnotW5y
         KZGvEvfULCRttkO6rtW6wX8qIAt6IkHwntu3TExJlnhoTdPMEpHcJ6aoPmFNYGC7xu2J
         3QMYtxobOOY+q8NOlpzCjszBUxBueR2frhrg+U2/At7o2cpxRja3Qu0O2TO0I2ViuUI4
         csXQ==
X-Gm-Message-State: APjAAAXP2c2rVKXqFzsFji8AKP/hEBsRC0UQMjRqJfY1gx/zUb+SRysn
	hpGtRn5DcSBB1cl8lT27l3eU1pw+YfA=
X-Google-Smtp-Source: APXvYqyoYkM83GDHs5E3PNlXmZYrHsdzyiSKwuZ0dy6B4Pl7gdC+716gQxKin/hT8FITw6cUNd+2Dw==
X-Received: by 2002:a17:902:144:: with SMTP id 62mr20399568plb.100.1570883395203;
        Sat, 12 Oct 2019 05:29:55 -0700 (PDT)
From: Shyam Saini <mayhs11saini@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: iommu@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Shyam Saini <mayhs11saini@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Matthew Wilcox <willy@infradead.org>,
	Christopher Lameter <cl@linux.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH] kernel: dma: Make CMA boot parameters __ro_after_init
Date: Sat, 12 Oct 2019 17:59:18 +0530
Message-Id: <20191012122918.8066-1-mayhs11saini@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This parameters are not changed after early boot.
By making them __ro_after_init will reduce any attack surface in the
kernel.

Link: https://lwn.net/Articles/676145/
Cc: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christopher Lameter <cl@linux.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 kernel/dma/contiguous.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 69cfb4345388..1b689b1303cd 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -42,10 +42,10 @@ struct cma *dma_contiguous_default_area;
  * Users, who want to set the size of global CMA area for their system
  * should use cma= kernel parameter.
  */
-static const phys_addr_t size_bytes = (phys_addr_t)CMA_SIZE_MBYTES * SZ_1M;
-static phys_addr_t size_cmdline = -1;
-static phys_addr_t base_cmdline;
-static phys_addr_t limit_cmdline;
+static const phys_addr_t __ro_after_init size_bytes = (phys_addr_t)CMA_SIZE_MBYTES * SZ_1M;
+static phys_addr_t __ro_after_init size_cmdline = -1;
+static phys_addr_t __ro_after_init base_cmdline;
+static phys_addr_t __ro_after_init limit_cmdline;
 
 static int __init early_cma(char *p)
 {
-- 
2.20.1

