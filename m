From: Kees Cook <keescook@chromium.org>
Date: Mon,  8 May 2017 12:32:51 -0700
Message-Id: <1494271972-140319-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1494271972-140319-1-git-send-email-keescook@chromium.org>
References: <1494271972-140319-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v3 1/2] x86/asm: Add suffix macro for GEN_*_RMWcc()
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, PaX Team <pageexec@freemail.hu>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

The coming x86 refcount protection needs to be able to add trailing
instructions to the GEN_*_RMWcc() operations. This extracts the
difference between the goto/non-goto cases so the helper macros
can be defined outside the #ifdef cases. Additionally adds argument
naming to the resulting asm for referencing from suffixed
instructions.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/rmwcc.h | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/rmwcc.h b/arch/x86/include/asm/rmwcc.h
index 661dd305694a..3e96f9a56b6d 100644
--- a/arch/x86/include/asm/rmwcc.h
+++ b/arch/x86/include/asm/rmwcc.h
@@ -8,18 +8,15 @@
 #define __GEN_RMWcc(fullop, var, cc, ...)				\
 do {									\
 	asm_volatile_goto (fullop "; j" #cc " %l[cc_label]"		\
-			: : "m" (var), ## __VA_ARGS__ 			\
+			: : [counter] "m" (var), ## __VA_ARGS__		\
 			: "memory" : cc_label);				\
 	return 0;							\
 cc_label:								\
 	return 1;							\
 } while (0)
 
-#define GEN_UNARY_RMWcc(op, var, arg0, cc) 				\
-	__GEN_RMWcc(op " " arg0, var, cc)
+#define __BINARY_RMWcc_ARG	" %1, "
 
-#define GEN_BINARY_RMWcc(op, var, vcon, val, arg0, cc)			\
-	__GEN_RMWcc(op " %1, " arg0, var, cc, vcon (val))
 
 #else /* defined(__GCC_ASM_FLAG_OUTPUTS__) || !defined(CC_HAVE_ASM_GOTO) */
 
@@ -29,17 +26,26 @@ cc_label:								\
 do {									\
 	bool c;								\
 	asm volatile (fullop ";" CC_SET(cc)				\
-			: "+m" (var), CC_OUT(cc) (c)			\
+			: [counter] "+m" (var), CC_OUT(cc) (c)		\
 			: __VA_ARGS__ : "memory");			\
 	return c;							\
 } while (0)
 
+#define __BINARY_RMWcc_ARG	" %2, "
+
+#endif /* defined(__GCC_ASM_FLAG_OUTPUTS__) || !defined(CC_HAVE_ASM_GOTO) */
+
 #define GEN_UNARY_RMWcc(op, var, arg0, cc)				\
 	__GEN_RMWcc(op " " arg0, var, cc)
 
+#define GEN_UNARY_SUFFIXED_RMWcc(op, suffix, var, arg0, cc)		\
+	__GEN_RMWcc(op " " arg0 "\n\t" suffix, var, cc)
+
 #define GEN_BINARY_RMWcc(op, var, vcon, val, arg0, cc)			\
-	__GEN_RMWcc(op " %2, " arg0, var, cc, vcon (val))
+	__GEN_RMWcc(op __BINARY_RMWcc_ARG arg0, var, cc, vcon (val))
 
-#endif /* defined(__GCC_ASM_FLAG_OUTPUTS__) || !defined(CC_HAVE_ASM_GOTO) */
+#define GEN_BINARY_SUFFIXED_RMWcc(op, suffix, var, vcon, val, arg0, cc)	\
+	__GEN_RMWcc(op __BINARY_RMWcc_ARG arg0 "\n\t" suffix, var, cc,	\
+		    vcon (val))
 
 #endif /* _ASM_X86_RMWcc */
-- 
2.7.4
