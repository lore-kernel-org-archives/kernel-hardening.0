From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v3 1/7] crypto: x86/glue_helper: Add static inline function glue macros
Date: Tue,  7 May 2019 09:13:15 -0700
Message-Id: <20190507161321.34611-2-keescook@chromium.org>
In-Reply-To: <20190507161321.34611-1-keescook@chromium.org>
References: <20190507161321.34611-1-keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <keescook@chromium.org>, Joao Moreira <jmoreira@suse.de>, Eric Biggers <ebiggers@google.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

It is possible to indirectly invoke functions with prototypes that do
not match those of the respectively used function pointers by using void
types or casts. This feature is frequently used as a way of relaxing
function invocation, making it possible that different data structures
are passed to different functions through the same pointer.

Despite the benefits, this can lead to a situation where functions with a
given prototype are invoked by pointers with a different prototype. This
is undesirable as it may prevent the use of heuristics such as prototype
matching-based Control-Flow Integrity, which can be used to prevent
ROP-based attacks.

One way of fixing this situation is through the use of inline helper
functions with prototypes that match the one in the respective invoking
pointer.

Given the above, the current efforts to improve the Linux security,
and the upcoming kernel support to compilers with CFI features, this
creates macros to be used to build the needed function definitions,
to be used in later patches to camellia, cast6, serpent, twofish, and
aesni.

Co-developed-by: Joao Moreira <jmoreira@suse.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/crypto/glue_helper.h | 32 +++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index d1818634ae7e..3b039d563809 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -23,6 +23,38 @@ typedef void (*common_glue_xts_func_t)(void *ctx, u128 *dst, const u128 *src,
 #define GLUE_CTR_FUNC_CAST(fn) ((common_glue_ctr_func_t)(fn))
 #define GLUE_XTS_FUNC_CAST(fn) ((common_glue_xts_func_t)(fn))
 
+
+#define GLUE_CAST(func, context)					\
+asmlinkage void func(struct context *ctx, u8 *dst, const u8 *src);	\
+asmlinkage static inline						\
+void func ## _glue(void *ctx, u8 *dst, const u8 *src)			\
+{ func((struct context *) ctx, dst, src); }
+
+#define GLUE_CAST_XOR(func, context)					\
+asmlinkage void __ ## func(struct context *ctx, u8 *dst, const u8 *src,	\
+			   bool y);					\
+asmlinkage static inline						\
+void func(void *ctx, u8 *dst, const u8 *src)				\
+{ __ ## func((struct context *) ctx, dst, src, false); }		\
+asmlinkage static inline						\
+void func ## _xor(void *ctx, u8 *dst, const u8 *src)			\
+{ __ ## func((struct context *) ctx, dst, src, true); }
+
+#define GLUE_CAST_CBC(func, context)					\
+asmlinkage void func(struct context *ctx, u8 *dst, const u8 *src);	\
+asmlinkage static inline						\
+void func ## _cbc_glue(void *ctx, u128 *dst, const u128 *src)		\
+{ func((struct context *) ctx, (u8 *) dst, (u8 *) src); }
+
+#define GLUE_CAST_CTR(func, context)					\
+asmlinkage void func(struct context *ctx, u128 *dst,			\
+		     const u128 *src, le128 *iv);			\
+asmlinkage static inline						\
+void func ## _glue(void *ctx, u128 *dst, const u128 *src, le128 *iv)	\
+{ func((struct context *) ctx, dst, src, iv); }
+
+#define GLUE_CAST_XTS(func, context) GLUE_CAST_CTR(func, context)
+
 struct common_glue_func_entry {
 	unsigned int num_blocks; /* number of blocks that @fn will process */
 	union {
-- 
2.17.1
