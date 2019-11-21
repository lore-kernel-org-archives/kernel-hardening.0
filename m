Return-Path: <SRS0=WYVU=ZN=lists.openwall.com=kernel-hardening-return-17416-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6155EC432C0
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 Nov 2019 18:16:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B18E6206CB
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 Nov 2019 18:16:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KrN4zpR8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B18E6206CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17416-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30322 invoked by uid 550); 21 Nov 2019 18:15:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30035 invoked from network); 21 Nov 2019 18:15:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JQs/4UxemMcGCjHZn4niB7nA1rMhXtjAz7kJK3AjL7E=;
        b=KrN4zpR8IEwpUQr4jn2KWwjZqUoeisnx3Am9Bp+lgiRIdx5345vx29iTTUFknjeFFQ
         Rj9A+pMLGH7kZeXTTYnjwo6xAzbqdCNRhagoYp/K8ogsyNX8Xx9jAt66FmI5COUA2UiY
         gHkW3zyflbmt4IHuKfJMdE/2YCaQqpLZhk71I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JQs/4UxemMcGCjHZn4niB7nA1rMhXtjAz7kJK3AjL7E=;
        b=Wlakjf47LX+gtGuiG4YMfrh9EClE+osCBpBQq5BSgqqNDp5i2y78bOt7hu0aN515ut
         KHWNPGAGHegC5DiaODEYgJ2gts6xfm0XmmFD26dU2VNPaW9lhQoWXKB0xL1Z3v6TRwHs
         kOy6Wmi5sF7+//LQerHaKIWyl4SclGOEePZGpinP2lyersEhvmGRVV/g0k/qh2BPlv4B
         aSiYoel5FukYPDYc9OAX2ZiaISWjC8C8VvaHKuTMfbnzvh7aedm9pVGA+ANv1V/dLGCu
         zAR2C/v3cZRvJnuBAZxM1q82ILczMldRYCnSqB/JKySrGPjVtnS/XJm2CDR/dr677jH8
         vO/g==
X-Gm-Message-State: APjAAAX1z0FksCX07UtUmZU4V7uskh0lhWVrCc7UKsHhAbQ4u4lszLyE
	V5Ku3PnPqRHrhxLswzv59MguZw==
X-Google-Smtp-Source: APXvYqwbG0mlD3ppkkL3k31yuwYGe/H5GA3+ceT+WKtRCMUFj+fEDoGxidbBeBr46DZ2WJ27O5jcgg==
X-Received: by 2002:a65:66c7:: with SMTP id c7mr10861530pgw.407.1574360130724;
        Thu, 21 Nov 2019 10:15:30 -0800 (PST)
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
Subject: [PATCH v2 2/3] ubsan: Split "bounds" checker from other options
Date: Thu, 21 Nov 2019 10:15:18 -0800
Message-Id: <20191121181519.28637-3-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191121181519.28637-1-keescook@chromium.org>
References: <20191121181519.28637-1-keescook@chromium.org>

In order to do kernel builds with the bounds checker individually
available, introduce CONFIG_UBSAN_BOUNDS, with the remaining options
under CONFIG_UBSAN_MISC.

For example, using this, we can start to expand the coverage syzkaller is
providing. Right now, all of UBSan is disabled for syzbot builds because
taken as a whole, it is too noisy. This will let us focus on one feature
at a time.

For the bounds checker specifically, this provides a mechanism to
eliminate an entire class of array overflows with close to zero
performance overhead (I cannot measure a difference). In my (mostly)
defconfig, enabling bounds checking adds ~4200 checks to the kernel.
Performance changes are in the noise, likely due to the branch predictors
optimizing for the non-fail path.

Some notes on the bounds checker:

- it does not instrument {mem,str}*()-family functions, it only
  instruments direct indexed accesses (e.g. "foo[i]"). Dealing with
  the {mem,str}*()-family functions is a work-in-progress around
  CONFIG_FORTIFY_SOURCE[1].

- it ignores flexible array members, including the very old single
  byte (e.g. "int foo[1];") declarations. (Note that GCC's
  implementation appears to ignore _all_ trailing arrays, but Clang only
  ignores empty, 0, and 1 byte arrays[2].)

[1] https://github.com/KSPP/linux/issues/6
[2] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=92589

Suggested-by: Elena Petrova <lenaptr@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 lib/Kconfig.ubsan      | 20 ++++++++++++++++++++
 scripts/Makefile.ubsan |  7 ++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/lib/Kconfig.ubsan b/lib/Kconfig.ubsan
index 9deb655838b0..9b9f76d1a3f7 100644
--- a/lib/Kconfig.ubsan
+++ b/lib/Kconfig.ubsan
@@ -25,6 +25,26 @@ config UBSAN_TRAP
 	  the system. For some system builders this is an acceptable
 	  trade-off.
 
+config UBSAN_BOUNDS
+	bool "Perform array index bounds checking"
+	depends on UBSAN
+	default UBSAN
+	help
+	  This option enables detection of directly indexed out of bounds
+	  array accesses, where the array size is known at compile time.
+	  Note that this does not protect array overflows via bad calls
+	  to the {str,mem}*cpy() family of functions (that is addressed
+	  by CONFIG_FORTIFY_SOURCE).
+
+config UBSAN_MISC
+	bool "Enable all other Undefined Behavior sanity checks"
+	depends on UBSAN
+	default UBSAN
+	help
+	  This option enables all sanity checks that don't have their
+	  own Kconfig options. Disable this if you only want to have
+	  individually selected checks.
+
 config UBSAN_SANITIZE_ALL
 	bool "Enable instrumentation for the entire kernel"
 	depends on UBSAN
diff --git a/scripts/Makefile.ubsan b/scripts/Makefile.ubsan
index 668a91510bfe..5b15bc425ec9 100644
--- a/scripts/Makefile.ubsan
+++ b/scripts/Makefile.ubsan
@@ -5,14 +5,19 @@ ifdef CONFIG_UBSAN_ALIGNMENT
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=alignment)
 endif
 
+ifdef CONFIG_UBSAN_BOUNDS
+      CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
+endif
+
+ifdef CONFIG_UBSAN_MISC
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=shift)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=integer-divide-by-zero)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=unreachable)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=signed-integer-overflow)
-      CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=object-size)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=bool)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=enum)
+endif
 
 ifdef CONFIG_UBSAN_TRAP
       CFLAGS_UBSAN += $(call cc-option, -fsanitize-undefined-trap-on-error)
-- 
2.17.1

