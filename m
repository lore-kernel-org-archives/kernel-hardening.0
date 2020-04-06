Return-Path: <SRS0=CGQt=5W=lists.openwall.com=kernel-hardening-return-18429-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D0DDC2BA19
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Apr 2020 14:59:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 58FB720769
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Apr 2020 14:59:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lKRnunrP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 58FB720769
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18429-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14050 invoked by uid 550); 6 Apr 2020 14:59:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30362 invoked from network); 6 Apr 2020 14:21:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0Bn24+y1kGNwe9DFY64ROYnXOJNtjKvnNKvk64odtX4=;
        b=lKRnunrPaE5/RhRVk/daU9Ur1312W3z/Fy1B1qwDC19qZm8X+6o7/Z3kHUnbP9RSsy
         U3HjQb979P9GGXfjziGF4VMmURveQCymDmX5EMv1X4VDErqiCydlZqsHnSDaNpvMW5cu
         x5Vu2OoYRhSLlPEq55OQKd9O+3Q58nac4yuArVGN00Guckx/gV8z0rMfwntW5EHr4zWd
         h8V8swKRqUEy+8b5wgc2oPF7sOTKBfT8S07zBDfcfL5Y3c3qv7Z/Hlp2R8fy64O4Gspy
         OlNT78aEFoCeW0yyZ3oN6utTqLAadLueONhGQ/hzsBv23NCqWgdJgAq1doBu7Y+fDKJ6
         4Bxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0Bn24+y1kGNwe9DFY64ROYnXOJNtjKvnNKvk64odtX4=;
        b=nESKXt+vZN30IjZnU3RtNV+YGbp5HwNF8XcGZ2eUX8JtvL5LKEBkkDoNfooPCXWa4V
         dA/+c5mVZiwOFotsLd4hR8m/yQLK2ruxmeInz3P4Q2d6yVkjNnP9TI18HZHp2+JG2hJv
         ScUpNIbrvn0JEWvqOd7ihS843HXdSGTm7EHfuGv8/tBlrLhiAHhpea8ibsU2SAlA4hzV
         4MM5SmAAxwg7rxG49a9/0jw+OQSuVBJRFMJDUhI0fGNTUBB5K277GzbhTllEFLraU+bg
         2UdVQPyepZMOUBJwT7FOurrwTHm6rSV+u6oeOxsIOwKRvEHKuocx6asOfj0stBdQDgJk
         G4OA==
X-Gm-Message-State: AGi0PubnhIED43MKeuBkrzYGR+z3b5zh3nqFrIOSEUFQlHcpKPE4C9GY
	mJWfzykbcprwXXepTqWOYGe9sZwN6L2rwQ==
X-Google-Smtp-Source: APiQypLGnGly7fF8aKwhSk1dT3RIj5NoRnjBV/1o9u9Gu4b8x4r1eqM4gX1hVZZV4jL3FfBRDSGngw==
X-Received: by 2002:a7b:cf02:: with SMTP id l2mr20319770wmg.4.1586182885443;
        Mon, 06 Apr 2020 07:21:25 -0700 (PDT)
From: Lev Olshvang <levonshe@gmail.com>
To: arnd@arndb.de
Cc: kernel-hardening@lists.openwall.com,
	Lev Olshvang <levonshe@gmail.com>
Subject: [RFC PATCH 5/5] UM:Prevent write to read-only pages :text, PLT/GOT tables from another process
Date: Mon,  6 Apr 2020 17:20:45 +0300
Message-Id: <20200406142045.32522-6-levonshe@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200406142045.32522-1-levonshe@gmail.com>
References: <20200406142045.32522-1-levonshe@gmail.com>

Signed-off-by: Lev Olshvang <levonshe@gmail.com>
---
 arch/um/include/asm/mmu_context.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/um/include/asm/mmu_context.h b/arch/um/include/asm/mmu_context.h
index b4deb1bfbb68..2de21d52bd60 100644
--- a/arch/um/include/asm/mmu_context.h
+++ b/arch/um/include/asm/mmu_context.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/*
+/*
  * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  */

@@ -28,6 +28,11 @@ static inline void arch_unmap(struct mm_struct *mm,
 static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
+	#ifdef CONFIG_PROTECT_READONLY_USER_MEMORY
+	/* Forbid write to PROT_READ pages of foreign process */
+	if (write && foreign && (!(vma->vm_flags & VM_WRITE)))
+	return false;
+	#endif
 	/* by default, allow everything */
 	return true;
 }
@@ -52,7 +57,7 @@ static inline void activate_mm(struct mm_struct *old, struct mm_struct *new)
 	up_write(&new->mmap_sem);
 }

-static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
+static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 			     struct task_struct *tsk)
 {
 	unsigned cpu = smp_processor_id();
@@ -65,7 +70,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	}
 }

-static inline void enter_lazy_tlb(struct mm_struct *mm,
+static inline void enter_lazy_tlb(struct mm_struct *mm,
 				  struct task_struct *tsk)
 {
 }
--
2.17.1

