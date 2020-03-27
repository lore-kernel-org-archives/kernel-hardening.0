Return-Path: <SRS0=t5AD=5M=lists.openwall.com=kernel-hardening-return-18251-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD9C0C43331
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Mar 2020 06:49:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1ACC320578
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Mar 2020 06:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="OCjXlmIo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1ACC320578
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18251-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26330 invoked by uid 550); 27 Mar 2020 06:48:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26224 invoked from network); 27 Mar 2020 06:48:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aCXQQNfM2EQYbGhE+c3i+WsEzSS1B+0KzErDD9Q3cJQ=;
        b=OCjXlmIoxfrnMcD6Fm7EqmFltbx9NqQHpjse+YKgPYhkHv6iZLLG1nlt7oUVP9C15G
         lQ19ipXBCR2dhvNCDNSaYaRpGtODDqGFdCxyjvW+VnHhSDXeSovFoVqIX6sa8HSy/zUS
         Tzoj2lH+NFiAotmdBSTAOMN6FsQCteguppeiQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aCXQQNfM2EQYbGhE+c3i+WsEzSS1B+0KzErDD9Q3cJQ=;
        b=cD6jzPptXqNAIh5GuD9dw2AW2TXg88DqXn/7s0Ngk9u1iqcABuSJj39bpXR3AVfp9A
         a2sjqV+w3oZJhABN34fcI4Aabupoj5FMp4rj0vSki6nPr0cRy3kKB73BYI/SkQpJ++nn
         Uhw+LatM26R0ZOT0UoRaAl0zk5i8voEDgxB7rbQAsSuET2skJ+XZdRhcd13hZVJlsQSk
         FtQuqMBptK4IWnG6YVZtsQ2/UXaLgVYNHaPmd0DJLRRPqd1D/De9VnkXcGbNqVYjIQN+
         ysL2q8hH2lCNolbH+FzBOyjrxSvZbsrQ2F/ZasTrAVAWSRpUiN69KReIT2Vs6KYa9ndV
         bOMQ==
X-Gm-Message-State: ANhLgQ1BKw0STyY82upsqXfhGCMJuFzGf9+dv/GCjVywRQJpC+NSey1p
	4upHWP+9cUVA7wwDKXOaaK+xbg==
X-Google-Smtp-Source: ADFU+vuRG/7CwdAL7Hz1xKA5Bt+/nzzdYx30lzuff91wl0WePMdT+P2vk/HnJix1tQIiabhGWyh6wg==
X-Received: by 2002:a17:90a:eb03:: with SMTP id j3mr4340967pjz.72.1585291706769;
        Thu, 26 Mar 2020 23:48:26 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Kees Cook <keescook@chromium.org>,
	Jason Gunthorpe <jgg@mellanox.com>,
	Hector Marco-Gisbert <hecmargi@upv.es>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Russell King <linux@armlinux.org.uk>,
	Will Deacon <will@kernel.org>,
	Jann Horn <jannh@google.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/6] x86/elf: Add table to document READ_IMPLIES_EXEC
Date: Thu, 26 Mar 2020 23:48:15 -0700
Message-Id: <20200327064820.12602-2-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200327064820.12602-1-keescook@chromium.org>
References: <20200327064820.12602-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add a table to document the current behavior of READ_IMPLIES_EXEC in
preparation for changing the behavior.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
---
 arch/x86/include/asm/elf.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 69c0f892e310..ee459d4c3b45 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -281,6 +281,25 @@ extern u32 elf_hwcap2;
 /*
  * An executable for which elf_read_implies_exec() returns TRUE will
  * have the READ_IMPLIES_EXEC personality flag set automatically.
+ *
+ * The decision process for determining the results are:
+ *
+ *                 CPU: | lacks NX*  | has NX, ia32     | has NX, x86_64 |
+ * ELF:                 |            |                  |                |
+ * ---------------------|------------|------------------|----------------|
+ * missing PT_GNU_STACK | exec-all   | exec-all         | exec-all       |
+ * PT_GNU_STACK == RWX  | exec-all   | exec-all         | exec-all       |
+ * PT_GNU_STACK == RW   | exec-none  | exec-none        | exec-none      |
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
 #define elf_read_implies_exec(ex, executable_stack)	\
 	(executable_stack != EXSTACK_DISABLE_X)
-- 
2.20.1

