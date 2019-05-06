From: Joao Moreira <jmoreira@suse.de>
Subject: [RFC PATCH v2 3/4] Fix twofish crypto functions prototype casts
Date: Mon,  6 May 2019 16:19:49 -0300
Message-Id: <20190506191950.9521-4-jmoreira@suse.de>
In-Reply-To: <20190506191950.9521-1-jmoreira@suse.de>
References: <20190506191950.9521-1-jmoreira@suse.de>
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Add macros that generate glue functions for twofish crypto functions.

Remove GLUE_FUNC_CAST macros from function pointer assignement and use
the helper instead, making the prototypes compliant.

RFC: twofish_enc_blk_ctr_3way is assigned both to .ecb and to .ctr,
what makes its declaration through the macro undoable, as thought in
this patch. Suggestions on how to fix this are welcome.

Signed-off-by: Joao Moreira <jmoreira@suse.de>
---
 arch/x86/crypto/twofish_avx_glue.c    | 65 ++++++++++++++++-------------------
 arch/x86/crypto/twofish_glue_3way.c   | 33 +++++++++---------
 arch/x86/include/asm/crypto/twofish.h | 33 +++++++++++++-----
 3 files changed, 71 insertions(+), 60 deletions(-)

diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index 66d989230d10..e895096fbc3b 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -37,20 +37,19 @@
 #define TWOFISH_PARALLEL_BLOCKS 8
 
 /* 8-way parallel cipher functions */
-asmlinkage void twofish_ecb_enc_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src);
-asmlinkage void twofish_ecb_dec_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src);
+TWOFISH_GLUE(twofish_ecb_enc_8way, twofish_ecb_enc_8way_glue);
+TWOFISH_GLUE(twofish_ecb_dec_8way, twofish_ecb_dec_8way_glue);
+TWOFISH_GLUE_CTR(twofish_ctr_8way, twofish_ctr_8way_glue);
+TWOFISH_GLUE_CTR(twofish_enc_blk_ctr, twofish_enc_blk_ctr_glue);
+TWOFISH_GLUE_XTS(twofish_xts_enc_8way, twofish_xts_enc_8way_glue);
+TWOFISH_GLUE_XTS(twofish_xts_dec_8way, twofish_xts_dec_8way_glue);
+TWOFISH_GLUE_CBC(twofish_cbc_dec_8way, twofish_cbc_dec_8way_glue);
 
 asmlinkage void twofish_cbc_dec_8way(struct twofish_ctx *ctx, u8 *dst,
 				     const u8 *src);
-asmlinkage void twofish_ctr_8way(struct twofish_ctx *ctx, u8 *dst,
-				 const u8 *src, le128 *iv);
 
-asmlinkage void twofish_xts_enc_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src, le128 *iv);
-asmlinkage void twofish_xts_dec_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src, le128 *iv);
+asmlinkage void twofish_xts_dec_8way(struct twofish_ctx *ctx, u128 *dst,
+				     const u128 *src, le128 *iv);
 
 static int twofish_setkey_skcipher(struct crypto_skcipher *tfm,
 				   const u8 *key, unsigned int keylen)
@@ -58,22 +57,19 @@ static int twofish_setkey_skcipher(struct crypto_skcipher *tfm,
 	return twofish_setkey(&tfm->base, key, keylen);
 }
 
-static inline void twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
-					const u8 *src)
+static inline void twofish_enc_blk_3way(void *ctx, u8 *dst, const u8 *src)
 {
-	__twofish_enc_blk_3way(ctx, dst, src, false);
+	__twofish_enc_blk_3way((struct twofish_ctx *) ctx, dst, src, false);
 }
 
 static void twofish_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(twofish_enc_blk));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, twofish_enc_blk_glue);
 }
 
 static void twofish_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(twofish_dec_blk));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, twofish_dec_blk_glue);
 }
 
 struct twofish_xts_ctx {
@@ -108,13 +104,13 @@ static const struct common_glue_ctx twofish_enc = {
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_ecb_enc_8way) }
+		.fn_u = { .ecb = twofish_ecb_enc_8way_glue }
 	}, {
 		.num_blocks = 3,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_3way) }
+		.fn_u = { .ecb = twofish_enc_blk_3way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk) }
+		.fn_u = { .ecb = twofish_enc_blk_glue }
 	} }
 };
 
@@ -124,13 +120,13 @@ static const struct common_glue_ctx twofish_ctr = {
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(twofish_ctr_8way) }
+		.fn_u = { .ctr = twofish_ctr_8way_glue }
 	}, {
 		.num_blocks = 3,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(twofish_enc_blk_ctr_3way) }
+		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(twofish_enc_blk_ctr_3way)}
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(twofish_enc_blk_ctr) }
+		.fn_u = { .ctr = twofish_enc_blk_ctr_glue }
 	} }
 };
 
@@ -140,10 +136,10 @@ static const struct common_glue_ctx twofish_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(twofish_xts_enc_8way) }
+		.fn_u = { .xts = twofish_xts_enc_8way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(twofish_xts_enc) }
+		.fn_u = { .xts = twofish_xts_enc }
 	} }
 };
 
@@ -153,13 +149,13 @@ static const struct common_glue_ctx twofish_dec = {
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_ecb_dec_8way) }
+		.fn_u = { .ecb = twofish_ecb_dec_8way_glue }
 	}, {
 		.num_blocks = 3,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk_3way) }
+		.fn_u = { .ecb = twofish_dec_blk_3way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk) }
+		.fn_u = { .ecb = twofish_dec_blk_glue }
 	} }
 };
 
@@ -169,13 +165,13 @@ static const struct common_glue_ctx twofish_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_cbc_dec_8way) }
+		.fn_u = { .cbc = twofish_cbc_dec_8way_glue }
 	}, {
 		.num_blocks = 3,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk_cbc_3way) }
+		.fn_u = { .cbc = twofish_dec_blk_cbc_3way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk) }
+		.fn_u = { .cbc = twofish_dec_blk_cbc_glue }
 	} }
 };
 
@@ -185,10 +181,10 @@ static const struct common_glue_ctx twofish_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(twofish_xts_dec_8way) }
+		.fn_u = { .xts = twofish_xts_dec_8way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(twofish_xts_dec) }
+		.fn_u = { .xts = twofish_xts_dec }
 	} }
 };
 
@@ -204,8 +200,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(twofish_enc_blk),
-					   req);
+	return glue_cbc_encrypt_req_128bit(twofish_enc_blk_glue, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 571485502ec8..0b10c5b3f486 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -31,6 +31,8 @@
 #include <linux/module.h>
 #include <linux/types.h>
 
+TWOFISH_GLUE_CTR(twofish_enc_blk_ctr, twofish_enc_blk_ctr_glue)
+
 EXPORT_SYMBOL_GPL(__twofish_enc_blk_3way);
 EXPORT_SYMBOL_GPL(twofish_dec_blk_3way);
 
@@ -40,10 +42,9 @@ static int twofish_setkey_skcipher(struct crypto_skcipher *tfm,
 	return twofish_setkey(&tfm->base, key, keylen);
 }
 
-static inline void twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
-					const u8 *src)
+static inline void twofish_enc_blk_3way(void *ctx, u8 *dst, const u8 *src)
 {
-	__twofish_enc_blk_3way(ctx, dst, src, false);
+	__twofish_enc_blk_3way((struct twofish_ctx *) ctx, dst, src, false);
 }
 
 static inline void twofish_enc_blk_xor_3way(struct twofish_ctx *ctx, u8 *dst,
@@ -66,7 +67,8 @@ void twofish_dec_blk_cbc_3way(void *ctx, u128 *dst, const u128 *src)
 }
 EXPORT_SYMBOL_GPL(twofish_dec_blk_cbc_3way);
 
-void twofish_enc_blk_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+void twofish_enc_blk_ctr(struct twofish_ctx *ctx, u128 *dst, const u128 *src,
+		le128 *iv)
 {
 	be128 ctrblk;
 
@@ -81,8 +83,8 @@ void twofish_enc_blk_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 }
 EXPORT_SYMBOL_GPL(twofish_enc_blk_ctr);
 
-void twofish_enc_blk_ctr_3way(void *ctx, u128 *dst, const u128 *src,
-			      le128 *iv)
+void twofish_enc_blk_ctr_3way(void *ctx, u128 *dst,
+		const u128 *src, le128 *iv)
 {
 	be128 ctrblks[3];
 
@@ -109,10 +111,10 @@ static const struct common_glue_ctx twofish_enc = {
 
 	.funcs = { {
 		.num_blocks = 3,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_3way) }
+		.fn_u = { .ecb = twofish_enc_blk_3way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk) }
+		.fn_u = { .ecb = twofish_enc_blk_glue }
 	} }
 };
 
@@ -122,10 +124,10 @@ static const struct common_glue_ctx twofish_ctr = {
 
 	.funcs = { {
 		.num_blocks = 3,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_ctr_3way) }
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_ctr_3way)}
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_ctr) }
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_ctr)}
 	} }
 };
 
@@ -135,10 +137,10 @@ static const struct common_glue_ctx twofish_dec = {
 
 	.funcs = { {
 		.num_blocks = 3,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk_3way) }
+		.fn_u = { .ecb = twofish_dec_blk_3way_glue}
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk) }
+		.fn_u = { .ecb = twofish_dec_blk_glue}
 	} }
 };
 
@@ -148,10 +150,10 @@ static const struct common_glue_ctx twofish_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = 3,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk_cbc_3way) }
+		.fn_u = { .cbc = twofish_dec_blk_cbc_3way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk) }
+		.fn_u = { .cbc = twofish_dec_blk_cbc_glue }
 	} }
 };
 
@@ -167,8 +169,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(twofish_enc_blk),
-					   req);
+	return glue_cbc_encrypt_req_128bit(twofish_enc_blk_glue, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
diff --git a/arch/x86/include/asm/crypto/twofish.h b/arch/x86/include/asm/crypto/twofish.h
index f618bf272b90..fe52a06a734a 100644
--- a/arch/x86/include/asm/crypto/twofish.h
+++ b/arch/x86/include/asm/crypto/twofish.h
@@ -6,22 +6,37 @@
 #include <crypto/twofish.h>
 #include <crypto/b128ops.h>
 
-/* regular block cipher functions from twofish_x86_64 module */
-asmlinkage void twofish_enc_blk(struct twofish_ctx *ctx, u8 *dst,
-				const u8 *src);
-asmlinkage void twofish_dec_blk(struct twofish_ctx *ctx, u8 *dst,
-				const u8 *src);
+#define TWOFISH_GLUE(func, helper)					       \
+asmlinkage void func(struct twofish_ctx *ctx, u8 *dst, const u8 *src);	       \
+asmlinkage static inline void helper(void *ctx, u8 *dst, const u8 *src)	       \
+{ func((struct twofish_ctx *) ctx, dst, src); }
+
+#define TWOFISH_GLUE_CBC(func, helper)					       \
+asmlinkage void func(struct twofish_ctx *ctx, u8 *dst, const u8 *src);	       \
+asmlinkage static inline void helper(void *ctx, u128 *dst,		       \
+		const u128 *src)					       \
+{ func((struct twofish_ctx *) ctx, (u8 *) dst, (u8 *) src); }
+
+#define TWOFISH_GLUE_CTR(func, helper)					       \
+asmlinkage void func(struct twofish_ctx *ctx, u128 *dst, const u128 *src,      \
+		le128 *iv);						       \
+asmlinkage static inline void helper(void *ctx, u128 *dst,		       \
+		const u128 *src, le128 *iv)				       \
+{ func((struct twofish_ctx *) ctx, dst, src, iv); }
+
+#define TWOFISH_GLUE_XTS(func, helper) TWOFISH_GLUE_CTR(func, helper)
+
+TWOFISH_GLUE(twofish_enc_blk, twofish_enc_blk_glue);
+TWOFISH_GLUE(twofish_dec_blk, twofish_dec_blk_glue);
+TWOFISH_GLUE_CBC(twofish_dec_blk, twofish_dec_blk_cbc_glue);
+TWOFISH_GLUE(twofish_dec_blk_3way, twofish_dec_blk_3way_glue)
 
 /* 3-way parallel cipher functions */
 asmlinkage void __twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
 				       const u8 *src, bool xor);
-asmlinkage void twofish_dec_blk_3way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src);
 
 /* helpers from twofish_x86_64-3way module */
 extern void twofish_dec_blk_cbc_3way(void *ctx, u128 *dst, const u128 *src);
-extern void twofish_enc_blk_ctr(void *ctx, u128 *dst, const u128 *src,
-				le128 *iv);
 extern void twofish_enc_blk_ctr_3way(void *ctx, u128 *dst, const u128 *src,
 				     le128 *iv);
 
-- 
2.16.4
