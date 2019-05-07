From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v3 6/7] crypto: x86/aesni: Use new glue function macros
Date: Tue,  7 May 2019 09:13:20 -0700
Message-Id: <20190507161321.34611-7-keescook@chromium.org>
In-Reply-To: <20190507161321.34611-1-keescook@chromium.org>
References: <20190507161321.34611-1-keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <keescook@chromium.org>, Joao Moreira <jmoreira@suse.de>, Eric Biggers <ebiggers@google.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Convert to function declaration macros from function prototype casts
to avoid trigger Control-Flow Integrity checks during indirect function
calls.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/crypto/aesni-intel_glue.c | 31 ++++++++++++------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 1e3d2102033a..350286235a47 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -39,9 +39,7 @@
 #include <crypto/internal/skcipher.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
-#ifdef CONFIG_X86_64
 #include <asm/crypto/glue_helper.h>
-#endif
 
 
 #define AESNI_ALIGN	16
@@ -52,6 +50,8 @@
 #define CRYPTO_AES_CTX_SIZE (sizeof(struct crypto_aes_ctx) + AESNI_ALIGN_EXTRA)
 #define XTS_AES_CTX_SIZE (sizeof(struct aesni_xts_ctx) + AESNI_ALIGN_EXTRA)
 
+#define AESNI_GLUE(func)       GLUE_CAST(func, crypto_aes_ctx)
+
 /* This data is stored at the end of the crypto_tfm struct.
  * It's a type of per "session" data storage location.
  * This needs to be 16 byte aligned.
@@ -89,10 +89,8 @@ struct gcm_context_data {
 
 asmlinkage int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 			     unsigned int key_len);
-asmlinkage void aesni_enc(struct crypto_aes_ctx *ctx, u8 *out,
-			  const u8 *in);
-asmlinkage void aesni_dec(struct crypto_aes_ctx *ctx, u8 *out,
-			  const u8 *in);
+AESNI_GLUE(aesni_enc);
+AESNI_GLUE(aesni_dec);
 asmlinkage void aesni_ecb_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len);
 asmlinkage void aesni_ecb_dec(struct crypto_aes_ctx *ctx, u8 *out,
@@ -570,19 +568,14 @@ static int xts_aesni_setkey(struct crypto_skcipher *tfm, const u8 *key,
 }
 
 
-static void aesni_xts_tweak(void *ctx, u8 *out, const u8 *in)
-{
-	aesni_enc(ctx, out, in);
-}
-
 static void aesni_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv, GLUE_FUNC_CAST(aesni_enc));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, aesni_enc_glue);
 }
 
 static void aesni_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv, GLUE_FUNC_CAST(aesni_dec));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, aesni_dec_glue);
 }
 
 static void aesni_xts_enc8(void *ctx, u128 *dst, const u128 *src, le128 *iv)
@@ -601,10 +594,10 @@ static const struct common_glue_ctx aesni_enc_xts = {
 
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
 
@@ -614,10 +607,10 @@ static const struct common_glue_ctx aesni_dec_xts = {
 
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
 
@@ -627,7 +620,7 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&aesni_enc_xts, req,
-				   XTS_TWEAK_CAST(aesni_xts_tweak),
+				   aesni_enc_glue,
 				   aes_ctx(ctx->raw_tweak_ctx),
 				   aes_ctx(ctx->raw_crypt_ctx));
 }
@@ -638,7 +631,7 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&aesni_dec_xts, req,
-				   XTS_TWEAK_CAST(aesni_xts_tweak),
+				   aesni_enc_glue,
 				   aes_ctx(ctx->raw_tweak_ctx),
 				   aes_ctx(ctx->raw_crypt_ctx));
 }
-- 
2.17.1
