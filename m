Return-Path: <SRS0=WC3O=XY=lists.openwall.com=kernel-hardening-return-16952-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BF3C4360C
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:31:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8E040217F5
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:31:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="errlXVVP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E040217F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16952-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21685 invoked by uid 550); 29 Sep 2019 16:30:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21589 invoked from network); 29 Sep 2019 16:30:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jhbq3TveIlinYpgq1BRWPlrsumrCt93AWFuNHyEsmso=;
        b=errlXVVPETa9SPKNGz/Ts1xIjRKPYBsD9UVuPxb9Cn1//Azn3TPN3d5IuyRFaINw+d
         ZuAi6MyawtE6ICbygilLlK4xu81nIk0bdZUQs5udNLEXJ82bTcWwFp2X8mT1e3DOsAV9
         2Gfu34lMIPdzzafFwbslQ++WSEb1t1KwR2t0fit8LL5xRj8tirrTDSkvq9PsQfO8H3jF
         7jeDzTvLvHS0Rapq1ZQ1uegD0Y5XeaEBxMVe4xqm6H8mtaUOCXktHEtQ8qxOBQN9lbw8
         LFVQDvmZeke1jZYjnTgLHEkKup91hPl7cYzS7fYhSPwUqoGEEexLMZRbhWY2pTKP9n4+
         B4Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jhbq3TveIlinYpgq1BRWPlrsumrCt93AWFuNHyEsmso=;
        b=CIhowbp2fD7p5xXHTljTFVLuaw/geKwCe9W5FcTOigHDx1LjyNEvORUtUAGzqndI6N
         D4PacbRWy3rlIEqZhdfR4O9Zx7FkIUGdwP4Wx2JyHkT3WTtks+StfxMkwcizbHnhUh9j
         lY9SFcxx5azO375MUKUzSkWN6NeCH4KAZrGnpWAbLNx14W7QOWAzXmKXRUGx1SHgRc3o
         x5FBg/09i2m6ziDXDnMogEtNWwouYcizNwHEyiK9+n2AjRUm5CBa4iQLavbQTmCeNzEC
         vHOAoc9aBCIirk19HtRP/DoiDYp2X74sdibL+g1PvEcDNhbtj/PEq53wFUt+2tphMC7s
         HLsw==
X-Gm-Message-State: APjAAAVExdSh84tpbQskjpFEm4AM9eu6tgTpjpOw62m/yeVnnJKUC2rw
	5ApH0EYXtFcc22UsoFi7M18=
X-Google-Smtp-Source: APXvYqy9w6L1jhKQb1MWjlO2w6eCyLhP2l5gd4fKrmFClaS4Kb3O2AM8GICmsDbpt5wCHHeMwIy0wA==
X-Received: by 2002:a1c:c14a:: with SMTP id r71mr14652358wmf.46.1569774642217;
        Sun, 29 Sep 2019 09:30:42 -0700 (PDT)
From: Romain Perier <romain.perier@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	Romain Perier <romain.perier@gmail.com>
Subject: [PRE-REVIEW PATCH 02/16] crypto: ccp - Prepare to use the new tasklet API
Date: Sun, 29 Sep 2019 18:30:14 +0200
Message-Id: <20190929163028.9665-3-romain.perier@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929163028.9665-1-romain.perier@gmail.com>
References: <20190929163028.9665-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, the tasklet and its "tdata" has no relationship. The future
tasklet API, will no longer allow to pass an arbitrary "unsigned long"
data parameter. The tasklet data structure will need to be embedded into
a data structure that will be retrieved from the tasklet handler (most
of the time, it is the driver data structure). This commit prepares the
driver to this change. For doing so, it embeds "tasklet" into "tdata".
Then, "tdata" will be recoverable from its "tasklet" field, with the
tasklet API.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 drivers/crypto/ccp/ccp-dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 73acf0fdb793..d0d180176f45 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -44,6 +44,7 @@ MODULE_PARM_DESC(max_devs, "Maximum number of CCPs to enable (default: all; 0 di
 struct ccp_tasklet_data {
 	struct completion completion;
 	struct ccp_cmd *cmd;
+	struct tasklet_struct tasklet;
 };
 
 /* Human-readable error strings */
@@ -436,9 +437,8 @@ int ccp_cmd_queue_thread(void *data)
 	struct ccp_cmd_queue *cmd_q = (struct ccp_cmd_queue *)data;
 	struct ccp_cmd *cmd;
 	struct ccp_tasklet_data tdata;
-	struct tasklet_struct tasklet;
 
-	tasklet_init(&tasklet, ccp_do_cmd_complete, (unsigned long)&tdata);
+	tasklet_init(&tdata.tasklet, ccp_do_cmd_complete, (unsigned long)&tdata);
 
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
@@ -458,7 +458,7 @@ int ccp_cmd_queue_thread(void *data)
 		/* Schedule the completion callback */
 		tdata.cmd = cmd;
 		init_completion(&tdata.completion);
-		tasklet_schedule(&tasklet);
+		tasklet_schedule(&tdata.tasklet);
 		wait_for_completion(&tdata.completion);
 	}
 
-- 
2.23.0

