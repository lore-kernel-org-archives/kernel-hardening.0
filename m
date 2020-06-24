Return-Path: <SRS0=LbYD=AF=lists.openwall.com=kernel-hardening-return-19113-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5531C433E2
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:33:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 48F082080C
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:33:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IfZnlNH6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48F082080C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19113-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30453 invoked by uid 550); 24 Jun 2020 20:33:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30353 invoked from network); 24 Jun 2020 20:33:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=E72RKePZ9QWe5v89HuDG9dmOi1TM58THK6MPfXGAxFQ=;
        b=IfZnlNH6VN1h5kv70OdYXiwpqxbG8Fsr0lLuwZMxg60FtsN9/VTg/yfhaEKY69+/+Y
         hyTqsTQRwHJPTGJCgx79BwJ5QVcEKyLgdthjRqbiH95tnfQghy4dm0yUNuDWrYAYeuQK
         bXlz5RTuRnG7qvLP46Ux6LdFVV3vgejq+f8vMdwP7C0ECe86rxVnbt4+28XS5oy0e//W
         3PvqoaOrjXwuF1y+TVGpByJgFdYpZGp3bhGDnuXbGiV8bnYHuHTTFlOLOu5U7PsEVYbS
         zVdr70MPwdtPFtMyvFviHewEzUoy8KN1TAyWLRedjTg9ydVnxrcpJqLiET5LocVJTpl1
         qi7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=E72RKePZ9QWe5v89HuDG9dmOi1TM58THK6MPfXGAxFQ=;
        b=TuOTGsTZHEF+Tn2ILs1ThNCKNLObGr72iX7Bnvi0GJ+Yy1w1fpkmsI3cN1NVu9DhzY
         ufBFUFEMI/AOae4hqlSRH+ALaCfAR4m/nh9GUx7tv0bdwEy/FX/tmlT/NZwdUisdWwbl
         DFN2PNrAmNBqa0wwfCo8jK7g+R1GZh/cipRqNopS65CY6QuslRtlhqBHnHfTIbLOiHIC
         TRzXXkByweM7e1NyYdGXlhIStqsbyXLhT2b77iCdeQ8/xBYeYumwVrR0eMpKtzmCGKyy
         jiyYGis+PaKPz65byehe+mm0ulqD4qGXXWVzqGpuPmvPXta54haWxcubFxfNRG3suUWI
         RrpQ==
X-Gm-Message-State: AOAM533Chpn02l1eDzSLDYF3+mHqRF5lKpAQ2xDA5Kn3sht+TwNX1VyX
	H+AFI9Gabei1FlyRMBQDOWt+O4jAIdTsY/nUh2w=
X-Google-Smtp-Source: ABdhPJzd9lgxY2ziJprOU0r6YQs1Hj+qf3c3VygR/GB4VeUCqKevsyTn5UTRuuuhSmVDqX6i9sr8ukJjhli7wtRCXdI=
X-Received: by 2002:a0c:85a3:: with SMTP id o32mr8043763qva.189.1593030786670;
 Wed, 24 Jun 2020 13:33:06 -0700 (PDT)
Date: Wed, 24 Jun 2020 13:31:43 -0700
In-Reply-To: <20200624203200.78870-1-samitolvanen@google.com>
Message-Id: <20200624203200.78870-6-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH 05/22] kbuild: lto: postpone objtool
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

With LTO, LLVM bitcode won't be compiled into native code until
modpost_link, or modfinal for modules. This change postpones calls
to objtool until after these steps.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 include/linux/compiler.h  |  2 +-
 lib/Kconfig.debug         |  2 +-
 scripts/Makefile.build    |  2 ++
 scripts/Makefile.modfinal | 15 +++++++++++++++
 4 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 30827f82ad62..12b115152532 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -120,7 +120,7 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 /* Annotate a C jump table to allow objtool to follow the code flow */
 #define __annotate_jump_table __section(.rodata..c_jump_table)
 
-#ifdef CONFIG_DEBUG_ENTRY
+#if defined(CONFIG_DEBUG_ENTRY) || defined(CONFIG_LTO_CLANG)
 /* Begin/end of an instrumentation safe region */
 #define instrumentation_begin() ({					\
 	asm volatile("%c0:\n\t"						\
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 9ad9210d70a1..9fdba71c135a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -399,7 +399,7 @@ config STACK_VALIDATION
 
 config VMLINUX_VALIDATION
 	bool
-	depends on STACK_VALIDATION && DEBUG_ENTRY && !PARAVIRT
+	depends on STACK_VALIDATION && (DEBUG_ENTRY || LTO_CLANG) && !PARAVIRT
 	default y
 
 config DEBUG_FORCE_WEAK_PER_CPU
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 64e99f4baa5b..82977350f5a6 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -226,6 +226,7 @@ endif # CC_USING_PATCHABLE_FUNCTION_ENTRY
 endif # CONFIG_FTRACE_MCOUNT_RECORD
 
 ifdef CONFIG_STACK_VALIDATION
+ifndef CONFIG_LTO_CLANG
 ifneq ($(SKIP_STACK_VALIDATION),1)
 
 __objtool_obj := $(objtree)/tools/objtool/objtool
@@ -258,6 +259,7 @@ objtool_obj = $(if $(patsubst y%,, \
 	$(__objtool_obj))
 
 endif # SKIP_STACK_VALIDATION
+endif # CONFIG_LTO_CLANG
 endif # CONFIG_STACK_VALIDATION
 
 # Rebuild all objects when objtool changes, or is enabled/disabled.
diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index d168f0cfe67c..9f1df2f1fab5 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -48,6 +48,21 @@ endif # CC_USING_PATCHABLE_FUNCTION_ENTRY
 endif # CC_USING_RECORD_MCOUNT
 endif # CONFIG_FTRACE_MCOUNT_RECORD
 
+ifdef CONFIG_STACK_VALIDATION
+ifneq ($(SKIP_STACK_VALIDATION),1)
+cmd_ld_ko_o +=								\
+	$(objtree)/tools/objtool/objtool				\
+		$(if $(CONFIG_UNWINDER_ORC),orc generate,check)		\
+		--module						\
+		$(if $(CONFIG_FRAME_POINTER),,--no-fp)			\
+		$(if $(CONFIG_GCOV_KERNEL),--no-unreachable,)		\
+		$(if $(CONFIG_RETPOLINE),--retpoline,)			\
+		$(if $(CONFIG_X86_SMAP),--uaccess,)			\
+		$(@:.ko=$(prelink-ext).o);
+
+endif # SKIP_STACK_VALIDATION
+endif # CONFIG_STACK_VALIDATION
+
 endif # CONFIG_LTO_CLANG
 
 quiet_cmd_ld_ko_o = LD [M]  $@
-- 
2.27.0.212.ge8ba1cc988-goog

