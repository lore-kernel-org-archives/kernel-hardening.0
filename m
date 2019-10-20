Return-Path: <SRS0=lIwC=YN=lists.openwall.com=kernel-hardening-return-17062-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A3FCA9EA0
	for <kernel-hardening@archiver.kernel.org>; Sun, 20 Oct 2019 05:04:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CB635222C2
	for <kernel-hardening@archiver.kernel.org>; Sun, 20 Oct 2019 05:04:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UwgOsRMT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB635222C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17062-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28031 invoked by uid 550); 20 Oct 2019 05:03:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27999 invoked from network); 20 Oct 2019 05:03:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ywjurEp+Cqg9Fe4cTYNr3xdPVL+AQ1tEWRef7MBO2GM=;
        b=UwgOsRMTJdf+LgBr0C20ejDPIAr9ydq6HPqifia3cf2sUDbcy29b0cQ7haAAoaxH9M
         o0gSiH8mSnEWttP3FaZxSqF3TEW+GF1zdaoQrV++F4z7IOT5nK2/s47etV0YlDbhxUL/
         XJWssf9Q4WAoPZ3+IUx6qZBCzKlboTmJkUG6CzzL0WsJLPUqV7FI8a1XAC+Gkle+djPG
         vgvRCyMFONAJrtZWIOehm5TLiYtvPU2zaLC1ArRBGH39CrsmQZougjogh+YiBTIceHBH
         x5zjL0GPGoU13XhRj/s0xyuzA8/6ttP69rpJHIzSAR6Pgaqq58fnEZtidpd8KEuQhMCl
         kIIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ywjurEp+Cqg9Fe4cTYNr3xdPVL+AQ1tEWRef7MBO2GM=;
        b=cEi/G4LGLdPad7U/it6oH57KPeml7+sLOdpmYydX1O3CI34egjGqkKHm6yld0a7kiN
         1jY3JsU9vfYAsJImwRr/S1PSNyhdh5vKTFhS3NeVJixGmoWWas25jKi6KxGpTXtyqSUJ
         3gAXeMSzXKdOesEu6vM9NIdj468utIy8ND3EOVq5lJuIvUui7cXlKFQWz5rDElGZxBZr
         BqYx6nCYhTwdRYYGOdcKAEZ8dTpLUtxnx3RhrqRzk2BLCr2mRdXb95kOutx4vXoBgZ7M
         Es1I31bILQoijRK9syQnNVdXMlhdYQyx1yNlospPVEGz+esnm6exr6XvEAYMmKdLv3Ah
         Xcmw==
X-Gm-Message-State: APjAAAXi7wkJyuHK13UKW6ABHW+MW8UaEJ5kW0cY3/8A3zEh7PSyi2le
	VGTvstqJa6XQpxhyvMpMltqs6RA/MGA=
X-Google-Smtp-Source: APXvYqzhq4Y6f40ITf9PsyqNcqlgvSoGUJy957fifRTQB2oiJKf62ter96xFc16NqqLRxmzBGJmp+A==
X-Received: by 2002:a62:2501:: with SMTP id l1mr15797770pfl.148.1571547824131;
        Sat, 19 Oct 2019 22:03:44 -0700 (PDT)
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
Subject: [PATCH V2] kernel: dma: contigous: Make CMA parameters __initdata/__initconst
Date: Sun, 20 Oct 2019 10:33:22 +0530
Message-Id: <20191020050322.2634-1-mayhs11saini@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These parameters are only referenced by __init routine calls during early
boot so they should be marked as __initdata and __initconst accordingly.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christopher Lameter <cl@linux.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
V1->V2:
	mark cma parameters as __initdata/__initconst
	instead of __ro_after_init. As these parameters
	are only used by __init calls and never used afterwards
	which contrast the __ro_after_init usage.
---
 kernel/dma/contiguous.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 69cfb4345388..10bfc8c44c54 100644
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
+static const phys_addr_t size_bytes __initconst = (phys_addr_t)CMA_SIZE_MBYTES * SZ_1M;
+static phys_addr_t  size_cmdline __initdata = -1;
+static phys_addr_t base_cmdline __initdata;
+static phys_addr_t limit_cmdline __initdata;
 
 static int __init early_cma(char *p)
 {
-- 
2.20.1

