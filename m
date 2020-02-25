Return-Path: <SRS0=5LTH=4N=lists.openwall.com=kernel-hardening-return-17901-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB8BC35DF2
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 05:14:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C9F8E2467C
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 05:14:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="avzQkIzW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9F8E2467C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17901-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7528 invoked by uid 550); 25 Feb 2020 05:13:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7394 invoked from network); 25 Feb 2020 05:13:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YYkEUMiwoqC9g5twl30uamAlKq3Tsh5NtF9u9M+qrn4=;
        b=avzQkIzWP11XHI9dfw+sintU7jSdYyOmCfUcrZbVfI3neNkexyxVoipAlC0aEClJyH
         aCOUDg37itfNNyo5WKHg3hVZ3VCLg6AxDzjoOQ4lSK1OaOhtw93wixoun6PIjwoxoYId
         BANd3swsVOiMeZkStF0wE5AKrSqy5u7EzvUzA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YYkEUMiwoqC9g5twl30uamAlKq3Tsh5NtF9u9M+qrn4=;
        b=qfFmRACA8U+3+pcXkKH4Ujdk7O5V7K9le0rwSmjkjSAtN3S6ymfSkz2wcDtviIWl2I
         UhqFv2RLwKKvDZoFZ7077iShTMp2fX63KyVPZX35Y2DI9HgmZfR4R6eEivL40EEZVknT
         sjgGKj7ZrhaVMEf9pPwkX+n7o22u1dfU8Jgoxva20bxG4DNeQlauf2u4JR+fM5rS2tMI
         lAcJkfK8QTIbEWp2TIsLk/KfvJCgHSqHejUkMKrpMbfJhZZX+LTO/wr4FDItZXDWXqZn
         eEcVJ9JDIASW2eSTDYrWnEO3b5QTbVqDJBW0SgQrpsG5otJ/xdZQFnuy78GMs4knv25L
         sJog==
X-Gm-Message-State: APjAAAUocre7/d+2/r8oInHiiXTpfKNbv5bttKsTaD44+uOKXdpCWK5n
	lwfiisKiCapRL5HOY7v8BatFwQ==
X-Google-Smtp-Source: APXvYqzBUEzonruL33z1bqgvonSPWOcLoIk/bYLtdQnry1U+j3ClgjvqG2nmE0zuEw4fCLKGWa37Yw==
X-Received: by 2002:a17:902:b617:: with SMTP id b23mr54721739pls.285.1582607594502;
        Mon, 24 Feb 2020 21:13:14 -0800 (PST)
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
Subject: [PATCH v4 1/6] x86/elf: Add table to document READ_IMPLIES_EXEC
Date: Mon, 24 Feb 2020 21:13:02 -0800
Message-Id: <20200225051307.6401-2-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200225051307.6401-1-keescook@chromium.org>
References: <20200225051307.6401-1-keescook@chromium.org>
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
index 69c0f892e310..733f69c2b053 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -281,6 +281,25 @@ extern u32 elf_hwcap2;
 /*
  * An executable for which elf_read_implies_exec() returns TRUE will
  * have the READ_IMPLIES_EXEC personality flag set automatically.
+ *
+ * The decision process for determining the results are:
+ *
+ *              CPU: | lacks NX*  | has NX, ia32     | has NX, x86_64 |
+ * ELF:              |            |                  |                |
+ * -------------------------------|------------------|----------------|
+ * missing GNU_STACK | exec-all   | exec-all         | exec-all       |
+ * GNU_STACK == RWX  | exec-all   | exec-all         | exec-all       |
+ * GNU_STACK == RW   | exec-none  | exec-none        | exec-none      |
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

