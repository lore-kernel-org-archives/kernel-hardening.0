Return-Path: <SRS0=sXbn=C3=lists.openwall.com=kernel-hardening-return-19935-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16278C43464
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:18:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 168B620684
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:18:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qgpy+pbz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 168B620684
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19935-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21741 invoked by uid 550); 18 Sep 2020 20:15:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21662 invoked from network); 18 Sep 2020 20:15:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=iG8c4IVmV6SAigaVNA/2Da1zni30786ipLEHlcLZdp4=;
        b=Qgpy+pbznAwuGgS1UcHWV2+GgEBqJBW/QXwkjniAUgd0yEt/iVnU3kXXwNdozhgQzz
         MZzhTSncTCZS90D0o8lSwmN7wmdlvsaE1QWRoTj6Wbe2nae8ffdijksuNQIIVYs/eybZ
         PhIUX9y2TjqMSdsaiGH0h2KtARkrrLOZf/w8Sm2VeQum5NJG1Sy6tVoqsuv4aAwEG7YK
         02eRqNOcpZQaCeV7Ckrk7WrJ5FjODwlvlNCDUQkrG9fITgVhDbllmG+pZNctstR4JiRy
         rA0r42k8E4pddkc8iQa3ov74ZrsmEOgVOhRYMv7EwvJEm2M2DLQUQBG2GyMEcM38Vad0
         xDlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iG8c4IVmV6SAigaVNA/2Da1zni30786ipLEHlcLZdp4=;
        b=Zot3WPvdDuXeIQExdQU7OHMcZcnvr3j8a/xLaVvX0InroG4auTyHzVd/Z9IG+J299q
         /3MzlSiimY6QnD/T0KKI+B7oAQcU8Kf7PvVck3+4mmtBA6CeHw/lwh9jdpN2WQBJpBa6
         zR7Ls/KY/AHgQW0OTLEAi1vH/9HN14mNRQRfRmXeakkPtf/feJ7FjjCGfDv2CtEI2LRE
         IpnQx+cbJ/eM6vHlJ31ec0fNxs1Mj7WAurV8n9PmRDVCL2IT3Gzy6DaVkWQVbA09tQQd
         GgXugXKNho33gPO0VjMJCBrZFGfw/3Aw612T7ItuKaFOAIPdFzcCkh+6hm4i3brE7kbV
         Phxw==
X-Gm-Message-State: AOAM53150cuDBt8iowpBMxsuBshXg1beBcihxKYRdweKkcexTGE45Zfv
	4HlnFk2TOa38Ra6RqWkBmtmcEhci3AKHNe18c5c=
X-Google-Smtp-Source: ABdhPJyAaI/eiFtDj86m6e83BVMlPsjdMZNZWL0L4WJ70VEUwFhQzIrnfngpXkviQEnEmXABI7Y2dHDcYxV6d7VeWCU=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:58c7:: with SMTP id
 dh7mr8337663qvb.20.1600460123968; Fri, 18 Sep 2020 13:15:23 -0700 (PDT)
Date: Fri, 18 Sep 2020 13:14:25 -0700
In-Reply-To: <20200918201436.2932360-1-samitolvanen@google.com>
Message-Id: <20200918201436.2932360-20-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 19/30] PCI: Fix PREL32 relocations for LTO
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
2.28.0.681.g6f77f65b4e-goog

