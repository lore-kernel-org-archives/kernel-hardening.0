Return-Path: <SRS0=f0Tt=BZ=lists.openwall.com=kernel-hardening-return-19635-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E3EBC433DF
	for <kernel-hardening@archiver.kernel.org>; Sat, 15 Aug 2020 17:09:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8C55D23B30
	for <kernel-hardening@archiver.kernel.org>; Sat, 15 Aug 2020 17:09:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CI1KLRx+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C55D23B30
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19635-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20073 invoked by uid 550); 15 Aug 2020 17:09:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20047 invoked from network); 15 Aug 2020 17:09:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=soE2IFby27f3lT1vJqM47DLs36Y61YrsYS5+tpHeZ7Q=;
        b=CI1KLRx+27luHuKs2XaeFptA0WMQW5Fz18CFhEPtVnkbVKV5k7fBMYmRMvP9FuTb7i
         POd83LEdDrPoRKUNpQJZiUqmb1YMxIu3WAyCVpW3k18G+SD1Q3iGNo/NWnt2drExn+vL
         j+P0BkgpDOAq7PVGoXtJGBjyX9cFgRCgT2DA0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=soE2IFby27f3lT1vJqM47DLs36Y61YrsYS5+tpHeZ7Q=;
        b=mVWJfGJl+sep6RuKE7ZHXBQ+g/dMzkQ6Eh7SiMNFO/gga4pHMYIKZaDbOsrscSkbj6
         /ibiFPAN4RdtcO9wF05urkg75D8482CPjz2FOTmi6YUSi+ouHtSh67RpdGJpTJTHyyDi
         Lu3hNbKTJgkRujP3aFNQZ5KgtrlyQF2jRlY/vfXRx04SUOgxJWiOrOD6UR5Nr5tYcvsM
         UQg6tGCp0Rs6OBCniAeyDMEv3NYgJWrAWSkOUvzD83zK45gZU26sq4yCSgEsey4lq3/9
         awMDbNW0E2hHt1DQf/rTWApy3RxkLdLLvFpAlxQtjmgzIsAIpl8mVlDSZ8Em6777HzY7
         sGBQ==
X-Gm-Message-State: AOAM533YnFoGygy7vf5gah1vwhMsMqzwDrPN55UK7UOyzAm65/CU00+r
	gUGWEqMp5xHenflsgwdkgSg1rw==
X-Google-Smtp-Source: ABdhPJw++rQdsQjQ+F1CYSDJTNwjmrCJstNOaRhqVrb+4iAk5WeYCFnuaK3T5187FLXs3/JeJ8ejCw==
X-Received: by 2002:a17:902:9a06:: with SMTP id v6mr6020983plp.57.1597511366548;
        Sat, 15 Aug 2020 10:09:26 -0700 (PDT)
Date: Sat, 15 Aug 2020 10:09:24 -0700
From: Kees Cook <keescook@chromium.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v2] overflow: Add __must_check attribute to check_*() helpers
Message-ID: <202008151007.EF679DF@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Since the destination variable of the check_*_overflow() helpers will
contain a wrapped value on failure, it would be best to make sure callers
really did check the return result of the helper. Adjust the macros to use
a bool-wrapping static inline that is marked with __must_check. This means
the macros can continue to have their type-agnostic behavior while gaining
the function attribute (that cannot be applied directly to macros).

Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2:
- de-generalized __must_check_overflow() from being named "bool" (willy)
- fix comment typos (rasmus)
v1: https://lore.kernel.org/lkml/202008121450.405E4A3@keescook
---
 include/linux/overflow.h | 39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/include/linux/overflow.h b/include/linux/overflow.h
index 93fcef105061..f1c4e7b56bd9 100644
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -43,6 +43,16 @@
 #define is_non_negative(a) ((a) > 0 || (a) == 0)
 #define is_negative(a) (!(is_non_negative(a)))
 
+/*
+ * Allows for effectively applying __must_check to a macro so we can have
+ * both the type-agnostic benefits of the macros while also being able to
+ * enforce that the return value is, in fact, checked.
+ */
+static inline bool __must_check __must_check_overflow(bool overflow)
+{
+	return unlikely(overflow);
+}
+
 #ifdef COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW
 /*
  * For simplicity and code hygiene, the fallback code below insists on
@@ -52,32 +62,32 @@
  * alias for __builtin_add_overflow, but add type checks similar to
  * below.
  */
-#define check_add_overflow(a, b, d) ({		\
+#define check_add_overflow(a, b, d) __must_check_overflow(({	\
 	typeof(a) __a = (a);			\
 	typeof(b) __b = (b);			\
 	typeof(d) __d = (d);			\
 	(void) (&__a == &__b);			\
 	(void) (&__a == __d);			\
 	__builtin_add_overflow(__a, __b, __d);	\
-})
+}))
 
-#define check_sub_overflow(a, b, d) ({		\
+#define check_sub_overflow(a, b, d) __must_check_overflow(({	\
 	typeof(a) __a = (a);			\
 	typeof(b) __b = (b);			\
 	typeof(d) __d = (d);			\
 	(void) (&__a == &__b);			\
 	(void) (&__a == __d);			\
 	__builtin_sub_overflow(__a, __b, __d);	\
-})
+}))
 
-#define check_mul_overflow(a, b, d) ({		\
+#define check_mul_overflow(a, b, d) __must_check_overflow(({	\
 	typeof(a) __a = (a);			\
 	typeof(b) __b = (b);			\
 	typeof(d) __d = (d);			\
 	(void) (&__a == &__b);			\
 	(void) (&__a == __d);			\
 	__builtin_mul_overflow(__a, __b, __d);	\
-})
+}))
 
 #else
 
@@ -190,21 +200,20 @@
 })
 
 
-#define check_add_overflow(a, b, d)					\
+#define check_add_overflow(a, b, d)	__must_check_overflow(		\
 	__builtin_choose_expr(is_signed_type(typeof(a)),		\
 			__signed_add_overflow(a, b, d),			\
-			__unsigned_add_overflow(a, b, d))
+			__unsigned_add_overflow(a, b, d)))
 
-#define check_sub_overflow(a, b, d)					\
+#define check_sub_overflow(a, b, d)	__must_check_overflow(		\
 	__builtin_choose_expr(is_signed_type(typeof(a)),		\
 			__signed_sub_overflow(a, b, d),			\
-			__unsigned_sub_overflow(a, b, d))
+			__unsigned_sub_overflow(a, b, d)))
 
-#define check_mul_overflow(a, b, d)					\
+#define check_mul_overflow(a, b, d)	__must_check_overflow(		\
 	__builtin_choose_expr(is_signed_type(typeof(a)),		\
 			__signed_mul_overflow(a, b, d),			\
-			__unsigned_mul_overflow(a, b, d))
-
+			__unsigned_mul_overflow(a, b, d)))
 
 #endif /* COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW */
 
@@ -227,7 +236,7 @@
  * '*d' will hold the results of the attempted shift, but is not
  * considered "safe for use" if false is returned.
  */
-#define check_shl_overflow(a, s, d) ({					\
+#define check_shl_overflow(a, s, d) __must_check_overflow(({		\
 	typeof(a) _a = a;						\
 	typeof(s) _s = s;						\
 	typeof(d) _d = d;						\
@@ -237,7 +246,7 @@
 	*_d = (_a_full << _to_shift);					\
 	(_to_shift != _s || is_negative(*_d) || is_negative(_a) ||	\
 	(*_d >> _to_shift) != _a);					\
-})
+}))
 
 /**
  * array_size() - Calculate size of 2-dimensional array.
-- 
2.25.1


-- 
Kees Cook
