Return-Path: <SRS0=OECi=4R=lists.openwall.com=kernel-hardening-return-18025-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E2CC3F2C6
	for <kernel-hardening@archiver.kernel.org>; Sat, 29 Feb 2020 23:11:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 71D5424672
	for <kernel-hardening@archiver.kernel.org>; Sat, 29 Feb 2020 23:11:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71D5424672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18025-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9428 invoked by uid 550); 29 Feb 2020 23:11:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9396 invoked from network); 29 Feb 2020 23:11:33 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T5ZPrIWUcFdZz+VY7vEnX2GwkgxMVshMmglqEI63Hd0=;
        b=efldeXgDU0p6cNG3ROPC29glrfWU7SgGGTT/SOvzXLC+u1tGgwZcqsREXPM8ymUsBA
         DpZo2re6sgPj4kNKLQaAx2F/2sWifvSRznhHJ9m1g4WRL/X+K7Bf7Lvp66OdBCDiZU4r
         scBptZ5RjmFOYDo8XfAR89W9k110sFs+NZHM2SkEjb1TKnxeMWAhby6qU1hVw1nDP9HP
         3g0z7FtaKUVEFBg/LIA7vgEuRmId+8igT8aGJ6JRxyMHKpyP2AWQkxRkB7N1GtgHOKde
         +6SgMzzIiEe0rlrq+Od0NGrKobV/WJajwoCrwNnUqCqIe3zi/7OwvftEFfwpHmWHTPXl
         9e6w==
X-Gm-Message-State: APjAAAXc6XpGnnd9vg+uob+9+B7OyJe5Ur5iLAtIPwm8FnZPwEPvafFV
	lF8dUbiypus2EeDxZabkiDo=
X-Google-Smtp-Source: APXvYqzJ+SJfesoEXBu07OvOjzBqsP/jFC5ZXJWFZcSGrzC5jVvdiMCeSRFshxY0nR3wLP/Z04f2Wg==
X-Received: by 2002:a05:620a:146c:: with SMTP id j12mr10863660qkl.373.1583017881241;
        Sat, 29 Feb 2020 15:11:21 -0800 (PST)
From: Arvind Sankar <nivedita@alum.mit.edu>
To: "Tobin C . Harding" <me@tobin.cc>,
	Tycho Andersen <tycho@tycho.ws>
Cc: kernel-hardening@lists.openwall.com,
	Kees Cook <keescook@chromium.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] x86/mm/init: Stop printing pgt_buf addresses
Date: Sat, 29 Feb 2020 18:11:20 -0500
Message-Id: <20200229231120.1147527-1-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This currently leaks kernel physical addresses into userspace.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
---
 arch/x86/mm/init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index e7bb483557c9..dc4711f09cdc 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -121,8 +121,6 @@ __ref void *alloc_low_pages(unsigned int num)
 	} else {
 		pfn = pgt_buf_end;
 		pgt_buf_end += num;
-		printk(KERN_DEBUG "BRK [%#010lx, %#010lx] PGTABLE\n",
-			pfn << PAGE_SHIFT, (pgt_buf_end << PAGE_SHIFT) - 1);
 	}
 
 	for (i = 0; i < num; i++) {
-- 
2.24.1

