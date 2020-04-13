Return-Path: <SRS0=R63L=55=lists.openwall.com=kernel-hardening-return-18496-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37776C2BA19
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Apr 2020 15:32:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 89FCB20735
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Apr 2020 15:32:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kA4ad8Nm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89FCB20735
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18496-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18036 invoked by uid 550); 13 Apr 2020 15:32:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17863 invoked from network); 13 Apr 2020 15:32:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oEzcpg+wFM4Rb49aIBDj7gJZwlrOkRESDp319LMJSJA=;
        b=kA4ad8NmHrZL3DfrE8aXACAYgUSOraXDJIi6eSAo/UKYkZvU20oz+mNzVBat2FeUHI
         +c5OQGMcIjWC3wZH0IXnoVStgOm1N3iBkdiaek6e5tfRwQQlKoQKsJQm4Xa7SR2A1cZe
         65xE6TJLTv43NQwa3KczO0Nh0wPyVHu1BizPdNKWtPtDXc3Hg9PGFEAUYC8aISBkP0kX
         XSgb1lnhx37Jdmc37tzotVTmAr/fGZy/eMPf8rb72c9jFbR67ns1CBd8yxgu4IrWptpM
         rlhO2sZAuNn2aTtUyA7RfD7KTcXm7lJOL/1tgLSAjHDai65sNGdarcnqtkuPHj7PPZih
         klWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oEzcpg+wFM4Rb49aIBDj7gJZwlrOkRESDp319LMJSJA=;
        b=dXEAV4vgmg4M2vIqs27D/0TYbPT14ALehddF6cyTZM9+MGCf21bVGdsF/Fl+Y+kHFe
         NftzYs5l34Ot0LApMorwW7k/c7atQCC4fvC0NJbpvRuxmwcMVCR3A+gJTPWbCzl5dGqf
         ITzLgSOb+QD4G3i37MqDdgj6APwqt1c0D7subVHtp9delPocSI8Khv8qICfCTdE9iurN
         JOTuwDE3MxbNCP+5zJfBHvPqRKpBAy4hdatiObHnn56QvXpRIBShuUybYOPeww5fY5p5
         rwtmSDfldd+E19Yj2A7UoUGIy41QPVvp9tAgKN82HaO2KWoi6hQ8gz/nhxuViaAx2X0X
         7LvQ==
X-Gm-Message-State: AGi0Pub8WvTmsXB/0OVI8oPRDJ7zB6f1Ys7BvbBTRkTF/lTk1V4Do7jn
	+MZCjqR80egYBBDpyBIZi7U=
X-Google-Smtp-Source: APiQypJ2YnvfFLKOIszSumLAvH3yYJDma329Ax1Gm+zC29OxQIZEsFPflF+pdXyYO/0JVLlvEYyThw==
X-Received: by 2002:a5d:4042:: with SMTP id w2mr11142896wrp.195.1586791949874;
        Mon, 13 Apr 2020 08:32:29 -0700 (PDT)
From: Lev Olshvang <levonshe@gmail.com>
To: keescook@chromium.orh
Cc: kernel-hardening@lists.openwall.com,
	Lev Olshvang <levonshe@gmail.com>
Subject: [PATCH v3 1/5] Hardening x86: Forbid writes to read-only memory pages of a process
Date: Mon, 13 Apr 2020 18:32:07 +0300
Message-Id: <20200413153211.29876-2-levonshe@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200413153211.29876-1-levonshe@gmail.com>
References: <20200413153211.29876-1-levonshe@gmail.com>

Signed-off-by: Lev Olshvang <levonshe@gmail.com>
---
 arch/x86/include/asm/mmu_context.h | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 701a7367babf..4e55370e48e8 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -5,7 +5,6 @@
 #include <asm/desc.h>
 #include <linux/atomic.h>
 #include <linux/mm_types.h>
-#include <linux/printk.h>
 #include <linux/pkeys.h>
 
 #include <trace/events/tlb.h>
@@ -217,12 +216,7 @@ static inline void arch_unmap(struct mm_struct *mm, unsigned long start,
 static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
-	if (unlikely(!vma_write_allowed(vma, write, execute, foreign))) {
-		pr_err_once("Error : PID[%d] %s writes to read only memory\n",
-			current->tgid, current->comm);
-		return false;
-	}
-	/* Don't check PKRU since pkeys never affect instruction fetches */
+	/* pkeys never affect instruction fetches */
 	if (execute)
 		return true;
 	/* allow access if the VMA is not one from this process */
-- 
2.17.1

