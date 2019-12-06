Return-Path: <SRS0=64aT=Z4=lists.openwall.com=kernel-hardening-return-17476-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E858C2D0C1
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Dec 2019 22:14:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6DDEA21835
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Dec 2019 22:14:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JUnATL/q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DDEA21835
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17476-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18347 invoked by uid 550); 6 Dec 2019 22:14:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18247 invoked from network); 6 Dec 2019 22:14:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XVGcsXtiiPVE9a9TFllXGgGHEKcXDxSx20NO6hJScDc=;
        b=JUnATL/qYc1oxv8iBdTskfQzu3dUUjyggOYJEMcIQnnUL/Y0NRoC+SEMllJtcFOWiS
         N/ulKnmZgrhoasRLRMaSLDH6091pEOUYgXXuTdPJyA/+/zT+NjML18Xbk0q7JQJZlyWp
         6rTkEVNH+fLD7+o9KvYuKvTopFNc6WKI4uib8O/Vx3iw4Shp3SUt/TKbmahphI0HKiU4
         BPRPCXf6h87GZeFyHIHYFqSn3p3Rv69hjOpYO3XFPBCkg3Q3z4MrJ2EA56qijI8w4jiX
         NQZtE0UhN3gJbyVa0+qGFUMyTZbRuK6Bc5RytwdbEZTnrQcmzPqvaU68OoqewWa4Q8Up
         87AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XVGcsXtiiPVE9a9TFllXGgGHEKcXDxSx20NO6hJScDc=;
        b=hb0TSwynwozOK/D5zH1FBm3ZM0qjn1MhG4t7hyTrkk9/nH/a7zKED7g2LvXlB0Cqya
         M0+pHpIMZ+mCbkWKPIspyR8vxmcyGg0FlEJnTZYDhZ23bTBw+BTNvW5MFU1/tRalwzLn
         HXnN+XKete3pWr9Ften8RTuufFDwljtVvvfJn423w7/FBAKglxHgfFwZlzja5jD3GpLT
         oGbYWB2nL6Fu6lulwCm5dVcG8iJCx75wd5vYVevg4fXXW/lQoS5QFNvI3PZcpxDODU+Z
         NQcihlrr+sLSjL0DC9S+HlFlRRbNx1gZpv6GppyJBI9rBaZmBgBTExkDrRhbX64X+PKg
         l8mA==
X-Gm-Message-State: APjAAAUG6lZUNbjb+dD3glQL1lFrEin++O3KwPOxKXlVhVD/nd3IGLFv
	r2VXOkEcXf5U+SVrj9ty8CmkrjHAl+VoSROlhDE=
X-Google-Smtp-Source: APXvYqzpc2h9jpUCodzOkaKdDJjjZM8itrSvWPNDKAcJvhYbUWMf4zn2+0r1408XQPHyy98KZt3TkfsfH2+NYjTL2w4=
X-Received: by 2002:a63:1c66:: with SMTP id c38mr5983922pgm.368.1575670446054;
 Fri, 06 Dec 2019 14:14:06 -0800 (PST)
Date: Fri,  6 Dec 2019 14:13:40 -0800
In-Reply-To: <20191206221351.38241-1-samitolvanen@google.com>
Message-Id: <20191206221351.38241-5-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191206221351.38241-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH v6 04/15] arm64: kernel: avoid x18 in __cpu_soft_restart
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
2.24.0.393.g34dc348eaf-goog

