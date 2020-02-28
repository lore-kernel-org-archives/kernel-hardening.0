Return-Path: <SRS0=VBmi=4Q=lists.openwall.com=kernel-hardening-return-17993-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECBD6C3F2C6
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 00:01:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4AFFD2087F
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 00:01:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="R0fDgyKL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4AFFD2087F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17993-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21529 invoked by uid 550); 28 Feb 2020 00:01:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20371 invoked from network); 28 Feb 2020 00:01:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fvhzUd6Qu7cjrcCOJttmYiBqe1hyVQ5v3hyhsFuyKi8=;
        b=R0fDgyKLTHQkfsWhWRkFBROySWE56w7r6inEPzUviguIQfBELPtivu7yY4Ik9lv7t7
         /nOIfMq8t2T13X1qgjHYJJ5cidxN2ymJ2qiAEIYtGpRaD6z6Ni0j6HvemLNDgKpXyqwv
         tyPUm4U3B3hIYcksrbm95hIv5aO+ZSAMYtXnc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fvhzUd6Qu7cjrcCOJttmYiBqe1hyVQ5v3hyhsFuyKi8=;
        b=iL9CN488pP72NIBiFXfARVMR8ZI7pT7H3YEHbwGORV0AA27+d/C4oCupelIRpg/U7X
         4SEX3ewJoMh0hG5PxO1seHxK9v5qY/dZ2QmIyXL6TgcYzluTAkgBEYZK9/qzCR6PBSMB
         CvH1YLz++tW1qY+63nIpokEoJ7vAYAA7oSmbizEKd5t7GP858RfEl0IOc9jZ2ujSJL2f
         n7JIcg+JfV24aiARfEJ8lKS4supujpiUrOMArXA8OGqAVmYxFTpZc/KrIwVPjYtE2bZ0
         nEgUGskyHm4QH9qDA938pRyrX7CmtSGrf6qxlbCzdKQJIE/cET7K/wSjk77k4RF/3qCq
         nQfQ==
X-Gm-Message-State: APjAAAWpOhUXl2K2UhELLQ/bCBdkwOKtTCLm9J7zLGrC+rH7Vu2GPa/0
	ki0OLALX0lvxA61Jkmw70sEk3djFp/Q=
X-Google-Smtp-Source: APXvYqwThB4LJ42cXGHIwD4VP+n+OceP9p72vw3hubV+kmuIORRSU7xn+cXTMOPaKk/qKAWgjHeHnQ==
X-Received: by 2002:a63:4e22:: with SMTP id c34mr1833461pgb.263.1582848073452;
        Thu, 27 Feb 2020 16:01:13 -0800 (PST)
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
	Masami Hiramatsu <mhiramat@kernel.org>,
	Will Deacon <will@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v11 02/11] x86: Add macro to get symbol address for PIE support
Date: Thu, 27 Feb 2020 16:00:47 -0800
Message-Id: <20200228000105.165012-3-thgarnie@chromium.org>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
In-Reply-To: <20200228000105.165012-1-thgarnie@chromium.org>
References: <20200228000105.165012-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new _ASM_MOVABS macro to fetch a symbol address. Replace
"_ASM_MOV $<symbol>, %dst" code construct that are not compatible with
PIE.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
---
 arch/x86/include/asm/asm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index cd339b88d5d4..644bdbf149ee 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -32,6 +32,7 @@
 #define _ASM_ALIGN	__ASM_SEL(.balign 4, .balign 8)
 
 #define _ASM_MOV	__ASM_SIZE(mov)
+#define _ASM_MOVABS	__ASM_SEL(movl, movabsq)
 #define _ASM_INC	__ASM_SIZE(inc)
 #define _ASM_DEC	__ASM_SIZE(dec)
 #define _ASM_ADD	__ASM_SIZE(add)
-- 
2.25.1.481.gfbce0eb801-goog

