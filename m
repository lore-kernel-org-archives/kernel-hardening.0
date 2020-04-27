Return-Path: <SRS0=FMfN=6L=lists.openwall.com=kernel-hardening-return-18645-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB130C54FD0
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Apr 2020 16:03:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 249F9206B8
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Apr 2020 16:03:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DHL29TiS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 249F9206B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18645-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14126 invoked by uid 550); 27 Apr 2020 16:01:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14078 invoked from network); 27 Apr 2020 16:01:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MhrpwHs0AsLMtVzb820LtwCNl0W7a7WFfLC0oPkvUmQ=;
        b=DHL29TiSaxcDKg26ae3snSvd9KBniehMx3v50e59HOzn23b9luEep1Uut6Rh1bgH//
         KO956X4m67E0WpTwHcyuZx/xco9K1MfUnOei1/NJ7DvhzpuBWAQQoieFIzyDvLo6Xj/U
         LSa76QE4JoiA3ockCGPZD1FfXXH04NOXGtZ1PxX9YzsvIand259bV5kmRZPWkfPadlSz
         XWC+qkJlG8khvQVMgO8moC3HdAi7FoVaXCNT/Dr0tnUqnPV0HoVJ/fMpxxfRfRmbMoG3
         yBAUhuFYHDK2Ll4Rry67J9w3Df6Y/7mnJGUxW1bj4MawAaAPsThGV9/Mf4P8wQ1n4vgO
         xZBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MhrpwHs0AsLMtVzb820LtwCNl0W7a7WFfLC0oPkvUmQ=;
        b=cCQ8blsWwWpsi8qRE2VFjSLCcB2eE7d8KP4t2l98DTtWD6kXLjoJ6TIzsDGh6nmh/L
         +3obcqEUNwk+hmbmC5wlA/mG3Y4LxQx6BhGc/mnKhJtSKt+94eHXsCwAj8x9HXn92UL3
         GGarjxlaJ34PJhgwSAcMUesiayTy5QehEpEZUXnRcGoXxR24iiLyHedSFW//NCoKuPr7
         +hZS+WSJqvSC0EzC8jj2ZcQ2xlRDUTGSvRD18ZdLf0q8SKpNWW2lebhXV2sUU3xsN9QF
         gzDS4LYgBQ73WA0w3Vh4ZL+deYJ7v2vMwYn4bNXdAr/Y/unTw7JhAIxnTwvf6M5vRg8P
         d9IQ==
X-Gm-Message-State: AGi0PuZk0lyzYC+ftDl4baEYlocTuNiU6GXgcuc5LIYmYi1fWwlFBM0O
	xHNWhYl3SFG2e4F4TUzGTn6w/c10DoeiTesr5Wk=
X-Google-Smtp-Source: APiQypIKYYCqrjrGDUY1B1bGA9o4qwmVhzAAlAiSD0oA2v0bEfRWWMuFhQtbWcozWJZsq/jS263B3BZnI77ktov0l6U=
X-Received: by 2002:a5b:44b:: with SMTP id s11mr21987518ybp.399.1588003254867;
 Mon, 27 Apr 2020 09:00:54 -0700 (PDT)
Date: Mon, 27 Apr 2020 09:00:15 -0700
In-Reply-To: <20200427160018.243569-1-samitolvanen@google.com>
Message-Id: <20200427160018.243569-10-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200427160018.243569-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH v13 09/12] arm64: disable SCS for hypervisor code
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

Disable SCS for code that runs at a different exception level by
adding __noscs to __hyp_text.

Suggested-by: James Morse <james.morse@arm.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index fe57f60f06a8..875b106c5d98 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -13,7 +13,7 @@
 #include <asm/kvm_mmu.h>
 #include <asm/sysreg.h>
 
-#define __hyp_text __section(.hyp.text) notrace
+#define __hyp_text __section(.hyp.text) notrace __noscs
 
 #define read_sysreg_elx(r,nvh,vh)					\
 	({								\
-- 
2.26.2.303.gf8c07b1a785-goog

