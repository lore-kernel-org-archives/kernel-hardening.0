Return-Path: <SRS0=mgmi=IR=lists.openwall.com=kernel-hardening-return-21011-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189A4C433DB
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 21:30:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 32C5C61944
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 21:29:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32C5C61944
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21011-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17416 invoked by uid 550); 19 Mar 2021 21:28:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16214 invoked from network); 19 Mar 2021 21:28:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yYr9wVtQr+Yv2YCxxAWFJhlutYOKWxR3zpP8Meqzwc0=;
        b=e2sppvO/nQd9M+oentUIs5EZBk1imYcO2Y6P9oesc5FiLYNAX5oQUh2eSicFEMB/1v
         YGCJGBJlY/OQDCB3klFA9+MjGrNwknRzu7lBP/9E5AQJ+MDfpULf7OP9Y4ckNoRmtBUj
         selUvH1rqIfKFKSdrXdWwzwTT5SotmIt+srGY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yYr9wVtQr+Yv2YCxxAWFJhlutYOKWxR3zpP8Meqzwc0=;
        b=iELrWDD+cCx8ND16XLXMXEJisSh/hZL/5Jzck+ZlYsB2RDO7bMyH1mHd6qbRkRDfeH
         f+5QMXS/0+0u++6dqFeP/fi5qwojkBLcJeemYvcRqSk39JX8CNVwycwMhaTk9Hhibalr
         r/Wy+i1YYUBoqlkq26MgqmgqWaAUVjwy6ZznUEL4uP2lfX1/EJ1fiDTXicJIJYSWQR7+
         tpvLZeYekiNTvfZcROhrdBIMdZATheheEb1XYgKPiHSy6NVGGrB5R19B7y0yVBMm3AfB
         tBXjO8imxHEiQiRXEy0OGgUuBG82oTvuvC8XUkGheWppYC31eHkeDNmhfeffcpvDvmeN
         n0kw==
X-Gm-Message-State: AOAM533JZENRDAq4qViHi2eicvq2zU0OEmKdLNs2tnakm5YHpfTA6dnx
	iN/ra3pwSvG1yx4aNGzRmCbyQA==
X-Google-Smtp-Source: ABdhPJxJZtzQQ9NDBHr8y2c9/UwW2oc21H/8qpcf3SLyv5Nzuq25MY5g8GZvru/n0ZnOUE0Nb52dKw==
X-Received: by 2002:a17:902:ecc4:b029:e6:1a9f:3397 with SMTP id a4-20020a170902ecc4b02900e61a9f3397mr16226370plh.9.1616189321892;
        Fri, 19 Mar 2021 14:28:41 -0700 (PDT)
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
Subject: [PATCH v7 5/6] arm64: entry: Enable random_kstack_offset support
Date: Fri, 19 Mar 2021 14:28:34 -0700
Message-Id: <20210319212835.3928492-6-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210319212835.3928492-1-keescook@chromium.org>
References: <20210319212835.3928492-1-keescook@chromium.org>
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=ab928f13a74b1e09ed2d4740c77a8520d58ab562; i=6FjHrMJQ1a03WxuPiMt8aIK5MW/T0bayLG0SuUm7Wt4=; m=DW/OKOjAEidoxl6ODEV6zN0c7U/uCvK1t/uZsIkKPaM=; p=MOQyOeWlIC4XP1YdIGtrtyC9k7Ng+ZO0cCzQ0e3ME/8=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmBVF4IACgkQiXL039xtwCbbYQ//aKC RB12qKUepze20ovzs2yJf0dmT1D50yyLFxRAc+jTyXP0XLbJ4FjRRT5JBH295k/HwE1RzY8E/wyL1 MLQbIX8nGuPSmXw5HI2GnGFwyliiKJ2hRW1qIsIik2Ag5GvGzVxJUmnWTKSZYF5ZxgD1qDIPbIUSK d6iWA9NBX3CVxt5pfyvF11mo6rqTIRjrm7A2YBVh908KfXHgmoEPdeXcQ0Y6AQu4OsMcgc/b22hX3 PICTMo2idK40hULIHc4ur454arQ8xCMQm4eQnPkSxI9InUjpLeJFjKxj8xF37UooMVo8ilnQE2JYT VzuR9stuJol0kzVwzvrPNbAoqL9O2/GZtf3G+iGSNGDyYP8XMxy5jW6h9iODPfGxobtVZc1ggixyR hTXR4AWBQy0r8dEIxV5SVpTrosDo3oz5805pws9kIWS4APOy5B5JoYfLjXNcx//68bsB3aV8qOuv1 YIYF5JwCBED2+oXHJSsSEiUg5sMIrqwj/ya6rbLisnMFpkGqjj79IvMBantlGjtEYUfQ4mB0ykF71 BfjftL6zhB2qWfHdjx2E6gOskLK7aHr/GUprx8lp/9dL0O7wlyQ2OvT49GiwElYVO8Ym05Hgu14tM 3xqTfSxjmZSxhRT/qMds2osQ0KCcqoKGEGf1qC2WVjVbHOZDwQqpOVcoccPHRYDs=
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

