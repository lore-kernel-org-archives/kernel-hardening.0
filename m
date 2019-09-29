Return-Path: <SRS0=yjba=XY=lists.openwall.com=kernel-hardening-return-16955-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 346ABC4360C
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:31:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7A3F8217F5
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:31:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R0gKnJJG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A3F8217F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16955-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22219 invoked by uid 550); 29 Sep 2019 16:30:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22145 invoked from network); 29 Sep 2019 16:30:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FzgzdaOfhopKVZS6nS8NUep7Gr1VrLPqWjmEKwT2ecg=;
        b=R0gKnJJGbNc4JxVHHN5S5NqD0V6ugueiUmvtuxKwjkto9OJuWf/UnUqTxPgLMlUF04
         +l3sfI6lMpyISv0rr6tHW9F/n/HTS3P0I9E2K1WbsqbjI5T8ULDHxPKSDlwcv/l4driJ
         4zfb5EQ9QBYVrIHxX7HK5tbls8gcILdXj2CsJL47x38WOV4n7iSB6NGRl/bIRqw1FA+6
         6Fz7kvihGl/H/pbL4d1MMm0tqrUXybbnIwrlf37MdKidJBES0QAU5H+1EZZLi2ij1QX8
         3LYkdrIbYb3kuvFaCIqvVJ2BUbh0d+r8HPFvBpz6/wTIBcy/5tlKsaqA45xGhHPPeVx8
         8wcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FzgzdaOfhopKVZS6nS8NUep7Gr1VrLPqWjmEKwT2ecg=;
        b=IRk6/MpYSeC6e12rpRocIABgr6wjoq1msRh3knM2l8yhnD6oY9sBiwzKDoGLEjR8/L
         ZBHb1zVIb8az95nKCgHXzOp10QQunZNvu0MaWKjR7RGq1u727UjZ2RoBrahPPJl2dxdt
         rPopeL3zDXWLb5X6jcv4IWPohr+HXBgCNrdYTKvb4USE17hBWHZGwOpga7adDYEItyR6
         GBysjjlfPAXahqBtIHc14wIu0ofHpJZiEmVdFjFdQQ6dK3eXOTsqta2RuQQawOU6zL3w
         Sx0KsG3zICDwWmhoEhb9pmtvKe0K1/7ZmfhmbVIMcwBwyJj0tjsyWIXT6mbhZIv+H3Tl
         QRHQ==
X-Gm-Message-State: APjAAAXeCPG6wGXEzoNf+WeKJR3HgjC6nhTD2ROGSeBIX03jPE7DkkmC
	5roBSCXZMnoK2ujO3oHuWNM=
X-Google-Smtp-Source: APXvYqzwgC5Ey6lgfHKhQ2ySRJkg3we7pcHBNafKCvd52OTd5VdvWBeEQICpdFM1r65Aq5hAkFZYUA==
X-Received: by 2002:a1c:e906:: with SMTP id q6mr13350514wmc.136.1569774647517;
        Sun, 29 Sep 2019 09:30:47 -0700 (PDT)
From: Romain Perier <romain.perier@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	Romain Perier <romain.perier@gmail.com>
Subject: [PRE-REVIEW PATCH 05/16] chelsio: Prepare to use the new tasklet API
Date: Sun, 29 Sep 2019 18:30:17 +0200
Message-Id: <20190929163028.9665-6-romain.perier@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929163028.9665-1-romain.perier@gmail.com>
References: <20190929163028.9665-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The future tasklet API will no longer allow to pass an arbitrary
"unsigned long" data parameter. The tasklet data structure will need to
be embedded into a data structure that will be retrieved from the tasklet
handler. Currently, there are no ways to get the sge data structure from
a given "struct sched *". This commits adds a field to store the pointer
of "the parent sge" into the context of each sched, so future tasklet
handlers will retrieve the "struct sched *" of the corresponding tasklet
and its "struct sge *".

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb/sge.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb/sge.c b/drivers/net/ethernet/chelsio/cxgb/sge.c
index 47b5c8e2104b..b6c656e15801 100644
--- a/drivers/net/ethernet/chelsio/cxgb/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb/sge.c
@@ -239,6 +239,7 @@ struct sched {
 	unsigned int	num;		/* num skbs in per port queues */
 	struct sched_port p[MAX_NPORTS];
 	struct tasklet_struct sched_tsk;/* tasklet used to run scheduler */
+	struct sge *sge;
 };
 static void restart_sched(unsigned long);
 
@@ -379,6 +380,7 @@ static int tx_sched_init(struct sge *sge)
 
 	pr_debug("tx_sched_init\n");
 	tasklet_init(&s->sched_tsk, restart_sched, (unsigned long) sge);
+	s->sge = sge;
 	sge->tx_sched = s;
 
 	for (i = 0; i < MAX_NPORTS; i++) {
-- 
2.23.0

