Return-Path: <SRS0=yVpq=IH=lists.openwall.com=kernel-hardening-return-20894-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00266C433E6
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Mar 2021 21:44:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0709464ED6
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Mar 2021 21:44:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0709464ED6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20894-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15930 invoked by uid 550); 9 Mar 2021 21:43:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15853 invoked from network); 9 Mar 2021 21:43:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yYr9wVtQr+Yv2YCxxAWFJhlutYOKWxR3zpP8Meqzwc0=;
        b=QfuDisPe9e6LA5+G0OqhJOKbJhyOfYMgFYd71oYjyW/qjnQRskxH2DwSwWa+zduR8z
         WQIq/CMZhY4sesmNBwH3ZsjovTqvPGWkSa5KYVH6qBsI8Qa7U87NKh3nubJFEJT8vq1A
         thA54toHbJNY99F/Bh83DjOw1zoidC/seKkGg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yYr9wVtQr+Yv2YCxxAWFJhlutYOKWxR3zpP8Meqzwc0=;
        b=i1RxBKJ2ioU5bdMoTwwcbjEEazXDje1AflqkNC9l8GBd+IouM79Bxn04TkIds00GjU
         N3mJCiLR8Dngz3+n8HEatdokHp7k6/nUNAoyErPFPFdSnQxBF/e37YpuiHXjbaXNwgKj
         hnZAX6xAv9IlTt0cHteQcRcQJ1lS+9Zj+SZAfXdsHeW2BIRGdjgZe/D8tGWWANNUSMy2
         3MX4aDTv0fGLSQC6dQ9NLn0QtubXJcIBarxTwu/wvcZEXBVJdKrh0mY31nbBbJqM5UF6
         APCkDiCZA4yUTH53vm4Iv4WeAEVpDikwnSnU3KU5HoCFLgZe6NEx0Dn9SmJqyRqkw7ns
         /JCQ==
X-Gm-Message-State: AOAM531p2sl7QG9IFLF9uEp1J2fakGDEhiSGoHAwAcGnynxbcedQp2HS
	CbzlXLZRdX4txkZR0TcPUB74mg==
X-Google-Smtp-Source: ABdhPJzTZix3DrfI3gS99XuookHZB6B8CC1mG7Unokf53d9LadNonom0utrVmg95TnKUZqX4fQ7VFg==
X-Received: by 2002:aa7:8f31:0:b029:1f8:987a:53dc with SMTP id y17-20020aa78f310000b02901f8987a53dcmr183958pfr.58.1615326193543;
        Tue, 09 Mar 2021 13:43:13 -0800 (PST)
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
	linux-hardening@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v5 6/7] arm64: entry: Enable random_kstack_offset support
Date: Tue,  9 Mar 2021 13:43:00 -0800
Message-Id: <20210309214301.678739-7-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210309214301.678739-1-keescook@chromium.org>
References: <20210309214301.678739-1-keescook@chromium.org>
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=ab928f13a74b1e09ed2d4740c77a8520d58ab562; i=6FjHrMJQ1a03WxuPiMt8aIK5MW/T0bayLG0SuUm7Wt4=; m=DW/OKOjAEidoxl6ODEV6zN0c7U/uCvK1t/uZsIkKPaM=; p=MOQyOeWlIC4XP1YdIGtrtyC9k7Ng+ZO0cCzQ0e3ME/8=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmBH6+QACgkQiXL039xtwCYAOg/+LgJ WgPJrpVY1ZhBup8fAF1iuohmC84qyEJf6H4fbXp63l60M3UxTJ/GNL23TdcEGxQ8swftFHFIkr6Nd xG8VuQNA3smCz7L5MqWyBsB2nf+SPSUYuC3mptJdGzraaD413rLhBOFojCAEDCWP7sYFRUtrV73am ZcSqH9n5FUVIbzACUtPaml/B7mEtFPB+lI6fJpLro72hGw6sjQJRkpiS5VhbWjJASeF47iChKcjBU l3m3qWTWSLt3SmZAaY+4XtHe1+TyOXw9RhR+erXEh6JmHpTQE6R4XRF9bkrRlUOboPGy502udXKds taG9ORm/JqzGUvKMUmgi1tjDPhPreYlYRNj4UaEIPLyPwfdbmatXCFyXM3YAkCKB74NE9rUI0W8pY w/dOS6d5U//pA346jb6D63ve1AMvz3boSI2IF0tm/BICqKURWY9oPV8h4wOM4FicJcBJNjRcwYK6x g0iwgAyle/C6bLnhgmWqApDv1NZ/boLi9Abl0qrQQxT7N1qfQOurTSsruSH0ZLauLKyQ7IGl6eELk HZ1Dxj2F1KBjPI2amq7hA7CrjogfXhsT5hqlw/f/By35OJk5gTSvOVGf5MY9LN4vd4o7O5FvboPlL XZvG0zwFnf+9JMrsXyGq0qjdoQuX9HtS1IQ7PM5EVEArilikYizdLC0wkQnHc5Cg=
Content-Transfer-Encoding: 8bit

Allow for a randomized stack offset on a per-syscall basis, with roughly
5 bits of entropy. (And include AAPCS rationale AAPCS thanks to Mark
Rutland.)

In order to avoid unconditional stack canaries on syscall entry (due to
the use of alloca()), also disable stack protector to avoid triggering
needless checks and slowing down the entry path. As there is no general
way to control stack protector coverage with a function attribute[1],
this must be disabled at the compilation unit level. This isn't a problem
here, though, since stack protector was not triggered before: examining
the resulting syscall.o, there are no changes in canary coverage (none
before, none now).

[1] a working __attribute__((no_stack_protector)) has been added to GCC
and Clang but has not been released in any version yet:
https://gcc.gnu.org/git/gitweb.cgi?p=gcc.git;h=346b302d09c1e6db56d9fe69048acb32fbb97845
https://reviews.llvm.org/rG4fbf84c1732fca596ad1d6e96015e19760eb8a9b

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm64/Kconfig          |  1 +
 arch/arm64/kernel/Makefile  |  5 +++++
 arch/arm64/kernel/syscall.c | 10 ++++++++++
 3 files changed, 16 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1f212b47a48a..2d0e5f544429 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -146,6 +146,7 @@ config ARM64
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
 	select HAVE_ARCH_PFN_VALID
 	select HAVE_ARCH_PREL32_RELOCATIONS
+	select HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_STACKLEAK
 	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index ed65576ce710..6cc97730790e 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -9,6 +9,11 @@ CFLAGS_REMOVE_ftrace.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_insn.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_return_address.o = $(CC_FLAGS_FTRACE)
 
+# Remove stack protector to avoid triggering unneeded stack canary
+# checks due to randomize_kstack_offset.
+CFLAGS_REMOVE_syscall.o	 = -fstack-protector -fstack-protector-strong
+CFLAGS_syscall.o	+= -fno-stack-protector
+
 # Object file lists.
 obj-y			:= debug-monitors.o entry.o irq.o fpsimd.o		\
 			   entry-common.o entry-fpsimd.o process.o ptrace.o	\
diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index b9cf12b271d7..58227a1c207e 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -5,6 +5,7 @@
 #include <linux/errno.h>
 #include <linux/nospec.h>
 #include <linux/ptrace.h>
+#include <linux/randomize_kstack.h>
 #include <linux/syscalls.h>
 
 #include <asm/daifflags.h>
@@ -43,6 +44,8 @@ static void invoke_syscall(struct pt_regs *regs, unsigned int scno,
 {
 	long ret;
 
+	add_random_kstack_offset();
+
 	if (scno < sc_nr) {
 		syscall_fn_t syscall_fn;
 		syscall_fn = syscall_table[array_index_nospec(scno, sc_nr)];
@@ -55,6 +58,13 @@ static void invoke_syscall(struct pt_regs *regs, unsigned int scno,
 		ret = lower_32_bits(ret);
 
 	regs->regs[0] = ret;
+
+	/*
+	 * The AAPCS mandates a 16-byte (i.e. 4-bit) aligned SP at
+	 * function boundaries. We want at least 5 bits of entropy so we
+	 * must randomize at least SP[8:4].
+	 */
+	choose_random_kstack_offset(get_random_int() & 0x1FF);
 }
 
 static inline bool has_syscall_work(unsigned long flags)
-- 
2.25.1

