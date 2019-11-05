Return-Path: <SRS0=WUpv=Y5=lists.openwall.com=kernel-hardening-return-17303-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A46BC5DF60
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 23:56:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3AE1521D6C
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 23:56:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bDliSoyY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3AE1521D6C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17303-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22238 invoked by uid 550); 5 Nov 2019 23:56:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22129 invoked from network); 5 Nov 2019 23:56:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dHd2oAd25v1QFamm49bKYnI+SDWrPmb9Vs4EgTfDEXk=;
        b=bDliSoyYGxx43rEjkFDy5V4ntr7XfyvBRO13dbvsBo0S8JQUy+CqxbLaHNdLfREnCw
         a0I8taTdiam8ApYbUculPMioDAysaU8DW84rQmV6vlUONLQUEhV8wGdC9CtCyCEtcyXZ
         zFMpPoI1eGpbZbiga1Th/X377A0R2Az7nA63db6p9Ay7zYwET083itnXUljV0iaN0/Qz
         3izH+/Yw9gDCV9sWl9Wgc4I4gMwOn+2k1tVCgkrd6MAFSPLlao809xh49sSGLtt0qEy2
         S+2sqJnqZhdClVXEacu79v4G5BJbF1/6V1tkhH9qEzhiNW9ETU59eVlVQfWrcC5/QOpD
         IKUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dHd2oAd25v1QFamm49bKYnI+SDWrPmb9Vs4EgTfDEXk=;
        b=X02g790KH45JI8mXmAl+fsFLDhdfbxv/z9qsquTHBwMAfQ/J7e678oLMePCAtVrWzD
         O/TMoeJ/2CnqDKYg2aYpxrzoYbSRIAz8KLt3EZnCkQBV3LZ1yMWEE9grVE9s4lUzalgm
         KjFGvrFWt4Fj9WyWB7D/z7JB/R+97PKdUq+OA0t7lakhlPzyqDlGfjKoDbzY85Z5xtH4
         /x0BB/UlmhCie0zcnyNjZkRfK7P6TD8Xcg6P00HA0OwPW7mIXFLEItZ7dLgy8vuRC8mO
         rUQy9FTZ//h1UDSot0BSteyL8Cy2ABCAiFv9Vjbtm1lSmMAqpobJ61s98c+PeNeBf/mt
         GMPQ==
X-Gm-Message-State: APjAAAX16IXDxU7Ojl1I1p+Ecj2ZEZE1dAG+NN0q1x68P7aro2biYbZi
	7V7w6ra2gCimCNA4iwtFjKbkSyqbUp2VNSPtJfw=
X-Google-Smtp-Source: APXvYqwoXaWLPx1zp6EIPHoWFJ4RyvAcLtwdFx+RmyQn+CTcUAB7w5M2fVP0LN47NIlc/qsCuoDGGAdmwSoWPYgVFrU=
X-Received: by 2002:a63:750f:: with SMTP id q15mr14598354pgc.422.1572998183307;
 Tue, 05 Nov 2019 15:56:23 -0800 (PST)
Date: Tue,  5 Nov 2019 15:55:57 -0800
In-Reply-To: <20191105235608.107702-1-samitolvanen@google.com>
Message-Id: <20191105235608.107702-4-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191105235608.107702-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v5 03/14] arm64: kvm: stop treating register x18 as caller save
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

In preparation of reserving x18, stop treating it as caller save in
the KVM guest entry/exit code. Currently, the code assumes there is
no need to preserve it for the host, given that it would have been
assumed clobbered anyway by the function call to __guest_enter().
Instead, preserve its value and restore it upon return.

Link: https://patchwork.kernel.org/patch/9836891/
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
[Sami: updated commit message, switched from x18 to x29 for the guest context]
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/kvm/hyp/entry.S | 45 ++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index e5cc8d66bf53..0c6832ec52b1 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -22,7 +22,12 @@
 	.text
 	.pushsection	.hyp.text, "ax"
 
+/*
+ * We treat x18 as callee-saved as the host may use it as a platform
+ * register (e.g. for shadow call stack).
+ */
 .macro save_callee_saved_regs ctxt
+	str	x18,      [\ctxt, #CPU_XREG_OFFSET(18)]
 	stp	x19, x20, [\ctxt, #CPU_XREG_OFFSET(19)]
 	stp	x21, x22, [\ctxt, #CPU_XREG_OFFSET(21)]
 	stp	x23, x24, [\ctxt, #CPU_XREG_OFFSET(23)]
@@ -32,6 +37,8 @@
 .endm
 
 .macro restore_callee_saved_regs ctxt
+	// We require \ctxt is not x18-x28
+	ldr	x18,      [\ctxt, #CPU_XREG_OFFSET(18)]
 	ldp	x19, x20, [\ctxt, #CPU_XREG_OFFSET(19)]
 	ldp	x21, x22, [\ctxt, #CPU_XREG_OFFSET(21)]
 	ldp	x23, x24, [\ctxt, #CPU_XREG_OFFSET(23)]
@@ -48,7 +55,7 @@ ENTRY(__guest_enter)
 	// x0: vcpu
 	// x1: host context
 	// x2-x17: clobbered by macros
-	// x18: guest context
+	// x29: guest context
 
 	// Store the host regs
 	save_callee_saved_regs x1
@@ -67,31 +74,28 @@ alternative_else_nop_endif
 	ret
 
 1:
-	add	x18, x0, #VCPU_CONTEXT
+	add	x29, x0, #VCPU_CONTEXT
 
 	// Macro ptrauth_switch_to_guest format:
 	// 	ptrauth_switch_to_guest(guest cxt, tmp1, tmp2, tmp3)
 	// The below macro to restore guest keys is not implemented in C code
 	// as it may cause Pointer Authentication key signing mismatch errors
 	// when this feature is enabled for kernel code.
-	ptrauth_switch_to_guest x18, x0, x1, x2
+	ptrauth_switch_to_guest x29, x0, x1, x2
 
 	// Restore guest regs x0-x17
-	ldp	x0, x1,   [x18, #CPU_XREG_OFFSET(0)]
-	ldp	x2, x3,   [x18, #CPU_XREG_OFFSET(2)]
-	ldp	x4, x5,   [x18, #CPU_XREG_OFFSET(4)]
-	ldp	x6, x7,   [x18, #CPU_XREG_OFFSET(6)]
-	ldp	x8, x9,   [x18, #CPU_XREG_OFFSET(8)]
-	ldp	x10, x11, [x18, #CPU_XREG_OFFSET(10)]
-	ldp	x12, x13, [x18, #CPU_XREG_OFFSET(12)]
-	ldp	x14, x15, [x18, #CPU_XREG_OFFSET(14)]
-	ldp	x16, x17, [x18, #CPU_XREG_OFFSET(16)]
-
-	// Restore guest regs x19-x29, lr
-	restore_callee_saved_regs x18
-
-	// Restore guest reg x18
-	ldr	x18,      [x18, #CPU_XREG_OFFSET(18)]
+	ldp	x0, x1,   [x29, #CPU_XREG_OFFSET(0)]
+	ldp	x2, x3,   [x29, #CPU_XREG_OFFSET(2)]
+	ldp	x4, x5,   [x29, #CPU_XREG_OFFSET(4)]
+	ldp	x6, x7,   [x29, #CPU_XREG_OFFSET(6)]
+	ldp	x8, x9,   [x29, #CPU_XREG_OFFSET(8)]
+	ldp	x10, x11, [x29, #CPU_XREG_OFFSET(10)]
+	ldp	x12, x13, [x29, #CPU_XREG_OFFSET(12)]
+	ldp	x14, x15, [x29, #CPU_XREG_OFFSET(14)]
+	ldp	x16, x17, [x29, #CPU_XREG_OFFSET(16)]
+
+	// Restore guest regs x18-x29, lr
+	restore_callee_saved_regs x29
 
 	// Do not touch any register after this!
 	eret
@@ -114,7 +118,7 @@ ENTRY(__guest_exit)
 	// Retrieve the guest regs x0-x1 from the stack
 	ldp	x2, x3, [sp], #16	// x0, x1
 
-	// Store the guest regs x0-x1 and x4-x18
+	// Store the guest regs x0-x1 and x4-x17
 	stp	x2, x3,   [x1, #CPU_XREG_OFFSET(0)]
 	stp	x4, x5,   [x1, #CPU_XREG_OFFSET(4)]
 	stp	x6, x7,   [x1, #CPU_XREG_OFFSET(6)]
@@ -123,9 +127,8 @@ ENTRY(__guest_exit)
 	stp	x12, x13, [x1, #CPU_XREG_OFFSET(12)]
 	stp	x14, x15, [x1, #CPU_XREG_OFFSET(14)]
 	stp	x16, x17, [x1, #CPU_XREG_OFFSET(16)]
-	str	x18,      [x1, #CPU_XREG_OFFSET(18)]
 
-	// Store the guest regs x19-x29, lr
+	// Store the guest regs x18-x29, lr
 	save_callee_saved_regs x1
 
 	get_host_ctxt	x2, x3
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

