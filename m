Return-Path: <SRS0=EkR7=5W=lists.openwall.com=kernel-hardening-return-18446-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B7E0C2BA1A
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Apr 2020 23:16:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8B531206C0
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Apr 2020 23:16:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="DETEeYLU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B531206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18446-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23945 invoked by uid 550); 6 Apr 2020 23:16:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23912 invoked from network); 6 Apr 2020 23:16:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jjDe4Hi7TtVO/wKC4Ixr8yGihHqa400mWL0wehOCRBk=;
        b=DETEeYLUPrHDWmX+mgf3XfkHhQ8bXZ4JQ20xi9rnXY3vkREikPg39QMkW+FwOTZOB6
         ad3hnyhmQW1o2fY8ksqfVaf3PHYZJN+QwgTMVfcpg7yFW8qoLnAx5xje3nNlmfgKQLKi
         xbiidiGJHcDcOJhrAq91ofcxuchLHrHgbpU+M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jjDe4Hi7TtVO/wKC4Ixr8yGihHqa400mWL0wehOCRBk=;
        b=s/kRgkWk3L1EKAr22F0Q0fuz1EYigwtddSNcBQU+YeO6VvE0xqTsowGjrNhcB4smUN
         FXurSaltckK/n0PE+sPAjPPp2NNicUGPgXy0C4NoGKTbWONwGY7kDIr5XrA5xjqwuwvO
         u6Dy1TK8PzKVRUOzup8sxu+WSZtKzzw/hualADchZRRehVOmbVz6+JKx7iyjWJvGefNa
         tGgOt423EE/8D5VBjxZXsu/9Et6jyfuMBu5V1EuBmu1dAS+Tt6mOEeiLX+Lt0qKOpwpl
         0mRDku1s9N1gHczw4kchvgUwa++TVRXGQ6yUsQEfggiyoCGSqmoMEYOoOxQ1FWx6PbqS
         2wyg==
X-Gm-Message-State: AGi0Pua9CQgMm3j/pQfBBvP0AuJ/COXshPkvxszC1+msFJ1SJqlKSxIK
	qCyEvlqvZtshqp/gTSRZn4w5DA==
X-Google-Smtp-Source: APiQypJOAJUD5o/cOCh1/7iAsdO0knHWBcNha6PAtRGiz4cvm/tS0aBBSt7jxUfJb4cvKE69NcjkTA==
X-Received: by 2002:a63:7b5e:: with SMTP id k30mr1393245pgn.209.1586214971506;
        Mon, 06 Apr 2020 16:16:11 -0700 (PDT)
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
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/5] init_on_alloc: Unpessimize default-on builds
Date: Mon,  6 Apr 2020 16:16:03 -0700
Message-Id: <20200406231606.37619-3-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200406231606.37619-1-keescook@chromium.org>
References: <20200406231606.37619-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Right now, the state of CONFIG_INIT_ON_ALLOC_DEFAULT_ON (and
...ON_FREE...) did not change the assembly ordering of the static branch
tests. Use the new jump_label macro to check CONFIG settings to default
to the "expected" state, unpessimizes the resulting assembly code.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Alexander Potapenko <glider@google.com>
---
 include/linux/mm.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 059658604dd6..64e911159ffa 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2665,7 +2665,8 @@ static inline void kernel_poison_pages(struct page *page, int numpages,
 DECLARE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, init_on_alloc);
 static inline bool want_init_on_alloc(gfp_t flags)
 {
-	if (static_branch_unlikely(&init_on_alloc) &&
+	if (static_branch_maybe(CONFIG_INIT_ON_ALLOC_DEFAULT_ON,
+				&init_on_alloc) &&
 	    !page_poisoning_enabled())
 		return true;
 	return flags & __GFP_ZERO;
@@ -2674,7 +2675,8 @@ static inline bool want_init_on_alloc(gfp_t flags)
 DECLARE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_FREE_DEFAULT_ON, init_on_free);
 static inline bool want_init_on_free(void)
 {
-	return static_branch_unlikely(&init_on_free) &&
+	return static_branch_maybe(CONFIG_INIT_ON_FREE_DEFAULT_ON,
+				   &init_on_free) &&
 	       !page_poisoning_enabled();
 }
 
-- 
2.20.1

