From: Joao Moreira <jmoreira@suse.de>
Subject: [PATCH 4/4] x86/crypto: twofish: Fix function prototypes
Date: Sun, 15 Apr 2018 01:15:42 -0300
Message-Id: <20180415041542.5364-5-jmoreira@suse.de>
In-Reply-To: <20180415041542.5364-1-jmoreira@suse.de>
References: <20180415041542.5364-1-jmoreira@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Convert the use of 'struct twofish_ctx *' to 'void *' in prototypes of
functions which are referenced through 'struct common_glue_func_entry',
making their prototypes match those of this struct and, consequently,
turning them compatible with CFI requirements.

Whenever needed, cast 'void *' to 'struct twofish_ctx *'.

Signed-off-by: João Moreira <jmoreira@suse.de>
---
 arch/x86/crypto/twofish_avx_glue.c    | 30 +++++++++++++-----------------
 arch/x86/crypto/twofish_glue.c        |  7 +++----
 arch/x86/crypto/twofish_glue_3way.c   | 10 ++++------
 arch/x86/include/asm/crypto/twofish.h |  9 +++------
 4 files changed, 23 insertions(+), 33 deletions(-)

diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index b7a3904b953c..916a4904fa25 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -46,25 +46,21 @@
 #define TWOFISH_PARALLEL_BLOCKS 8
 
 /* 8-way parallel cipher functions */
-asmlinkage void twofish_ecb_enc_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src);
-asmlinkage void twofish_ecb_dec_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src);
-
-asmlinkage void twofish_cbc_dec_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src);
-asmlinkage void twofish_ctr_8way(struct twofish_ctx *ctx, u8 *dst,
-				 const u8 *src, le128 *iv);
-
-asmlinkage void twofish_xts_enc_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src, le128 *iv);
-asmlinkage void twofish_xts_dec_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src, le128 *iv);
-
-static inline void twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
+asmlinkage void twofish_ecb_enc_8way(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void twofish_ecb_dec_8way(void *ctx, u8 *dst, const u8 *src);
+
+asmlinkage void twofish_cbc_dec_8way(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void twofish_ctr_8way(void *ctx, u8 *dst, const u8 *src, le128 *iv);
+
+asmlinkage void twofish_xts_enc_8way(void *ctx, u8 *dst, const u8 *src,
+				     le128 *iv);
+asmlinkage void twofish_xts_dec_8way(void *ctx, u8 *dst, const u8 *src,
+				     le128 *iv);
+
+static inline void twofish_enc_blk_3way(void *ctx, u8 *dst,
 					const u8 *src)
 {
-	__twofish_enc_blk_3way(ctx, dst, src, false);
+	__twofish_enc_blk_3way((struct twofish_ctx *) ctx, dst, src, false);
 }
 
 static void twofish_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
diff --git a/arch/x86/crypto/twofish_glue.c b/arch/x86/crypto/twofish_glue.c
index 77e06c2da83d..3dee618c2dd2 100644
--- a/arch/x86/crypto/twofish_glue.c
+++ b/arch/x86/crypto/twofish_glue.c
@@ -44,11 +44,10 @@
 #include <linux/module.h>
 #include <linux/types.h>
 
-asmlinkage void twofish_enc_blk(struct twofish_ctx *ctx, u8 *dst,
-				const u8 *src);
+asmlinkage void twofish_enc_blk(void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(twofish_enc_blk);
-asmlinkage void twofish_dec_blk(struct twofish_ctx *ctx, u8 *dst,
-				const u8 *src);
+
+asmlinkage void twofish_dec_blk(void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(twofish_dec_blk);
 
 static void twofish_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 243e90a4b5d9..ce25be1bc260 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -36,16 +36,14 @@
 EXPORT_SYMBOL_GPL(__twofish_enc_blk_3way);
 EXPORT_SYMBOL_GPL(twofish_dec_blk_3way);
 
-static inline void twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
-					const u8 *src)
+static inline void twofish_enc_blk_3way(void *ctx, u8 *dst, const u8 *src)
 {
-	__twofish_enc_blk_3way(ctx, dst, src, false);
+	__twofish_enc_blk_3way((struct twofish_ctx *) ctx, dst, src, false);
 }
 
-static inline void twofish_enc_blk_xor_3way(struct twofish_ctx *ctx, u8 *dst,
-					    const u8 *src)
+static inline void twofish_enc_blk_xor_3way(void *ctx, u8 *dst, const u8 *src)
 {
-	__twofish_enc_blk_3way(ctx, dst, src, true);
+	__twofish_enc_blk_3way((struct twofish_ctx *) ctx, dst, src, true);
 }
 
 void twofish_dec_blk_cbc_3way(void *ctx, u128 *dst, const u128 *src)
diff --git a/arch/x86/include/asm/crypto/twofish.h b/arch/x86/include/asm/crypto/twofish.h
index 65bb80adba3e..871eaa7bacdc 100644
--- a/arch/x86/include/asm/crypto/twofish.h
+++ b/arch/x86/include/asm/crypto/twofish.h
@@ -18,16 +18,13 @@ struct twofish_xts_ctx {
 };
 
 /* regular block cipher functions from twofish_x86_64 module */
-asmlinkage void twofish_enc_blk(struct twofish_ctx *ctx, u8 *dst,
-				const u8 *src);
-asmlinkage void twofish_dec_blk(struct twofish_ctx *ctx, u8 *dst,
-				const u8 *src);
+asmlinkage void twofish_enc_blk(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void twofish_dec_blk(void *ctx, u8 *dst, const u8 *src);
 
 /* 3-way parallel cipher functions */
 asmlinkage void __twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
 				       const u8 *src, bool xor);
-asmlinkage void twofish_dec_blk_3way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src);
+asmlinkage void twofish_dec_blk_3way(void *ctx, u8 *dst, const u8 *src);
 
 /* helpers from twofish_x86_64-3way module */
 extern void twofish_dec_blk_cbc_3way(void *ctx, u128 *dst, const u128 *src);
-- 
2.12.0
