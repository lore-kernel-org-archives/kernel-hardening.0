Return-Path: <SRS0=boeX=ZF=lists.openwall.com=kernel-hardening-return-17353-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B19F1C432C3
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 Nov 2019 18:26:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1E5A320409
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 Nov 2019 18:26:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="B0Nw9A2d"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E5A320409
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17353-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1119 invoked by uid 550); 13 Nov 2019 18:25:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32754 invoked from network); 13 Nov 2019 18:25:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rF12U17ByIOUQlBO485khkST+bkad067Bgj3e47H3vA=;
        b=B0Nw9A2dWJpHxnMPBj0OXkSohw6eWiwcJKGvnKHrJrtIk0rvPw+E7/6OZfIcBo0MoE
         EG/wQc/J+UmQdYjfEmSKSde2EkwAGvkXitXGwd6JwXG88zNi3/lEutSAtonzdWCmsuEP
         KMNwIhqUaj7y14XDAUn1Zn3DCY7sINJ44Z1lQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rF12U17ByIOUQlBO485khkST+bkad067Bgj3e47H3vA=;
        b=Ak4uavsGNtFodi/JCkuG/wrdPK/QCH2bi9MbS5LpjYlxL5vmog+QMES1vFvr+kDddy
         QrmRh8Ug7V9RgfD9S3Qn2e0GTe+A1+ZZAXUZqceEtGhqSLhNjqyXuMmRSUpXEpCSuhQe
         8yP4TZyoETUnDchAjfWGUwN+FnVJ54u88vJmZg1593Uu2gxexEM7E6LxYamUqoXVQReb
         JnGKQwB1Qc8D0Y8F4HkORLcgmQ8jdDhjEzeHLsLTFy1MgZBFeO12KZ/ywqk7U+6Ewlan
         uajjOMTuuseqLzI5l/RTnW1u6Dj56wwUfhtiypU1d1n6DV71JosfC7Szn5COt1LpN7Ad
         bttw==
X-Gm-Message-State: APjAAAVyf97jIPcabi5k445y5Ry1aGzjfmuYEZUjP9cHyPTXIZ5BTg+W
	t2+0YXpb/n+sJNrEsBUZPhRmYA==
X-Google-Smtp-Source: APXvYqzwuMLsVm5YwHmbN1BZvt4twWfgaMYDp8kH6QoYuok+0f4pRCA11sqZ5mo522AsEv1vA2vENw==
X-Received: by 2002:a17:90a:f496:: with SMTP id bx22mr6677618pjb.126.1573669527838;
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
Subject: [PATCH v5 5/8] crypto: x86/cast6: Remove glue function macro usage
Date: Wed, 13 Nov 2019 10:25:13 -0800
Message-Id: <20191113182516.13545-6-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191113182516.13545-1-keescook@chromium.org>
References: <20191113182516.13545-1-keescook@chromium.org>
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
 arch/x86/crypto/cast6_avx_glue.c | 70 +++++++++++++++-----------------
 crypto/cast6_generic.c           |  6 ++-
 include/crypto/cast6.h           |  4 +-
 3 files changed, 39 insertions(+), 41 deletions(-)

diff --git a/arch/x86/crypto/cast6_avx_glue.c b/arch/x86/crypto/cast6_avx_glue.c
index a8a38fffb4a9..299cef14a762 100644
--- a/arch/x86/crypto/cast6_avx_glue.c
+++ b/arch/x86/crypto/cast6_avx_glue.c
@@ -20,20 +20,17 @@
 
 #define CAST6_PARALLEL_BLOCKS 8
 
-asmlinkage void cast6_ecb_enc_8way(struct cast6_ctx *ctx, u8 *dst,
-				   const u8 *src);
-asmlinkage void cast6_ecb_dec_8way(struct cast6_ctx *ctx, u8 *dst,
-				   const u8 *src);
-
-asmlinkage void cast6_cbc_dec_8way(struct cast6_ctx *ctx, u8 *dst,
-				   const u8 *src);
-asmlinkage void cast6_ctr_8way(struct cast6_ctx *ctx, u8 *dst, const u8 *src,
+asmlinkage void cast6_ecb_enc_8way(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void cast6_ecb_dec_8way(void *ctx, u8 *dst, const u8 *src);
+
+asmlinkage void cast6_cbc_dec_8way(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void cast6_ctr_8way(void *ctx, u8 *dst, const u8 *src,
 			       le128 *iv);
 
-asmlinkage void cast6_xts_enc_8way(struct cast6_ctx *ctx, u8 *dst,
-				   const u8 *src, le128 *iv);
-asmlinkage void cast6_xts_dec_8way(struct cast6_ctx *ctx, u8 *dst,
-				   const u8 *src, le128 *iv);
+asmlinkage void cast6_xts_enc_8way(void *ctx, u8 *dst, const u8 *src,
+				   le128 *iv);
+asmlinkage void cast6_xts_dec_8way(void *ctx, u8 *dst, const u8 *src,
+				   le128 *iv);
 
 static int cast6_setkey_skcipher(struct crypto_skcipher *tfm,
 				 const u8 *key, unsigned int keylen)
@@ -41,21 +38,23 @@ static int cast6_setkey_skcipher(struct crypto_skcipher *tfm,
 	return cast6_setkey(&tfm->base, key, keylen);
 }
 
-static void cast6_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+static void cast6_xts_enc(void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(__cast6_encrypt));
+	glue_xts_crypt_128bit_one(ctx, (u128 *)dst, (const u128 *)src, iv,
+				  __cast6_encrypt);
 }
 
-static void cast6_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+static void cast6_xts_dec(void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(__cast6_decrypt));
+	glue_xts_crypt_128bit_one(ctx, (u128 *)dst, (const u128 *)src, iv,
+				  __cast6_decrypt);
 }
 
-static void cast6_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+static void cast6_crypt_ctr(void *ctx, u8 *d, const u8 *s, le128 *iv)
 {
 	be128 ctrblk;
+	u128 *dst = (u128 *)d;
+	const u128 *src = (const u128 *)s;
 
 	le128_to_be128(&ctrblk, iv);
 	le128_inc(iv);
@@ -70,10 +69,10 @@ static const struct common_glue_ctx cast6_enc = {
 
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
 
@@ -83,10 +82,10 @@ static const struct common_glue_ctx cast6_ctr = {
 
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
 
@@ -96,10 +95,10 @@ static const struct common_glue_ctx cast6_enc_xts = {
 
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
 
@@ -109,10 +108,10 @@ static const struct common_glue_ctx cast6_dec = {
 
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
 
@@ -122,10 +121,10 @@ static const struct common_glue_ctx cast6_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(cast6_cbc_dec_8way) }
+		.fn_u = { .cbc = cast6_cbc_dec_8way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(__cast6_decrypt) }
+		.fn_u = { .cbc = __cast6_decrypt }
 	} }
 };
 
@@ -135,10 +134,10 @@ static const struct common_glue_ctx cast6_dec_xts = {
 
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
 
@@ -154,8 +153,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(__cast6_encrypt),
-					   req);
+	return glue_cbc_encrypt_req_128bit(__cast6_encrypt, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -199,8 +197,7 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct cast6_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&cast6_enc_xts, req,
-				   XTS_TWEAK_CAST(__cast6_encrypt),
+	return glue_xts_req_128bit(&cast6_enc_xts, req, __cast6_encrypt,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
 }
 
@@ -209,8 +206,7 @@ static int xts_decrypt(struct skcipher_request *req)
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

