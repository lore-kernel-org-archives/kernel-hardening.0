Return-Path: <SRS0=4pJ/=24=lists.openwall.com=kernel-hardening-return-17547-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE91C282DD
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jan 2020 19:26:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DF23020656
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jan 2020 19:26:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b="a3skjP/A"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF23020656
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=digitalocean.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17547-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9701 invoked by uid 550); 7 Jan 2020 19:26:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9589 invoked from network); 7 Jan 2020 19:26:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=maOi+ccdSCJ33tytaZ2VQyWTlm9roQsB2CYyKUcC3tE=;
        b=a3skjP/AmaWwBHZeZWluAghlXwxiT7Cj7kdIwSY35YoouSaTAle6gkkF+gWSQ43i5K
         B0GbiFcbbFVZraT3GERgOABL8Uc68kYFZIreZ/RiZRxaBPKz51UcdeY8c9TkW4rBxplO
         +ma4KhzsrQj/BcgUSva7gsUmK8tJO0k2NfeH0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=maOi+ccdSCJ33tytaZ2VQyWTlm9roQsB2CYyKUcC3tE=;
        b=GvQAqfIMoRjdHpc5t6xypsNU1LKjBgy/avzLEK7WrTZCt5k0kUYO3X+htIWOOKQ2Zj
         jsN4iQ3Wsd5yESOuaS7+VUoH6lB3P2XQ5DoI81o7zEe1tzpfHga6A7Hfbx3cHEgBigrP
         l2K7WF82/Q79YS3EpHYZeQkvHuaIXbyb1qtEYgr7Jj5mq5+H04QoBmvQ/aehQpDUUiOK
         r1gAunCrGLXwz7Q1dtSewhjhrxN4+CbknHAa+NjO5Q14+ogAPzFp4JwkG70lBBZLlEv4
         uOiSgEs8HEjqYz5lNNlp+4+B2E22l6CFzcdV8tiA1DGDPOSI2yDOHyB8vSgMSCniXRYx
         OEGQ==
X-Gm-Message-State: APjAAAV1zcw2d3S20CCZ3c5etG//9zoTpC463DltWwknPPK7qIvBqKAZ
	U/kEKRCS3fqeUlmhswbRumGe
X-Google-Smtp-Source: APXvYqwCwkS16hDGTInMHpIbsWfaGLyz0bdtQUZqjjL2wAm7ADS3K2eO1OR9tckNRyznHTSO/nu0Yg==
X-Received: by 2002:a81:ec01:: with SMTP id j1mr738569ywm.274.1578425166700;
        Tue, 07 Jan 2020 11:26:06 -0800 (PST)
From: Tianlin Li <tli@digitalocean.com>
To: kernel-hardening@lists.openwall.com,
	keescook@chromium.org
Cc: Alex Deucher <alexander.deucher@amd.com>,
	christian.koenig@amd.com,
	David1.Zhou@amd.com,
	David Airlie <airlied@linux.ie>,
	Daniel Vetter <daniel@ffwll.ch>,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	Tianlin Li <tli@digitalocean.com>
Subject: [PATCH 2/2] drm/radeon: change call sites to handle return value properly.
Date: Tue,  7 Jan 2020 13:25:55 -0600
Message-Id: <20200107192555.20606-3-tli@digitalocean.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200107192555.20606-1-tli@digitalocean.com>
References: <20200107192555.20606-1-tli@digitalocean.com>

Ideally, the failure of set_memory_*() should be passed up the call stack,
and callers should examine the failure and deal with it. Fix those call 
sites in drm/radeon to handle retval properly. 
Since fini functions are always void, print errors for the failures.

Signed-off-by: Tianlin Li <tli@digitalocean.com>
---
 drivers/gpu/drm/radeon/r100.c  | 3 ++-
 drivers/gpu/drm/radeon/rs400.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 110fb38004b1..7eafe15ba124 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -706,7 +706,8 @@ void r100_pci_gart_fini(struct radeon_device *rdev)
 {
 	radeon_gart_fini(rdev);
 	r100_pci_gart_disable(rdev);
-	radeon_gart_table_ram_free(rdev);
+	if (radeon_gart_table_ram_free(rdev))
+		DRM_ERROR("radeon: failed free system ram for GART page table.\n");
 }
 
 int r100_irq_set(struct radeon_device *rdev)
diff --git a/drivers/gpu/drm/radeon/rs400.c b/drivers/gpu/drm/radeon/rs400.c
index 117f60af1ee4..de3674f5fe23 100644
--- a/drivers/gpu/drm/radeon/rs400.c
+++ b/drivers/gpu/drm/radeon/rs400.c
@@ -210,7 +210,8 @@ void rs400_gart_fini(struct radeon_device *rdev)
 {
 	radeon_gart_fini(rdev);
 	rs400_gart_disable(rdev);
-	radeon_gart_table_ram_free(rdev);
+	if (radeon_gart_table_ram_free(rdev))
+		DRM_ERROR("radeon: failed free system ram for GART page table.\n");
 }
 
 #define RS400_PTE_UNSNOOPED (1 << 0)
-- 
2.17.1

