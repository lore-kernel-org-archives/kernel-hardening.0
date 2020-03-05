Return-Path: <SRS0=Sw95=4W=lists.openwall.com=kernel-hardening-return-18071-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6E3C3F2D1
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 15:02:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B238B20801
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 15:02:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B238B20801
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18071-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1828 invoked by uid 550); 5 Mar 2020 15:02:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1796 invoked from network); 5 Mar 2020 15:02:05 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G+99kCRYMzeEWVxPvUrg7nF1DV74zPu+cLQl+vuE6tE=;
        b=ikgQK95PV7J6MqEfek1UMDx4AAwvahztyM5/jz0wszEI97hC02/dpziXlCFKkpJ5uO
         tQcb645funOi/zSyniOq4xolxmXfPnTKWvPPaUilyy1xlffNZaiNHUB8ced6CErT1yFp
         barwGAlqA63ZLicUOKjeDdHwNH2L7yz1fiCLPbaaCTRtg8+cy7xcJ0WvGJC8qHuD2RtO
         xByC2RE/yKK0nlQjuBG2HAeduyCZ50qPAlb6eHJ+8hmLGllYoC9y8pceZek7rXNAe/Ss
         l+dt0pOD+0m6eBeW9G7NqtvBs7BHIpP+nZVbfoMRhrP8m7lcdnRWrzb0Vfosv/xY8krq
         LG6Q==
X-Gm-Message-State: ANhLgQ1pEOXTaOm1OQ/6QTGBf+Z1gkGBChfg+J5EZEqTo7qXkrJHvkE1
	bmCdeR2w8QDnwzo+6o24Hbc=
X-Google-Smtp-Source: ADFU+vun+lE3H+kFlVWifa921exuOdYo+CsuSTA28nIHTavPtrQtBcLZ/jpFo/8YRdLeTKv6qbbgJg==
X-Received: by 2002:a37:a14a:: with SMTP id k71mr8329570qke.321.1583420513686;
        Thu, 05 Mar 2020 07:01:53 -0800 (PST)
From: Arvind Sankar <nivedita@alum.mit.edu>
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C . Harding" <me@tobin.cc>,
	Tycho Andersen <tycho@tycho.ws>,
	kernel-hardening@lists.openwall.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] x86/mm/init_32: Stop printing the virtual memory layout
Date: Thu,  5 Mar 2020 10:01:52 -0500
Message-Id: <20200305150152.831697-1-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <202003021039.257258E1B@keescook>
References: <202003021039.257258E1B@keescook>
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
 arch/x86/mm/init_32.c | 38 --------------------------------------
 1 file changed, 38 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 23df4885bbed..8ae0272c1c51 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -788,44 +788,6 @@ void __init mem_init(void)
 	x86_init.hyper.init_after_bootmem();
 
 	mem_init_print_info(NULL);
-	printk(KERN_INFO "virtual kernel memory layout:\n"
-		"    fixmap  : 0x%08lx - 0x%08lx   (%4ld kB)\n"
-		"  cpu_entry : 0x%08lx - 0x%08lx   (%4ld kB)\n"
-#ifdef CONFIG_HIGHMEM
-		"    pkmap   : 0x%08lx - 0x%08lx   (%4ld kB)\n"
-#endif
-		"    vmalloc : 0x%08lx - 0x%08lx   (%4ld MB)\n"
-		"    lowmem  : 0x%08lx - 0x%08lx   (%4ld MB)\n"
-		"      .init : 0x%08lx - 0x%08lx   (%4ld kB)\n"
-		"      .data : 0x%08lx - 0x%08lx   (%4ld kB)\n"
-		"      .text : 0x%08lx - 0x%08lx   (%4ld kB)\n",
-		FIXADDR_START, FIXADDR_TOP,
-		(FIXADDR_TOP - FIXADDR_START) >> 10,
-
-		CPU_ENTRY_AREA_BASE,
-		CPU_ENTRY_AREA_BASE + CPU_ENTRY_AREA_MAP_SIZE,
-		CPU_ENTRY_AREA_MAP_SIZE >> 10,
-
-#ifdef CONFIG_HIGHMEM
-		PKMAP_BASE, PKMAP_BASE+LAST_PKMAP*PAGE_SIZE,
-		(LAST_PKMAP*PAGE_SIZE) >> 10,
-#endif
-
-		VMALLOC_START, VMALLOC_END,
-		(VMALLOC_END - VMALLOC_START) >> 20,
-
-		(unsigned long)__va(0), (unsigned long)high_memory,
-		((unsigned long)high_memory - (unsigned long)__va(0)) >> 20,
-
-		(unsigned long)&__init_begin, (unsigned long)&__init_end,
-		((unsigned long)&__init_end -
-		 (unsigned long)&__init_begin) >> 10,
-
-		(unsigned long)&_etext, (unsigned long)&_edata,
-		((unsigned long)&_edata - (unsigned long)&_etext) >> 10,
-
-		(unsigned long)&_text, (unsigned long)&_etext,
-		((unsigned long)&_etext - (unsigned long)&_text) >> 10);
 
 	/*
 	 * Check boundaries twice: Some fundamental inconsistencies can
-- 
2.24.1

