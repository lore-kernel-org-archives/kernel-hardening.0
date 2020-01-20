Return-Path: <SRS0=lxFV=3J=lists.openwall.com=kernel-hardening-return-17596-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5BD2C33CA1
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2020 07:44:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 227B52077C
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2020 07:44:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="VuL5LjlK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 227B52077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=axtens.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17596-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21628 invoked by uid 550); 20 Jan 2020 07:44:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21528 invoked from network); 20 Jan 2020 07:44:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cgbwx4pPrUton+YWvUC8+XEHkB4TEyRZFBvrMu0o0Xs=;
        b=VuL5LjlKzy5In5eNW/F5iZwG9YFS55bxJ5qNflJfa7xgPiL5jeyn4MVx6HIXtqakdc
         mlWSi8vEjgA+5iEwRXltmyveZnSvqffSizU8pgqORRZe+7ND4OEjm3+oEkOTSUgm/shH
         tDykiKnwoifmqkjgslih0ocm9GPAeGNHcGHQE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cgbwx4pPrUton+YWvUC8+XEHkB4TEyRZFBvrMu0o0Xs=;
        b=Ab+QKaZ3as+30kfkueYJSkt5EVNa4N/5JVWWuT7cGBaG3fR5gjJpPXy0DE5iJp7SrA
         9VN8OfozCpmcj2DDKmy6IPalZSjEfH4nExmm/4IyOPH6drtL7DYnqaazKswUcb+KDCXR
         DsI2AWG5vDzfZ6imGTYbWz2xLZ8J+CyIa5hmp0UYg6bxmspriJjsc1W7BF95OXPbEBZe
         iiw4OzUjGw7v5Mt/zh60cgW+XoBWDvFc4aEC6MyTozCxUV525OePHHB+09MuNpQTKoOG
         C+RROYch86q1jpwN6KTIUUcp/ZogLDHRaoMp0tkr2Z178tfCze6AzKJm0oOYw9cnbrsu
         /9Ig==
X-Gm-Message-State: APjAAAUQqU+wXIN/sQqYtdtEKM1QVChuee88dl8G/xyiBhLKapmCm28c
	APXodNTaKeU2Ly3rNS5AjArr2kMv0t8=
X-Google-Smtp-Source: APXvYqyZlAaoK52ybK4EBOzspAzOfrFduSZoB1YaLPW36ZGZBdpEQmZVkbWxdL3Re8WEtuUuz3FE4Q==
X-Received: by 2002:aa7:9ec9:: with SMTP id r9mr15945385pfq.85.1579506240797;
        Sun, 19 Jan 2020 23:44:00 -0800 (PST)
From: Daniel Axtens <dja@axtens.net>
To: kernel-hardening@lists.openwall.com,
	linux-mm@kvack.org,
	keescook@chromium.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	Daniel Axtens <dja@axtens.net>
Subject: [PATCH 3/5] [RFC] staging: rts5208: make len a u16 in rtsx_write_cfg_seq
Date: Mon, 20 Jan 2020 18:43:42 +1100
Message-Id: <20200120074344.504-4-dja@axtens.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200120074344.504-1-dja@axtens.net>
References: <20200120074344.504-1-dja@axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A warning occurs when vzalloc is annotated in a subsequent patch to tell
the compiler that its parameter is an allocation size:

drivers/staging/rts5208/rtsx_chip.c: In function ‘rtsx_write_cfg_seq’:
drivers/staging/rts5208/rtsx_chip.c:1453:7: warning: argument 1 value ‘18446744073709551615’ exceeds maximum object size 9223372036854775807 [-Walloc-size-larger-than=]
  data = vzalloc(array_size(dw_len, 4));
  ~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This occurs because len and dw_len are signed integers and the parameter to
array_size is a size_t. If dw_len is a negative integer, it will become a
very large positive number when cast to size_t. This could cause an
overflow, so array_size(), will return SIZE_MAX _at compile time_. gcc then
notices that this value is too large for an allocation and throws a
warning.

rtsx_write_cfg_seq is only called from write_cfg_byte in rtsx_scsi.c.
There, len is a u16. So make len a u16 in rtsx_write_cfg_seq too. This
means dw_len can never be negative, avoiding the potential overflow and the
warning.

This should not cause a functional change, but was compile tested only.

Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 drivers/staging/rts5208/rtsx_chip.c | 2 +-
 drivers/staging/rts5208/rtsx_chip.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx_chip.c b/drivers/staging/rts5208/rtsx_chip.c
index 17c4131f5f62..4a8cbf7362f7 100644
--- a/drivers/staging/rts5208/rtsx_chip.c
+++ b/drivers/staging/rts5208/rtsx_chip.c
@@ -1432,7 +1432,7 @@ int rtsx_read_cfg_dw(struct rtsx_chip *chip, u8 func_no, u16 addr, u32 *val)
 }
 
 int rtsx_write_cfg_seq(struct rtsx_chip *chip, u8 func, u16 addr, u8 *buf,
-		       int len)
+		       u16 len)
 {
 	u32 *data, *mask;
 	u16 offset = addr % 4;
diff --git a/drivers/staging/rts5208/rtsx_chip.h b/drivers/staging/rts5208/rtsx_chip.h
index bac65784d4a1..9b0024557b7e 100644
--- a/drivers/staging/rts5208/rtsx_chip.h
+++ b/drivers/staging/rts5208/rtsx_chip.h
@@ -963,7 +963,7 @@ int rtsx_write_cfg_dw(struct rtsx_chip *chip,
 		      u8 func_no, u16 addr, u32 mask, u32 val);
 int rtsx_read_cfg_dw(struct rtsx_chip *chip, u8 func_no, u16 addr, u32 *val);
 int rtsx_write_cfg_seq(struct rtsx_chip *chip,
-		       u8 func, u16 addr, u8 *buf, int len);
+		       u8 func, u16 addr, u8 *buf, u16 len);
 int rtsx_read_cfg_seq(struct rtsx_chip *chip,
 		      u8 func, u16 addr, u8 *buf, int len);
 int rtsx_write_phy_register(struct rtsx_chip *chip, u8 addr, u16 val);
-- 
2.20.1

