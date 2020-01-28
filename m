Return-Path: <SRS0=O8o6=3R=lists.openwall.com=kernel-hardening-return-17626-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D33CC2D0DB
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jan 2020 18:50:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6F00F207FD
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jan 2020 18:50:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WKzYD9qR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F00F207FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17626-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11607 invoked by uid 550); 28 Jan 2020 18:50:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11539 invoked from network); 28 Jan 2020 18:50:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3z69QiWDrqEiuvPmX+boefS4xCQlVDQqcKUHkZHcYiM=;
        b=WKzYD9qRh241gJR37Gn3slI0Ze0ENEB50B561Azo46OjWSNnKsQSwTha+IR8iUN7A8
         bIL8fU7f6KviuaQftzEamZyVxAqUTnnHC6uedeJC4aQF/6TkFDuvF+sEqqFHwmjqQfoI
         TymdgIColOq7seg3DKZbAHmhw5jAFVHT2lWBR1O1QVgR4imxTSma7d51+vNTPwsWA4fb
         YlEIvbI2hzVY5IAfh+gyqKxuXZ3bTx983VQ7LbP5xF7SPACPNJAhj8V6Bq3bI9I3rHA0
         G+wMuqmht03rH27g5NqQOLr3hTXl+79EaIr4HNKT04efHrIRskPatCwoVaiqyFAzs5sr
         3rFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3z69QiWDrqEiuvPmX+boefS4xCQlVDQqcKUHkZHcYiM=;
        b=CrG918aOWgWJFPbwdoyOoq51sRDEaKuF70L1fR5Vc+0NdMlI4YJ9+nHaGLQ/2Ec9Ro
         vjZRelFIPN8SyDYQbyCru6edZ9cK1X/lw/uv46xgjp2wAH89cQ21V0XcF2l0lDHJblh8
         mumoP2MOhE0oTDaKKru2MPrRlD8Bg+AqYNYJncNraSNi6UqauQzhrIwXLLlhUEynBTXB
         4MWP6pLvqvjfHUTMnN0E8kUhtfRj+v3yMlADbXyZ6IfNhtFdXUO2qsM1nrLrTuJpkPns
         qXa0R1MF4wkR5WwB2bfKFhdLeGtl9jRYQ1Wyci0W5yhi2PAbz6JvggDYHI2IWBxITf8U
         SguQ==
X-Gm-Message-State: APjAAAXWBzriaPeyUe26IFHL/2shWn/Mu7Nnn2pp5WUIPLX8aD7YdUIE
	gjV4DEzMIJBqoj2eTexEi9bHqv/LnjxxdrRolYY=
X-Google-Smtp-Source: APXvYqyCCLKh4s0TkRqrwhynUzYu2+5v/oLjs7TG9/zRyQpl2gfMCAhVzqKgups6XR11XC6BZHds7SoxOgaSqO5NAfY=
X-Received: by 2002:a65:64c6:: with SMTP id t6mr25413296pgv.392.1580237391528;
 Tue, 28 Jan 2020 10:49:51 -0800 (PST)
Date: Tue, 28 Jan 2020 10:49:28 -0800
In-Reply-To: <20200128184934.77625-1-samitolvanen@google.com>
Message-Id: <20200128184934.77625-6-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200128184934.77625-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH v7 05/11] arm64: reserve x18 from general allocation with SCS
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, james.morse@arm.com
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
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
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index dca1a97751ab..ab26b448faa9 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -65,6 +65,10 @@ stack_protector_prepare: prepare0
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
2.25.0.341.g760bfbb309-goog

