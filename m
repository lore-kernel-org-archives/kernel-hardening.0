Return-Path: <SRS0=kNUV=HY=lists.openwall.com=kernel-hardening-return-20796-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBAC4C433DB
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:17:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ECA4C6148E
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:17:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECA4C6148E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20796-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24401 invoked by uid 550); 22 Feb 2021 15:13:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24279 invoked from network); 22 Feb 2021 15:13:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6uS/mI0aatEHqUL9B1S+eTlivdmOLrwoS7EuJ7+U7Sw=;
        b=XZEw/mrXSku5Su9sqZev/RiL5oSE4cCOxgVcpsEgG3Aw0XC5XGMbZ8sqOGMu46zW6Y
         pmk88rgk0w35uM+iQ/W6ggkpxsWUssIP76jHTKw/m5goS80GD3UFMggz0J3zCrZw4T1n
         vxKoG4KOwfSNVFSUKqDil3BAlxJzyV+NzDxhrbyXbGisNTL1SGQQ+XWbAVPjU4Ob+Z8c
         /8NUJtdfz+cwhHOsdwZbuOZzN2zDOt3EN1OuU2jiw/fI7WxiG6MfHss0L9zX1ekkKH5c
         dVDq4bEHmLsJWf1chDh4fUhoveUKBxqfznRpEoUzR8fBgahyCZVNbvKcQK3A5oSFQ9l8
         uqEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6uS/mI0aatEHqUL9B1S+eTlivdmOLrwoS7EuJ7+U7Sw=;
        b=Azad+4M78/pPQoNa2eUK/gd955HQDBhki7uA7YjY7vfwEfZUzh2wxswcELGE1NTBWN
         jX+Np+odH98cciBxRDqrB4YEv8xcT3DS4KLKh/lmv8byvcJtDNdOeVPeu+qovsZDzuMI
         bvF9wp6SsbhB90wB1EkBLnIRjXIQX+rUXLwstyKEyDhvBih9s7oytLkahTT6wqZfpk6C
         HRHPne+rMdbasU3OTN9X+UQkfd0Cy0MXmfcQYPh+gUDT7CaOHVCIPpGMOwCmxdsVZ6fV
         VtRfN2vIKX8QKRD7Uc/iKuCPzm8jBcgbTH/qZJRTRfr5mTdTccFtMwf9/7vU5U2Dee15
         BHfw==
X-Gm-Message-State: AOAM533okBEpW3N4V8b7zKWqMSITSTGB/9jAoyEO9cbC7XtEhSxRnsEK
	cwK34VsDo7pdeXploHtC9BQ=
X-Google-Smtp-Source: ABdhPJwt7aFnIwDsl4dI/alqogWDhoC64RsfiBRWaspWMkuciWBaudkzHyUrd8ywtQbTILnHc6eO5Q==
X-Received: by 2002:a7b:ce14:: with SMTP id m20mr13614858wmc.12.1614006781358;
        Mon, 22 Feb 2021 07:13:01 -0800 (PST)
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@redhat.com>
Cc: Romain Perier <romain.perier@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 16/20] tracing/probe: Manual replacement of the deprecated strlcpy() with return values
Date: Mon, 22 Feb 2021 16:12:27 +0100
Message-Id: <20210222151231.22572-17-romain.perier@gmail.com>
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
 kernel/trace/trace_uprobe.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 3cf7128e1ad3..f9583afdb735 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -154,12 +154,11 @@ fetch_store_string(unsigned long addr, void *dest, void *base)
 	u8 *dst = get_loc_data(dest, base);
 	void __user *src = (void __force __user *) addr;
 
-	if (unlikely(!maxlen))
-		return -ENOMEM;
-
-	if (addr == FETCH_TOKEN_COMM)
-		ret = strlcpy(dst, current->comm, maxlen);
-	else
+	if (addr == FETCH_TOKEN_COMM) {
+		ret = strscpy(dst, current->comm, maxlen);
+		if (ret == -E2BIG)
+			return -ENOMEM;
+	} else
 		ret = strncpy_from_user(dst, src, maxlen);
 	if (ret >= 0) {
 		if (ret == maxlen)

