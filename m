Return-Path: <SRS0=Z0WH=DG=lists.openwall.com=kernel-hardening-return-20048-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.9 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8189C4727C
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:49:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 121382076D
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:49:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b55hwPid"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 121382076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20048-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32473 invoked by uid 550); 29 Sep 2020 21:47:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32301 invoked from network); 29 Sep 2020 21:47:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=/vP7q5BBB0uTfRm2AgwdilGSRfsWzFPQ2WkTiyoFr6c=;
        b=b55hwPidpBtwXSYzPL7nG9/Vda7JuMVr/EGJixbfG0vXQwUBtPjkDoj3MJOTqZMsWM
         vzguUIrKQvSlcJMS9LcTLx25efyz9HzS/XNyEl+Vmt3JZFYWS9Xi9CW480UD18Iv8V/8
         Zv0q3PdFWw+MxCu1kPSRKo5b5kauZeRMwrGkfiXKdlBUKbyUb+Mx09RiNdFeO5g1b1k/
         MGs4GivcBr1kLWAINFKbVMCXqvyatQdyLKZ3K2d+FSPXYNUWpizBFCZ7ExOm+k6gsGZr
         9pRIvsrPB/pkdVgUtISLhxoJY5If1dpdNi3Vrr64TIoPSMdOxtuHEgcrwzGEARSD2d7Y
         rM6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/vP7q5BBB0uTfRm2AgwdilGSRfsWzFPQ2WkTiyoFr6c=;
        b=VQZlMTBDgzbrQNnSEoHRTfieSC8GReOTOTdspMBgH/EZT0Jla4QbCIsfv5KUI0+jaP
         AQADRDmfpxXoBzTLVD55aq5f0CA7BHHBNV+eX+Az9pbQdFjHFiwB7G4jKyxJunUBG/Kv
         XHyRC0EA+ojBX7TJUU6B0/s+gNsYPe9nrGX49OQyFdaFGzTlMeXB4imvxsCdfkfD0Pod
         nxZDj4zl0wsObM//mJtvVIvz1exV29Bwtzm24yVKhL+YOU7K38Pv7oh2HHTopthyzne0
         u3+yVGatbDCRcwX4mRw75LOUs3wdt5zVF0EO8yPfufH/0h2Xz3/Yct2WRQ7opz+QKUdI
         YTxg==
X-Gm-Message-State: AOAM531rq7uxK+SNTt5BKUz07tup8jTU3xXI85tG7a4NDg487qxQWx9t
	DxP5RqivrJG5Wj3heVXCfZH2SCkF5gvat7i3KJI=
X-Google-Smtp-Source: ABdhPJzwunn8/64a+JvNFjvDzCLI2jH4jHUm6kjJgtH3L7MwJCKNh04+JiRlVd1IwEJ79vkmzQAo7H0Oi+ZByvS+NaY=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a63:e813:: with SMTP id
 s19mr4805529pgh.33.1601416033950; Tue, 29 Sep 2020 14:47:13 -0700 (PDT)
Date: Tue, 29 Sep 2020 14:46:20 -0700
In-Reply-To: <20200929214631.3516445-1-samitolvanen@google.com>
Message-Id: <20200929214631.3516445-19-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200929214631.3516445-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH v4 18/29] init: lto: fix PREL32 relocations
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

With LTO, the compiler can rename static functions to avoid global
naming collisions. As initcall functions are typically static,
renaming can break references to them in inline assembly. This
change adds a global stub with a stable name for each initcall to
fix the issue when PREL32 relocations are used.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 include/linux/init.h | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index af638cd6dd52..cea63f7e7705 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -209,26 +209,49 @@ extern bool initcall_debug;
  */
 #define __initcall_section(__sec, __iid)			\
 	#__sec ".init.." #__iid
+
+/*
+ * With LTO, the compiler can rename static functions to avoid
+ * global naming collisions. We use a global stub function for
+ * initcalls to create a stable symbol name whose address can be
+ * taken in inline assembly when PREL32 relocations are used.
+ */
+#define __initcall_stub(fn, __iid, id)				\
+	__initcall_name(initstub, __iid, id)
+
+#define __define_initcall_stub(__stub, fn)			\
+	int __init __stub(void);				\
+	int __init __stub(void)					\
+	{ 							\
+		return fn();					\
+	}							\
+	__ADDRESSABLE(__stub)
 #else
 #define __initcall_section(__sec, __iid)			\
 	#__sec ".init"
+
+#define __initcall_stub(fn, __iid, id)	fn
+
+#define __define_initcall_stub(__stub, fn)			\
+	__ADDRESSABLE(fn)
 #endif
 
 #ifdef CONFIG_HAVE_ARCH_PREL32_RELOCATIONS
-#define ____define_initcall(fn, __name, __sec)			\
-	__ADDRESSABLE(fn)					\
+#define ____define_initcall(fn, __stub, __name, __sec)		\
+	__define_initcall_stub(__stub, fn)			\
 	asm(".section	\"" __sec "\", \"a\"		\n"	\
 	    __stringify(__name) ":			\n"	\
-	    ".long	" #fn " - .			\n"	\
+	    ".long	" __stringify(__stub) " - .	\n"	\
 	    ".previous					\n");
 #else
-#define ____define_initcall(fn, __name, __sec)			\
+#define ____define_initcall(fn, __unused, __name, __sec)	\
 	static initcall_t __name __used 			\
 		__attribute__((__section__(__sec))) = fn;
 #endif
 
 #define __unique_initcall(fn, id, __sec, __iid)			\
 	____define_initcall(fn,					\
+		__initcall_stub(fn, __iid, id),			\
 		__initcall_name(initcall, __iid, id),		\
 		__initcall_section(__sec, __iid))
 
-- 
2.28.0.709.gb0816b6eb0-goog

