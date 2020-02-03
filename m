Return-Path: <SRS0=C/69=3X=lists.openwall.com=kernel-hardening-return-17654-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82D23C35247
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Feb 2020 16:18:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D923520838
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Feb 2020 16:18:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b="eINJVtQO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D923520838
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=digitalocean.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17654-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9271 invoked by uid 550); 3 Feb 2020 16:18:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9237 invoked from network); 3 Feb 2020 16:18:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=ptdL8j4y4Nu0slWC9GMlqw2vupDc3jE8cCzq/d6QOxo=;
        b=eINJVtQOFasRcQUUhrRypp1cvIgGSB2uv66wDqp4LEqIw+IxE8nZFh8zR1m5xpcBNs
         asYRxtDshmiHoSfr1mRX75C2UKBJu2rdW11q9+Bv/5yr2fbQHpAax5CNnqgsso8HZU0v
         UyOp9uDe8Q5dKeQmicM7GjESp/71ZeaA3EeFA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ptdL8j4y4Nu0slWC9GMlqw2vupDc3jE8cCzq/d6QOxo=;
        b=G67TaWwOKPO9wEzuanGN6qsvQ1eCoY0gREnC6EP8dcOp13mjRVAe9xRSlhDfJlM3m5
         iKlw8NGYdApztnP4qNtlbiYKCX4RXiBBAkyJaGLhZx7Kb0paPC30SrJ9zxft8J4SS5D1
         9XEs3JUgVylDUFzpufc1KqYPvqFvAYuG+v8lEFSzVjG/jUmynMnPlGjNCd2xQVW36IHB
         /ODb/aLUXXUVC4CVtWSkZmEYsC6FuwAgGZfc8xLOvzPRJEUOARsYmM7fqlZpahhkZz4A
         CvSSYZAyn2FQvNRZ7PiyTGm4ww6dEW2twFBKcbX36kc0OILboGPBswV46E8uNUYz/Pvu
         EDpQ==
X-Gm-Message-State: APjAAAVKm5Vfl5Uw2qgIXwv31162el3bnThqHS1g4V2R2wCZkjW/3ASl
	L0++fUY0l7rvMdhz8xs2aHuh
X-Google-Smtp-Source: APXvYqxDPyKmX7Xb7xJg3h+x7fg95e7oQwGe6vGn9t+4Xg/mY5Q8WpzfOarZKicAK8elQfsAEGxyDw==
X-Received: by 2002:a05:620a:306:: with SMTP id s6mr22664268qkm.469.1580746719156;
        Mon, 03 Feb 2020 08:18:39 -0800 (PST)
From: Tianlin Li <tli@digitalocean.com>
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org,
	Alex Deucher <alexander.deucher@amd.com>,
	christian.koenig@amd.com,
	David1.Zhou@amd.com,
	David Airlie <airlied@linux.ie>,
	Daniel Vetter <daniel@ffwll.ch>,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	Tianlin Li <tli@digitalocean.com>
Subject: [PATCH v2] drm/radeon: have the callers of set_memory_*() check the return value
Date: Mon,  3 Feb 2020 10:18:27 -0600
Message-Id: <20200203161827.768-1-tli@digitalocean.com>
X-Mailer: git-send-email 2.17.1

Right now several architectures allow their set_memory_*() family of  
functions to fail, but callers may not be checking the return values.
If set_memory_*() returns with an error, call-site assumptions may be
infact wrong to assume that it would either succeed or not succeed at  
all. Ideally, the failure of set_memory_*() should be passed up the 
call stack, and callers should examine the failure and deal with it. 

Need to fix the callers and add the __must_check attribute. They also 
may not provide any level of atomicity, in the sense that the memory 
protections may be left incomplete on failure. This issue likely has a 
few steps on effects architectures:
1)Have all callers of set_memory_*() helpers check the return value.
2)Add __must_check to all set_memory_*() helpers so that new uses do  
not ignore the return value.
3)Add atomicity to the calls so that the memory protections aren't left 
in a partial state.

This series is part of step 1. Make drm/radeon check the return value of  
set_memory_*().

Signed-off-by: Tianlin Li <tli@digitalocean.com>
---
v2:
The hardware is too old to be tested on and the code cannot be simply
removed from the kernel, so this is the solution for the short term. 
- Just print an error when something goes wrong
- Remove patch 2.  
v1:
https://lore.kernel.org/lkml/20200107192555.20606-1-tli@digitalocean.com/
---
 drivers/gpu/drm/radeon/radeon_gart.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
index f178ba321715..a2cc864aa08d 100644
--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -80,8 +80,9 @@ int radeon_gart_table_ram_alloc(struct radeon_device *rdev)
 #ifdef CONFIG_X86
 	if (rdev->family == CHIP_RS400 || rdev->family == CHIP_RS480 ||
 	    rdev->family == CHIP_RS690 || rdev->family == CHIP_RS740) {
-		set_memory_uc((unsigned long)ptr,
-			      rdev->gart.table_size >> PAGE_SHIFT);
+		if (set_memory_uc((unsigned long)ptr,
+			      rdev->gart.table_size >> PAGE_SHIFT))
+			DRM_ERROR("set_memory_uc failed.\n");
 	}
 #endif
 	rdev->gart.ptr = ptr;
@@ -106,8 +107,9 @@ void radeon_gart_table_ram_free(struct radeon_device *rdev)
 #ifdef CONFIG_X86
 	if (rdev->family == CHIP_RS400 || rdev->family == CHIP_RS480 ||
 	    rdev->family == CHIP_RS690 || rdev->family == CHIP_RS740) {
-		set_memory_wb((unsigned long)rdev->gart.ptr,
-			      rdev->gart.table_size >> PAGE_SHIFT);
+		if (set_memory_wb((unsigned long)rdev->gart.ptr,
+			      rdev->gart.table_size >> PAGE_SHIFT))
+			DRM_ERROR("set_memory_wb failed.\n");
 	}
 #endif
 	pci_free_consistent(rdev->pdev, rdev->gart.table_size,
-- 
2.17.1

