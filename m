Return-Path: <SRS0=0MHO=VF=lists.openwall.com=kernel-hardening-return-16392-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B90C2C606BD
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2019 17:51:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 163D22189F
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2019 17:51:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="kU0hTEVJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 163D22189F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16392-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28441 invoked by uid 550); 8 Jul 2019 17:49:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28377 invoked from network); 8 Jul 2019 17:49:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ePdEUdrca6fFwO52Os//aVk9SOcvqdOqJdcWyryzZTw=;
        b=kU0hTEVJAcl6SkM40WFYbml9NRVB/VRgYvcodBevBVS7b5Dci28pvYAr2xfhi/axgn
         eBQEcW6Js8KEf09C6+AFw/yxAlwdgGyE2B1AsbeW+pGDw2pR18c+hPy5YlvCsK4qNBBV
         8XE2uXEe8ZEhINFcEgDl/BiQWMLWv9/IddJBg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ePdEUdrca6fFwO52Os//aVk9SOcvqdOqJdcWyryzZTw=;
        b=In4rxyE8xoIq9hv+/Rl93qCG1sjI2TBb8rYoBjZpO1n+a3+hhAjWXigbDN/xEzPsUS
         qlV6o4KnkDo25CH/FqbHpOC0clJe+4iO3F8Mp/FYBs2j42rQjRU5C1OpjwYYE/U9pJ0A
         5vOocNDssVqy3WrZ2XQXzF6UMuHdtMC1rnngv8ZZDarDwMndivyX5SYvJzr/vC7nPI7e
         LQJ3fe4PYCRY8e3h6cZNR8G1hQMbjO/vO2mEqsyX0xyPN+o6i1eBKuhcUR/tb/F2zm/H
         XAxAt7m/+sPnLLvU6f8xlnWXopd6agR1i0KM70JHX/Q9rJEEaxQGypO12LqqrQt/XPV+
         m/6g==
X-Gm-Message-State: APjAAAXDmPGOKJZEtAv5KH1Q3muw66/50I9WkA6QoY1w70/20OIG5ydz
	ec4nTLnZZoLzqgWuceRSIHn6fQGJd8k=
X-Google-Smtp-Source: APXvYqxlefZEZZIMWA46QmINk8z9e/nAo/rW+qIWGkvdt+qwKeKFE8s8d+qOafqM7Ad1JAdHYwQagA==
X-Received: by 2002:a63:231c:: with SMTP id j28mr25012871pgj.430.1562608178690;
        Mon, 08 Jul 2019 10:49:38 -0700 (PDT)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	keescook@chromium.org,
	Thomas Garnier <thgarnie@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Feng Tang <feng.tang@intel.com>,
	Maran Wilson <maran.wilson@oracle.com>,
	Andy Lutomirski <luto@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 08/11] x86/boot/64: Adapt assembly for PIE support
Date: Mon,  8 Jul 2019 10:49:01 -0700
Message-Id: <20190708174913.123308-9-thgarnie@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190708174913.123308-1-thgarnie@chromium.org>
References: <20190708174913.123308-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the assembly code to use only relative references of symbols for the
kernel to be PIE compatible.

Early at boot, the kernel is mapped at a temporary address while preparing
the page table. To know the changes needed for the page table with KASLR,
the boot code calculate the difference between the expected address of the
kernel and the one chosen by KASLR. It does not work with PIE because all
symbols in code are relatives. Instead of getting the future relocated
virtual address, you will get the current temporary mapping.
Instructions were changed to have absolute 64-bit references.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/kernel/head_64.S | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index bcd206c8ac90..64a4f0a22b20 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -90,8 +90,10 @@ startup_64:
 	popq	%rsi
 
 	/* Form the CR3 value being sure to include the CR3 modifier */
-	addq	$(early_top_pgt - __START_KERNEL_map), %rax
+	movabs  $(early_top_pgt - __START_KERNEL_map), %rcx
+	addq    %rcx, %rax
 	jmp 1f
+
 ENTRY(secondary_startup_64)
 	UNWIND_HINT_EMPTY
 	/*
@@ -120,7 +122,8 @@ ENTRY(secondary_startup_64)
 	popq	%rsi
 
 	/* Form the CR3 value being sure to include the CR3 modifier */
-	addq	$(init_top_pgt - __START_KERNEL_map), %rax
+	movabs	$(init_top_pgt - __START_KERNEL_map), %rcx
+	addq    %rcx, %rax
 1:
 
 	/* Enable PAE mode, PGE and LA57 */
@@ -138,7 +141,7 @@ ENTRY(secondary_startup_64)
 	movq	%rax, %cr3
 
 	/* Ensure I am executing from virtual addresses */
-	movq	$1f, %rax
+	movabs  $1f, %rax
 	ANNOTATE_RETPOLINE_SAFE
 	jmp	*%rax
 1:
@@ -235,11 +238,12 @@ ENTRY(secondary_startup_64)
 	 *	REX.W + FF /5 JMP m16:64 Jump far, absolute indirect,
 	 *		address given in m16:64.
 	 */
-	pushq	$.Lafter_lret	# put return address on stack for unwinder
+	movabs  $.Lafter_lret, %rax
+	pushq	%rax		# put return address on stack for unwinder
 	xorl	%ebp, %ebp	# clear frame pointer
-	movq	initial_code(%rip), %rax
+	leaq	initial_code(%rip), %rax
 	pushq	$__KERNEL_CS	# set correct cs
-	pushq	%rax		# target address in negative space
+	pushq	(%rax)		# target address in negative space
 	lretq
 .Lafter_lret:
 END(secondary_startup_64)
-- 
2.22.0.410.gd8fdbe21b5-goog

