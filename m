Return-Path: <SRS0=OQ1R=FP=lists.openwall.com=kernel-hardening-return-20590-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD605C433FE
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 18:48:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 07F1123F37
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 18:48:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 07F1123F37
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20590-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7745 invoked by uid 550); 11 Dec 2020 18:47:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7617 invoked from network); 11 Dec 2020 18:47:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=9TLfWaf58UYL7wICLMCVVnhaOCpYf+H5DpQSRdiy6Cc=;
        b=HYjrQ1sMOOn7ObkUbybc+wvc4I5EDo2ggFgwIjqmySqyqvcxKUz9U7SM7Iku6XAD3L
         MaZfkgEgX8bO5VzFU2gtMQNWgcu/wOnkSTwXPIFeVvlEzpMkLiHIbHpRj8g4yDu1jHZA
         3CxXJVzpzKe4SOfBmr81hNI0UbqvcB2S9srss5KkoPp6DWrNCN9YKq4L3D8K0njH4hkb
         YiZREXyM6H7MRSRk5aoMuIbQJAGK7qyIC/Vh6N5H5PAnKudPsvjj6Xkm2vgSii8TALn6
         7lDbS9j6fQNA0FCLEENh5zRwh0RcunHnF5d9mlF3zyS30HlqX3tlEMim0v00ijfjLPOW
         Ri5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9TLfWaf58UYL7wICLMCVVnhaOCpYf+H5DpQSRdiy6Cc=;
        b=nvvemNgdpzHf/7vgTAxOjnsZ96DEBXn47srAQKlbgMjMxP7HkqxQ4WrPmzaOznW1X7
         37maWdUSMBMXExaEE5lnzoCxthpT8mL6MgxbKjGNQdoOir4aZNv3drI1M857v9vaLzY9
         5oNzy73Tj2BB7fephHVIFTBk61m9raf7uKS3XoW4t1zTlIL1tKikbS+BjTYjWob0IhVM
         2uj2lWNTMVZXl7ovP8GVpNDEQMayGyhsTxqZczNes5kG6vsQFBaqfQPpoIJlHfVyHiRK
         p93LbzOGeg42IEmRgbbhPe616phHTFFn5hPS7gDe6XsbQ2AWxG38Wsu56KGu3H6L+tu1
         2iqg==
X-Gm-Message-State: AOAM533tUfvGWtNxvkp7aYwTjuAQL1u/Dz06VR5Dilv5BYcN720uvlgX
	6I4DzLR20Ud2Av+P0oTQlHcHSVqF7nrb4RN/img=
X-Google-Smtp-Source: ABdhPJxOTg1pZ6kKhg4/TLTiKW5mUxnxwTfGU0xF4tIiotwCBx+K30YxUBmIUhBVi6sN8mztOiZkcgmhCe/rnpjaMvs=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a05:6214:302:: with SMTP id
 i2mr1391507qvu.14.1607712411329; Fri, 11 Dec 2020 10:46:51 -0800 (PST)
Date: Fri, 11 Dec 2020 10:46:25 -0800
In-Reply-To: <20201211184633.3213045-1-samitolvanen@google.com>
Message-Id: <20201211184633.3213045-9-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201211184633.3213045-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v9 08/16] init: lto: fix PREL32 relocations
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
2.29.2.576.ga3fc446d84-goog

