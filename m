Return-Path: <SRS0=n+cH=XY=lists.openwall.com=kernel-hardening-return-16958-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE0EDC4360C
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:32:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 00236217F5
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:32:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G+c8PrK2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00236217F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16958-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23786 invoked by uid 550); 29 Sep 2019 16:31:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23709 invoked from network); 29 Sep 2019 16:31:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5asksigGkLc4609dY+n2zdH3ZGsHmODEbP6cIup7ZCk=;
        b=G+c8PrK2TCAwIBaIMGUIUGvdjrcFwC9SFWQIyePR9aXwMthoZq7YyFVsLwe3piDc5X
         ug/KnrvckyOePV5t6pKc212yn7Jja+XVfAXDPUWMa+bU7UjAOqJFToWvr+SRFtihhEGm
         4xT6S1mJqarOexASH78/NcUolZqJr3RLe4sMKsYPdcHNjQ3Mt7JZlO2v2bfSz7dIYMwz
         6DhOYm367s9c792GlzmyGSUO74y/mmkNaNWPSvY+NkDwjpO/IvNVVtanhIeJwXcPLqEj
         ROqso0V563OsRLfP2vNmgMgg7kmKy+Ojs7+3683gikyWRC/GHu6RyyoNy9kYkwYe+22N
         wqng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5asksigGkLc4609dY+n2zdH3ZGsHmODEbP6cIup7ZCk=;
        b=qnzbuYtvkMLqeathdMv9FXe3NC+B8YAhCZRqjKplB40alShOg6YvKNy4cQirxM4Zei
         wzO8gEzsbzbJIL1s7g4dwuk1vs7WQVivrgsSi/RPJ52CTSiLB6NwzQT5TF+xuZHOUYJU
         TCOih3vf6jRiEQVQBVroj3/TsKg16CeTaYVOlXvL41Iimz9ny9/B0+W7PGjTkDwRbHHB
         n31WsRwKMgjgOA9QYV0Csup3UreFxPjyw1tscT26hgOdA9991h3vPgIeF/Rqim8hJziV
         E0dwRH6WMgSLmXBo1lpo03+DTZ5s2OaEewHd6IgfW5bdB2XO15+w3jtNNM7f9C/kOIaj
         rnkg==
X-Gm-Message-State: APjAAAWCsB97agwcGasL1yacb30W6s8oZzcXiM3+a8WDPjCTxUKA+Fvs
	I228h/ehcdwlMa4E00eXHrc=
X-Google-Smtp-Source: APXvYqxrBEaX6uHlbJ2CqSwvmA5jTIXJref2N2dshwkz4hDgRyvzdp7PCB4HUcsfS5HBl/3RAC+quQ==
X-Received: by 2002:a1c:544e:: with SMTP id p14mr13625564wmi.72.1569774653237;
        Sun, 29 Sep 2019 09:30:53 -0700 (PDT)
From: Romain Perier <romain.perier@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	Romain Perier <romain.perier@gmail.com>
Subject: [PRE-REVIEW PATCH 08/16] isdn: Prepare to use the new tasklet API
Date: Sun, 29 Sep 2019 18:30:20 +0200
Message-Id: <20190929163028.9665-9-romain.perier@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929163028.9665-1-romain.perier@gmail.com>
References: <20190929163028.9665-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The future tasklet API will no longer allow to pass an arbitrary
"unsigned long" data parameter. The tasklet data structure will need to
be embedded into a data structure that will be retrieved from the tasklet
handler. The current tasklets handlers get the pointer of the "struct
bc_state", so it is an address we will need to retrieve from the
"struct bas_bc_state", parent of the tasklet being run. This commit adds
a new field in this structure, so we can get the address of the
corresponding "bcs" for any "ubc" and retrieve everything from the
tasklets handlers that will be modified soon.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 drivers/staging/isdn/gigaset/bas-gigaset.c | 1 +
 drivers/staging/isdn/gigaset/gigaset.h     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/staging/isdn/gigaset/bas-gigaset.c b/drivers/staging/isdn/gigaset/bas-gigaset.c
index c334525a5f63..a3febefde39b 100644
--- a/drivers/staging/isdn/gigaset/bas-gigaset.c
+++ b/drivers/staging/isdn/gigaset/bas-gigaset.c
@@ -2128,6 +2128,7 @@ static int gigaset_initbcshw(struct bc_state *bcs)
 		return -ENOMEM;
 	}
 
+	ubc->bcs = bcs;
 	ubc->running = 0;
 	atomic_set(&ubc->corrbytes, 0);
 	spin_lock_init(&ubc->isooutlock);
diff --git a/drivers/staging/isdn/gigaset/gigaset.h b/drivers/staging/isdn/gigaset/gigaset.h
index 0ecc2b5ea553..df745c7bf57c 100644
--- a/drivers/staging/isdn/gigaset/gigaset.h
+++ b/drivers/staging/isdn/gigaset/gigaset.h
@@ -559,6 +559,7 @@ struct bas_bc_state {
 	unsigned stolen0s;		/* '0' stuff bits also serving as
 					   leading flag bits */
 	struct tasklet_struct rcvd_tasklet;
+	struct bc_state *bcs;
 };
 
 struct gigaset_ops {
-- 
2.23.0

