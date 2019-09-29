Return-Path: <SRS0=fCwZ=XY=lists.openwall.com=kernel-hardening-return-16954-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81DFAC4360C
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:31:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C9C69217F5
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:31:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E8pWc1ym"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9C69217F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16954-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22067 invoked by uid 550); 29 Sep 2019 16:30:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21973 invoked from network); 29 Sep 2019 16:30:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CW9SpO3BnroQsvnvmxPFFfeIhkRcu5C+hK4Vkk6u/pE=;
        b=E8pWc1ymsW1QHAGSaq7C4tuuHuJ8f0U1jDgQ5EJ7n0bR6LHgjYV9uKTuV0qTIOzdka
         P0NaO4cq17trXdf/4GtJkJFqtt48fBKfkCHVOi+Ag6AtuGIxxYcBFclUVfi5tSDa/jiH
         Fz70tDqtNmso32RldyEmv/p2epMdtH8R482E08JwjXaMmPuboR+Kuv6X1N69WjYBp2Eb
         8eLYV1s/+sZsIOrHjrZErt5dR884atGaLbnVyk5HJUEwAAcj+JWonr6jHKWwcv0vusfv
         ngu8TNEack3wci7rPDh18MA8hRSN9SJh3pC7Yt6Uawq1Ve4dZzmAUTWcOAh1DrEvVXen
         zNgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CW9SpO3BnroQsvnvmxPFFfeIhkRcu5C+hK4Vkk6u/pE=;
        b=CilEzkl1I7YPCO15qiNJO5iK+HXy9IerY3IX0zotlhywYdLSoZWXCZHjW50CfpGVKP
         kIePKHyVzC4Bwvm5a7OfG19DDFeG5DWdZWjDKnOAN2go+M+sPGh1mvrEyRIibQSvLwWm
         U7uiGS8a0J4FqOlvL3Yl7eJpjZ7NZZXRlzWKOKyA0KwWEvOX9jR3K0pBEYGIzBl2GkEl
         KIbjTxpW73aMgIvTy9WwB3f7Xxd2328fv82Tw1AMuF+rf7ga8+Ddu5euYmM3iKUdfZ/e
         tEdkGwg+7dkWz+vR2G+nXlG+a7MbXwZefDv0FpfEBVjpxVoeDinEyFJ2LG+jCWEPp8bt
         TmdA==
X-Gm-Message-State: APjAAAVEBPNsrtVFiajhUN9fimbNSDlZGjBGbEvdlkp7Kz9aQIsp5HGf
	kqIkSDfEbfuc4gOeqN+g71A=
X-Google-Smtp-Source: APXvYqwhmXUBlJUL4bFWqJca0BL9lQQRQ+kkAUiW5qxhKzE0pc15QBr29p4i8E0a102MJB3wBH745Q==
X-Received: by 2002:a5d:40d2:: with SMTP id b18mr9834794wrq.4.1569774645871;
        Sun, 29 Sep 2019 09:30:45 -0700 (PDT)
From: Romain Perier <romain.perier@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	Romain Perier <romain.perier@gmail.com>
Subject: [PRE-REVIEW PATCH 04/16] net: liquidio: Prepare to use the new tasklet API
Date: Sun, 29 Sep 2019 18:30:16 +0200
Message-Id: <20190929163028.9665-5-romain.perier@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929163028.9665-1-romain.perier@gmail.com>
References: <20190929163028.9665-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The future tasklet API will no longer allow to pass an arbitrary
"unsigned long" data parameter. The tasklet data structure will need to
be embedded into a data structure that will be retrieved from the tasklet
handler. Currently, the private driver data structure "struct
octeon_priv" is retrievable from the tasklet (by using container_of),
howerver it is not the case for the "struct octeon_device" (the field
"priv" is a pointer and cannot be used in container_of). This commit
adds a new field in the private data structure, so we can easily get a
pointer to the main device from the private context.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 drivers/net/ethernet/cavium/liquidio/lio_main.c    | 1 +
 drivers/net/ethernet/cavium/liquidio/octeon_main.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 7f3b2e3b0868..283e1461257d 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -4326,6 +4326,7 @@ static int octeon_device_init(struct octeon_device *octeon_dev)
 	complete(&handshake[octeon_dev->octeon_id].init);
 
 	atomic_set(&octeon_dev->status, OCT_DEV_HOST_OK);
+	oct_priv->dev = octeon_dev;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_main.h b/drivers/net/ethernet/cavium/liquidio/octeon_main.h
index 073d0647b439..5b4cb725f60f 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_main.h
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_main.h
@@ -39,6 +39,7 @@ struct octeon_device_priv {
 	/** Tasklet structures for this device. */
 	struct tasklet_struct droq_tasklet;
 	unsigned long napi_mask;
+	struct octeon_device *dev;
 };
 
 /** This structure is used by NIC driver to store information required
-- 
2.23.0

