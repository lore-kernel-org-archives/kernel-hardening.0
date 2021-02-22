Return-Path: <SRS0=3eDc=HY=lists.openwall.com=kernel-hardening-return-20783-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE80C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:13:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7FCBD64E77
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:13:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7FCBD64E77
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20783-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22174 invoked by uid 550); 22 Feb 2021 15:12:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22052 invoked from network); 22 Feb 2021 15:12:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pdGuMOt4W9f6d632mZ/3+qcmk+vyhqvdNPaPLq7IjEM=;
        b=k6YPsBKxhiIVQgrR1NdSYHdWn4S97ym5N5LCHyB5TOSQxclZfqhb+K112mwVOvPdbc
         YsUsd4glncxcxs/mU+68rO2yBsai6OJMWHsI7TDIBaGyHKBwGGMOcRdSxtby0dHsakBU
         xudObvNr9cstN2fAOzMrQywEDT+qKOMFCrVBy1Yvo5/K3pN1wuEhu5nMw7+Vn4P+oyzq
         kPMccoOCphrMrfGWAsxbhPcYfTeCYThv/ZThSHcajVGLTJ648gdvc90RDNiEvAwmz1CF
         EodIi/cqA2HJ68SYPUU3JACVRe/vGDjIvh4jIeA6QGbl9MIa6ktk+C1cJU8HA7lmYQtu
         aDrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pdGuMOt4W9f6d632mZ/3+qcmk+vyhqvdNPaPLq7IjEM=;
        b=WQ9vMmCULLTvNPmxxcmq+937BirInJRalJYMzmlYWGmStQLiVNwBOjcaRuftaP5DA8
         EeOu3J4ZrBjHrq+UvbN1dy8Wd88cEjZrkEdDOOhkx/lrFQH+L3W54EZ2GK048CUxpd69
         VNVLfRvJixgAb/g0O8Z0nkGMxzKYPcTS0qEtgbojs/zGO4hzc2Y3V/uuGjjDYasa8ha6
         ZsQx6W4Lm/xQ6G63yAMAlFk0yTxVJFHRVGO3lDKnzygm1kewfmRkA/kJDKW4fhZ1axuG
         HqcHjDmTHyL71rl2vFLbCYl+mVMYRsMW8HasTAkG/EGprW6PHeH8S59cr/C0xCggKbVc
         AeOQ==
X-Gm-Message-State: AOAM53012pchvNpMgttWM8m2bnHw1ZvX8R1GN4VdXAsPfCzfJ5LeZoze
	S0BMD+JVfyyg9pYCIC+FAU0Ayl16CPkFXB/CiqM=
X-Google-Smtp-Source: ABdhPJxrpzigvnHf99oo4cOIbGkxhLJ4N3VZOzCxRfNHMT7x79PfV4RdRx6LhrL4FqA9HYIKUqBMqg==
X-Received: by 2002:adf:ff88:: with SMTP id j8mr15600241wrr.62.1614006765655;
        Mon, 22 Feb 2021 07:12:45 -0800 (PST)
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	Jiri Pirko <jiri@nvidia.com>
Cc: Romain Perier <romain.perier@gmail.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 03/20] devlink: Manual replacement of the deprecated strlcpy() with return values
Date: Mon, 22 Feb 2021 16:12:14 +0100
Message-Id: <20210222151231.22572-4-romain.perier@gmail.com>
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
 net/core/devlink.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 737b61c2976e..7eb445460c92 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9461,10 +9461,10 @@ EXPORT_SYMBOL_GPL(devlink_port_param_value_changed);
 void devlink_param_value_str_fill(union devlink_param_value *dst_val,
 				  const char *src)
 {
-	size_t len;
+	ssize_t len;
 
-	len = strlcpy(dst_val->vstr, src, __DEVLINK_PARAM_MAX_STRING_VALUE);
-	WARN_ON(len >= __DEVLINK_PARAM_MAX_STRING_VALUE);
+	len = strscpy(dst_val->vstr, src, __DEVLINK_PARAM_MAX_STRING_VALUE);
+	WARN_ON(len == -E2BIG);
 }
 EXPORT_SYMBOL_GPL(devlink_param_value_str_fill);
 

