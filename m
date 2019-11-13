Return-Path: <SRS0=bPxx=ZF=lists.openwall.com=kernel-hardening-return-17354-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D48BCC432C3
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 Nov 2019 18:26:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6D24820409
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 Nov 2019 18:26:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="MEtxbYLY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D24820409
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17354-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1164 invoked by uid 550); 13 Nov 2019 18:25:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1065 invoked from network); 13 Nov 2019 18:25:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FkQlTXoldDSpdA3XRHwjBvm7XBhk4dajoTajQfALRYk=;
        b=MEtxbYLYLDqKJOwVZpQwr07bqAbP7blBkrIKEe+qSSM+PzgU+W1xQ5xOMPT6NWkA5s
         rjycVONiVR4AZCSO66k8jQI/nHgPmSZA8EKdwNPXcG1C+dxVgIME8hIZfzzYsdvFzQNR
         bObyqobSLlgC0VWqTqqCssDdU0qVnwehbIpug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FkQlTXoldDSpdA3XRHwjBvm7XBhk4dajoTajQfALRYk=;
        b=PE4keK9SGu6xfdQdKj7tmNVsvQ8gCAcphCXo+udTQyDFGN4MvlwMbONSwK5S77LATu
         LTmojQruF1y3T8haLGIoQcZGeMd4VMms36dfXmYyFaol0tVOBYB++dvNNMcnDAqUFcub
         RbAE9GmG2z2Q7psMHOO+NNYLYep2hX82/XKDe8Z52iLgAfbmVLdqzENG23I3cjU1RNZP
         WexTp1N34allYe/YZFJYy+vwZs0QljAUZZidomAbMAHrsAGYCU5Lkfo0stJVb8XWhuB+
         ztelWtbxGkQXrWwk/oqNovnlFVkRG4Okid+8yYSArvyb1i3TX/qfBRfOXkXqI2peDLPB
         hdiA==
X-Gm-Message-State: APjAAAVM13kF+UxAV6olsQm74pyn9VJZm/ouN6+GnVcReINin333IArQ
	8h3QmDgH8fQ8ka/vqi7h0NWHzQ==
X-Google-Smtp-Source: APXvYqwdr/HsDHCg8rYc+JoYPlqrZVPXvJbvoHDyYD/BcIw5ye1omidirdR4UfblDi7OXzJoXHKdAw==
X-Received: by 2002:a17:902:8345:: with SMTP id z5mr5111902pln.113.1573669528934;
        Wed, 13 Nov 2019 10:25:28 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <keescook@chromium.org>,
	=?UTF-8?q?Jo=C3=A3o=20Moreira?= <joao.moreira@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Stephan Mueller <smueller@chronox.de>,
	x86@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v5 7/8] crypto: x86/glue_helper: Remove function prototype cast helpers
Date: Wed, 13 Nov 2019 10:25:15 -0800
Message-Id: <20191113182516.13545-8-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191113182516.13545-1-keescook@chromium.org>
References: <20191113182516.13545-1-keescook@chromium.org>

Now that all users of the function prototype casting helpers have been
removed, delete the unused macros.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/crypto/glue_helper.h | 5 -----
 include/crypto/xts.h                      | 2 --
 2 files changed, 7 deletions(-)

diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index 22d54e8b8375..d08a7085015f 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -18,11 +18,6 @@ typedef void (*common_glue_ctr_func_t)(void *ctx, u8 *dst, const u8 *src,
 typedef void (*common_glue_xts_func_t)(void *ctx, u8 *dst, const u8 *src,
 				       le128 *iv);
 
-#define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
-#define GLUE_CBC_FUNC_CAST(fn) ((common_glue_cbc_func_t)(fn))
-#define GLUE_CTR_FUNC_CAST(fn) ((common_glue_ctr_func_t)(fn))
-#define GLUE_XTS_FUNC_CAST(fn) ((common_glue_xts_func_t)(fn))
-
 struct common_glue_func_entry {
 	unsigned int num_blocks; /* number of blocks that @fn will process */
 	union {
diff --git a/include/crypto/xts.h b/include/crypto/xts.h
index 75fd96ff976b..15ae7fdc0478 100644
--- a/include/crypto/xts.h
+++ b/include/crypto/xts.h
@@ -8,8 +8,6 @@
 
 #define XTS_BLOCK_SIZE 16
 
-#define XTS_TWEAK_CAST(x) ((void (*)(void *, u8*, const u8*))(x))
-
 static inline int xts_check_key(struct crypto_tfm *tfm,
 				const u8 *key, unsigned int keylen)
 {
-- 
2.17.1

