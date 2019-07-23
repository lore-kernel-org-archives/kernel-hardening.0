Return-Path: <SRS0=FYnm=VU=lists.openwall.com=kernel-hardening-return-16553-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD9EC7618E
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 12:30:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E4B8E223A1
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 12:30:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4B8E223A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16553-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3076 invoked by uid 550); 23 Jul 2019 12:30:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19634 invoked from network); 23 Jul 2019 06:51:13 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jMAMtmUAhJdSC4vipMY5itqWELsNJG6mJ9qzPbPKC4c=;
        b=ihb0XbaNzs9AlVpMOo2LpImJqR7AyD2EwQ+BeXXDMs9XsReXoQCbUd6szM7HqjNmpO
         lp0uiH2mAA9YaD+NxmwWO+p6vKYN6uXespDnGEszP8uOyQdCX8KHKTgAlkE6yAggf2gy
         +hPkN01mxYODNgfWQExwbeplzNiNfs3C0m678j8KL8uq4ANtBI0O73OJzpS5S5abyAxy
         Gns8F/lCr4TT/79Mmyq9PJGlpaBha4CLDUt0DMyd/vGdnJH0dAByagBWA5YsKHttWL6A
         5odY8GLprLS6Y7mcpjJCsAjYMvTq1e6v62jhmbIX2RD4b2FesNglME3RK+HJc/bDybOS
         ZO7w==
X-Gm-Message-State: APjAAAVI79OZd9MaGmJJ8WYNklUpE3fpTpeMPyXgGTJ14NOB0Zon9ckV
	rL9SfCqthM5SdSFCNCPpGcuFAg==
X-Google-Smtp-Source: APXvYqy/k1FmuZtmzbGj70tGf6pEe8WcHy9IAXeVEBHOs6jjeBXUvh5MQmOdUmijA3oVu2MGxa60jg==
X-Received: by 2002:a7b:c5c3:: with SMTP id n3mr59499751wmk.101.1563864662076;
        Mon, 22 Jul 2019 23:51:02 -0700 (PDT)
From: Ondrej Mosnacek <omosnace@redhat.com>
To: selinux@vger.kernel.org,
	Paul Moore <paul@paul-moore.com>
Cc: NitinGote <nitin.r.gote@intel.com>,
	kernel-hardening@lists.openwall.com,
	Kees Cook <keescook@chromium.org>,
	William Roberts <bill.c.roberts@gmail.com>
Subject: [PATCH v2] selinux: check sidtab limit before adding a new entry
Date: Tue, 23 Jul 2019 08:50:59 +0200
Message-Id: <20190723065059.30101-1-omosnace@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We need to error out when trying to add an entry above SIDTAB_MAX in
sidtab_reverse_lookup() to avoid overflow on the odd chance that this
happens.

Fixes: ee1a84fdfeed ("selinux: overhaul sidtab to fix bug and improve performance")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 security/selinux/ss/sidtab.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/security/selinux/ss/sidtab.c b/security/selinux/ss/sidtab.c
index e63a90ff2728..1f0a6eaa2d6a 100644
--- a/security/selinux/ss/sidtab.c
+++ b/security/selinux/ss/sidtab.c
@@ -286,6 +286,11 @@ static int sidtab_reverse_lookup(struct sidtab *s, struct context *context,
 		++count;
 	}
 
+	/* bail out if we already reached max entries */
+	rc = -EOVERFLOW;
+	if (count >= SIDTAB_MAX)
+		goto out_unlock;
+
 	/* insert context into new entry */
 	rc = -ENOMEM;
 	dst = sidtab_do_lookup(s, count, 1);
-- 
2.21.0

