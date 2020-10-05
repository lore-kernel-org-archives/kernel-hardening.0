Return-Path: <SRS0=ybgl=DM=lists.openwall.com=kernel-hardening-return-20097-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4648C4363A
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Oct 2020 22:54:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CDE072074F
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Oct 2020 22:54:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="l35Vrlxx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDE072074F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20097-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17599 invoked by uid 550); 5 Oct 2020 22:54:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17566 invoked from network); 5 Oct 2020 22:54:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6kYPidesDrPpkfu9bAf1thvUGBXxbaosRDcQ6Yl6UD0=;
        b=l35VrlxxzRCHmT4nTjBivNAlxfq+ceEXUSvn3LeWA5SW8/81k+drOlPsRVNFX68OAo
         GbzAUoFKyiK/syvBdnWKLMyvQR8kC/0FNFTmej99FkfHnkBak8OXYZ1HMPN4fJJJ24Uf
         6BJmM0rDYONfxUTPFoybWNyMjiXjhPQ7KHe2g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6kYPidesDrPpkfu9bAf1thvUGBXxbaosRDcQ6Yl6UD0=;
        b=EEnkgf7E1nIiT3gTAX7frsy6X7Xm0pka4lZLXe/i1iinJQ3qhYr6PtFb6jXYnVcuXI
         NFzmEiTPV7C+YymOkV+82m5uE47UZKgGpcX+9rfJGWG3wsecqrOI58EhBUZJnLQ92Yk/
         Bj0TrLZV6Uu4A+n5HjWdlH0WZbSANjcrzPdum2kZLKXvUiBYnnTQTTG+OTfFCRxHADN6
         mV3xthIm4/1jsbgpZ8e+5s7G1nPVKZOFnhxe8knYnMfnDz9GtElM1fzasN/7oTWyOjSE
         Tvt67Ubb88gIF4HLlmKiBQmvM9ALI4EFpT03H2zHVjjKNU3/Kdna/It3gj38f+HV8cH2
         QeOA==
X-Gm-Message-State: AOAM5303QZO8ahKy0sK0uH2nN0DKtpzfU4q08yD6esV5MimwK3kId/nY
	idO0/wI1MQeOnBJOsow9K7fKaxyqsO6zdp7P
X-Google-Smtp-Source: ABdhPJzVoAKWMvinAua02fba0iow8ESJoWh/Us36b096hU0GKxEVwCAuIfYhSncgj0pJuEGPMW/GBA==
X-Received: by 2002:a17:902:7687:b029:d2:8d1f:1079 with SMTP id m7-20020a1709027687b02900d28d1f1079mr644542pll.2.1601938446076;
        Mon, 05 Oct 2020 15:54:06 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
	Emese Revfy <re.emese@gmail.com>,
	"Tobin C. Harding" <me@tobin.cc>,
	Tycho Andersen <tycho@tycho.pizza>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH] MAINTAINERS: Change hardening mailing list
Date: Mon,  5 Oct 2020 15:53:20 -0700
Message-Id: <20201005225319.2699826-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

As more email from git history gets aimed at the OpenWall
kernel-hardening@ list, there has been a desire to separate "new topics"
from "on-going" work. To handle this, the superset of hardening email
topics are now to be directed to linux-hardening@vger.kernel.org. Update
the MAINTAINTERS file and the .mailmap to accomplish this, so that
linux-hardening@ can be treated like any other regular upstream kernel
development list.

Link: https://lore.kernel.org/linux-hardening/202010051443.279CC265D@keescook/
Link: https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Get_Involved
Signed-off-by: Kees Cook <keescook@chromium.org>
---
I intend to include this in one of my trees, unless akpm or jon want it?
---
 .mailmap    | 1 +
 MAINTAINERS | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/.mailmap b/.mailmap
index 50096b96c85d..91cea2d9a6a3 100644
--- a/.mailmap
+++ b/.mailmap
@@ -184,6 +184,7 @@ Leon Romanovsky <leon@kernel.org> <leonro@nvidia.com>
 Linas Vepstas <linas@austin.ibm.com>
 Linus Lüssing <linus.luessing@c0d3.blue> <linus.luessing@ascom.ch>
 Linus Lüssing <linus.luessing@c0d3.blue> <linus.luessing@web.de>
+<linux-hardening@vger.kernel.org> <kernel-hardening@lists.openwall.com>
 Li Yang <leoyang.li@nxp.com> <leoli@freescale.com>
 Li Yang <leoyang.li@nxp.com> <leo@zh-kernel.org>
 Lukasz Luba <lukasz.luba@arm.com> <l.luba@partner.samsung.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index adc4f0619b19..44d97693b6f3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7216,7 +7216,7 @@ F:	drivers/staging/gasket/
 GCC PLUGINS
 M:	Kees Cook <keescook@chromium.org>
 R:	Emese Revfy <re.emese@gmail.com>
-L:	kernel-hardening@lists.openwall.com
+L:	linux-hardening@lists.openwall.com
 S:	Maintained
 F:	Documentation/kbuild/gcc-plugins.rst
 F:	scripts/Makefile.gcc-plugins
@@ -9776,7 +9776,7 @@ F:	drivers/scsi/53c700*
 LEAKING_ADDRESSES
 M:	Tobin C. Harding <me@tobin.cc>
 M:	Tycho Andersen <tycho@tycho.pizza>
-L:	kernel-hardening@lists.openwall.com
+L:	linux-hardening@lists.openwall.com
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tobin/leaks.git
 F:	scripts/leaking_addresses.pl
-- 
2.25.1

