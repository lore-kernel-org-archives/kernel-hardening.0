Return-Path: <SRS0=foQT=36=lists.openwall.com=kernel-hardening-return-17767-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 372EFC35254
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 19:32:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 54D83206ED
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 19:32:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="PoL0XhCM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54D83206ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17767-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12284 invoked by uid 550); 10 Feb 2020 19:31:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12103 invoked from network); 10 Feb 2020 19:31:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vV+4L9n935hAwwy1rny/bKPJmpM6IQkGJafPemnuM6M=;
        b=PoL0XhCMF5RYylDc0l4IgFMeB8xwO+uVffzPYfytDnFxlYeMxyX/mZuQokiRqvLpeB
         3BSmLKsw8Mn0fTOGDf5FiPjNmXvq0HmdnXXBN/WXOAJCOAtbktliwg0Ij4BFjNLNEwz1
         LFDL39Nbv292S1gxIrW8F3TJd9vj+dby5RYxI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vV+4L9n935hAwwy1rny/bKPJmpM6IQkGJafPemnuM6M=;
        b=hMJTAFG7hrq03iLkGWcmAHSwG8WavQjZYFCLpWehs2CfRkfiyaXMhrhPfHTezFWp9h
         nnJ7F2Zlz+KRkGY2tLakebkSi/3trPzbbT+5IFp3pGlxMbjvansXK6DzrbRv3V4Xdi3/
         XhUoC5LC5XZZegFgTa4jZe4kBS/Sm9ItsMYWyhMw1DBb2Vuip9RCXdtiUVPE+/FHxoEp
         YzjmqEwRVunBDahZle565rLMAuR8DDPaZS0fvOgQRHlaNQoxw9CkAaWRpqKlbuoiqu56
         fTEzJCVE5N8Hihgsu75+gzQf6XA28aBMElSLCWxbXo2Nm5/C4A/LWhp1kNqJi/cStPCN
         hoJQ==
X-Gm-Message-State: APjAAAXODFqbhzgngwBwyk9AxeD0u80MoynzqYxRvlSGGl1IgIYtU+U0
	Ul1s2c758oXUHl8WwG9Mve0v/w==
X-Google-Smtp-Source: APXvYqxxYA/0/Zbqi4Hv0JHtPdrzzbONYFkwCVp0/iu2hk9k8CQImN2sdfiTosdmQZKPTHVPQ7l30Q==
X-Received: by 2002:aca:5083:: with SMTP id e125mr424241oib.96.1581363063722;
        Mon, 10 Feb 2020 11:31:03 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>,
	Hector Marco-Gisbert <hecmargi@upv.es>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Jason Gunthorpe <jgg@mellanox.com>,
	Jann Horn <jannh@google.com>,
	Russell King <linux@armlinux.org.uk>,
	x86@kernel.org,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v3 5/7] arm32/64, elf: Split READ_IMPLIES_EXEC from executable GNU_STACK
Date: Mon, 10 Feb 2020 11:30:47 -0800
Message-Id: <20200210193049.64362-6-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200210193049.64362-1-keescook@chromium.org>
References: <20200210193049.64362-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The READ_IMPLIES_EXEC work-around was designed for old toolchains that
lacked the ELF PT_GNU_STACK marking under the assumption that toolchains
that couldn't specify executable permission flags for the stack may not
know how to do it correctly for any memory region.

This logic is sensible for having ancient binaries coexist in a system
with possibly NX memory, but was implemented in a way that equated having
a PT_GNU_STACK marked executable as being as "broken" as lacking the
PT_GNU_STACK marking entirely. Things like unmarked assembly and stack
trampolines may cause PT_GNU_STACK to need an executable bit, but they
do not imply all mappings must be executable.

This confusion has led to situations where modern programs with explicitly
marked executable stack are forced into the READ_IMPLIES_EXEC state when
no such thing is needed. (And leads to unexpected failures when mmap()ing
regions of device driver memory that wish to disallow VM_EXEC[1].)

In looking for other reasons for the READ_IMPLIES_EXEC behavior, Jann
Horn noted that glibc thread stacks have always been marked RWX (until
2003 when they started tracking the PT_GNU_STACK flag instead[2]). And
musl doesn't support executable stacks at all[3]. As such, no breakage
for multithreaded applications is expected from this change.

This changes arm32 and arm64 compat together, to keep behavior the same.

[1] https://lkml.kernel.org/r/20190418055759.GA3155@mellanox.com
[2] https://sourceware.org/git/?p=glibc.git;a=commitdiff;h=54ee14b3882
[3] https://lkml.kernel.org/r/20190423192534.GN23599@brightrain.aerifal.cx

Suggested-by: Hector Marco-Gisbert <hecmargi@upv.es>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/kernel/elf.c        | 5 +++--
 arch/arm64/include/asm/elf.h | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/elf.c b/arch/arm/kernel/elf.c
index 2f69cf978fe3..6965a673a141 100644
--- a/arch/arm/kernel/elf.c
+++ b/arch/arm/kernel/elf.c
@@ -87,12 +87,13 @@ EXPORT_SYMBOL(elf_set_personality);
  * ELF:              |            |            |
  * -------------------------------|------------|
  * missing GNU_STACK | exec-all   | exec-all   |
- * GNU_STACK == RWX  | exec-all   | exec-all   |
+ * GNU_STACK == RWX  | exec-all   | exec-stack |
  * GNU_STACK == RW   | exec-all   | exec-none  |
  *
  *  exec-all  : all PROT_READ user mappings are executable, except when
  *              backed by files on a noexec-filesystem.
  *  exec-none : only PROT_EXEC user mappings are executable.
+ *  exec-stack: only the stack and PROT_EXEC user mappings are executable.
  *
  *  *this column has no architectural effect: NX markings are ignored by
  *   hardware, but may have behavioral effects when "wants X" collides with
@@ -102,7 +103,7 @@ EXPORT_SYMBOL(elf_set_personality);
  */
 int arm_elf_read_implies_exec(int executable_stack)
 {
-	if (executable_stack != EXSTACK_DISABLE_X)
+	if (executable_stack == EXSTACK_DEFAULT)
 		return 1;
 	if (cpu_architecture() < CPU_ARCH_ARMv6)
 		return 1;
diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index 7fc779e3f1ec..03ada29984a7 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -106,17 +106,18 @@
  * ELF:              |            |            |
  * -------------------------------|------------|
  * missing GNU_STACK | exec-all   | exec-all   |
- * GNU_STACK == RWX  | exec-all   | exec-all   |
+ * GNU_STACK == RWX  | exec-stack | exec-stack |
  * GNU_STACK == RW   | exec-none  | exec-none  |
  *
  *  exec-all  : all PROT_READ user mappings are executable, except when
  *              backed by files on a noexec-filesystem.
  *  exec-none : only PROT_EXEC user mappings are executable.
+ *  exec-stack: only the stack and PROT_EXEC user mappings are executable.
  *
  *  *all arm64 CPUs support NX, so there is no "lacks NX" column.
  *
  */
-#define elf_read_implies_exec(ex,stk)	(stk != EXSTACK_DISABLE_X)
+#define elf_read_implies_exec(ex,stk)	(stk == EXSTACK_DEFAULT)
 
 #define CORE_DUMP_USE_REGSET
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
-- 
2.20.1

