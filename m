Return-Path: <SRS0=rVCJ=ZO=lists.openwall.com=kernel-hardening-return-17422-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21CA6C43215
	for <kernel-hardening@archiver.kernel.org>; Fri, 22 Nov 2019 01:04:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A863F20674
	for <kernel-hardening@archiver.kernel.org>; Fri, 22 Nov 2019 01:04:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="nicNbVp6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A863F20674
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17422-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19576 invoked by uid 550); 22 Nov 2019 01:03:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18353 invoked from network); 22 Nov 2019 01:03:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kdYC0pBu/EAPqdjWM3ua8RUDru/SEmXyg/S4R+FESwM=;
        b=nicNbVp62wAtdYARJt++xYlup8n5EhnPi39LYb8wMo3l2gPaYTCRhoIMIsO3vnM/mx
         3f5/fPE3Se032ravZJ9AcBoU9x/QESjozIxY8sW8vzQ8petWr8It4JYfpBB9ZWfrEoTf
         zEpLE9xftJO+0PzMaQ3WCytzlEBDoQ0ANr6mk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kdYC0pBu/EAPqdjWM3ua8RUDru/SEmXyg/S4R+FESwM=;
        b=qtdimGe/u6T8vxzs1p9rKrgnsMNOgIV1EoCvixcJh7TRYil1NgG9FWyig5sM197NUa
         UTpXibZu3qhgGjmADKtroKrJ8t95COb3AmQjmgRCTZCY6iAyqXezfcoJ3pf4xkJ7k+kf
         PdsOuD42MJr2Mho4tm3ggCFCTfVXWPlReaUO+cZ2eK9Non6MqiCghw8/q0wXdzfTUyao
         k2mk0mnhAXWrXGYXStTFBz6UJNSQp++1ACpo7Ex5HK3mP4e/6/ocRPRy+a35zttGVZ8K
         D2LNIylIih7IxIDYWksy+5Tx2PrGxsJCiGfNPAy57595VMD6gGbUX4cwfAlybng4SgW7
         hsGw==
X-Gm-Message-State: APjAAAW/sNB1/xIF7IVLWfRhD1wImKLDTXNC1MBhsCFOOt8ongMrqEcT
	wJoJf5BB05wkesa9TZGHZPRhfw==
X-Google-Smtp-Source: APXvYqzRFo5rwpGeKqSpqoGlGVb2LHplZ+rjO5pY+6ou5TwPTpDAQ+1+3HxYcIPCtKPXAsyoRZwKdQ==
X-Received: by 2002:a17:90a:c004:: with SMTP id p4mr15478535pjt.104.1574384620604;
        Thu, 21 Nov 2019 17:03:40 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <keescook@chromium.org>,
	=?UTF-8?q?Jo=C3=A3o=20Moreira?= <joao.moreira@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Stephan Mueller <smueller@chronox.de>,
	x86@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v6 2/8] crypto: x86/serpent: Remove glue function macros usage
Date: Thu, 21 Nov 2019 17:03:28 -0800
Message-Id: <20191122010334.12081-3-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191122010334.12081-1-keescook@chromium.org>
References: <20191122010334.12081-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In order to remove the callsite function casts, regularize the function
prototypes for helpers to avoid triggering Control-Flow Integrity checks
during indirect function calls. Where needed, to avoid changes to
pointer math, u8 pointers are internally cast back to u128 pointers.

Co-developed-by: João Moreira <joao.moreira@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/crypto/serpent_avx2_glue.c        | 65 +++++++++++-----------
 arch/x86/crypto/serpent_avx_glue.c         | 63 +++++++++++----------
 arch/x86/crypto/serpent_sse2_glue.c        | 30 ++++++----
 arch/x86/include/asm/crypto/serpent-avx.h  | 20 +++----
 arch/x86/include/asm/crypto/serpent-sse2.h | 28 ++++------
 crypto/serpent_generic.c                   |  6 +-
 include/crypto/serpent.h                   |  4 +-
 7 files changed, 108 insertions(+), 108 deletions(-)

diff --git a/arch/x86/crypto/serpent_avx2_glue.c b/arch/x86/crypto/serpent_avx2_glue.c
index 13fd8d3d2da0..f973ace44ad3 100644
--- a/arch/x86/crypto/serpent_avx2_glue.c
+++ b/arch/x86/crypto/serpent_avx2_glue.c
@@ -19,18 +19,16 @@
 #define SERPENT_AVX2_PARALLEL_BLOCKS 16
 
 /* 16-way AVX2 parallel cipher functions */
-asmlinkage void serpent_ecb_enc_16way(struct serpent_ctx *ctx, u8 *dst,
-				      const u8 *src);
-asmlinkage void serpent_ecb_dec_16way(struct serpent_ctx *ctx, u8 *dst,
-				      const u8 *src);
-asmlinkage void serpent_cbc_dec_16way(void *ctx, u128 *dst, const u128 *src);
+asmlinkage void serpent_ecb_enc_16way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void serpent_ecb_dec_16way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void serpent_cbc_dec_16way(const void *ctx, u8 *dst, const u8 *src);
 
-asmlinkage void serpent_ctr_16way(void *ctx, u128 *dst, const u128 *src,
+asmlinkage void serpent_ctr_16way(const void *ctx, u8 *dst, const u8 *src,
 				  le128 *iv);
-asmlinkage void serpent_xts_enc_16way(struct serpent_ctx *ctx, u8 *dst,
-				      const u8 *src, le128 *iv);
-asmlinkage void serpent_xts_dec_16way(struct serpent_ctx *ctx, u8 *dst,
-				      const u8 *src, le128 *iv);
+asmlinkage void serpent_xts_enc_16way(const void *ctx, u8 *dst, const u8 *src,
+				      le128 *iv);
+asmlinkage void serpent_xts_dec_16way(const void *ctx, u8 *dst, const u8 *src,
+				      le128 *iv);
 
 static int serpent_setkey_skcipher(struct crypto_skcipher *tfm,
 				   const u8 *key, unsigned int keylen)
@@ -44,13 +42,13 @@ static const struct common_glue_ctx serpent_enc = {
 
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
 
@@ -60,13 +58,13 @@ static const struct common_glue_ctx serpent_ctr = {
 
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
 
@@ -76,13 +74,13 @@ static const struct common_glue_ctx serpent_enc_xts = {
 
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
 
@@ -92,13 +90,13 @@ static const struct common_glue_ctx serpent_dec = {
 
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
 
@@ -108,13 +106,13 @@ static const struct common_glue_ctx serpent_dec_cbc = {
 
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
+		.fn_u = { .cbc = __serpent_decrypt }
 	} }
 };
 
@@ -124,13 +122,13 @@ static const struct common_glue_ctx serpent_dec_xts = {
 
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
 
@@ -146,8 +144,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(__serpent_encrypt),
-					   req);
+	return glue_cbc_encrypt_req_128bit(__serpent_encrypt, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -166,8 +163,8 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct serpent_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&serpent_enc_xts, req,
-				   XTS_TWEAK_CAST(__serpent_encrypt),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
+				   __serpent_encrypt, &ctx->tweak_ctx,
+				   &ctx->crypt_ctx, false);
 }
 
 static int xts_decrypt(struct skcipher_request *req)
@@ -176,8 +173,8 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct serpent_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&serpent_dec_xts, req,
-				   XTS_TWEAK_CAST(__serpent_encrypt),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
+				   __serpent_encrypt, &ctx->tweak_ctx,
+				   &ctx->crypt_ctx, true);
 }
 
 static struct skcipher_alg serpent_algs[] = {
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index 7d3dca38a5a2..7806d1cbe854 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -20,33 +20,35 @@
 #include <asm/crypto/serpent-avx.h>
 
 /* 8-way parallel cipher functions */
-asmlinkage void serpent_ecb_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_ecb_enc_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src);
 EXPORT_SYMBOL_GPL(serpent_ecb_enc_8way_avx);
 
-asmlinkage void serpent_ecb_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_ecb_dec_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src);
 EXPORT_SYMBOL_GPL(serpent_ecb_dec_8way_avx);
 
-asmlinkage void serpent_cbc_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_cbc_dec_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src);
 EXPORT_SYMBOL_GPL(serpent_cbc_dec_8way_avx);
 
-asmlinkage void serpent_ctr_8way_avx(struct serpent_ctx *ctx, u8 *dst,
-				     const u8 *src, le128 *iv);
+asmlinkage void serpent_ctr_8way_avx(const void *ctx, u8 *dst, const u8 *src,
+				     le128 *iv);
 EXPORT_SYMBOL_GPL(serpent_ctr_8way_avx);
 
-asmlinkage void serpent_xts_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_xts_enc_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src, le128 *iv);
 EXPORT_SYMBOL_GPL(serpent_xts_enc_8way_avx);
 
-asmlinkage void serpent_xts_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_xts_dec_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src, le128 *iv);
 EXPORT_SYMBOL_GPL(serpent_xts_dec_8way_avx);
 
-void __serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+void __serpent_crypt_ctr(const void *ctx, u8 *d, const u8 *s, le128 *iv)
 {
 	be128 ctrblk;
+	u128 *dst = (u128 *)d;
+	const u128 *src = (const u128 *)s;
 
 	le128_to_be128(&ctrblk, iv);
 	le128_inc(iv);
@@ -56,17 +58,15 @@ void __serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 }
 EXPORT_SYMBOL_GPL(__serpent_crypt_ctr);
 
-void serpent_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+void serpent_xts_enc(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(__serpent_encrypt));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, __serpent_encrypt);
 }
 EXPORT_SYMBOL_GPL(serpent_xts_enc);
 
-void serpent_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+void serpent_xts_dec(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(__serpent_decrypt));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, __serpent_decrypt);
 }
 EXPORT_SYMBOL_GPL(serpent_xts_dec);
 
@@ -102,10 +102,10 @@ static const struct common_glue_ctx serpent_enc = {
 
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
 
@@ -115,10 +115,10 @@ static const struct common_glue_ctx serpent_ctr = {
 
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
 
@@ -128,10 +128,10 @@ static const struct common_glue_ctx serpent_enc_xts = {
 
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
 
@@ -141,10 +141,10 @@ static const struct common_glue_ctx serpent_dec = {
 
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
 
@@ -154,10 +154,10 @@ static const struct common_glue_ctx serpent_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(serpent_cbc_dec_8way_avx) }
+		.fn_u = { .cbc = serpent_cbc_dec_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(__serpent_decrypt) }
+		.fn_u = { .cbc = __serpent_decrypt }
 	} }
 };
 
@@ -167,10 +167,10 @@ static const struct common_glue_ctx serpent_dec_xts = {
 
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
 
@@ -186,8 +186,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(__serpent_encrypt),
-					   req);
+	return glue_cbc_encrypt_req_128bit(__serpent_encrypt, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -206,8 +205,8 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct serpent_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&serpent_enc_xts, req,
-				   XTS_TWEAK_CAST(__serpent_encrypt),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
+				   __serpent_encrypt, &ctx->tweak_ctx,
+				   &ctx->crypt_ctx, false);
 }
 
 static int xts_decrypt(struct skcipher_request *req)
@@ -216,8 +215,8 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct serpent_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&serpent_dec_xts, req,
-				   XTS_TWEAK_CAST(__serpent_encrypt),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
+				   __serpent_encrypt, &ctx->tweak_ctx,
+				   &ctx->crypt_ctx, true);
 }
 
 static struct skcipher_alg serpent_algs[] = {
diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index 5fdf1931d069..4fed8d26b91a 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -31,9 +31,11 @@ static int serpent_setkey_skcipher(struct crypto_skcipher *tfm,
 	return __serpent_setkey(crypto_skcipher_ctx(tfm), key, keylen);
 }
 
-static void serpent_decrypt_cbc_xway(void *ctx, u128 *dst, const u128 *src)
+static void serpent_decrypt_cbc_xway(const void *ctx, u8 *d, const u8 *s)
 {
 	u128 ivs[SERPENT_PARALLEL_BLOCKS - 1];
+	u128 *dst = (u128 *)d;
+	const u128 *src = (const u128 *)s;
 	unsigned int j;
 
 	for (j = 0; j < SERPENT_PARALLEL_BLOCKS - 1; j++)
@@ -45,9 +47,11 @@ static void serpent_decrypt_cbc_xway(void *ctx, u128 *dst, const u128 *src)
 		u128_xor(dst + (j + 1), dst + (j + 1), ivs + j);
 }
 
-static void serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+static void serpent_crypt_ctr(const void *ctx, u8 *d, const u8 *s, le128 *iv)
 {
 	be128 ctrblk;
+	u128 *dst = (u128 *)d;
+	const u128 *src = (const u128 *)s;
 
 	le128_to_be128(&ctrblk, iv);
 	le128_inc(iv);
@@ -56,10 +60,12 @@ static void serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 	u128_xor(dst, src, (u128 *)&ctrblk);
 }
 
-static void serpent_crypt_ctr_xway(void *ctx, u128 *dst, const u128 *src,
+static void serpent_crypt_ctr_xway(const void *ctx, u8 *d, const u8 *s,
 				   le128 *iv)
 {
 	be128 ctrblks[SERPENT_PARALLEL_BLOCKS];
+	u128 *dst = (u128 *)d;
+	const u128 *src = (const u128 *)s;
 	unsigned int i;
 
 	for (i = 0; i < SERPENT_PARALLEL_BLOCKS; i++) {
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
+		.fn_u = { .cbc = __serpent_decrypt }
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
index db7c9cc32234..251c2c89d7cf 100644
--- a/arch/x86/include/asm/crypto/serpent-avx.h
+++ b/arch/x86/include/asm/crypto/serpent-avx.h
@@ -15,26 +15,26 @@ struct serpent_xts_ctx {
 	struct serpent_ctx crypt_ctx;
 };
 
-asmlinkage void serpent_ecb_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_ecb_enc_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src);
-asmlinkage void serpent_ecb_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_ecb_dec_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src);
 
-asmlinkage void serpent_cbc_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_cbc_dec_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src);
-asmlinkage void serpent_ctr_8way_avx(struct serpent_ctx *ctx, u8 *dst,
-				     const u8 *src, le128 *iv);
+asmlinkage void serpent_ctr_8way_avx(const void *ctx, u8 *dst, const u8 *src,
+				     le128 *iv);
 
-asmlinkage void serpent_xts_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_xts_enc_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src, le128 *iv);
-asmlinkage void serpent_xts_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_xts_dec_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src, le128 *iv);
 
-extern void __serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src,
+extern void __serpent_crypt_ctr(const void *ctx, u8 *dst, const u8 *src,
 				le128 *iv);
 
-extern void serpent_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv);
-extern void serpent_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv);
+extern void serpent_xts_enc(const void *ctx, u8 *dst, const u8 *src, le128 *iv);
+extern void serpent_xts_dec(const void *ctx, u8 *dst, const u8 *src, le128 *iv);
 
 extern int xts_serpent_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			      unsigned int keylen);
diff --git a/arch/x86/include/asm/crypto/serpent-sse2.h b/arch/x86/include/asm/crypto/serpent-sse2.h
index 1a345e8a7496..860ca248914b 100644
--- a/arch/x86/include/asm/crypto/serpent-sse2.h
+++ b/arch/x86/include/asm/crypto/serpent-sse2.h
@@ -9,25 +9,23 @@
 
 #define SERPENT_PARALLEL_BLOCKS 4
 
-asmlinkage void __serpent_enc_blk_4way(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void __serpent_enc_blk_4way(const struct serpent_ctx *ctx, u8 *dst,
 				       const u8 *src, bool xor);
-asmlinkage void serpent_dec_blk_4way(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_dec_blk_4way(const struct serpent_ctx *ctx, u8 *dst,
 				     const u8 *src);
 
-static inline void serpent_enc_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-					const u8 *src)
+static inline void serpent_enc_blk_xway(const void *ctx, u8 *dst, const u8 *src)
 {
 	__serpent_enc_blk_4way(ctx, dst, src, false);
 }
 
-static inline void serpent_enc_blk_xway_xor(struct serpent_ctx *ctx, u8 *dst,
-					    const u8 *src)
+static inline void serpent_enc_blk_xway_xor(const struct serpent_ctx *ctx,
+					    u8 *dst, const u8 *src)
 {
 	__serpent_enc_blk_4way(ctx, dst, src, true);
 }
 
-static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-					const u8 *src)
+static inline void serpent_dec_blk_xway(const void *ctx, u8 *dst, const u8 *src)
 {
 	serpent_dec_blk_4way(ctx, dst, src);
 }
@@ -36,25 +34,23 @@ static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
 
 #define SERPENT_PARALLEL_BLOCKS 8
 
-asmlinkage void __serpent_enc_blk_8way(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void __serpent_enc_blk_8way(const struct serpent_ctx *ctx, u8 *dst,
 				       const u8 *src, bool xor);
-asmlinkage void serpent_dec_blk_8way(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_dec_blk_8way(const struct serpent_ctx *ctx, u8 *dst,
 				     const u8 *src);
 
-static inline void serpent_enc_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-				   const u8 *src)
+static inline void serpent_enc_blk_xway(const void *ctx, u8 *dst, const u8 *src)
 {
 	__serpent_enc_blk_8way(ctx, dst, src, false);
 }
 
-static inline void serpent_enc_blk_xway_xor(struct serpent_ctx *ctx, u8 *dst,
-				       const u8 *src)
+static inline void serpent_enc_blk_xway_xor(const struct serpent_ctx *ctx,
+					    u8 *dst, const u8 *src)
 {
 	__serpent_enc_blk_8way(ctx, dst, src, true);
 }
 
-static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-				   const u8 *src)
+static inline void serpent_dec_blk_xway(const void *ctx, u8 *dst, const u8 *src)
 {
 	serpent_dec_blk_8way(ctx, dst, src);
 }
diff --git a/crypto/serpent_generic.c b/crypto/serpent_generic.c
index 56fa665a4f01..492c1d0bfe06 100644
--- a/crypto/serpent_generic.c
+++ b/crypto/serpent_generic.c
@@ -449,8 +449,9 @@ int serpent_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
 }
 EXPORT_SYMBOL_GPL(serpent_setkey);
 
-void __serpent_encrypt(struct serpent_ctx *ctx, u8 *dst, const u8 *src)
+void __serpent_encrypt(const void *c, u8 *dst, const u8 *src)
 {
+	const struct serpent_ctx *ctx = c;
 	const u32 *k = ctx->expkey;
 	const __le32 *s = (const __le32 *)src;
 	__le32	*d = (__le32 *)dst;
@@ -514,8 +515,9 @@ static void serpent_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	__serpent_encrypt(ctx, dst, src);
 }
 
-void __serpent_decrypt(struct serpent_ctx *ctx, u8 *dst, const u8 *src)
+void __serpent_decrypt(const void *c, u8 *dst, const u8 *src)
 {
+	const struct serpent_ctx *ctx = c;
 	const u32 *k = ctx->expkey;
 	const __le32 *s = (const __le32 *)src;
 	__le32	*d = (__le32 *)dst;
diff --git a/include/crypto/serpent.h b/include/crypto/serpent.h
index 7dd780c5d058..75c7eaa20853 100644
--- a/include/crypto/serpent.h
+++ b/include/crypto/serpent.h
@@ -22,7 +22,7 @@ int __serpent_setkey(struct serpent_ctx *ctx, const u8 *key,
 		     unsigned int keylen);
 int serpent_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen);
 
-void __serpent_encrypt(struct serpent_ctx *ctx, u8 *dst, const u8 *src);
-void __serpent_decrypt(struct serpent_ctx *ctx, u8 *dst, const u8 *src);
+void __serpent_encrypt(const void *ctx, u8 *dst, const u8 *src);
+void __serpent_decrypt(const void *ctx, u8 *dst, const u8 *src);
 
 #endif
-- 
2.17.1

