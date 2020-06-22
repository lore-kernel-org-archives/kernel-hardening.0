Return-Path: <SRS0=nqtU=AD=lists.openwall.com=kernel-hardening-return-19038-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8752C433DF
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 19:32:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 11CE620776
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 19:32:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BKy23l2w"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11CE620776
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19038-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19959 invoked by uid 550); 22 Jun 2020 19:32:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19832 invoked from network); 22 Jun 2020 19:32:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zcPQ3teAeONtZCSjASMvWQH+0FGked91D84DWb3cnhA=;
        b=BKy23l2w1m43ZpBXQM2fDRryt6KkrHZIrILWSDueLTLg7JkO/xXIBdrpxBtpXqG8Eo
         C+whcf+rw091oqysj+R7yNmqCI48ZtM7rhgZGnobI7SE5xNIel15JCPoNXr8RLA/8gKA
         FUXw0i2C4M8kbA9Vh9+15Qvp6mVOpj0mucLag=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zcPQ3teAeONtZCSjASMvWQH+0FGked91D84DWb3cnhA=;
        b=lSdVlcs+dLlcQ7ziJAckQKCuyzQ6xaTgOf3GLAatx+YwErnePx5ybA8KfJyCMPT1Ph
         g3tzE4eLM31wr0wam5AFhEpsWIAGUvtaGRw7cvCRWXHbs5qqfP/QKeg5gEb7shHYzANm
         Et+Q7uDo7norX03QY4VlU2lvvKUj/GSSXepx31ud/Xh8xozitMC30qJ7+aP8tFPWBP+b
         go9xhkkHYUnnQQ39s4pgSPuCfbr91AK//Wdwkl4hjEi4JkhWbEHhlvh/+ol7TzPdSlg+
         5DjCb+orHtIckk/+H4B5yC6EdDsr0pOFo9vEpgu8eOFOB0PziPztmYtewRxJfaYoXHr/
         Qgvg==
X-Gm-Message-State: AOAM532vCealYK6MfoHqYGedgoJwTKjn+TmGYjBcnyA7Za6fraYEYsN5
	eKWSXP0eomUH7LnOo70VdyvVHg==
X-Google-Smtp-Source: ABdhPJwITrbj7E83VXsf9fWrxu//1aHMGodlvPkjapka8zNgM+eZ+A/1KAwdust7T+yhFUZyNvTBXw==
X-Received: by 2002:a63:3f42:: with SMTP id m63mr14501829pga.310.1592854314990;
        Mon, 22 Jun 2020 12:31:54 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
	Elena Reshetova <elena.reshetova@intel.com>,
	x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Alexander Popov <alex.popov@linux.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/5] arm64: entry: Enable random_kstack_offset support
Date: Mon, 22 Jun 2020 12:31:46 -0700
Message-Id: <20200622193146.2985288-6-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200622193146.2985288-1-keescook@chromium.org>
References: <20200622193146.2985288-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow for a randomized stack offset on a per-syscall basis, with roughly
5 bits of entropy.

In order to avoid unconditional stack canaries on syscall entry, also
downgrade from -fstack-protector-strong to -fstack-protector to avoid
triggering checks due to alloca(). Examining the resulting syscall.o,
sees no changes in canary coverage (none before, none now).

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm64/Kconfig          |  1 +
 arch/arm64/kernel/Makefile  |  5 +++++
 arch/arm64/kernel/syscall.c | 10 ++++++++++
 3 files changed, 16 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a4a094bedcb2..2902e5316e1a 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -135,6 +135,7 @@ config ARM64
 	select HAVE_ARCH_MMAP_RND_BITS
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
 	select HAVE_ARCH_PREL32_RELOCATIONS
+	select HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_STACKLEAK
 	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 151f28521f1e..39fc23d3770b 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -11,6 +11,11 @@ CFLAGS_REMOVE_ftrace.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_insn.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_return_address.o = $(CC_FLAGS_FTRACE)
 
+# Downgrade to -fstack-protector to avoid triggering unneeded stack canary
+# checks due to randomize_kstack_offset.
+CFLAGS_REMOVE_syscall.o += -fstack-protector-strong
+CFLAGS_syscall.o	+= $(subst -fstack-protector-strong,-fstack-protector,$(filter -fstack-protector-strong,$(KBUILD_CFLAGS)))
+
 # Object file lists.
 obj-y			:= debug-monitors.o entry.o irq.o fpsimd.o		\
 			   entry-common.o entry-fpsimd.o process.o ptrace.o	\
diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index 5f5b868292f5..00d3c84db9cd 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -5,6 +5,7 @@
 #include <linux/errno.h>
 #include <linux/nospec.h>
 #include <linux/ptrace.h>
+#include <linux/randomize_kstack.h>
 #include <linux/syscalls.h>
 
 #include <asm/daifflags.h>
@@ -42,6 +43,8 @@ static void invoke_syscall(struct pt_regs *regs, unsigned int scno,
 {
 	long ret;
 
+	add_random_kstack_offset();
+
 	if (scno < sc_nr) {
 		syscall_fn_t syscall_fn;
 		syscall_fn = syscall_table[array_index_nospec(scno, sc_nr)];
@@ -51,6 +54,13 @@ static void invoke_syscall(struct pt_regs *regs, unsigned int scno,
 	}
 
 	regs->regs[0] = ret;
+
+	/*
+	 * Since the compiler chooses a 4 bit alignment for the stack,
+	 * let's save one additional bit (9 total), which gets us up
+	 * near 5 bits of entropy.
+	 */
+	choose_random_kstack_offset(get_random_int() & 0x1FF);
 }
 
 static inline bool has_syscall_work(unsigned long flags)
-- 
2.25.1

