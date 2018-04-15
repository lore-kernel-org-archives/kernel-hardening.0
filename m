From: Joao Moreira <jmoreira@suse.de>
Subject: [PATCH 1/4] x86/crypto: camellia: Fix function prototypes
Date: Sun, 15 Apr 2018 01:15:39 -0300
Message-Id: <20180415041542.5364-2-jmoreira@suse.de>
In-Reply-To: <20180415041542.5364-1-jmoreira@suse.de>
References: <20180415041542.5364-1-jmoreira@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Convert the use of 'struct camellia_ctx *' to 'void *' in prototypes of
functions which are referenced through 'struct common_glue_func_entry',
making their prototypes match those of this struct and, consequently,
turning them compatible with CFI requirements.

Whenever needed, cast 'void *' to 'struct camellia_ctx *'.

Signed-off-by: João Moreira <jmoreira@suse.de>
---
 arch/x86/crypto/camellia_aesni_avx2_glue.c | 25 ++++++++---------
 arch/x86/crypto/camellia_aesni_avx_glue.c  | 21 +++++++--------
 arch/x86/crypto/camellia_glue.c            |  6 ++---
 arch/x86/include/asm/crypto/camellia.h     | 43 +++++++++++++-----------------
 4 files changed, 40 insertions(+), 55 deletions(-)

diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
index 60907c139c4e..6fe248ee5efa 100644
--- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
@@ -27,20 +27,17 @@
 #define CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS 32
 
 /* 32-way AVX2/AES-NI parallel cipher functions */
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
+asmlinkage void camellia_ecb_enc_32way(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_ecb_dec_32way(void *ctx, u8 *dst, const u8 *src);
+
+asmlinkage void camellia_cbc_dec_32way(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_ctr_32way(void *ctx, u8 *dst, const u8 *src,
+				   le128 *iv);
+
+asmlinkage void camellia_xts_enc_32way(void *ctx, u8 *dst, const u8 *src,
+				       le128 *iv);
+asmlinkage void camellia_xts_dec_32way(void *ctx, u8 *dst, const u8 *src,
+				       le128 *iv);
 
 static const struct common_glue_ctx camellia_enc = {
 	.num_funcs = 4,
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
index d96429da88eb..3ccfd75b4af4 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -26,28 +26,25 @@
 #define CAMELLIA_AESNI_PARALLEL_BLOCKS 16
 
 /* 16-way parallel cipher functions (avx/aes-ni) */
-asmlinkage void camellia_ecb_enc_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
+asmlinkage void camellia_ecb_enc_16way(void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_ecb_enc_16way);
 
-asmlinkage void camellia_ecb_dec_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
+asmlinkage void camellia_ecb_dec_16way(void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_ecb_dec_16way);
 
-asmlinkage void camellia_cbc_dec_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
+asmlinkage void camellia_cbc_dec_16way(void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_cbc_dec_16way);
 
-asmlinkage void camellia_ctr_16way(struct camellia_ctx *ctx, u8 *dst,
-				   const u8 *src, le128 *iv);
+asmlinkage void camellia_ctr_16way(void *ctx, u8 *dst, const u8 *src,
+				   le128 *iv);
 EXPORT_SYMBOL_GPL(camellia_ctr_16way);
 
-asmlinkage void camellia_xts_enc_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src, le128 *iv);
+asmlinkage void camellia_xts_enc_16way(void *ctx, u8 *dst, const u8 *src,
+				       le128 *iv);
 EXPORT_SYMBOL_GPL(camellia_xts_enc_16way);
 
-asmlinkage void camellia_xts_dec_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src, le128 *iv);
+asmlinkage void camellia_xts_dec_16way(void *ctx, u8 *dst, const u8 *src,
+				       le128 *iv);
 EXPORT_SYMBOL_GPL(camellia_xts_dec_16way);
 
 void camellia_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index af4840ab2a3d..0942b3998de5 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -39,16 +39,14 @@
 asmlinkage void __camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
 				   const u8 *src, bool xor);
 EXPORT_SYMBOL_GPL(__camellia_enc_blk);
-asmlinkage void camellia_dec_blk(struct camellia_ctx *ctx, u8 *dst,
-				 const u8 *src);
+asmlinkage void camellia_dec_blk(void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_dec_blk);
 
 /* 2-way parallel cipher functions */
 asmlinkage void __camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *dst,
 					const u8 *src, bool xor);
 EXPORT_SYMBOL_GPL(__camellia_enc_blk_2way);
-asmlinkage void camellia_dec_blk_2way(struct camellia_ctx *ctx, u8 *dst,
-				      const u8 *src);
+asmlinkage void camellia_dec_blk_2way(void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_dec_blk_2way);
 
 static void camellia_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
diff --git a/arch/x86/include/asm/crypto/camellia.h b/arch/x86/include/asm/crypto/camellia.h
index 10f8d590bcfe..974bea896d96 100644
--- a/arch/x86/include/asm/crypto/camellia.h
+++ b/arch/x86/include/asm/crypto/camellia.h
@@ -40,35 +40,29 @@ extern int xts_camellia_setkey(struct crypto_tfm *tfm, const u8 *key,
 /* regular block cipher functions */
 asmlinkage void __camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
 				   const u8 *src, bool xor);
-asmlinkage void camellia_dec_blk(struct camellia_ctx *ctx, u8 *dst,
-				 const u8 *src);
+asmlinkage void camellia_dec_blk(void *ctx, u8 *dst, const u8 *src);
 
 /* 2-way parallel cipher functions */
 asmlinkage void __camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *dst,
 					const u8 *src, bool xor);
-asmlinkage void camellia_dec_blk_2way(struct camellia_ctx *ctx, u8 *dst,
-				      const u8 *src);
+asmlinkage void camellia_dec_blk_2way(void *ctx, u8 *dst, const u8 *src);
 
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
+asmlinkage void camellia_ecb_enc_16way(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_ecb_dec_16way(void *ctx, u8 *dst, const u8 *src);
+
+asmlinkage void camellia_cbc_dec_16way(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_ctr_16way(void *ctx, u8 *dst, const u8 *src,
+				   le128 *iv);
+
+asmlinkage void camellia_xts_enc_16way(void *ctx, u8 *dst, const u8 *src,
+				       le128 *iv);
+asmlinkage void camellia_xts_dec_16way(void *ctx, u8 *dst, const u8 *src,
+				       le128 *iv);
+
+static inline void camellia_enc_blk(void *ctx, u8 *dst, const u8 *src)
 {
-	__camellia_enc_blk(ctx, dst, src, false);
+	__camellia_enc_blk((struct camellia_ctx *) ctx, dst, src, false);
 }
 
 static inline void camellia_enc_blk_xor(struct camellia_ctx *ctx, u8 *dst,
@@ -77,10 +71,9 @@ static inline void camellia_enc_blk_xor(struct camellia_ctx *ctx, u8 *dst,
 	__camellia_enc_blk(ctx, dst, src, true);
 }
 
-static inline void camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *dst,
-					 const u8 *src)
+static inline void camellia_enc_blk_2way(void *ctx, u8 *dst, const u8 *src)
 {
-	__camellia_enc_blk_2way(ctx, dst, src, false);
+	__camellia_enc_blk_2way((struct camellia_ctx *) ctx, dst, src, false);
 }
 
 static inline void camellia_enc_blk_xor_2way(struct camellia_ctx *ctx, u8 *dst,
-- 
2.12.0
