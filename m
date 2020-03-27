Return-Path: <SRS0=bgGr=5M=lists.openwall.com=kernel-hardening-return-18249-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D194C43331
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Mar 2020 06:48:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CEFD720716
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Mar 2020 06:48:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Tm4FMyfy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CEFD720716
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18249-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26256 invoked by uid 550); 27 Mar 2020 06:48:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26156 invoked from network); 27 Mar 2020 06:48:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mgxC9d4qXy1U6S4xZZ93iQn9OATjbx+7aDsjHxYmoto=;
        b=Tm4FMyfyM+cogSruDE6HvsM+6ZwmCpC70VZfPJPeA0p+kq4CJe5z5I2DHZ9LX+tWXU
         +NQzb1bYQeo9YhPAv4Z4oabDJ4d38VX5KW8GF7YKk2UeP4oHUqCJe3joDSiC6v18w10H
         Kq7G4OI4gxFxFK+ZrGvyhlubqD/l0vQZ9EUtM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mgxC9d4qXy1U6S4xZZ93iQn9OATjbx+7aDsjHxYmoto=;
        b=hlsPkurHeTAYblshAGUfNV/7rVSdfDn5Qadlya98NapHOqgTIL8F+VVloFL2bR4l+O
         TovNNaPdM/XR8KwhSYG/sbhRhPBWjkgUUh2oval+4m7gFbf2V5r3RrnGTZs+OG3etQxz
         UmuqdqzZCXl66913zHZzIImbC++EELFWnwdDf1E8gfzoGwF0To18glGFYNMqdziV7OAm
         6xu1BZ+vwhhpnmJDoYar+yooOOti8PlLpKbrVdSIR1/0xIevctDhlaEBYuNRCV/eHzob
         G2F+eTnuvw8nyt8fG8SaDY9LRaIf/21oCq8a1VDicg6BKWosDyT5ltxWSNdBus3qnXSl
         WApg==
X-Gm-Message-State: ANhLgQ09LRXD9K1BGQpeP+wzORqvYXTXXi63TE3kf9/inmg3iYq9qisy
	4q/4dFVRWmALPXYKofIGTr6+nA==
X-Google-Smtp-Source: ADFU+vvUCTEaE7rTCmfqpNAlHIP1Nzssf0r27kJDIMaQrHcgZSr12IA4FWWsjvLo1vxI4YLA34ar7w==
X-Received: by 2002:a17:90a:33c1:: with SMTP id n59mr4125261pjb.4.1585291705258;
        Thu, 26 Mar 2020 23:48:25 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Kees Cook <keescook@chromium.org>,
	Jason Gunthorpe <jgg@mellanox.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Hector Marco-Gisbert <hecmargi@upv.es>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Russell King <linux@armlinux.org.uk>,
	Will Deacon <will@kernel.org>,
	Jann Horn <jannh@google.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 4/6] arm32/64, elf: Add tables to document READ_IMPLIES_EXEC
Date: Thu, 26 Mar 2020 23:48:18 -0700
Message-Id: <20200327064820.12602-5-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200327064820.12602-1-keescook@chromium.org>
References: <20200327064820.12602-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add tables to document the current behavior of READ_IMPLIES_EXEC in
preparation for changing the behavior for both arm64 and arm.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/kernel/elf.c        | 24 +++++++++++++++++++++---
 arch/arm64/include/asm/elf.h | 20 ++++++++++++++++++++
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/elf.c b/arch/arm/kernel/elf.c
index 182422981386..5ccd4aced6cc 100644
--- a/arch/arm/kernel/elf.c
+++ b/arch/arm/kernel/elf.c
@@ -78,9 +78,27 @@ void elf_set_personality(const struct elf32_hdr *x)
 EXPORT_SYMBOL(elf_set_personality);
 
 /*
- * Set READ_IMPLIES_EXEC if:
- *  - the binary requires an executable stack
- *  - we're running on a CPU which doesn't support NX.
+ * An executable for which elf_read_implies_exec() returns TRUE will
+ * have the READ_IMPLIES_EXEC personality flag set automatically.
+ *
+ * The decision process for determining the results are:
+ *
+ *                 CPU: | lacks NX*  | has NX     |
+ * ELF:                 |            |            |
+ * ---------------------|------------|------------|
+ * missing PT_GNU_STACK | exec-all   | exec-all   |
+ * PT_GNU_STACK == RWX  | exec-all   | exec-all   |
+ * PT_GNU_STACK == RW   | exec-all   | exec-none  |
+ *
+ *  exec-all  : all PROT_READ user mappings are executable, except when
+ *              backed by files on a noexec-filesystem.
+ *  exec-none : only PROT_EXEC user mappings are executable.
+ *
+ *  *this column has no architectural effect: NX markings are ignored by
+ *   hardware, but may have behavioral effects when "wants X" collides with
+ *   "cannot be X" constraints in memory permission flags, as in
+ *   https://lkml.kernel.org/r/20190418055759.GA3155@mellanox.com
+ *
  */
 int arm_elf_read_implies_exec(int executable_stack)
 {
diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index b618017205a3..986ecf41fc0f 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -96,6 +96,26 @@
  */
 #define elf_check_arch(x)		((x)->e_machine == EM_AARCH64)
 
+/*
+ * An executable for which elf_read_implies_exec() returns TRUE will
+ * have the READ_IMPLIES_EXEC personality flag set automatically.
+ *
+ * The decision process for determining the results are:
+ *
+ *                CPU*: | arm32      | arm64      |
+ * ELF:                 |            |            |
+ * ---------------------|------------|------------|
+ * missing PT_GNU_STACK | exec-all   | exec-all   |
+ * PT_GNU_STACK == RWX  | exec-all   | exec-all   |
+ * PT_GNU_STACK == RW   | exec-none  | exec-none  |
+ *
+ *  exec-all  : all PROT_READ user mappings are executable, except when
+ *              backed by files on a noexec-filesystem.
+ *  exec-none : only PROT_EXEC user mappings are executable.
+ *
+ *  *all arm64 CPUs support NX, so there is no "lacks NX" column.
+ *
+ */
 #define elf_read_implies_exec(ex,stk)	(stk != EXSTACK_DISABLE_X)
 
 #define CORE_DUMP_USE_REGSET
-- 
2.20.1

