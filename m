Return-Path: <SRS0=zuTL=5W=lists.openwall.com=kernel-hardening-return-18450-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19460C2BA1A
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Apr 2020 23:17:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 40D2B206C0
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Apr 2020 23:17:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="FAUou8gY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40D2B206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18450-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24323 invoked by uid 550); 6 Apr 2020 23:16:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24207 invoked from network); 6 Apr 2020 23:16:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=afO1zKmkq1sj5aqNSAPmo8IRjezuEuKjnM3GlRCWtRE=;
        b=FAUou8gYmt2MCxO2cKyXhzSw4j1IC8KgeC+bXiqTqe5QqSNRmdnqOuVJoHQDJ+UyPU
         RdIafVDCCHUGnepHULs0h0QZtUehhYm52xPc8JIfEafNjj7L97tUHTMzVrIHdX23tu7T
         870tT8w8N8DbhdKYHGf474/jG4q9lS98mHNd0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=afO1zKmkq1sj5aqNSAPmo8IRjezuEuKjnM3GlRCWtRE=;
        b=lrNux+8wrQybfFRtahBw+tk2JUEuJ6t0a7VnRCV72PTOgLbHdxjJVfh0kIHz3SFuMG
         0WJ9zcT50xET5UUMcFr12bMkT9KCXhlZzUF/hj5TYrtAjfDTWN8pUGK4AlzRBmLKuVZY
         xMuzd4DO0xv+xCotXQ8d0073Kf1CwenpG1XVdPorHKR2WS+9oZyAPcZdvNQzyWQqEHU/
         e7rLO4OIC0DthtNg4EwjHpnDzGSuMK0N9Tc5BAHcOhpwklputq++rwpyewa9Yg7oo0bw
         PhPN8A/dQjPKeis70K+3dOExt/PcTHtjQsyl64T+qUqI0ZTFxkDmUzjwWnAnv2IgHF5K
         GH0Q==
X-Gm-Message-State: AGi0PuYAg8ijCnInCVwo4UeItbbtw5Ea8zppOSuYyDhjVz+IqIOYsPbb
	XiIC2MY8LOCa8Ul9qGs5kim7XQ==
X-Google-Smtp-Source: APiQypLKqmE7eCIX43I8YR8JbiR94l3ZUUPoGei30hzmH3c+zDO2qS2G3j+Tlv/Caq6mWLyP6sMzhQ==
X-Received: by 2002:a17:902:788e:: with SMTP id q14mr22301315pll.72.1586214974066;
        Mon, 06 Apr 2020 16:16:14 -0700 (PDT)
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
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/5] x86/entry: Enable random_kstack_offset support
Date: Mon,  6 Apr 2020 16:16:05 -0700
Message-Id: <20200406231606.37619-5-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200406231606.37619-1-keescook@chromium.org>
References: <20200406231606.37619-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow for a randomized stack offset on a per-syscall basis, with roughly
5 bits of entropy.

In order to avoid unconditional stack canaries on syscall entry, also
downgrade from -fstack-protector-strong to -fstack-protector to avoid
triggering checks due to alloca(). Examining the resulting canary coverage
changes to common.o, this also removes canaries in other functions,
due to a handful of declarations of "__u64 args[6]" (from seccomp) and
"unsigned long args[6]" (from tracepoints), but their accesses are indexed
(instead of via dynamically sized linear reads/writes) so the risk of
removing useful mitigation coverage here is very low.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/Kconfig        |  1 +
 arch/x86/entry/Makefile |  9 +++++++++
 arch/x86/entry/common.c | 12 +++++++++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index beea77046f9b..b9d449581eb6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -150,6 +150,7 @@ config X86
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if X86_64
 	select HAVE_ARCH_VMAP_STACK		if X86_64
+	select HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
 	select HAVE_ARCH_WITHIN_STACK_FRAMES
 	select HAVE_ASM_MODVERSIONS
 	select HAVE_CMPXCHG_DOUBLE
diff --git a/arch/x86/entry/Makefile b/arch/x86/entry/Makefile
index 06fc70cf5433..7b40e6ae2618 100644
--- a/arch/x86/entry/Makefile
+++ b/arch/x86/entry/Makefile
@@ -7,6 +7,15 @@ OBJECT_FILES_NON_STANDARD_entry_64_compat.o := y
 
 CFLAGS_syscall_64.o		+= $(call cc-option,-Wno-override-init,)
 CFLAGS_syscall_32.o		+= $(call cc-option,-Wno-override-init,)
+
+# Downgrade to -fstack-protector to avoid triggering unneeded stack canary
+# checks due to randomize_kstack_offset. This also removes canaries in
+# other places as well, due to a handful of declarations of __u64 args[6]
+# (seccomp) and unsigned long args[6] (tracepoints), but their accesses
+# are indexed (instead of via dynamically sized linear reads/writes) so
+# the risk of removing useful mitigation coverage here is very low.
+CFLAGS_common.o			+= $(subst -fstack-protector-strong,-fstack-protector,$(filter -fstack-protector-strong,$(KBUILD_CFLAGS)))
+
 obj-y				:= entry_$(BITS).o thunk_$(BITS).o syscall_$(BITS).o
 obj-y				+= common.o
 
diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 9747876980b5..086d7af570af 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -26,6 +26,7 @@
 #include <linux/livepatch.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
+#include <linux/randomize_kstack.h>
 
 #include <asm/desc.h>
 #include <asm/traps.h>
@@ -189,6 +190,13 @@ __visible inline void prepare_exit_to_usermode(struct pt_regs *regs)
 	lockdep_assert_irqs_disabled();
 	lockdep_sys_exit();
 
+	/*
+	 * x86_64 stack alignment means 3 bits are ignored, so keep
+	 * the top 5 bits. x86_32 needs only 2 bits of alignment, so
+	 * the top 6 bits will be used.
+	 */
+	choose_random_kstack_offset(rdtsc() & 0xFF);
+
 	cached_flags = READ_ONCE(ti->flags);
 
 	if (unlikely(cached_flags & EXIT_TO_USERMODE_LOOP_FLAGS))
@@ -283,6 +291,7 @@ __visible void do_syscall_64(unsigned long nr, struct pt_regs *regs)
 {
 	struct thread_info *ti;
 
+	add_random_kstack_offset();
 	enter_from_user_mode();
 	local_irq_enable();
 	ti = current_thread_info();
@@ -355,6 +364,7 @@ static __always_inline void do_syscall_32_irqs_on(struct pt_regs *regs)
 /* Handles int $0x80 */
 __visible void do_int80_syscall_32(struct pt_regs *regs)
 {
+	add_random_kstack_offset();
 	enter_from_user_mode();
 	local_irq_enable();
 	do_syscall_32_irqs_on(regs);
@@ -378,8 +388,8 @@ __visible long do_fast_syscall_32(struct pt_regs *regs)
 	 */
 	regs->ip = landing_pad;
 
+	add_random_kstack_offset();
 	enter_from_user_mode();
-
 	local_irq_enable();
 
 	/* Fetch EBP from where the vDSO stashed it. */
-- 
2.20.1

