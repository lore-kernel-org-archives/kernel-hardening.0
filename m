Return-Path: <SRS0=gqGH=ZO=lists.openwall.com=kernel-hardening-return-17424-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15C3C432C0
	for <kernel-hardening@archiver.kernel.org>; Fri, 22 Nov 2019 01:04:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 81EFF206CB
	for <kernel-hardening@archiver.kernel.org>; Fri, 22 Nov 2019 01:04:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="W4hqQ2Wo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81EFF206CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17424-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19816 invoked by uid 550); 22 Nov 2019 01:03:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19615 invoked from network); 22 Nov 2019 01:03:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QTM69Bxwp5xwLqfylTsmV9HmViM0S64SsqvOMmlOVw8=;
        b=W4hqQ2WowOSNf877qwevhpb3EGriv6p2u55tYgkrrzF5nw3MiY0nAopRQp691CJZXM
         paF4wndbYPJzxaK9WUHXTaJgl/y2TBZ8JpyOzz0GmUturCGaK4MqHrfJc0ON76/P7Pra
         N4pHNsY0r33oAdRME1rf1U/1TOxMXqhKmMw3Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QTM69Bxwp5xwLqfylTsmV9HmViM0S64SsqvOMmlOVw8=;
        b=RtjO8Naw87cwrI2iugSK06MThsWjEDsiDeK62+GNJcYG3KNoMbKU5iUjzj+9VWkmU5
         AMa/vuG138JctIltEBWp/e5aX+WNIpiVsjsG+2EimwpCxVYLtOdbikVvL0XL6hk9o3YD
         kGgQZrgLrE7waHGMc0RhS0Zu36MyQ1UhZEsdBKsTbcOaOdAMdK+zknkwMi9+wocwLkOg
         CiiRPUNq4tSxWknXZ9TQb4lLUOC/rRlUwmWl2yGMFLneVbgWVMbFzu+1/oOENqQFN/Lb
         cjUTEht540xTGP6kKIQiirP5IT5j7uSpUEwkPEBmDc+0073GNcvoH2hc+dRvXq9Ov2mm
         z0WQ==
X-Gm-Message-State: APjAAAU9w0+CZjWk35BoDQEWVSSCVqP5oVA2uMGYiE6vQzAP0yInEnRX
	FxfndHv23r/pbqHx+weuF1ygrA==
X-Google-Smtp-Source: APXvYqwxRbLkxdYUlnyEY1BTeoAh59Iy3CjqiI67xbxvXN+RCa8ShhGpdiHIs78iPmB/woAdKjOy/w==
X-Received: by 2002:a65:6810:: with SMTP id l16mr5890962pgt.55.1574384622267;
        Thu, 21 Nov 2019 17:03:42 -0800 (PST)
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
Subject: [PATCH v6 3/8] crypto: x86/camellia: Remove glue function macro usage
Date: Thu, 21 Nov 2019 17:03:29 -0800
Message-Id: <20191122010334.12081-4-keescook@chromium.org>
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
 arch/x86/crypto/camellia_aesni_avx2_glue.c | 74 ++++++++++------------
 arch/x86/crypto/camellia_aesni_avx_glue.c  | 72 ++++++++++-----------
 arch/x86/crypto/camellia_glue.c            | 45 +++++++------
 arch/x86/include/asm/crypto/camellia.h     | 63 +++++++++---------
 4 files changed, 119 insertions(+), 135 deletions(-)

diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
index a4f00128ea55..a8cc2c83fe1b 100644
--- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
@@ -19,20 +19,17 @@
 #define CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS 32
 
 /* 32-way AVX2/AES-NI parallel cipher functions */
-asmlinkage void camellia_ecb_enc_32way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
-asmlinkage void camellia_ecb_dec_32way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
+asmlinkage void camellia_ecb_enc_32way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_ecb_dec_32way(const void *ctx, u8 *dst, const u8 *src);
 
-asmlinkage void camellia_cbc_dec_32way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
-asmlinkage void camellia_ctr_32way(struct camellia_ctx *ctx, u8 *dst,
-				   const u8 *src, le128 *iv);
+asmlinkage void camellia_cbc_dec_32way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_ctr_32way(const void *ctx, u8 *dst, const u8 *src,
+				   le128 *iv);
 
-asmlinkage void camellia_xts_enc_32way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src, le128 *iv);
-asmlinkage void camellia_xts_dec_32way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src, le128 *iv);
+asmlinkage void camellia_xts_enc_32way(const void *ctx, u8 *dst, const u8 *src,
+				       le128 *iv);
+asmlinkage void camellia_xts_dec_32way(const void *ctx, u8 *dst, const u8 *src,
+				       le128 *iv);
 
 static const struct common_glue_ctx camellia_enc = {
 	.num_funcs = 4,
@@ -40,16 +37,16 @@ static const struct common_glue_ctx camellia_enc = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_enc_32way) }
+		.fn_u = { .ecb = camellia_ecb_enc_32way }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_enc_16way) }
+		.fn_u = { .ecb = camellia_ecb_enc_16way }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_enc_blk_2way) }
+		.fn_u = { .ecb = camellia_enc_blk_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_enc_blk) }
+		.fn_u = { .ecb = camellia_enc_blk }
 	} }
 };
 
@@ -59,16 +56,16 @@ static const struct common_glue_ctx camellia_ctr = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_ctr_32way) }
+		.fn_u = { .ctr = camellia_ctr_32way }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_ctr_16way) }
+		.fn_u = { .ctr = camellia_ctr_16way }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_crypt_ctr_2way) }
+		.fn_u = { .ctr = camellia_crypt_ctr_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_crypt_ctr) }
+		.fn_u = { .ctr = camellia_crypt_ctr }
 	} }
 };
 
@@ -78,13 +75,13 @@ static const struct common_glue_ctx camellia_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_enc_32way) }
+		.fn_u = { .xts = camellia_xts_enc_32way }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_enc_16way) }
+		.fn_u = { .xts = camellia_xts_enc_16way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_enc) }
+		.fn_u = { .xts = camellia_xts_enc }
 	} }
 };
 
@@ -94,16 +91,16 @@ static const struct common_glue_ctx camellia_dec = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_dec_32way) }
+		.fn_u = { .ecb = camellia_ecb_dec_32way }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_dec_16way) }
+		.fn_u = { .ecb = camellia_ecb_dec_16way }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk_2way) }
+		.fn_u = { .ecb = camellia_dec_blk_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .ecb = camellia_dec_blk }
 	} }
 };
 
@@ -113,16 +110,16 @@ static const struct common_glue_ctx camellia_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_cbc_dec_32way) }
+		.fn_u = { .cbc = camellia_cbc_dec_32way }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_cbc_dec_16way) }
+		.fn_u = { .cbc = camellia_cbc_dec_16way }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_decrypt_cbc_2way) }
+		.fn_u = { .cbc = camellia_decrypt_cbc_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .cbc = camellia_dec_blk }
 	} }
 };
 
@@ -132,13 +129,13 @@ static const struct common_glue_ctx camellia_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_dec_32way) }
+		.fn_u = { .xts = camellia_xts_dec_32way }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_dec_16way) }
+		.fn_u = { .xts = camellia_xts_dec_16way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_dec) }
+		.fn_u = { .xts = camellia_xts_dec }
 	} }
 };
 
@@ -161,8 +158,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(camellia_enc_blk),
-					   req);
+	return glue_cbc_encrypt_req_128bit(camellia_enc_blk, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -180,8 +176,7 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct camellia_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&camellia_enc_xts, req,
-				   XTS_TWEAK_CAST(camellia_enc_blk),
+	return glue_xts_req_128bit(&camellia_enc_xts, req, camellia_enc_blk,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
 }
 
@@ -190,8 +185,7 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct camellia_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&camellia_dec_xts, req,
-				   XTS_TWEAK_CAST(camellia_enc_blk),
+	return glue_xts_req_128bit(&camellia_dec_xts, req, camellia_enc_blk,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
 }
 
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
index f28d282779b8..31a82a79f4ac 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -18,41 +18,36 @@
 #define CAMELLIA_AESNI_PARALLEL_BLOCKS 16
 
 /* 16-way parallel cipher functions (avx/aes-ni) */
-asmlinkage void camellia_ecb_enc_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
+asmlinkage void camellia_ecb_enc_16way(const void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_ecb_enc_16way);
 
-asmlinkage void camellia_ecb_dec_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
+asmlinkage void camellia_ecb_dec_16way(const void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_ecb_dec_16way);
 
-asmlinkage void camellia_cbc_dec_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
+asmlinkage void camellia_cbc_dec_16way(const void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_cbc_dec_16way);
 
-asmlinkage void camellia_ctr_16way(struct camellia_ctx *ctx, u8 *dst,
-				   const u8 *src, le128 *iv);
+asmlinkage void camellia_ctr_16way(const void *ctx, u8 *dst, const u8 *src,
+				   le128 *iv);
 EXPORT_SYMBOL_GPL(camellia_ctr_16way);
 
-asmlinkage void camellia_xts_enc_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src, le128 *iv);
+asmlinkage void camellia_xts_enc_16way(const void *ctx, u8 *dst, const u8 *src,
+				       le128 *iv);
 EXPORT_SYMBOL_GPL(camellia_xts_enc_16way);
 
-asmlinkage void camellia_xts_dec_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src, le128 *iv);
+asmlinkage void camellia_xts_dec_16way(const void *ctx, u8 *dst, const u8 *src,
+				       le128 *iv);
 EXPORT_SYMBOL_GPL(camellia_xts_dec_16way);
 
-void camellia_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+void camellia_xts_enc(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(camellia_enc_blk));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, camellia_enc_blk);
 }
 EXPORT_SYMBOL_GPL(camellia_xts_enc);
 
-void camellia_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+void camellia_xts_dec(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(camellia_dec_blk));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, camellia_dec_blk);
 }
 EXPORT_SYMBOL_GPL(camellia_xts_dec);
 
@@ -62,13 +57,13 @@ static const struct common_glue_ctx camellia_enc = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_enc_16way) }
+		.fn_u = { .ecb = camellia_ecb_enc_16way }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_enc_blk_2way) }
+		.fn_u = { .ecb = camellia_enc_blk_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_enc_blk) }
+		.fn_u = { .ecb = camellia_enc_blk }
 	} }
 };
 
@@ -78,13 +73,13 @@ static const struct common_glue_ctx camellia_ctr = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_ctr_16way) }
+		.fn_u = { .ctr = camellia_ctr_16way }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_crypt_ctr_2way) }
+		.fn_u = { .ctr = camellia_crypt_ctr_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_crypt_ctr) }
+		.fn_u = { .ctr = camellia_crypt_ctr }
 	} }
 };
 
@@ -94,10 +89,10 @@ static const struct common_glue_ctx camellia_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_enc_16way) }
+		.fn_u = { .xts = camellia_xts_enc_16way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_enc) }
+		.fn_u = { .xts = camellia_xts_enc }
 	} }
 };
 
@@ -107,13 +102,13 @@ static const struct common_glue_ctx camellia_dec = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_dec_16way) }
+		.fn_u = { .ecb = camellia_ecb_dec_16way }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk_2way) }
+		.fn_u = { .ecb = camellia_dec_blk_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .ecb = camellia_dec_blk }
 	} }
 };
 
@@ -123,13 +118,13 @@ static const struct common_glue_ctx camellia_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_cbc_dec_16way) }
+		.fn_u = { .cbc = camellia_cbc_dec_16way }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_decrypt_cbc_2way) }
+		.fn_u = { .cbc = camellia_decrypt_cbc_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .cbc = camellia_dec_blk }
 	} }
 };
 
@@ -139,10 +134,10 @@ static const struct common_glue_ctx camellia_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_dec_16way) }
+		.fn_u = { .xts = camellia_xts_dec_16way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_dec) }
+		.fn_u = { .xts = camellia_xts_dec }
 	} }
 };
 
@@ -165,8 +160,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(camellia_enc_blk),
-					   req);
+	return glue_cbc_encrypt_req_128bit(camellia_enc_blk, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -206,8 +200,7 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct camellia_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&camellia_enc_xts, req,
-				   XTS_TWEAK_CAST(camellia_enc_blk),
+	return glue_xts_req_128bit(&camellia_enc_xts, req, camellia_enc_blk,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
 }
 
@@ -216,8 +209,7 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct camellia_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&camellia_dec_xts, req,
-				   XTS_TWEAK_CAST(camellia_enc_blk),
+	return glue_xts_req_128bit(&camellia_dec_xts, req, camellia_enc_blk,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
 }
 
diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index 7c62db56ffe1..5f3ed5af68d7 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -18,19 +18,17 @@
 #include <asm/crypto/glue_helper.h>
 
 /* regular block cipher functions */
-asmlinkage void __camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
-				   const u8 *src, bool xor);
+asmlinkage void __camellia_enc_blk(const void *ctx, u8 *dst, const u8 *src,
+				   bool xor);
 EXPORT_SYMBOL_GPL(__camellia_enc_blk);
-asmlinkage void camellia_dec_blk(struct camellia_ctx *ctx, u8 *dst,
-				 const u8 *src);
+asmlinkage void camellia_dec_blk(const void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_dec_blk);
 
 /* 2-way parallel cipher functions */
-asmlinkage void __camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *dst,
-					const u8 *src, bool xor);
+asmlinkage void __camellia_enc_blk_2way(const void *ctx, u8 *dst, const u8 *src,
+					bool xor);
 EXPORT_SYMBOL_GPL(__camellia_enc_blk_2way);
-asmlinkage void camellia_dec_blk_2way(struct camellia_ctx *ctx, u8 *dst,
-				      const u8 *src);
+asmlinkage void camellia_dec_blk_2way(const void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_dec_blk_2way);
 
 static void camellia_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
@@ -1267,8 +1265,10 @@ static int camellia_setkey_skcipher(struct crypto_skcipher *tfm, const u8 *key,
 	return camellia_setkey(&tfm->base, key, key_len);
 }
 
-void camellia_decrypt_cbc_2way(void *ctx, u128 *dst, const u128 *src)
+void camellia_decrypt_cbc_2way(const void *ctx, u8 *d, const u8 *s)
 {
+	u128 *dst = (u128 *)d;
+	const u128 *src = (const u128 *)s;
 	u128 iv = *src;
 
 	camellia_dec_blk_2way(ctx, (u8 *)dst, (u8 *)src);
@@ -1277,9 +1277,11 @@ void camellia_decrypt_cbc_2way(void *ctx, u128 *dst, const u128 *src)
 }
 EXPORT_SYMBOL_GPL(camellia_decrypt_cbc_2way);
 
-void camellia_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+void camellia_crypt_ctr(const void *ctx, u8 *d, const u8 *s, le128 *iv)
 {
 	be128 ctrblk;
+	u128 *dst = (u128 *)d;
+	const u128 *src = (const u128 *)s;
 
 	if (dst != src)
 		*dst = *src;
@@ -1291,9 +1293,11 @@ void camellia_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 }
 EXPORT_SYMBOL_GPL(camellia_crypt_ctr);
 
-void camellia_crypt_ctr_2way(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+void camellia_crypt_ctr_2way(const void *ctx, u8 *d, const u8 *s, le128 *iv)
 {
 	be128 ctrblks[2];
+	u128 *dst = (u128 *)d;
+	const u128 *src = (const u128 *)s;
 
 	if (dst != src) {
 		dst[0] = src[0];
@@ -1315,10 +1319,10 @@ static const struct common_glue_ctx camellia_enc = {
 
 	.funcs = { {
 		.num_blocks = 2,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_enc_blk_2way) }
+		.fn_u = { .ecb = camellia_enc_blk_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_enc_blk) }
+		.fn_u = { .ecb = camellia_enc_blk }
 	} }
 };
 
@@ -1328,10 +1332,10 @@ static const struct common_glue_ctx camellia_ctr = {
 
 	.funcs = { {
 		.num_blocks = 2,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_crypt_ctr_2way) }
+		.fn_u = { .ctr = camellia_crypt_ctr_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_crypt_ctr) }
+		.fn_u = { .ctr = camellia_crypt_ctr }
 	} }
 };
 
@@ -1341,10 +1345,10 @@ static const struct common_glue_ctx camellia_dec = {
 
 	.funcs = { {
 		.num_blocks = 2,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk_2way) }
+		.fn_u = { .ecb = camellia_dec_blk_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .ecb = camellia_dec_blk }
 	} }
 };
 
@@ -1354,10 +1358,10 @@ static const struct common_glue_ctx camellia_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = 2,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_decrypt_cbc_2way) }
+		.fn_u = { .cbc = camellia_decrypt_cbc_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .cbc = camellia_dec_blk }
 	} }
 };
 
@@ -1373,8 +1377,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(camellia_enc_blk),
-					   req);
+	return glue_cbc_encrypt_req_128bit(camellia_enc_blk, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
diff --git a/arch/x86/include/asm/crypto/camellia.h b/arch/x86/include/asm/crypto/camellia.h
index a5d86fc0593f..f1592619dd65 100644
--- a/arch/x86/include/asm/crypto/camellia.h
+++ b/arch/x86/include/asm/crypto/camellia.h
@@ -32,65 +32,60 @@ extern int xts_camellia_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			       unsigned int keylen);
 
 /* regular block cipher functions */
-asmlinkage void __camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
-				   const u8 *src, bool xor);
-asmlinkage void camellia_dec_blk(struct camellia_ctx *ctx, u8 *dst,
-				 const u8 *src);
+asmlinkage void __camellia_enc_blk(const void *ctx, u8 *dst, const u8 *src,
+				   bool xor);
+asmlinkage void camellia_dec_blk(const void *ctx, u8 *dst, const u8 *src);
 
 /* 2-way parallel cipher functions */
-asmlinkage void __camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *dst,
-					const u8 *src, bool xor);
-asmlinkage void camellia_dec_blk_2way(struct camellia_ctx *ctx, u8 *dst,
-				      const u8 *src);
+asmlinkage void __camellia_enc_blk_2way(const void *ctx, u8 *dst, const u8 *src,
+					bool xor);
+asmlinkage void camellia_dec_blk_2way(const void *ctx, u8 *dst, const u8 *src);
 
 /* 16-way parallel cipher functions (avx/aes-ni) */
-asmlinkage void camellia_ecb_enc_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
-asmlinkage void camellia_ecb_dec_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
-
-asmlinkage void camellia_cbc_dec_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
-asmlinkage void camellia_ctr_16way(struct camellia_ctx *ctx, u8 *dst,
-				   const u8 *src, le128 *iv);
-
-asmlinkage void camellia_xts_enc_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src, le128 *iv);
-asmlinkage void camellia_xts_dec_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src, le128 *iv);
-
-static inline void camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
-				    const u8 *src)
+asmlinkage void camellia_ecb_enc_16way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_ecb_dec_16way(const void *ctx, u8 *dst, const u8 *src);
+
+asmlinkage void camellia_cbc_dec_16way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_ctr_16way(const void *ctx, u8 *dst, const u8 *src,
+				   le128 *iv);
+
+asmlinkage void camellia_xts_enc_16way(const void *ctx, u8 *dst, const u8 *src,
+				       le128 *iv);
+asmlinkage void camellia_xts_dec_16way(const void *ctx, u8 *dst, const u8 *src,
+				       le128 *iv);
+
+static inline void camellia_enc_blk(const void *ctx, u8 *dst, const u8 *src)
 {
 	__camellia_enc_blk(ctx, dst, src, false);
 }
 
-static inline void camellia_enc_blk_xor(struct camellia_ctx *ctx, u8 *dst,
-					const u8 *src)
+static inline void camellia_enc_blk_xor(const void *ctx, u8 *dst, const u8 *src)
 {
 	__camellia_enc_blk(ctx, dst, src, true);
 }
 
-static inline void camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *dst,
+static inline void camellia_enc_blk_2way(const void *ctx, u8 *dst,
 					 const u8 *src)
 {
 	__camellia_enc_blk_2way(ctx, dst, src, false);
 }
 
-static inline void camellia_enc_blk_xor_2way(struct camellia_ctx *ctx, u8 *dst,
+static inline void camellia_enc_blk_xor_2way(const void *ctx, u8 *dst,
 					     const u8 *src)
 {
 	__camellia_enc_blk_2way(ctx, dst, src, true);
 }
 
 /* glue helpers */
-extern void camellia_decrypt_cbc_2way(void *ctx, u128 *dst, const u128 *src);
-extern void camellia_crypt_ctr(void *ctx, u128 *dst, const u128 *src,
+extern void camellia_decrypt_cbc_2way(const void *ctx, u8 *dst, const u8 *src);
+extern void camellia_crypt_ctr(const void *ctx, u8 *dst, const u8 *src,
 			       le128 *iv);
-extern void camellia_crypt_ctr_2way(void *ctx, u128 *dst, const u128 *src,
+extern void camellia_crypt_ctr_2way(const void *ctx, u8 *dst, const u8 *src,
 				    le128 *iv);
 
-extern void camellia_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv);
-extern void camellia_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv);
+extern void camellia_xts_enc(const void *ctx, u8 *dst, const u8 *src,
+			     le128 *iv);
+extern void camellia_xts_dec(const void *ctx, u8 *dst, const u8 *src,
+			     le128 *iv);
 
 #endif /* ASM_X86_CAMELLIA_H */
-- 
2.17.1

