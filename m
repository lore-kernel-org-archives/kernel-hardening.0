Return-Path: <SRS0=DUPu=5W=lists.openwall.com=kernel-hardening-return-18427-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AF9FC2BA19
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Apr 2020 14:59:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8B727206C3
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Apr 2020 14:59:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YjAgtsne"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B727206C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18427-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11733 invoked by uid 550); 6 Apr 2020 14:59:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30273 invoked from network); 6 Apr 2020 14:21:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=U6TtxNoL8vsZ1orBVNXifDVjmZ/Dy8Jl5SK2A+eCKBs=;
        b=YjAgtsnepo6yOh2e6WMPJQH/zQNrmSe2kwaiZbasA0StRdOYqUa4mPbaEmgRreHRs9
         xKBNmlaUB+ieAuuwCtrYLf/05SwkBbaK/m38iHBNm0Tvp+jxj6VG4Y1M2jTQT9CdMKVJ
         5jUZ/YfTZZBzWMhotm6/iZ0OtpIe1bRYR43zv1Rx3gtX1h0tV9nlv7zOz1ZzBgvSKK1d
         WR7D95U4bGOqeeXWdTAWE6JyyrnkV1GbwP5uu1juXoWE1jkyMTAAOcvHrVSX8k6TMhhb
         T0NqrjcTm0t0ObZjGkkX2U01PkyqmZ/rFsyOWf4HmC7K2Fb8fCYfb/1Esh2Iov4IKCdH
         d6kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=U6TtxNoL8vsZ1orBVNXifDVjmZ/Dy8Jl5SK2A+eCKBs=;
        b=Y23+pOveNYvIyKnAzkYgaE7WAbR8vRyuwu6kFR3vVwEGx85oU0hcpSH1X/pM1soDhy
         gGtrQjmoMeCSMvLepqah47ZVPwYSn58jmyyBF+QvbP0ed8dLEuc6vi5xFyhL7TqeilRt
         tFElFDBHF28HKsRN0RXIUQB0BtW2S6FkM6DsCU1J5Fn4zzpYJ7xqeoOcKh7NR/DBDqm1
         J0twksikZXphiOqmIO6q9jSMBPkDFjWAI2KENcIHxN7CpFpItYpv8QvnEMJta7JMKFDc
         Z9Q9uS0H+ZSFSNqw1ZrBCYyz/uv7GN2S9cX2PRKuN7FQZ3w3Y7Fjjw/VUaEiozKj59Q3
         ICfA==
X-Gm-Message-State: AGi0PuaRgidg0KY+nbcbiEQJ068QkRHfmAzDxSch99AXszzhZASe3bPy
	iJ/ednXrv8BwH8dt3J+gkRY=
X-Google-Smtp-Source: APiQypJSc3VUutpLAF+C3TPDX/ncWod1QhEyFkCol1LTSAFEMXHvkWym/36lzVoKowjxUxEzf4YNOA==
X-Received: by 2002:a5d:69c8:: with SMTP id s8mr24309252wrw.300.1586182882984;
        Mon, 06 Apr 2020 07:21:22 -0700 (PDT)
From: Lev Olshvang <levonshe@gmail.com>
To: arnd@arndb.de
Cc: kernel-hardening@lists.openwall.com,
	Lev Olshvang <levonshe@gmail.com>
Subject: [RFC PATCH 3/5] Prevent write to read-only pages text, PLT/GOT tables from another process
Date: Mon,  6 Apr 2020 17:20:43 +0300
Message-Id: <20200406142045.32522-4-levonshe@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200406142045.32522-1-levonshe@gmail.com>
References: <20200406142045.32522-1-levonshe@gmail.com>

Signed-off-by: Lev Olshvang <levonshe@gmail.com>
---
 arch/powerpc/include/asm/mmu_context.h | 7 ++++++-
 arch/powerpc/mm/book3s64/pkeys.c       | 5 +++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/mmu_context.h b/arch/powerpc/include/asm/mmu_context.h
index 360367c579de..b25e5726fa99 100644
--- a/arch/powerpc/include/asm/mmu_context.h
+++ b/arch/powerpc/include/asm/mmu_context.h
@@ -246,10 +246,15 @@ void arch_dup_pkeys(struct mm_struct *oldmm, struct mm_struct *mm);
 static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
+#ifdef CONFIG_PROTECT_READONLY_USER_MEMORY
+	/* Forbid write to PROT_READ pages of foreign process */
+	if (write && foreign && (!(vma->vm_flags & VM_WRITE)))
+		return false;
+#endif
 	/* by default, allow everything */
 	return true;
 }
-
+#endif
 #define pkey_mm_init(mm)
 #define thread_pkey_regs_save(thread)
 #define thread_pkey_regs_restore(new_thread, old_thread)
diff --git a/arch/powerpc/mm/book3s64/pkeys.c b/arch/powerpc/mm/book3s64/pkeys.c
index 07527f1ed108..230058a52009 100644
--- a/arch/powerpc/mm/book3s64/pkeys.c
+++ b/arch/powerpc/mm/book3s64/pkeys.c
@@ -384,6 +384,11 @@ bool arch_pte_access_permitted(u64 pte, bool write, bool execute)
 bool arch_vma_access_permitted(struct vm_area_struct *vma, bool write,
 			       bool execute, bool foreign)
 {
+#ifdef CONFIG_PROTECT_READONLY_USER_MEMORY
+	/* Forbid write to PROT_READ pages of foreign process */
+	if (write && foreign && (!(vma->vm_flags & VM_WRITE)))
+		return false;
+#endif
 	if (static_branch_likely(&pkey_disabled))
 		return true;
 	/*
--
2.17.1

