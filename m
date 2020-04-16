Return-Path: <SRS0=j6Z7=6A=lists.openwall.com=kernel-hardening-return-18540-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2FBFC2BB55
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Apr 2020 16:15:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2E0D02223E
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Apr 2020 16:15:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fKyFfLXO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E0D02223E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18540-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3729 invoked by uid 550); 16 Apr 2020 16:13:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3660 invoked from network); 16 Apr 2020 16:13:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0RQ1N542RT3QYdW6h+S0B1gn+F6MhyfTNdXGmDt/FSM=;
        b=fKyFfLXOz5sVcsMLYKlGfkS9d2/UCV8LgsPAZpozE0APa/tBvBvuH72SAkskPwpulK
         Q9xEycscm+hu03BJdYzx1SmxGohZ5WLC2Kp00QJoD/1v3vT77G97X59ssrg+rhyJkLt0
         FIZhmLR8ROQHOMNhMyY0XOXWlBU9bwJvWf1mFMpV7bvXEXcTn+KsgXL1xWQ9YaJxsI3p
         r5wBMm8vbJljvjWEKVD3VUjKdk7HSzBXS47lLsTkO0XDaM+rtLDkPFyAx4fJbEib9dsz
         fBUPYaCtMV7+NrFyKOzLqdDoXj0u8w2J3DBLtUaWWXI1UwSZCihejvWj1Y1tkFy1U7G+
         /Qng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0RQ1N542RT3QYdW6h+S0B1gn+F6MhyfTNdXGmDt/FSM=;
        b=MTULMDbxyFoLq6t51A6p4vl8+piJgGpUKXOmsT2R/8gCptQPxJQx+IFO5MlZhpzJqv
         VK0G8qktYXrp1Y2HmK20mXG7JDJk8bvo3xn3r4Odbtiqe5ZhV1rpaPY/PEbgNGBNKDD+
         jt+9CTfCkd/PVPbIDtnrymYcXbZYWlaVhiZ5Tg16NvJsHzEM4ISoqENxBCmlYUbJrdBD
         K4r0rPdnaYclg+OqWPeGST7f5dVqpuQuGu0O18z2SAhU7VoG91jFOVDH3P/eKjZoFeDN
         YCuQKKB8aQxgvSKlLd+bNk9lcPVy/HaQ+7eUR/wqaq3hVlulwAWwvuPs9Rd9PZvfbnYv
         Lsvg==
X-Gm-Message-State: AGi0PuYIJYoPnExHi7Y1Nh7c2xyPNdX4FHFkXpQ7ZIcBE1uyjdpqO9u+
	0vZbC8pltmQyKNDL16MwF+HVMkcpQOXdbTsK2lU=
X-Google-Smtp-Source: APiQypLcEVWlOSbUU7JM1b+dPKZalYkgI8XZ2RJRR7DguNAHXrP4Q+xtVussY8m1ZWA3xxy8DZYEgVb57sv3jHyS0G0=
X-Received: by 2002:a1f:a703:: with SMTP id q3mr5645257vke.4.1587053598668;
 Thu, 16 Apr 2020 09:13:18 -0700 (PDT)
Date: Thu, 16 Apr 2020 09:12:45 -0700
In-Reply-To: <20200416161245.148813-1-samitolvanen@google.com>
Message-Id: <20200416161245.148813-13-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200416161245.148813-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v11 12/12] efi/libstub: disable SCS
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
	Sami Tolvanen <samitolvanen@google.com>, Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Shadow stacks are not available in the EFI stub, filter out SCS flags.

Suggested-by: James Morse <james.morse@arm.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 094eabdecfe6..b52ae8c29560 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -32,6 +32,9 @@ KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
 				   $(call cc-option,-fno-stack-protector) \
 				   -D__DISABLE_EXPORTS
 
+# remove SCS flags from all objects in this directory
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
+
 GCOV_PROFILE			:= n
 KASAN_SANITIZE			:= n
 UBSAN_SANITIZE			:= n
-- 
2.26.1.301.g55bc3eb7cb9-goog

