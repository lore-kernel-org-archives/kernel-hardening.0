Return-Path: <SRS0=t9vb=CM=lists.openwall.com=kernel-hardening-return-19746-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B107DC433E2
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:37:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0DFB720684
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:37:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iQRyuXb7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DFB720684
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19746-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28031 invoked by uid 550); 3 Sep 2020 20:32:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27915 invoked from network); 3 Sep 2020 20:32:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=KoA5zv+DpjEyp13/YuX/m1kwH/JJTx3lL+cQSxNvvDE=;
        b=iQRyuXb7DQREhbTivVeYcDoSGjtob7g8M5KS5z8R2T1nBf9Gx0F/IaqPMtn2bzwhh2
         DvvxcFNLC0B9wSIyz6SplW6mCPM1aenF7xoo1ziClwMNK+NKE53qTfAePUKqHL2UJnkB
         FLm0++eFSfi/lPj6VdPdxbPF95syaHvlo+Sk6yuM88i2IZzlSpgq1yQGQxsjz99mcX7p
         m9V6emvEp6fvuUTr1uX1VsgenOsyFKN9dFgrfxlx04zsYAMmRAr9kaydPt8YWI7OzTUw
         /xEzK08P+0B0NFU8v2bS7pcwz8uTLGPrj4WfYV2c9K1P9hISKsyvAPYFID29+oNZ0pwD
         RY9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KoA5zv+DpjEyp13/YuX/m1kwH/JJTx3lL+cQSxNvvDE=;
        b=DgGc1SFIA2e6k/LowEu+mvOTMr3n5xa6310d3Y1fM3pJn2uH/P+dkxPXlbfIf3gg9E
         x/cnzma7HYWSuWs/Lh0BDs1hI7uOWEMxFKKHGz9/ncoPhkkOyflnz+uB/WXMioGXgTRl
         3g0XgDJcPjlK2kAL60HQJ3hw0f1oGxjFkOzWvmXbK+Aa1+r0KM2KVXNeMIT+9bLaiehB
         0oRw6N/1+LlZ/ggaxm5q4ZRRYwnkyH5cEePS2sQdFPRe+Ju8ej5xsyiLebayriIcMyB5
         Ema9p6swY26y5E+b+b8UPXhlmiYdtZ8j6ks0CptS7cYdx8h5fxnDUA7V8vuIgyCeepjF
         63lQ==
X-Gm-Message-State: AOAM533kOQ9P3Z93lHXstDhpJMoRTQRpNlWT4gJojz+mBwfsN3zvctNC
	Jf8P2aZdtyNutB3q0HBhDIi4mATqHkvMn9BQWrk=
X-Google-Smtp-Source: ABdhPJx+z0p9xaedPgPNzeY/Rz32SVtx7k9bWUtWq2o8BTU/tO7RQ+3N5loCDPVr3FxVA9GPo0ZEtNIss1cCzuNBmj0=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a05:6214:1105:: with SMTP id
 e5mr3719981qvs.11.1599165111812; Thu, 03 Sep 2020 13:31:51 -0700 (PDT)
Date: Thu,  3 Sep 2020 13:30:52 -0700
In-Reply-To: <20200903203053.3411268-1-samitolvanen@google.com>
Message-Id: <20200903203053.3411268-28-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200903203053.3411268-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH v2 27/28] x86, relocs: Ignore L4_PAGE_OFFSET relocations
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

L4_PAGE_OFFSET is a constant value, so don't warn about absolute
relocations.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/x86/tools/relocs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index ce7188cbdae5..8f3bf34840ce 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -47,6 +47,7 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 	[S_ABS] =
 	"^(xen_irq_disable_direct_reloc$|"
 	"xen_save_fl_direct_reloc$|"
+	"L4_PAGE_OFFSET|"
 	"VDSO|"
 	"__crc_)",
 
-- 
2.28.0.402.g5ffc5be6b7-goog

