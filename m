Return-Path: <SRS0=vB8j=IH=lists.openwall.com=kernel-hardening-return-20891-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48BBDC433DB
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Mar 2021 21:43:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6F53B64F59
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Mar 2021 21:43:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F53B64F59
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20891-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15669 invoked by uid 550); 9 Mar 2021 21:43:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15625 invoked from network); 9 Mar 2021 21:43:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QchGfDa9Ang9HjVlU1RQNYIjoI3tEPOfhu9LIBI5D+M=;
        b=AAchEITQdw6OW0zYEsb+JMW1vwYgaTwlwzk7fiKypJWjhEQgoK92EG8oQj/4Tq88SF
         zwG5DspDifkgXW3HuJUgs4F3dISckAhmF8SPrLQMssyCJX95lcs5zaG5CrPPPGeb+HSO
         dWyEMq2T8jbT0sDAA79Mlwjm4ookDIWPgIkLI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QchGfDa9Ang9HjVlU1RQNYIjoI3tEPOfhu9LIBI5D+M=;
        b=AVD2wU6hOeGDYS5rpxuuMVCt7su3KR95yb+mh27EumagEYLncExwqGHgV7dPudRI88
         ygs4oL/nG8jiyAilHxQiNJS1vMZ/X4w14oRTjVGnDLHeHrV2Vm77tL0xQcK4c/5h6EJX
         ScVoJbi4hvw/7hEJNDm2dO0dRyC1/C2SD+znYRiUqC6t1JxO1WzuYS5hkWXzVw0p5l/T
         8/EIv1k0t8RLwQN2Yb5MzUmOg/kiCqwqFIhtzKUuUlrfmicXGHcu4WRWAorNYnts43JF
         ktWqOXA7zeRJtK9ibwU5JBRjxKmqrtU9O9tTwYwcYuxfRaa6eUn/LXiD+7AgHA2BeCIg
         Sy8Q==
X-Gm-Message-State: AOAM533IlVyNbGYkZzR/Gnb5HnwbfVPprAI+rVYeDO2dKsH3pzbykWLA
	qnldhbokCU7jfLoAAOReE0NMJA==
X-Google-Smtp-Source: ABdhPJzcdsp6YYQ3RJHVjDIyR4wddA7Ee7emO+fBuKmY/97M5tY6wZi5jJxb+krjkrH7lCrJYsY4vg==
X-Received: by 2002:a63:4241:: with SMTP id p62mr26586949pga.453.1615326189986;
        Tue, 09 Mar 2021 13:43:09 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
	Alexander Potapenko <glider@google.com>,
	Elena Reshetova <elena.reshetova@intel.com>,
	x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Popov <alex.popov@linux.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v5 3/7] init_on_alloc: Unpessimize default-on builds
Date: Tue,  9 Mar 2021 13:42:57 -0800
Message-Id: <20210309214301.678739-4-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210309214301.678739-1-keescook@chromium.org>
References: <20210309214301.678739-1-keescook@chromium.org>
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=0180538bd89f892d9a7cb5912f57764dd4574e64; i=FGm2eJrFhO36W3pokRKQXJ/1lCJEdw+Xji0AZWdKldw=; m=vArMoxGjWi+hJ/sQRlVkEVurD6o0k4s1dF+QIrjNXSc=; p=UIEnT5JyleN0fGLkjBMkQSBdyQITBdVfP87yTFfx7Kg=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmBH6+QACgkQiXL039xtwCZhGQ//cU9 87sq54cQfs8uAKxVAHV77yHdW6J6AftBwhrqAq+1M0C1IoOLVi+Uvz1cWTM7C6G672FEhYPM8aZvd 31/s3taFnCDyvmBhh9HUBBsYUk7Hhwi+V7r5EvVHAxBw1jyUByiPVHV6FWRcSDFOZHv9iKXNEFC7O iKSWVZ4V6X0u98fHeVq2MA3000qbRbBtef8DMgWd5rq3d+1IJQKEWRi/ws2e3bW82oHj1a7+KPOv4 X1J5M9A/OStaOcbwJ76LyVjtjizbvJMYsUDfIwUkH2Ouj84CYuWxK5AflU8Wf8690EOKQ6XGAvCXA 2tcD81q96YPjYRgGy1QoC4cqyGHQf52FCkGDjrZd4LIHJjPLxc8C7OAemJ8ofvZNIZDwRF9u07y4D qUKVUYEjWSwsP03gVJB7kc6gYALIB5AX3qNNQkMAGKgiyrLXML5eBay0b9+G6DrlXQO2uEwQ6ocni JoXsEVBoz0zZRetbT2/TXK6Nqk9DV4p8bkO7R26Ut6wAEn8jZSHgyBk3GrJg+6d1pOzsj761vvjya NK/0w2VQYOsrjdciOEQR/Xd2ZGCaFPfQY41b5nEjmBC+YS8l0GSHFqG1ce4mPDlQeuNmYOgu8+k/B 1hTaHBXrEPHJbO69gYEpIn/T7M1Tb4pYIlHnvmvDlMkPoUrznzLJonVQIk5rqeX8=
Content-Transfer-Encoding: 8bit

Right now, the state of CONFIG_INIT_ON_ALLOC_DEFAULT_ON (and
...ON_FREE...) did not change the assembly ordering of the static branch
tests. Use the new jump_label macro to check CONFIG settings to default
to the "expected" state, unpessimizes the resulting assembly code.

Reviewed-by: Alexander Potapenko <glider@google.com>
Link: https://lore.kernel.org/lkml/CAG_fn=X0DVwqLaHJTO6Jw7TGcMSm77GKHinrd0m_6y0SzWOrFA@mail.gmail.com/
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/mm.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index bf341a9bfe46..2ccd856ac0d1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2874,7 +2874,8 @@ static inline void kernel_unpoison_pages(struct page *page, int numpages) { }
 DECLARE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, init_on_alloc);
 static inline bool want_init_on_alloc(gfp_t flags)
 {
-	if (static_branch_unlikely(&init_on_alloc))
+	if (static_branch_maybe(CONFIG_INIT_ON_ALLOC_DEFAULT_ON,
+				&init_on_alloc))
 		return true;
 	return flags & __GFP_ZERO;
 }
@@ -2882,7 +2883,8 @@ static inline bool want_init_on_alloc(gfp_t flags)
 DECLARE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_FREE_DEFAULT_ON, init_on_free);
 static inline bool want_init_on_free(void)
 {
-	return static_branch_unlikely(&init_on_free);
+	return static_branch_maybe(CONFIG_INIT_ON_FREE_DEFAULT_ON,
+				   &init_on_free);
 }
 
 extern bool _debug_pagealloc_enabled_early;
-- 
2.25.1

