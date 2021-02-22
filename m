Return-Path: <SRS0=A1NU=HY=lists.openwall.com=kernel-hardening-return-20799-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 127D3C433DB
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:19:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1AB9C6148E
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:19:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1AB9C6148E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20799-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24570 invoked by uid 550); 22 Feb 2021 15:13:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24466 invoked from network); 22 Feb 2021 15:13:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xsehZqvcvtb4tCCQoqeDviKqU/Y1YzBUUFjUVz3pAZk=;
        b=rncFZJGMNdZtNXBSacAVdgQBb0oGFNyf4Hdrl4WXvGfYPpXc/Yp5sNVXRPxebcNuHS
         7IwEN7oQqyGVvRqs7xITRH9BrQFVeMl9spTlXJbuc9zRHDrvQyCLU3I7tFJ1PyS/4HNJ
         fzRC7nyB+goax8BUDRiSpHvvPl5rliAh3rGz2sJefngJxqQ91KSDr12SCvrRitANW/hI
         0ZEPXb2d75NN21G4Mk1zMcEiEFxGfPE1x4YqmFFkLRQzfM4WHTL3WWIWjUQbfKTCBMaK
         sivFSnlzPOUjk7O8xk+5jDWF/7ksajmmcO15qtMvYQi3A8BDvi2F/SkrsWH3iGHIEm/5
         DhaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xsehZqvcvtb4tCCQoqeDviKqU/Y1YzBUUFjUVz3pAZk=;
        b=AqW5ybT7kUGvwkbBIhPQyDgjqD66zuIj2YdFNkkzosWEDCBYqMsJXzkGETbGUqtrK0
         gcDOOcCeEQD5V9ioeoprRHgXNdu6PfcU0QbJl0pP2mP7CBQz0pxIH4397cVV/XJVf3Lr
         eEwp17DwjL7TA8R+Bdtq1hTdd2ZiG9GlfIbeIxqL13Us3VHHtwZNia5leQXaOdcv/Clq
         MUriIVJ0MVazwA2TtctJFasHDTtoCQYmMfopug8rxlQ0pP59HSC3wSyVHuSsZL0+rAyc
         p1XT9blQOFR+mHLm0FahBja2HzlAVz08lC8Vfh2bhXbOYMyap7CRRbrx+Roa0pYP+E7J
         12eQ==
X-Gm-Message-State: AOAM531/SEqxDKdIEYWWkN2u/B0VaXupXI5BwkzYuut3UQRyoIRrfm18
	RiNCU3orvXrpCl+v9L9cKX0=
X-Google-Smtp-Source: ABdhPJxRYTjEd7nsbxeIKUmEpWw/94Nm1leoqbaxX1B5ddNqok4WzlYQVzm9GVfAfVRtD+2oslhAOw==
X-Received: by 2002:a5d:55d2:: with SMTP id i18mr5005134wrw.221.1614006784971;
        Mon, 22 Feb 2021 07:13:04 -0800 (PST)
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Valentina Manea <valentina.manea.m@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: Romain Perier <romain.perier@gmail.com>,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 19/20] usbip: usbip_host: Manual replacement of the deprecated strlcpy() with return values
Date: Mon, 22 Feb 2021 16:12:30 +0100
Message-Id: <20210222151231.22572-20-romain.perier@gmail.com>
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
 drivers/usb/usbip/stub_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/usbip/stub_main.c b/drivers/usb/usbip/stub_main.c
index 77a5b3f8736a..5bc2c09c0d10 100644
--- a/drivers/usb/usbip/stub_main.c
+++ b/drivers/usb/usbip/stub_main.c
@@ -167,15 +167,15 @@ static ssize_t match_busid_show(struct device_driver *drv, char *buf)
 static ssize_t match_busid_store(struct device_driver *dev, const char *buf,
 				 size_t count)
 {
-	int len;
+	ssize_t len;
 	char busid[BUSID_SIZE];
 
 	if (count < 5)
 		return -EINVAL;
 
 	/* busid needs to include \0 termination */
-	len = strlcpy(busid, buf + 4, BUSID_SIZE);
-	if (sizeof(busid) <= len)
+	len = strscpy(busid, buf + 4, BUSID_SIZE);
+	if (len == -E2BIG)
 		return -EINVAL;
 
 	if (!strncmp(buf, "add ", 4)) {

