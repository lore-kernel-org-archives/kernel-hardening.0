Return-Path: <SRS0=1hro=4W=lists.openwall.com=kernel-hardening-return-18073-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9304FC3F2CD
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 15:07:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ED4852073D
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 15:06:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED4852073D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18073-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 6046 invoked by uid 550); 5 Mar 2020 15:06:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 6014 invoked from network); 5 Mar 2020 15:06:52 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4YtauhyBuYarI81yGagt2ohXVIXr6pZDvPOFIfRFrBo=;
        b=q/UdXQlL1+yp/ySXt5kuEwWTbo+twiE/aNdW72DBJ4z+nuuw1JEKFsEADHAkL+SSnG
         gly4oMrIIDUWGJ9OkVQAgP3MkD/0DSOUXAQF9kB92vqHB8E0NU4B7Ub8XEqzoyEe3Zp9
         xBIQuvhaA6MEqF26pNsXAfhVJxJzwQ1m4WnG75pTbnOqLSrIcvv4jz+/tC8JpvLgAOsi
         XpcEkp95Ad2TbTug4oDPWJKriW3pcuWQ7IcmYV25uryn+GcfretII3F0Jn9L2aH9F5ob
         aR7SYPA9KlKzZUakPtMqpGieG1BJyxp0UBIl/vcNzZvcLtpin8kcD+eAQOQ6UdGT/cGu
         wrGw==
X-Gm-Message-State: ANhLgQ1xFEZQ6BmkrKDNyk79EJu6lKE8iDy03w8dpsp3ZTmVGnt4Taqw
	g1ko6bMZKFOr9Vzodiaro/w=
X-Google-Smtp-Source: ADFU+vt4PIOV75cKuujfyu22jJMx8631ltXW5tt1iRMuoUZFlcy2KbEnmXQTIcni8S134YaBPpbl7w==
X-Received: by 2002:a0c:9081:: with SMTP id p1mr4587490qvp.38.1583420800482;
        Thu, 05 Mar 2020 07:06:40 -0800 (PST)
From: Arvind Sankar <nivedita@alum.mit.edu>
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C . Harding" <me@tobin.cc>,
	Tycho Andersen <tycho@tycho.ws>,
	kernel-hardening@lists.openwall.com,
	Nick Hu <nickhu@andestech.com>,
	Greentime Hu <green.hu@gmail.com>,
	Vincent Chen <deanbo422@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nds32/mm: Stop printing the virtual memory layout
Date: Thu,  5 Mar 2020 10:06:39 -0500
Message-Id: <20200305150639.834129-1-nivedita@alum.mit.edu>
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
 arch/nds32/mm/init.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/arch/nds32/mm/init.c b/arch/nds32/mm/init.c
index 0be3833f6814..1c1e79b4407c 100644
--- a/arch/nds32/mm/init.c
+++ b/arch/nds32/mm/init.c
@@ -205,36 +205,6 @@ void __init mem_init(void)
 	memblock_free_all();
 	mem_init_print_info(NULL);
 
-	pr_info("virtual kernel memory layout:\n"
-		"    fixmap  : 0x%08lx - 0x%08lx   (%4ld kB)\n"
-#ifdef CONFIG_HIGHMEM
-		"    pkmap   : 0x%08lx - 0x%08lx   (%4ld kB)\n"
-#endif
-		"    consist : 0x%08lx - 0x%08lx   (%4ld MB)\n"
-		"    vmalloc : 0x%08lx - 0x%08lx   (%4ld MB)\n"
-		"    lowmem  : 0x%08lx - 0x%08lx   (%4ld MB)\n"
-		"      .init : 0x%08lx - 0x%08lx   (%4ld kB)\n"
-		"      .data : 0x%08lx - 0x%08lx   (%4ld kB)\n"
-		"      .text : 0x%08lx - 0x%08lx   (%4ld kB)\n",
-		FIXADDR_START, FIXADDR_TOP, (FIXADDR_TOP - FIXADDR_START) >> 10,
-#ifdef CONFIG_HIGHMEM
-		PKMAP_BASE, PKMAP_BASE + LAST_PKMAP * PAGE_SIZE,
-		(LAST_PKMAP * PAGE_SIZE) >> 10,
-#endif
-		CONSISTENT_BASE, CONSISTENT_END,
-		((CONSISTENT_END) - (CONSISTENT_BASE)) >> 20, VMALLOC_START,
-		(unsigned long)VMALLOC_END, (VMALLOC_END - VMALLOC_START) >> 20,
-		(unsigned long)__va(memory_start), (unsigned long)high_memory,
-		((unsigned long)high_memory -
-		 (unsigned long)__va(memory_start)) >> 20,
-		(unsigned long)&__init_begin, (unsigned long)&__init_end,
-		((unsigned long)&__init_end -
-		 (unsigned long)&__init_begin) >> 10, (unsigned long)&_etext,
-		(unsigned long)&_edata,
-		((unsigned long)&_edata - (unsigned long)&_etext) >> 10,
-		(unsigned long)&_text, (unsigned long)&_etext,
-		((unsigned long)&_etext - (unsigned long)&_text) >> 10);
-
 	/*
 	 * Check boundaries twice: Some fundamental inconsistencies can
 	 * be detected at build time already.
-- 
2.24.1

