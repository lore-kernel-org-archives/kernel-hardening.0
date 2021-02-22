Return-Path: <SRS0=V1WD=HY=lists.openwall.com=kernel-hardening-return-20797-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30E00C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:18:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 57DC364E83
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:18:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57DC364E83
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20797-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24441 invoked by uid 550); 22 Feb 2021 15:13:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24346 invoked from network); 22 Feb 2021 15:13:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pNjPP+R6G1ipZtLvtiVHNIvTPKhMwdVdBohHcYREKCw=;
        b=czOh/H+hJtEMAW7bl45eaYyPl+SGuDPrp1yzUjcGmgfimbF7FpaKsatvBqaQUE58IY
         jfsa9jO6Ofi087FELMZ11LHCvRWx3NK3RJUAn3er32i1wS0cqrT77H6x6GUN9bocNpqp
         E9Cb+6ioqmICjpIY+SIou+1IR3oqvxXuCmFutIF3HUV6FfCE9Q2g/WeKY9GRaDNpWOM3
         3XpNLC+Vnqr5cAIC74JQ76tuVnjyo+VHImkVdAY1PsVKKfkNi8BE0qufn02lx90c29uv
         4dM5NF+hrClmTRgOpJLK3nwnzKqarm8Tq3D5O9iN8RBz4Bi8rJDPi2jiapbOSzblwcjD
         dkXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pNjPP+R6G1ipZtLvtiVHNIvTPKhMwdVdBohHcYREKCw=;
        b=b4UrTnLtYRXyvk2lzJHe6zzFKqYdUFBjo2HhrElp5mwcV7jXiwwJdjSj3O8j+5eBLD
         JbWwo9LJVypEQXEJ3me8TEjdtw5qmV1ABXEsWUp30V5WnTSaY9Q7spAAPPOfArcEP7nW
         t/erAXLPmQZMDECjB3MsLOnLGHDkk76LN3+o72G5skUDOM96GYZaY/5f1Gxq7lC63DFZ
         LB6V/rI//yJwdurBvxt6AfbsvYRsKI6SkLTtAH5kxJZGTMBmqeD9e9yrSkDkOXqXHY/2
         WWhDxJbTU5MapFixXhwKDLr8tlG8nClEUiF/vjD3u+NicspAVLGjKSwjAjE01TDQ9meT
         W60A==
X-Gm-Message-State: AOAM533fx8q6RCd2zHIXVxAxaMXoB0NF8oaS3m7iSI2GnXoD/vqFnIdU
	vTHTT1ZyCixlLnkkar6rZTY=
X-Google-Smtp-Source: ABdhPJxELjftRjbjQ8QfUGGO1yRJpXVaKOsjxszlBPDZ6XpG6SXTXprLGU2UGpUASnlugQFQNk7gkw==
X-Received: by 2002:a5d:540d:: with SMTP id g13mr22002512wrv.143.1614006782504;
        Mon, 22 Feb 2021 07:13:02 -0800 (PST)
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>
Cc: Romain Perier <romain.perier@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 17/20] vt: Manual replacement of the deprecated strlcpy() with return values
Date: Mon, 22 Feb 2021 16:12:28 +0100
Message-Id: <20210222151231.22572-18-romain.perier@gmail.com>
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
 drivers/tty/vt/keyboard.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 77638629c562..5e20c6c307e0 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -2067,9 +2067,12 @@ int vt_do_kdgkb_ioctl(int cmd, struct kbsentry __user *user_kdgkb, int perm)
 			return -ENOMEM;
 
 		spin_lock_irqsave(&func_buf_lock, flags);
-		len = strlcpy(kbs, func_table[kb_func] ? : "", len);
+		len = strscpy(kbs, func_table[kb_func] ? : "", len);
 		spin_unlock_irqrestore(&func_buf_lock, flags);
 
+		if (len == -E2BIG)
+			return -E2BIG;
+
 		ret = copy_to_user(user_kdgkb->kb_string, kbs, len + 1) ?
 			-EFAULT : 0;
 

