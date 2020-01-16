Return-Path: <SRS0=q2aZ=3F=lists.openwall.com=kernel-hardening-return-17562-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5059C32771
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jan 2020 01:25:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 237212084D
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jan 2020 01:25:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="SJwnin5n"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 237212084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17562-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3846 invoked by uid 550); 16 Jan 2020 01:24:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3701 invoked from network); 16 Jan 2020 01:24:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=46Z0N6nNFPIgM2OuwNgkHRjYe659IsqNoWw8FG0hdrY=;
        b=SJwnin5nMwZBKrhpnWtYLNNA2XESjaBA5OMZZUiC+dLBovxajhmbEreGNQuSCGlJwg
         rzwLtTnueeZeF9mo1NZWc/UG++85l/gf4xMNaTD7Mi65olwyiNctPjj7SEzVTf8lz6JY
         y2wkfmtBIGevOe/HcrOjcNSuIe8PF7VSzsSEI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=46Z0N6nNFPIgM2OuwNgkHRjYe659IsqNoWw8FG0hdrY=;
        b=nHrZMMR1RB7yPxlQlk04vrwNufnAI9KvK6SZLDOiG+YeslnQVv12kX7V8ARIto5qSo
         ROLEjrdbETrQhfxGEOcKuyHWYAV54wimNutBK4qYUprBRYQm+Mr+Y2ny8tFBITaqy8m6
         FdUbJVwCKo4FDDfBB/i0CuqzVdVbtdHwOui+mD+JG7LLp7OJWr6iggZBweD8+F3tFY1P
         BxLvP245qY2H82T5FCjrlkmKt7RjHfpN32miMOS0NkcFGHnuf9UCe2vuNx2KjJ/6tKyN
         wMc4ynzFdj/t+60A4g6kZ0Vs/AX9Q+ikVa1u1wSDFQ7p7e4V5UMl/tao9HQM0ZEcmbYz
         KYig==
X-Gm-Message-State: APjAAAV9RZ8vKTmGFhiO8jUNvOLEk/0Z9VoZQySn2mjVP4jMHiIV3LBa
	4Lfl5blyNdmMbZxZy8UexvJF9A==
X-Google-Smtp-Source: APXvYqxsGknX6bnO/GaSkj5DHw5Et7M+pO9sTANSMwjDnHU91axQ6Z/1Fsl4MvtQ189Vh73/ukEWVg==
X-Received: by 2002:aa7:9816:: with SMTP id e22mr35105862pfl.229.1579137863425;
        Wed, 15 Jan 2020 17:24:23 -0800 (PST)
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
Subject: [PATCH v3 4/6] ubsan: Check panic_on_warn
Date: Wed, 15 Jan 2020 17:23:19 -0800
Message-Id: <20200116012321.26254-5-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116012321.26254-1-keescook@chromium.org>
References: <20200116012321.26254-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzkaller expects kernel warnings to panic when the panic_on_warn
sysctl is set. More work is needed here to have UBSan reuse the WARN
infrastructure, but for now, just check the flag manually.

Link: https://lore.kernel.org/lkml/CACT4Y+bsLJ-wFx_TaXqax3JByUOWB3uk787LsyMVcfW6JzzGvg@mail.gmail.com
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/ubsan.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/lib/ubsan.c b/lib/ubsan.c
index 7b9b58aee72c..429663eef6a7 100644
--- a/lib/ubsan.c
+++ b/lib/ubsan.c
@@ -156,6 +156,17 @@ static void ubsan_epilogue(void)
 		"========================================\n");
 
 	current->in_ubsan--;
+
+	if (panic_on_warn) {
+		/*
+		 * This thread may hit another WARN() in the panic path.
+		 * Resetting this prevents additional WARN() from panicking the
+		 * system on this thread.  Other threads are blocked by the
+		 * panic_mutex in panic().
+		 */
+		panic_on_warn = 0;
+		panic("panic_on_warn set ...\n");
+	}
 }
 
 static void handle_overflow(struct overflow_data *data, void *lhs,
-- 
2.20.1

