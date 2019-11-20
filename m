Return-Path: <SRS0=yFvW=ZM=lists.openwall.com=kernel-hardening-return-17406-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E62C5C432C0
	for <kernel-hardening@archiver.kernel.org>; Wed, 20 Nov 2019 01:07:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3BEDD2245C
	for <kernel-hardening@archiver.kernel.org>; Wed, 20 Nov 2019 01:07:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="GjW65mTR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BEDD2245C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17406-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26020 invoked by uid 550); 20 Nov 2019 01:06:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25793 invoked from network); 20 Nov 2019 01:06:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cO8TBOltsH4skyCZjRFi1jjLHEcJb6wGQF3Nty2AFlw=;
        b=GjW65mTRpHcwke1tPpXJc+tEroqq+/c02L1weluBXv2HYDmUvuJroQHtjQB47mZ+Dq
         XrKKO4SSKAvPWN92dzPW6/GSh6v84X+1ecqKm5cP0W3j1AZS9WEFrXlA9digFiGFRewB
         KhiECAt/oiWz0Q2+iz92oxoX7RzTYeQrdzJTo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cO8TBOltsH4skyCZjRFi1jjLHEcJb6wGQF3Nty2AFlw=;
        b=Klu8EFKd70LrRc0VHyGe6tqhpFFuTFoEzchVq3FApjpNl7agzBvR1+NGvqczKv34kV
         BtbpSTmW9ToFbyNIzP28X1JE6bglIsI9Wg10tmf2MPJrZN/MJM2d+mptovatZ8f8G97c
         DDFCgxOuRXrTmLnEpy520465fpo8OWv/26DXzcoPn8jNnH8Qk8sLpp2enYJTVDjLenNS
         dnRpcWYAHnp6iZb3AJ+sYKHegenoTouWW+Fnn/FgeTfWrh8YOedH1Y1Uw9Uyi008aTpX
         8lupWVf/2f88xPCVtAhoN9YpXjfbCcLZHg9DviTaLk8yYB5PrNMn3E+lX29b7eEBXwHp
         dHYQ==
X-Gm-Message-State: APjAAAUJzGl3isCVXiZfOc1YBcXDU8AbbfHC9IOHhX0DQ0RAY7nHXf9i
	LPxdjUoriOYXUe8Qw9T7ZKFMGA==
X-Google-Smtp-Source: APXvYqyASvZYvBQ/e7CI9HnVv6bkAWB/563LT5YKo0qEsvHWgg7DJbmwdBC/nFhsf8xhjPvdZtXPKw==
X-Received: by 2002:aa7:9f89:: with SMTP id z9mr651850pfr.123.1574212004404;
        Tue, 19 Nov 2019 17:06:44 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Kees Cook <keescook@chromium.org>,
	Elena Petrova <lenaptr@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH 1/3] ubsan: Add trap instrumentation option
Date: Tue, 19 Nov 2019 17:06:34 -0800
Message-Id: <20191120010636.27368-2-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191120010636.27368-1-keescook@chromium.org>
References: <20191120010636.27368-1-keescook@chromium.org>

The Undefined Behavior Sanitizer can operate in two modes: warning
reporting mode via lib/ubsan.c handler calls, or trap mode, which uses
__builtin_trap() as the handler. Using lib/ubsan.c means the kernel
image is about 5% larger (due to all the debugging text and reporting
structures to capture details about the warning conditions). Using the
trap mode, the image size changes are much smaller, though at the loss
of the "warning only" mode.

In order to give greater flexibility to system builders that want
minimal changes to image size and are prepared to deal with kernel
threads being killed, this introduces CONFIG_UBSAN_TRAP. The resulting
image sizes comparison:

   text    data     bss       dec       hex     filename
19533663   6183037  18554956  44271656  2a38828 vmlinux.stock
19991849   7618513  18874448  46484810  2c54d4a vmlinux.ubsan
19712181   6284181  18366540  44362902  2a4ec96 vmlinux.ubsan-trap

CONFIG_UBSAN=y:      image +4.8% (text +2.3%, data +18.9%)
CONFIG_UBSAN_TRAP=y: image +0.2% (text +0.9%, data +1.6%)

Suggested-by: Elena Petrova <lenaptr@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/Kconfig.ubsan      | 15 +++++++++++++--
 lib/Makefile           |  2 ++
 scripts/Makefile.ubsan |  9 +++++++--
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/lib/Kconfig.ubsan b/lib/Kconfig.ubsan
index 0e04fcb3ab3d..d69e8b21ebae 100644
--- a/lib/Kconfig.ubsan
+++ b/lib/Kconfig.ubsan
@@ -5,12 +5,23 @@ config ARCH_HAS_UBSAN_SANITIZE_ALL
 config UBSAN
 	bool "Undefined behaviour sanity checker"
 	help
-	  This option enables undefined behaviour sanity checker
+	  This option enables undefined behaviour sanity checker.
 	  Compile-time instrumentation is used to detect various undefined
-	  behaviours in runtime. Various types of checks may be enabled
+	  behaviours at runtime. Various types of checks may be enabled
 	  via boot parameter ubsan_handle
 	  (see: Documentation/dev-tools/ubsan.rst).
 
+config UBSAN_TRAP
+	bool "On Sanitizer warnings, stop the offending kernel thread"
+	depends on UBSAN
+	depends on $(cc-option, -fsanitize-undefined-trap-on-error)
+	help
+	  Building kernels with Sanitizer features enabled tends to grow
+	  the kernel size by over 5%, due to adding all the debugging
+	  text on failure paths. To avoid this, Sanitizer instrumentation
+	  can just issue a trap. This reduces the kernel size overhead but
+	  turns all warnings into full thread-killing exceptions.
+
 config UBSAN_SANITIZE_ALL
 	bool "Enable instrumentation for the entire kernel"
 	depends on UBSAN
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

