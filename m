Return-Path: <SRS0=xHlS=AD=lists.openwall.com=kernel-hardening-return-19035-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B31C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 19:32:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E1EAC20776
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 19:32:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jQvwT91a"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1EAC20776
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19035-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19657 invoked by uid 550); 22 Jun 2020 19:32:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19561 invoked from network); 22 Jun 2020 19:32:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bd9f3BBqo3zGwwTfmvjboaNS4RxuJ7DCwqiU44HfZsQ=;
        b=jQvwT91aNdu6DbbTFmcHtowv1QDuWeDxsDk/RqKsPvwbGbHTpYzrDrmmY/0dq+aBJQ
         jlwYwDhLmthT175NDbEj6C17KQJgc9BEyT+EwcD3Md/NbUgFJ+PR+YCJt9RkY1QSZdRZ
         QY9d67wu3uA3m5bOy/gHJd8An71KIaVS3oaeE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bd9f3BBqo3zGwwTfmvjboaNS4RxuJ7DCwqiU44HfZsQ=;
        b=Z5zPUgWSOEREUEam7bsyeCS5D65qUrXSJZT8PLWNybn207H6itvYDPH61BJ2Hbp3VT
         d658FbkRa/r61O70H3JWrnOJ2LYi7gYkOzKkZj/gWDFEoTxFBGLhqJSkraDIYVNCJREA
         HQafKF5jFMUnTE9dY9ZKN+z/PKSbC190CjHDZ0nyDSqTo5PsMMHAmjiopOfb735iuWPh
         oEpJanR5mtiFSt4P2abGYIOnUBCh0DeUmTU0j75Nnl8tjdszuxAW9zshA2Ff4kne5bNp
         n/wDCo9Dsu0TmFMQt7/dBAvDLc6Sn7dC2PCZBB8R1NNDg5BWx8vu1jsdxWfV1lthR5Um
         E72Q==
X-Gm-Message-State: AOAM532vnjUrsngcdkR2GkhXfIa5x/sM6yUyMuFigss+R/Rv0XcQRR6Z
	HxPgCT4bg+8FU1GSDPJ0N6PlQg==
X-Google-Smtp-Source: ABdhPJy/XsCwbSTQ8GDNdy6eIPIN39i7/vLM9SHQLKSs+iIR061Tg/mVW3fZLxYeE/B4wCdXiH9v5A==
X-Received: by 2002:a62:1d0b:: with SMTP id d11mr15185345pfd.1.1592854312494;
        Mon, 22 Jun 2020 12:31:52 -0700 (PDT)
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
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/5] init_on_alloc: Unpessimize default-on builds
Date: Mon, 22 Jun 2020 12:31:43 -0700
Message-Id: <20200622193146.2985288-3-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200622193146.2985288-1-keescook@chromium.org>
References: <20200622193146.2985288-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Right now, the state of CONFIG_INIT_ON_ALLOC_DEFAULT_ON (and
...ON_FREE...) did not change the assembly ordering of the static branch
tests. Use the new jump_label macro to check CONFIG settings to default
to the "expected" state, unpessimizes the resulting assembly code.

Reviewed-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/mm.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0e6824fd4458..0a05b20870c2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2892,7 +2892,8 @@ static inline void kernel_poison_pages(struct page *page, int numpages,
 DECLARE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, init_on_alloc);
 static inline bool want_init_on_alloc(gfp_t flags)
 {
-	if (static_branch_unlikely(&init_on_alloc) &&
+	if (static_branch_maybe(CONFIG_INIT_ON_ALLOC_DEFAULT_ON,
+				&init_on_alloc) &&
 	    !page_poisoning_enabled())
 		return true;
 	return flags & __GFP_ZERO;
@@ -2901,7 +2902,8 @@ static inline bool want_init_on_alloc(gfp_t flags)
 DECLARE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_FREE_DEFAULT_ON, init_on_free);
 static inline bool want_init_on_free(void)
 {
-	return static_branch_unlikely(&init_on_free) &&
+	return static_branch_maybe(CONFIG_INIT_ON_FREE_DEFAULT_ON,
+				   &init_on_free) &&
 	       !page_poisoning_enabled();
 }
 
-- 
2.25.1

