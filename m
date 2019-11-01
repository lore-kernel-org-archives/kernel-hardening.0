Return-Path: <SRS0=LYXa=YZ=lists.openwall.com=kernel-hardening-return-17235-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36A6BCA9ED1
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 22:12:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8291E218AC
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 22:12:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q3YTCGLY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8291E218AC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17235-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30261 invoked by uid 550); 1 Nov 2019 22:12:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30127 invoked from network); 1 Nov 2019 22:12:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=E806Ihq7Qr5kwAxZ8O8jq/5GK0i44oON304BuEfvZ08=;
        b=q3YTCGLY4SwiQs7Dr523GbwXcyS1rOF4ePlC+I2FlqMLdM1nbvtx89eitGKg3+MPv/
         /6kpVC7ib3nqYGqEvd/D7Aja0/Oqw9bqK4yY73IHHngPbb8yNTF80TsjwS3dip4BNdjJ
         vrTCQU+wyHKRY1+9qAAoEBJOivxjjzkaOrEGQr3vnrSW+SARMhsCk1i/tL9jdyhbVr9G
         N6J/wBNQprJN4QGbaP/iQ1MEafD71JFawBswZkK6umVAzs2YdsoYpup5A4o/8Tk1dVfR
         JqWRLp00wfY2sTSArmHg6PdT5yupXzlZUV+YXQhkWVfHN9eXitDPORweXPhbmCnVSWKB
         z5cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=E806Ihq7Qr5kwAxZ8O8jq/5GK0i44oON304BuEfvZ08=;
        b=W6+4Ff37nNqwArAUP0Rnl/AZ6kI8MzX97AzgLis+OvnrM+AKnW1jK/7YDBmNhg3JD5
         9zleDmrskn3UueVcUM24HLgjRdV1hV+ZA3sF/HjildH6KgMDR8KZF6L64WDdghmeDdNT
         otsaQQDKjcpw0LxQpqjhwn3mB77dkJhoUk8swA1uBWd/sLmB4cr5Ii9iYpP5hjGcDX+n
         hWgDJXFJuRF/m+TWCi64BIN4nKt8rW+K/si1xySk+4uWD/JC8udF/BiJOZdKUh1QqrO8
         0WSc40XTGxsEkDbWfqiPWh2F2FhJs/6FMsLxcn/tYMfEBrfPy5Dll6KDL8u2jqqx1Ntz
         Eofg==
X-Gm-Message-State: APjAAAWAusAoQO8kUxLhew9XkFS+lP8u60jinMnKG7AjGMNbY/V97dk4
	6FG+9m728L0gK2XNxPJ6+C56DakLXn1b+qtXEZg=
X-Google-Smtp-Source: APXvYqyjCtIlE+FqIkDNQuZrIZu231KKDGdgU5VhgnFa05GlKuF5lFgoXY69KDCGAPVnM5k2sylcp3A3JeY4sKUC4Q0=
X-Received: by 2002:a63:7015:: with SMTP id l21mr14741976pgc.200.1572646325115;
 Fri, 01 Nov 2019 15:12:05 -0700 (PDT)
Date: Fri,  1 Nov 2019 15:11:37 -0700
In-Reply-To: <20191101221150.116536-1-samitolvanen@google.com>
Message-Id: <20191101221150.116536-5-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191101221150.116536-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v4 04/17] arm64: kernel: avoid x18 __cpu_soft_restart
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

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

The code in __cpu_soft_restart() uses x18 as an arbitrary temp register,
which will shortly be disallowed. So use x8 instead.

Link: https://patchwork.kernel.org/patch/9836877/
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
[Sami: updated commit message]
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/arm64/kernel/cpu-reset.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/cpu-reset.S b/arch/arm64/kernel/cpu-reset.S
index 6ea337d464c4..32c7bf858dd9 100644
--- a/arch/arm64/kernel/cpu-reset.S
+++ b/arch/arm64/kernel/cpu-reset.S
@@ -42,11 +42,11 @@ ENTRY(__cpu_soft_restart)
 	mov	x0, #HVC_SOFT_RESTART
 	hvc	#0				// no return
 
-1:	mov	x18, x1				// entry
+1:	mov	x8, x1				// entry
 	mov	x0, x2				// arg0
 	mov	x1, x3				// arg1
 	mov	x2, x4				// arg2
-	br	x18
+	br	x8
 ENDPROC(__cpu_soft_restart)
 
 .popsection
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

