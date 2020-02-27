Return-Path: <SRS0=HpLh=4P=lists.openwall.com=kernel-hardening-return-17989-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EEE8C11D3D
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Feb 2020 19:36:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9DEBA2468E
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Feb 2020 19:36:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="YBkqK4RC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DEBA2468E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17989-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1958 invoked by uid 550); 27 Feb 2020 19:35:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1871 invoked from network); 27 Feb 2020 19:35:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sVbVapbdvm9D9bZT8RLizJdch6+5SIEY/KYRYQVG8Tk=;
        b=YBkqK4RCOblb4V5cg2JjztQtg3wh+brHnQ/Xnw/4IBUFJRhh4GeFiQP9nVouaSw+sY
         Iq7R/urAShHZ7CPMQvKGeXyT+FOvmE0vy0gms+GZvnF1oUTIeAIqmZaTytVTOmRvhGYp
         9u4+wigHHHW5WR6VelBYcFCmp7ofnwGN7wT7U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sVbVapbdvm9D9bZT8RLizJdch6+5SIEY/KYRYQVG8Tk=;
        b=QWocyYV5WNZXnSdYmN2PMcg9W8ly5MV7kQcND/bDqDCIRLBGhJoIhO69hc1M5WDgAl
         xCbTdYDvMDRwVDv3v9DzOhB4pBN91hkt1wOwObHZag8XdaX3+4SarDutoQhq4yfHt59E
         Cj3IcjMox/nHAtbrqobVoNJ5Q9EOnoSQ4w1Pe2vq/Aq4K4LmvT1YRphsg9zPbIdasqlP
         SZ/pLpmDQr9x+wfXeG9xHT9sk32G5dNyzxZo6rRo30p9ZZMbVFDEVcnw0BvfWGk3DEh5
         8/q5zajP240r9vV8G8j5I1YyNUEjIc2Wopq47rm34P+t3Ip0yqVb6Jt5QsyLlveGb0Uy
         7TJQ==
X-Gm-Message-State: APjAAAX3Sm1zO4YrT+7FnZ91x97Bbl18cRYcNIsAri155q28Vl3ZZVfj
	YlyVeXncUVdAtGSBq0Hk99D7gw==
X-Google-Smtp-Source: APXvYqwJAU0YQCF3NBelWYbAkfjhxYyfXVhFnc+XRJm1wrTo2TVo3yr52ImKKRO716VR/awYEpFPlg==
X-Received: by 2002:a17:90a:3266:: with SMTP id k93mr527984pjb.23.1582832128663;
        Thu, 27 Feb 2020 11:35:28 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Elena Petrova <lenaptr@google.com>,
	Andrey Konovalov <andreyknvl@google.com>,
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
Subject: [PATCH v5 5/6] kasan: Unset panic_on_warn before calling panic()
Date: Thu, 27 Feb 2020 11:35:15 -0800
Message-Id: <20200227193516.32566-6-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200227193516.32566-1-keescook@chromium.org>
References: <20200227193516.32566-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As done in the full WARN() handler, panic_on_warn needs to be cleared
before calling panic() to avoid recursive panics.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
---
 mm/kasan/report.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 5ef9f24f566b..54bd98a1fc7b 100644
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

