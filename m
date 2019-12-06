Return-Path: <SRS0=FFnf=Z4=lists.openwall.com=kernel-hardening-return-17485-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32FADC43603
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Dec 2019 22:16:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 80F7D21835
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Dec 2019 22:16:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FrhxzfWX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80F7D21835
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17485-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23679 invoked by uid 550); 6 Dec 2019 22:14:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23601 invoked from network); 6 Dec 2019 22:14:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8FJHqLK+9qp1SI0ZtY8nP7Vb0Kv4oQj2LgBWqplCpRM=;
        b=FrhxzfWXmzsxE4agp2rhmb4i9ATROH/GqZDqVq2Imv+d8/yhy1TAupBbdgdQuSdfT5
         6nQ5+3t9PECXIMWiDkrxMAiTDpvy1ngzEasXmXrAdNopBfmN/Bna9sPRCkNQn5V572bx
         eywVNSAedzToawJGzxolT5bl0ETab6Tw7CSJ2i0Uja/LPJMZj7f7aPe8T4bfjdxlPjQS
         3rIjn9HdeJXWzsniPYQzRfVJY1BL/sjidsk9JqsZiiFE1dkWT9OuAz7rz3hw05LyvVwP
         aif6TsG/Uxd0YqyKA9qyIH/plzSKaLaWabPJbVwtZIh3ODY4G/YpLNqbHQXB/I8WrOae
         /1eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8FJHqLK+9qp1SI0ZtY8nP7Vb0Kv4oQj2LgBWqplCpRM=;
        b=cccdMCVne/eKPpse+XOZcxjfmyI+08EAEC1EBM030/hv/wbNlp2eNBv9cz7YDSaV6k
         dwY0TYz97ktuTdqzy0u2m+nRdqtF0ze6qacxIg1pJtYsQbQXr2YZtonEXkbZUbFzRppc
         tYr/qmJiAaCLzpeJm4zPFKwp2TSvKMJkW1Tjx9MLWAey4AjWp1jXB1zT/aeCv/O4tE11
         /NUBcNjvniSHKQ2Lko2vsEnXz7hy4x0Y6MeeH/SirVfvc7buqF/AbCtjPyso/WUtElRX
         wpSnnAjVo3334EfD30x+BJjMkOuGZF/vRf9f3zvKty6OL5EGU9HIyRgcINncnAFjV7ex
         /J3g==
X-Gm-Message-State: APjAAAX5H/JYuQ1f/Gi7uHqEaknnmYQSgtnMMyB8OdSTuA27XurQ44vy
	+ftSXpk+YexTVGhs7vDwWfcUYP9O5Ko9X+m6m2g=
X-Google-Smtp-Source: APXvYqzqfWQ39jRufjAhL7TZCDF47F43HjTHP8BNawKKpBRXjo9R8WHVKYYkig1q6KIkZysnArdkgny3hm72jaBZ4w0=
X-Received: by 2002:a65:6245:: with SMTP id q5mr6050849pgv.347.1575670468844;
 Fri, 06 Dec 2019 14:14:28 -0800 (PST)
Date: Fri,  6 Dec 2019 14:13:49 -0800
In-Reply-To: <20191206221351.38241-1-samitolvanen@google.com>
Message-Id: <20191206221351.38241-14-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191206221351.38241-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH v6 13/15] arm64: disable SCS for hypervisor code
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Filter out CC_FLAGS_SCS for code that runs at a different exception
level.

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/kvm/hyp/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index ea710f674cb6..17ea3da325e9 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -28,3 +28,6 @@ GCOV_PROFILE	:= n
 KASAN_SANITIZE	:= n
 UBSAN_SANITIZE	:= n
 KCOV_INSTRUMENT	:= n
+
+# remove the SCS flags from all objects in this directory
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
-- 
2.24.0.393.g34dc348eaf-goog

