Return-Path: <SRS0=SBsx=6L=lists.openwall.com=kernel-hardening-return-18641-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA4AC55199
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Apr 2020 16:01:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6E316206E9
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Apr 2020 16:01:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kiSv8CiU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E316206E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18641-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13319 invoked by uid 550); 27 Apr 2020 16:00:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12195 invoked from network); 27 Apr 2020 16:00:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vWKjMu4YpZkMxmoaABUBOKf1igZnxFZ9c3Ig1J3O4Og=;
        b=kiSv8CiUDdv0MhnhG7OLvK4HRjHRHD2p5Xk8z4MNjfWWTLx6u3zwpYo+VXYo00s9lQ
         2SiB14ebJv+tpR/lJ6lBiS6NtwBJkpElgf6+/UxLuf4ODhwnkipaZqAOpGAlWYJpWfCS
         z/5ymvrE+OkDEIiguUTShhBQhJ6y715cKJGNQcwyaJsde7L0h/IXtozn5mtgfyeHg/Ym
         H43sTz24QuaAjK8JJGNtzpBldyBrDbq8uPivT4CI9K7/qC+hhiObIxt3J7MJfK5BmrKL
         +bLkpaJXkzjZcdx/s4M6wTt3HBXcwxs7ZUVUd46Y+nf5P0oIYdPegXdb9NdLI9tk1xzd
         GS1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vWKjMu4YpZkMxmoaABUBOKf1igZnxFZ9c3Ig1J3O4Og=;
        b=arPiOm5Be4VwK7GiOuLyFSIfTJfVxdUaihibJTipy9micuSdKqDhAiqn/n9ueK2s2F
         IplZ9gcEkiYtc0BSxgVlrd670f4+UxsAvRhcwyidsmwRVxZgT/p7DrAVpFk3sUzJDChI
         HXYdIBg6fKkXsFTz0ML6bvqukQ1z1r+rC8xG2jv1fFV4o1nmkk6CyfB7zfBpb9aLkG3a
         d14Ss5yS6N6HNLOIaYUaZ2Z868dpX3G6s0YIz4mBo53QQw+25hE1Tz7k5MlnC4RnQHDt
         O3qyvFqYJghdzZHfXpjK6FIpUU88PG2zbRSFEveI8ya9ay1bs4z7Kw0Cnw3OcgUEx0L8
         VdXQ==
X-Gm-Message-State: AGi0PuZP68PyUq7T/tmSvMaE1BcfxkXgqWuFq9mlC779VCx9eYZSYpJS
	Qo42z0SIpixosaUU5H0ZLPLoOUO3adYWmdcZY3w=
X-Google-Smtp-Source: APiQypJpHxnUVa+HJ+OCdJz02DOHfWXmMr67lw1U6ExG9PpcAMVbKyAwbyBII6uQ9n51wuhyBZXu9qOSoWBoJcrJ8Lg=
X-Received: by 2002:a05:6214:150e:: with SMTP id e14mr23211009qvy.65.1588003241754;
 Mon, 27 Apr 2020 09:00:41 -0700 (PDT)
Date: Mon, 27 Apr 2020 09:00:11 -0700
In-Reply-To: <20200427160018.243569-1-samitolvanen@google.com>
Message-Id: <20200427160018.243569-6-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200427160018.243569-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH v13 05/12] arm64: reserve x18 from general allocation with SCS
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	James Morse <james.morse@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Michal Marek <michal.lkml@markovi.net>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Jann Horn <jannh@google.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Reserve the x18 register from general allocation when SCS is enabled,
because the compiler uses the register to store the current task's
shadow stack pointer. Note that all external kernel modules must also be
compiled with -ffixed-x18 if the kernel has SCS enabled.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 85e4149cc5d5..409a6c1be8cc 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -81,6 +81,10 @@ endif
 
 KBUILD_CFLAGS += $(branch-prot-flags-y)
 
+ifeq ($(CONFIG_SHADOW_CALL_STACK), y)
+KBUILD_CFLAGS	+= -ffixed-x18
+endif
+
 ifeq ($(CONFIG_CPU_BIG_ENDIAN), y)
 KBUILD_CPPFLAGS	+= -mbig-endian
 CHECKFLAGS	+= -D__AARCH64EB__
-- 
2.26.2.303.gf8c07b1a785-goog

