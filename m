Return-Path: <SRS0=al13=CM=lists.openwall.com=kernel-hardening-return-19736-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF95DC433E2
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:34:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 143CF20658
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:34:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bl8y7IQF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 143CF20658
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19736-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23914 invoked by uid 550); 3 Sep 2020 20:31:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23819 invoked from network); 3 Sep 2020 20:31:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=eXyK7J9+wEoy6n93pGjsemhSapgcmFl0BX/NaB/p9Jk=;
        b=bl8y7IQFLGNeyUAeZcfI04liBm2+5Zu2fhovRckS3HbShVs/pKY6yijYdoZGgjXbe9
         rnxHlZIFkhdAC3UL0J1KPXOl/qNLi62/6WiZKWSWivwBFIdb1nS7FU25EYtuAYUJmGv8
         +qz++Je0zhFE7opCb1BqdwzM2IDaUvm0cTqiaobW/Sp0ZiEVR2t6jKZvd+n2Cqqzbh8Y
         kwXyVj1GLGn4l5bafljvZKOUNQdm4i+Il6qu14szG7RRqeufJYl6I/DnRE+ba3CTgsG4
         QlyOJKGfXIwTRIG9BHfsdwEpvtfi7qErAYGP0+FUfzucydQmKqVh5VMxBUoKCqntz4Ew
         9X3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eXyK7J9+wEoy6n93pGjsemhSapgcmFl0BX/NaB/p9Jk=;
        b=Uh2EzIH/uS2htFVWd950iuU80gQ79g8zhg+r/EZlPgt6RtCOAIbpK8hTtRjI//V8Uh
         aA8QOBgtrfQGGv8DGv6c/biSwByyt4B+uFhO6vPIFeZadI6jleFsMY29alqSaKXPlc6L
         3bY6lUgImrKD0gWI2tkxg/Xd4FdxU5ucfJKoWZVCC/PMZ7/Kfeb+Q0uq7NWgzYZ+v/ns
         lPRkOmwOXtJ0Xi6zgPG9kbRl63jmiiTIvM/bQ1EdXZcx1aQ9YHIKkZP9eYVLnSqJlHqF
         pQsrKzC2gswGybA/EeGkwHkIr1iDLdHR00FcfTjGoz51lKOU1gituLwINswGTZpgIAkU
         X7Iw==
X-Gm-Message-State: AOAM531LBxEx4Vxpv8N0tulpQuHSwqOYlRJ6p0IfWP8MP8fy0tXa2Vni
	Y5IzbvcNvlcHE2bq63TC6HJ9iL3OlmwRueSdbSA=
X-Google-Smtp-Source: ABdhPJzL5rJmpcBKWDSFuqkgaUQFoP665rSkqnN6Fo73XdVlItxzzwLHKRC84PR6feaowJ2duaBg4X7jp0x4RA6WkXE=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:aab1:: with SMTP id
 t46mr4799689ybi.249.1599165090093; Thu, 03 Sep 2020 13:31:30 -0700 (PDT)
Date: Thu,  3 Sep 2020 13:30:42 -0700
In-Reply-To: <20200903203053.3411268-1-samitolvanen@google.com>
Message-Id: <20200903203053.3411268-18-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200903203053.3411268-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH v2 17/28] PCI: Fix PREL32 relocations for LTO
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

With Clang's Link Time Optimization (LTO), the compiler can rename
static functions to avoid global naming collisions. As PCI fixup
functions are typically static, renaming can break references
to them in inline assembly. This change adds a global stub to
DECLARE_PCI_FIXUP_SECTION to fix the issue when PREL32 relocations
are used.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
---
 include/linux/pci.h | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 835530605c0d..4e64421981c7 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1909,19 +1909,28 @@ enum pci_fixup_pass {
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
2.28.0.402.g5ffc5be6b7-goog

