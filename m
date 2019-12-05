Return-Path: <SRS0=CsR0=Z3=lists.openwall.com=kernel-hardening-return-17465-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE2F2C43603
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Dec 2019 00:12:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 49C2B206DF
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Dec 2019 00:12:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="TYU9bizn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49C2B206DF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17465-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29819 invoked by uid 550); 5 Dec 2019 00:10:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29770 invoked from network); 5 Dec 2019 00:10:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Wom0YuEw+sxPN46lShSOJcleDb+6/uebIAUT9UJe6O4=;
        b=TYU9biznX4Fr+oXplt8t6lZVC875R5GdQpDtGyoG7jHn1dhskEBnd09tvZhJGAFU/g
         LrL5kio9op22EkuMbWapAdZnmHsJNSN3VvpSYWblpjxw1xSpBmEfPLeFLApm+7QNnUe1
         b/lOwzkq65DhE5MjKUY1R1NraoVNUwtPyd4uk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wom0YuEw+sxPN46lShSOJcleDb+6/uebIAUT9UJe6O4=;
        b=hiybdenMdEyvIArLuSO1SVMrXvtzgyaxsxY2KEddIo2w8wagJ6ZHjXcduS5uS8SMHr
         TFW3iJk3ENwXo332DuqndzWEca/1chr3VF1DBLFvHZVNsbG4ElKWqaamtOKQ571tRbm0
         HhSSu1eT/xHACTe9Of16FIjOsefpmN8tFvVIoUzpN3JCnkpaZm+Gryxc0yksNoovQihg
         R8D52Kbv/CgLA95aWZprztBOqiMuBAfHrLrxmL5SdrKOdZ1fVsgIsvePb6bBqDVdzm74
         Yv+74mx662RdojZMuEw9G7HFaNL0jojPmAlCH4+gQl/i2YzprfI3mvcO2B1IX85jVmTf
         dIbQ==
X-Gm-Message-State: APjAAAVIPEhkVkhnwBdrvizdNGbqupC+bpwakJJirruYKe1z3ShhNVij
	WV1Vp0rxUpS480o7WZ7Ddjn9aeUKYM8=
X-Google-Smtp-Source: APXvYqx+rdjo7KYD764+cA3j+DYShZXYaqzplHV9aZLeeWqpbwUsyT49bWt0YB2+lFklCCpyLgsBCw==
X-Received: by 2002:aa7:9afb:: with SMTP id y27mr6140094pfp.91.1575504624844;
        Wed, 04 Dec 2019 16:10:24 -0800 (PST)
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
Subject: [PATCH v10 10/11] x86/paravirt: Adapt assembly for PIE support
Date: Wed,  4 Dec 2019 16:09:47 -0800
Message-Id: <20191205000957.112719-11-thgarnie@chromium.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <20191205000957.112719-1-thgarnie@chromium.org>
References: <20191205000957.112719-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If PIE is enabled, switch the paravirt assembly constraints to be
compatible. The %c/i constrains generate smaller code so is kept by
default.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

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
2.24.0.393.g34dc348eaf-goog

