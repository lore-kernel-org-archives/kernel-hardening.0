Return-Path: <SRS0=V6p0=VF=lists.openwall.com=kernel-hardening-return-16390-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D1ACC606BD
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2019 17:50:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8FF452189F
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2019 17:50:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BNCUGiWX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FF452189F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16390-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28219 invoked by uid 550); 8 Jul 2019 17:49:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28083 invoked from network); 8 Jul 2019 17:49:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OoW2qUxF2Y13G8sy4evp2ekSnjnyuxDpMJJ26amqb7M=;
        b=BNCUGiWXuQ8qN+niQV/uh0ftqGzahTn53WVCXKLQ7j3/UygHUpJNdM1dz3w0hUR9V9
         3/HTRrHFz27ciHAqn+eej0H+MN7JSSyl9ZHtRUnlgHj1BwgG3ICdq1xpj6Bn5VYDBAUq
         mOamx9j7XPuTvZ7+3bO+ZNE5xM1++o+Pceiv4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OoW2qUxF2Y13G8sy4evp2ekSnjnyuxDpMJJ26amqb7M=;
        b=GmrkPIQH72VvVfD8Wy3HYIjdzSsO0DA79BUNc56+LrS63sUENHhqJkbWHRiEXDMrU1
         MvlvLc4p6Xj/9lOKfp/xlmww4LLT1HDPI6dg3FaOq+eari2OxhmN98Q5Zyiycz8iSxOI
         XKaMTyVFsoUEe1oRaUfXKQzxYoU+EFvciMeh4MgShqkdWx8/kAJTwB5E8QdUcFoZqkqi
         4L4xWsWu6oobamh/M41JDI7pNQar81P+ALQ8SROoWRjeUQg1b8xu7EQct3fWsTNoghs5
         FIqGlegs3ilVy1X1XwwqmCSqywYTyjr7T9dbQCpG/ZrYe31v9gjXhq3mesMhV+KL9sZS
         6QfA==
X-Gm-Message-State: APjAAAWDvbY2a5Gg7pfRpVNuoGQUwVuiD33FLqNURgEnnpkXNOgOilKr
	PqEylcyXKVv/YOFqLDHQAMZjibbzuxM=
X-Google-Smtp-Source: APXvYqw279fFsYnSHVmw/+KLDHUbYaOUU+X8mJqY8GWz4AaJjrinbltbShvM9qQHBj13cCc5O+8nig==
X-Received: by 2002:a17:90a:5288:: with SMTP id w8mr27583562pjh.61.1562608175528;
        Mon, 08 Jul 2019 10:49:35 -0700 (PDT)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	keescook@chromium.org,
	Thomas Garnier <thgarnie@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Len Brown <len.brown@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 06/11] x86/CPU: Adapt assembly for PIE support
Date: Mon,  8 Jul 2019 10:48:59 -0700
Message-Id: <20190708174913.123308-7-thgarnie@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190708174913.123308-1-thgarnie@chromium.org>
References: <20190708174913.123308-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the assembly code to use only relative references of symbols for the
kernel to be PIE compatible. Use the new _ASM_MOVABS macro instead of
the 'mov $symbol, %dst' construct.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
---
 arch/x86/include/asm/processor.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 3eab6ece52b4..3e2154b0e09f 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -713,11 +713,13 @@ static inline void sync_core(void)
 		"pushfq\n\t"
 		"mov %%cs, %0\n\t"
 		"pushq %q0\n\t"
-		"pushq $1f\n\t"
+		"movabsq $1f, %q0\n\t"
+		"pushq %q0\n\t"
 		"iretq\n\t"
 		UNWIND_HINT_RESTORE
 		"1:"
-		: "=&r" (tmp), ASM_CALL_CONSTRAINT : : "cc", "memory");
+		: "=&r" (tmp), ASM_CALL_CONSTRAINT
+		: : "cc", "memory");
 #endif
 }
 
-- 
2.22.0.410.gd8fdbe21b5-goog

