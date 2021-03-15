Return-Path: <SRS0=MrWN=IN=lists.openwall.com=kernel-hardening-return-20938-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7063FC433DB
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Mar 2021 18:03:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8C2CE64F26
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Mar 2021 18:03:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C2CE64F26
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20938-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11496 invoked by uid 550); 15 Mar 2021 18:02:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11296 invoked from network); 15 Mar 2021 18:02:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DcTnVacz4A0tmKEIIvO2n/EpgXlfdRl1ckINTgAR5oI=;
        b=PQ3XGnvMsKcXU4s5p+F5dfZF6FA/iSbcSn0nswwcqPExK09KIRLEltkz0Bh8wiwE7N
         1XkNp1GfB55SBD6zDGJQRjdRpTR4DYjid5msGEofOSSYqbipdCIbWhBqrPM9AWy1UM52
         l+EaNe1XtG5skHL76gK0sXV38Rb8Lgh4egJtA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DcTnVacz4A0tmKEIIvO2n/EpgXlfdRl1ckINTgAR5oI=;
        b=M6k33OHSUk9V7sdOjYt4SY6rMoXUo9JZUGoMVpV1RbI7ir4pjP/D4r27YUx1Kl4y1m
         aVfTvWSDJ/5sNnTio168x17Vnmdjf6lfNXaYnMBy18E0GtWaGV/Ox2loEjLfgZ8qydJE
         Njbx4uqQy2KDcxhTwjJbKh18B6i7/FGFNYAQUGwJDgC4jeC12DrYRB1UdmVYWu8hhOMm
         dY5bo5KBUv3u/0Jpyf4WTYHSojlQNUIpySXUonHp0Qw2OUlxXxBlHc4ZByCUEG3EvzFY
         BUUPH8/6FHIR9mJra7UyupK7Vrl3GYgkU8xqU0UQ7GXFzGs+lFriCTumHiIQ8h8kIjQI
         cAjw==
X-Gm-Message-State: AOAM533sBhdvMePZ+MjOUOhyANzcckiBxJUabr1ZOHsjXNFJ1GOnAOb1
	hXm+sYaQniFCGqu5S09Jso0b/g==
X-Google-Smtp-Source: ABdhPJxy/jBx4lbYUG9dTL/BSOwG++1sLNIRxLhlf/Aak5xk+P2rM72P6uwME362sOaUIYrG0OIg4w==
X-Received: by 2002:a65:4c86:: with SMTP id m6mr314819pgt.174.1615831358475;
        Mon, 15 Mar 2021 11:02:38 -0700 (PDT)
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
Subject: [PATCH v6 4/6] x86/entry: Enable random_kstack_offset support
Date: Mon, 15 Mar 2021 11:02:27 -0700
Message-Id: <20210315180229.1224655-5-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210315180229.1224655-1-keescook@chromium.org>
References: <20210315180229.1224655-1-keescook@chromium.org>
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=1a3993b6371bcc7c9fa1576e563a724a70c25875; i=np7yed3mY+gWIWkexmB7CyDLgwsIh0xV2RGaksJc7tI=; m=cc9SLz8pm+mdXOKZLHtRjH7FITDzwHCOKmwFrX1p7io=; p=UyRR1nzRrbUXeUU5ICay1xt2wYZVgu7b/Eh0FjkN2Hc=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmBPoTQACgkQiXL039xtwCb9dw/8CDN Ir13NcCLMJOuRm2LpzDYbdgOc9JQ2QokpXPH/jLGBVXWXwV2g8Nk5TYJJcm7X/yj75HbSyNJLBUVU c8QbEGqzcBxjyIZUTKBDrYfApusLejywRj5YCmq1CONO5XBcJTMPuNAo1ZlzyQ0fI+754FraF3eU/ O8qcOD18DBVIsRP7e9ASpSyjqINb46mpEDrlvXa+uJyzGfAGLz+B0NLm6WPK0eaKzRmPC3mUs5gXU 9pL8/JlmcsD3Ne3kzSexmn7+uvYXEcwRagE8A76gkzE69JK3Lq8uIAyFARV2VO8mXZcUD/loxowRK vpn44j3EK04VB/Nf0IEDP6SNkNmSFvdqOSbp8gXcBI+rAJgA91SXLBf+ld9pIsIkGf6+uvY+rKqb7 XT7pyiu/3f7C3m64R7FFFUsWH6waSp2VR4ccIbNM97N6o5FY5keipPsjJNinKedZwOGjmY2O+FMkE nxUr2FjxcwFOBCbAkwJL+rgVv9UPOprPnq+Gxi6axTrDjRe3JoWtapLhbdDjHYLos7Gh5+UhghIj/ vYKfMHbHOOlKyhcrufiMXbcy0dkK6EK9ES3KNDmWu0cpxS2QAPrJvyrC6eCIxT9T0fko/eWgdUhWi ZNc8RzQeH2jVopqqCkmd8L74weZxz2gnh8S5w2OW3/yb5VWZ8VjJWDr3879m6aVE=
Content-Transfer-Encoding: 8bit

Allow for a randomized stack offset on a per-syscall basis, with roughly
5-6 bits of entropy, depending on compiler and word size. Since the
method of offsetting uses macros, this cannot live in the common entry
code (the stack offset needs to be retained for the life of the syscall,
which means it needs to happen at the actual entry point).

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/Kconfig                    | 1 +
 arch/x86/entry/common.c             | 3 +++
 arch/x86/include/asm/entry-common.h | 8 ++++++++
 3 files changed, 12 insertions(+)

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
index 2b87b191b3b8..8e41566e154a 100644
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_X86_ENTRY_COMMON_H
 #define _ASM_X86_ENTRY_COMMON_H
 
+#include <linux/randomize_kstack.h>
 #include <linux/user-return-notifier.h>
 
 #include <asm/nospec-branch.h>
@@ -70,6 +71,13 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
 	 */
 	current_thread_info()->status &= ~(TS_COMPAT | TS_I386_REGS_POKED);
 #endif
+
+	/*
+	 * x86_64 stack alignment means 3 bits are ignored, so keep
+	 * the top 5 bits. x86_32 needs only 2 bits of alignment, so
+	 * the top 6 bits will be used.
+	 */
+	choose_random_kstack_offset(rdtsc() & 0xFF);
 }
 #define arch_exit_to_user_mode_prepare arch_exit_to_user_mode_prepare
 
-- 
2.25.1

