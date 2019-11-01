Return-Path: <SRS0=X+Zs=YZ=lists.openwall.com=kernel-hardening-return-17246-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E2B8CA9ECF
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 22:14:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8ABB72085B
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 22:14:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mLcd5Ko+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8ABB72085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17246-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3371 invoked by uid 550); 1 Nov 2019 22:12:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3298 invoked from network); 1 Nov 2019 22:12:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oB4lIvjzdBiHgRAUphuiQVPgI+jp2K5bMoUCGUiH4hk=;
        b=mLcd5Ko+fJmhjxDMoBpGZ3EPC3b/VP/PBLdcmlypMJNdCOc5u9jhjSLWUNRMYr69hx
         U2P5JSWVYdV6u8EzfA94UAbX9w5Q1ZrloIyJVyjdf/ObF5XN+RiQraEntwZF84tiJw4A
         SKbzKEtQORywvZdxPhMYx0LHvfikuCCPY9XvjfKtjRiin1Jn0QFeomQACCaJo3jt8lCW
         KyuDz5lfuSMpAGWUw7ut45j+6bJefZga8POnR6VI0FVyWw/cL8vyvxBQD9C59E1UjFOA
         7acbvIVDECPMMh62wKUfHOE3f3OZYuymQJbmahdFgydr8nJ0p/3u8CSBUyJzVVefqNG+
         Z8oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oB4lIvjzdBiHgRAUphuiQVPgI+jp2K5bMoUCGUiH4hk=;
        b=VxZyn4jhpMvZYuN00F5gdOFEMY+Xg7PCbnzYxm0IbAmUlj0iQQ65eTL4ONK0t5vpSU
         SjNd9FszaPsUYk68rjiEjAmXfY0Z4hAlLALPdmXttGDOS/xD8zKXzkGEosqnignoC8cq
         HxzdJNQRHzd/tfaFfbf4m3pLC1WbW06HhDHTz0Ul86NEznfUwi5RKskjVt/sWh8//1wu
         uoRfEywU/9hxsraZy+4NSMYznNHGglivDw1JYHcFPAhPi+1lxeDDghiG0jdqPpm4x9L4
         Xo7Ikz/LlaOEJLTbFlPL7oiH7rGznWh8VsTLVFG6gf+Ljwqquy/MqA8FT/9yJKpuG/3Q
         wkYg==
X-Gm-Message-State: APjAAAVzBqS6n7zG91p8DnHnBavJA7k3H64csPXbJFRW9AK+64MEmKw6
	JIiEO2VsiS7GQqnQSxr378uo+UNguJOP0xlR5cw=
X-Google-Smtp-Source: APXvYqxeW4tUSlj5Rjy/RV2utncaJwaQyF3tWO3lBVE2VevumOyR70VNIZ9Nj/gJhm+HF4+zxBXbctrnYgLnOQF1Wjw=
X-Received: by 2002:a63:d20c:: with SMTP id a12mr14724175pgg.402.1572646354642;
 Fri, 01 Nov 2019 15:12:34 -0700 (PDT)
Date: Fri,  1 Nov 2019 15:11:48 -0700
In-Reply-To: <20191101221150.116536-1-samitolvanen@google.com>
Message-Id: <20191101221150.116536-16-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191101221150.116536-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v4 15/17] arm64: vdso: disable Shadow Call Stack
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

Shadow stacks are only available in the kernel, so disable SCS
instrumentation for the vDSO.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/arm64/kernel/vdso/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index dd2514bb1511..a87a4f11724e 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -25,7 +25,7 @@ ccflags-y += -DDISABLE_BRANCH_PROFILING
 
 VDSO_LDFLAGS := -Bsymbolic
 
-CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os
+CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS)
 KBUILD_CFLAGS			+= $(DISABLE_LTO)
 KASAN_SANITIZE			:= n
 UBSAN_SANITIZE			:= n
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

