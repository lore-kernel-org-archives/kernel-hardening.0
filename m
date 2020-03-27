Return-Path: <SRS0=L0nt=5M=lists.openwall.com=kernel-hardening-return-18252-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75441C43331
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Mar 2020 06:49:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CA16020714
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Mar 2020 06:49:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="EN7/Lyg4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA16020714
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18252-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26390 invoked by uid 550); 27 Mar 2020 06:48:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26297 invoked from network); 27 Mar 2020 06:48:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZTdPh9cpqKAayj+42mk/55nYw+jDQf8ejhb0i9ICEnI=;
        b=EN7/Lyg4dzcL5ijfnBiELInv0uwpf9cILpg/iZy1MhtJP1dlI3p/fZu6C0tEtWRcDT
         ciM1ErpmM6twLHmMQ5krksVL0jrw2o1Sla9jBavUg7zJVC/sMQ1TuM1swfQeu6hgQTqQ
         uBfbOptJ0cLByC0Y+tB/fdPP50WYBdQ1ETwDM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZTdPh9cpqKAayj+42mk/55nYw+jDQf8ejhb0i9ICEnI=;
        b=EU0/zMhFqsRKg6U62I14dBawWw0hONrnaDcBVzk+sH6c+7hccfa4YKUoi4I9Fii1pD
         SCxxs5YgddgldfstgcAZtC82Bo+TMRcHQrXr/15NUmNJs2JCq7aYMDcQTE33RtMrMaoU
         4TJDzoBZanOy7E+0XFv8qS2CzbDZiJzIOmFfjtSevYF0DY4anoVZ3I9FAeQLE+xArIHo
         nu2ZZGNck0pUiu9KbTeVZLU4vBHNBQAmbtq2kcpvu5b7sYqaUi2cLGX53D3m5bda8Kgl
         AscQcmeEZGPT4WaEGtjdPdBk++lLpQsjMAP5Habpd4nZedqMtnDUcexkZAY6/Q5k0RPk
         IsJQ==
X-Gm-Message-State: ANhLgQ0zzwtSnTwZ71bilylLs7em6oPNzeiMMQCV1f35sY9jxElw6nQc
	8Vxpfgi5vZ8KUzOU0Lqog03pRg==
X-Google-Smtp-Source: ADFU+vt7GOdG4GJrRj468GubEkFUve/2A0teR6lM1LEYtLCojGHgXFTocsSWpD7m1gRNKoJs8FD9zw==
X-Received: by 2002:a62:170f:: with SMTP id 15mr12765680pfx.12.1585291707764;
        Thu, 26 Mar 2020 23:48:27 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Kees Cook <keescook@chromium.org>,
	Hector Marco-Gisbert <hecmargi@upv.es>,
	Jason Gunthorpe <jgg@mellanox.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Russell King <linux@armlinux.org.uk>,
	Will Deacon <will@kernel.org>,
	Jann Horn <jannh@google.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/6] x86/elf: Split READ_IMPLIES_EXEC from executable PT_GNU_STACK
Date: Thu, 26 Mar 2020 23:48:16 -0700
Message-Id: <20200327064820.12602-3-keescook@chromium.org>
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

[1] https://lkml.kernel.org/r/20190418055759.GA3155@mellanox.com
[2] https://sourceware.org/git/?p=glibc.git;a=commitdiff;h=54ee14b3882
[3] https://lkml.kernel.org/r/20190423192534.GN23599@brightrain.aerifal.cx

Suggested-by: Hector Marco-Gisbert <hecmargi@upv.es>
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
---
 arch/x86/include/asm/elf.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index ee459d4c3b45..397a1c74433e 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -288,12 +288,13 @@ extern u32 elf_hwcap2;
  * ELF:                 |            |                  |                |
  * ---------------------|------------|------------------|----------------|
  * missing PT_GNU_STACK | exec-all   | exec-all         | exec-all       |
- * PT_GNU_STACK == RWX  | exec-all   | exec-all         | exec-all       |
+ * PT_GNU_STACK == RWX  | exec-stack | exec-stack       | exec-stack     |
  * PT_GNU_STACK == RW   | exec-none  | exec-none        | exec-none      |
  *
  *  exec-all  : all PROT_READ user mappings are executable, except when
  *              backed by files on a noexec-filesystem.
  *  exec-none : only PROT_EXEC user mappings are executable.
+ *  exec-stack: only the stack and PROT_EXEC user mappings are executable.
  *
  *  *this column has no architectural effect: NX markings are ignored by
  *   hardware, but may have behavioral effects when "wants X" collides with
@@ -302,7 +303,7 @@ extern u32 elf_hwcap2;
  *
  */
 #define elf_read_implies_exec(ex, executable_stack)	\
-	(executable_stack != EXSTACK_DISABLE_X)
+	(executable_stack == EXSTACK_DEFAULT)
 
 struct task_struct;
 
-- 
2.20.1

