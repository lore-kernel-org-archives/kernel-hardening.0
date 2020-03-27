Return-Path: <SRS0=6Y0Q=5M=lists.openwall.com=kernel-hardening-return-18253-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F31C43331
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Mar 2020 06:49:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7284620578
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Mar 2020 06:49:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="i/kVRB9h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7284620578
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18253-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26456 invoked by uid 550); 27 Mar 2020 06:48:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26329 invoked from network); 27 Mar 2020 06:48:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/ziE3u+JHVGjUbo7zvAcqmvTGnTDwDeNLGHtkAuW1SE=;
        b=i/kVRB9h49fSIU/SXBBd76YRq+m2dKmO90EFoN2azRXHRsGFnN8fQwX1bWQShxfMO3
         fsJCr1ApPfPLWPyVmqTHbvnE0/TQ+9Ft1N7AnyEv2Obi+yKqae7pHIiFGbj+dcCs3Qth
         hx/8AA5HN+FRYM8rSleK8Ggvfe0bb3ThM++NY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/ziE3u+JHVGjUbo7zvAcqmvTGnTDwDeNLGHtkAuW1SE=;
        b=JrgzfYVzNP3Grn3olz2H75jlvpbsyRIq9G9rYaMCu+TlHOj73pztpmqGOeMyJ/FQtu
         4kE+IVKW/LfNbXF7jiJPTBJ61Ku13KJqBfcu172911Yx/ZVlUxXnrZVWFL90aUQtR0wI
         ZkUM7uR6bdEMXJGEDAXCiTNxkZCB/R0dZS6xL/BQl9AZOBVgQ/obfsv/Gl/N4cjGoubz
         w97vTEe0hMu8xCp36c4Zuz4+ZJRHhm9yfMmJx4g3rzjoNha9WBVw3HPvUpHpIE2bSY6T
         GuWGIC0PwV/9gn8vRe3AAY+O3I8+rxukBnCI9DZ6njt2XDr/ZTxxM2lH9+3ZbW8u2724
         2LMA==
X-Gm-Message-State: ANhLgQ2BAVD2N9WlbEUzalewzFqMuMNQ8fdisKu5QwwyrTpVQJEgpWVq
	pVCcRcIbtd14XukEtzBQcE1LrA==
X-Google-Smtp-Source: ADFU+vvGmOrrIs+Qj5TkNUJrkUU3G9n3+Tfo2n/9fFwWG4WT0SaqW8ECI8HTyCrm6d42Hjl+wwoUXQ==
X-Received: by 2002:a17:90a:b395:: with SMTP id e21mr4362227pjr.33.1585291708788;
        Thu, 26 Mar 2020 23:48:28 -0700 (PDT)
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
Subject: [PATCH v5 6/6] arm64, elf: Disable automatic READ_IMPLIES_EXEC for 64-bit address spaces
Date: Thu, 26 Mar 2020 23:48:20 -0700
Message-Id: <20200327064820.12602-7-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200327064820.12602-1-keescook@chromium.org>
References: <20200327064820.12602-1-keescook@chromium.org>
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
index 0074e9fd6431..0e7df6f1eb7a 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -105,7 +105,7 @@
  *                CPU*: | arm32      | arm64      |
  * ELF:                 |            |            |
  * ---------------------|------------|------------|
- * missing PT_GNU_STACK | exec-all   | exec-all   |
+ * missing PT_GNU_STACK | exec-all   | exec-none  |
  * PT_GNU_STACK == RWX  | exec-stack | exec-stack |
  * PT_GNU_STACK == RW   | exec-none  | exec-none  |
  *
@@ -117,7 +117,7 @@
  *  *all arm64 CPUs support NX, so there is no "lacks NX" column.
  *
  */
-#define elf_read_implies_exec(ex, stk)	(stk == EXSTACK_DEFAULT)
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

