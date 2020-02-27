Return-Path: <SRS0=GMpp=4P=lists.openwall.com=kernel-hardening-return-17985-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE4C9C11D3D
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Feb 2020 19:35:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E573C2468E
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Feb 2020 19:35:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="fhU4ZWts"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E573C2468E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17985-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1571 invoked by uid 550); 27 Feb 2020 19:35:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1498 invoked from network); 27 Feb 2020 19:35:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TZN5E5934TvMDmRyA6YbiUZA3oVW+HYGx9jzlGs1fas=;
        b=fhU4ZWtsMwSX2mupe2qPd38EZqvMNduMdASxFGXOeV4vpARzuW/YSPVaTMFGN08Hhc
         XliIaYkwUiNY8jqwNeYkG4jQoqhhnqvlU2l4wKiF6qSNMzXt1xWnxElExOLM5ZL41m7y
         Z7z1AWZH5EHP1O9W7xlNQcsJwhj4eFUdEyy5Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TZN5E5934TvMDmRyA6YbiUZA3oVW+HYGx9jzlGs1fas=;
        b=dXTYpVYOwKzjq+I9xEvErAbE5cigJcNCDxEb1w0aWdqfr7LY9Zaz01FIoun3tVro6T
         8HFktRloN4/ArzDk+skHlphyMsah4tJfgNhVg309ZuRO/4PQ36a9GTlCbuPhWP7Ndba0
         P3sEj7g8+xiFIMW0pF8gxacor2R14eW2Kfr6R1dLXzI2G6YmfTKbT2QZIB7dtUBIVc5y
         9az3gFyF3TE3BMlmWwhuUgITCPwlfVmp8eQllwGS0zMiao8luCcGa7KL7wQ9M1elakWe
         j7zFyP9rnWjO72qvjqW9jT3IoCT6I0/u3rSPOzJ6Y1N+eZ116SzEAhYorkO54eEzhrrO
         clbA==
X-Gm-Message-State: APjAAAU8mwTew5FbuO6D8SfZ/enqL2F2tHVbbs+SzsQYfXSAVy0qhgRz
	KOAlaPdNb6LzZFBBn06fyF9sTQ==
X-Google-Smtp-Source: APXvYqy8bVQH818HJGFZc2ql+d1GQcz5CnyZ/Lu/Mb9ddeqTtnjcaB2N07vWUnQwqSXTy5cLxuMyQA==
X-Received: by 2002:a17:902:7048:: with SMTP id h8mr383251plt.64.1582832122570;
        Thu, 27 Feb 2020 11:35:22 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>,
	Elena Petrova <lenaptr@google.com>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrey Konovalov <andreyknvl@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	syzkaller@googlegroups.com
Subject: [PATCH v5 2/6] ubsan: Split "bounds" checker from other options
Date: Thu, 27 Feb 2020 11:35:12 -0800
Message-Id: <20200227193516.32566-3-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200227193516.32566-1-keescook@chromium.org>
References: <20200227193516.32566-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
Acked-by: Dmitry Vyukov <dvyukov@google.com>
---
 lib/Kconfig.ubsan      | 29 ++++++++++++++++++++++++-----
 scripts/Makefile.ubsan |  7 ++++++-
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/lib/Kconfig.ubsan b/lib/Kconfig.ubsan
index 9deb655838b0..48469c95d78e 100644
--- a/lib/Kconfig.ubsan
+++ b/lib/Kconfig.ubsan
@@ -2,7 +2,7 @@
 config ARCH_HAS_UBSAN_SANITIZE_ALL
 	bool
 
-config UBSAN
+menuconfig UBSAN
 	bool "Undefined behaviour sanity checker"
 	help
 	  This option enables the Undefined Behaviour sanity checker.
@@ -10,9 +10,10 @@ config UBSAN
 	  behaviours at runtime. For more details, see:
 	  Documentation/dev-tools/ubsan.rst
 
+if UBSAN
+
 config UBSAN_TRAP
 	bool "On Sanitizer warnings, abort the running kernel code"
-	depends on UBSAN
 	depends on $(cc-option, -fsanitize-undefined-trap-on-error)
 	help
 	  Building kernels with Sanitizer features enabled tends to grow
@@ -25,9 +26,26 @@ config UBSAN_TRAP
 	  the system. For some system builders this is an acceptable
 	  trade-off.
 
+config UBSAN_BOUNDS
+	bool "Perform array index bounds checking"
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
+	default UBSAN
+	help
+	  This option enables all sanity checks that don't have their
+	  own Kconfig options. Disable this if you only want to have
+	  individually selected checks.
+
 config UBSAN_SANITIZE_ALL
 	bool "Enable instrumentation for the entire kernel"
-	depends on UBSAN
 	depends on ARCH_HAS_UBSAN_SANITIZE_ALL
 
 	# We build with -Wno-maybe-uninitilzed, but we still want to
@@ -44,7 +62,6 @@ config UBSAN_SANITIZE_ALL
 
 config UBSAN_NO_ALIGNMENT
 	bool "Disable checking of pointers alignment"
-	depends on UBSAN
 	default y if HAVE_EFFICIENT_UNALIGNED_ACCESS
 	help
 	  This option disables the check of unaligned memory accesses.
@@ -57,7 +74,9 @@ config UBSAN_ALIGNMENT
 
 config TEST_UBSAN
 	tristate "Module for testing for undefined behavior detection"
-	depends on m && UBSAN
+	depends on m
 	help
 	  This is a test module for UBSAN.
 	  It triggers various undefined behavior, and detect it.
+
+endif	# if UBSAN
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
2.20.1

