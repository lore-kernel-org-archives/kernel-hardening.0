Return-Path: <SRS0=RyBW=4Q=lists.openwall.com=kernel-hardening-return-17997-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED70C3F2C6
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 00:02:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DE6EF2087F
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 00:02:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="MiPZlyhh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE6EF2087F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17997-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22131 invoked by uid 550); 28 Feb 2020 00:01:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22030 invoked from network); 28 Feb 2020 00:01:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HVEfaBtq4P7YQEKJlB0rNIhGuSMdX7ZyWHWzM+iNj0k=;
        b=MiPZlyhhgfM7UPgKZ/frWvRzNlBB5613UuXaClOb+/1qj4My0rxjR2m0/Q68Aqjer2
         gZYS9YdvWjfD32foSE/T14ZSJwLXcxaxD5TFllT8NBx0vpNpvH9gXUcwAi9LBcMVYSoD
         GAqgi2ibQpd1tNuqjY7zAzuM2NwWtDPz6cTyI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HVEfaBtq4P7YQEKJlB0rNIhGuSMdX7ZyWHWzM+iNj0k=;
        b=jZFi40MPj5wqGEYHaLQa73LXAGvnnRp4bPxJCmQHPKApMYjy5CIZ/Yb4MXgY1ybXMY
         7cxCotpU2ntEpZ2wZ0XtRTr98Z3mf1I02WXpPaZEp0nZQU2vBsF+6xndYcBvEREd0v7E
         VF7eTOdY9Ye/ZJtQlr6e2dgCO7r65mTQiYk8BhC2TDJM9ioE5yBO1Sgn8U5tc8jt9ZDx
         ASPJow+nHInybm6aMlYHTn8r0Fwr5SzQQ287skNW/4HltRqZqhKN8MEKtkSFykFcPKa4
         WEO0KgAeNhIc7Cy3oHtX6niXkOUfgJJDJ3xFgb1PegmdZiXB+ny2tQ/1YqRKHBGSyn8X
         Wmsw==
X-Gm-Message-State: APjAAAW6W3ciUiNT4mg4kJr30d/bPHk/qEyEVqftaoQFzbgzERxAoU/e
	6gn8CdAb1X5CmrM80J6zkWV/ngqnPXI=
X-Google-Smtp-Source: APXvYqymY4xDGLBpKhllQYQtdvp8eIxEJSyOvYMBEHU7xpDpUfih++1rH9KsvwXHUVBag4LFr8Qb4Q==
X-Received: by 2002:a17:90a:7784:: with SMTP id v4mr1614784pjk.134.1582848081160;
        Thu, 27 Feb 2020 16:01:21 -0800 (PST)
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
	Andy Lutomirski <luto@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Len Brown <len.brown@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v11 06/11] x86/CPU: Adapt assembly for PIE support
Date: Thu, 27 Feb 2020 16:00:51 -0800
Message-Id: <20200228000105.165012-7-thgarnie@chromium.org>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
In-Reply-To: <20200228000105.165012-1-thgarnie@chromium.org>
References: <20200228000105.165012-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the assembly code to use only relative references of symbols for the
kernel to be PIE compatible.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
---
 arch/x86/include/asm/processor.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 09705ccc393c..fdf6366c482d 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -746,11 +746,13 @@ static inline void sync_core(void)
 		"pushfq\n\t"
 		"mov %%cs, %0\n\t"
 		"pushq %q0\n\t"
-		"pushq $1f\n\t"
+		"leaq 1f(%%rip), %q0\n\t"
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
2.25.1.481.gfbce0eb801-goog

