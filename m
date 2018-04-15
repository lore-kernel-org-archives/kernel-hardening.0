From: Joao Moreira <jmoreira@suse.de>
Subject: [PATCH 2/4] x86/crypto: cast6: Fix function prototypes
Date: Sun, 15 Apr 2018 01:15:40 -0300
Message-Id: <20180415041542.5364-3-jmoreira@suse.de>
In-Reply-To: <20180415041542.5364-1-jmoreira@suse.de>
References: <20180415041542.5364-1-jmoreira@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Convert the use of 'struct cast6_ctx *' to 'void *' in prototypes of
functions which are referenced through 'struct common_glue_func_entry',
making their prototypes match those of this struct and, consequently,
turning them compatible with CFI requirements.

Signed-off-by: João Moreira <jmoreira@suse.de>
---
 arch/x86/crypto/cast6_avx_glue.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/x86/crypto/cast6_avx_glue.c b/arch/x86/crypto/cast6_avx_glue.c
index 50e684768c55..f4e05388fbbb 100644
--- a/arch/x86/crypto/cast6_avx_glue.c
+++ b/arch/x86/crypto/cast6_avx_glue.c
@@ -41,20 +41,16 @@
 
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
+asmlinkage void cast6_ecb_enc_8way(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void cast6_ecb_dec_8way(void *ctx, u8 *dst, const u8 *src);
+
+asmlinkage void cast6_cbc_dec_8way(void *ctx, u8 *dst, const u8 *src);
+asmlinkage void cast6_ctr_8way(void *ctx, u8 *dst, const u8 *src, le128 *iv);
+
+asmlinkage void cast6_xts_enc_8way(void *ctx, u8 *dst, const u8 *src,
+				  le128 *iv);
+asmlinkage void cast6_xts_dec_8way(void *ctx, u8 *dst, const u8 *src,
+				  le128 *iv);
 
 static void cast6_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-- 
2.12.0
