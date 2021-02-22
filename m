Return-Path: <SRS0=fX6q=HY=lists.openwall.com=kernel-hardening-return-20800-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D20DEC433DB
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:19:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1ED8F64E83
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:19:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1ED8F64E83
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20800-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25666 invoked by uid 550); 22 Feb 2021 15:13:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24519 invoked from network); 22 Feb 2021 15:13:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=24BL/iNm/fhU40HUi/hWtrmxaezcBQ+HXPsyjGQxBIo=;
        b=aaT0G/6TPkMVKasY0K+CD2HHIphx92WqXSKR482UnNPC/Dw6RTdYUajXcvWj5JxCpW
         8sfT+13XlreR72oYWOKLWRxOzgMLwot2q8GXpJiWoq7vv8keyNgyGAEXQdIAJZsYFYxu
         9oozI3VPNhjir/Dc8xRVF1efGRLRax2AL5U3xKZd7hI8ahM6/+EAqOeu+v5ExNEfvU6m
         YEXviYbfZtFcujSnXKa1vV3/Q31O/Ry8WfSmofK190AjXtfW9k71QJWUCY5NINQpW957
         9mMzgZFjNzNAd7tyXyKdIA1tfAyIwnDAVCOtXKEkuIkii8yw8fvQhbc2VIO2C2wFJoeR
         51Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=24BL/iNm/fhU40HUi/hWtrmxaezcBQ+HXPsyjGQxBIo=;
        b=BV8k6G7PyLWW3hJr+tqLKsf/FAJO5CfBPDDQINLErwbRLC81K0YYORaCIgOMjf/YAo
         w7TasSOhTb8JrXtff0zj6uU74k1YdA+sG8ZNsfs5N1aUnk4Eoc/S3+YkRz0CnyXI6CEw
         vynWy4Rlm5VuZ9W5derR1SCZD2GqHjtRfzHGe921LXuBuL7aofzuFOXdZYiExCmBLsqz
         dHrgJFAJb6eZCLvqy1dB84mZPnHhfX15GYx7/K/8ZDQR3VdBpLzUCZoqqFHI4gz1cAMu
         mSTdohD4jXRPjJMDKQG4aoikaUbceaFTMpqoJ0tVFxKY5d7ZqOuD641dbJcxjmvmhC9g
         c+SQ==
X-Gm-Message-State: AOAM531/ki/B2Gfkr4L+T08AT19CrKl/vnoStLz9RmqsD5qZFjgIIYgF
	HgGQ8AB/1vvxAJgzFkCT0Yk=
X-Google-Smtp-Source: ABdhPJxvgxyutQqdF4CzBQ2jUcCdCfMoxXN6O3eh4JjIrCfH4tryUG8CD/8iT/uMuDIoz+kC7pzRqA==
X-Received: by 2002:a5d:5283:: with SMTP id c3mr21327841wrv.319.1614006786274;
        Mon, 22 Feb 2021 07:13:06 -0800 (PST)
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>
Cc: Romain Perier <romain.perier@gmail.com>,
	linux-watchdog@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 20/20] s390/watchdog: Manual replacement of the deprecated strlcpy() with return values
Date: Mon, 22 Feb 2021 16:12:31 +0100
Message-Id: <20210222151231.22572-21-romain.perier@gmail.com>
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
 drivers/watchdog/diag288_wdt.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/watchdog/diag288_wdt.c b/drivers/watchdog/diag288_wdt.c
index aafc8d98bf9f..5703f35dd0b7 100644
--- a/drivers/watchdog/diag288_wdt.c
+++ b/drivers/watchdog/diag288_wdt.c
@@ -111,7 +111,7 @@ static unsigned long wdt_status;
 static int wdt_start(struct watchdog_device *dev)
 {
 	char *ebc_cmd;
-	size_t len;
+	ssize_t len;
 	int ret;
 	unsigned int func;
 
@@ -126,7 +126,9 @@ static int wdt_start(struct watchdog_device *dev)
 			clear_bit(DIAG_WDOG_BUSY, &wdt_status);
 			return -ENOMEM;
 		}
-		len = strlcpy(ebc_cmd, wdt_cmd, MAX_CMDLEN);
+		len = strscpy(ebc_cmd, wdt_cmd, MAX_CMDLEN);
+		if (len == -E2BIG)
+			return -E2BIG;
 		ASCEBC(ebc_cmd, MAX_CMDLEN);
 		EBC_TOUPPER(ebc_cmd, MAX_CMDLEN);
 
@@ -163,7 +165,7 @@ static int wdt_stop(struct watchdog_device *dev)
 static int wdt_ping(struct watchdog_device *dev)
 {
 	char *ebc_cmd;
-	size_t len;
+	ssize_t len;
 	int ret;
 	unsigned int func;
 
@@ -173,7 +175,9 @@ static int wdt_ping(struct watchdog_device *dev)
 		ebc_cmd = kmalloc(MAX_CMDLEN, GFP_KERNEL);
 		if (!ebc_cmd)
 			return -ENOMEM;
-		len = strlcpy(ebc_cmd, wdt_cmd, MAX_CMDLEN);
+		len = strscpy(ebc_cmd, wdt_cmd, MAX_CMDLEN);
+		if (len == -E2BIG)
+			return -E2BIG;
 		ASCEBC(ebc_cmd, MAX_CMDLEN);
 		EBC_TOUPPER(ebc_cmd, MAX_CMDLEN);
 

