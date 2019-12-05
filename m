Return-Path: <SRS0=NvHs=Z3=lists.openwall.com=kernel-hardening-return-17459-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84DE5C43603
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Dec 2019 00:11:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D3E3520674
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Dec 2019 00:11:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ZJRP8vF3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3E3520674
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17459-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27974 invoked by uid 550); 5 Dec 2019 00:10:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27910 invoked from network); 5 Dec 2019 00:10:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sl9+RtgVbb7KwtMxDxQLj2F2VAZGCx1aAKzBbfOxt1g=;
        b=ZJRP8vF30U0k7vaqJoBuANMFiYYfPxKnryHE+msf40PIzZ2XSlMmsYPF0mGufSJdUR
         4H2AxF8qdpgOFyXbO2LGTs5xyhXmVdZWKtNq5VikWN//N+UtZBGPCJGRg0Anl75AVr85
         uHT83t8RIonezj2yYKWA+eGP1srhqMzW/Z7Ys=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sl9+RtgVbb7KwtMxDxQLj2F2VAZGCx1aAKzBbfOxt1g=;
        b=ocBiqpEf0yX5cEIu2+WvAbmwssnpLTHGCG7FP0xILHBYwJmLV14YiXrN7+87oev2n4
         U/zq3RUkyQj1NkK47aAePc+HyiJzsc+6xm2UQLg/CKDddzP/vKmHJIAgQNIzHQIMebKw
         v5oMT8JRHzJqj6m//8hwD3/3FeJ99fUhBjOOjsNkwRsn+wCA6cAJbZ7zOpvQVzmNLK6l
         oq7zva6Ky9ZSM6wm/DRRGjTZONi1yf51tbsCOzgq0TJklHeAz2j/7XwnX8vh7OWy+JJS
         bDPBgE6qTGUHj2vjKDCg/NNVFK+lWKsAe7Mr+IlLufUwlcIifi3X0ZDOKfWDhLh2xhGB
         Xv2Q==
X-Gm-Message-State: APjAAAV2ZgAaZwgu1T2dlFnfuYqX3UJyjNiCepzf3xG8WpxRO3BYWN6d
	n+oLuhlGmsyzzExkQNbaq+o+xwCei2Q=
X-Google-Smtp-Source: APXvYqyUZRhwcUxDg88BSvcVoZjK0y9Ie8prRgjXiPT5oLIYZyeO09SYIVpYFNvdP8jyPMYnr2JPiw==
X-Received: by 2002:a17:902:d881:: with SMTP id b1mr6107230plz.170.1575504615218;
        Wed, 04 Dec 2019 16:10:15 -0800 (PST)
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
Subject: [PATCH v10 04/11] x86/entry/64: Adapt assembly for PIE support
Date: Wed,  4 Dec 2019 16:09:41 -0800
Message-Id: <20191205000957.112719-5-thgarnie@chromium.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <20191205000957.112719-1-thgarnie@chromium.org>
References: <20191205000957.112719-1-thgarnie@chromium.org>
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
index 76942cbd95a1..f14363625f4b 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1329,7 +1329,8 @@ SYM_CODE_START_LOCAL(error_entry)
 	movl	%ecx, %eax			/* zero extend */
 	cmpq	%rax, RIP+8(%rsp)
 	je	.Lbstep_iret
-	cmpq	$.Lgs_change, RIP+8(%rsp)
+	leaq	.Lgs_change(%rip), %rcx
+	cmpq	%rcx, RIP+8(%rsp)
 	jne	.Lerror_entry_done_lfence
 
 	/*
@@ -1529,10 +1530,10 @@ SYM_CODE_START(nmi)
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
@@ -1586,7 +1587,8 @@ nested_nmi:
 	pushq	%rdx
 	pushfq
 	pushq	$__KERNEL_CS
-	pushq	$repeat_nmi
+	leaq	repeat_nmi(%rip), %rdx
+	pushq	%rdx
 
 	/* Put stack back */
 	addq	$(6*8), %rsp
@@ -1625,7 +1627,11 @@ first_nmi:
 	addq	$8, (%rsp)	/* Fix up RSP */
 	pushfq			/* RFLAGS */
 	pushq	$__KERNEL_CS	/* CS */
-	pushq	$1f		/* RIP */
+	pushq	$0		/* Future return address */
+	pushq	%rdx		/* Save RAX */
+	leaq	1f(%rip), %rdx	/* RIP */
+	movq    %rdx, 8(%rsp)   /* Put 1f on return address */
+	popq	%rdx		/* Restore RAX */
 	iretq			/* continues at repeat_nmi below */
 	UNWIND_HINT_IRET_REGS
 1:
-- 
2.24.0.393.g34dc348eaf-goog

