Return-Path: <SRS0=ipuA=4P=lists.openwall.com=kernel-hardening-return-17979-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A47D9C35DF9
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Feb 2020 18:50:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 03077246C6
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Feb 2020 18:50:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="lTDnhmVn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03077246C6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17979-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3831 invoked by uid 550); 27 Feb 2020 18:49:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3732 invoked from network); 27 Feb 2020 18:49:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=46Z0N6nNFPIgM2OuwNgkHRjYe659IsqNoWw8FG0hdrY=;
        b=lTDnhmVnqQJEUJ5LnBGPuhXrnv05UkcjRDWNOX4WHR+p4aommd+S5U5/xJ9GYmjDyV
         D/5GwhtD18WW//fs2/5w1ghXIQm+EKFifaYUneu04fLN8/9y1Mj2SuFmDWjgLzxaen0O
         3tTOuDeaafS34wt+AZuoCBaUtcE3qzutj612k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=46Z0N6nNFPIgM2OuwNgkHRjYe659IsqNoWw8FG0hdrY=;
        b=Y5al6XlPUeRYJxZ0cTtBFh4xV2ychyqnJT8kkAXfnVLrmaLXOQxjE3gYC2uX7xT+IH
         s59hkF/LWU+v8oF5u9Si7K+VFWq+DmRk6+z57/pRN5KqeGnQQ3aK0f6kwRC0HvU9sHdB
         +nuPaT14MBRkhOM1vn6+oxL9rcJh4x/pJESz+yC+eU0rfspmLEVwEUgSRA/q5xArfJSJ
         4uc2KIfY9fTlbf+tgdmVVqEcIhszLnnpPAvsueibdZtfQuXnXdT/jOV3KKfpT/bptd/j
         CNEo7QjwJdfAntAh7u5YoRw9pJPiCPO/I1bTbMhz7ASidQvDzWNokUMZxT+K/ohGp6EY
         ZL7A==
X-Gm-Message-State: APjAAAX9f4Uqs5robz+xmtyHP4dDbaXo00SmLuzVz88WwXe8dvGrft5q
	FsuogFazELfF2w0JDyCUG2gdvg==
X-Google-Smtp-Source: APXvYqyp61REIsdWHH37oqm6TnnTLVpBM0r3x0E6/zmvpnUPvvoIlWHFgZSyISwmK1qp5zs0Rz23qw==
X-Received: by 2002:a63:3103:: with SMTP id x3mr677715pgx.209.1582829368829;
        Thu, 27 Feb 2020 10:49:28 -0800 (PST)
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
Subject: [PATCH v4 4/6] ubsan: Check panic_on_warn
Date: Thu, 27 Feb 2020 10:49:19 -0800
Message-Id: <20200227184921.30215-5-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200227184921.30215-1-keescook@chromium.org>
References: <20200227184921.30215-1-keescook@chromium.org>
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

