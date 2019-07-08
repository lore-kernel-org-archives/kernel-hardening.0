Return-Path: <SRS0=NTw0=VF=lists.openwall.com=kernel-hardening-return-16395-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7159C606C7
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2019 17:51:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 133B62189F
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2019 17:51:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="YO7rYeBT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 133B62189F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16395-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29752 invoked by uid 550); 8 Jul 2019 17:49:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28605 invoked from network); 8 Jul 2019 17:49:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VYVCK+lE6TfQr6KRbpNni5BR/rdhwG4w+KTNeQVPvFA=;
        b=YO7rYeBTtbOSPm2PM2bUxLHbjhObhohK+nc071hlnGlCjMy8KwfWnPBD8qNgCz3fB1
         8RchZLAzudKMoEAymQQLjNDFw0lA8xTX0qJciZeUvBDr2VLBQ3P0M+Pa7oSYMgRHrMdN
         woz/GPDPKTh6ACUfHbMv4pAEfp7T2uaZhoVGo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VYVCK+lE6TfQr6KRbpNni5BR/rdhwG4w+KTNeQVPvFA=;
        b=ktHqS1lM2ysoh2++dNjVSLQPh92G8gudlt5ZnKcRNP9iFOmAKNuBOWg85Gb+BoxHia
         YuEI5awduMsaG/5tvO6kwi5jku4l1j0gGE04NK3RWDWpL65NtpzIkMCJ0tpcCsY2R2QH
         iffNJmwpI4wvCUY4eEn/XHgLsc2qhcSE8EXNKBwOEnAPLbheg73t4+DC+cuS/Dn7eBoo
         Ra8YuaCPActD7l5NFh8G0659LAXK5iV6XB/W04Qy33251XcTKvDZNHh8tZsW8Ht6LbU+
         tJWn4WZZELwlcRVMjdz2cVJHx9CUSyr781QFtQA0loJ4RNZF34Etn13U7+hUEbOACTI2
         Q+lw==
X-Gm-Message-State: APjAAAUeKP3+L0eWidb/ihmar6yxSHREJEk8Rb5YkBmREjWSqBSkROQ6
	2LmmTGUEEal9MmHni1NdU03y0i75yW4=
X-Google-Smtp-Source: APXvYqzLN6oNXPNoxCuXGt+FuBI73Vtvl0VQN9tamK8mlquFWOHra5OXoyNjTYkeZDsSJbhySbtUxA==
X-Received: by 2002:a17:902:684f:: with SMTP id f15mr26566998pln.332.1562608182892;
        Mon, 08 Jul 2019 10:49:42 -0700 (PDT)
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
Subject: [PATCH v8 11/11] x86/alternatives: Adapt assembly for PIE support
Date: Mon,  8 Jul 2019 10:49:04 -0700
Message-Id: <20190708174913.123308-12-thgarnie@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190708174913.123308-1-thgarnie@chromium.org>
References: <20190708174913.123308-1-thgarnie@chromium.org>
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
2.22.0.410.gd8fdbe21b5-goog

