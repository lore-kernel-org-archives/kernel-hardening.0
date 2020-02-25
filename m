Return-Path: <SRS0=Vzw7=4N=lists.openwall.com=kernel-hardening-return-17904-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6229C35DF2
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 05:14:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 09DDC2467C
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 05:14:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="DPDiTUn9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 09DDC2467C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17904-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7727 invoked by uid 550); 25 Feb 2020 05:13:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7538 invoked from network); 25 Feb 2020 05:13:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2lIWrB2rl2fls1DP3gLk6fTzwbihtKCjsTFZYdDbGQ4=;
        b=DPDiTUn9mHAJPUVeuO6O/4+ZWGT7CXMflUkvN2DOGwNzNVpUoWmOyBDAPPODhXWKny
         NAGKI6c4hPVF4ebdPpwklU4evW4Jv0T46fb90WvXFEfUBpzH+zSH2ffMjDvLcQk8cmtw
         yow7naoX3eK49OZ2mSrrxi/CmK2iPRw64SR2c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2lIWrB2rl2fls1DP3gLk6fTzwbihtKCjsTFZYdDbGQ4=;
        b=pwJxXk/h1YFoUc0eBNbqM+4UQaDiK0z9Oacu5UH+cafHi1GWYgP6my4IcwCfgDrIxd
         wsAOSjMQHKCurOJAr1jfVhcEy2L0WmXgUj5P0IXDdyZsJ0Kqo6Wvux7bDWjj5Y3DA4lA
         Mv/UtwfNd0v4pIUaK7SrWI8qCPnDrGQME/3PsC4PSmkFCC6QMMw5crJTKjEiq9+vZxdR
         E+D0fUaiZ+Dhaf8kbWLxbYc/yZO7MoVYX8TFZYVoyhDoCR0++sS2+Ad0eT73++RNLbfQ
         YgjEDv54fQq2pa4m05mvLNQGOnNzp5YkwUJ37rmbjh1TYMqZuj8RL/bY3dVycE3ZELQZ
         xUAQ==
X-Gm-Message-State: APjAAAXlrPzZwf+M2/UchPu1S7A7V3yEVOBfiv66SOZvq6SfclNtUPOn
	5vbHd0n7WR/W6qb+wboX9NgPJQ==
X-Google-Smtp-Source: APXvYqypIEhUi0EJIgMKTYt0m4YMRHeIhF58LfEi+94S8qvARJ0jimCVUlM03w63T/gtF6c3CH2Xsg==
X-Received: by 2002:aa7:8101:: with SMTP id b1mr56045649pfi.105.1582607596919;
        Mon, 24 Feb 2020 21:13:16 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Kees Cook <keescook@chromium.org>,
	Hector Marco-Gisbert <hecmargi@upv.es>,
	Jason Gunthorpe <jgg@mellanox.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Russell King <linux@armlinux.org.uk>,
	Will Deacon <will@kernel.org>,
	Jann Horn <jannh@google.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/6] arm32/64, elf: Split READ_IMPLIES_EXEC from executable GNU_STACK
Date: Mon, 24 Feb 2020 21:13:06 -0800
Message-Id: <20200225051307.6401-6-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200225051307.6401-1-keescook@chromium.org>
References: <20200225051307.6401-1-keescook@chromium.org>
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
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
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

