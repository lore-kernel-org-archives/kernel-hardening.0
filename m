Return-Path: <SRS0=uoWb=6F=lists.openwall.com=kernel-hardening-return-18595-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87DFAC38A30
	for <kernel-hardening@archiver.kernel.org>; Tue, 21 Apr 2020 02:17:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D5DD22082E
	for <kernel-hardening@archiver.kernel.org>; Tue, 21 Apr 2020 02:17:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rprfLeuL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5DD22082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18595-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21851 invoked by uid 550); 21 Apr 2020 02:15:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21803 invoked from network); 21 Apr 2020 02:15:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0RQ1N542RT3QYdW6h+S0B1gn+F6MhyfTNdXGmDt/FSM=;
        b=rprfLeuLS2/09QHh/+y7xWTflZnqrv4ouAc/OGi0JspjqJm6eS46yKUFVvDRBA7xrD
         IsViCxyeg1EAE5/s87qdzXUUiSf8TnxPVsuAIEAzrr3sqXBZqrbtjCRgovWji//XWbZQ
         xcpiVJbVBTm7m/L4++NSnlJY0nFfQmhsqhI7X6papIZyD9mnE6qKALG0X6wbzmG68IwR
         NV/C9sJ2akeM/VxVHXv1UPXM8tN6ST0/kppmOPac277uAdAe7X5IMbeLQ3XxJTYzxblF
         bzhvQzjWFL0p41IeJx5ZGURPl6ZqYdcPqRjHl+2oWSLxp524C0oH+hXSgGEVR7rzQoiC
         gbPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0RQ1N542RT3QYdW6h+S0B1gn+F6MhyfTNdXGmDt/FSM=;
        b=TxR4KrUcYDJa/0qyzrsF13q9yAlT/vHSEGPtI4ClusJIgTEoPjaM84wczbJF642bmi
         NoncPxUxXnIegQiQ9dAqEYRs9fT6MDxYAsnt9i4HK5tMsq+Ezp5UNujMahT9EN7JiCQQ
         Tk1PTfFPcS3YJyEwocT8fixgoNda7nz2DqbVtqka3xF0XEFC+Zwcf/JH6ukYds7EVFeb
         IlhLTZxORmLAFAFx+/FU0GkATAs5ucuo7foJncOzZJ/c6NQ5h1mtOsf50McGAxhQg/UG
         TFcDeuhajGVZrdPF6955rlWx+Wnx4VzxSG9wiG285dZWpO5mYmPLRRqiRB0x5Nz0/6yy
         8YLg==
X-Gm-Message-State: AGi0PubN3aRuAJL0yTxuJu04kVZcob7A0foKVw2b0DHu6lGqQch5AXFd
	OsIbCi/E/ZNEup/0TPXO2mUdq1RVyvl4tO5TC2g=
X-Google-Smtp-Source: APiQypKVaa6EVfAXEUsgkxuszfVQpEqhSdTwtpRewqbIvj3iqtNn3hSJPBlIieXNvYTQbT7aDUwDMoQW4Qa/HRJl/w4=
X-Received: by 2002:a5b:112:: with SMTP id 18mr24192885ybx.103.1587435326655;
 Mon, 20 Apr 2020 19:15:26 -0700 (PDT)
Date: Mon, 20 Apr 2020 19:14:53 -0700
In-Reply-To: <20200421021453.198187-1-samitolvanen@google.com>
Message-Id: <20200421021453.198187-13-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200421021453.198187-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v12 12/12] efi/libstub: disable SCS
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
2.26.1.301.g55bc3eb7cb9-goog

