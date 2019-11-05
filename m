Return-Path: <SRS0=BfHT=Y5=lists.openwall.com=kernel-hardening-return-17309-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68948C5DF60
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 23:57:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 86DE8206B8
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 23:57:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WX/V/VTf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86DE8206B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17309-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26061 invoked by uid 550); 5 Nov 2019 23:56:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25989 invoked from network); 5 Nov 2019 23:56:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xr3X122JfUZTOJ9HNPiJpW+Iyor6r4hGY/b4sjNxJZA=;
        b=WX/V/VTfUhYNVK63Q6o2nwuNZuF84nG4taeFhEo17XXi/wiIq5TBNma6L2QWkkxymH
         DvQMMy0aOWkuLzcjaD/VZ7I9iJTaYKRhuhci0d1Uv1dvow1PsPAbfcG7lofjVT32BZTo
         XfopDA2vhLhs1jhnHF0BtxTMW++6XgIwcQqObAyguiG5eCzS2AdaeI/mW/++SFMdkYFO
         0sFgOE5K8+grQi8hixiOmdeRZME3HY40NRXpHJTOGJP9Yp/g21dwfZOSqMKsicYNTg7M
         PQxjmxBUU54ovXgSaLB6R/0V/BtxcVf6/NuKLrw9AecxZk0Kx+tl9gJtoHFRyt1RFLTp
         RO5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xr3X122JfUZTOJ9HNPiJpW+Iyor6r4hGY/b4sjNxJZA=;
        b=kOQpuElaIe2g4207Ot/B0uNZBTLwwd4a8yZsCg7LZqlNxwsyIOetbB0qaONjIFUYJr
         gHxHZCXJoJs4M00DLXLSZFzcO4IcPb77ajRy4KodzBDXUOxSh4qf816o7WZ6uzwoWzUZ
         yrtrNW0NbTuegc/6hJTaLAQpqjAbY2ZfRblOgpg86BwFkRuL6atVCnAmkWOXTgR80JMt
         CGHml8HI+Lp2xVL9Hgo60blV+LEgFCriMoHx951PmyEQtD7nqHAd0SmW94bpOmUJvk68
         hk4MB6peb24fIhpEPvOpAmqHQoujDewjkZhvCO3bBwkKuQ33ZRIszyNE4A+lZDP3CTdi
         nWDw==
X-Gm-Message-State: APjAAAXfEK9LWje5MI7HM8fQoAA2OZFymOWoJTZmcjCPIkzXS9sh4Ty/
	Nf2z7/2IArMftDbrUM0+bPlaZrtWW3gU8XC9mFU=
X-Google-Smtp-Source: APXvYqzws/iChASYEHCRVYS8P2kdCocZTmxir9yLCAbfQ2Y76yiotnVRg74apgBfcVGe/Rb1kCjSoUo8I9YbTGAoXKw=
X-Received: by 2002:a65:5683:: with SMTP id v3mr19280245pgs.190.1572998200132;
 Tue, 05 Nov 2019 15:56:40 -0800 (PST)
Date: Tue,  5 Nov 2019 15:56:03 -0800
In-Reply-To: <20191105235608.107702-1-samitolvanen@google.com>
Message-Id: <20191105235608.107702-10-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191105235608.107702-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v5 09/14] arm64: reserve x18 from general allocation with SCS
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Reserve the x18 register from general allocation when SCS is enabled,
because the compiler uses the register to store the current task's
shadow stack pointer. Note that all external kernel modules must also be
compiled with -ffixed-x18 if the kernel has SCS enabled.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/arm64/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 2c0238ce0551..ef76101201b2 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -72,6 +72,10 @@ stack_protector_prepare: prepare0
 					include/generated/asm-offsets.h))
 endif
 
+ifeq ($(CONFIG_SHADOW_CALL_STACK), y)
+KBUILD_CFLAGS	+= -ffixed-x18
+endif
+
 ifeq ($(CONFIG_CPU_BIG_ENDIAN), y)
 KBUILD_CPPFLAGS	+= -mbig-endian
 CHECKFLAGS	+= -D__AARCH64EB__
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

