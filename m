Return-Path: <SRS0=g4Tb=VX=lists.openwall.com=kernel-hardening-return-16595-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3AA5C7618B
	for <kernel-hardening@archiver.kernel.org>; Fri, 26 Jul 2019 16:31:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4FEFC2173B
	for <kernel-hardening@archiver.kernel.org>; Fri, 26 Jul 2019 16:31:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mUP5bp4B"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4FEFC2173B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16595-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14255 invoked by uid 550); 26 Jul 2019 16:31:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14221 invoked from network); 26 Jul 2019 16:31:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=/uapPV30FnuKZOrO/m+jPWlWR9noietQQzXlvKFWtUQ=;
        b=mUP5bp4BDhvX9Kpssr8T17MpsFdLah6pAxJ5MAWH71gFIWKSggQPSakLOdtYR4zNF4
         ZW/P5eudklFUK77ocHBWiRLn3aMcU38uxHsul1Xm7j3/Tiaiao2X5rBMnRR6nYb18YPg
         pFCr/Q67E6TnJx7eTRhKBk+R29Tj6EjP6/dbg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=/uapPV30FnuKZOrO/m+jPWlWR9noietQQzXlvKFWtUQ=;
        b=fq00pNgb22l7fZTsVxmFcIjn1N10qPBiRfiDGyDPyZnVkXroTK2zREGNFkycC2n2Le
         BO3qmvildGTLN47K0Mk55cpk1KmmyQhvNtvBJRPHqv/5Ar6KSFIlcFJy6dA5r+vwLcFV
         KrGQ8ztwoUIYIYwMtwEck7gr4/ovwXropG3B/OCSl1IrQtYZqxCAOkkROZE280XvuDAb
         k/GlWrvczX7LdqNTCjCxmFWhORgNmWkyXEF7v0Sl3qo1u7VDOSZKCqULBiBc3sCgAapl
         O9vli7ldImaXul+xNKO6Kj7VrM/9+GHFFepEzk04lvxJRRmId7G5Fgzx6knZut7dvAMY
         ScAw==
X-Gm-Message-State: APjAAAWl8reZ9x609t3zmPwtlMnFmVWJYrwNTz0xyaZWvy5ee8+U04j7
	feNg/8QbR/sK2endCepI+aUNNw==
X-Google-Smtp-Source: APXvYqyrzAX5xec1X60ADY+BupOXCKep6Mooa/4CsD65Phd1E2IrWJFtk1Zj0jRhyGRx6aBygBW3BQ==
X-Received: by 2002:a17:902:549:: with SMTP id 67mr96837111plf.86.1564158665090;
        Fri, 26 Jul 2019 09:31:05 -0700 (PDT)
Date: Fri, 26 Jul 2019 09:31:03 -0700
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Yann Droneaud <ydroneaud@opteya.com>,
	David Laight <David.Laight@aculab.com>,
	Jonathan Corbet <corbet@lwn.net>, Stephen Kitt <steve@sk2.org>,
	Nitin Gote <nitin.r.gote@intel.com>,
	"jannh@google.com" <jannh@google.com>,
	kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Subject: [PATCH] strscpy: reject buffer sizes larger than INT_MAX
Message-ID: <201907260928.23DE35406@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As already done for snprintf(), add a check in strscpy() for giant
(i.e. likely negative and/or miscalculated) copy sizes, WARN, and
error out.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/string.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/string.c b/lib/string.c
index 461fb620f85f..913cb945a82a 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -182,7 +182,7 @@ ssize_t strscpy(char *dest, const char *src, size_t count)
 	size_t max = count;
 	long res = 0;
 
-	if (count == 0)
+	if (count == 0 || WARN_ON_ONCE(count > INT_MAX))
 		return -E2BIG;
 
 #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-- 
2.17.1


-- 
Kees Cook
