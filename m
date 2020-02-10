Return-Path: <SRS0=OQ/k=36=lists.openwall.com=kernel-hardening-return-17763-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B000C35254
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 19:31:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A5BFA20661
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 19:31:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="L4WYG666"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5BFA20661
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17763-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12030 invoked by uid 550); 10 Feb 2020 19:31:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11812 invoked from network); 10 Feb 2020 19:31:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xgo1yExYE1FoOrHi/q0yB3FWShMft6x5k4WGrQxm170=;
        b=L4WYG666B6q1Et3bcdlnVISVkOrsiaz/021i2HOtSDO+5jbbvUU8qOhFuAJpImd9Of
         tHvcCRS71nZ2E2PCYI1v1I7/5Fx8qC14IBkh3bZudUkhVCFVSTRXv68LgS4rolJ8b7NO
         oy2IjZYniOec+89rewQ3DeqzhHAbfLUi9rvdA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xgo1yExYE1FoOrHi/q0yB3FWShMft6x5k4WGrQxm170=;
        b=GCqfVrqBMglOJBotBqwvRtfObmJXJ5mhMPFEGyDJlUHYCi2JJ7kcTX1WF45ll9fpXx
         elLfRGtYFcJJQhQXxGDo9yPOwohGDiUceXVtEjtHH7imEcx2faFm6iyFy2P9Prb1QArF
         ov8DDHhOWCCwfy1TTxu+8NRtAtAjov6ZjMowLiFszatzwHqPGEMuker0il7N6YlgKgLm
         VGCHiOCofBecTCIb7bZMYB3y8AB2yFSgHGMiqKFrQQevLaLvf53aoiDlgKCWPDmDwxb5
         ooQBakZgMBhP3ZhHcCr00afQkkIMGhTDYExI797IO9MsLk5JgjeIdYvr3yPnHtqSI0/n
         u4Ag==
X-Gm-Message-State: APjAAAWS6BNNT3xdamTi3c+8Z671bQMWds5yrYf2YPUbY8I2eThPFbQD
	77mBDchJQ4nhdza70vAuiofgwA==
X-Google-Smtp-Source: APXvYqxrCRbeRObAKsREPcdxJmg1NESdR+jwjL0VLXI5HeLb3NvoJQshGJ4OJNNqOglQAXv1YayQEA==
X-Received: by 2002:a9d:6e8f:: with SMTP id a15mr2204441otr.178.1581363060517;
        Mon, 10 Feb 2020 11:31:00 -0800 (PST)
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
Subject: [PATCH v3 4/7] arm32/64, elf: Add tables to document READ_IMPLIES_EXEC
Date: Mon, 10 Feb 2020 11:30:46 -0800
Message-Id: <20200210193049.64362-5-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200210193049.64362-1-keescook@chromium.org>
References: <20200210193049.64362-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add tables to document the current behavior of READ_IMPLIES_EXEC in
preparation for changing the behavior for both arm64 and arm.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/kernel/elf.c        | 24 +++++++++++++++++++++---
 arch/arm64/include/asm/elf.h | 20 ++++++++++++++++++++
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/elf.c b/arch/arm/kernel/elf.c
index 182422981386..2f69cf978fe3 100644
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
+ *              CPU: | lacks NX*  | has NX     |
+ * ELF:              |            |            |
+ * -------------------------------|------------|
+ * missing GNU_STACK | exec-all   | exec-all   |
+ * GNU_STACK == RWX  | exec-all   | exec-all   |
+ * GNU_STACK == RW   | exec-all   | exec-none  |
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
index b618017205a3..7fc779e3f1ec 100644
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
+ *             CPU*: | arm32      | arm64      |
+ * ELF:              |            |            |
+ * -------------------------------|------------|
+ * missing GNU_STACK | exec-all   | exec-all   |
+ * GNU_STACK == RWX  | exec-all   | exec-all   |
+ * GNU_STACK == RW   | exec-none  | exec-none  |
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

