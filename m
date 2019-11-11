Return-Path: <SRS0=jXK2=ZD=lists.openwall.com=kernel-hardening-return-17335-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC0AC43331
	for <kernel-hardening@archiver.kernel.org>; Mon, 11 Nov 2019 21:47:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0113E206BB
	for <kernel-hardening@archiver.kernel.org>; Mon, 11 Nov 2019 21:47:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ZP43Y1V6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0113E206BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17335-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32643 invoked by uid 550); 11 Nov 2019 21:46:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32484 invoked from network); 11 Nov 2019 21:46:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZcOJA7rw+bZqOv1GdLBsInsGQzz6225k9cIjCh5MhhM=;
        b=ZP43Y1V6ff1HQ8Xg1Z0ybmTGnTgRWCPigzsp6aXFM0pQLo1PpYLDrNqdglWa7w2kBE
         ofnkcT7WE6/XgspKsZzZ5hZBEtphVnmkH3/mJOvpJtyAg1t+8XDm9JPGKrQruBHSlYFm
         lLKvS4N7e27k8xvRFE8aBMz/XQgulBfA9tQ5s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZcOJA7rw+bZqOv1GdLBsInsGQzz6225k9cIjCh5MhhM=;
        b=mq3wLXjz2sEpjy+WTWqmHJnbS3A9oJIhPzOpPvyco50nbIV2fIT/3WTiOxnJc1LaUW
         c6H1Otjq+8Ws9lMkL13A60PogJd8XcGSLPEkDnUZxA4FxhkQy1mRdk7xIKKdQ45RlJL5
         SuxWjSVRu843ac2Yxe/2XlyQcVUBTAQmWQ5Ik4EaHpWKELtFhxixCzWFG66x0aGjVsTv
         I3OBez6z+0oBhjTQOv+jpvQQklSR37QicU2ylVilD4cNuwmb77VK76amaDj82+QdqoYD
         3NXZKNLCfJrq0zrHr/ERVE7PRLiHPGy2YiefX9Y1hfVwMWWXFiKI5vC3By5DZRPsAOFc
         TrEA==
X-Gm-Message-State: APjAAAXK4cCNqVMom2uBeZUPrAdjLX9ZfbtT6FojgoFwz9zUrXS6xd94
	CyYVDkAkxULpaqIDGcJ6wkBYOQ==
X-Google-Smtp-Source: APXvYqyffBGHQKnSMZzfXoWRTqJhRDT1ivChICdHWoCl+K+VCWP8Doc5SEkO+zmrUTOghOMCkdnNiQ==
X-Received: by 2002:a05:6a00:e:: with SMTP id h14mr30956789pfk.99.1573508765844;
        Mon, 11 Nov 2019 13:46:05 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <keescook@chromium.org>,
	=?UTF-8?q?Jo=C3=A3o=20Moreira?= <joao.moreira@lsc.ic.unicamp.br>,
	Eric Biggers <ebiggers@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Stephan Mueller <smueller@chronox.de>,
	x86@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v4 5/8] crypto: x86/cast6: Use new glue function macros
Date: Mon, 11 Nov 2019 13:45:49 -0800
Message-Id: <20191111214552.36717-6-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191111214552.36717-1-keescook@chromium.org>
References: <20191111214552.36717-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Convert to function declaration macros from function prototype casts to
avoid triggering Control-Flow Integrity checks during indirect function
calls.

Co-developed-by: João Moreira <joao.moreira@lsc.ic.unicamp.br>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/crypto/cast6_avx_glue.c | 62 ++++++++++++++------------------
 crypto/cast6_generic.c           |  6 ++--
 include/crypto/cast6.h           |  4 +--
 3 files changed, 32 insertions(+), 40 deletions(-)

diff --git a/arch/x86/crypto/cast6_avx_glue.c b/arch/x86/crypto/cast6_avx_glue.c
index a8a38fffb4a9..841724f335a5 100644
--- a/arch/x86/crypto/cast6_avx_glue.c
+++ b/arch/x86/crypto/cast6_avx_glue.c
@@ -20,20 +20,15 @@
 
 #define CAST6_PARALLEL_BLOCKS 8
 
-asmlinkage void cast6_ecb_enc_8way(struct cast6_ctx *ctx, u8 *dst,
-				   const u8 *src);
-asmlinkage void cast6_ecb_dec_8way(struct cast6_ctx *ctx, u8 *dst,
-				   const u8 *src);
-
-asmlinkage void cast6_cbc_dec_8way(struct cast6_ctx *ctx, u8 *dst,
-				   const u8 *src);
-asmlinkage void cast6_ctr_8way(struct cast6_ctx *ctx, u8 *dst, const u8 *src,
-			       le128 *iv);
-
-asmlinkage void cast6_xts_enc_8way(struct cast6_ctx *ctx, u8 *dst,
-				   const u8 *src, le128 *iv);
-asmlinkage void cast6_xts_dec_8way(struct cast6_ctx *ctx, u8 *dst,
-				   const u8 *src, le128 *iv);
+CRYPTO_FUNC(__cast6_encrypt);
+CRYPTO_FUNC(__cast6_decrypt);
+CRYPTO_FUNC(cast6_ecb_enc_8way);
+CRYPTO_FUNC(cast6_ecb_dec_8way);
+CRYPTO_FUNC_CBC(cast6_cbc_dec_8way);
+CRYPTO_FUNC_WRAP_CBC(__cast6_decrypt);
+CRYPTO_FUNC_CTR(cast6_ctr_8way);
+CRYPTO_FUNC_XTS(cast6_xts_enc_8way);
+CRYPTO_FUNC_XTS(cast6_xts_dec_8way);
 
 static int cast6_setkey_skcipher(struct crypto_skcipher *tfm,
 				 const u8 *key, unsigned int keylen)
@@ -43,14 +38,12 @@ static int cast6_setkey_skcipher(struct crypto_skcipher *tfm,
 
 static void cast6_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(__cast6_encrypt));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, __cast6_encrypt);
 }
 
 static void cast6_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(__cast6_decrypt));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, __cast6_decrypt);
 }
 
 static void cast6_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
@@ -70,10 +63,10 @@ static const struct common_glue_ctx cast6_enc = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(cast6_ecb_enc_8way) }
+		.fn_u = { .ecb = cast6_ecb_enc_8way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__cast6_encrypt) }
+		.fn_u = { .ecb = __cast6_encrypt }
 	} }
 };
 
@@ -83,10 +76,10 @@ static const struct common_glue_ctx cast6_ctr = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(cast6_ctr_8way) }
+		.fn_u = { .ctr = cast6_ctr_8way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(cast6_crypt_ctr) }
+		.fn_u = { .ctr = cast6_crypt_ctr }
 	} }
 };
 
@@ -96,10 +89,10 @@ static const struct common_glue_ctx cast6_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(cast6_xts_enc_8way) }
+		.fn_u = { .xts = cast6_xts_enc_8way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(cast6_xts_enc) }
+		.fn_u = { .xts = cast6_xts_enc }
 	} }
 };
 
@@ -109,10 +102,10 @@ static const struct common_glue_ctx cast6_dec = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(cast6_ecb_dec_8way) }
+		.fn_u = { .ecb = cast6_ecb_dec_8way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__cast6_decrypt) }
+		.fn_u = { .ecb = __cast6_decrypt }
 	} }
 };
 
@@ -122,10 +115,10 @@ static const struct common_glue_ctx cast6_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(cast6_cbc_dec_8way) }
+		.fn_u = { .cbc = cast6_cbc_dec_8way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(__cast6_decrypt) }
+		.fn_u = { .cbc = __cast6_decrypt_cbc }
 	} }
 };
 
@@ -135,10 +128,10 @@ static const struct common_glue_ctx cast6_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(cast6_xts_dec_8way) }
+		.fn_u = { .xts = cast6_xts_dec_8way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(cast6_xts_dec) }
+		.fn_u = { .xts = cast6_xts_dec }
 	} }
 };
 
@@ -154,8 +147,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(__cast6_encrypt),
-					   req);
+	return glue_cbc_encrypt_req_128bit(__cast6_encrypt, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -199,8 +191,7 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct cast6_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&cast6_enc_xts, req,
-				   XTS_TWEAK_CAST(__cast6_encrypt),
+	return glue_xts_req_128bit(&cast6_enc_xts, req, __cast6_encrypt,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
 }
 
@@ -209,8 +200,7 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct cast6_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&cast6_dec_xts, req,
-				   XTS_TWEAK_CAST(__cast6_encrypt),
+	return glue_xts_req_128bit(&cast6_dec_xts, req, __cast6_encrypt,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
 }
 
diff --git a/crypto/cast6_generic.c b/crypto/cast6_generic.c
index a8248f8e2777..c51121bedf68 100644
--- a/crypto/cast6_generic.c
+++ b/crypto/cast6_generic.c
@@ -173,8 +173,9 @@ static inline void QBAR(u32 *block, u8 *Kr, u32 *Km)
 	block[2] ^= F1(block[3], Kr[0], Km[0]);
 }
 
-void __cast6_encrypt(struct cast6_ctx *c, u8 *outbuf, const u8 *inbuf)
+void __cast6_encrypt(void *ctx, u8 *outbuf, const u8 *inbuf)
 {
+	struct cast6_ctx *c = ctx;
 	const __be32 *src = (const __be32 *)inbuf;
 	__be32 *dst = (__be32 *)outbuf;
 	u32 block[4];
@@ -211,8 +212,9 @@ static void cast6_encrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf)
 	__cast6_encrypt(crypto_tfm_ctx(tfm), outbuf, inbuf);
 }
 
-void __cast6_decrypt(struct cast6_ctx *c, u8 *outbuf, const u8 *inbuf)
+void __cast6_decrypt(void *ctx, u8 *outbuf, const u8 *inbuf)
 {
+	struct cast6_ctx *c = ctx;
 	const __be32 *src = (const __be32 *)inbuf;
 	__be32 *dst = (__be32 *)outbuf;
 	u32 block[4];
diff --git a/include/crypto/cast6.h b/include/crypto/cast6.h
index c71f6ef47f0f..b6c3a0324959 100644
--- a/include/crypto/cast6.h
+++ b/include/crypto/cast6.h
@@ -19,7 +19,7 @@ int __cast6_setkey(struct cast6_ctx *ctx, const u8 *key,
 		   unsigned int keylen, u32 *flags);
 int cast6_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen);
 
-void __cast6_encrypt(struct cast6_ctx *ctx, u8 *dst, const u8 *src);
-void __cast6_decrypt(struct cast6_ctx *ctx, u8 *dst, const u8 *src);
+void __cast6_encrypt(void *ctx, u8 *dst, const u8 *src);
+void __cast6_decrypt(void *ctx, u8 *dst, const u8 *src);
 
 #endif
-- 
2.17.1

