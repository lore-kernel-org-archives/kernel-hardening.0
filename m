Return-Path: <SRS0=58Nq=HY=lists.openwall.com=kernel-hardening-return-20795-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFA1FC433DB
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:17:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D600764DF5
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:17:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D600764DF5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20795-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24322 invoked by uid 550); 22 Feb 2021 15:13:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24213 invoked from network); 22 Feb 2021 15:13:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WYznJRJi7sEltEuFcbESAgA/1ekiiKcyEWk34Vl4+aw=;
        b=CcgFY/TizwV98v0EjQpqqprS4kVWLxLIO+yAEtYX9MJDmQjMwKOK0zhLFhUAmTTUvo
         UYCCmjDnP3NHnqKIuslmK1ckzcpTkXYuvs0ZfCVMNzBvYmY5JxTzUGmctvKraW5OW/3m
         d3UAE7bzLdvPxuy+csHIHgHU41Y17L8S4vqx0F0JnvKxr1BGWcR0gdJnGyVtMHkBv2OD
         G+ZRlYUbp7mUHzS2OGp06688Aziy6jCbmBcL2ghihroHV2JxcYem1sy18GTKwUfACGzy
         RNfbhejFrJtQ2h2UcWWTlvOP9zx7vP2kTgELNmMdR7OqC90iRXVahtQQtVVU1CPFV8sf
         TYdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WYznJRJi7sEltEuFcbESAgA/1ekiiKcyEWk34Vl4+aw=;
        b=asMySY7ymg1GaH1rHK0w612EsYYNulKqxAV9qy4X61nuRzLlbzutk65QlH/RZkXXJL
         AMj/UdjZo0WLr0Omfb5+upNSYCsuDldCcGUcXfUIa3MpsiYpDcRXWkUi74W2R/qCmNAt
         bFyDTH32KJQ7OrL72p1kCVNBrZYFtnwZPdeQkRCScFf6i3Xun4ghBGa5sV2j4KAcAp4R
         e82PejkUJLxpjBOMrzXRqzP9kZ+ynNPvhOtUzMXhZg+2cSBLMjBEOyCNHJ68Aj7X52a2
         9rhII6bWdmc3YE31Heygk8z9L/I8kyHMMgvZ2Xi8MC7RY0WKHecFZguyvGcXspK0vNVO
         JiYA==
X-Gm-Message-State: AOAM5327KrynqblvLP4LhKqtOhQzaUl7sLXitUtZCQ6rLJqbhGCf86tN
	CpSkeTuuEub3kaZSq70DiSo=
X-Google-Smtp-Source: ABdhPJzjuRXaYt/SRvU62YQ+PqGinj8lFxjNzE0l2PB160Gii4xzWBJxkVSIXDJqoVo/mJEet+g7wQ==
X-Received: by 2002:a5d:54cb:: with SMTP id x11mr2479881wrv.165.1614006780305;
        Mon, 22 Feb 2021 07:13:00 -0800 (PST)
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>
Cc: Romain Perier <romain.perier@gmail.com>,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 15/20] ALSA: usb-audio: Manual replacement of the deprecated strlcpy() with return values
Date: Mon, 22 Feb 2021 16:12:26 +0100
Message-Id: <20210222151231.22572-16-romain.perier@gmail.com>
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
 sound/usb/card.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index 85ed8507e41a..acb1ea3e16a3 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -496,7 +496,7 @@ static void usb_audio_make_longname(struct usb_device *dev,
 	struct snd_card *card = chip->card;
 	const struct usb_audio_device_name *preset;
 	const char *s = NULL;
-	int len;
+	ssize_t len;
 
 	preset = lookup_device_name(chip->usb_id);
 
-- 
2.20.1


