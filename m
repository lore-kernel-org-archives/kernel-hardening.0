Return-Path: <SRS0=I5nF=BW=lists.openwall.com=kernel-hardening-return-19613-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 570B9C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Aug 2020 21:52:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9083C20774
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Aug 2020 21:52:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="JuuCrSJH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9083C20774
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19613-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9690 invoked by uid 550); 12 Aug 2020 21:52:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9667 invoked from network); 12 Aug 2020 21:52:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=V87j311e4SaSage1A0MUzbfGo+GdO8JYJCvpjXUYsdU=;
        b=JuuCrSJHL05yDhCIgMWwssihbT/0FU6HagnQ/Wc0qs8cW6L58XlfMSxbmLCUUtjU1v
         e/jNDvxxuRg4YcxyWBm75ZSjMCMDVFTLy3WCkDteVC8Aw4gPTCv1vjasMtQDtl1ANk+L
         m5KNdxdg0YrAP6Rd4Y24h25/3aYpE1yLmAboo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=V87j311e4SaSage1A0MUzbfGo+GdO8JYJCvpjXUYsdU=;
        b=Uc/2kZj63FauViMVd/5iSB8DO595axQ+sHuaADOGz9aK8JMovZOEZv7Hry5Xas1tWS
         mM7BGfFaSV6ro6ZXUv++eovzCmIZXMr4V4f8PbJ3lLUlRMeEzYdVk2HgMDsqjLa1nsB+
         GZ/UZUPSN3fSN4aPt7lbbhDUXwUkekOuSUc1/Olk/6kvbi+Bgh1IcHpKuwQrxFuw+oJT
         szw+tv0JVvnlnvclj5GgP6G7Y7EvK1uiKlXbJMtT7PxAl8h3HEULY1olPtLV8YmFWO1E
         EDbvp7xeJhzSnGF3dZkRTYAqf52QZdX+3ieL3DVKg9WDk0tKIULMZmpSsSHjkHe3qDon
         +oXQ==
X-Gm-Message-State: AOAM532QJHkGM8vP+EJtrxE+gqRN2NfCC3a/EEfX3t5TJFnV0R62Qjtg
	PNBL5zlWlwTt5GtalE6fDv2Eug==
X-Google-Smtp-Source: ABdhPJyiDFbmD/3ui8ViAYloP9167Bsd8mPA+tiO4XJENWoDt8gRZlflrI+O2XqLK4gRQNiqHiUtkw==
X-Received: by 2002:a65:6287:: with SMTP id f7mr1039468pgv.307.1597269114622;
        Wed, 12 Aug 2020 14:51:54 -0700 (PDT)
Date: Wed, 12 Aug 2020 14:51:52 -0700
From: Kees Cook <keescook@chromium.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH] overflow: Add __must_check attribute to check_*() helpers
Message-ID: <202008121450.405E4A3@keescook>
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
 include/linux/overflow.h | 51 +++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/include/linux/overflow.h b/include/linux/overflow.h
index 93fcef105061..ef7d538c2d08 100644
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -43,6 +43,16 @@
 #define is_non_negative(a) ((a) > 0 || (a) == 0)
 #define is_negative(a) (!(is_non_negative(a)))
 
+/*
+ * Allows to effectively us apply __must_check to a macro so we can have
+ * both the type-agnostic benefits of the macros while also being able to
+ * enforce that the return value is, in fact, checked.
+ */
+static inline bool __must_check __must_check_bool(bool condition)
+{
+	return unlikely(condition);
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
+#define check_add_overflow(a, b, d) __must_check_bool(({	\
 	typeof(a) __a = (a);			\
 	typeof(b) __b = (b);			\
 	typeof(d) __d = (d);			\
 	(void) (&__a == &__b);			\
 	(void) (&__a == __d);			\
 	__builtin_add_overflow(__a, __b, __d);	\
-})
+}))
 
-#define check_sub_overflow(a, b, d) ({		\
+#define check_sub_overflow(a, b, d) __must_check_bool(({	\
 	typeof(a) __a = (a);			\
 	typeof(b) __b = (b);			\
 	typeof(d) __d = (d);			\
 	(void) (&__a == &__b);			\
 	(void) (&__a == __d);			\
 	__builtin_sub_overflow(__a, __b, __d);	\
-})
+}))
 
-#define check_mul_overflow(a, b, d) ({		\
+#define check_mul_overflow(a, b, d) __must_check_bool(({	\
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
-	__builtin_choose_expr(is_signed_type(typeof(a)),		\
-			__signed_add_overflow(a, b, d),			\
-			__unsigned_add_overflow(a, b, d))
+#define check_add_overflow(a, b, d)					   \
+	__must_check_bool(__builtin_choose_expr(is_signed_type(typeof(a)), \
+				__signed_add_overflow(a, b, d),		   \
+				__unsigned_add_overflow(a, b, d)))
 
-#define check_sub_overflow(a, b, d)					\
-	__builtin_choose_expr(is_signed_type(typeof(a)),		\
-			__signed_sub_overflow(a, b, d),			\
-			__unsigned_sub_overflow(a, b, d))
-
-#define check_mul_overflow(a, b, d)					\
-	__builtin_choose_expr(is_signed_type(typeof(a)),		\
-			__signed_mul_overflow(a, b, d),			\
-			__unsigned_mul_overflow(a, b, d))
+#define check_sub_overflow(a, b, d)					   \
+	__must_check_bool(__builtin_choose_expr(is_signed_type(typeof(a)), \
+				__signed_sub_overflow(a, b, d),		   \
+				__unsigned_sub_overflow(a, b, d)))
 
+#define check_mul_overflow(a, b, d)					   \
+	__must_check_bool(__builtin_choose_expr(is_signed_type(typeof(a)), \
+				__signed_mul_overflow(a, b, d),		   \
+				__unsigned_mul_overflow(a, b, d)))
 
 #endif /* COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW */
 
@@ -227,7 +236,7 @@
  * '*d' will hold the results of the attempted shift, but is not
  * considered "safe for use" if false is returned.
  */
-#define check_shl_overflow(a, s, d) ({					\
+#define check_shl_overflow(a, s, d) __must_check_bool(({		\
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
