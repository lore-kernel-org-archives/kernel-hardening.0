Return-Path: <SRS0=4Ln2=YZ=lists.openwall.com=kernel-hardening-return-17247-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BCC1CA9ECF
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 22:14:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 810A02085B
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 22:14:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jD7UphcO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 810A02085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17247-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3595 invoked by uid 550); 1 Nov 2019 22:12:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3534 invoked from network); 1 Nov 2019 22:12:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SBPjjox/K0nQBp9p/UReaX06mOCKZA5VG5oKrHSRp3U=;
        b=jD7UphcOofzvzp+Fej+FGAYX3qlgaInC3q6riheK3W8LCKmKWtfTlTrJ/vzD4a19an
         +Hcrv+tkq9TdRVKgDOaa6Ic5PZn6XxN9+vLYJmvkleDiug2F9Tcj89ldzM4/Wx0mDp22
         mgzUKliuIEQOx7CwzvE6V9myvgkQNgKcVgCutPLeSHS/wibMi+2JvOa+OCv75/Nwje2O
         8oWep5ZzzzdxjS5LcG8wINg1XSm4eYtuiQytGXDC4/Up/8zjkIUOQ+XAAMs0f9WdxGw6
         GvK3uzJndPpvEwWoClt/0ppEIta5+qJS7qlUvBidggYVVp60p9g8sBe1C+92bc/icYtq
         Aalg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SBPjjox/K0nQBp9p/UReaX06mOCKZA5VG5oKrHSRp3U=;
        b=XDp1k2L9NVbXQWQRVtGIznQLLz1CsmYcHvW+9TsHYvV2Y1+/O8N2cQdWutFUp/D76f
         DuGtuAv5N5Gbkv3wUr3Fp0LkejBDUfsTfXaQ6QUycnDkEv4eBiIRtp+EmOar2uyEvtIa
         Eg9V5Yk+FunZ05sf0xT/AYV656ZG7e1Y/NETwZfi1vH4IIp7T8TjZv+uOI25fwGvwLST
         1c1VsHKet9k2NTTXDq2JxwYmk6jQiM6eQY5N1sEh4mGcK+eGRxA3wDYnVnNgjmy7D63M
         9i1MwWS7cjAGVmVdIvT1b+V37QkOBTlNJXVfHHmXs5hhjVLcjKUgSpgu/NroftV91+vM
         ixvA==
X-Gm-Message-State: APjAAAV44QJ568uR0Evd6GSW93dPNWbobykP2HfbLqQEt6G0xi+FM6WC
	Ifoz87hfwi2EW65UQ60IsyI7n2f3jndCM8AiaQc=
X-Google-Smtp-Source: APXvYqxqSMUGI9UyircMqSL5QLFPtKAtuhwEXcqXTbAsf4XrCTVNUwTxLrj6ufv4Kgs0IKAfQNkuo4iX4Ohmpxbq4g8=
X-Received: by 2002:a63:4525:: with SMTP id s37mr16212936pga.148.1572646357518;
 Fri, 01 Nov 2019 15:12:37 -0700 (PDT)
Date: Fri,  1 Nov 2019 15:11:49 -0700
In-Reply-To: <20191101221150.116536-1-samitolvanen@google.com>
Message-Id: <20191101221150.116536-17-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191101221150.116536-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v4 16/17] arm64: disable SCS for hypervisor code
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

