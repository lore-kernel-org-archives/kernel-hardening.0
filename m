Return-Path: <SRS0=qdhH=HY=lists.openwall.com=kernel-hardening-return-20798-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C95C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:18:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2F7DC64E61
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:18:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F7DC64E61
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20798-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24513 invoked by uid 550); 22 Feb 2021 15:13:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24373 invoked from network); 22 Feb 2021 15:13:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eE3vB1/Y8MdpJt97O9ILAeiKByH7vJluKckPn4DVjuc=;
        b=qRBLvooKzzptyg4Na1vV+Zw3xpJrgdbtv8oSWAD7uDzDOAIsoTtNtDBnRP9zRr6tkh
         9f6G6dKGjz9WqzquotrqA1GQ0V2DC9qo/WLqkVtNZzGlwHJ6egBZxwWujxTt/wYYKVgT
         N9EkVwdrFyjVzqlI1Q150Z6RFloU34+sttMm2VStZnXAzwYTBae87xniZ9tqaDV+5Rv7
         NlvoiH4/Btz0f3ojJebhRhpVbONzce8Rr1ksYkPxS50D3HLkxHENK/oyP9iYz9y4yD2S
         Hj9yfnfnfRQn6PdUvWIhTP9ZODAnNhPVrqhvbkfziR3sCGsXj4jq1O1wu9GUWbxu1vW7
         ylvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eE3vB1/Y8MdpJt97O9ILAeiKByH7vJluKckPn4DVjuc=;
        b=Oo/kMz8l6Y1eOCOuBwLP2EHsYjurR3UISfi7xPI9+JIC9JMmDybsg42SC96H8j1FiM
         0RX2PWxiMIGvsNmoxWFM0sfUY6Vo9CGBeleJgMKGWI+txk5SNBajK0B2LV6NvITP8o10
         zCuBl+298qV5r5ie086cfdOYBkIMHeqhOJJVKpyfYR9MUV7wsY/epbLsZ5zkpMGL0p4V
         atfuTlti9lIcEhGrBAJLiJ/bg8xSTVTFe+JXuUzuqiDDe0vv1h9m1XeBeQqQLfbxyGZT
         aK/TsAmRGHIGRr0il3L2pEipWT6f1qGBeJyOEqz7mAqlE4Hq6QycAvR1dqarHP2LnamI
         ZOUw==
X-Gm-Message-State: AOAM5328i+UBxFCxQXje84JGTXUdaOaoRxujvK46l4kmYTxj0hHDUDhR
	jcT5LiMrVbiYQrOPXzwVHj0=
X-Google-Smtp-Source: ABdhPJyfPGar/M7v1Lbgl1i6VGHfK9R+x8JNl1xnJQkxT/oA6TAsd7WzE2w4ZgIygKgSC/mrQJNzqg==
X-Received: by 2002:adf:f1c4:: with SMTP id z4mr4346920wro.52.1614006783582;
        Mon, 22 Feb 2021 07:13:03 -0800 (PST)
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Felipe Balbi <balbi@kernel.org>
Cc: Romain Perier <romain.perier@gmail.com>,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 18/20] usb: gadget: f_midi: Manual replacement of the deprecated strlcpy() with return values
Date: Mon, 22 Feb 2021 16:12:29 +0100
Message-Id: <20210222151231.22572-19-romain.perier@gmail.com>
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
 drivers/usb/gadget/function/f_midi.c    |    4 ++--
 drivers/usb/gadget/function/f_printer.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/function/f_midi.c b/drivers/usb/gadget/function/f_midi.c
index 71a1a26e85c7..1f2b0d4309b4 100644
--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -1143,11 +1143,11 @@ F_MIDI_OPT(out_ports, true, MAX_PORTS);
 static ssize_t f_midi_opts_id_show(struct config_item *item, char *page)
 {
 	struct f_midi_opts *opts = to_f_midi_opts(item);
-	int result;
+	ssize_t result;
 
 	mutex_lock(&opts->lock);
 	if (opts->id) {
-		result = strlcpy(page, opts->id, PAGE_SIZE);
+		result = strscpy(page, opts->id, PAGE_SIZE);
 	} else {
 		page[0] = 0;
 		result = 0;
diff --git a/drivers/usb/gadget/function/f_printer.c b/drivers/usb/gadget/function/f_printer.c
index 61ce8e68f7a3..af83953e6770 100644
--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -1212,15 +1212,15 @@ static ssize_t f_printer_opts_pnp_string_show(struct config_item *item,
 					      char *page)
 {
 	struct f_printer_opts *opts = to_f_printer_opts(item);
-	int result = 0;
+	ssize_t result = 0;
 
 	mutex_lock(&opts->lock);
 	if (!opts->pnp_string)
 		goto unlock;
 
-	result = strlcpy(page, opts->pnp_string, PAGE_SIZE);
-	if (result >= PAGE_SIZE) {
-		result = PAGE_SIZE;
+	result = strscpy(page, opts->pnp_string, PAGE_SIZE);
+	if (result == -E2BIG) {
+		goto unlock;
 	} else if (page[result - 1] != '\n' && result + 1 < PAGE_SIZE) {
 		page[result++] = '\n';
 		page[result] = '\0';

