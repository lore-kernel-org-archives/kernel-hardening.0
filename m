Return-Path: <SRS0=TnjF=DQ=lists.openwall.com=kernel-hardening-return-20148-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51CC2C433DF
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:17:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 70CF32222F
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:17:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E5G/sJ81"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 70CF32222F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20148-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 6119 invoked by uid 550); 9 Oct 2020 16:14:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 6031 invoked from network); 9 Oct 2020 16:14:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=b5rCnYz4obhAgpKHq4mgEn5Hvv5UPGIbAlGkTv5aKg4=;
        b=E5G/sJ81fFEbU3UrV/4DwBfDWW8suW611A0G6/DwYfbR04ohtV708reO0SJgwS2rf7
         bSqsXq3OjK2yL1hKhQfhwZRZ5aBj98+xPOc+UFD8lX0GapobLOFhUzyy2r2Ix8ArAd0p
         mGmDn3PZkPNl1b/DlynJoS1L8xMBaXaj6SJ35+lWUlg4xMQamvtjXzlzzct2MoZ5wPyM
         MNKTdnp/zeU1v9mmBSvDZzYwOLTZJr2sWDxiglMg0b83/FZMs4lgJsucTLS60ojx171N
         0Z36nkDB3h5N6Ml8sbsV3TfqqbNBcSFUY1hiHFHCfLLxtVk4pfMm91HtyPzFHHq4SRa4
         QS5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=b5rCnYz4obhAgpKHq4mgEn5Hvv5UPGIbAlGkTv5aKg4=;
        b=e2uPbGEizSr7y/IdhPZXhOxrleW1gv8bLcIOxKXquUWGpZFQ/PJCcvNpqnjcorsv4/
         LHkJiZANLIlIXLN7zYvXfwURmjvbA+Xn9AKG8hU02YcVo0IXjOaH1DYS+47VlSThKs4T
         BukjtBvhnmsPcfYnVrHK1koCppQQHv2DaYvFn6wzK8UQ3aGkNc2onI5ZBiZAvZ0tZk3m
         IQ5eXINCOv9JqbLkMK7OTQqMTrF8dHbbZi5G0KbF+caPE4qGq53JCbZUpzoHSK5Y63An
         xtWaRNcBUomM66a89ohI9BCnWBo5goaqC7Q87rjHstSV18HE1OGM4vkyXWSHIDAhv6gJ
         g+wA==
X-Gm-Message-State: AOAM532X6ABOcplPd4IfQWMGhgGo5EKBDDZftoHb87/ySSDSWK3glGXK
	RR/hYeDeZJKhieaukusCBHjjB2WR2/E3Nrbdw64=
X-Google-Smtp-Source: ABdhPJxUsLNRYd2SDtvgB7CmXqlcp3vGOaCoLMxBFjkUgYB81ry88e1Q7zWE2vdzY9Ol+dTKaZMDIAjVS73Q6wHF4BA=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a05:6214:122a:: with SMTP id
 p10mr14125090qvv.0.1602260054668; Fri, 09 Oct 2020 09:14:14 -0700 (PDT)
Date: Fri,  9 Oct 2020 09:13:26 -0700
In-Reply-To: <20201009161338.657380-1-samitolvanen@google.com>
Message-Id: <20201009161338.657380-18-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201009161338.657380-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v5 17/29] PCI: Fix PREL32 relocations for LTO
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
2.28.0.1011.ga647a8990f-goog

