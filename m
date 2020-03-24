Return-Path: <SRS0=4ZUS=5J=lists.openwall.com=kernel-hardening-return-18199-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A83D4C54EEB
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 20:33:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 077F120788
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 20:33:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="S9Srk3vt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 077F120788
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18199-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18150 invoked by uid 550); 24 Mar 2020 20:32:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18007 invoked from network); 24 Mar 2020 20:32:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c3b1sjWFJGWk+HhbHvBn4evu301M7fqA/kMQ4pyC4tI=;
        b=S9Srk3vtm/u5AWxb5Lq0VLBe/+/+CUvcc/nWuriifzbcDxo3ZwBkLe8Zpl+BamGg/O
         HO1v1zWZwiU7plLhdxR37s1Jaqc0uJSA8G7tsY4VxqWCO/G2fiHTxNvERagnEIgId99M
         jOOdb0wJUrZaXGZR5SVzv7rR8cyPHnbBh6gDc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c3b1sjWFJGWk+HhbHvBn4evu301M7fqA/kMQ4pyC4tI=;
        b=rO1g+5xCBL3okOFIix+x5dmDAqmR1sZTzOuW7nh36g4fds3xILiZ92NvONEqPCwxKn
         QPRwAh5DkozW4Pez57ZmPbXE5/RDhj+oL2W3PLWre0iFDtZFSFQf2CN/Y0zgbluU2JqX
         NgTaujxtqRv1a1uzfL8F77GKR4E99wqHxvUdX1slVwva//xczDMBZXa81rG1L4IpdCyc
         l++EmPpvwUpuPMS8pEXcAnhZyGKYZzLhUI5AL9ULqs6JHowzR3GDoHpqTHaCcBwt24kd
         wy1LkPlramxX4ahuLFPmv4TUdi6I1o6ueRsNrA/0JV5uXwof6YgeZBQBhAgDlBa8Mn0a
         Ghkw==
X-Gm-Message-State: ANhLgQ2NVvECXNa4AqHrBOa82FZXG5r+PloNdLfZFBNhUcUBDoTWyYlb
	HILXAFCQ0HIMk77WW9CoAnolkg==
X-Google-Smtp-Source: ADFU+vtXBHEgdg26RkMBmCkSMYW4AGLyko9MzjPWEETXma0en8jpa6fm5D16S9175yT7TTEUnSU+xQ==
X-Received: by 2002:a17:90a:1911:: with SMTP id 17mr205762pjg.65.1585081963230;
        Tue, 24 Mar 2020 13:32:43 -0700 (PDT)
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
	"Perla, Enrico" <enrico.perla@intel.com>,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] arm64: entry: Enable random_kstack_offset support
Date: Tue, 24 Mar 2020 13:32:31 -0700
Message-Id: <20200324203231.64324-6-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324203231.64324-1-keescook@chromium.org>
References: <20200324203231.64324-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow for a randomized stack offset on a per-syscall basis, with roughly
5 bits of entropy.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm64/Kconfig          |  1 +
 arch/arm64/kernel/syscall.c | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 0b30e884e088..4d5aa4959f72 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -127,6 +127,7 @@ config ARM64
 	select HAVE_ARCH_MMAP_RND_BITS
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
 	select HAVE_ARCH_PREL32_RELOCATIONS
+	select HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_STACKLEAK
 	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index a12c0c88d345..238dbd753b44 100644
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
2.20.1

