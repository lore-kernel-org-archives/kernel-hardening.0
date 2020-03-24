Return-Path: <SRS0=GDqk=5J=lists.openwall.com=kernel-hardening-return-18198-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6138EC43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 20:33:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 88D5320735
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 20:33:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BcF5fu0w"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88D5320735
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18198-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18048 invoked by uid 550); 24 Mar 2020 20:32:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17835 invoked from network); 24 Mar 2020 20:32:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1MVGnSojuGRbIf385C9jQfbyEyUVxBYpFXB8EsCcrYw=;
        b=BcF5fu0w+3RjSRBoJOMuJwRkQ7K/mRa1BZHJeNserbqzlapS73yhJkI9BAFD3QlZia
         /tK6Q6a0Xix0108WsK916BMXctBv6x/nqlbYs0Fqc2Fl/c07lkSHe4EI2UglGuLZrWzk
         OsxF7OZPK7kzoWTSxKgurb1BP56sAT/bnrrp0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1MVGnSojuGRbIf385C9jQfbyEyUVxBYpFXB8EsCcrYw=;
        b=rBRz6xQsAYtVOMoy+YMmiTrrUAKv+BzkR6B6tvidDn0YdoMzjqnPLd9Z9SSOn8nvJt
         RLNMX0+I9T0mPlU8nm5k9IFS+3NpMBYCfMbuG9CsLX3RA0RDvSKDdsyHzOkPqEBXvMa2
         UtcUzEdqmWpPVw/ZwaKyIMHW9lafGvxV5kfG2Dr8Mcd1s/oYUoLNSRgTFgtk4nsrZIuH
         rprHlCNCzuttbwmMdI4sBmFyDdeLlkpmXxyZzsxouig952n4zcqltVLN5Q0QAcx45fmi
         0aEdHgBQ8E9vQxJHoseQ3tcwrBRe1U+IzKJEP71miufDcQif3Z/ui7sR5luvHjXic9v1
         +BoQ==
X-Gm-Message-State: ANhLgQ1i7pmYotT11cjMWObt93qhGT5Wd4A/xVZhWwl74EXqFPITGXNx
	3j5VNuEZJSwPLnVjWcQduOr2HQ==
X-Google-Smtp-Source: ADFU+vvnVRb00GhJN60Odz51h8y0qLnFMPgufkKkVflkAhmJwmU/2do8qdmBufOmVDll0iyTu12GSw==
X-Received: by 2002:a17:902:61:: with SMTP id 88mr28126394pla.313.1585081961408;
        Tue, 24 Mar 2020 13:32:41 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
	Elena Reshetova <elena.reshetova@intel.com>,
	x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	"Perla, Enrico" <enrico.perla@intel.com>,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] jump_label: Provide CONFIG-driven build state defaults
Date: Tue, 24 Mar 2020 13:32:27 -0700
Message-Id: <20200324203231.64324-2-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324203231.64324-1-keescook@chromium.org>
References: <20200324203231.64324-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Choosing the initial state of static branches changes the assembly
layout (if the condition is expected to be likely, inline, or unlikely,
out of line via a jump). A few places in the kernel use (or could be
using) a CONFIG to choose the default state, so provide the
infrastructure to do this and convert the existing cases (init_on_alloc
and init_on_free) to the new macros.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/jump_label.h | 19 +++++++++++++++++++
 include/linux/mm.h         | 12 ++----------
 mm/page_alloc.c            | 12 ++----------
 3 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 3526c0aee954..615fdfb871a3 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -382,6 +382,21 @@ struct static_key_false {
 		[0 ... (count) - 1] = STATIC_KEY_FALSE_INIT,	\
 	}
 
+#define _DEFINE_STATIC_KEY_1(name)	DEFINE_STATIC_KEY_TRUE(name)
+#define _DEFINE_STATIC_KEY_0(name)	DEFINE_STATIC_KEY_FALSE(name)
+#define DEFINE_STATIC_KEY_MAYBE(cfg, name)			\
+	__PASTE(_DEFINE_STATIC_KEY_, IS_ENABLED(cfg))(name)
+
+#define _DEFINE_STATIC_KEY_RO_1(name)	DEFINE_STATIC_KEY_TRUE_RO(name)
+#define _DEFINE_STATIC_KEY_RO_0(name)	DEFINE_STATIC_KEY_FALSE_RO(name)
+#define DEFINE_STATIC_KEY_MAYBE_RO(cfg, name)			\
+	__PASTE(_DEFINE_STATIC_KEY_RO_, IS_ENABLED(cfg))(name)
+
+#define _DECLARE_STATIC_KEY_1(name)	DECLARE_STATIC_KEY_TRUE(name)
+#define _DECLARE_STATIC_KEY_0(name)	DECLARE_STATIC_KEY_FALSE(name)
+#define DECLARE_STATIC_KEY_MAYBE(cfg, name)			\
+	__PASTE(_DECLARE_STATIC_KEY_, IS_ENABLED(cfg))(name)
+
 extern bool ____wrong_branch_error(void);
 
 #define static_key_enabled(x)							\
@@ -482,6 +497,10 @@ extern bool ____wrong_branch_error(void);
 
 #endif /* CONFIG_JUMP_LABEL */
 
+#define static_branch_maybe(config, x)					\
+	(IS_ENABLED(config) ? static_branch_likely(x)			\
+			    : static_branch_unlikely(x))
+
 /*
  * Advanced usage; refcount, branch is enabled when: count != 0
  */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index c54fb96cb1e6..059658604dd6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2662,11 +2662,7 @@ static inline void kernel_poison_pages(struct page *page, int numpages,
 					int enable) { }
 #endif
 
-#ifdef CONFIG_INIT_ON_ALLOC_DEFAULT_ON
-DECLARE_STATIC_KEY_TRUE(init_on_alloc);
-#else
-DECLARE_STATIC_KEY_FALSE(init_on_alloc);
-#endif
+DECLARE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, init_on_alloc);
 static inline bool want_init_on_alloc(gfp_t flags)
 {
 	if (static_branch_unlikely(&init_on_alloc) &&
@@ -2675,11 +2671,7 @@ static inline bool want_init_on_alloc(gfp_t flags)
 	return flags & __GFP_ZERO;
 }
 
-#ifdef CONFIG_INIT_ON_FREE_DEFAULT_ON
-DECLARE_STATIC_KEY_TRUE(init_on_free);
-#else
-DECLARE_STATIC_KEY_FALSE(init_on_free);
-#endif
+DECLARE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_FREE_DEFAULT_ON, init_on_free);
 static inline bool want_init_on_free(void)
 {
 	return static_branch_unlikely(&init_on_free) &&
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3c4eb750a199..1f625e5a03c0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -135,18 +135,10 @@ unsigned long totalcma_pages __read_mostly;
 
 int percpu_pagelist_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
-#ifdef CONFIG_INIT_ON_ALLOC_DEFAULT_ON
-DEFINE_STATIC_KEY_TRUE(init_on_alloc);
-#else
-DEFINE_STATIC_KEY_FALSE(init_on_alloc);
-#endif
+DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, init_on_alloc);
 EXPORT_SYMBOL(init_on_alloc);
 
-#ifdef CONFIG_INIT_ON_FREE_DEFAULT_ON
-DEFINE_STATIC_KEY_TRUE(init_on_free);
-#else
-DEFINE_STATIC_KEY_FALSE(init_on_free);
-#endif
+DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_FREE_DEFAULT_ON, init_on_free);
 EXPORT_SYMBOL(init_on_free);
 
 static int __init early_init_on_alloc(char *buf)
-- 
2.20.1

