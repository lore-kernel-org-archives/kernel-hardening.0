Return-Path: <SRS0=zWhK=CM=lists.openwall.com=kernel-hardening-return-19735-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 294D0C35265
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:34:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 81DC720658
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:34:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mF0WB4Q1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81DC720658
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19735-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23726 invoked by uid 550); 3 Sep 2020 20:31:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23588 invoked from network); 3 Sep 2020 20:31:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=uaTfkB4ak1aJZWY50HSjxViiXLY/kut+uNnKrezpcK8=;
        b=mF0WB4Q1ilKN/2ZqpXw5x4/HmJUMwCWGi2P+cTr/YpR+8mKfhxtAQ98O8PqGynIC8O
         SEOr8J0gsFlwzelGzRV17yurypMIXiNJ55R0Ym5qIIwq+cQiNZ/t4akGHBiu14GZxifB
         mGzV4o2ZdqIe4cXD+oWt+lNNks1pqY9XmZ8qYRr8AF+yz2wMbwhUJW9NadF6++sNk6qg
         k6gt9RssqRm8Ro+SLyHZewy2mRecQrib+ApgUWgcAWDaDTixRz6n/GojNuc8DZQ0zJwb
         gqJSHHf8ovZr9XJCJdpQFTPz3QtwXORXLXWqFrqr3VgOKkRiidqDj1RYJuMC+BGncMrH
         crQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uaTfkB4ak1aJZWY50HSjxViiXLY/kut+uNnKrezpcK8=;
        b=blkL8pl8r2GiXkSEn5+/+z/OtDiib3hRyul8qVyJxCUJBdrc5eVG8m1wZ67BzY+8xl
         0CWQSUKNwRQC3PWg+Cb1We/zu6HFOBcWLX5RpAd6QTN1hdtgFkQTJfWeaTzWfGwoOqe4
         iYdgdkv0jQ5dqzxw8w1Q7k0Q/PUYywIN8ygVvWPp9yn8awnc66P9gkEM6iq+8HvPvuBL
         IixvRue2wQLi3bFHeCndJAsje16snihk6UypzCOexKT8vEA+q3Qof4fr1x4HJBE1AtVZ
         J4ef18qVvhTjDyGI8xMCfvPt3EVexXDihqa3qskSJtnt/pSk4kZ/HvAlBCQMkiqDlRaa
         MucQ==
X-Gm-Message-State: AOAM531AzoFIVc/ww5Zu4SE2n8GSNXSBEtuKgILYuSNgiW+0/Gy8kiGT
	DAEbxn0DpqAkXC4G5rwhlTsHlQV5z0mx8i7zTqQ=
X-Google-Smtp-Source: ABdhPJxkMmB21+S7VY0Jt9zVeucemxfhi5zBK41/ZcXFOz1RBFo/uHKHBl3+bP1fnXBaBCAh+O4Eoo9Dz40YO9G7Tzc=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:cdca:: with SMTP id
 d193mr5380428ybf.402.1599165087915; Thu, 03 Sep 2020 13:31:27 -0700 (PDT)
Date: Thu,  3 Sep 2020 13:30:41 -0700
In-Reply-To: <20200903203053.3411268-1-samitolvanen@google.com>
Message-Id: <20200903203053.3411268-17-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200903203053.3411268-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH v2 16/28] init: lto: fix PREL32 relocations
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

With LTO, the compiler can rename static functions to avoid global
naming collisions. As initcall functions are typically static,
renaming can break references to them in inline assembly. This
change adds a global stub with a stable name for each initcall to
fix the issue when PREL32 relocations are used.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
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
2.28.0.402.g5ffc5be6b7-goog

