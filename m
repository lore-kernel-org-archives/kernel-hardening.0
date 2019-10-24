Return-Path: <SRS0=vg0b=YS=lists.openwall.com=kernel-hardening-return-17121-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B84CA9EBD
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 09:30:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4ABDE21D7B
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 09:30:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KnquzFop"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4ABDE21D7B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17121-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9533 invoked by uid 550); 25 Oct 2019 09:28:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19879 invoked from network); 24 Oct 2019 22:52:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1o2AK/x7KnetiIYq4sD6lyk+Z1PFoM7PTIwarlqCwx8=;
        b=KnquzFopxhgUh+yJfoei8gVVx1UFevR3Wi9RJ0Dct5s/wjoLo0UIULHJ52iyDlFB6P
         94/Io21URIBdRGDxFS0tbpT8pf9wFw8CXp+hb35OeyzhyhJZzuNbeeXwAhpUtwNbkNqL
         edchxQirUe1MwQD/Bh4qSgXOeqnChy0v7mDVdemPsERGoJorUBOTSCiz1vXHX3iTQXqK
         L/AQoYVVPSbkYTN+kSNfz4S5Cfd9VFTM/5mH+ilYFDv/qrO8wemOh+JMQ//CnpweWdoe
         mgXlVK8nsRV8k399Qz5bXX+5b7BlTlHNqA1J8uDhWD+EG7ALlgdLoLxjV63C4rvVMaoN
         Kpyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1o2AK/x7KnetiIYq4sD6lyk+Z1PFoM7PTIwarlqCwx8=;
        b=eTYKO4z6K/8HDI+/N54eLiY3RVpjT53M8hhRs7K5aIejgJNF7eiT589mGCmEo5uQkz
         LhxnmxrBwQJQy+YN9JIg47gr7P/3BgWZZj7ch/qVRMWy2UCqnY1wAZhsRO5fholbm1oe
         4+9cg39xUhKujZTzdjHJ7c+LdMeizcZTVmYBzKg3z5IIRzgp+2fLV4DBPvbm8hFFTpgg
         86zPzCuhBEuEJSNbKKCPw4A1x5/dTvyKnKjTaiWfABI/2NgioIpYIkl1Prxx3bP+e50C
         PyzpIOweSVpUU4dF0gTx8ZjjlCBtHpLWpWWLm6BaC3+uH53SNfQQQmqfAbc9pwER93ZB
         yUwg==
X-Gm-Message-State: APjAAAWI7BRJua22D7fIZ37r8Q4LzoXeoLQazLC+j29ql+AwtCDYD6nD
	11d2Pst+W5jBTOdK02Pp3bqyaOW8H+jZWEveaRE=
X-Google-Smtp-Source: APXvYqxqUYVuoLyhOB6Va7uYpgm1rgX3n1dq9Gi5p5wkBMwq0WVn5KMyKDwxuEEfjT/w/yrqMmcBrDqFtfNYzjT3hHU=
X-Received: by 2002:a63:3c19:: with SMTP id j25mr558800pga.12.1571957554655;
 Thu, 24 Oct 2019 15:52:34 -0700 (PDT)
Date: Thu, 24 Oct 2019 15:51:31 -0700
In-Reply-To: <20191024225132.13410-1-samitolvanen@google.com>
Message-Id: <20191024225132.13410-17-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191024225132.13410-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v2 16/17] arm64: disable SCS for hypervisor code
From: samitolvanen@google.com
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/kvm/hyp/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index ea710f674cb6..8289ea086e5e 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -28,3 +28,6 @@ GCOV_PROFILE	:= n
 KASAN_SANITIZE	:= n
 UBSAN_SANITIZE	:= n
 KCOV_INSTRUMENT	:= n
+
+ORIG_CFLAGS := $(KBUILD_CFLAGS)
+KBUILD_CFLAGS = $(subst $(CC_FLAGS_SCS),,$(ORIG_CFLAGS))
-- 
2.24.0.rc0.303.g954a862665-goog

