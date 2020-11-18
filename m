Return-Path: <SRS0=p+EE=EY=lists.openwall.com=kernel-hardening-return-20414-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 794F9C56201
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Nov 2020 22:09:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 771722054F
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Nov 2020 22:09:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GNMm1MAV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 771722054F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20414-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3912 invoked by uid 550); 18 Nov 2020 22:08:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3805 invoked from network); 18 Nov 2020 22:08:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=JUh1T9Q0UpH1P/k5MG3eyMCJDiIsKr/ZhdG3k4jEA2o=;
        b=GNMm1MAVTepQmZAF77rlDYxsuCdPaSo7+Ez7SIfF2FWVLeWy9R3mFyHA2wPW466N3j
         0SWe2Yq8j6EF83sMo6emozMTZ9ptK/gS+fCtk3yKY5a6UO91rxckJhgTq1xK04dt07lp
         6p26tDJr7oc3rv4oRJ6DOnLzLhSn87edt2CqXiE7YNvlWSgL9o2LDhtNJDbcJBqeQQWd
         0KEtkxJOmbT6JFsXb04tkZ4RCyVn70wiNpv4WilQN6L1DumoZp7goDqbL/XtjbAL/M99
         v3kUtHqpOiXPTfFRq+tP2O4TBYERMP+NYokmuOLksHWs2A228Y+lQf9s5GUGTnt79xuC
         A4GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JUh1T9Q0UpH1P/k5MG3eyMCJDiIsKr/ZhdG3k4jEA2o=;
        b=RNdUauxGZzAwGpXoV2bYQqY1GxE7Jfe7o8xyUtc4wQadOT0RjoY6RiuS3QGFKW1TGS
         U/Q1wMEGkOwIgje9sCLWRSh5BYyOAJxQgBo3R+DCGBHg7R8PQCNrghfINDkD9m94zHUY
         syV14sEJ6Qvc4XqExyWIWhfk4TgvXXkLs0qaOYnJMsafHMaTeUHYzOWfGbfIAmcwlUcH
         H58nGg3RY8CvJd8PiKsWAA73AANEGCECNfj4uHOf79/cTS9TUcgMEFTVRZ2ObmftTal2
         ca2g23rG3zx+lld9ABD5ai7Eg/KNxXf/4X+v661PBbig39WZJrjZUIQ6d4uVZ91GvSXH
         W8Gg==
X-Gm-Message-State: AOAM533hQa/nmoN9W9ql0jJ/wBVILk7MK3Y2Advt8zJJKGsZBDeCtApg
	FUabTrcZgDcc2Q6s1N8WhjNcgzxAVv1k3xOoWV0=
X-Google-Smtp-Source: ABdhPJxE6/lqSbIrIFD1BhHDD+bexarqDwW1+leKzxBz5MqxugP2bAoLKwReJ4geoR/cz0YhdybYAmKOwiK4l65zoYE=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a17:90a:fb54:: with SMTP id
 iq20mr1047953pjb.111.1605737270583; Wed, 18 Nov 2020 14:07:50 -0800 (PST)
Date: Wed, 18 Nov 2020 14:07:22 -0800
In-Reply-To: <20201118220731.925424-1-samitolvanen@google.com>
Message-Id: <20201118220731.925424-9-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH v7 08/17] init: lto: fix PREL32 relocations
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
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
index d466bea7ecba..27b9478dcdef 100644
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
2.29.2.299.gdc1121823c-goog

