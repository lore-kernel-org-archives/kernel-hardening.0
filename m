From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v3 7/7] crypto: x86/glue_helper: Remove function prototype cast helpers
Date: Tue,  7 May 2019 09:13:21 -0700
Message-Id: <20190507161321.34611-8-keescook@chromium.org>
In-Reply-To: <20190507161321.34611-1-keescook@chromium.org>
References: <20190507161321.34611-1-keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <keescook@chromium.org>, Joao Moreira <jmoreira@suse.de>, Eric Biggers <ebiggers@google.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Now that all users of the function prototype casting helpers have been
removed, this deletes the unused macros.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/crypto/glue_helper.h | 6 ------
 include/crypto/xts.h                      | 2 --
 2 files changed, 8 deletions(-)

diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index 3b039d563809..2b2d8d4a5081 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -18,12 +18,6 @@ typedef void (*common_glue_ctr_func_t)(void *ctx, u128 *dst, const u128 *src,
 typedef void (*common_glue_xts_func_t)(void *ctx, u128 *dst, const u128 *src,
 				       le128 *iv);
 
-#define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
-#define GLUE_CBC_FUNC_CAST(fn) ((common_glue_cbc_func_t)(fn))
-#define GLUE_CTR_FUNC_CAST(fn) ((common_glue_ctr_func_t)(fn))
-#define GLUE_XTS_FUNC_CAST(fn) ((common_glue_xts_func_t)(fn))
-
-
 #define GLUE_CAST(func, context)					\
 asmlinkage void func(struct context *ctx, u8 *dst, const u8 *src);	\
 asmlinkage static inline						\
diff --git a/include/crypto/xts.h b/include/crypto/xts.h
index 75fd96ff976b..15ae7fdc0478 100644
--- a/include/crypto/xts.h
+++ b/include/crypto/xts.h
@@ -8,8 +8,6 @@
 
 #define XTS_BLOCK_SIZE 16
 
-#define XTS_TWEAK_CAST(x) ((void (*)(void *, u8*, const u8*))(x))
-
 static inline int xts_check_key(struct crypto_tfm *tfm,
 				const u8 *key, unsigned int keylen)
 {
-- 
2.17.1
