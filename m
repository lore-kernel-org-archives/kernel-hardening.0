Return-Path: <SRS0=X6fq=AF=lists.openwall.com=kernel-hardening-return-19122-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD7DC433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:35:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0E0A920578
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:35:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QHLFKZjz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E0A920578
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19122-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1432 invoked by uid 550); 24 Jun 2020 20:33:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1350 invoked from network); 24 Jun 2020 20:33:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=063/REsTpnFRr+cDI+sseVhgFckW5SG29uiho3UNZTY=;
        b=QHLFKZjziQv1B4lTQJOFrFkeBBeD3vqMRAW+KU8uSJ0z8P5diTku752ppGYK+p1sHj
         Tuqj5FmieFc5zewP3DRNS5iM40Pga5Yd012RZ1UJSub9OeGcQ/BjM9Xhswo2S+wawZKA
         RoZrP4AKzJhPxHnp2kwUEq2iAcWJC9Jvd0o41DT/D0J5C0PT78vt0tH2KpFNFHvjKqOE
         izzBiEOpzdtuThxfwOEyO+K5m3BsSaqVWi7OpscZsOWnWe/8qa7rh4O22Mfte1SMk6Qe
         rW+Cnirb92ArG8+1lDPtjHVyv4CvsFhD6/kzdDW605IdVtQymCiQD3WRRYOvRlD/Mv+p
         36IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=063/REsTpnFRr+cDI+sseVhgFckW5SG29uiho3UNZTY=;
        b=KUzoSMwCBNyusqRNjKfFXjbh7fzzKBr4SV1jxR+GSkGiH1QL/H8MYg4y8U6EPmtGnG
         Mcv6ceEz5hVtqEe/C+Zo5Fu/G8P7e/n9fVQjHD5y6YYJM0cfAYy+2lNuo6U8uGddx0vt
         LiqZEHEdC1ZM5lOLsGIVqOE51/BG9GcM2KJu6CGA+rKqPk6TfEwyJOO9Aj+1e+DH6n7q
         jdHeQmILXJZ1zQez3AbCPjiI5U6B3jSuvPZ8HE9D1LXrLMsz5VPrTzLZfefJp4yrqPH/
         b5vLpIMui4MMWg+5KTufHOyFl25Kv0hmJvhDDbrEiwjjAHK7SlKOgtcMg1mKMUFIyZQ6
         0XCQ==
X-Gm-Message-State: AOAM5335/Y9hmZ7yOvHvntPK9X+d32hfBbjdTcg7reWMp3gpsPGIrwlh
	EQbIDGPqd/pVueDxjXFypXX7IjF0pDdW3bRQnns=
X-Google-Smtp-Source: ABdhPJxSD93X1bZbMxIVxbatDlNzo+plulwlXrP7mUhDGUyc2zpYsUnUjocqKRL/aFZ9kJnCfhHJEfDbrbY1YJULi70=
X-Received: by 2002:a25:e8b:: with SMTP id 133mr46457083ybo.13.1593030803250;
 Wed, 24 Jun 2020 13:33:23 -0700 (PDT)
Date: Wed, 24 Jun 2020 13:31:52 -0700
In-Reply-To: <20200624203200.78870-1-samitolvanen@google.com>
Message-Id: <20200624203200.78870-15-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH 14/22] efi/libstub: disable LTO
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

With CONFIG_LTO_CLANG, we produce LLVM bitcode instead of ELF object
files. Since LTO is not really needed here and the Makefile assumes we
produce an object file, disable LTO for libstub.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 drivers/firmware/efi/libstub/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 75daaf20374e..95e12002cc7c 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -35,6 +35,8 @@ KBUILD_CFLAGS			:= $(cflags-y) -Os -DDISABLE_BRANCH_PROFILING \
 
 # remove SCS flags from all objects in this directory
 KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
+# disable LTO
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_LTO), $(KBUILD_CFLAGS))
 
 GCOV_PROFILE			:= n
 # Sanitizer runtimes are unavailable and cannot be linked here.
-- 
2.27.0.212.ge8ba1cc988-goog

