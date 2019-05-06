From: Joao Moreira <jmoreira@suse.de>
Subject: [RFC PATCH v2 2/4] Fix camellia crypto functions prototype casts
Date: Mon,  6 May 2019 16:19:48 -0300
Message-Id: <20190506191950.9521-3-jmoreira@suse.de>
In-Reply-To: <20190506191950.9521-1-jmoreira@suse.de>
References: <20190506191950.9521-1-jmoreira@suse.de>
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Add macros that generate glue functions for camellia crypto functions.

Remove GLUE_FUNC_CAST macros from function pointer assignement and use
the helper instead, making the prototypes compliant.

Signed-off-by: Joao Moreira <jmoreira@suse.de>
---
 arch/x86/crypto/camellia_aesni_avx2_glue.c | 69 ++++++++--------------
 arch/x86/crypto/camellia_aesni_avx_glue.c  | 45 +++++++--------
 arch/x86/crypto/camellia_glue.c            | 19 +++---
 arch/x86/include/asm/crypto/camellia.h     | 93 +++++++++++++++---------------
 4 files changed, 101 insertions(+), 125 deletions(-)

diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
index d4992e458f92..6893d3299103 100644
--- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
@@ -23,38 +23,22 @@
 #define CAMELLIA_AESNI_PARALLEL_BLOCKS 16
 #define CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS 32
 
-/* 32-way AVX2/AES-NI parallel cipher functions */
-asmlinkage void camellia_ecb_enc_32way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
-asmlinkage void camellia_ecb_dec_32way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
-
-asmlinkage void camellia_cbc_dec_32way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
-asmlinkage void camellia_ctr_32way(struct camellia_ctx *ctx, u8 *dst,
-				   const u8 *src, le128 *iv);
-
-asmlinkage void camellia_xts_enc_32way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src, le128 *iv);
-asmlinkage void camellia_xts_dec_32way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src, le128 *iv);
-
 static const struct common_glue_ctx camellia_enc = {
 	.num_funcs = 4,
 	.fpu_blocks_limit = CAMELLIA_AESNI_PARALLEL_BLOCKS,
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_enc_32way) }
+		.fn_u = { .ecb = camellia_ecb_enc_32way_glue }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_enc_16way) }
+		.fn_u = { .ecb = camellia_ecb_enc_16way_glue }
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
 
@@ -64,16 +48,16 @@ static const struct common_glue_ctx camellia_ctr = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_ctr_32way) }
+		.fn_u = { .ctr = camellia_ctr_32way_glue }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_ctr_16way) }
+		.fn_u = { .ctr = camellia_ctr_16way_glue }
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
 
@@ -83,13 +67,13 @@ static const struct common_glue_ctx camellia_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_enc_32way) }
+		.fn_u = { .xts = camellia_xts_enc_32way_glue }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_enc_16way) }
+		.fn_u = { .xts = camellia_xts_enc_16way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_enc) }
+		.fn_u = { .xts = camellia_xts_enc }
 	} }
 };
 
@@ -99,16 +83,16 @@ static const struct common_glue_ctx camellia_dec = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_dec_32way) }
+		.fn_u = { .ecb = camellia_ecb_dec_32way_glue }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_dec_16way) }
+		.fn_u = { .ecb = camellia_ecb_dec_16way_glue }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk_2way) }
+		.fn_u = { .ecb = camellia_dec_blk_2way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .ecb = camellia_dec_blk_glue }
 	} }
 };
 
@@ -118,16 +102,16 @@ static const struct common_glue_ctx camellia_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_cbc_dec_32way) }
+		.fn_u = { .cbc = camellia_cbc_dec_32way_glue }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_cbc_dec_16way) }
+		.fn_u = { .cbc = camellia_cbc_dec_16way_glue }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_decrypt_cbc_2way) }
+		.fn_u = { .cbc = camellia_decrypt_cbc_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .cbc = camellia_dec_cbc_blk_glue }
 	} }
 };
 
@@ -137,13 +121,13 @@ static const struct common_glue_ctx camellia_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_dec_32way) }
+		.fn_u = { .xts = camellia_xts_dec_32way_glue }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_dec_16way) }
+		.fn_u = { .xts = camellia_xts_dec_16way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_dec) }
+		.fn_u = { .xts = camellia_xts_dec }
 	} }
 };
 
@@ -166,8 +150,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(camellia_enc_blk),
-					   req);
+	return glue_cbc_encrypt_req_128bit(camellia_enc_blk, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -185,8 +168,7 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct camellia_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&camellia_enc_xts, req,
-				   XTS_TWEAK_CAST(camellia_enc_blk),
+	return glue_xts_req_128bit(&camellia_enc_xts, req, camellia_enc_blk,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx);
 }
 
@@ -195,8 +177,7 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct camellia_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&camellia_dec_xts, req,
-				   XTS_TWEAK_CAST(camellia_enc_blk),
+	return glue_xts_req_128bit(&camellia_dec_xts, req, camellia_enc_blk,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx);
 }
 
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
index d09f6521466a..eaf03bc6e89f 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -49,15 +49,13 @@ EXPORT_SYMBOL_GPL(camellia_xts_dec_16way);
 
 void camellia_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(camellia_enc_blk));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, camellia_enc_blk);
 }
 EXPORT_SYMBOL_GPL(camellia_xts_enc);
 
 void camellia_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(camellia_dec_blk));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, camellia_dec_blk_glue);
 }
 EXPORT_SYMBOL_GPL(camellia_xts_dec);
 
@@ -67,13 +65,13 @@ static const struct common_glue_ctx camellia_enc = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_enc_16way) }
+		.fn_u = { .ecb = camellia_ecb_enc_16way_glue }
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
 
@@ -83,13 +81,13 @@ static const struct common_glue_ctx camellia_ctr = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_ctr_16way) }
+		.fn_u = { .ctr = camellia_ctr_16way_glue }
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
 
@@ -99,10 +97,10 @@ static const struct common_glue_ctx camellia_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_enc_16way) }
+		.fn_u = { .xts = camellia_xts_enc_16way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_enc) }
+		.fn_u = { .xts = camellia_xts_enc }
 	} }
 };
 
@@ -112,13 +110,13 @@ static const struct common_glue_ctx camellia_dec = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_dec_16way) }
+		.fn_u = { .ecb = camellia_ecb_dec_16way_glue }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk_2way) }
+		.fn_u = { .ecb = camellia_dec_blk_2way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .ecb = camellia_dec_blk_glue }
 	} }
 };
 
@@ -128,13 +126,13 @@ static const struct common_glue_ctx camellia_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_cbc_dec_16way) }
+		.fn_u = { .cbc = camellia_cbc_dec_16way_glue }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_decrypt_cbc_2way) }
+		.fn_u = { .cbc = camellia_decrypt_cbc_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .cbc = camellia_dec_cbc_blk_glue }
 	} }
 };
 
@@ -144,10 +142,10 @@ static const struct common_glue_ctx camellia_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_dec_16way) }
+		.fn_u = { .xts = camellia_xts_dec_16way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_dec) }
+		.fn_u = { .xts = camellia_xts_dec }
 	} }
 };
 
@@ -170,8 +168,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(camellia_enc_blk),
-					   req);
+	return glue_cbc_encrypt_req_128bit(camellia_enc_blk, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -212,7 +209,7 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct camellia_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&camellia_enc_xts, req,
-				   XTS_TWEAK_CAST(camellia_enc_blk),
+				   camellia_enc_blk,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx);
 }
 
@@ -222,7 +219,7 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct camellia_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&camellia_dec_xts, req,
-				   XTS_TWEAK_CAST(camellia_enc_blk),
+				   camellia_enc_blk,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx);
 }
 
diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index dcd5e0f71b00..f4374044f6ee 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -1330,10 +1330,10 @@ static const struct common_glue_ctx camellia_enc = {
 
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
 
@@ -1343,10 +1343,10 @@ static const struct common_glue_ctx camellia_ctr = {
 
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
 
@@ -1356,10 +1356,10 @@ static const struct common_glue_ctx camellia_dec = {
 
 	.funcs = { {
 		.num_blocks = 2,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk_2way) }
+		.fn_u = { .ecb = camellia_dec_blk_2way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .ecb = camellia_dec_blk_glue }
 	} }
 };
 
@@ -1369,10 +1369,10 @@ static const struct common_glue_ctx camellia_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = 2,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_decrypt_cbc_2way) }
+		.fn_u = { .cbc = camellia_decrypt_cbc_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .cbc = camellia_dec_cbc_blk_glue }
 	} }
 };
 
@@ -1388,8 +1388,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(camellia_enc_blk),
-					   req);
+	return glue_cbc_encrypt_req_128bit(camellia_enc_blk, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
diff --git a/arch/x86/include/asm/crypto/camellia.h b/arch/x86/include/asm/crypto/camellia.h
index a5d86fc0593f..4daf9f3472f9 100644
--- a/arch/x86/include/asm/crypto/camellia.h
+++ b/arch/x86/include/asm/crypto/camellia.h
@@ -24,6 +24,30 @@ struct camellia_xts_ctx {
 	struct camellia_ctx crypt_ctx;
 };
 
+#define CAMELLIA_GLUE_XOR(func, helper, x)				       \
+asmlinkage void func(struct camellia_ctx *ctx, u8 *dst, const u8 *src, bool y);\
+asmlinkage static inline void helper(void *ctx, u8 *dst, const u8 *src)	       \
+{ func((struct camellia_ctx *) ctx, dst, src, x); }
+
+#define CAMELLIA_GLUE(func)						       \
+asmlinkage void func(struct camellia_ctx *ctx, u8 *dst, const u8 *src);	       \
+asmlinkage static inline void func ## _glue(void *ctx, u8 *dst, const u8 *src) \
+{ func((struct camellia_ctx *) ctx, dst, src); }
+
+#define CAMELLIA_GLUE_CBC(func, helper)					       \
+asmlinkage void func(struct camellia_ctx *ctx, u8 *dst, const u8 *src);	       \
+asmlinkage static inline void helper(void *ctx, u128 *dst, const u128 *src)    \
+{ func((struct camellia_ctx *) ctx, (u8 *) dst, (u8 *) src); }
+
+#define CAMELLIA_GLUE_CTR(func)						       \
+asmlinkage void func(struct camellia_ctx *ctx, u8 *dst, const u8 *src,	       \
+		le128 *iv);						       \
+asmlinkage static inline void func ## _glue(void *ctx, u128 *dst,	       \
+		const u128 *src, le128 *iv)				       \
+{ func((struct camellia_ctx *) ctx, (u8 *) dst, (u8 *) src, iv); }
+
+#define CAMELLIA_GLUE_XTS(func) CAMELLIA_GLUE_CTR(func)
+
 extern int __camellia_setkey(struct camellia_ctx *cctx,
 			     const unsigned char *key,
 			     unsigned int key_len, u32 *flags);
@@ -32,64 +56,39 @@ extern int xts_camellia_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			       unsigned int keylen);
 
 /* regular block cipher functions */
-asmlinkage void __camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
-				   const u8 *src, bool xor);
-asmlinkage void camellia_dec_blk(struct camellia_ctx *ctx, u8 *dst,
-				 const u8 *src);
+CAMELLIA_GLUE_XOR(__camellia_enc_blk, camellia_enc_blk, false);
+CAMELLIA_GLUE_XOR(__camellia_enc_blk, camellia_enc_blk_xor, true);
+CAMELLIA_GLUE(camellia_dec_blk);
+CAMELLIA_GLUE_CBC(camellia_dec_blk, camellia_dec_cbc_blk_glue);
 
 /* 2-way parallel cipher functions */
-asmlinkage void __camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *dst,
-					const u8 *src, bool xor);
-asmlinkage void camellia_dec_blk_2way(struct camellia_ctx *ctx, u8 *dst,
-				      const u8 *src);
+CAMELLIA_GLUE_XOR(__camellia_enc_blk_2way, camellia_enc_blk_2way, false);
+CAMELLIA_GLUE_XOR(__camellia_enc_blk_2way, camellia_enc_blk_xor_2way, true);
+CAMELLIA_GLUE(camellia_dec_blk_2way);
 
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
-{
-	__camellia_enc_blk(ctx, dst, src, false);
-}
-
-static inline void camellia_enc_blk_xor(struct camellia_ctx *ctx, u8 *dst,
-					const u8 *src)
-{
-	__camellia_enc_blk(ctx, dst, src, true);
-}
-
-static inline void camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *dst,
-					 const u8 *src)
-{
-	__camellia_enc_blk_2way(ctx, dst, src, false);
-}
-
-static inline void camellia_enc_blk_xor_2way(struct camellia_ctx *ctx, u8 *dst,
-					     const u8 *src)
-{
-	__camellia_enc_blk_2way(ctx, dst, src, true);
-}
+CAMELLIA_GLUE(camellia_ecb_enc_16way);
+CAMELLIA_GLUE(camellia_ecb_dec_16way);
+CAMELLIA_GLUE_CBC(camellia_cbc_dec_16way, camellia_cbc_dec_16way_glue);
+CAMELLIA_GLUE_CTR(camellia_ctr_16way);
+CAMELLIA_GLUE_XTS(camellia_xts_enc_16way);
+CAMELLIA_GLUE_XTS(camellia_xts_dec_16way);
+
+/* 32-way AVX2/AES-NI parallel cipher functions */
+CAMELLIA_GLUE(camellia_ecb_enc_32way);
+CAMELLIA_GLUE(camellia_ecb_dec_32way);
+CAMELLIA_GLUE_CBC(camellia_cbc_dec_32way, camellia_cbc_dec_32way_glue);
+CAMELLIA_GLUE_CTR(camellia_ctr_32way);
+CAMELLIA_GLUE_XTS(camellia_xts_enc_32way);
+CAMELLIA_GLUE_XTS(camellia_xts_dec_32way);
 
 /* glue helpers */
 extern void camellia_decrypt_cbc_2way(void *ctx, u128 *dst, const u128 *src);
 extern void camellia_crypt_ctr(void *ctx, u128 *dst, const u128 *src,
 			       le128 *iv);
+
 extern void camellia_crypt_ctr_2way(void *ctx, u128 *dst, const u128 *src,
 				    le128 *iv);
-
 extern void camellia_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv);
 extern void camellia_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv);
 
-- 
2.16.4
