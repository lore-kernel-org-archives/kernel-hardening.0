Return-Path: <SRS0=TosP=3F=lists.openwall.com=kernel-hardening-return-17565-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44DD8C32771
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jan 2020 01:25:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 989E02084D
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jan 2020 01:25:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="YBfsq7Ez"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 989E02084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17565-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 4002 invoked by uid 550); 16 Jan 2020 01:24:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3851 invoked from network); 16 Jan 2020 01:24:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8H0Ju2Tzkc7Hi4GTApYP4I+j3crkZ0C4oDWnN2FFbsw=;
        b=YBfsq7Ezv9QYWZccbUoWAnosaxltJReREbQgD47d8e4wJ+Ejg4Gn/vs3HhD5eYzXQr
         oJSYxgIJL4FY50iMU0/0GHsjGfjdVuL9/LFpgrcASS5CbKRGtx4pLqrpDWIs3X6BUzT1
         x8tB+7PXLZLkr6MHrizsmnC10IzFOgJdvcjV8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8H0Ju2Tzkc7Hi4GTApYP4I+j3crkZ0C4oDWnN2FFbsw=;
        b=d+V/TNk0v7j20oQQ8uzcCK89Ed2F1TK5CXIkqyR3k5Ek36JC+GRi0lUqUuxbVsoynK
         zT5VTaaxIDLK4u/y7k5AjOjA8N+gOlWAIYoZHmVPzU0W9D2d3IXgiitQLuUijeFxv/4h
         BlBOhN+Brr8bDpbFCau+wBh7Ji6EsZHyoEIfcDt47dsZpxsn8hQy4d5MILt06nDivxia
         Sql0AIGnO8gjicxFzNAaqR12AAE1U76L69iEOSFRfx+S2B5gz1cd72AONCiEKAL6bKM6
         mTC579VNqXAI9eItzAUZUorKVlTLeO+4kDKdx3SxmFJyev7NCuaqe+QiECk5aKKr+esY
         W17g==
X-Gm-Message-State: APjAAAVuPhBHvBIRGyKQU7FRRhtY6zicNifZ5Q+f3uKW27BXUo3Wp/xf
	NJ1onYNZ2QdPOPzxKCEFiSEoiA==
X-Google-Smtp-Source: APXvYqyCry89U8JhHB2JmnnGGqfqp6e2/sFNsw+rUzw40rZSQ9y3ohq76mRbxz8eJb3EdmcaMK/hOw==
X-Received: by 2002:aa7:98d0:: with SMTP id e16mr33457061pfm.77.1579137865146;
        Wed, 15 Jan 2020 17:24:25 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Elena Petrova <lenaptr@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	syzkaller@googlegroups.com
Subject: [PATCH v3 5/6] kasan: Unset panic_on_warn before calling panic()
Date: Wed, 15 Jan 2020 17:23:20 -0800
Message-Id: <20200116012321.26254-6-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116012321.26254-1-keescook@chromium.org>
References: <20200116012321.26254-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As done in the full WARN() handler, panic_on_warn needs to be cleared
before calling panic() to avoid recursive panics.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 mm/kasan/report.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 621782100eaa..844554e78893 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -92,8 +92,16 @@ static void end_report(unsigned long *flags)
 	pr_err("==================================================================\n");
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 	spin_unlock_irqrestore(&report_lock, *flags);
-	if (panic_on_warn)
+	if (panic_on_warn) {
+		/*
+		 * This thread may hit another WARN() in the panic path.
+		 * Resetting this prevents additional WARN() from panicking the
+		 * system on this thread.  Other threads are blocked by the
+		 * panic_mutex in panic().
+		 */
+		panic_on_warn = 0;
 		panic("panic_on_warn set ...\n");
+	}
 	kasan_enable_current();
 }
 
-- 
2.20.1

