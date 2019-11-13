Return-Path: <SRS0=dCSd=ZF=lists.openwall.com=kernel-hardening-return-17352-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCED2C432C3
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 Nov 2019 18:26:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1AB3A206ED
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 Nov 2019 18:26:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="VExaM07G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1AB3A206ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17352-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1055 invoked by uid 550); 13 Nov 2019 18:25:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32654 invoked from network); 13 Nov 2019 18:25:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5SySjDTgN3qWnie4Ke2JR3B886GYW0P8tT3fYgclTkk=;
        b=VExaM07G2Px81mzM/uVGM95aKdSOW3V4JqLg5km95Azs7ZaTdwk2gUkNpADIF4oxoN
         wyAYVugJ7PCh2ovu3SEW60ZWAqYORnVjvL6VHzQFIrzU9ceuuqNbUrWfCfsq/Qek6rLM
         iBMZELZEodScImYU48BBJCcijcfjLqChT5HX8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5SySjDTgN3qWnie4Ke2JR3B886GYW0P8tT3fYgclTkk=;
        b=Xu3uYIEQBthxsBESVpLIsqY9hjsAvs5xKOXLYKSgiregD8qq8RcZr8wtr5K9fnnD3a
         yk1pVzba5Dtjn7o9dhJRA8o5GtF8r8fwgO0uasmf3JHmbc4J8sZuTHJ/fLZvoUT6C2m0
         DvKj7Q259k9bEyGARURmWcX8fYnfxeVkCxFmCQYjh7/t5esypTRyJYa19e4ghlOC+uQB
         iAXfY5dKFa/l1QFUF3h2KVl67MFL1zWeD4egzmDFQpEIGN76NYQgzfQA4aMSE7Sc/Jom
         /ZJoCF/NbcEKoczbCKWQXPOdKR/h2kbMrh7NoItR0ANVMV1XauBg5ToZ8/d1bUoIXTkC
         oXag==
X-Gm-Message-State: APjAAAU+tbY7x6nb3hDff7GT2LMdXVezPWu1xh3WTRod/KHktFOTShVz
	DoLgJfAOWLiu+xthYKRFKt2XYA==
X-Google-Smtp-Source: APXvYqzuLlP4xvSyy5tZNeGXMpPEZ/WJ6KBWFFuZ88y2PQLr5GqL1uDM4V4EaIMleAQtKeJcj/wtcw==
X-Received: by 2002:a65:41cd:: with SMTP id b13mr5322014pgq.385.1573669527194;
        Wed, 13 Nov 2019 10:25:27 -0800 (PST)
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
Subject: [PATCH v5 6/8] crypto: x86/aesni: Remove glue function macro usage
Date: Wed, 13 Nov 2019 10:25:14 -0800
Message-Id: <20191113182516.13545-7-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191113182516.13545-1-keescook@chromium.org>
References: <20191113182516.13545-1-keescook@chromium.org>

In order to remove the callsite function casts, regularize the function
prototypes for helpers to avoid triggering Control-Flow Integrity checks
during indirect function calls. Where needed, to avoid changes to
pointer math, u8 pointers are internally cast back to u128 pointers.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/crypto/aesni-intel_glue.c | 45 +++++++++++++-----------------
 1 file changed, 19 insertions(+), 26 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 3e707e81afdb..f47afa5ae8ca 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -83,10 +83,8 @@ struct gcm_context_data {
 
 asmlinkage int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 			     unsigned int key_len);
-asmlinkage void aesni_enc(struct crypto_aes_ctx *ctx, u8 *out,
-			  const u8 *in);
-asmlinkage void aesni_dec(struct crypto_aes_ctx *ctx, u8 *out,
-			  const u8 *in);
+asmlinkage void aesni_enc(void *ctx, u8 *out, const u8 *in);
+asmlinkage void aesni_dec(void *ctx, u8 *out, const u8 *in);
 asmlinkage void aesni_ecb_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len);
 asmlinkage void aesni_ecb_dec(struct crypto_aes_ctx *ctx, u8 *out,
@@ -107,7 +105,7 @@ asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 
 asmlinkage void aesni_xts_crypt8(struct crypto_aes_ctx *ctx, u8 *out,
-				 const u8 *in, bool enc, u8 *iv);
+				 const u8 *in, bool enc, le128 *iv);
 
 /* asmlinkage void aesni_gcm_enc()
  * void *ctx,  AES Key schedule. Starts on a 16 byte boundary.
@@ -550,29 +548,26 @@ static int xts_aesni_setkey(struct crypto_skcipher *tfm, const u8 *key,
 }
 
 
-static void aesni_xts_tweak(void *ctx, u8 *out, const u8 *in)
+static void aesni_xts_enc(void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	aesni_enc(ctx, out, in);
+	glue_xts_crypt_128bit_one(ctx, (u128 *)dst, (const u128 *)src, iv,
+				  aesni_enc);
 }
 
-static void aesni_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+static void aesni_xts_dec(void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv, GLUE_FUNC_CAST(aesni_enc));
+	glue_xts_crypt_128bit_one(ctx, (u128 *)dst, (const u128 *)src, iv,
+				  aesni_dec);
 }
 
-static void aesni_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+static void aesni_xts_enc8(void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv, GLUE_FUNC_CAST(aesni_dec));
+	aesni_xts_crypt8(ctx, dst, src, true, iv);
 }
 
-static void aesni_xts_enc8(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+static void aesni_xts_dec8(void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	aesni_xts_crypt8(ctx, (u8 *)dst, (const u8 *)src, true, (u8 *)iv);
-}
-
-static void aesni_xts_dec8(void *ctx, u128 *dst, const u128 *src, le128 *iv)
-{
-	aesni_xts_crypt8(ctx, (u8 *)dst, (const u8 *)src, false, (u8 *)iv);
+	aesni_xts_crypt8(ctx, dst, src, false, iv);
 }
 
 static const struct common_glue_ctx aesni_enc_xts = {
@@ -581,10 +576,10 @@ static const struct common_glue_ctx aesni_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = 8,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(aesni_xts_enc8) }
+		.fn_u = { .xts = aesni_xts_enc8 }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(aesni_xts_enc) }
+		.fn_u = { .xts = aesni_xts_enc }
 	} }
 };
 
@@ -594,10 +589,10 @@ static const struct common_glue_ctx aesni_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = 8,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(aesni_xts_dec8) }
+		.fn_u = { .xts = aesni_xts_dec8 }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(aesni_xts_dec) }
+		.fn_u = { .xts = aesni_xts_dec }
 	} }
 };
 
@@ -606,8 +601,7 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&aesni_enc_xts, req,
-				   XTS_TWEAK_CAST(aesni_xts_tweak),
+	return glue_xts_req_128bit(&aesni_enc_xts, req, aesni_enc,
 				   aes_ctx(ctx->raw_tweak_ctx),
 				   aes_ctx(ctx->raw_crypt_ctx),
 				   false);
@@ -618,8 +612,7 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&aesni_dec_xts, req,
-				   XTS_TWEAK_CAST(aesni_xts_tweak),
+	return glue_xts_req_128bit(&aesni_dec_xts, req, aesni_enc,
 				   aes_ctx(ctx->raw_tweak_ctx),
 				   aes_ctx(ctx->raw_crypt_ctx),
 				   true);
-- 
2.17.1

