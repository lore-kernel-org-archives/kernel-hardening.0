From: Joao Moreira <jmoreira@suse.de>
Subject: [RFC PATCH v2 1/4] Fix serpent crypto functions prototype casts
Date: Mon,  6 May 2019 16:19:47 -0300
Message-Id: <20190506191950.9521-2-jmoreira@suse.de>
In-Reply-To: <20190506191950.9521-1-jmoreira@suse.de>
References: <20190506191950.9521-1-jmoreira@suse.de>
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Add macros that generate glue functions for serpent crypto functions.

Remove GLUE_FUNC_CAST macros from function pointer assignement and use
the helper instead, making the prototypes compliant.

Signed-off-by: Joao Moreira <jmoreira@suse.de>
---
 arch/x86/crypto/serpent_avx2_glue.c        | 68 ++++++++++++++----------------
 arch/x86/crypto/serpent_avx_glue.c         | 63 ++++++++++-----------------
 arch/x86/crypto/serpent_sse2_glue.c        | 24 +++++++----
 arch/x86/include/asm/crypto/serpent-avx.h  | 39 +++++++++++------
 arch/x86/include/asm/crypto/serpent-sse2.h | 10 +++++
 5 files changed, 105 insertions(+), 99 deletions(-)

diff --git a/arch/x86/crypto/serpent_avx2_glue.c b/arch/x86/crypto/serpent_avx2_glue.c
index 03347b16ac9d..d2e7cf23c74b 100644
--- a/arch/x86/crypto/serpent_avx2_glue.c
+++ b/arch/x86/crypto/serpent_avx2_glue.c
@@ -24,18 +24,15 @@
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
+SERPENT_GLUE(serpent_ecb_enc_16way);
+SERPENT_GLUE(serpent_ecb_dec_16way);
+SERPENT_GLUE_CBC(serpent_cbc_dec_16way, serpent_cbc_dec_16way_glue);
+SERPENT_GLUE_CTR(serpent_ctr_16way);
+SERPENT_GLUE_XTS(serpent_xts_enc_16way);
+SERPENT_GLUE_XTS(serpent_xts_dec_16way);
+SERPENT_GLUE(__serpent_encrypt);
+SERPENT_GLUE(__serpent_decrypt);
+SERPENT_GLUE_CBC(__serpent_decrypt, __serpent_decrypt_cbc_glue);
 
 static int serpent_setkey_skcipher(struct crypto_skcipher *tfm,
 				   const u8 *key, unsigned int keylen)
@@ -49,13 +46,13 @@ static const struct common_glue_ctx serpent_enc = {
 
 	.funcs = { {
 		.num_blocks = 16,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_enc_16way) }
+		.fn_u = { .ecb = serpent_ecb_enc_16way_glue }
 	}, {
 		.num_blocks = 8,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_enc_8way_avx) }
+		.fn_u = { .ecb = serpent_ecb_enc_8way_avx_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_encrypt) }
+		.fn_u = { .ecb = __serpent_encrypt_glue }
 	} }
 };
 
@@ -65,13 +62,13 @@ static const struct common_glue_ctx serpent_ctr = {
 
 	.funcs = { {
 		.num_blocks = 16,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(serpent_ctr_16way) }
+		.fn_u = { .ctr = serpent_ctr_16way_glue }
 	},  {
 		.num_blocks = 8,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(serpent_ctr_8way_avx) }
+		.fn_u = { .ctr = serpent_ctr_8way_avx_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(__serpent_crypt_ctr) }
+		.fn_u = { .ctr = __serpent_crypt_ctr }
 	} }
 };
 
@@ -81,13 +78,13 @@ static const struct common_glue_ctx serpent_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = 16,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_enc_16way) }
+		.fn_u = { .xts = serpent_xts_enc_16way_glue }
 	}, {
 		.num_blocks = 8,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_enc_8way_avx) }
+		.fn_u = { .xts = serpent_xts_enc_8way_avx_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_enc) }
+		.fn_u = { .xts = serpent_xts_enc }
 	} }
 };
 
@@ -97,13 +94,13 @@ static const struct common_glue_ctx serpent_dec = {
 
 	.funcs = { {
 		.num_blocks = 16,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_dec_16way) }
+		.fn_u = { .ecb = serpent_ecb_dec_16way_glue }
 	}, {
 		.num_blocks = 8,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_dec_8way_avx) }
+		.fn_u = { .ecb = serpent_ecb_dec_8way_avx_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_decrypt) }
+		.fn_u = { .ecb = __serpent_decrypt_glue }
 	} }
 };
 
@@ -113,13 +110,13 @@ static const struct common_glue_ctx serpent_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = 16,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(serpent_cbc_dec_16way) }
+		.fn_u = { .cbc = serpent_cbc_dec_16way_glue }
 	}, {
 		.num_blocks = 8,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(serpent_cbc_dec_8way_avx) }
+		.fn_u = { .cbc = serpent_cbc_dec_8way_avx_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(__serpent_decrypt) }
+		.fn_u = { .cbc = __serpent_decrypt_cbc_glue }
 	} }
 };
 
@@ -129,13 +126,13 @@ static const struct common_glue_ctx serpent_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = 16,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_dec_16way) }
+		.fn_u = { .xts = serpent_xts_dec_16way_glue }
 	}, {
 		.num_blocks = 8,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_dec_8way_avx) }
+		.fn_u = { .xts = serpent_xts_dec_8way_avx_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_dec) }
+		.fn_u = { .xts = serpent_xts_dec }
 	} }
 };
 
@@ -151,8 +148,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(__serpent_encrypt),
-					   req);
+	return glue_cbc_encrypt_req_128bit(__serpent_encrypt_glue, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -171,8 +167,8 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct serpent_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&serpent_enc_xts, req,
-				   XTS_TWEAK_CAST(__serpent_encrypt),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx);
+				   __serpent_encrypt_glue, &ctx->tweak_ctx,
+				   &ctx->crypt_ctx);
 }
 
 static int xts_decrypt(struct skcipher_request *req)
@@ -181,8 +177,8 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct serpent_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&serpent_dec_xts, req,
-				   XTS_TWEAK_CAST(__serpent_encrypt),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx);
+				   __serpent_encrypt_glue, &ctx->tweak_ctx,
+				   &ctx->crypt_ctx);
 }
 
 static struct skcipher_alg serpent_algs[] = {
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index 458567ecf76c..45584cf7bb81 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -34,29 +34,15 @@
 #include <asm/crypto/glue_helper.h>
 #include <asm/crypto/serpent-avx.h>
 
-/* 8-way parallel cipher functions */
-asmlinkage void serpent_ecb_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
-					 const u8 *src);
-EXPORT_SYMBOL_GPL(serpent_ecb_enc_8way_avx);
+SERPENT_GLUE(__serpent_encrypt);
+SERPENT_GLUE(__serpent_decrypt);
+SERPENT_GLUE_CBC(__serpent_decrypt, __serpent_decrypt_cbc_glue);
 
-asmlinkage void serpent_ecb_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
-					 const u8 *src);
+EXPORT_SYMBOL_GPL(serpent_ecb_enc_8way_avx);
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
@@ -73,15 +59,13 @@ EXPORT_SYMBOL_GPL(__serpent_crypt_ctr);
 
 void serpent_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(__serpent_encrypt));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, __serpent_encrypt_glue);
 }
 EXPORT_SYMBOL_GPL(serpent_xts_enc);
 
 void serpent_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(__serpent_decrypt));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, __serpent_decrypt_glue);
 }
 EXPORT_SYMBOL_GPL(serpent_xts_dec);
 
@@ -117,10 +101,10 @@ static const struct common_glue_ctx serpent_enc = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_enc_8way_avx) }
+		.fn_u = { .ecb = serpent_ecb_enc_8way_avx_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_encrypt) }
+		.fn_u = { .ecb = __serpent_encrypt_glue }
 	} }
 };
 
@@ -130,10 +114,10 @@ static const struct common_glue_ctx serpent_ctr = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(serpent_ctr_8way_avx) }
+		.fn_u = { .ctr = serpent_ctr_8way_avx_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(__serpent_crypt_ctr) }
+		.fn_u = { .ctr = __serpent_crypt_ctr }
 	} }
 };
 
@@ -143,10 +127,10 @@ static const struct common_glue_ctx serpent_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_enc_8way_avx) }
+		.fn_u = { .xts = serpent_xts_enc_8way_avx_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_enc) }
+		.fn_u = { .xts = serpent_xts_enc }
 	} }
 };
 
@@ -156,10 +140,10 @@ static const struct common_glue_ctx serpent_dec = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_dec_8way_avx) }
+		.fn_u = { .ecb = serpent_ecb_dec_8way_avx_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_decrypt) }
+		.fn_u = { .ecb = __serpent_decrypt_glue }
 	} }
 };
 
@@ -169,10 +153,10 @@ static const struct common_glue_ctx serpent_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(serpent_cbc_dec_8way_avx) }
+		.fn_u = { .cbc = serpent_cbc_dec_8way_avx_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(__serpent_decrypt) }
+		.fn_u = { .cbc = __serpent_decrypt_cbc_glue }
 	} }
 };
 
@@ -182,10 +166,10 @@ static const struct common_glue_ctx serpent_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_dec_8way_avx) }
+		.fn_u = { .xts = serpent_xts_dec_8way_avx_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_dec) }
+		.fn_u = { .xts = serpent_xts_dec }
 	} }
 };
 
@@ -201,8 +185,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(__serpent_encrypt),
-					   req);
+	return glue_cbc_encrypt_req_128bit(__serpent_encrypt_glue, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -221,8 +204,8 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct serpent_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&serpent_enc_xts, req,
-				   XTS_TWEAK_CAST(__serpent_encrypt),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx);
+			__serpent_encrypt_glue, &ctx->tweak_ctx,
+			&ctx->crypt_ctx);
 }
 
 static int xts_decrypt(struct skcipher_request *req)
@@ -231,8 +214,8 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct serpent_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&serpent_dec_xts, req,
-				   XTS_TWEAK_CAST(__serpent_encrypt),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx);
+			__serpent_encrypt_glue, &ctx->tweak_ctx,
+			&ctx->crypt_ctx);
 }
 
 static struct skcipher_alg serpent_algs[] = {
diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index 3dafe137596a..0ddaa0671a7e 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -40,6 +40,12 @@
 #include <asm/crypto/serpent-sse2.h>
 #include <asm/crypto/glue_helper.h>
 
+SERPENT_GLUE(__serpent_encrypt);
+SERPENT_GLUE(__serpent_decrypt);
+SERPENT_GLUE_CBC(__serpent_decrypt, __serpent_decrypt_cbc_glue);
+SERPENT_GLUE(serpent_enc_blk_xway);
+SERPENT_GLUE(serpent_dec_blk_xway);
+
 static int serpent_setkey_skcipher(struct crypto_skcipher *tfm,
 				   const u8 *key, unsigned int keylen)
 {
@@ -94,10 +100,10 @@ static const struct common_glue_ctx serpent_enc = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_enc_blk_xway) }
+		.fn_u = { .ecb = serpent_enc_blk_xway_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_encrypt) }
+		.fn_u = { .ecb = __serpent_encrypt_glue }
 	} }
 };
 
@@ -107,10 +113,10 @@ static const struct common_glue_ctx serpent_ctr = {
 
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
 
@@ -120,10 +126,10 @@ static const struct common_glue_ctx serpent_dec = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_dec_blk_xway) }
+		.fn_u = { .ecb = serpent_dec_blk_xway_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_decrypt) }
+		.fn_u = { .ecb = __serpent_decrypt_glue }
 	} }
 };
 
@@ -133,10 +139,10 @@ static const struct common_glue_ctx serpent_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(serpent_decrypt_cbc_xway) }
+		.fn_u = { .cbc = serpent_decrypt_cbc_xway }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(__serpent_decrypt) }
+		.fn_u = { .cbc = __serpent_decrypt_cbc_glue }
 	} }
 };
 
@@ -152,7 +158,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(__serpent_encrypt),
+	return glue_cbc_encrypt_req_128bit(__serpent_encrypt_glue,
 					   req);
 }
 
diff --git a/arch/x86/include/asm/crypto/serpent-avx.h b/arch/x86/include/asm/crypto/serpent-avx.h
index db7c9cc32234..314080cf63e0 100644
--- a/arch/x86/include/asm/crypto/serpent-avx.h
+++ b/arch/x86/include/asm/crypto/serpent-avx.h
@@ -15,20 +15,31 @@ struct serpent_xts_ctx {
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
+#define SERPENT_GLUE(func)						       \
+asmlinkage void func(struct serpent_ctx *ctx, u8 *dst, const u8 *src);	       \
+asmlinkage static inline void func ## _glue(void *ctx, u8 *dst, const u8 *src) \
+{ func((struct serpent_ctx *) ctx, dst, src); }
+
+#define SERPENT_GLUE_CBC(func, helper)					       \
+asmlinkage void func(struct serpent_ctx *ctx, u8 *dst, const u8 *src);	       \
+asmlinkage static inline void helper(void *ctx, u128 *dst, const u128 *src)    \
+{ func((struct serpent_ctx *) ctx, (u8 *) dst, (u8 *) src); }
+
+#define SERPENT_GLUE_CTR(func)						       \
+asmlinkage void func(struct serpent_ctx *ctx, u8 *dst, const u8 *src,          \
+		le128 *iv);						       \
+asmlinkage static inline void func ## _glue(void *ctx, u128 *dst,	       \
+		const u128 *src, le128 *iv)				       \
+{ func((struct serpent_ctx *) ctx, (u8 *) dst, (u8 *) src, iv); }
+
+#define SERPENT_GLUE_XTS(func) SERPENT_GLUE_CTR(func)
+
+SERPENT_GLUE(serpent_ecb_enc_8way_avx);
+SERPENT_GLUE(serpent_ecb_dec_8way_avx);
+SERPENT_GLUE_CBC(serpent_cbc_dec_8way_avx, serpent_cbc_dec_8way_avx_glue);
+SERPENT_GLUE_CTR(serpent_ctr_8way_avx);
+SERPENT_GLUE_XTS(serpent_xts_enc_8way_avx);
+SERPENT_GLUE_XTS(serpent_xts_dec_8way_avx);
 
 extern void __serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src,
 				le128 *iv);
diff --git a/arch/x86/include/asm/crypto/serpent-sse2.h b/arch/x86/include/asm/crypto/serpent-sse2.h
index 1a345e8a7496..fd82518869ba 100644
--- a/arch/x86/include/asm/crypto/serpent-sse2.h
+++ b/arch/x86/include/asm/crypto/serpent-sse2.h
@@ -5,6 +5,16 @@
 #include <linux/crypto.h>
 #include <crypto/serpent.h>
 
+#define SERPENT_GLUE(func)						       \
+asmlinkage void func(struct serpent_ctx *ctx, u8 *dst, const u8 *src);	       \
+asmlinkage static inline void func ## _glue(void *ctx, u8 *dst, const u8 *src) \
+{ func((struct serpent_ctx *) ctx, dst, src); }
+
+#define SERPENT_GLUE_CBC(func, helper)					       \
+asmlinkage void func(struct serpent_ctx *ctx, u8 *dst, const u8 *src);	       \
+asmlinkage static inline void helper(void *ctx, u128 *dst, const u128 *src)    \
+{ func((struct serpent_ctx *) ctx, (u8 *) dst, (u8 *) src); }
+
 #ifdef CONFIG_X86_32
 
 #define SERPENT_PARALLEL_BLOCKS 4
-- 
2.16.4
