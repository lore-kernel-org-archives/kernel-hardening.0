Return-Path: <SRS0=1n6d=Z3=lists.openwall.com=kernel-hardening-return-17466-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70A5EC43603
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Dec 2019 00:12:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C0CFD206DF
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Dec 2019 00:12:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="TOFLyf0y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0CFD206DF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17466-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30049 invoked by uid 550); 5 Dec 2019 00:10:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29910 invoked from network); 5 Dec 2019 00:10:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+buIVC/1VPKvECsxMqNDPQ+i8AJPTJg9/lSk6De449o=;
        b=TOFLyf0yU9XQEB/FeqiNbT3V7qcPRtpa6NeVrNIlQWiqVak0lOBZUpf1Yvd6G9OnJs
         zZoCQoQD7O7Nl7/81xFWrt6uhDQwLfgPC/kMg1DZ9nekQl/hofNQHT34Lb2PaxDQZZUv
         8pChH0mbB4xQmPqsjrYFEWKoH1hHaWA/Hxq4Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+buIVC/1VPKvECsxMqNDPQ+i8AJPTJg9/lSk6De449o=;
        b=egzuyxWzS3uWZv+yyPrYi2G1S5MOUWvpBTlHgMcAD8SPcgtHweHjpMclP52l2TnxtF
         ZPa/jjHTKTCWMbZOIRlVyHXSyuTGACkQEkNnsuqFKtuHG/cFJTmiG+BGw5vuqE3/pZU7
         NkPMF8vkWCVzjkyUFDx7hrHgsQOHYfR6+IyrnNffBs9ukn/TBDwTSQHfCGQzS4IGjXF6
         +nES+sRuQ7o+XiTcQ6YEHln8hmZbbK3bP9aSx8xl5+0thjThiORNh7wrqyKsCSBhx7/t
         FmLWFXo9OSc+nJO0mH3+EsIWbjIgZH28kfpTAFiW+BQmCdxoIDCIO844sM2UkEJkJYiQ
         DnZw==
X-Gm-Message-State: APjAAAW+0LdN5gfdiUQK1g3N3peb3785U/rVSHLI0TXRXWdFJdU/kiSz
	BeULYqCKiCG+zN8SM6bW/cVMFbKhYwc=
X-Google-Smtp-Source: APXvYqzgIu9igh7MFHq8gluXRTDKpLsMAIXgdWsDG2JqoQ+PmfOnBN59SFV+7mTZDoxKqvhnDHf7wQ==
X-Received: by 2002:a17:902:7083:: with SMTP id z3mr6280284plk.215.1575504626887;
        Wed, 04 Dec 2019 16:10:26 -0800 (PST)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	keescook@chromium.org,
	Thomas Garnier <thgarnie@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 11/11] x86/alternatives: Adapt assembly for PIE support
Date: Wed,  4 Dec 2019 16:09:48 -0800
Message-Id: <20191205000957.112719-12-thgarnie@chromium.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <20191205000957.112719-1-thgarnie@chromium.org>
References: <20191205000957.112719-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the assembly options to work with pointers instead of integers.
The generated code is the same PIE just ensures input is a pointer.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
---
 arch/x86/include/asm/alternative.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 13adca37c99a..43a148042656 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -243,7 +243,7 @@ static inline int alternatives_text_reserved(void *start, void *end)
 /* Like alternative_io, but for replacing a direct call with another one. */
 #define alternative_call(oldfunc, newfunc, feature, output, input...)	\
 	asm_inline volatile (ALTERNATIVE("call %P[old]", "call %P[new]", feature) \
-		: output : [old] "i" (oldfunc), [new] "i" (newfunc), ## input)
+		: output : [old] "X" (oldfunc), [new] "X" (newfunc), ## input)
 
 /*
  * Like alternative_call, but there are two features and respective functions.
@@ -256,8 +256,8 @@ static inline int alternatives_text_reserved(void *start, void *end)
 	asm_inline volatile (ALTERNATIVE_2("call %P[old]", "call %P[new1]", feature1,\
 		"call %P[new2]", feature2)				      \
 		: output, ASM_CALL_CONSTRAINT				      \
-		: [old] "i" (oldfunc), [new1] "i" (newfunc1),		      \
-		  [new2] "i" (newfunc2), ## input)
+		: [old] "X" (oldfunc), [new1] "X" (newfunc1),		      \
+		  [new2] "X" (newfunc2), ## input)
 
 /*
  * use this macro(s) if you need more than one output parameter
-- 
2.24.0.393.g34dc348eaf-goog

