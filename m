Return-Path: <SRS0=wgJy=IR=lists.openwall.com=kernel-hardening-return-21008-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B9A8C433C1
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 21:29:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 469EB61944
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 21:29:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 469EB61944
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21008-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16285 invoked by uid 550); 19 Mar 2021 21:28:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16109 invoked from network); 19 Mar 2021 21:28:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DcTnVacz4A0tmKEIIvO2n/EpgXlfdRl1ckINTgAR5oI=;
        b=LDuAGuwSfUrZpxRboSFxPKN0Ol8PCKr96pFsJQdIzM/qmu01vhkcA0luWz1GW1wOSq
         cTWKPn5XjGVcgadIkPWT29E0xa9RT3OgmuDflIEVLyehy0uJmZfQu0krRgXtH4UxsmrA
         4c5MCmdhiwl2Ytt783PrN2LkrmKLUDLi++Qag=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DcTnVacz4A0tmKEIIvO2n/EpgXlfdRl1ckINTgAR5oI=;
        b=rorruTfevxCHtWpmm9Pt+YsFGXETB8XiTR9HAmK26jdUByV85MMA9b5ydiArnsVuq4
         xONw9r/03VjCEFyEsozoFxkZouArD7T4CaFNaKt549i9/Iyut7L3/FFqp2Xa8Ci21D/B
         uZkxEZvRpfW2OSIw/7XH9Me/sFNzipWacOh4EyHT1Osw3QAVya0p6UZ6mot1MGMdNjkv
         YxmbdFpaNKg+SDpFGv8hYlDj4UG0WPlmysWuPTYST/kjCGi2G3Ni0Jc9l++zBpLsJZbb
         k+Pu7XVG1LKa8pQVGkQjpGA9dYxhuECMvkFS5EGqhL3itYEqXXOx5uMVddTTforE9L6N
         Bk5A==
X-Gm-Message-State: AOAM530QKtA0puvjH5J2p4OTyxjFdRAKlEheRnL19CvDvenN9x5EHjG3
	zL+D28HU6zsF+oMzT8T5zOZ+ig==
X-Google-Smtp-Source: ABdhPJxdZl5dz8J4HcEGq1U3sh6smFuioiTtHkZWIFJMoaQp6bhf/5gie+v1/Mx7ts/oSjDBRYpagg==
X-Received: by 2002:a62:3706:0:b029:211:3d70:a55a with SMTP id e6-20020a6237060000b02902113d70a55amr8176181pfa.16.1616189320750;
        Fri, 19 Mar 2021 14:28:40 -0700 (PDT)
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
Subject: [PATCH v7 4/6] x86/entry: Enable random_kstack_offset support
Date: Fri, 19 Mar 2021 14:28:33 -0700
Message-Id: <20210319212835.3928492-5-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210319212835.3928492-1-keescook@chromium.org>
References: <20210319212835.3928492-1-keescook@chromium.org>
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=1a3993b6371bcc7c9fa1576e563a724a70c25875; i=np7yed3mY+gWIWkexmB7CyDLgwsIh0xV2RGaksJc7tI=; m=cc9SLz8pm+mdXOKZLHtRjH7FITDzwHCOKmwFrX1p7io=; p=UyRR1nzRrbUXeUU5ICay1xt2wYZVgu7b/Eh0FjkN2Hc=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmBVF4IACgkQiXL039xtwCZ0TA/9G5L 4Gq2XDB0ORCV3ObWCFjNzoB1X2U6WW+MZpa4KHua8XcqEdD1tyl5O+itJM/5Wb8Mz3y5l94bcih0o yxUkaZovC9XNFy/WEs8LOM40hMq+I9+X7a24iYc1mjjhLyq5UBsbbWImJL6AZzYz+u+kynyXwCt3l iTXAnBMJ9DxlxVYHuShxa8q6IV6EPGJQgZ+1T5PiykslYR3mlT8rdcceClY1UPXIxnqZQJ89zVbbO 6zAGbjmnBKlFkOe52j39gKV+Cy/XYTltWGtmexS3FxEsqWcS73rE9Hy9ywx2BgNXL9GFFPotX27ZT cNugmpMFNsaJYo8VQviS8aCAI1Nao0OBdTa/Dup84TjWNmSmvU5ELSfFNJUlRdA2Jcq6QukJReF7E am6n+8M7bYGnOB6Azb9+Iz9KO13ScywyBH4b3ehBnLPHqu6K1R0cj7lu2Wy/K9sSwtN/DzzK73B61 Ghj1DwusmuGubHrAeI2J7eDW/MxSD/V6gA69jiZNeC+knnWVwd1hKtccvGOwq20nLh5plq57W644z 0f010Jg2Tr33OVcOu6RaIZ2KN/ttqs2KZrWKLCTkkZ2IHVp33I2CptMX2cuOIJDuXQJ+qap/csjkI 9y/2ZoPKpNqjwOWJJgeJ0POfwOy79dXv7uQe3fDwAmNN0455mTROFFDzgFak4vj0=
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

