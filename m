Return-Path: <SRS0=MaM+=AD=lists.openwall.com=kernel-hardening-return-19033-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69AFEC433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 19:32:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B882E20776
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 19:32:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="J/uzTV9o"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B882E20776
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19033-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19553 invoked by uid 550); 22 Jun 2020 19:32:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19514 invoked from network); 22 Jun 2020 19:32:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LkjcF2W3iR+CPlZbMflQ6gTadXRXXr87sQKE5d5Gz6g=;
        b=J/uzTV9owlvRdao+cxwp8Vslq/cFyZE3Lw8w6UUjzYWCr5LjrjVVNFSCVkinxX4Y2H
         kx/K7FzydtI/KfWHnOel3UOO4tgm0ampnIQbO/M+28yKFT7/EZw/h52Jk9ZvEqY4xdyo
         Gk7/un3Abi/4AXl0tPJ/akjqNspTqiopNeHAw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LkjcF2W3iR+CPlZbMflQ6gTadXRXXr87sQKE5d5Gz6g=;
        b=AZvK/0z8xqM31UWS6wDJYLKGAh8pQYlvDsavN/HShierosJuS6+bDw93OZZN7sUC2E
         O+b89UAt3jqbnKUnSXXXolqa3uyTQJNVBSIi2m469HSIyMB4x4FEsQ2/msS/3XIa+Jn+
         pjkmy0LBkpaHyXak+G4dkIIXPkxJ5z7J6zABYAFoFIOWqMJt2QJcC+xtOws+CmPYLfgZ
         fVYgXH4Bw70N+dHSlRa51u2kLyJuWSYSGppRO+u75jlX7NeCLQEU33fBckWSlEHhxCfu
         NPrEMaKycuXyGepeG3KwKI2OGqy4dXKwyJHjS7Q/9XcZgJDuiU2bsNX+CAjKMoa+N12b
         oQAQ==
X-Gm-Message-State: AOAM5305PaxsjFWdDmabaTXumEr6HyzwMLOYX2sQTmvh8qAX2MusMaWZ
	NXXIemI99pto1xgDfpLArlKOzQ==
X-Google-Smtp-Source: ABdhPJzsD2uLlmJ7YMnz76yJmcuXkfmLp3DfOApUsk4PZt0cKKx5QBWDZp5Da97pcoyR3Ss/b2BgBg==
X-Received: by 2002:a17:902:8bc7:: with SMTP id r7mr7968646plo.174.1592854311241;
        Mon, 22 Jun 2020 12:31:51 -0700 (PDT)
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
Subject: [PATCH v4 4/5] x86/entry: Enable random_kstack_offset support
Date: Mon, 22 Jun 2020 12:31:45 -0700
Message-Id: <20200622193146.2985288-5-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200622193146.2985288-1-keescook@chromium.org>
References: <20200622193146.2985288-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow for a randomized stack offset on a per-syscall basis, with roughly
5 bits of entropy.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/Kconfig        |  1 +
 arch/x86/entry/common.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6a0cc524882d..57c2a458150e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -156,6 +156,7 @@ config X86
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if X86_64
 	select HAVE_ARCH_USERFAULTFD_WP         if X86_64 && USERFAULTFD
 	select HAVE_ARCH_VMAP_STACK		if X86_64
+	select HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
 	select HAVE_ARCH_WITHIN_STACK_FRAMES
 	select HAVE_ASM_MODVERSIONS
 	select HAVE_CMPXCHG_DOUBLE
diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index bd3f14175193..681125bbf09a 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -26,6 +26,7 @@
 #include <linux/livepatch.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
+#include <linux/randomize_kstack.h>
 
 #ifdef CONFIG_XEN_PV
 #include <xen/xen-ops.h>
@@ -240,6 +241,13 @@ static void __prepare_exit_to_usermode(struct pt_regs *regs)
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
@@ -346,6 +354,7 @@ __visible noinstr void do_syscall_64(unsigned long nr, struct pt_regs *regs)
 {
 	struct thread_info *ti;
 
+	add_random_kstack_offset();
 	enter_from_user_mode();
 	instrumentation_begin();
 
@@ -409,6 +418,7 @@ static void do_syscall_32_irqs_on(struct pt_regs *regs)
 /* Handles int $0x80 */
 __visible noinstr void do_int80_syscall_32(struct pt_regs *regs)
 {
+	add_random_kstack_offset();
 	enter_from_user_mode();
 	instrumentation_begin();
 
@@ -467,6 +477,7 @@ __visible noinstr long do_fast_syscall_32(struct pt_regs *regs)
 	 */
 	regs->ip = landing_pad;
 
+	add_random_kstack_offset();
 	enter_from_user_mode();
 	instrumentation_begin();
 
-- 
2.25.1

