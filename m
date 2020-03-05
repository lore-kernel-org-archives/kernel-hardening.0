Return-Path: <SRS0=k7i3=4W=lists.openwall.com=kernel-hardening-return-18074-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC4AC3F2D1
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 15:08:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 04A31208CD
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 15:08:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04A31208CD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18074-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 8044 invoked by uid 550); 5 Mar 2020 15:08:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8012 invoked from network); 5 Mar 2020 15:08:50 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m1v7KEH8H8EEgDnDnnlGNlXFsnNQAqOhZZNudokQ2Po=;
        b=nyaNW4M4T1mwJHKevT6wYa4CV0jHG8jVutLUTaR8l3XpL1QzHM37dJSJjJh5x8g0XJ
         aMj/9nakW0RaOdL1Z9FI3LNrW4Sgm8BZEw1XmfT0DrZf16IKh1rvdHRePE17zWNlf1mG
         Oky1DrR81Czv1LwjAjoccDZZ4sAokTzuUPBKSCWYFjwjFJuKuSvd1WyN9kyLYI19Js18
         NH9qM8IlOMWBanOi+D5ckJmB6Gw07dNWUK2GS5coWnGtOy3mDS30q5sbYwi4P9QilBCX
         eD6NzpLEXu5JaEagD654DiTdxnP9lzc/c3rmnV8OW9pE7m6Lth459Rt87beJM8+s8EOT
         FAmA==
X-Gm-Message-State: ANhLgQ3w4pGKZTy6e6x5p1s3PmqKkX61ijp3oe+CQK6yQAffjT8+o8u6
	K+Cw2+U1WmC4SBosbHfrV4Q=
X-Google-Smtp-Source: ADFU+vuOS2xZwbWZs6qEQtovSh6AUFl9WlSPml+IgYmIWtqCd0kt/sKG334d9lzu+FpmW4dkIw7TEw==
X-Received: by 2002:ac8:4408:: with SMTP id j8mr7637069qtn.3.1583420918447;
        Thu, 05 Mar 2020 07:08:38 -0800 (PST)
From: Arvind Sankar <nivedita@alum.mit.edu>
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C . Harding" <me@tobin.cc>,
	Tycho Andersen <tycho@tycho.ws>,
	kernel-hardening@lists.openwall.com,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc/32: Stop printing the virtual memory layout
Date: Thu,  5 Mar 2020 10:08:37 -0500
Message-Id: <20200305150837.835083-1-nivedita@alum.mit.edu>
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
 arch/powerpc/mm/mem.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index ef7b1119b2e2..df2c143b6bf7 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -331,23 +331,6 @@ void __init mem_init(void)
 #endif
 
 	mem_init_print_info(NULL);
-#ifdef CONFIG_PPC32
-	pr_info("Kernel virtual memory layout:\n");
-#ifdef CONFIG_KASAN
-	pr_info("  * 0x%08lx..0x%08lx  : kasan shadow mem\n",
-		KASAN_SHADOW_START, KASAN_SHADOW_END);
-#endif
-	pr_info("  * 0x%08lx..0x%08lx  : fixmap\n", FIXADDR_START, FIXADDR_TOP);
-#ifdef CONFIG_HIGHMEM
-	pr_info("  * 0x%08lx..0x%08lx  : highmem PTEs\n",
-		PKMAP_BASE, PKMAP_ADDR(LAST_PKMAP));
-#endif /* CONFIG_HIGHMEM */
-	if (ioremap_bot != IOREMAP_TOP)
-		pr_info("  * 0x%08lx..0x%08lx  : early ioremap\n",
-			ioremap_bot, IOREMAP_TOP);
-	pr_info("  * 0x%08lx..0x%08lx  : vmalloc & ioremap\n",
-		VMALLOC_START, VMALLOC_END);
-#endif /* CONFIG_PPC32 */
 }
 
 void free_initmem(void)
-- 
2.24.1

