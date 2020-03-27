Return-Path: <SRS0=zO1H=5M=lists.openwall.com=kernel-hardening-return-18254-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7078AC43331
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Mar 2020 06:49:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8FCFD20714
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Mar 2020 06:49:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="JROchnuo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FCFD20714
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18254-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27681 invoked by uid 550); 27 Mar 2020 06:48:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26353 invoked from network); 27 Mar 2020 06:48:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9LO2LzsxD2r9Xv+srqALdfcgB8lxU6x5iZM1oUedN0w=;
        b=JROchnuoQhF2R/Mx5z01GK7uJjfXpDKE0LvGoYpHwUfQ1LM+YDoX9iNWypkcK6H8ga
         Y52O13oWS8BcrW5QYSCbprsyCVbOVMXojnxUDi6FH0Bi6Y3Zq7JyhA+8mCT1Z1cEBymy
         PJxdNR/1VyMhsLDwzYotBhML4MtN9DLzspX50=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9LO2LzsxD2r9Xv+srqALdfcgB8lxU6x5iZM1oUedN0w=;
        b=aCtmCZzLZQYKlCFnMFSFuqRu57YyvyYrcwZcZJpCGqfm1l2DJ1P5f78uUyyh8au4qz
         6vgqqfTH7/ONerKfd+MczFP5f3pQE8G68/DfHvuUU+I4yNgIPegrsuO7QS75LCnv0o1z
         pgf/BTy7annDgKZb5jkyp32DLmJmkG2MUKhu83ED/B32kYMfG48wCJxWR2xMGpB7NV7i
         AffO0M++mA8En1JLc+heY3B5jShTXTtqJCA18J9hr4OAsn3zDQwtoppZF9ljPGsHLolR
         a7/+kvpkv3pyeG1D0EcpaQKRxLe6uzgEpjen1v/bZsEUdLwT5+I2fCWQmvpjq2p1De6A
         Hghw==
X-Gm-Message-State: ANhLgQ1DzhI+eA2rcMKihjfL29uIA2GmaKgdtsh3BXUP8uSmIqKuXwhF
	7JI8K4PM3IPK5E6Bpor+O7tacA==
X-Google-Smtp-Source: ADFU+vuA1LFfImtyYtbDmLUlKIzpXJoC5cD77qNyfHDvBSDw6ezHZbSgFf8tN7H3qURKXYRhUoj5iA==
X-Received: by 2002:a62:2c8c:: with SMTP id s134mr13352706pfs.253.1585291709337;
        Thu, 26 Mar 2020 23:48:29 -0700 (PDT)
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
Subject: [PATCH v5 5/6] arm32/64, elf: Split READ_IMPLIES_EXEC from executable PT_GNU_STACK
Date: Thu, 26 Mar 2020 23:48:19 -0700
Message-Id: <20200327064820.12602-6-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200327064820.12602-1-keescook@chromium.org>
References: <20200327064820.12602-1-keescook@chromium.org>
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
index 5ccd4aced6cc..254ab7138c85 100644
--- a/arch/arm/kernel/elf.c
+++ b/arch/arm/kernel/elf.c
@@ -87,12 +87,13 @@ EXPORT_SYMBOL(elf_set_personality);
  * ELF:                 |            |            |
  * ---------------------|------------|------------|
  * missing PT_GNU_STACK | exec-all   | exec-all   |
- * PT_GNU_STACK == RWX  | exec-all   | exec-all   |
+ * PT_GNU_STACK == RWX  | exec-all   | exec-stack |
  * PT_GNU_STACK == RW   | exec-all   | exec-none  |
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
index 986ecf41fc0f..0074e9fd6431 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -106,17 +106,18 @@
  * ELF:                 |            |            |
  * ---------------------|------------|------------|
  * missing PT_GNU_STACK | exec-all   | exec-all   |
- * PT_GNU_STACK == RWX  | exec-all   | exec-all   |
+ * PT_GNU_STACK == RWX  | exec-stack | exec-stack |
  * PT_GNU_STACK == RW   | exec-none  | exec-none  |
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
+#define elf_read_implies_exec(ex, stk)	(stk == EXSTACK_DEFAULT)
 
 #define CORE_DUMP_USE_REGSET
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
-- 
2.20.1

