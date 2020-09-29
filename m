Return-Path: <SRS0=2hho=DG=lists.openwall.com=kernel-hardening-return-20049-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.9 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F632C4727C
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:49:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 95AF72076D
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:49:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MekhgGdQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95AF72076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20049-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32720 invoked by uid 550); 29 Sep 2020 21:47:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32596 invoked from network); 29 Sep 2020 21:47:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=5ADrbIYYdkQ2THetWVdXFRMGM/F7dNAyZUNR6Ura+J8=;
        b=MekhgGdQDfVYCDwXqPqLOmRuR7bDrOrx74bKs36BEL9DMLEqc3GHdIW78xNvVW+CXD
         OBR1TA7PPlKp15z5Yvt6TGU00YrPE6jEVmJU2/BObk6f58edi9mDYneayNLG3BF+85eI
         JjVCIO2RNOdO/LFMDVGntOPmSZ80VCfWnW6rDxt2eRzeZ6jXgiYTuMIacuHOI7Agk84Q
         /EqGu8oBcu0EPNuoFAiQuSJKYV61YqkH23yEvB8gadt3EGDYNx7DqA1r7P5qUmqJEEld
         mLCeOrbo1nSD3wVfre9ST4vF2Q7dHDbNvEpQKR0fdUlOz46fHVxsu7B8etms0FiNNoqi
         jwIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5ADrbIYYdkQ2THetWVdXFRMGM/F7dNAyZUNR6Ura+J8=;
        b=bbHclBrX71Opah54mioWMmPu12MA5JNkJz4v76nG8weRVznuDhagUavkfwDN66illi
         qOHoSsimkwXN9XQeN2t10KyBBxKoaPH5nbqWI8EtSXhEHE1cTWe+5ca/dgJFyEIAAx10
         1iZ3Q1HZ5PY2RGs+BPrcrck/r+m2k1WIeNrlAs6OUJc89vI/ZDpihlDF1N96yCbLgL7T
         f6AeqQPeYnwhpa0pG238Db/2yznruj01P7qFdYzLDYpwOI9GrzyIVcHRPDqsN++FDXuZ
         jLyp/BOhsSjKoiwDmuCxe4XYpTxVJCgBkEeFiCyK+/nzod0kEb5t8I0x1jcId1jwJGdg
         Zy8g==
X-Gm-Message-State: AOAM533bAj8ez4ohuh/dTv4eBPwXu8COnRAvmnW5nmTlomzs2nfWzFsU
	n/ePpDGc8VaCx6mZsFybj/3t2qJ/7ay3YAUQ7U4=
X-Google-Smtp-Source: ABdhPJyEka8NWg0904uGqV+IPTNA4hO1MufGCj8cRerlSixJNEwhSMmuf5P+grySLqv5SKpAniKp5seVaNsVmut9k5g=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a63:ff63:: with SMTP id
 s35mr4883241pgk.14.1601416036594; Tue, 29 Sep 2020 14:47:16 -0700 (PDT)
Date: Tue, 29 Sep 2020 14:46:21 -0700
In-Reply-To: <20200929214631.3516445-1-samitolvanen@google.com>
Message-Id: <20200929214631.3516445-20-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200929214631.3516445-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH v4 19/29] PCI: Fix PREL32 relocations for LTO
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
2.28.0.709.gb0816b6eb0-goog

