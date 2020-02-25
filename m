Return-Path: <SRS0=T55a=4N=lists.openwall.com=kernel-hardening-return-17898-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8ACAC35DF7
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 05:13:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 13E4824682
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 05:13:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gdPEq+Jj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13E4824682
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17898-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7393 invoked by uid 550); 25 Feb 2020 05:13:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7358 invoked from network); 25 Feb 2020 05:13:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZNLE8qanU9tB+qprhCqb5JhCmvZIHAS4t1qFulujc3c=;
        b=gdPEq+JjTnrTNZqPxDtXj3Xt27Obpw016njmHmr0gwgR2L0EhflW7LupjRtFxw9Gzn
         d6sOQ9k8yYEGUOhzaE7ZBqcsy7EJW5gT+CjF9zvaZkZkitVMHy3UQiBPck0XAuOlr352
         foYbhGhFwUKbexhzLsmgLzdkttIU4h/cxj6PY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZNLE8qanU9tB+qprhCqb5JhCmvZIHAS4t1qFulujc3c=;
        b=iRmCJeNEqVn35jMfdGTQ/ho5WSXa9EGINBPUGMTmZbZ7MKCcvROTqLMYdP6/BNd6xz
         7uB6+JAFDhDQEF1AEj/mtNrD7Pq+2qiD9ejV74b6m0dznTghDSUoTpLwSON9Z3M11bst
         swMKHr7iJ9aByV1Z7TCwe98taBQpO5UCpOpkuW0Ftuu+WOITDwVV2LeqaUxYHdvnOVeu
         b2YZxyPpSuflThpnJgZTrtrBqCi/8nvuEVUL9ApMrUqVtRLZKrJJ2CxBkjSIe8vn68si
         4Y/xHre8FgXKxxcbR5IOM3bt3JUoKhVsIw+hGdJROcf6vmTHW35VVcyA8NYrjO1KgGLN
         7QFw==
X-Gm-Message-State: APjAAAVV4FwlmoPUIG2O3R9Whx1tnLdzHIdDeb8O0OLGnGcs7Vk/Z+He
	0jaGbuRiD8jpVlq7GD5X7P7wYA==
X-Google-Smtp-Source: APXvYqzhhwjL9Yg+ZfnqgfEq+io+9jGp/eGcRcIoZfPqoFZ+RQ/M8xfh20Jez7PEOAC4j9RETiwkqw==
X-Received: by 2002:aa7:8703:: with SMTP id b3mr53336326pfo.67.1582607593189;
        Mon, 24 Feb 2020 21:13:13 -0800 (PST)
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
Subject: [PATCH v4 3/6] x86/elf: Disable automatic READ_IMPLIES_EXEC for 64-bit address spaces
Date: Mon, 24 Feb 2020 21:13:04 -0800
Message-Id: <20200225051307.6401-4-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200225051307.6401-1-keescook@chromium.org>
References: <20200225051307.6401-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

With modern x86 64-bit environments, there should never be a need for
automatic READ_IMPLIES_EXEC, as the architecture is intended to always
be execute-bit aware (as in, the default memory protection should be NX
unless a region explicitly requests to be executable).

There were very old x86_64 systems that lacked the NX bit, but for those,
the NX bit is, obviously, unenforceable, so these changes should have
no impact on them.

Suggested-by: Hector Marco-Gisbert <hecmargi@upv.es>
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
---
 arch/x86/include/asm/elf.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index a7035065377c..c9b7be0bcad3 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -287,7 +287,7 @@ extern u32 elf_hwcap2;
  *              CPU: | lacks NX*  | has NX, ia32     | has NX, x86_64 |
  * ELF:              |            |                  |                |
  * -------------------------------|------------------|----------------|
- * missing GNU_STACK | exec-all   | exec-all         | exec-all       |
+ * missing GNU_STACK | exec-all   | exec-all         | exec-none      |
  * GNU_STACK == RWX  | exec-stack | exec-stack       | exec-stack     |
  * GNU_STACK == RW   | exec-none  | exec-none        | exec-none      |
  *
@@ -303,7 +303,7 @@ extern u32 elf_hwcap2;
  *
  */
 #define elf_read_implies_exec(ex, executable_stack)	\
-	(executable_stack == EXSTACK_DEFAULT)
+	(mmap_is_ia32() && executable_stack == EXSTACK_DEFAULT)
 
 struct task_struct;
 
-- 
2.20.1

