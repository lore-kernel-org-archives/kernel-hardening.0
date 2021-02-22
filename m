Return-Path: <SRS0=Ir4b=HY=lists.openwall.com=kernel-hardening-return-20792-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB5CCC4332D
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:16:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E6DEE6148E
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:16:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E6DEE6148E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20792-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24113 invoked by uid 550); 22 Feb 2021 15:13:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24005 invoked from network); 22 Feb 2021 15:13:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x89BexqXo3Pbh3lJ7Z3KsfvIYs1RyNkeULZlTFZ42+U=;
        b=eFetgx/wQhK3HZ2gWlP04SHuML29p37v+tAFLedoJXj9GkZFBC/hupx34Gp6IhDGrE
         +07FYvjDqIGmymb825+gtZPd+MCkrhBe7yfvasFOdWBH3MP0soii3st4v4Rbt7YdNej9
         UTT4FS8vqX+AkkbPmTrO8blnZrh1Qig1NIXl1iqgxFg9guKAa66TCQ9oCVQNzyj76UQC
         i5TIiYQoNHpnluAMOPEn4xuLmlemsKwaGUEROA9LQN5OUnIbA3RJgpga8G+TAiUQTv9Z
         +0ABoKr1oOu6/txw6FcOaR67h0RIYSFyvOGxG6Yrmx+bMEdom+zC7HXCnaP8admDuyx8
         1MuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x89BexqXo3Pbh3lJ7Z3KsfvIYs1RyNkeULZlTFZ42+U=;
        b=CBdibtzefTyShITDsvWskaCHTM1GKvrC+1NNLL+z53wodi5G0ovkJkg5PuKBDcPpLg
         lkXEKGJPfNVGCfI9ct2YvzP2WRsrWLwnWMFRddNxPnOcncty+Ci3pOssifW96aWO0MIi
         /ra60KtcmYI7vBOWxO/0aItYlrqEOYK27qaY3fhDX49Y7U9eTTwdUcrlAz0fGxn9gHom
         20x0CJ6sOUezBK1U6e1h0NKl1FZyMWfSIxYwW1A+XUpro+4L/br2cu++nXaOqw18hK3H
         bdnA+yGjqH5DPH6XQB2VSsZB13Kdbf+EVr2W1OiyAWdM10FrWlcuMZRXun1Vk0VjLttL
         +idw==
X-Gm-Message-State: AOAM531/LjLszpSCOUi3M2fcKSEUt9ZEtRm8afg5PGzqkiKrzIpiH4Qv
	MuLHjhGyWfIgcSk6ySk0E3Q=
X-Google-Smtp-Source: ABdhPJyyLj7nPo4kA6f6+G83yp5TJSPhh3+lb/y0vT/f7lNvvrjPJjDSCO/PqGqFpOrjePvhXxy5eQ==
X-Received: by 2002:a1c:2e04:: with SMTP id u4mr20581364wmu.79.1614006776742;
        Mon, 22 Feb 2021 07:12:56 -0800 (PST)
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Romain Perier <romain.perier@gmail.com>,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 12/20] s390/hmcdrv: Manual replacement of the deprecated strlcpy() with return values
Date: Mon, 22 Feb 2021 16:12:23 +0100
Message-Id: <20210222151231.22572-13-romain.perier@gmail.com>
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
 drivers/s390/char/diag_ftp.c |    4 ++--
 drivers/s390/char/sclp_ftp.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/char/diag_ftp.c b/drivers/s390/char/diag_ftp.c
index 6bf1058de873..c198dfcc85be 100644
--- a/drivers/s390/char/diag_ftp.c
+++ b/drivers/s390/char/diag_ftp.c
@@ -158,8 +158,8 @@ ssize_t diag_ftp_cmd(const struct hmcdrv_ftp_cmdspec *ftp, size_t *fsize)
 		goto out;
 	}
 
-	len = strlcpy(ldfpl->fident, ftp->fname, sizeof(ldfpl->fident));
-	if (len >= HMCDRV_FTP_FIDENT_MAX) {
+	len = strscpy(ldfpl->fident, ftp->fname, sizeof(ldfpl->fident));
+	if (len == -E2BIG) {
 		len = -EINVAL;
 		goto out_free;
 	}
diff --git a/drivers/s390/char/sclp_ftp.c b/drivers/s390/char/sclp_ftp.c
index dfdd6c8fd17e..525156926592 100644
--- a/drivers/s390/char/sclp_ftp.c
+++ b/drivers/s390/char/sclp_ftp.c
@@ -87,7 +87,7 @@ static int sclp_ftp_et7(const struct hmcdrv_ftp_cmdspec *ftp)
 	struct completion completion;
 	struct sclp_diag_sccb *sccb;
 	struct sclp_req *req;
-	size_t len;
+	ssize_t len;
 	int rc;
 
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
@@ -114,9 +114,9 @@ static int sclp_ftp_et7(const struct hmcdrv_ftp_cmdspec *ftp)
 	sccb->evbuf.mdd.ftp.length = ftp->len;
 	sccb->evbuf.mdd.ftp.bufaddr = virt_to_phys(ftp->buf);
 
-	len = strlcpy(sccb->evbuf.mdd.ftp.fident, ftp->fname,
+	len = strscpy(sccb->evbuf.mdd.ftp.fident, ftp->fname,
 		      HMCDRV_FTP_FIDENT_MAX);
-	if (len >= HMCDRV_FTP_FIDENT_MAX) {
+	if (len == -E2BIG) {
 		rc = -EINVAL;
 		goto out_free;
 	}

