Return-Path: <SRS0=Yq3Q=Y5=lists.openwall.com=kernel-hardening-return-17313-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7014EC5DF60
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 23:58:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 90BC12178F
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 23:58:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p/+qormW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90BC12178F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17313-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28170 invoked by uid 550); 5 Nov 2019 23:57:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28102 invoked from network); 5 Nov 2019 23:57:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SBPjjox/K0nQBp9p/UReaX06mOCKZA5VG5oKrHSRp3U=;
        b=p/+qormWzpAk/hn6fTIAq1GD6e0WQRag5NF7NjqAhGo5V+9tCeqWxMigwtXWt/lGNp
         q9buszXWKYVWoziPQLZS51iBSuLA1nUdgVLAfYt05cUtAWebiilSqti+DjDN8Q0UKshx
         57MAdb8441Kh4kMQAc47B2g6uSc/jktWoSENQoAO1SfBArC0JfH71OE1ZC9X88wFzf7D
         1zKwIMNiGpyq7Ox2PdBV9bj7qpbfLeuEOQjRxH+b5fzmSdlQBlgmJqQb6wUCW+t/kkJd
         W22heVjnv5z8zfiAr2e8BVc/Krx9f9PGp3snmyjgH+VW1d5sU1rFDMtHZ42LB6knm6uR
         i+NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SBPjjox/K0nQBp9p/UReaX06mOCKZA5VG5oKrHSRp3U=;
        b=ToT881aPJP7hY4OVbMlO4a5xfay+CQsXxdWgAqyhgrFxEWKQq7IssXb8jEqTSmvZ2i
         yLGQN5tc82KuIXbAzPlSwoQBU1bJZJ7QLtCvgGHiF0OyCQZUkH7TQm4E3oBnXuS5kWnR
         exhP+I6JruAWiYjEYjDN/kEyJa3Awjngrh340ul8GuJyOMaNp+zNM9PEHNKb1YeE7o35
         yvHL8VVQQy3lFAuWtcoC/3kYsfZO60wcIUp2RpMHtvfi97NYXMtJEbpyUSMcZZVoq9D+
         yBN7gMKHxtFOC/gIPz2wAb5QSj4DbfmEt0l+mhWZ1/tppZgzuQo9QP7KE9sUkpppw/kB
         L/5A==
X-Gm-Message-State: APjAAAXsTfMU6wKphWbdIkI+iW8NaKNa+0zbwn8eVJHquEp/r120DUy+
	5bNyXooMUS5a67Hjcm5L/QuhYlG4RCcbvOp+2qU=
X-Google-Smtp-Source: APXvYqwMtHOZMoB23ssF7JNCZzaMw12LgXJO1Cx/fyHqurm8wqZn755XqIGbFFeB1mv3cEwMcIBCpgy6byzfZbrNKqg=
X-Received: by 2002:a63:6483:: with SMTP id y125mr5619534pgb.444.1572998212169;
 Tue, 05 Nov 2019 15:56:52 -0800 (PST)
Date: Tue,  5 Nov 2019 15:56:07 -0800
In-Reply-To: <20191105235608.107702-1-samitolvanen@google.com>
Message-Id: <20191105235608.107702-14-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191105235608.107702-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v5 13/14] arm64: disable SCS for hypervisor code
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

Filter out CC_FLAGS_SCS for code that runs at a different exception
level.

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
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
2.24.0.rc1.363.gb1bccd3e3d-goog

