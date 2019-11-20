Return-Path: <SRS0=jjiB=ZM=lists.openwall.com=kernel-hardening-return-17404-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D4AC432C0
	for <kernel-hardening@archiver.kernel.org>; Wed, 20 Nov 2019 01:07:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D3F1420708
	for <kernel-hardening@archiver.kernel.org>; Wed, 20 Nov 2019 01:07:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Dl72hrPu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3F1420708
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17404-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25791 invoked by uid 550); 20 Nov 2019 01:06:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24562 invoked from network); 20 Nov 2019 01:06:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Qk+ofBX2bx2BOGB4TqoJ+/VT2N5xkCBYGbqC21Di0lw=;
        b=Dl72hrPuwamrfPqyV6plvaUBtf5zRowEghIpoZqmgJgFOczuF7EKzjTanI6iefsS9Z
         9TvygmIVih8TjwrgaGRcecyP/tDTc7gHkW1za6Qsa+kQOjj0UpGf+owodcIUwPQ/ZSDu
         QgLC6/NCcIR5lG7LQGAW6FZc2y8odHX4FtywQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Qk+ofBX2bx2BOGB4TqoJ+/VT2N5xkCBYGbqC21Di0lw=;
        b=N4XlaO1KwOUk5LzqSY2QnX0XFOFkZdjCs9OT+TXgLu2cPAHJHe45Y3Rt4/Z9f5pu0W
         59tOqw07/BbRmKp0OPAjzKM/AjG7p27POMtlhfKSHz4EffwIN4mt2JbIpOS3N/2+enAD
         aIzZyviV5dGa2wxYjF25CIv1WpAVXrYIXJUT8jxEDgJUBxx7FT6o8Qd1G2lVNz6ktKJt
         KfVskm467nF4juXF3aacZ1ToAcwh3Plku+AbM5S7knoEDld9xwMFyRAJC0xQAum6Phpu
         MhSYTTpTJeHQmI+5LsLhrS5LbMMhqDkFCkV4iRpWfU46MwJ3uy6+98DvuC4e6lwxDC8T
         Uq/g==
X-Gm-Message-State: APjAAAWLRGSv+PZBPVXtt109hif+PUO7CPQrm5GKCUEwNfwUyd5LiJmw
	80MJyAyhJ/LQzlh5eKpjlhlQdA==
X-Google-Smtp-Source: APXvYqwU4vILON4RTm6tdSJVl700JzP/ajHyi1fFkaWh7maGAK9WWWqyZPY7AO1vwzjH8oRIUlhNnw==
X-Received: by 2002:a63:5d10:: with SMTP id r16mr80693pgb.41.1574212003024;
        Tue, 19 Nov 2019 17:06:43 -0800 (PST)
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
Subject: [PATCH 2/3] ubsan: Split "bounds" checker from other options
Date: Tue, 19 Nov 2019 17:06:35 -0800
Message-Id: <20191120010636.27368-3-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191120010636.27368-1-keescook@chromium.org>
References: <20191120010636.27368-1-keescook@chromium.org>

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
---
 lib/Kconfig.ubsan      | 19 +++++++++++++++++++
 scripts/Makefile.ubsan |  7 ++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/lib/Kconfig.ubsan b/lib/Kconfig.ubsan
index d69e8b21ebae..f5ed2dceef30 100644
--- a/lib/Kconfig.ubsan
+++ b/lib/Kconfig.ubsan
@@ -22,6 +22,25 @@ config UBSAN_TRAP
 	  can just issue a trap. This reduces the kernel size overhead but
 	  turns all warnings into full thread-killing exceptions.
 
+config UBSAN_BOUNDS
+	bool "Perform array bounds checking"
+	depends on UBSAN
+	default UBSAN
+	help
+	  This option enables detection of direct out of bounds array
+	  accesses, where the array size is known at compile time. Note
+	  that this does not protect character array overflows due to
+	  bad calls to the {str,mem}*cpy() family of functions.
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

