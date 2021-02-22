Return-Path: <SRS0=tfU5=HY=lists.openwall.com=kernel-hardening-return-20789-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A68C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:15:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 20AD164E04
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:15:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20AD164E04
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20789-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23776 invoked by uid 550); 22 Feb 2021 15:13:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23729 invoked from network); 22 Feb 2021 15:13:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DkOt0yrBVyRKH79yBKw6bfM0jQaRrACpcMjpjEsTbCk=;
        b=XovTNWHwTCos9xzXipmutbAdCB13MpWujMUaUW7i4hXpx6rYXFXRPIZ8/iNIwrIi2R
         IbP55z5TmCskc2vHnE7UiDvlds9Z4mcKkR0XlN2D3QfmOmA+nY0FgXuDfsvASdnr3ug3
         czItvGV4svJ/yme+wrTkvACH9L18hK0r1/zHtY+6xV+8xbuoGUGOBpls8YgfkWLuxWBa
         91YJKDhrgBm2P2OxXOxoUunNoOsDqTJcdQI2B7Chr/RrYqxeCm3jBUh0z5PE43xzj+Fs
         tWiylFYaUFkWZvLYXuEpybk/gQzm7sudrmZpNp3/2HLP7goAXFs5HwUHuZEsY0S7zSKy
         ZGXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DkOt0yrBVyRKH79yBKw6bfM0jQaRrACpcMjpjEsTbCk=;
        b=G62pxTZMkco/SsQsk8XsLmYYfHOe+7YkBs3+0rDY3nBHVWK2mF2YBkGXNx6dLjLOjz
         dC3YusnFxygqe5ecfkOASmqojvwp1hGE+xF7nOT4iW6lJg9ur8lNHGdG5SoUuuxkHJJC
         Yk3lpIEz2DJMn70UjTkrnn55DF1ucXovHjkhuYUx4ChpXdlVTqy1ld8DGxDnTys/nZ8n
         uoYsYedHEZ5irtX4qcfTxbmkzEdvkcTVaKD4c7HksSNAw3YapOABdKBar29Ii7zkFm+V
         VgL3CHTa67+XhGW+M1+vH7AQr3iw4aa4GrX/Vt9YfYWqw9fVfUtvBENrb0A9SvP7DROg
         KdgA==
X-Gm-Message-State: AOAM533kDoVC7f4h1dmPDRt+e7el/xxU6ib7oDKFzO+FpNWiSDEcBJkU
	6zA7zwIfOtgj1Bcm2sZ39zc=
X-Google-Smtp-Source: ABdhPJzqndAalbnZM20kjoLXRdtC8IozfrJChCqLGB5rdddPCSw4ZQcEBtySznNjVccHSoocrtBBLg==
X-Received: by 2002:a5d:524b:: with SMTP id k11mr1010025wrc.122.1614006773420;
        Mon, 22 Feb 2021 07:12:53 -0800 (PST)
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Romain Perier <romain.perier@gmail.com>,
	linux-m68k@lists.linux-m68k.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 09/20] m68k/atari: Manual replacement of the deprecated strlcpy() with return values
Date: Mon, 22 Feb 2021 16:12:20 +0100
Message-Id: <20210222151231.22572-10-romain.perier@gmail.com>
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
 arch/m68k/emu/natfeat.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/emu/natfeat.c b/arch/m68k/emu/natfeat.c
index 71b78ecee75c..fbb3454d3c6a 100644
--- a/arch/m68k/emu/natfeat.c
+++ b/arch/m68k/emu/natfeat.c
@@ -41,10 +41,10 @@ long nf_get_id(const char *feature_name)
 {
 	/* feature_name may be in vmalloc()ed memory, so make a copy */
 	char name_copy[32];
-	size_t n;
+	ssize_t n;
 
-	n = strlcpy(name_copy, feature_name, sizeof(name_copy));
-	if (n >= sizeof(name_copy))
+	n = strscpy(name_copy, feature_name, sizeof(name_copy));
+	if (n == -E2BIG)
 		return 0;
 
 	return nf_get_id_phys(virt_to_phys(name_copy));

