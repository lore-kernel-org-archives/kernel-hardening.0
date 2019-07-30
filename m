Return-Path: <SRS0=DCkl=V3=lists.openwall.com=kernel-hardening-return-16654-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E664BC0650F
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Jul 2019 19:15:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 403DD2064A
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Jul 2019 19:15:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="NEHgj6CU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 403DD2064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16654-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29937 invoked by uid 550); 30 Jul 2019 19:13:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29786 invoked from network); 30 Jul 2019 19:13:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=djb+K5YV06tE6CuanEg0CCbjMrpDNzEbnLAfye7ZkSY=;
        b=NEHgj6CUyhuGNXZT844G24GmkoVlxjwnp/ZZK+KeYPZYfnl+y2UvSztPruWijQ4cSI
         kBY38ehlnCl9JH9OOX/JsC03zQgxQlLzWzBZnYs6E5MkdIvE+bVThcfwBcwDd1fydiyS
         XhhW1KJvnX2Qrszc09rMS6Fb8iqbbIIl1pYec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=djb+K5YV06tE6CuanEg0CCbjMrpDNzEbnLAfye7ZkSY=;
        b=g1lRB8fHTut2JIMkLz6wdBYNCNAHPsa9AlknIqDtAA3GuXXTMxzuLISwk4KWr4EdAL
         jRqwx+nn3GVBr3dyAIqu2RDJ1m++zA6CvVcP1j47tsAWdjYbjD4bcv/vmsV7TmSm4k2a
         hOm/Lo4xlhi6Kd68L0HZU9Nc+lsbTW8pIka0H+O//n0Fed2/W0lxImLsHERs+zfTA4YJ
         f1ZeNqMx+ZARh5ZOGV2bXUHfTn4zWPSeS6Lny9sl8wEu/hu6LOPLlKhRBNDErzRonbpH
         QiEnXPVoJJtjaL69r7LpsqvyOYaFl7YaQEkJKDj6D6CT8Oc/rd2lJL+IuOJYTEeacwPm
         A+Ow==
X-Gm-Message-State: APjAAAUC/0qdHWkw+qcduN2aiK8RjDePa6iktotKhEPML1PrHbc/O0Lg
	wlYeJohTLbBbfnawNMbOKtsJ1T8lT08=
X-Google-Smtp-Source: APXvYqx7PDw4+udfJ0/X/aulEp6speZuvn3qPpw/ORb5g1xlvlm+szU4lbJM3sBZ+Qyz/KRfApdJug==
X-Received: by 2002:a17:902:42a5:: with SMTP id h34mr120262792pld.16.1564514006452;
        Tue, 30 Jul 2019 12:13:26 -0700 (PDT)
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
	Nadav Amit <namit@vmware.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v9 11/11] x86/alternatives: Adapt assembly for PIE support
Date: Tue, 30 Jul 2019 12:12:55 -0700
Message-Id: <20190730191303.206365-12-thgarnie@chromium.org>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
In-Reply-To: <20190730191303.206365-1-thgarnie@chromium.org>
References: <20190730191303.206365-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the assembly options to work with pointers instead of integers.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
---
 arch/x86/include/asm/alternative.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 094fbc9c0b1c..28a838106e5f 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -243,7 +243,7 @@ static inline int alternatives_text_reserved(void *start, void *end)
 /* Like alternative_io, but for replacing a direct call with another one. */
 #define alternative_call(oldfunc, newfunc, feature, output, input...)	\
 	asm volatile (ALTERNATIVE("call %P[old]", "call %P[new]", feature) \
-		: output : [old] "i" (oldfunc), [new] "i" (newfunc), ## input)
+		: output : [old] "X" (oldfunc), [new] "X" (newfunc), ## input)
 
 /*
  * Like alternative_call, but there are two features and respective functions.
@@ -256,8 +256,8 @@ static inline int alternatives_text_reserved(void *start, void *end)
 	asm volatile (ALTERNATIVE_2("call %P[old]", "call %P[new1]", feature1,\
 		"call %P[new2]", feature2)				      \
 		: output, ASM_CALL_CONSTRAINT				      \
-		: [old] "i" (oldfunc), [new1] "i" (newfunc1),		      \
-		  [new2] "i" (newfunc2), ## input)
+		: [old] "X" (oldfunc), [new1] "X" (newfunc1),		      \
+		  [new2] "X" (newfunc2), ## input)
 
 /*
  * use this macro(s) if you need more than one output parameter
-- 
2.22.0.770.g0f2c4a37fd-goog

