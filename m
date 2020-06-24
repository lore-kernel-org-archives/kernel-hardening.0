Return-Path: <SRS0=k6fy=AF=lists.openwall.com=kernel-hardening-return-19118-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE1BC433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:34:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6871D2081A
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:34:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="egWHIaow"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6871D2081A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19118-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32460 invoked by uid 550); 24 Jun 2020 20:33:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32370 invoked from network); 24 Jun 2020 20:33:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=edIkT6p07lpLePHQP+aYqsXpIzZ2+6woe9Vgp5gIJI4=;
        b=egWHIaowycA2j4XZam7KmKMW2pQ89pwKSamnnESmMZjXlGrpDiBMEKX0ymsIpEUG5Q
         Q/5jq7wq9EUsrGut0D7nH0OzX+X6PmQ4BsvV+OFdyIwItO18fwnnqRcjLL/etsokICn2
         kJA/eOpcLnRws54bEMudJOUeKnPBfutms4HPc2YVoU7pUuEXirkoHEo/+ZivIPBIpcjm
         QAZkoUB6YhA3LjQHac3tKT7W83SDE0ybUBlgAkHod3lCaXJMmDghQ2Hjaer2BjebhMdJ
         6tJB8nkEwUWILUX4LAlqgG6pcwYlTLpv3LHaWpmgIRcC8eGvhD6AT800VKeaZEkZUUaI
         CVRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=edIkT6p07lpLePHQP+aYqsXpIzZ2+6woe9Vgp5gIJI4=;
        b=YczBBJ9/TdsxkdyX+2xrR9oryG5KBPPxnH3EuRBDBnlptliPcIww4g2eA6T6Yc9KX7
         +lv19J0Za0X+wxYn7IPiomMe67l7l/FCGnMSbcf6ud0njDHQa1PWoe4Tsgp1FWFThIMj
         aYfj85Ql8cvNzhiChAzc3/AdZdPWS74XXFCUsLzBjVSJEJ0VVXQUc51W2y1IVlPwJObe
         dhwa0kVSwYjmBKOBBpIbemN5fh6Q2Q30KFmfwNCqRZXglvdu4vSVdqxY2CF1cV9mUayS
         LIXdeQfeZpFKcNVWAXX9zG6YiBZXKEV4l0W+gI2VNdS4aha429pj7RNKVkBJpgblQeQd
         +ayg==
X-Gm-Message-State: AOAM531CdDICkEJWD76xJw8kUE0KTX9DEPzMK9XkmQ03pfTRKloJzKdq
	ZYGt/X8C79qsoik9pgQfZXKZdLwn7GI/WKugkMQ=
X-Google-Smtp-Source: ABdhPJydy+dzRZtnkDF9CbEhIOBTVruIEpnrPFlxeYrxbEJR+QigE4MSYlaU55SmzK1okb/YgyaF3Z/PviJDUt9UdRg=
X-Received: by 2002:a25:2fc5:: with SMTP id v188mr45630243ybv.130.1593030796295;
 Wed, 24 Jun 2020 13:33:16 -0700 (PDT)
Date: Wed, 24 Jun 2020 13:31:48 -0700
In-Reply-To: <20200624203200.78870-1-samitolvanen@google.com>
Message-Id: <20200624203200.78870-11-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH 10/22] init: lto: fix PREL32 relocations
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
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
 include/linux/init.h | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index af638cd6dd52..5b4bdc5a8399 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -209,26 +209,48 @@ extern bool initcall_debug;
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
2.27.0.212.ge8ba1cc988-goog

