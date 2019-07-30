Return-Path: <SRS0=OhRh=V3=lists.openwall.com=kernel-hardening-return-16647-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4BFC433FF
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Jul 2019 19:14:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9669A2064A
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Jul 2019 19:14:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dUh629Cx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9669A2064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16647-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28323 invoked by uid 550); 30 Jul 2019 19:13:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28255 invoked from network); 30 Jul 2019 19:13:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g8F81aPRcXP2Hl/h5880SBWLCYrdCb9mGhwAq1nau08=;
        b=dUh629CxLDWe2ICkvFeC4qXjIQGvvsjijYV4+IzjvPROpIi+iYdIzNRfF6AXW9yD7j
         6av49IFog/hErgPxDo8LO6KszfGUsQuRVtAukrJN89JRjJOTeTiYRi4ZcCu0cfmC3eUo
         7R5M5POv61QFetY8gle4w1aDZ1RV9FSIBJtlE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g8F81aPRcXP2Hl/h5880SBWLCYrdCb9mGhwAq1nau08=;
        b=TG0zFdQ06xzexvX9l5pEUhtHbJ2f49xsLsm2f18lqqWCGWDjTMyvBsRWCgx3TxN8t+
         p432syLc4yWNGlRckGtpYe2wmxpS2mHyvICMbnShFWEfEbzLjxKripnkCMAf7WdwPHjA
         eS20LWrnNKMH+ZARk8LewCeEwkxupI+iJU/zZTSE1LZAE1Xx+Wr2szxZoYt04GzN0P08
         pIkD9uPFBQ++BjivHl0DuvFQjvjByrvce7RwZeuwpt/S73D1MnMF+LeLmXap0LH/eKCQ
         +mMh+2j/MGD22Y7Lj/63wuM35RiuW79W6bQFHz4SSYLQr7eIX3UmOWlDDKTDVPgiXCWu
         wGNQ==
X-Gm-Message-State: APjAAAUPmyrkwSekH8yNzLE4q10z5eeWGhvrC/o/ly6WCzO5wtbae6Gi
	Du6CysaUjMlvTH7v/Ik9I/NCx5P+3yw=
X-Google-Smtp-Source: APXvYqwGmbprmSHopN+BDz1XZeLfq9alpJ09UTr1PphowM1pkkwfMHHOEjFK6E/ulqm8Y3g/IHWAbQ==
X-Received: by 2002:a65:6108:: with SMTP id z8mr78911177pgu.289.1564513995418;
        Tue, 30 Jul 2019 12:13:15 -0700 (PDT)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	keescook@chromium.org,
	Thomas Garnier <thgarnie@chromium.org>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v9 04/11] x86/entry/64: Adapt assembly for PIE support
Date: Tue, 30 Jul 2019 12:12:48 -0700
Message-Id: <20190730191303.206365-5-thgarnie@chromium.org>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
In-Reply-To: <20190730191303.206365-1-thgarnie@chromium.org>
References: <20190730191303.206365-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the assembly code to use only relative references of symbols for the
kernel to be PIE compatible.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/entry/entry_64.S | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 3f5a978a02a7..4b588a902009 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1317,7 +1317,8 @@ ENTRY(error_entry)
 	movl	%ecx, %eax			/* zero extend */
 	cmpq	%rax, RIP+8(%rsp)
 	je	.Lbstep_iret
-	cmpq	$.Lgs_change, RIP+8(%rsp)
+	leaq	.Lgs_change(%rip), %rcx
+	cmpq	%rcx, RIP+8(%rsp)
 	jne	.Lerror_entry_done
 
 	/*
@@ -1514,10 +1515,10 @@ ENTRY(nmi)
 	 * resume the outer NMI.
 	 */
 
-	movq	$repeat_nmi, %rdx
+	leaq	repeat_nmi(%rip), %rdx
 	cmpq	8(%rsp), %rdx
 	ja	1f
-	movq	$end_repeat_nmi, %rdx
+	leaq	end_repeat_nmi(%rip), %rdx
 	cmpq	8(%rsp), %rdx
 	ja	nested_nmi_out
 1:
@@ -1571,7 +1572,8 @@ nested_nmi:
 	pushq	%rdx
 	pushfq
 	pushq	$__KERNEL_CS
-	pushq	$repeat_nmi
+	leaq	repeat_nmi(%rip), %rdx
+	pushq	%rdx
 
 	/* Put stack back */
 	addq	$(6*8), %rsp
@@ -1610,7 +1612,11 @@ first_nmi:
 	addq	$8, (%rsp)	/* Fix up RSP */
 	pushfq			/* RFLAGS */
 	pushq	$__KERNEL_CS	/* CS */
-	pushq	$1f		/* RIP */
+	pushq	$0		/* Future return address */
+	pushq	%rax		/* Save RAX */
+	leaq	1f(%rip), %rax	/* RIP */
+	movq    %rax, 8(%rsp)   /* Put 1f on return address */
+	popq	%rax		/* Restore RAX */
 	iretq			/* continues at repeat_nmi below */
 	UNWIND_HINT_IRET_REGS
 1:
-- 
2.22.0.770.g0f2c4a37fd-goog

