Return-Path: <SRS0=QC6N=EY=lists.openwall.com=kernel-hardening-return-20415-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C327C56201
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Nov 2020 22:09:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 568CA2054F
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Nov 2020 22:09:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nd7GPjj0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 568CA2054F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20415-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 4083 invoked by uid 550); 18 Nov 2020 22:08:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 4007 invoked from network); 18 Nov 2020 22:08:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=bMl2xGwOyye8qFQQO5LhDpDmrDsCMs58eGZcnuWlmjA=;
        b=Nd7GPjj0ywkFIgMBmhds53YYdSle4acSaIFPLbVd61W8stSkNuoz0WxEayV/OD+juR
         7iFFwAf5WeBqFMYZtbNZKvYarFFEIh0TRBfk8yozSVYTyizaOQn7nV/yOM5qfxhN6W3x
         F41WPEwVNkENBqTup7x2SW7FaXclkPY/jek8JoLFOskeSCczH+BvXJtXBg4dfeqkMd7O
         5Jgsz0yx51vX7weJ6s9P7KIXrk46KNMTxH11C5CzpPEqWRCRyIwkXB16YTNgAiWSsV8M
         KuNdy4S5hjgNwFDrtraKFHI+LKTEBWBcWNWdPZnYpkQRqJAXNOz0JKEptCIRYdyLVRVY
         EmzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bMl2xGwOyye8qFQQO5LhDpDmrDsCMs58eGZcnuWlmjA=;
        b=OfFQiELKa787PwBMiz6Wf70S7XmR7AMrEFSvZZotcUFGEdtgrfB4TOngCvkx0Uab+r
         rfCnvWE17CjqT3GGCZ84Q2z5hBdX+tTNTmA3vOzzbr7jwtTymXkOOyVKt4St8RI+8lYg
         FuYbF98R3EQpfkYwTXWXU5BasXG9am7OjKu9gjhSN4yU/gND+RMU9JTmhucvYXiszYXt
         L8XPUkfbFZC2b+NlOKjmw+X+juCyytXtX6GapH6TiOokzRp/5WJwb7GyYUAfQYseIX1a
         ndJGCLNSi2PwFvr2jHNLczqx3QLP3lqrsIQo2OW2ondc80yLA3z9Lmz0sSx4/6YKFnEe
         76gQ==
X-Gm-Message-State: AOAM530n5jHkw+uyf8c2rJfBe2VFAnje789SBWghK9VwzhvNzghoF0og
	2UZ3NSjq5N817A598VCrk+UEW6gvccKPOMrmRxg=
X-Google-Smtp-Source: ABdhPJw3XblGH0ype4DsebvgJ6qN/grSpkQ1FW0TAdSpMqPujHMfKBlR5uzuC4pXuA1vl9up5ivNoLV3rdGadkF867U=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a0c:a94b:: with SMTP id
 z11mr3035952qva.24.1605737272927; Wed, 18 Nov 2020 14:07:52 -0800 (PST)
Date: Wed, 18 Nov 2020 14:07:23 -0800
In-Reply-To: <20201118220731.925424-1-samitolvanen@google.com>
Message-Id: <20201118220731.925424-10-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH v7 09/17] PCI: Fix PREL32 relocations for LTO
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

With Clang's Link Time Optimization (LTO), the compiler can rename
static functions to avoid global naming collisions. As PCI fixup
functions are typically static, renaming can break references
to them in inline assembly. This change adds a global stub to
DECLARE_PCI_FIXUP_SECTION to fix the issue when PREL32 relocations
are used.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 include/linux/pci.h | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 22207a79762c..5b8505a5ca5f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1912,19 +1912,28 @@ enum pci_fixup_pass {
 };
 
 #ifdef CONFIG_HAVE_ARCH_PREL32_RELOCATIONS
-#define __DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
-				    class_shift, hook)			\
-	__ADDRESSABLE(hook)						\
+#define ___DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
+				    class_shift, hook, stub)		\
+	void stub(struct pci_dev *dev);					\
+	void stub(struct pci_dev *dev)					\
+	{ 								\
+		hook(dev); 						\
+	}								\
 	asm(".section "	#sec ", \"a\"				\n"	\
 	    ".balign	16					\n"	\
 	    ".short "	#vendor ", " #device "			\n"	\
 	    ".long "	#class ", " #class_shift "		\n"	\
-	    ".long "	#hook " - .				\n"	\
+	    ".long "	#stub " - .				\n"	\
 	    ".previous						\n");
+
+#define __DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
+				  class_shift, hook, stub)		\
+	___DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
+				  class_shift, hook, stub)
 #define DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
 				  class_shift, hook)			\
 	__DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
-				  class_shift, hook)
+				  class_shift, hook, __UNIQUE_ID(hook))
 #else
 /* Anonymous variables would be nice... */
 #define DECLARE_PCI_FIXUP_SECTION(section, name, vendor, device, class,	\
-- 
2.29.2.299.gdc1121823c-goog

