Return-Path: <SRS0=oWnl=4W=lists.openwall.com=kernel-hardening-return-18076-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 482E3C3F2CD
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 15:12:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A19F12070E
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 15:12:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A19F12070E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18076-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11951 invoked by uid 550); 5 Mar 2020 15:11:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11919 invoked from network); 5 Mar 2020 15:11:57 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PjbkYOJJF4QVM5t+Vwl8Y4BXszbEfFKAKxz7B3KWc7g=;
        b=a0sKhZ3jmeXbALF1em2q3zdTZik4Ch1j/4jXTwJLn0sXCqRnR1DmZrm+C5HRL5I93O
         59REQUx78yCimQSr+cywMgwWUlC/KoXKDNDMkuRhpR02+5UE+HayIEFPseq0iSUJoM93
         ofe8bHr7lU6qZOMUT/RxMYY5DUTuXp6voO0qux9b7Mphk5KOpnmiNcoG6YoirO4M/K9q
         XjIpopiP4KdbdULx+LOb/cxdKqd2jNY/dAEgfiWAUJbdsy2AmPZP8kdKulASlZEgNT+F
         Hbz8aBjRhX76tsgNGhedUnYCg6ffQIhddsmqLQh9NsLmaf4KZLGjZuJWS7UkPvqPRgKL
         Oy/A==
X-Gm-Message-State: ANhLgQ0ls6O0edFnSEFKHOk0klxdJ/vs+KM2ZsK7fdknvhbJZ5nfNnV/
	fqEGpPOxtdzECmDfc/b+Hq8=
X-Google-Smtp-Source: ADFU+vtlWGM1UZ1f2aliBPEDyGuIg9uQXGA6okBMuDSwkcXoOJqL+PG1QBjgeAKnASBWIjuWGN8Egw==
X-Received: by 2002:a37:b984:: with SMTP id j126mr8051038qkf.3.1583421105629;
        Thu, 05 Mar 2020 07:11:45 -0800 (PST)
From: Arvind Sankar <nivedita@alum.mit.edu>
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C . Harding" <me@tobin.cc>,
	Tycho Andersen <tycho@tycho.ws>,
	kernel-hardening@lists.openwall.com,
	Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
	linux-xtensa@linux-xtensa.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] xtensa/mm: Stop printing the virtual memory layout
Date: Thu,  5 Mar 2020 10:11:44 -0500
Message-Id: <20200305151144.836824-1-nivedita@alum.mit.edu>
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
 arch/xtensa/mm/init.c | 46 -------------------------------------------
 1 file changed, 46 deletions(-)

diff --git a/arch/xtensa/mm/init.c b/arch/xtensa/mm/init.c
index 19c625e6d81f..7ba3f1fce8ec 100644
--- a/arch/xtensa/mm/init.c
+++ b/arch/xtensa/mm/init.c
@@ -155,52 +155,6 @@ void __init mem_init(void)
 	memblock_free_all();
 
 	mem_init_print_info(NULL);
-	pr_info("virtual kernel memory layout:\n"
-#ifdef CONFIG_KASAN
-		"    kasan   : 0x%08lx - 0x%08lx  (%5lu MB)\n"
-#endif
-#ifdef CONFIG_MMU
-		"    vmalloc : 0x%08lx - 0x%08lx  (%5lu MB)\n"
-#endif
-#ifdef CONFIG_HIGHMEM
-		"    pkmap   : 0x%08lx - 0x%08lx  (%5lu kB)\n"
-		"    fixmap  : 0x%08lx - 0x%08lx  (%5lu kB)\n"
-#endif
-		"    lowmem  : 0x%08lx - 0x%08lx  (%5lu MB)\n"
-		"    .text   : 0x%08lx - 0x%08lx  (%5lu kB)\n"
-		"    .rodata : 0x%08lx - 0x%08lx  (%5lu kB)\n"
-		"    .data   : 0x%08lx - 0x%08lx  (%5lu kB)\n"
-		"    .init   : 0x%08lx - 0x%08lx  (%5lu kB)\n"
-		"    .bss    : 0x%08lx - 0x%08lx  (%5lu kB)\n",
-#ifdef CONFIG_KASAN
-		KASAN_SHADOW_START, KASAN_SHADOW_START + KASAN_SHADOW_SIZE,
-		KASAN_SHADOW_SIZE >> 20,
-#endif
-#ifdef CONFIG_MMU
-		VMALLOC_START, VMALLOC_END,
-		(VMALLOC_END - VMALLOC_START) >> 20,
-#ifdef CONFIG_HIGHMEM
-		PKMAP_BASE, PKMAP_BASE + LAST_PKMAP * PAGE_SIZE,
-		(LAST_PKMAP*PAGE_SIZE) >> 10,
-		FIXADDR_START, FIXADDR_TOP,
-		(FIXADDR_TOP - FIXADDR_START) >> 10,
-#endif
-		PAGE_OFFSET, PAGE_OFFSET +
-		(max_low_pfn - min_low_pfn) * PAGE_SIZE,
-#else
-		min_low_pfn * PAGE_SIZE, max_low_pfn * PAGE_SIZE,
-#endif
-		((max_low_pfn - min_low_pfn) * PAGE_SIZE) >> 20,
-		(unsigned long)_text, (unsigned long)_etext,
-		(unsigned long)(_etext - _text) >> 10,
-		(unsigned long)__start_rodata, (unsigned long)__end_rodata,
-		(unsigned long)(__end_rodata - __start_rodata) >> 10,
-		(unsigned long)_sdata, (unsigned long)_edata,
-		(unsigned long)(_edata - _sdata) >> 10,
-		(unsigned long)__init_begin, (unsigned long)__init_end,
-		(unsigned long)(__init_end - __init_begin) >> 10,
-		(unsigned long)__bss_start, (unsigned long)__bss_stop,
-		(unsigned long)(__bss_stop - __bss_start) >> 10);
 }
 
 static void __init parse_memmap_one(char *p)
-- 
2.24.1

