Return-Path: <SRS0=YfXP=I6=lists.openwall.com=kernel-hardening-return-21136-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E90CC433ED
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 23:24:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9134A61103
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 23:24:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9134A61103
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21136-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11631 invoked by uid 550); 1 Apr 2021 23:24:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11557 invoked from network); 1 Apr 2021 23:24:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0iK0aKBdGLAGxgJdxBWHAkXtURWP8RQAHBQ4WEZMvwk=;
        b=Z2CHDUVkMSklshFb3NxT2bGXR27w+GSF7tsZqr9rE37jCHuIY3AbMQ6qxvUEcX5ZQ1
         1/gG1wOvJE0yHvcAYlTXZLJsaCgA7GWr2Hw8NKcZ1wFqXLQBLSWNe7bKEbfp4Kyy+15z
         Cd+u2AWoLCR2TLY6GXxxprij+RZMuXhv0eeN8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0iK0aKBdGLAGxgJdxBWHAkXtURWP8RQAHBQ4WEZMvwk=;
        b=jC0OBo2pcc2/wUmvd2EmK3NTfG9a+pj6bXgvjnTSF8HZ+jDZ+joNkchgvqH3reTr7t
         YYJydgPrz2dIYNs4oCtT8deMUh1LqdQravGN0/4i+nInMecIWb202wzK+0V6qBC0pJQd
         bXW0mCocMz5BlpKeT3u2AFsVMnLNHs2mPra36TP4H5Z9kyodziVQbJJcEE2SdYlLmp+D
         dcT5mGh7Gm7gwwqvi/D5DW8DGkzGCq+x88/pP69djoytvEdJOVAd7LxMLziTkO7Of//r
         x8MaMHCVfEsYZmPwmYKH3M85OEmEYVP9KGLsfOTGH6EYjT/7tAYbG4scVi8zryYwZg3P
         IVrA==
X-Gm-Message-State: AOAM531UjInWP26GIIsr99iHSGlYVHP3SXfqTZ4BeEGBySM1s1botCC+
	7/09Lq96z8Ht16Xr9yt0Sjb4Aw==
X-Google-Smtp-Source: ABdhPJxvvMTlD4QwOl/dE2dQVrae6FQePxPse4C77UO8+oMVT91t15kw3UOGk9sRJC6/hxpNs1Q28g==
X-Received: by 2002:a05:6a00:1350:b029:227:7a8b:99c9 with SMTP id k16-20020a056a001350b02902277a8b99c9mr9603503pfu.73.1617319432097;
        Thu, 01 Apr 2021 16:23:52 -0700 (PDT)
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
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 4/6] x86/entry: Enable random_kstack_offset support
Date: Thu,  1 Apr 2021 16:23:45 -0700
Message-Id: <20210401232347.2791257-5-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210401232347.2791257-1-keescook@chromium.org>
References: <20210401232347.2791257-1-keescook@chromium.org>
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=5ebd0a02df09ef237ee07421c9f73e94deeaf170; i=np7yed3mY+gWIWkexmB7CyDLgwsIh0xV2RGaksJc7tI=; m=bWJ56lJBn9Ma2AQu8aultasTTfx/BX5M5azaoQbfD3I=; p=EuIQlileJ2PUD6W0Q1r2arSRAFiVT/zqDgDnM3BVsdE=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmBmVgIACgkQiXL039xtwCYJfQ//R01 +ruGpfNJgR38fkaOdtzHbDqDlJxmSNFRC8/dN3FGy/e8NTkweXZd+TPUWSRssw9mev1qqdZWr1DaQ GeFsLCwKMWeZLe5D1t34WvH09xuhIxcOIrFKYqbs5J76yT492D7yIk/MAkGnvXh1042U5k3At+Vcn rwHW9ynX6sTvAzEiiTQGJKcSDvQSfUCoi1oIFEugCNoesi5WgfCbdIqD8nOiCkb8Zfl6JKEUtyceE WT61pe3ZutEbpn7k78ypOmwqFBPhJm2F9VrOIXz+CcmYTBEjowzd0iErcIUMannJfXP05bfL550cP 0VYAEG0IFFissaoezJRmFqCgx3osXEkLkAm/LWNfXfW36ijHZZgJR69TuHYwPEdneGOrcU46McEt5 9+0lT1L9ajNTB01KrLzS2RhQIV6+uXjTIoS4Q0tHSMqpMMsOvbjvXANwMlMHg6vTPpqVrLFf2JScy K4yGVN6gS9pGqJ0c0iMK91nYmrlze3N2+eu5P1lcYVBfmvwpa2PNWkAtMkcrkabJCBWbao7w9yJTd C1EQD9gN1AbTlckl+EcM3Kqq4E5z9/zzJawIMLpHbg7au5q00TadCiR0huOkuR+e4hWTvWvzuSdgK EFXsFx+LXQjd3kXGaBtnkoNEFz3nPp7Ag7P7eYwvaHi26k5yW9Cy0dWZGC9FGAWM=
Content-Transfer-Encoding: 8bit

Allow for a randomized stack offset on a per-syscall basis, with roughly
5-6 bits of entropy, depending on compiler and word size. Since the
method of offsetting uses macros, this cannot live in the common entry
code (the stack offset needs to be retained for the life of the syscall,
which means it needs to happen at the actual entry point).

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/lkml/87lfa369tv.ffs@nanos.tec.linutronix.de/
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/Kconfig                    |  1 +
 arch/x86/entry/common.c             |  3 +++
 arch/x86/include/asm/entry-common.h | 16 ++++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2792879d398e..4b4ad8ec10d2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -165,6 +165,7 @@ config X86
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if X86_64
 	select HAVE_ARCH_USERFAULTFD_WP         if X86_64 && USERFAULTFD
 	select HAVE_ARCH_VMAP_STACK		if X86_64
+	select HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
 	select HAVE_ARCH_WITHIN_STACK_FRAMES
 	select HAVE_ASM_MODVERSIONS
 	select HAVE_CMPXCHG_DOUBLE
diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index a2433ae8a65e..810983d7c26f 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -38,6 +38,7 @@
 #ifdef CONFIG_X86_64
 __visible noinstr void do_syscall_64(unsigned long nr, struct pt_regs *regs)
 {
+	add_random_kstack_offset();
 	nr = syscall_enter_from_user_mode(regs, nr);
 
 	instrumentation_begin();
@@ -83,6 +84,7 @@ __visible noinstr void do_int80_syscall_32(struct pt_regs *regs)
 {
 	unsigned int nr = syscall_32_enter(regs);
 
+	add_random_kstack_offset();
 	/*
 	 * Subtlety here: if ptrace pokes something larger than 2^32-1 into
 	 * orig_ax, the unsigned int return value truncates it.  This may
@@ -102,6 +104,7 @@ static noinstr bool __do_fast_syscall_32(struct pt_regs *regs)
 	unsigned int nr = syscall_32_enter(regs);
 	int res;
 
+	add_random_kstack_offset();
 	/*
 	 * This cannot use syscall_enter_from_user_mode() as it has to
 	 * fetch EBP before invoking any of the syscall entry work
diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/entry-common.h
index 2b87b191b3b8..14ebd2196569 100644
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_X86_ENTRY_COMMON_H
 #define _ASM_X86_ENTRY_COMMON_H
 
+#include <linux/randomize_kstack.h>
 #include <linux/user-return-notifier.h>
 
 #include <asm/nospec-branch.h>
@@ -70,6 +71,21 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
 	 */
 	current_thread_info()->status &= ~(TS_COMPAT | TS_I386_REGS_POKED);
 #endif
+
+	/*
+	 * Ultimately, this value will get limited by KSTACK_OFFSET_MAX(),
+	 * but not enough for x86 stack utilization comfort. To keep
+	 * reasonable stack head room, reduce the maximum offset to 8 bits.
+	 *
+	 * The actual entropy will be further reduced by the compiler when
+	 * applying stack alignment constraints (see cc_stack_align4/8 in
+	 * arch/x86/Makefile), which will remove the 3 (x86_64) or 2 (ia32)
+	 * low bits from any entropy chosen here.
+	 *
+	 * Therefore, final stack offset entropy will be 5 (x86_64) or
+	 * 6 (ia32) bits.
+	 */
+	choose_random_kstack_offset(rdtsc() & 0xFF);
 }
 #define arch_exit_to_user_mode_prepare arch_exit_to_user_mode_prepare
 
-- 
2.25.1

