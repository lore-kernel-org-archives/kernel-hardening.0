Return-Path: <SRS0=8JGG=HY=lists.openwall.com=kernel-hardening-return-20782-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B02C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:13:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C065664DF5
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:13:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C065664DF5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20782-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22046 invoked by uid 550); 22 Feb 2021 15:12:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21913 invoked from network); 22 Feb 2021 15:12:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bS+BhtUH3R5L/9GDlP7BU+Ce2CmxRyCIWCNfBp1I6gM=;
        b=V5cR30vb5ardXeLt1d88QjtqI6/PZWMibuMU6FBWH9EF+5K4B7ctOb8EB9Nyw2+5O/
         B9DRlg8fmqjkflRlIWXPb5PmqND8ANbJzfMVVl6CfSc/H95nHm1PyuLvjBrysK2xDjmV
         eQLwLsWF227SCr5APVYITzaqAgCw//AAItH+IWl2SAeN4LzRXmXEYvJ6PecDGNySDc4p
         IoZJSdblCMO+SeXF9z861+jky4AvY48blDSwbc8Fqk59soEOkZ0EbZpniMgaPfg21OVW
         xxChBbjW63ip25O/FvjUxtYu+nOdaku8Z27gVkmqS2yhU3cjha3zgR6FIYJxsFTOQmWY
         2aZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bS+BhtUH3R5L/9GDlP7BU+Ce2CmxRyCIWCNfBp1I6gM=;
        b=Uvrp9fGXoRjm08+DG6Uclp6y5MeTbuf5txzz7K2ejxIiSsWw8NC2s5h4E7nTlThOxf
         MYVib+sj3qTm/Dlf0GNGxRUvW3y0Zr8UpVPwHKb7qKRjDxnUNJ3tqhEprJsMmUxQbVm0
         DNcsgZ3T872S5ugs78LLLZg50gzhZTBC6BJ/Kam5lV5MiqcFb8W8UO0RWN+dWr+3E50G
         XCQToquuydeQvQXK4irbdx/8bU1xhWCEnOq7I1aetdLospJf3Wx1bXJ8NYBjJslvV1wN
         uerh+v+rhFNj4BIlXSqwAsjQLFzxejT75Oowle/rNPg1spxyIOMKqrGr2gD/2yPTlnf2
         cmTw==
X-Gm-Message-State: AOAM530TOUqQEitWqEC46jz36+jW1IhLlYULnZpNCd4CN9eT9kr3JSXw
	w+yGF7lfmKjSNvHlx6DR9VE=
X-Google-Smtp-Source: ABdhPJw11x5IL7ncOL+63QUugBE7PetgqUhUecRWWpL8gsY5S92hRrmOrK8XXRALroxCO+KKqgCkIA==
X-Received: by 2002:a1c:7705:: with SMTP id t5mr14179710wmi.148.1614006764022;
        Mon, 22 Feb 2021 07:12:44 -0800 (PST)
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Romain Perier <romain.perier@gmail.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 02/20] crypto: Manual replacement of the deprecated strlcpy() with return values
Date: Mon, 22 Feb 2021 16:12:13 +0100
Message-Id: <20210222151231.22572-3-romain.perier@gmail.com>
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
 crypto/lrw.c |    6 +++---
 crypto/xts.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index bcf09fbc750a..4d35f4439012 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -357,10 +357,10 @@ static int lrw_create(struct crypto_template *tmpl, struct rtattr **tb)
 	 * cipher name.
 	 */
 	if (!strncmp(cipher_name, "ecb(", 4)) {
-		unsigned len;
+		ssize_t len;
 
-		len = strlcpy(ecb_name, cipher_name + 4, sizeof(ecb_name));
-		if (len < 2 || len >= sizeof(ecb_name))
+		len = strscpy(ecb_name, cipher_name + 4, sizeof(ecb_name));
+		if (len == -E2BIG || len < 2)
 			goto err_free_inst;
 
 		if (ecb_name[len - 1] != ')')
diff --git a/crypto/xts.c b/crypto/xts.c
index 6c12f30dbdd6..1dfe39d61418 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -396,10 +396,10 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	 * cipher name.
 	 */
 	if (!strncmp(cipher_name, "ecb(", 4)) {
-		unsigned len;
+		ssize_t len;
 
-		len = strlcpy(ctx->name, cipher_name + 4, sizeof(ctx->name));
-		if (len < 2 || len >= sizeof(ctx->name))
+		len = strscpy(ctx->name, cipher_name + 4, sizeof(ctx->name));
+		if (len == -E2BIG || len < 2)
 			goto err_free_inst;
 
 		if (ctx->name[len - 1] != ')')

