From: Kees Cook <keescook@chromium.org>
Date: Tue, 18 Jul 2017 17:03:33 -0700
Message-Id: <1500422614-94821-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1500422614-94821-1-git-send-email-keescook@chromium.org>
References: <1500422614-94821-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v6 1/2] x86/asm: Add suffix macro for GEN_*_RMWcc()
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Christoph Hellwig <hch@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

The coming x86 refcount protection needs to be able to add trailing
instructions to the GEN_*_RMWcc() operations. This extracts the
difference between the goto/non-goto cases so the helper macros
can be defined outside the #ifdef cases. Additionally adds argument
naming to the resulting asm for referencing from suffixed
instructions, and adds clobbers for "cc", and "cx" to let suffixes
use _ASM_CX, and retain any set flags.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/rmwcc.h | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/rmwcc.h b/arch/x86/include/asm/rmwcc.h
index 661dd305694a..045f99211a99 100644
--- a/arch/x86/include/asm/rmwcc.h
+++ b/arch/x86/include/asm/rmwcc.h
@@ -1,45 +1,56 @@
 #ifndef _ASM_X86_RMWcc
 #define _ASM_X86_RMWcc
 
+#define __CLOBBERS_MEM		"memory"
+#define __CLOBBERS_MEM_CC_CX	"memory", "cc", "cx"
+
 #if !defined(__GCC_ASM_FLAG_OUTPUTS__) && defined(CC_HAVE_ASM_GOTO)
 
 /* Use asm goto */
 
-#define __GEN_RMWcc(fullop, var, cc, ...)				\
+#define __GEN_RMWcc(fullop, var, cc, clobbers, ...)			\
 do {									\
 	asm_volatile_goto (fullop "; j" #cc " %l[cc_label]"		\
-			: : "m" (var), ## __VA_ARGS__ 			\
-			: "memory" : cc_label);				\
+			: : [counter] "m" (var), ## __VA_ARGS__		\
+			: clobbers : cc_label);				\
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
 
 /* Use flags output or a set instruction */
 
-#define __GEN_RMWcc(fullop, var, cc, ...)				\
+#define __GEN_RMWcc(fullop, var, cc, clobbers, ...)			\
 do {									\
 	bool c;								\
 	asm volatile (fullop ";" CC_SET(cc)				\
-			: "+m" (var), CC_OUT(cc) (c)			\
-			: __VA_ARGS__ : "memory");			\
+			: [counter] "+m" (var), CC_OUT(cc) (c)		\
+			: __VA_ARGS__ : clobbers);			\
 	return c;							\
 } while (0)
 
+#define __BINARY_RMWcc_ARG	" %2, "
+
+#endif /* defined(__GCC_ASM_FLAG_OUTPUTS__) || !defined(CC_HAVE_ASM_GOTO) */
+
 #define GEN_UNARY_RMWcc(op, var, arg0, cc)				\
-	__GEN_RMWcc(op " " arg0, var, cc)
+	__GEN_RMWcc(op " " arg0, var, cc, __CLOBBERS_MEM)
+
+#define GEN_UNARY_SUFFIXED_RMWcc(op, suffix, var, arg0, cc)		\
+	__GEN_RMWcc(op " " arg0 "\n\t" suffix, var, cc,			\
+		    __CLOBBERS_MEM_CC_CX)
 
 #define GEN_BINARY_RMWcc(op, var, vcon, val, arg0, cc)			\
-	__GEN_RMWcc(op " %2, " arg0, var, cc, vcon (val))
+	__GEN_RMWcc(op __BINARY_RMWcc_ARG arg0, var, cc,		\
+		    __CLOBBERS_MEM, vcon (val))
 
-#endif /* defined(__GCC_ASM_FLAG_OUTPUTS__) || !defined(CC_HAVE_ASM_GOTO) */
+#define GEN_BINARY_SUFFIXED_RMWcc(op, suffix, var, vcon, val, arg0, cc)	\
+	__GEN_RMWcc(op __BINARY_RMWcc_ARG arg0 "\n\t" suffix, var, cc,	\
+		    __CLOBBERS_MEM_CC_CX, vcon (val))
 
 #endif /* _ASM_X86_RMWcc */
-- 
2.7.4
