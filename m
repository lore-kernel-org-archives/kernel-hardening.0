Return-Path: <SRS0=lr/R=ZN=lists.openwall.com=kernel-hardening-return-17415-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4438C432C0
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 Nov 2019 18:15:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DC8C02068E
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 Nov 2019 18:15:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="nANVur5k"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC8C02068E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17415-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30200 invoked by uid 550); 21 Nov 2019 18:15:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29993 invoked from network); 21 Nov 2019 18:15:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ccHak5xmnouFPda/AWVo/lGwU/xGWHbS5K0BgsHuUQE=;
        b=nANVur5kLJlbf+6u+7VUDkKEjaiMC2PFH5e24iCf0pYkdwHtQD0NWweCruV4r8kb3e
         CcjwoSrV0Dgahhol5DLONFuh3LbyzNHH/0qWrI0YQ6vdFVp6rmeUdhnvVjKuUR2ff46N
         6iIMYjQf4aJWK8+XkAl07Qtt4SskGL3F5TRZU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ccHak5xmnouFPda/AWVo/lGwU/xGWHbS5K0BgsHuUQE=;
        b=alSDSixBRJB38ANaK4SCKzJlYXftD8pgAwcY6C2NLYZE8fYmroezvttdViu7Hy9a1v
         HbzIGltVJt51ftd8vVbdUHFabtwnoya2qlpIc8xMckAX3lcFIcXv4lL+3b7sxQ4m8E7V
         WuDfwDCg3JBZYyQp686SqXpHadNaXIxX37eG6lg89SfmT2MzGpI+oWOUKhMuGVKuWWVe
         ivH0FBfAHSuohmBf7XNsOr/tG7SwmsPJaJqBj19acx+xcXR5z6JKSRQyYkw079PwB49X
         CVtktBxOABBwWeXTl5YZXxQtxCJKpcLAFM1+FXe7lap11/DwB0sdLxqG6psZ5ubFids0
         82sg==
X-Gm-Message-State: APjAAAUqrWTiTxhWiRLOtl2xgIM0Hxd0wgKXsQxcT38sD7wQDbLFOop9
	8t27GEvuV6p6BzEXLIiNQFnetw==
X-Google-Smtp-Source: APXvYqxBltaVztxF8obBvw++HqCE/1IaQdeMeweeYTlarHq2vfh1pumYJ2FFNKeqzOLaoVxRGNOQMw==
X-Received: by 2002:a63:535c:: with SMTP id t28mr11108812pgl.173.1574360129873;
        Thu, 21 Nov 2019 10:15:29 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Elena Petrova <lenaptr@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v2 1/3] ubsan: Add trap instrumentation option
Date: Thu, 21 Nov 2019 10:15:17 -0800
Message-Id: <20191121181519.28637-2-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191121181519.28637-1-keescook@chromium.org>
References: <20191121181519.28637-1-keescook@chromium.org>

The Undefined Behavior Sanitizer can operate in two modes: warning
reporting mode via lib/ubsan.c handler calls, or trap mode, which uses
__builtin_trap() as the handler. Using lib/ubsan.c means the kernel
image is about 5% larger (due to all the debugging text and reporting
structures to capture details about the warning conditions). Using the
trap mode, the image size changes are much smaller, though at the loss
of the "warning only" mode.

In order to give greater flexibility to system builders that want
minimal changes to image size and are prepared to deal with kernel code
being aborted and potentially destabilizing the system, this introduces
CONFIG_UBSAN_TRAP. The resulting image sizes comparison:

   text    data     bss       dec       hex     filename
19533663   6183037  18554956  44271656  2a38828 vmlinux.stock
19991849   7618513  18874448  46484810  2c54d4a vmlinux.ubsan
19712181   6284181  18366540  44362902  2a4ec96 vmlinux.ubsan-trap

CONFIG_UBSAN=y:      image +4.8% (text +2.3%, data +18.9%)
CONFIG_UBSAN_TRAP=y: image +0.2% (text +0.9%, data +1.6%)

Additionally adjusts the CONFIG_UBSAN Kconfig help for clarity and
removes the mention of non-existing boot param "ubsan_handle".

Suggested-by: Elena Petrova <lenaptr@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/Kconfig.ubsan      | 22 ++++++++++++++++++----
 lib/Makefile           |  2 ++
 scripts/Makefile.ubsan |  9 +++++++--
 3 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/lib/Kconfig.ubsan b/lib/Kconfig.ubsan
index 0e04fcb3ab3d..9deb655838b0 100644
--- a/lib/Kconfig.ubsan
+++ b/lib/Kconfig.ubsan
@@ -5,11 +5,25 @@ config ARCH_HAS_UBSAN_SANITIZE_ALL
 config UBSAN
 	bool "Undefined behaviour sanity checker"
 	help
-	  This option enables undefined behaviour sanity checker
+	  This option enables the Undefined Behaviour sanity checker.
 	  Compile-time instrumentation is used to detect various undefined
-	  behaviours in runtime. Various types of checks may be enabled
-	  via boot parameter ubsan_handle
-	  (see: Documentation/dev-tools/ubsan.rst).
+	  behaviours at runtime. For more details, see:
+	  Documentation/dev-tools/ubsan.rst
+
+config UBSAN_TRAP
+	bool "On Sanitizer warnings, abort the running kernel code"
+	depends on UBSAN
+	depends on $(cc-option, -fsanitize-undefined-trap-on-error)
+	help
+	  Building kernels with Sanitizer features enabled tends to grow
+	  the kernel size by around 5%, due to adding all the debugging
+	  text on failure paths. To avoid this, Sanitizer instrumentation
+	  can just issue a trap. This reduces the kernel size overhead but
+	  turns all warnings (including potentially harmless conditions)
+	  into full exceptions that abort the running kernel code
+	  (regardless of context, locks held, etc), which may destabilize
+	  the system. For some system builders this is an acceptable
+	  trade-off.
 
 config UBSAN_SANITIZE_ALL
 	bool "Enable instrumentation for the entire kernel"
diff --git a/lib/Makefile b/lib/Makefile
index c5892807e06f..bc498bf0f52d 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -272,7 +272,9 @@ quiet_cmd_build_OID_registry = GEN     $@
 clean-files	+= oid_registry_data.c
 
 obj-$(CONFIG_UCS2_STRING) += ucs2_string.o
+ifneq ($(CONFIG_UBSAN_TRAP),y)
 obj-$(CONFIG_UBSAN) += ubsan.o
+endif
 
 UBSAN_SANITIZE_ubsan.o := n
 KASAN_SANITIZE_ubsan.o := n
diff --git a/scripts/Makefile.ubsan b/scripts/Makefile.ubsan
index 019771b845c5..668a91510bfe 100644
--- a/scripts/Makefile.ubsan
+++ b/scripts/Makefile.ubsan
@@ -1,5 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
 ifdef CONFIG_UBSAN
+
+ifdef CONFIG_UBSAN_ALIGNMENT
+      CFLAGS_UBSAN += $(call cc-option, -fsanitize=alignment)
+endif
+
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=shift)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=integer-divide-by-zero)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=unreachable)
@@ -9,8 +14,8 @@ ifdef CONFIG_UBSAN
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=bool)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=enum)
 
-ifdef CONFIG_UBSAN_ALIGNMENT
-      CFLAGS_UBSAN += $(call cc-option, -fsanitize=alignment)
+ifdef CONFIG_UBSAN_TRAP
+      CFLAGS_UBSAN += $(call cc-option, -fsanitize-undefined-trap-on-error)
 endif
 
       # -fsanitize=* options makes GCC less smart than usual and
-- 
2.17.1

