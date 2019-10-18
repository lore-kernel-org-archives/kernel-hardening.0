Return-Path: <SRS0=TFhE=YL=lists.openwall.com=kernel-hardening-return-17025-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C43ACA9EA9
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 16:14:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C7E3921D7C
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 16:14:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RTWmB+YR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7E3921D7C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17025-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16229 invoked by uid 550); 18 Oct 2019 16:14:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9861 invoked from network); 18 Oct 2019 16:11:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=soVi6argGh8CkyJ/tZS/XQoN8aAv6F/7ncnrrIAGrbI=;
        b=RTWmB+YRhbyTrupTegTePDqh83wahNiLo24V/vkd3XNh2/VjRfOzsP8l9UA07iBYVh
         cNCOrmz1KApedjuZfTuf+oEAy7uJ9vOjlPpxsg7OkJReg5LlWaNnJSadKKQxT6uV8oo9
         DYHGRvWBz3/GUdtlA0wIAJuRmYFSW5vXFhnZ39LEFxcVI9DqpO8eIN9kDWvp9NjS8BGy
         xN5pkbK5dusYfEE++LF7k5cNY+Cu1x/v4ps1Ft2zcALY7q2NKOD2KsdADykKFGjX/ek9
         pgnN2RfC3QCLk3Iaa8HyaKxHiBf6citZAP2zBGFrT6GXMyCWAMsRsDGnPTlW+RbabIhg
         vExA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=soVi6argGh8CkyJ/tZS/XQoN8aAv6F/7ncnrrIAGrbI=;
        b=S8IfuLfwkdtWuSxEcqQVxnCHYKMzz+qG5f5qPVNyadX9a+UhCn+kbCEhEZ9glpjgmi
         YIBHXu5D7qCrih/hno7lmKsNDNb2gNZ78DNZWh5Dsl0jZNZgx6Ibr2XiwWo+PHijMQ8k
         8ArI9xmaffeN4G36/gnPK+R4jhfnPT7tWud9En6ZX20B71iYzHSDwrFyvhPPwlM3qXbY
         hcK8Wx9yg7h+TyKxqqrYrKmGRjiw9lOEmdz2Zf8m0z7gsdpcwkvAFDUADEnebS7I1E0B
         rIR4afaX4atPdeuX+MKIv9GBUYxLdIcon99veo6hWiJsCTgp2kxFrwDhx1KKJ654qCM7
         nX0w==
X-Gm-Message-State: APjAAAUaA8ap6FutL1jYaLVeFeMuSwSki3lwealj5Una1q/ezdWeZmhA
	67V/Pms9Pb1fw1YStj9Q1mne2mif4otMYeJI56I=
X-Google-Smtp-Source: APXvYqzkAvflPUA4hxOT5c7IqsE0Ybkf3fYa0ytmTSeu2hOJz51kZPeU6sdMsbUTLU2Tls8gLg9QkcQsftcMtRZzrhY=
X-Received: by 2002:a67:e34b:: with SMTP id s11mr5965401vsm.195.1571415062790;
 Fri, 18 Oct 2019 09:11:02 -0700 (PDT)
Date: Fri, 18 Oct 2019 09:10:20 -0700
In-Reply-To: <20191018161033.261971-1-samitolvanen@google.com>
Message-Id: <20191018161033.261971-6-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH 05/18] arm64: kbuild: reserve reg x18 from general allocation
 by the compiler
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Before we can start using register x18 for a special purpose (as permitted
by the AAPCS64 ABI), we need to tell the compiler that it is off limits
for general allocation. So tag it as 'fixed', and remove the mention from
the LL/SC compiler flag override.

Link: https://patchwork.kernel.org/patch/9836881/
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 2c0238ce0551..1c7b276bc7c5 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -55,7 +55,7 @@ endif
 
 KBUILD_CFLAGS	+= -mgeneral-regs-only $(lseinstr) $(brokengasinst)	\
 		   $(compat_vdso) $(cc_has_k_constraint)
-KBUILD_CFLAGS	+= -fno-asynchronous-unwind-tables
+KBUILD_CFLAGS	+= -fno-asynchronous-unwind-tables -ffixed-x18
 KBUILD_CFLAGS	+= $(call cc-disable-warning, psabi)
 KBUILD_AFLAGS	+= $(lseinstr) $(brokengasinst) $(compat_vdso)
 
-- 
2.23.0.866.gb869b98d4c-goog

