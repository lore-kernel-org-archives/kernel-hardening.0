Return-Path: <SRS0=AToN=V3=lists.openwall.com=kernel-hardening-return-16653-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F8A2C433FF
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Jul 2019 19:15:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8F3122064A
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Jul 2019 19:15:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gqg94NNJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F3122064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16653-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29781 invoked by uid 550); 30 Jul 2019 19:13:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28564 invoked from network); 30 Jul 2019 19:13:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4p7Yl4EvALrNapOIPblFQ4RqIFxBJYtmcwuhdJ36a4M=;
        b=gqg94NNJOdf9cHSR+XH6US+L0jKiqTwG0Xmx1oLuP1Hhp+nDgjGFTPn60im+Ecit12
         y/IVI2h60aZld1+y9XWSydA3vMe0xeJM9dR6rAMy+Kp7VanoIic5nQjtZLeRn6MaGJms
         8PRL5H4oh61RS+rUbxcD5n83K03BRRSwK4xJY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4p7Yl4EvALrNapOIPblFQ4RqIFxBJYtmcwuhdJ36a4M=;
        b=mVrqlMvfnV+UB+B8qQGmEYUKwCjyhPHvn05u0aqWjb44gQj2P0MdagITrE7IVtMCKL
         TfkqcDvdQOTTsdR9R4WVjgoxplW4A6m7SAkq65yrPrriG69jDulP2pxz09SG7sSyKJ0N
         ttPlnz5WnyNFgA7CrJE8QWRdd7UzD5CrUyy4ExLkV0CCZjKUUtz9y9UmcRIWxa/1gc2o
         7UOQEPdzBsbIbiIxfZy/xkOUYrcHC/KS+BSvafET9dKQJEn+yIv+0j9Z7wf9EC8QF35r
         zichhTGDkWXapHSb1A4sjtzyib4knv44g/HrpPPZU4pyHXe0Omu25F3eMm6qPZvkxsdb
         3Vmw==
X-Gm-Message-State: APjAAAWbpKqoH4S+Scaphv6j5ZlVfk7YxuWWK62cuvSfOVigpEwxBkET
	HwThq/PPI6E34zgvGSa8CGvBJA7yLpA=
X-Google-Smtp-Source: APXvYqwoE5YtV9czMWqYh5jaOXzzNfppyGGX1LntKX22Zkz6VcJhYSb1VjmmI91pfMMS60cxTSLgPQ==
X-Received: by 2002:aa7:9407:: with SMTP id x7mr44914613pfo.163.1564514004448;
        Tue, 30 Jul 2019 12:13:24 -0700 (PDT)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	keescook@chromium.org,
	Thomas Garnier <thgarnie@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Thomas Hellstrom <thellstrom@vmware.com>,
	"VMware, Inc." <pv-drivers@vmware.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v9 10/11] x86/paravirt: Adapt assembly for PIE support
Date: Tue, 30 Jul 2019 12:12:54 -0700
Message-Id: <20190730191303.206365-11-thgarnie@chromium.org>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
In-Reply-To: <20190730191303.206365-1-thgarnie@chromium.org>
References: <20190730191303.206365-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

if PIE is enabled, switch the paravirt assembly constraints to be
compatible. The %c/i constrains generate smaller code so is kept by
default.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
Acked-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/include/asm/paravirt_types.h | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 70b654f3ffe5..fd7dc37d0010 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -338,9 +338,25 @@ extern struct paravirt_patch_template pv_ops;
 #define PARAVIRT_PATCH(x)					\
 	(offsetof(struct paravirt_patch_template, x) / sizeof(void *))
 
+#ifdef CONFIG_X86_PIE
+#define paravirt_opptr_call "a"
+#define paravirt_opptr_type "p"
+
+/*
+ * Alternative patching requires a maximum of 7 bytes but the relative call is
+ * only 6 bytes. If PIE is enabled, add an additional nop to the call
+ * instruction to ensure patching is possible.
+ */
+#define PARAVIRT_CALL_POST  "nop;"
+#else
+#define paravirt_opptr_call "c"
+#define paravirt_opptr_type "i"
+#define PARAVIRT_CALL_POST  ""
+#endif
+
 #define paravirt_type(op)				\
 	[paravirt_typenum] "i" (PARAVIRT_PATCH(op)),	\
-	[paravirt_opptr] "i" (&(pv_ops.op))
+	[paravirt_opptr] paravirt_opptr_type (&(pv_ops.op))
 #define paravirt_clobber(clobber)		\
 	[paravirt_clobber] "i" (clobber)
 
@@ -379,9 +395,10 @@ int paravirt_disable_iospace(void);
  * offset into the paravirt_patch_template structure, and can therefore be
  * freely converted back into a structure offset.
  */
-#define PARAVIRT_CALL					\
-	ANNOTATE_RETPOLINE_SAFE				\
-	"call *%c[paravirt_opptr];"
+#define PARAVIRT_CALL						\
+	ANNOTATE_RETPOLINE_SAFE					\
+	"call *%" paravirt_opptr_call "[paravirt_opptr];"	\
+	PARAVIRT_CALL_POST
 
 /*
  * These macros are intended to wrap calls through one of the paravirt
-- 
2.22.0.770.g0f2c4a37fd-goog

