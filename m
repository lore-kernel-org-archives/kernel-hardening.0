Return-Path: <SRS0=9dxE=4W=lists.openwall.com=kernel-hardening-return-18072-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 368FEC3F2CD
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 15:05:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8FBED20801
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 15:05:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FBED20801
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18072-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 4041 invoked by uid 550); 5 Mar 2020 15:05:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 4009 invoked from network); 5 Mar 2020 15:05:17 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DHZpwYtph4e4XvTwzjYe/dYk7V3T2U6hQ2PR81bE1+A=;
        b=gOrR3V8PMDtOE29auiBaSOlG/id/oDI7My5KbGhYACWq8foDteZN4K0romCv4yys8U
         H0wBR2qwzSqT15oXyO29+secuXQqyDQo7bkpAvWKV3dmz8YQTdL7wGSay0tfT9fFupmB
         v0qmt5cnjtYeySFi/sYKaroBoPA9JgOPCFhaIuD1V2/ROFhSIPEoqNtJI+8KWQv6l74O
         xah5NVZIKZPox48NapPRNfFEVeUOZHuwmO9th/AkfbO/RbFPYVeUidK3obJKvzD2u2Pr
         Pu2jrqTbI8NlyGH2ZGTL0yMZUNZjfpUzKw/cKRz5ag+mKjAKD1e6Qq114pOKcJQiHp+Q
         AFQA==
X-Gm-Message-State: ANhLgQ0/sirFze+qN+kj1594Zq/CjnZKZXIy0Gn91ooLm5h6fvEXFuGF
	yk21Eja7DqHL03x4cN4NoVs=
X-Google-Smtp-Source: ADFU+vt9ZG47mHHNYOu4QgHGpZhfHLFcRTrsrZsiQHYCTpmwtRGsWnJknkOV5avRh+fAPtBGjB7vXA==
X-Received: by 2002:a37:aa92:: with SMTP id t140mr3685762qke.119.1583420705705;
        Thu, 05 Mar 2020 07:05:05 -0800 (PST)
From: Arvind Sankar <nivedita@alum.mit.edu>
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C . Harding" <me@tobin.cc>,
	Tycho Andersen <tycho@tycho.ws>,
	kernel-hardening@lists.openwall.com,
	Michal Simek <monstr@monstr.eu>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] microblaze: Stop printing the virtual memory layout
Date: Thu,  5 Mar 2020 10:05:03 -0500
Message-Id: <20200305150503.833172-1-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <202003021038.8F0369D907@keescook>
References: <202003021038.8F0369D907@keescook>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For security, don't display the kernel's virtual memory layout.

Kees Cook points out:
"These have been entirely removed on other architectures, so let's
just do the same for ia32 and remove it unconditionally."

071929dbdd86 ("arm64: Stop printing the virtual memory layout")
1c31d4e96b8c ("ARM: 8820/1: mm: Stop printing the virtual memory layout")
31833332f798 ("m68k/mm: Stop printing the virtual memory layout")
fd8d0ca25631 ("parisc: Hide virtual kernel memory layout")
adb1fe9ae2ee ("mm/page_alloc: Remove kernel address exposure in free_reserved_area()")

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
---
 arch/microblaze/mm/init.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
index 1056f1674065..8323651bf7ec 100644
--- a/arch/microblaze/mm/init.c
+++ b/arch/microblaze/mm/init.c
@@ -201,18 +201,6 @@ void __init mem_init(void)
 #endif
 
 	mem_init_print_info(NULL);
-#ifdef CONFIG_MMU
-	pr_info("Kernel virtual memory layout:\n");
-	pr_info("  * 0x%08lx..0x%08lx  : fixmap\n", FIXADDR_START, FIXADDR_TOP);
-#ifdef CONFIG_HIGHMEM
-	pr_info("  * 0x%08lx..0x%08lx  : highmem PTEs\n",
-		PKMAP_BASE, PKMAP_ADDR(LAST_PKMAP));
-#endif /* CONFIG_HIGHMEM */
-	pr_info("  * 0x%08lx..0x%08lx  : early ioremap\n",
-		ioremap_bot, ioremap_base);
-	pr_info("  * 0x%08lx..0x%08lx  : vmalloc & ioremap\n",
-		(unsigned long)VMALLOC_START, VMALLOC_END);
-#endif
 	mem_init_done = 1;
 }
 
-- 
2.24.1

