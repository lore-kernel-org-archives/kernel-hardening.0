From: Joao Moreira <jmoreira@suse.de>
Subject: [RFC PATCH v2 4/4] Fix cast6 crypto functions prototype casts
Date: Mon,  6 May 2019 16:19:50 -0300
Message-Id: <20190506191950.9521-5-jmoreira@suse.de>
In-Reply-To: <20190506191950.9521-1-jmoreira@suse.de>
References: <20190506191950.9521-1-jmoreira@suse.de>
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Add macros that generate glue functions for cast6 crypto functions.

Remove GLUE_FUNC_CAST macros from function pointer assignement and use
the helper instead, making the prototypes compliant.

Signed-off-by: Joao Moreira <jmoreira@suse.de>
---
 arch/x86/crypto/cast6_avx_glue.c | 54 ++++++++++++++++------------------------
 include/crypto/cast6.h           | 23 +++++++++++++++--
 2 files changed, 43 insertions(+), 34 deletions(-)

diff --git a/arch/x86/crypto/cast6_avx_glue.c b/arch/x86/crypto/cast6_avx_glue.c
index 18965c39305e..7f156fc02422 100644
--- a/arch/x86/crypto/cast6_avx_glue.c
+++ b/arch/x86/crypto/cast6_avx_glue.c
@@ -35,20 +35,13 @@
 
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
+CAST6_GLUE(cast6_ecb_enc_8way);
+CAST6_GLUE(cast6_ecb_dec_8way);
+CAST6_GLUE_CTR(cast6_ctr_8way);
+CAST6_GLUE_XTS(cast6_xts_enc_8way);
+CAST6_GLUE_XTS(cast6_xts_dec_8way);
+CAST6_GLUE_CBC(cast6_cbc_dec_8way, cast6_cbc_dec_8way_glue);
+CAST6_GLUE_CBC(__cast6_decrypt, __cast6_decrypt_cbc_glue);
 
 static int cast6_setkey_skcipher(struct crypto_skcipher *tfm,
 				 const u8 *key, unsigned int keylen)
@@ -58,14 +51,12 @@ static int cast6_setkey_skcipher(struct crypto_skcipher *tfm,
 
 static void cast6_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(__cast6_encrypt));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, __cast6_encrypt_glue);
 }
 
 static void cast6_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(__cast6_decrypt));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, __cast6_decrypt_glue);
 }
 
 static void cast6_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
@@ -85,10 +76,10 @@ static const struct common_glue_ctx cast6_enc = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(cast6_ecb_enc_8way) }
+		.fn_u = { .ecb = cast6_ecb_enc_8way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__cast6_encrypt) }
+		.fn_u = { .ecb = __cast6_encrypt_glue }
 	} }
 };
 
@@ -98,10 +89,10 @@ static const struct common_glue_ctx cast6_ctr = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(cast6_ctr_8way) }
+		.fn_u = { .ctr = cast6_ctr_8way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(cast6_crypt_ctr) }
+		.fn_u = { .ctr = cast6_crypt_ctr }
 	} }
 };
 
@@ -111,10 +102,10 @@ static const struct common_glue_ctx cast6_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(cast6_xts_enc_8way) }
+		.fn_u = { .xts = cast6_xts_enc_8way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(cast6_xts_enc) }
+		.fn_u = { .xts = cast6_xts_enc }
 	} }
 };
 
@@ -124,10 +115,10 @@ static const struct common_glue_ctx cast6_dec = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(cast6_ecb_dec_8way) }
+		.fn_u = { .ecb = cast6_ecb_dec_8way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__cast6_decrypt) }
+		.fn_u = { .ecb = __cast6_decrypt_glue }
 	} }
 };
 
@@ -137,10 +128,10 @@ static const struct common_glue_ctx cast6_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(cast6_cbc_dec_8way) }
+		.fn_u = { .cbc = cast6_cbc_dec_8way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(__cast6_decrypt) }
+		.fn_u = { .cbc = __cast6_decrypt_cbc_glue }
 	} }
 };
 
@@ -150,10 +141,10 @@ static const struct common_glue_ctx cast6_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(cast6_xts_dec_8way) }
+		.fn_u = { .xts = cast6_xts_dec_8way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(cast6_xts_dec) }
+		.fn_u = { .xts = cast6_xts_dec }
 	} }
 };
 
@@ -169,8 +160,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(__cast6_encrypt),
-					   req);
+	return glue_cbc_encrypt_req_128bit(__cast6_encrypt_glue, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
diff --git a/include/crypto/cast6.h b/include/crypto/cast6.h
index c71f6ef47f0f..0b4970a769c4 100644
--- a/include/crypto/cast6.h
+++ b/include/crypto/cast6.h
@@ -10,6 +10,25 @@
 #define CAST6_MIN_KEY_SIZE 16
 #define CAST6_MAX_KEY_SIZE 32
 
+#define CAST6_GLUE(func)						       \
+asmlinkage void func(struct cast6_ctx *ctx, u8 *dst, const u8 *src);	       \
+asmlinkage static inline void func ## _glue(void *ctx, u8 *dst, const u8 *src) \
+{ func((struct cast6_ctx *) ctx, dst, src); }
+
+#define CAST6_GLUE_CBC(func, helper)					       \
+asmlinkage void func(struct cast6_ctx *ctx, u8 *dst, const u8 *src);	       \
+asmlinkage static inline void helper(void *ctx, u128 *dst, const u128 *src)    \
+{ func((struct cast6_ctx *) ctx, (u8 *) dst, (u8 *) src); }
+
+#define CAST6_GLUE_CTR(func)						       \
+asmlinkage void func(struct cast6_ctx *ctx, u8 *dst, const u8 *src, le128 *iv);\
+asmlinkage static inline void func ## _glue(void *ctx, u128 *dst,	       \
+		const u128 *src, le128 *iv)				       \
+{ func((struct cast6_ctx *) ctx, (u8 *) dst, (u8 *) src, iv); }
+
+#define CAST6_GLUE_XTS(func) CAST6_GLUE_CTR(func)
+
+
 struct cast6_ctx {
 	u32 Km[12][4];
 	u8 Kr[12][4];
@@ -19,7 +38,7 @@ int __cast6_setkey(struct cast6_ctx *ctx, const u8 *key,
 		   unsigned int keylen, u32 *flags);
 int cast6_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen);
 
-void __cast6_encrypt(struct cast6_ctx *ctx, u8 *dst, const u8 *src);
-void __cast6_decrypt(struct cast6_ctx *ctx, u8 *dst, const u8 *src);
+CAST6_GLUE(__cast6_encrypt);
+CAST6_GLUE(__cast6_decrypt);
 
 #endif
-- 
2.16.4
