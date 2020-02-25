Return-Path: <SRS0=nAvu=4N=lists.openwall.com=kernel-hardening-return-17903-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E826C35DF2
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 05:14:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9E2C02467C
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 05:14:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="FNMuINYq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E2C02467C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17903-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7644 invoked by uid 550); 25 Feb 2020 05:13:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7517 invoked from network); 25 Feb 2020 05:13:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KFgEd5ihB5mpYJHgTJ73YmLe+8HUk6ELkCILmCi0oOk=;
        b=FNMuINYqjkWcMKmsC54Bq/gTZBk8TfWE/kHSeHazPaZ6Qsgq4UEwtaKxNjx3U/LSOL
         lSxriB94mOtmP7ZumY1pLpyXNh1eiELD+deo2AfzoltvtXbJresnxC13IfnGI7/zF0u8
         gfw7+zy+BpP4vi9hf0mYsgj0+sBmXM2UX7Dlk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KFgEd5ihB5mpYJHgTJ73YmLe+8HUk6ELkCILmCi0oOk=;
        b=dLZODGAYk7ifwd6NUDvib+0mEPyCSYewBRWS6QU2UeY74kaIng/JLSBZnHK3myJ2qB
         R0FIiWF/cc8xNPa+yVVORInPCS2PeM3ZrkchE8WGzuUElSGRKH2Hs274elYbRPU7YeAB
         ZNUS1nvnRNQiEfC5TaWWMEqwRirDuYbN/SYQ14RKeliEuWvmm70omNeL9SFhoEn8ZbIC
         jdsIvpkj6xzg7/OIKRvM8KQhTUzYWpwaZqhauKzcr7Yxrh6J3mHK1CmR1upu/54o3+N9
         RsofL5yuFEHPI/oFuxw5sUzhJqtg0GsYCDvZzI2HMdMs6cuFSgGAMLW59C8TKk11x6n/
         QXfg==
X-Gm-Message-State: APjAAAUh24MjPy53I2HOqSqe/QgPieDGMUEwe/rqCGcwBCcKmVvQeMgp
	DHuMivDGX93Lkk8VEA1/coev/A==
X-Google-Smtp-Source: APXvYqwchftXeveUuXJHknSGejturvoBpu91/DIibP3TqJfUAAo+U3HXFzD6DGyObdeKZ5MP3RURPQ==
X-Received: by 2002:a63:5b54:: with SMTP id l20mr19043243pgm.324.1582607596247;
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
Subject: [PATCH v4 6/6] arm64, elf: Disable automatic READ_IMPLIES_EXEC for 64-bit address spaces
Date: Mon, 24 Feb 2020 21:13:07 -0800
Message-Id: <20200225051307.6401-7-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200225051307.6401-1-keescook@chromium.org>
References: <20200225051307.6401-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

With arm64 64-bit environments, there should never be a need for automatic
READ_IMPLIES_EXEC, as the architecture has always been execute-bit aware
(as in, the default memory protection should be NX unless a region
explicitly requests to be executable).

Suggested-by: Hector Marco-Gisbert <hecmargi@upv.es>
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/elf.h | 4 ++--
 fs/compat_binfmt_elf.c       | 5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index 03ada29984a7..ea9221ed68a1 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -105,7 +105,7 @@
  *             CPU*: | arm32      | arm64      |
  * ELF:              |            |            |
  * -------------------------------|------------|
- * missing GNU_STACK | exec-all   | exec-all   |
+ * missing GNU_STACK | exec-all   | exec-none  |
  * GNU_STACK == RWX  | exec-stack | exec-stack |
  * GNU_STACK == RW   | exec-none  | exec-none  |
  *
@@ -117,7 +117,7 @@
  *  *all arm64 CPUs support NX, so there is no "lacks NX" column.
  *
  */
-#define elf_read_implies_exec(ex,stk)	(stk == EXSTACK_DEFAULT)
+#define compat_elf_read_implies_exec(ex, stk)	(stk == EXSTACK_DEFAULT)
 
 #define CORE_DUMP_USE_REGSET
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
diff --git a/fs/compat_binfmt_elf.c b/fs/compat_binfmt_elf.c
index aaad4ca1217e..3068d57436b3 100644
--- a/fs/compat_binfmt_elf.c
+++ b/fs/compat_binfmt_elf.c
@@ -113,6 +113,11 @@
 #define	arch_setup_additional_pages compat_arch_setup_additional_pages
 #endif
 
+#ifdef	compat_elf_read_implies_exec
+#undef	elf_read_implies_exec
+#define	elf_read_implies_exec compat_elf_read_implies_exec
+#endif
+
 /*
  * Rename a few of the symbols that binfmt_elf.c will define.
  * These are all local so the names don't really matter, but it
-- 
2.20.1

