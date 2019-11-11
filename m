Return-Path: <SRS0=ywwc=ZD=lists.openwall.com=kernel-hardening-return-17331-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0990EC1744A
	for <kernel-hardening@archiver.kernel.org>; Mon, 11 Nov 2019 21:46:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F0DBD206BB
	for <kernel-hardening@archiver.kernel.org>; Mon, 11 Nov 2019 21:46:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="MlTOhUGT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0DBD206BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17331-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32333 invoked by uid 550); 11 Nov 2019 21:46:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32224 invoked from network); 11 Nov 2019 21:46:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sfboeiv8JCMcl19Ljf0Wt+ugr3E2aYX7s1amn1fzaaE=;
        b=MlTOhUGTFlgsrhhYqETf6FZGdkc5oXfA8Mj9m1exKYyLki21rA3H7KDGQm233hLdhL
         3e4D2W8dguoD7Q7TjUB0z3Fk0WILwScL4m9/bgRBJWbzbLZhC2ERgOqee8atcwCvtb4a
         3cznvifmOJq801TfwhTYGvbxC2qg69IovL5D0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sfboeiv8JCMcl19Ljf0Wt+ugr3E2aYX7s1amn1fzaaE=;
        b=OvoPnqGcr9nHnQQSjAH1n5OIg/yyzblelJqR4s7h4TZfuxCNobE8DIkFX95DtI5Ov4
         9UqqzxJrMnFbcQEDKwNRs+LqCQ+C2D311cqzR30mQ7N7M405rbbfhuXvrOUw1R04/EUn
         EmsmkQ5sEzaaPG13ggbVAx8a+m5iKcZdgKDIfGwqYErwhqZJfKdouNMPRglOov0aW0qO
         0+a4OW9pJ1D8o1S7UjHsYZt0SpOlwzrFHKGQgbp/kMikOb2MMeLiaQn2hFWP7Q52bE0N
         Qio0z/GHBWlJVFDplfUNXs+kbrJV3JR7/1S3pNbDB2eICFBIaZgtTIrt/gEIHq9ezRvH
         G1aQ==
X-Gm-Message-State: APjAAAXuWhID9ol5mBcP7laQq9I/V+PiKlzZ7IC8+sgrpKuIQO5BdFUI
	GoR6SdQjk2VXgvoxfmHeuOLg1A==
X-Google-Smtp-Source: APXvYqzhVjwNIm1LXIRz2ia3dBQycGEDMEkzBpGVfgemI5r8JyPgBG0iVT0lXPDz9slD4wR/cwhPgQ==
X-Received: by 2002:a63:2ac9:: with SMTP id q192mr31375298pgq.351.1573508762533;
        Mon, 11 Nov 2019 13:46:02 -0800 (PST)
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
Subject: [PATCH v4 2/8] crypto: x86/serpent: Use new glue function macros
Date: Mon, 11 Nov 2019 13:45:46 -0800
Message-Id: <20191111214552.36717-3-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191111214552.36717-1-keescook@chromium.org>
References: <20191111214552.36717-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Convert to function declaration macros from function prototype casts
to avoid triggering Control-Flow Integrity checks during indirect function
calls.

Co-developed-by: João Moreira <joao.moreira@lsc.ic.unicamp.br>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/crypto/serpent_avx2_glue.c        | 65 ++++++++++------------
 arch/x86/crypto/serpent_avx_glue.c         | 58 +++++++------------
 arch/x86/crypto/serpent_sse2_glue.c        | 24 +++++---
 arch/x86/include/asm/crypto/serpent-avx.h  | 23 +++-----
 arch/x86/include/asm/crypto/serpent-sse2.h |  6 +-
 crypto/serpent_generic.c                   |  6 +-
 include/crypto/serpent.h                   |  4 +-
 7 files changed, 80 insertions(+), 106 deletions(-)

diff --git a/arch/x86/crypto/serpent_avx2_glue.c b/arch/x86/crypto/serpent_avx2_glue.c
index 13fd8d3d2da0..b27139cf93c2 100644
--- a/arch/x86/crypto/serpent_avx2_glue.c
+++ b/arch/x86/crypto/serpent_avx2_glue.c
@@ -19,18 +19,12 @@
 #define SERPENT_AVX2_PARALLEL_BLOCKS 16
 
 /* 16-way AVX2 parallel cipher functions */
-asmlinkage void serpent_ecb_enc_16way(struct serpent_ctx *ctx, u8 *dst,
-				      const u8 *src);
-asmlinkage void serpent_ecb_dec_16way(struct serpent_ctx *ctx, u8 *dst,
-				      const u8 *src);
-asmlinkage void serpent_cbc_dec_16way(void *ctx, u128 *dst, const u128 *src);
-
-asmlinkage void serpent_ctr_16way(void *ctx, u128 *dst, const u128 *src,
-				  le128 *iv);
-asmlinkage void serpent_xts_enc_16way(struct serpent_ctx *ctx, u8 *dst,
-				      const u8 *src, le128 *iv);
-asmlinkage void serpent_xts_dec_16way(struct serpent_ctx *ctx, u8 *dst,
-				      const u8 *src, le128 *iv);
+CRYPTO_FUNC(serpent_ecb_enc_16way);
+CRYPTO_FUNC(serpent_ecb_dec_16way);
+CRYPTO_FUNC_CBC(serpent_cbc_dec_16way);
+CRYPTO_FUNC_CTR(serpent_ctr_16way);
+CRYPTO_FUNC_XTS(serpent_xts_enc_16way);
+CRYPTO_FUNC_XTS(serpent_xts_dec_16way);
 
 static int serpent_setkey_skcipher(struct crypto_skcipher *tfm,
 				   const u8 *key, unsigned int keylen)
@@ -44,13 +38,13 @@ static const struct common_glue_ctx serpent_enc = {
 
 	.funcs = { {
 		.num_blocks = 16,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_enc_16way) }
+		.fn_u = { .ecb = serpent_ecb_enc_16way }
 	}, {
 		.num_blocks = 8,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_enc_8way_avx) }
+		.fn_u = { .ecb = serpent_ecb_enc_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_encrypt) }
+		.fn_u = { .ecb = __serpent_encrypt }
 	} }
 };
 
@@ -60,13 +54,13 @@ static const struct common_glue_ctx serpent_ctr = {
 
 	.funcs = { {
 		.num_blocks = 16,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(serpent_ctr_16way) }
+		.fn_u = { .ctr = serpent_ctr_16way }
 	},  {
 		.num_blocks = 8,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(serpent_ctr_8way_avx) }
+		.fn_u = { .ctr = serpent_ctr_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(__serpent_crypt_ctr) }
+		.fn_u = { .ctr = __serpent_crypt_ctr }
 	} }
 };
 
@@ -76,13 +70,13 @@ static const struct common_glue_ctx serpent_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = 16,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_enc_16way) }
+		.fn_u = { .xts = serpent_xts_enc_16way }
 	}, {
 		.num_blocks = 8,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_enc_8way_avx) }
+		.fn_u = { .xts = serpent_xts_enc_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_enc) }
+		.fn_u = { .xts = serpent_xts_enc }
 	} }
 };
 
@@ -92,13 +86,13 @@ static const struct common_glue_ctx serpent_dec = {
 
 	.funcs = { {
 		.num_blocks = 16,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_dec_16way) }
+		.fn_u = { .ecb = serpent_ecb_dec_16way }
 	}, {
 		.num_blocks = 8,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_dec_8way_avx) }
+		.fn_u = { .ecb = serpent_ecb_dec_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_decrypt) }
+		.fn_u = { .ecb = __serpent_decrypt }
 	} }
 };
 
@@ -108,13 +102,13 @@ static const struct common_glue_ctx serpent_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = 16,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(serpent_cbc_dec_16way) }
+		.fn_u = { .cbc = serpent_cbc_dec_16way }
 	}, {
 		.num_blocks = 8,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(serpent_cbc_dec_8way_avx) }
+		.fn_u = { .cbc = serpent_cbc_dec_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(__serpent_decrypt) }
+		.fn_u = { .cbc = __serpent_decrypt_cbc }
 	} }
 };
 
@@ -124,13 +118,13 @@ static const struct common_glue_ctx serpent_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = 16,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_dec_16way) }
+		.fn_u = { .xts = serpent_xts_dec_16way }
 	}, {
 		.num_blocks = 8,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_dec_8way_avx) }
+		.fn_u = { .xts = serpent_xts_dec_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_dec) }
+		.fn_u = { .xts = serpent_xts_dec }
 	} }
 };
 
@@ -146,8 +140,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(__serpent_encrypt),
-					   req);
+	return glue_cbc_encrypt_req_128bit(__serpent_encrypt, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -166,8 +159,8 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct serpent_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&serpent_enc_xts, req,
-				   XTS_TWEAK_CAST(__serpent_encrypt),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
+				   __serpent_encrypt, &ctx->tweak_ctx,
+				   &ctx->crypt_ctx, false);
 }
 
 static int xts_decrypt(struct skcipher_request *req)
@@ -176,8 +169,8 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct serpent_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&serpent_dec_xts, req,
-				   XTS_TWEAK_CAST(__serpent_encrypt),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
+				   __serpent_encrypt, &ctx->tweak_ctx,
+				   &ctx->crypt_ctx, true);
 }
 
 static struct skcipher_alg serpent_algs[] = {
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index 7d3dca38a5a2..4a0a26195952 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -20,28 +20,11 @@
 #include <asm/crypto/serpent-avx.h>
 
 /* 8-way parallel cipher functions */
-asmlinkage void serpent_ecb_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
-					 const u8 *src);
 EXPORT_SYMBOL_GPL(serpent_ecb_enc_8way_avx);
-
-asmlinkage void serpent_ecb_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
-					 const u8 *src);
 EXPORT_SYMBOL_GPL(serpent_ecb_dec_8way_avx);
-
-asmlinkage void serpent_cbc_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
-					 const u8 *src);
 EXPORT_SYMBOL_GPL(serpent_cbc_dec_8way_avx);
-
-asmlinkage void serpent_ctr_8way_avx(struct serpent_ctx *ctx, u8 *dst,
-				     const u8 *src, le128 *iv);
 EXPORT_SYMBOL_GPL(serpent_ctr_8way_avx);
-
-asmlinkage void serpent_xts_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
-					 const u8 *src, le128 *iv);
 EXPORT_SYMBOL_GPL(serpent_xts_enc_8way_avx);
-
-asmlinkage void serpent_xts_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
-					 const u8 *src, le128 *iv);
 EXPORT_SYMBOL_GPL(serpent_xts_dec_8way_avx);
 
 void __serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
@@ -58,15 +41,13 @@ EXPORT_SYMBOL_GPL(__serpent_crypt_ctr);
 
 void serpent_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(__serpent_encrypt));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, __serpent_encrypt);
 }
 EXPORT_SYMBOL_GPL(serpent_xts_enc);
 
 void serpent_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(__serpent_decrypt));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, __serpent_decrypt);
 }
 EXPORT_SYMBOL_GPL(serpent_xts_dec);
 
@@ -102,10 +83,10 @@ static const struct common_glue_ctx serpent_enc = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_enc_8way_avx) }
+		.fn_u = { .ecb = serpent_ecb_enc_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_encrypt) }
+		.fn_u = { .ecb = __serpent_encrypt }
 	} }
 };
 
@@ -115,10 +96,10 @@ static const struct common_glue_ctx serpent_ctr = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(serpent_ctr_8way_avx) }
+		.fn_u = { .ctr = serpent_ctr_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(__serpent_crypt_ctr) }
+		.fn_u = { .ctr = __serpent_crypt_ctr }
 	} }
 };
 
@@ -128,10 +109,10 @@ static const struct common_glue_ctx serpent_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_enc_8way_avx) }
+		.fn_u = { .xts = serpent_xts_enc_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_enc) }
+		.fn_u = { .xts = serpent_xts_enc }
 	} }
 };
 
@@ -141,10 +122,10 @@ static const struct common_glue_ctx serpent_dec = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_dec_8way_avx) }
+		.fn_u = { .ecb = serpent_ecb_dec_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_decrypt) }
+		.fn_u = { .ecb = __serpent_decrypt }
 	} }
 };
 
@@ -154,10 +135,10 @@ static const struct common_glue_ctx serpent_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(serpent_cbc_dec_8way_avx) }
+		.fn_u = { .cbc = serpent_cbc_dec_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(__serpent_decrypt) }
+		.fn_u = { .cbc = __serpent_decrypt_cbc }
 	} }
 };
 
@@ -167,10 +148,10 @@ static const struct common_glue_ctx serpent_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_dec_8way_avx) }
+		.fn_u = { .xts = serpent_xts_dec_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_dec) }
+		.fn_u = { .xts = serpent_xts_dec }
 	} }
 };
 
@@ -186,8 +167,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(__serpent_encrypt),
-					   req);
+	return glue_cbc_encrypt_req_128bit(__serpent_encrypt, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -206,8 +186,8 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct serpent_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&serpent_enc_xts, req,
-				   XTS_TWEAK_CAST(__serpent_encrypt),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
+			__serpent_encrypt, &ctx->tweak_ctx,
+			&ctx->crypt_ctx, false);
 }
 
 static int xts_decrypt(struct skcipher_request *req)
@@ -216,8 +196,8 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct serpent_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&serpent_dec_xts, req,
-				   XTS_TWEAK_CAST(__serpent_encrypt),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
+			__serpent_encrypt, &ctx->tweak_ctx,
+			&ctx->crypt_ctx, true);
 }
 
 static struct skcipher_alg serpent_algs[] = {
diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index 5fdf1931d069..1d4ba7359e8e 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -25,6 +25,12 @@
 #include <asm/crypto/serpent-sse2.h>
 #include <asm/crypto/glue_helper.h>
 
+CRYPTO_FUNC(__serpent_encrypt);
+CRYPTO_FUNC(__serpent_decrypt);
+CRYPTO_FUNC_WRAP_CBC(__serpent_decrypt);
+CRYPTO_FUNC(serpent_enc_blk_xway);
+CRYPTO_FUNC(serpent_dec_blk_xway);
+
 static int serpent_setkey_skcipher(struct crypto_skcipher *tfm,
 				   const u8 *key, unsigned int keylen)
 {
@@ -79,10 +85,10 @@ static const struct common_glue_ctx serpent_enc = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_enc_blk_xway) }
+		.fn_u = { .ecb = serpent_enc_blk_xway }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_encrypt) }
+		.fn_u = { .ecb = __serpent_encrypt }
 	} }
 };
 
@@ -92,10 +98,10 @@ static const struct common_glue_ctx serpent_ctr = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(serpent_crypt_ctr_xway) }
+		.fn_u = { .ctr = serpent_crypt_ctr_xway }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(serpent_crypt_ctr) }
+		.fn_u = { .ctr = serpent_crypt_ctr }
 	} }
 };
 
@@ -105,10 +111,10 @@ static const struct common_glue_ctx serpent_dec = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_dec_blk_xway) }
+		.fn_u = { .ecb = serpent_dec_blk_xway }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_decrypt) }
+		.fn_u = { .ecb = __serpent_decrypt }
 	} }
 };
 
@@ -118,10 +124,10 @@ static const struct common_glue_ctx serpent_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(serpent_decrypt_cbc_xway) }
+		.fn_u = { .cbc = serpent_decrypt_cbc_xway }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(__serpent_decrypt) }
+		.fn_u = { .cbc = __serpent_decrypt_cbc }
 	} }
 };
 
@@ -137,7 +143,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(__serpent_encrypt),
+	return glue_cbc_encrypt_req_128bit(__serpent_encrypt,
 					   req);
 }
 
diff --git a/arch/x86/include/asm/crypto/serpent-avx.h b/arch/x86/include/asm/crypto/serpent-avx.h
index db7c9cc32234..7dd8ab476295 100644
--- a/arch/x86/include/asm/crypto/serpent-avx.h
+++ b/arch/x86/include/asm/crypto/serpent-avx.h
@@ -15,20 +15,15 @@ struct serpent_xts_ctx {
 	struct serpent_ctx crypt_ctx;
 };
 
-asmlinkage void serpent_ecb_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
-					 const u8 *src);
-asmlinkage void serpent_ecb_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
-					 const u8 *src);
-
-asmlinkage void serpent_cbc_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
-					 const u8 *src);
-asmlinkage void serpent_ctr_8way_avx(struct serpent_ctx *ctx, u8 *dst,
-				     const u8 *src, le128 *iv);
-
-asmlinkage void serpent_xts_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
-					 const u8 *src, le128 *iv);
-asmlinkage void serpent_xts_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
-					 const u8 *src, le128 *iv);
+CRYPTO_FUNC(__serpent_encrypt);
+CRYPTO_FUNC(__serpent_decrypt);
+CRYPTO_FUNC_WRAP_CBC(__serpent_decrypt);
+CRYPTO_FUNC(serpent_ecb_enc_8way_avx);
+CRYPTO_FUNC(serpent_ecb_dec_8way_avx);
+CRYPTO_FUNC_CBC(serpent_cbc_dec_8way_avx);
+CRYPTO_FUNC_CTR(serpent_ctr_8way_avx);
+CRYPTO_FUNC_XTS(serpent_xts_enc_8way_avx);
+CRYPTO_FUNC_XTS(serpent_xts_dec_8way_avx);
 
 extern void __serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src,
 				le128 *iv);
diff --git a/arch/x86/include/asm/crypto/serpent-sse2.h b/arch/x86/include/asm/crypto/serpent-sse2.h
index 1a345e8a7496..491a5a7d4e15 100644
--- a/arch/x86/include/asm/crypto/serpent-sse2.h
+++ b/arch/x86/include/asm/crypto/serpent-sse2.h
@@ -41,8 +41,7 @@ asmlinkage void __serpent_enc_blk_8way(struct serpent_ctx *ctx, u8 *dst,
 asmlinkage void serpent_dec_blk_8way(struct serpent_ctx *ctx, u8 *dst,
 				     const u8 *src);
 
-static inline void serpent_enc_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-				   const u8 *src)
+static inline void serpent_enc_blk_xway(void *ctx, u8 *dst, const u8 *src)
 {
 	__serpent_enc_blk_8way(ctx, dst, src, false);
 }
@@ -53,8 +52,7 @@ static inline void serpent_enc_blk_xway_xor(struct serpent_ctx *ctx, u8 *dst,
 	__serpent_enc_blk_8way(ctx, dst, src, true);
 }
 
-static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-				   const u8 *src)
+static inline void serpent_dec_blk_xway(void *ctx, u8 *dst, const u8 *src)
 {
 	serpent_dec_blk_8way(ctx, dst, src);
 }
diff --git a/crypto/serpent_generic.c b/crypto/serpent_generic.c
index 56fa665a4f01..6309fdc77466 100644
--- a/crypto/serpent_generic.c
+++ b/crypto/serpent_generic.c
@@ -449,8 +449,9 @@ int serpent_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
 }
 EXPORT_SYMBOL_GPL(serpent_setkey);
 
-void __serpent_encrypt(struct serpent_ctx *ctx, u8 *dst, const u8 *src)
+void __serpent_encrypt(void *c, u8 *dst, const u8 *src)
 {
+	struct serpent_ctx *ctx = c;
 	const u32 *k = ctx->expkey;
 	const __le32 *s = (const __le32 *)src;
 	__le32	*d = (__le32 *)dst;
@@ -514,8 +515,9 @@ static void serpent_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	__serpent_encrypt(ctx, dst, src);
 }
 
-void __serpent_decrypt(struct serpent_ctx *ctx, u8 *dst, const u8 *src)
+void __serpent_decrypt(void *c, u8 *dst, const u8 *src)
 {
+	struct serpent_ctx *ctx = c;
 	const u32 *k = ctx->expkey;
 	const __le32 *s = (const __le32 *)src;
 	__le32	*d = (__le32 *)dst;
diff --git a/include/crypto/serpent.h b/include/crypto/serpent.h
index 7dd780c5d058..986659db5939 100644
--- a/include/crypto/serpent.h
+++ b/include/crypto/serpent.h
@@ -22,7 +22,7 @@ int __serpent_setkey(struct serpent_ctx *ctx, const u8 *key,
 		     unsigned int keylen);
 int serpent_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen);
 
-void __serpent_encrypt(struct serpent_ctx *ctx, u8 *dst, const u8 *src);
-void __serpent_decrypt(struct serpent_ctx *ctx, u8 *dst, const u8 *src);
+void __serpent_encrypt(void *ctx, u8 *dst, const u8 *src);
+void __serpent_decrypt(void *ctx, u8 *dst, const u8 *src);
 
 #endif
-- 
2.17.1

