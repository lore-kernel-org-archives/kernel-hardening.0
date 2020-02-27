Return-Path: <SRS0=q5x+=4P=lists.openwall.com=kernel-hardening-return-17984-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B92F9C11D3D
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Feb 2020 19:35:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 158ED222C2
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Feb 2020 19:35:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="g/0EvsSA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 158ED222C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17984-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1530 invoked by uid 550); 27 Feb 2020 19:35:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1494 invoked from network); 27 Feb 2020 19:35:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=46Z0N6nNFPIgM2OuwNgkHRjYe659IsqNoWw8FG0hdrY=;
        b=g/0EvsSAMFLQMs3F4fsuSd2nVZEd0UnWu4D3Sl3dqAK2cD5B2JP/5fjn+Xf0mTTCA1
         5qBJKz6rexuU4wD/Fm2T6RKX1mqL5z11ejipV8pBRRNCR/z0fgr1nevk9cbdozCY3z4J
         CEEvmhdGXWUBzU64x5LbmMXX3iFxMU4Y/Igq8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=46Z0N6nNFPIgM2OuwNgkHRjYe659IsqNoWw8FG0hdrY=;
        b=W0gdkrCx4BZw5nSjGDQmnuOjEkr1lMZOkqt894VXX1ZfChrelY3BxQ3lgK+tMNGIXu
         hVGewTt+5C+Jvxy+O+P8S2T0mS3mCW1I0aLwXsIloauO5lVLINVrPxjeYGekg+NtWj68
         ka0q3n7fFGzMplNYOupMDkdsUEdhwFHEG1ltNRwhSyJqS3gvFp19NB2M5WQgrUKCedPM
         4LQbt94w3WWm74FNSa3mt75V+lC9PC7ZscbVx6oEy8554ghPDN44KAn9yDCPW17rdhW8
         0IsoUM2FH+iL7zMJau484V9iNt051847htemgTgV1qOEa2qivP4XklEVChoj+3yW6cl+
         VHVA==
X-Gm-Message-State: APjAAAW2ZBa90IwXIM8VMTNgHEy33TgmFMi/EmtoWgZUd/m+4II7f+Qj
	K0w2rpeTvH+mUjxWVkv8hOCMug==
X-Google-Smtp-Source: APXvYqyO3xXE1iYRbSHC6/Q9hVVz43xR0biiVO0z4es+cZucLAEsJlQuw4NFe3BlB1tUhIBv2xxm2g==
X-Received: by 2002:a17:90a:c24c:: with SMTP id d12mr520844pjx.113.1582832121953;
        Thu, 27 Feb 2020 11:35:21 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>,
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
Subject: [PATCH v5 4/6] ubsan: Check panic_on_warn
Date: Thu, 27 Feb 2020 11:35:14 -0800
Message-Id: <20200227193516.32566-5-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200227193516.32566-1-keescook@chromium.org>
References: <20200227193516.32566-1-keescook@chromium.org>
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

