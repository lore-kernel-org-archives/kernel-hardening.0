Return-Path: <SRS0=8/43=24=lists.openwall.com=kernel-hardening-return-17546-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C119C282DD
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jan 2020 19:26:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8FD3820656
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jan 2020 19:26:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b="RBjyUZwp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FD3820656
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=digitalocean.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17546-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9510 invoked by uid 550); 7 Jan 2020 19:26:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9404 invoked from network); 7 Jan 2020 19:26:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tQjRs3gNjU2oRCRkkGnPvWhg7epwoT3OSGkU89AkxDQ=;
        b=RBjyUZwp3oCaYSH4lBnXhf98sJuriMFFB8O7XKfK7ldWb6ngmv2f9qtFr6pCkkxgGw
         7CXrDYukjNwKP67z0Lw1byh8GcFRee92q4Li3sqQ/YUX/yWYSTzzPS0CWi7nplUTz0tb
         Jc7R/IvQnQExyScOkuyYIt2H8ViWXed3K25ks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tQjRs3gNjU2oRCRkkGnPvWhg7epwoT3OSGkU89AkxDQ=;
        b=ZLNH7CFZt9yInByc4xx+KHN2aT0YXF6OZJ6dnFicb9pkq1UZViM1XbevZ7MSHr3o4m
         WUa+eMZLhrE5wcxdOXVeBq9uirqjeb6sViV8ODewtUy6w6LPTkM0wntauUBPnUFGI+3A
         zJX1PqA6AMcI3QcpuTpHBUXvPrY9yqwpDieAfVkt5M/K3NDXi0x1UEUHxWm9eXdaCVe2
         XZGbt1q4EMQ+HrOQeZqfyYLYXwcW5DEfJQFGqhVa+Z1pa1Eh9nhcBPyeMZGIzmVwjV6d
         eQb81WDOXhO6L89Z3WduKapJDPHjL9XzskCHb32/V2HPT6uXcdtqeSCD0wso1PY5PLan
         iJdA==
X-Gm-Message-State: APjAAAWBXX+D+b8aQAiZ5L4AOxkA6mVAiDNSScZc/UJNNe9wLC0rZzPS
	bH68iDz2YESy8vHFOnSfqODO
X-Google-Smtp-Source: APXvYqxUxZ+QGpsSnWO2wfDZLiBGzqQSyJZLkZZl9iPaevdfkH2M+Sp/oQ3CIezE7wg13+qNsbCYpQ==
X-Received: by 2002:a81:9c14:: with SMTP id m20mr702845ywa.143.1578425164670;
        Tue, 07 Jan 2020 11:26:04 -0800 (PST)
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
Subject: [PATCH 1/2] drm/radeon: have the callers of set_memory_*() check the return value
Date: Tue,  7 Jan 2020 13:25:54 -0600
Message-Id: <20200107192555.20606-2-tli@digitalocean.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200107192555.20606-1-tli@digitalocean.com>
References: <20200107192555.20606-1-tli@digitalocean.com>

Have the callers of set_memory_*() in drm/radeon check the return value.
Change the return type of the callers properly. 

Signed-off-by: Tianlin Li <tli@digitalocean.com>
---
 drivers/gpu/drm/radeon/radeon.h      |  2 +-
 drivers/gpu/drm/radeon/radeon_gart.c | 22 ++++++++++++++++++----
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 30e32adc1fc6..a23e58397293 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -661,7 +661,7 @@ struct radeon_gart {
 };
 
 int radeon_gart_table_ram_alloc(struct radeon_device *rdev);
-void radeon_gart_table_ram_free(struct radeon_device *rdev);
+int radeon_gart_table_ram_free(struct radeon_device *rdev);
 int radeon_gart_table_vram_alloc(struct radeon_device *rdev);
 void radeon_gart_table_vram_free(struct radeon_device *rdev);
 int radeon_gart_table_vram_pin(struct radeon_device *rdev);
diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
index d4d3778d0a98..59039ab602e8 100644
--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -71,6 +71,7 @@
 int radeon_gart_table_ram_alloc(struct radeon_device *rdev)
 {
 	void *ptr;
+	int ret;
 
 	ptr = pci_alloc_consistent(rdev->pdev, rdev->gart.table_size,
 				   &rdev->gart.table_addr);
@@ -80,8 +81,16 @@ int radeon_gart_table_ram_alloc(struct radeon_device *rdev)
 #ifdef CONFIG_X86
 	if (rdev->family == CHIP_RS400 || rdev->family == CHIP_RS480 ||
 	    rdev->family == CHIP_RS690 || rdev->family == CHIP_RS740) {
-		set_memory_uc((unsigned long)ptr,
+		ret = set_memory_uc((unsigned long)ptr,
 			      rdev->gart.table_size >> PAGE_SHIFT);
+		if (ret) {
+			pci_free_consistent(rdev->pdev, rdev->gart.table_size,
+						(void *)rdev->gart.ptr,
+						rdev->gart.table_addr);
+			rdev->gart.ptr = NULL;
+			rdev->gart.table_addr = 0;
+			return ret;
+		}
 	}
 #endif
 	rdev->gart.ptr = ptr;
@@ -98,16 +107,20 @@ int radeon_gart_table_ram_alloc(struct radeon_device *rdev)
  * (r1xx-r3xx, non-pcie r4xx, rs400).  These asics require the
  * gart table to be in system memory.
  */
-void radeon_gart_table_ram_free(struct radeon_device *rdev)
+int radeon_gart_table_ram_free(struct radeon_device *rdev)
 {
+	int ret;
+
 	if (rdev->gart.ptr == NULL) {
-		return;
+		return 0;
 	}
 #ifdef CONFIG_X86
 	if (rdev->family == CHIP_RS400 || rdev->family == CHIP_RS480 ||
 	    rdev->family == CHIP_RS690 || rdev->family == CHIP_RS740) {
-		set_memory_wb((unsigned long)rdev->gart.ptr,
+		ret = set_memory_wb((unsigned long)rdev->gart.ptr,
 			      rdev->gart.table_size >> PAGE_SHIFT);
+		if (ret)
+			return ret;
 	}
 #endif
 	pci_free_consistent(rdev->pdev, rdev->gart.table_size,
@@ -115,6 +128,7 @@ void radeon_gart_table_ram_free(struct radeon_device *rdev)
 			    rdev->gart.table_addr);
 	rdev->gart.ptr = NULL;
 	rdev->gart.table_addr = 0;
+	return 0;
 }
 
 /**
-- 
2.17.1

