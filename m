Return-Path: <SRS0=7eXu=4Q=lists.openwall.com=kernel-hardening-return-18001-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A084C3F2CD
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 00:03:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 89D272087F
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 00:03:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="oEStjVPt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89D272087F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18001-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23644 invoked by uid 550); 28 Feb 2020 00:01:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22466 invoked from network); 28 Feb 2020 00:01:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H9FWlvjeU2XqZhHoJiWspMH4kFGj3K9GjGYd2WRMYmQ=;
        b=oEStjVPt0S31nPacabrXXaqaOo12Uk+r85uXc9Xl7Tu1lXk9HmiONOEKMda7M1yCLl
         DfI6JExzzhDdrzGWYDMCWToyRPzvherlO6BerSNdsLYxiTTSYaVvNUHXPBhmY/g7c40t
         6aZqMcdDUuTRkqEUDTm4BWTIy0OXUsHY+h8Gc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H9FWlvjeU2XqZhHoJiWspMH4kFGj3K9GjGYd2WRMYmQ=;
        b=T8c4I87pGhrLEEnGvcRwEyBjwajMl/t7WwEZeDDm09zWp+mU57TFnS9onAhKXyZisU
         fDKkD9r+O/3dVPTipRvjqWTQLkW3b/rRQkYAGRqwNrhpiJzWfGn0DjWC86uKTyJZWt9M
         opL88BrBtggEDSitVf9+FuyXqg3zxBtT2bsPo8YrUiN8GQn3o9C6etsigSWHcU9Ish3w
         d2hpTDeJQFI1zlrR/EQVffOFI/KoYLPfN1TcaGP4z6P5r/5VPM7fSSaeUVC2QCZHh4al
         I2usBD9vB57mFMM37+KAmAunMSm0bqPwfMNlEkAAJ0bE3mbXplGIDMf7UG/JsG8i7SyV
         GZ2Q==
X-Gm-Message-State: APjAAAWmD+DRtgpaoyen3JLYL22uJmQwjKCVNeEJjH1zLJmzc0odFx0Q
	A6RbOL5uAzYW33uP9kqhAC1OS7eDHXw=
X-Google-Smtp-Source: APXvYqzm3a/ZFJ1l5Nvdz79Gm4AfpVbhjeL86Hhy3RQsCyWjAO+rF4ZDCotN8wJqbSnZ9y96RTh5JA==
X-Received: by 2002:a63:df02:: with SMTP id u2mr1689153pgg.403.1582848086381;
        Thu, 27 Feb 2020 16:01:26 -0800 (PST)
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
Subject: [PATCH v11 10/11] x86/paravirt: Adapt assembly for PIE support
Date: Thu, 27 Feb 2020 16:00:55 -0800
Message-Id: <20200228000105.165012-11-thgarnie@chromium.org>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
In-Reply-To: <20200228000105.165012-1-thgarnie@chromium.org>
References: <20200228000105.165012-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If PIE is enabled, switch the paravirt assembly constraints to be
compatible. The %c/i constrains generate smaller code so is kept by
default.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
Acked-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/include/asm/paravirt_types.h | 32 +++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 84812964d3dd..82f7ca22e0ae 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -336,9 +336,32 @@ extern struct paravirt_patch_template pv_ops;
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
+ *
+ * Without PIE, the call is reg/mem64:
+ * ff 14 25 68 37 02 82    callq  *0xffffffff82023768
+ *
+ * With PIE, it is relative to %rip and take 1-less byte:
+ * ff 15 fa d9 ff 00       callq  *0xffd9fa(%rip) # <pv_ops+0x30>
+ *
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
 
@@ -377,9 +400,10 @@ int paravirt_disable_iospace(void);
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
2.25.1.481.gfbce0eb801-goog

