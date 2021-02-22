Return-Path: <SRS0=YRFH=HY=lists.openwall.com=kernel-hardening-return-20794-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7084C433E9
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:17:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 021B664DF5
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:17:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 021B664DF5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20794-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24251 invoked by uid 550); 22 Feb 2021 15:13:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24143 invoked from network); 22 Feb 2021 15:13:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AaIJGjhVZ09u/EP3bHxMgqdNAjXosc23vp6hWLR+1MA=;
        b=UmcqE3lzOznpZPI93PnZsK+swpRu7m70pr3gta9k6ZAIq9lPUwIAP1G9soX57vzhSE
         P/a0sNKNqSnFIIPV7MzCjU+UngDEfNkYIt1Ygt32naA/1AwNmtutkAmWt+cP5uyegNef
         zE726RgSRt3elVe1YYwaEEYrhpNaIp3q1R/HZBsH0pBTATq61HxX2NdtCGsRw8xtKOvS
         7zLaHvg7AsObv5YcMHfFoP3BZaymoqvShDHdx5v0vni/ynrG07sM5E3+GEUdzclERKOi
         3vnvPl7WCz5W7zmqT1YjbquukYOHREJtRbP0rGS9D+SWNg+8POkwIaRGxb5jq0Ro4qqy
         cXPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AaIJGjhVZ09u/EP3bHxMgqdNAjXosc23vp6hWLR+1MA=;
        b=rHXmhC0Emqpzm1ykVM052WRCr0EM8/EIi7+M2Zlznp0sG6OYjOewiLc1+pFbciZd/7
         8qDX5/7KUHzSzAq7zugOe+TEo+taP53+MYwe1BMQNWXjU0MqinKkhtFEOp4r4p5u4ZO2
         p7Eb5m+vjxWAjhsqvliXtyP1V0/sgB1K/p9O87meHtD6DxamEJGdb7q06BzrGtWlUjRU
         Vb2IblgQ4pzE2Yy44oS/QQhPlkvehgAZ7i7Zi3oIhJG4xPQRebOc21Iue70kjho48y8b
         +3WUqa/HL3tGl7MjtBi7xEgsenKMgkViAYlf/srB2W+KpN5yOxI4eDRJGdYWWEHoZNVo
         8auw==
X-Gm-Message-State: AOAM533t4yieZBk5pf+Qjt92Xd2oYRA1yPO+yAAZz+bvGD4EjSK8ND9I
	0awcS5He4UcFNXLoFWCXU+MCs3znI0swNrZfdjg=
X-Google-Smtp-Source: ABdhPJxPIIevSdHpq0bz8dkLKKzkdobBzKa6BG4pC9pZkFSwSrY4yq1GT/LnCNM1hIF4l39fbEWI4g==
X-Received: by 2002:a1c:2090:: with SMTP id g138mr20574057wmg.137.1614006779236;
        Mon, 22 Feb 2021 07:12:59 -0800 (PST)
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Romain Perier <romain.perier@gmail.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 14/20] target: Manual replacement of the deprecated strlcpy() with return values
Date: Mon, 22 Feb 2021 16:12:25 +0100
Message-Id: <20210222151231.22572-15-romain.perier@gmail.com>
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
 drivers/target/target_core_configfs.c |   33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f04352285155..676215cd8847 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1325,16 +1325,11 @@ static ssize_t target_wwn_vendor_id_store(struct config_item *item,
 	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
 	unsigned char buf[INQUIRY_VENDOR_LEN + 2];
 	char *stripped = NULL;
-	size_t len;
+	ssize_t len;
 	ssize_t ret;
 
-	len = strlcpy(buf, page, sizeof(buf));
-	if (len < sizeof(buf)) {
-		/* Strip any newline added from userspace. */
-		stripped = strstrip(buf);
-		len = strlen(stripped);
-	}
-	if (len > INQUIRY_VENDOR_LEN) {
+	len = strscpy(buf, page, sizeof(buf));
+	if (len == -E2BIG) {
 		pr_err("Emulated T10 Vendor Identification exceeds"
 			" INQUIRY_VENDOR_LEN: " __stringify(INQUIRY_VENDOR_LEN)
 			"\n");
@@ -1381,16 +1376,11 @@ static ssize_t target_wwn_product_id_store(struct config_item *item,
 	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
 	unsigned char buf[INQUIRY_MODEL_LEN + 2];
 	char *stripped = NULL;
-	size_t len;
+	ssize_t len;
 	ssize_t ret;
 
-	len = strlcpy(buf, page, sizeof(buf));
-	if (len < sizeof(buf)) {
-		/* Strip any newline added from userspace. */
-		stripped = strstrip(buf);
-		len = strlen(stripped);
-	}
-	if (len > INQUIRY_MODEL_LEN) {
+	len = strscpy(buf, page, sizeof(buf));
+	if (len == -E2BIG) {
 		pr_err("Emulated T10 Vendor exceeds INQUIRY_MODEL_LEN: "
 			 __stringify(INQUIRY_MODEL_LEN)
 			"\n");
@@ -1437,16 +1427,11 @@ static ssize_t target_wwn_revision_store(struct config_item *item,
 	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
 	unsigned char buf[INQUIRY_REVISION_LEN + 2];
 	char *stripped = NULL;
-	size_t len;
+	ssize_t len;
 	ssize_t ret;
 
-	len = strlcpy(buf, page, sizeof(buf));
-	if (len < sizeof(buf)) {
-		/* Strip any newline added from userspace. */
-		stripped = strstrip(buf);
-		len = strlen(stripped);
-	}
-	if (len > INQUIRY_REVISION_LEN) {
+	len = strscpy(buf, page, sizeof(buf));
+	if (len == -E2BIG) {
 		pr_err("Emulated T10 Revision exceeds INQUIRY_REVISION_LEN: "
 			 __stringify(INQUIRY_REVISION_LEN)
 			"\n");

