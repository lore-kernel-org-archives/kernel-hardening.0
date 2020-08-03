Return-Path: <SRS0=4qzO=BN=lists.openwall.com=kernel-hardening-return-19543-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F1AC433DF
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Aug 2020 18:29:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E5A19207DF
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Aug 2020 18:29:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="DjzvW0b8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5A19207DF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19543-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15377 invoked by uid 550); 3 Aug 2020 18:29:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14333 invoked from network); 3 Aug 2020 18:29:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=Jp+RUdqxn2bqBAJrnl3/EtyTRS168jjNSIe2CptEcmg=;
        b=DjzvW0b8CiSYl0WsHAxDm6vYeLjke22BrUVzGogsnNj1LZjAWNzxHJFpLFhoulfDgl
         Ni25KCT3eSrzC04fZ61g1Ay9PNx3FccY2qTnpZuQL5hc32pGb4N09mVekuDj9MnPA96w
         dYFvfR/u1sUYaqOjbobYBDeStPIf+ee3utRyM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Jp+RUdqxn2bqBAJrnl3/EtyTRS168jjNSIe2CptEcmg=;
        b=H76cEP5pQAuOzR4qPXHDhVzbeNsnMgPACthgASPbgWOocFFcds5qjk8sjAMhkqF1Le
         hl9AszBJ4MikiJjeOjbhwCAgpeTwxkgNZ9irllf1tz7n60biy6n7GT6rv62jV8tDmVOe
         di7e1UWgj7PTEdRBPm3DtO60Rxdim/3JgV77jxMwgcFiTkKUSvsyN9y0Vs6eFo9UJ7ZR
         2ML+U6j+8Od/JuSUWKmhpuv3g32zN6vwW5fgtTUP6Educ+445yNU8BFaRKnsulFCIlZo
         sFlz0Y+0QL6uQVaOhD0jXvO+Ys+4OXzAa5RNe0zS3fy8MiBFpHWEtItKJwZHnB45Bd/E
         GDwQ==
X-Gm-Message-State: AOAM533FUQAEn66sHkI+2o9z4O6z2+NanIf5cFVUcv0apCXPNQkf7py7
	ZJmC2xz7GrLkBZXqxNUnU3eIpw==
X-Google-Smtp-Source: ABdhPJw6+KwHqP+X6kkB/Nh+5MoJPmoZuMVKaA4zdRO65/hv0t1RhuJZhxmS17f5eIeBraxJKlocrQ==
X-Received: by 2002:a17:902:a9c8:: with SMTP id b8mr16117240plr.2.1596479380570;
        Mon, 03 Aug 2020 11:29:40 -0700 (PDT)
Date: Mon, 3 Aug 2020 11:29:38 -0700
From: Kees Cook <keescook@chromium.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [RFC] saturate check_*_overflow() output?
Message-ID: <202008031118.36756FAD04@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I wonder if we should explicitly saturate the output of the overflow
helpers as a side-effect of overflow detection? (That way the output
is never available with a "bad" value, if the caller fails to check the
result or forgets that *d was written...) since right now, *d will hold
the wrapped value.

Also, if we enable arithmetic overflow detection sanitizers, we're going
to trip over the fallback implementation (since it'll wrap and then do
the overflow test in the macro).

e.g. I'm think of something like this (showing only "mul" here, and
untested):

diff --git a/include/linux/overflow.h b/include/linux/overflow.h
index 93fcef105061..00baf3a75dc7 100644
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -71,12 +71,16 @@
 })
 
 #define check_mul_overflow(a, b, d) ({		\
+	bool __result;				\
 	typeof(a) __a = (a);			\
 	typeof(b) __b = (b);			\
 	typeof(d) __d = (d);			\
 	(void) (&__a == &__b);			\
 	(void) (&__a == __d);			\
-	__builtin_mul_overflow(__a, __b, __d);	\
+	__result = __builtin_mul_overflow(__a, __b, __d);\
+	if (unlikely(__result))			\
+		*__d = type_max(__a);		\
+	__result;				\
 })
 
 #else
@@ -105,15 +109,20 @@
  * If one of a or b is a compile-time constant, this avoids a division.
  */
 #define __unsigned_mul_overflow(a, b, d) ({		\
+	bool __result;					\
 	typeof(a) __a = (a);				\
 	typeof(b) __b = (b);				\
 	typeof(d) __d = (d);				\
 	(void) (&__a == &__b);				\
 	(void) (&__a == __d);				\
-	*__d = __a * __b;				\
-	__builtin_constant_p(__b) ?			\
+	__result = __builtin_constant_p(__b) ?		\
 	  __b > 0 && __a > type_max(typeof(__a)) / __b : \
 	  __a > 0 && __b > type_max(typeof(__b)) / __a;	 \
+	if (unlikely(__result))				\
+		*__d = type_max(typeof(__a));		\
+	else						\
+		*__d = __a * __b;			\
+	__result;
 })
 
 /*
@@ -176,6 +185,7 @@
  */
 
 #define __signed_mul_overflow(a, b, d) ({				\
+	bool __result;							\
 	typeof(a) __a = (a);						\
 	typeof(b) __b = (b);						\
 	typeof(d) __d = (d);						\
@@ -183,10 +193,14 @@
 	typeof(a) __tmin = type_min(typeof(a));				\
 	(void) (&__a == &__b);						\
 	(void) (&__a == __d);						\
-	*__d = (u64)__a * (u64)__b;					\
-	(__b > 0   && (__a > __tmax/__b || __a < __tmin/__b)) ||	\
-	(__b < (typeof(__b))-1  && (__a > __tmin/__b || __a < __tmax/__b)) || \
-	(__b == (typeof(__b))-1 && __a == __tmin);			\
+	__result = (__b > 0   && (__a > __tmax/__b || __a < __tmin/__b)) || \
+		   (__b < (typeof(__b))-1  && (__a > __tmin/__b || __a < __tmax/__b)) || \
+		   (__b == (typeof(__b))-1 && __a == __tmin);		\
+	if (unlikely(__result))						\
+		*__d = type_max(__a);					\
+	else								\
+		*__d = (u64)__a * (u64)__b;				\
+	__result;							\
 })
 
 

Thoughts?

-- 
Kees Cook
