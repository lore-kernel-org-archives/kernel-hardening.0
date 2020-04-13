Return-Path: <SRS0=kNsT=55=lists.openwall.com=kernel-hardening-return-18499-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A78BCC2BA19
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Apr 2020 15:33:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 040892072C
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Apr 2020 15:33:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UOoBsfxh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 040892072C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18499-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19499 invoked by uid 550); 13 Apr 2020 15:32:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18374 invoked from network); 13 Apr 2020 15:32:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jlI6RZwAeSB0wbNAx6U5Hs1HxRUTSCnbRiRykcZqGNQ=;
        b=UOoBsfxh54Ek4c+Z2qosmk5m+xl6VlhPSBJtKjPu+D0KUVsoytgyNXI+MMzF45JT8h
         RzihwkRKXxWtcCmBdLoQEbAXW1k8zjA+2bYab0HjlQX8oFTBBuw6G33y/Y2lyFkMWYf0
         7QUSNM/IyU0T1HLiUrqkSXlB1XbLoZd3EOA5lFCY5A5JBfIIU7NuhJAcu6HKQSvkSxa0
         9GDMCmpoE4PeMmG93JqWANW3N5whYBpAsSloFq2apcBgwlhClbTAmHSwSijj7cPKxH8w
         2ZdMrjLhgRzqqHiodwwSQsgwefvBGVdhSCQdmcMpBx5sBwSjxvu5dNoeLTlzWZHMamc8
         Cuxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jlI6RZwAeSB0wbNAx6U5Hs1HxRUTSCnbRiRykcZqGNQ=;
        b=gCBR8MV7tdW9cVsSwORD54hh/VLnyuotyIUVAKP3SJrXFYkRgTSS7WXHAAAf/Hj7nl
         7U7GjwEOZbGQbs1DnoEKpe7djslKgVyzV+LZ14kKn0EsbQI+qshCAEbKjsRtXNQXIg5i
         EV+affhisckV33IphmGCKZt2BrlKRKODCO9RZVCdR3LPqlEhUUgO+C2JXX1Un4+d/DXi
         8bqLSEeUYBqvT1CTni1F5oc0LlUvSMMBEMicB2cdyAVcobbzt5cUCRJKK45NQrbQS95F
         a3ecT62XiFp3i1hkXueiuv3vY5u4qx8NiGkNeFAvGA1oP+rGDc8zcgGd6QqcQTuh60ge
         s98Q==
X-Gm-Message-State: AGi0PubY+DnaSKULGWtE8i8HG8yihJbfQc3AFvdSjThECvamSN/9Adyx
	057ynY3n7sJUkCeR+YH+Khw=
X-Google-Smtp-Source: APiQypITjBdTPiK6o3JqI5ScFOmMSH/hy1hFJ/Xh629QguwJgGQlbx7bgMf1cSsRBPl6u5rfmxgMeQ==
X-Received: by 2002:a1c:4603:: with SMTP id t3mr18964693wma.103.1586791953168;
        Mon, 13 Apr 2020 08:32:33 -0700 (PDT)
From: Lev Olshvang <levonshe@gmail.com>
To: keescook@chromium.orh
Cc: kernel-hardening@lists.openwall.com,
	Lev Olshvang <levonshe@gmail.com>
Subject: [PATCH v3 4/5] Hardening unicore32: Forbid writes to read-only memory pages of a process
Date: Mon, 13 Apr 2020 18:32:10 +0300
Message-Id: <20200413153211.29876-5-levonshe@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200413153211.29876-1-levonshe@gmail.com>
References: <20200413153211.29876-1-levonshe@gmail.com>

Signed-off-by: Lev Olshvang <levonshe@gmail.com>
---
 arch/unicore32/include/asm/mmu_context.h | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/unicore32/include/asm/mmu_context.h b/arch/unicore32/include/asm/mmu_context.h
index 50961d4b4951..388c0c811c68 100644
--- a/arch/unicore32/include/asm/mmu_context.h
+++ b/arch/unicore32/include/asm/mmu_context.h
@@ -93,11 +93,6 @@ static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
 	/* by default, allow everything */
-	if (likely(vma_write_allowed(vma, write, execute, foreign)))
-		return true;
-
-	pr_err_once("Error : PID[%d] %s writes to read only memory\n",
-			current->tgid, current->comm);
-	return false;
+	return true;
 }
 #endif
-- 
2.17.1

