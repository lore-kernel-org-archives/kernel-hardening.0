Return-Path: <SRS0=ylpS=I6=lists.openwall.com=kernel-hardening-return-21137-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2127C433B4
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 23:24:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 22D7361108
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 23:24:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22D7361108
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21137-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11676 invoked by uid 550); 1 Apr 2021 23:24:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11558 invoked from network); 1 Apr 2021 23:24:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9ijlYcKqhmRnIjh3GfaZu6VzSGgGwccaBk76YZfh88U=;
        b=WKcAnIleO2ypEZLKdHh37aVTO4tnIydkC5OCyMTVr+JpikHZ2/ZMU3FugvxEly10iU
         XSYN4IoCMfmYa9AiUhoVcjinurr136nmz9lf7q3gbfnnfDCOVEDSAGVTeituYbklhN9Y
         yq+0k7ScK7oeFnBPFOBIMf0UvJV0M6vj4GtgI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9ijlYcKqhmRnIjh3GfaZu6VzSGgGwccaBk76YZfh88U=;
        b=Qn43bfJtBQW4eqxwt/6zbB2Rchr/K0x4D7f4/FQG8hprDUSR0aE8hqZTll3vCNgxAh
         kAt+6oeUZ2UD73tMeCLq2tORwTwh8bzDiHwK3Nef7Xv+KkeVLZ1hu7qJ8Dt5eRDaO0vv
         oEI6beaxTo/a04TInqXO8WBvOEY73fBNAjiaFTISL3mrJkDcC32X2Ch79v0b3NTG3SGj
         Oil9DhGVyXI/okIugQ3M8HY7euQyjBe/w1daEsIyz7iM3Em+SfLkha4f91QsnfWcPOUx
         H96ajdEktHJThkYvM0TJPM8rEqRPBXJfGmQOGZP7pnwO6jJ1pFtCnHOxKcm16439Rb/q
         wCQg==
X-Gm-Message-State: AOAM533LuS51iJ4tEnojgqTeNpIRpJptaIEGzrlrb+bRkYSzR+oupJHS
	AaR7EXX2viuIYW/z0ZFru2fajw==
X-Google-Smtp-Source: ABdhPJwcYRMQryh7JJASN23+Q3HQF6uWuabr3WsRHjWCDIRpgK6DJhS0r2tl16IIlvy5t61K9IC1DA==
X-Received: by 2002:a62:7b83:0:b029:1f1:5ef3:b4d9 with SMTP id w125-20020a627b830000b02901f15ef3b4d9mr9608204pfc.65.1617319432493;
        Thu, 01 Apr 2021 16:23:52 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Elena Reshetova <elena.reshetova@intel.com>,
	x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Alexander Popov <alex.popov@linux.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 1/6] jump_label: Provide CONFIG-driven build state defaults
Date: Thu,  1 Apr 2021 16:23:42 -0700
Message-Id: <20210401232347.2791257-2-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210401232347.2791257-1-keescook@chromium.org>
References: <20210401232347.2791257-1-keescook@chromium.org>
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=aa54c44d1d71b9550d6015efc734f667917094a1; i=Vishx6UyAXwYzcnoSyP+eBB3iQyx+/i5smsbQfc0cnA=; m=vc4sSYlf+uaSlLSFP5TpbQv56VaSRpBLpRuMltXaB4Q=; p=mNH2Bo/K9vrGz9sBtTDV8UFO0eJ8yv8BbR/DeIaO1es=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmBmVgEACgkQiXL039xtwCbiEBAArOm /EtpeLQvJQ16Bi0gBHOl/CblUQyhrscVrs8xNm/lKfSaeaGIDJaNfx0EZ4L7n2IVkpGYSodLxZlwj ve4GueMybGaAPJWYFy3L+jAe9eYTp3zyYwvQsSRg55iW5msvqK3ZUeJqC/CxPrDdwT05noLV9mDub lAzrVY/pLiXE0HTK9ogAdyiNFQY2yA44UmGTIkmgZ30jl0d4aSVtwsViZeMS8pCrK22xkiccq/bRY 72ASLPxyOBOL00UWKeUmbmdUfNW+BkNlK7IaN+w5QBfiKuQWTf/WdZ+8c5tQWjLE3kJ4DRx8mrBcy 1vYJ1m1ZKfAOe8uV8waSURiUMzfgB/uL5on3W1e6s8SkChf0KGAZMyDGuIflDnvFUy8OIfM8Ak/fg hoYQ2dUXkKa50EdvadntVka+XmxokcSERzN0e9tOQlYfeLiL5TINkkDQFAallIMnHy6ImGd9Yd23F zSvCmvv0683j96kJXsEcfl0wH3LYYCyRS0fIK1ssPxPAViuN0vY1jlIeDn734NiR4+itDg8pTepIM h8ozYc9GPgYBTzXQPG29KmXRHc4es7o4enMoBQ1Gj0PZ5f9c0fr6AUpoe7c1jVtsL4wJD6tUuC9do T40yZwF6fDGX1jsVc/mbC1ug6gurwbG+Xo1xiQ2I1YUyr1MimqrfE4LvelISHwZM=
Content-Transfer-Encoding: 8bit

As shown in jump_label.h[1], choosing the initial state of static
branches changes the assembly layout. If the condition is expected to
be likely it's inline, and if unlikely it is out of line via a jump. A
few places in the kernel use (or could be using) a CONFIG to choose the
default state, which would give a small performance benefit to their
compile-time declared default. Provide the infrastructure to do this.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/jump_label.h?h=v5.11#n398

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/lkml/20200324220641.GT2452@worktop.programming.kicks-ass.net/
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/jump_label.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index d92691262f51..05f5554d860f 100644
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
-- 
2.25.1

