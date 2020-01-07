Return-Path: <SRS0=bzK1=24=lists.openwall.com=kernel-hardening-return-17545-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74275C282DD
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jan 2020 19:26:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C68BE20656
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jan 2020 19:26:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b="IOJjPyAy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C68BE20656
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=digitalocean.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17545-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 8016 invoked by uid 550); 7 Jan 2020 19:26:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7979 invoked from network); 7 Jan 2020 19:26:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=4DKB6Qc7EQjmBiBL2Egn9+nwj/mOHqlQ9foMEYlIG8s=;
        b=IOJjPyAyvnzuaeYvsM7svksubqWXA8Hoa7vK1bSt+tq7EJBo7VMbZS8S8OZSLwg1pG
         36w/czHJ96ImfadkDxCEjuu2XWNf62lAMDsXNsGFKHjawBMtvJOe2BF5ITEpiN1FAxl9
         5YiirNrNugcI13cQILvJLZwP+M6SsP86e47EU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4DKB6Qc7EQjmBiBL2Egn9+nwj/mOHqlQ9foMEYlIG8s=;
        b=j/UpbwhqwO3SkyQzX9j6qjpTVZRNaxsCMCbyeqt7idRRvnmCCsVNMzRrmJh4e1tkiG
         tRLaQYRGE9J2UbvRisvmoWpL+tCBCkzb8c9y5TFXavgM2iXdmT/lbfGI/RRBKkclyl9P
         SFlmohHj/mRhgY24BPDDCZ+21mqukPad/c1MuD9/0M475wAt31w1t8L0+kU8B+jiwUnk
         PFSYfnZzbZKyApd+jFF91SmaGIIKs1LT5xPpd3O+QG1KhHXYr8NK5QQlVxm230ukTXHH
         IjLCUwoAB9Rx3LW7zkyZuYPaP5BqzKUfqtYYW2yTYb7sdzazBXeaOCl37+jO4nlg3D/V
         UQpA==
X-Gm-Message-State: APjAAAVH1xAGLqVg5q4ttgg46HMM8YZQCiqTD3aI9tuAoDmjk1PFHtSJ
	MIo7H3+z8IDMHKhnUShWxdVc
X-Google-Smtp-Source: APXvYqy+9ob7vtrukxOuHGC9cxGwvi0VR2CE0/vcLH7EgE5nxS3/p087frpqoeKCnXIBDamwJYeLvQ==
X-Received: by 2002:a25:40c4:: with SMTP id n187mr909330yba.199.1578425160957;
        Tue, 07 Jan 2020 11:26:00 -0800 (PST)
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
Subject: [PATCH 0/2] drm/radeon: have the callers of set_memory_*() check the return value
Date: Tue,  7 Jan 2020 13:25:53 -0600
Message-Id: <20200107192555.20606-1-tli@digitalocean.com>
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

Tianlin Li (2):
  drm/radeon: have the callers of set_memory_*() check the return value
  drm/radeon: change call sites to handle return value properly.

 drivers/gpu/drm/radeon/r100.c        |  3 ++-
 drivers/gpu/drm/radeon/radeon.h      |  2 +-
 drivers/gpu/drm/radeon/radeon_gart.c | 22 ++++++++++++++++++----
 drivers/gpu/drm/radeon/rs400.c       |  3 ++-
 4 files changed, 23 insertions(+), 7 deletions(-)

-- 
2.17.1

