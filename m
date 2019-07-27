Return-Path: <SRS0=jjGz=VY=lists.openwall.com=kernel-hardening-return-16597-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5377BC7618B
	for <kernel-hardening@archiver.kernel.org>; Sat, 27 Jul 2019 16:13:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ACBA22087C
	for <kernel-hardening@archiver.kernel.org>; Sat, 27 Jul 2019 16:13:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L7ewl3Ac"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACBA22087C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16597-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28527 invoked by uid 550); 27 Jul 2019 16:13:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9823 invoked from network); 27 Jul 2019 15:58:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=N73gVQg6a3C4HgsLaCOq7Hz45GAHNtEV1T91iTCqpnk=;
        b=L7ewl3AcLbeUFC7eCzjQRdIrUTWRMVKW5HX8M73hOwasMI5rZAP58D8VrsF+tivWmI
         jKUmxze/cTEXPonmRssoee50rJRKeu0WgX1eHy5njqPo5F/T+h0IZ4fTMUkra1grtNj2
         nqul8qI/U45GP6C7AbzTFP5q5uJcAqEXHIk7aew0MlXUs6zm/wlxJjsPHm18U7SrseAr
         Dqvv34ajcidNajkImd5iMk1u0S1JCUiUi+BnEKLtDXaoyPsMoXy2o2vC/2le4oDeCXWm
         5XojNkr/3rKxynBkSFPNw6jiMdl4mDr6jba494XaR75mVxY5+QnPc7zc6BX1NryrMvdk
         431Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=N73gVQg6a3C4HgsLaCOq7Hz45GAHNtEV1T91iTCqpnk=;
        b=YFUQhceU8z2YItGN+u8cWZjVNW/qiVrncY0W9DkFdEy+I55XIgIfKx76gl+8qNFRB7
         pO2JIKLRvhUQ3OB88hkan14UrhRJ4hBnbDfzQoovfONBdyjANFg0fdLxy6kXOLFRbwz4
         5yE6o6eqDFsoXRNeqZSamT18cwD0uGRuKkGX+/WqdCTMj7YvV/1c21SvnxBXK9/+X5zJ
         nYpjJn93pLWidSXm56VUmG9lH6uK3fEnnvjc6XM4SqH3vvEhOYbdexYpvKhqjSm7TB59
         Z/R2jABnSVV58lBNRclLuPg4KTztM0kmGfxKoH0jW1QU3s78ZC8IicNydSfK5ilXznAl
         uuyg==
X-Gm-Message-State: APjAAAU/RUFXnXsJzw6VF6EJg1OaQcOvcR87+Lu83E+hw0As+S0+lvhq
	RcjbrPY71jkSJM+KMFnHFiI=
X-Google-Smtp-Source: APXvYqw+ZQUom1oi/G4J7dHzt5RJ3zkCqb6hAenYN/wiGCdzeLJyS0z/7VcBbkoAHSYOj6QHYZY22w==
X-Received: by 2002:a17:902:b905:: with SMTP id bf5mr95127804plb.342.1564243126185;
        Sat, 27 Jul 2019 08:58:46 -0700 (PDT)
Date: Sun, 28 Jul 2019 00:58:41 +0900
From: Joonwon Kang <kjw1627@gmail.com>
To: keescook@chromium.org
Cc: re.emese@gmail.com, kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] randstruct: fix a bug in is_pure_ops_struct()
Message-ID: <20190727155841.GA13586@host>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)

Before this, there were false negatives in the case where a struct
contains other structs which contain only function pointers because
of unreachable code in is_pure_ops_struct().

Signed-off-by: Joonwon Kang <kjw1627@gmail.com>
---
 scripts/gcc-plugins/randomize_layout_plugin.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index 6d5bbd31db7f..a123282a4fcd 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -443,13 +443,12 @@ static int is_pure_ops_struct(const_tree node)
 		if (node == fieldtype)
 			continue;
 
-		if (!is_fptr(fieldtype))
-			return 0;
-
-		if (code != RECORD_TYPE && code != UNION_TYPE)
-			continue;
+		if (code == RECORD_TYPE || code == UNION_TYPE) {
+			if (!is_pure_ops_struct(fieldtype))
+				return 0;
+		}
 
-		if (!is_pure_ops_struct(fieldtype))
+		if (!is_fptr(fieldtype))
 			return 0;
 	}
 
-- 
2.17.1

