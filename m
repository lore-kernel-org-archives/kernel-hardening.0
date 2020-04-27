Return-Path: <SRS0=9juQ=6L=lists.openwall.com=kernel-hardening-return-18648-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E8CAC54FCB
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Apr 2020 16:04:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A53C6205C9
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Apr 2020 16:04:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ijnQ0fnO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A53C6205C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18648-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15558 invoked by uid 550); 27 Apr 2020 16:01:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15501 invoked from network); 27 Apr 2020 16:01:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=aF2klQa9rRamHf/M4CeCxFGtvwc1mZVJXnokoniINw4=;
        b=ijnQ0fnOBOZz8ohYGbprOcWD6bXoahdyQ/EdPHNcahHH1UNi6yI4DR5R2vlPmVt+MA
         4ppIwntZ2J5xzVAeqXwe8sImyb647bo4hHg8kf1yP8EUjew4IgKXlLT+cyN+LZsy9Bq6
         UC/DmCNG2YyUikRIYaXEhti+n0bf2Uk+eSvlUyy0VkRfNHrV9zVYezDs+dHfFwKCE9hw
         sMB0tZWkO4naa4enGnEraDahmtXjGEJ9z7j4fYeSXhaXwN3tRENHyK+EQjCXHOgGEjXH
         LRUwN4NXMSq2HIBjq6AGd84jx2T6eVKALaDwXc+kFG7UvOg+1/Elzk8FlgUN6WR5CVNf
         +rUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aF2klQa9rRamHf/M4CeCxFGtvwc1mZVJXnokoniINw4=;
        b=UESnawemxkgBvtxe0GPMNho0AiDbd3dhfP1oNDPcoBhPQyeKeQgt1BLDL1pbFmnvHx
         7b/wN68j0sXt/P33nLd4R8XPe8qiErIo7bxa4W/sneReKkdiNXdJlLrIg/YfxubZWbTx
         yQJgxx0DXEShKb5wNDKpBtk9HqD914cA5l+yWF+PNi9PM7JsAVsJBVfgn/3tQf7QNa9y
         VImtXRG0Kda3TFB0Ikgc+GFxuJ/3dAM6cyjj3naAbISR+u/oFXDyITbovliwDgJSIT0d
         HzstktbL9cDfyEV+rpUVsMmOVjPg4kWg0o+xGc2QS9NMWxZOGB7DW/bAlPBRIqkbqaw/
         zivw==
X-Gm-Message-State: AGi0PuYzy/HowT5PIfwgfKzBGDiLE/NQ5UU4aP3Myw6ys6Gpn8GyYaRN
	+7DkM458MzFWt6Sc06V8Kz2u2EPsuNKF36P/tmo=
X-Google-Smtp-Source: APiQypKOsjWQ+jO+l4BxG62MWOPRhB/PQQHwz7wCFC1Vfqvf4Ou89RrbjPCh/lsRauohpj0Cl1hSrISC+Brb9ZNFufc=
X-Received: by 2002:a25:23d4:: with SMTP id j203mr35345989ybj.97.1588003260531;
 Mon, 27 Apr 2020 09:01:00 -0700 (PDT)
Date: Mon, 27 Apr 2020 09:00:18 -0700
In-Reply-To: <20200427160018.243569-1-samitolvanen@google.com>
Message-Id: <20200427160018.243569-13-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200427160018.243569-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH v13 12/12] efi/libstub: disable SCS
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
2.26.2.303.gf8c07b1a785-goog

