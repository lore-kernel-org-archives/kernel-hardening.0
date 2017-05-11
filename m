Date: Thu, 11 May 2017 16:25:38 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
Message-ID: <20170511212538.bjp4jbb7p4qipawo@treble>
References: <1494356483-81678-1-git-send-email-keescook@chromium.org>
 <1494356483-81678-3-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1494356483-81678-3-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v4 2/2] x86/refcount: Implement fast refcount overflow
 protection
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, PaX Team <pageexec@freemail.hu>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 09, 2017 at 12:01:23PM -0700, Kees Cook wrote:
> +#define _REFCOUNT_EXCEPTION				\
> +	".pushsection .text.unlikely\n"			\
> +	"111:\tmovl $0x7fffffff, %[counter]\n"		\
> +	"112:\t" ASM_UD0 "\n"				\
> +	".popsection\n"					\
> +	"113:\n"					\
> +	_ASM_EXTABLE_REFCOUNT(112b, 113b)

This resulted in some new objtool warnings because the UD0 instruction
is a dead end in the .text.unlikely section, but it's not annotated as
such.  (As opposed to the WARN macros' use of UD0, which aren't dead
ends since they resume execution immediately afterwards).

The below patch creates a UNREACHABLE_ASM macro, similar to the existing
unreachable() macro for C code, which you can call right after the
ASM_UD0 line above to fix the warnings.  Feel free to add the patch to
your set.

----

From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH] objtool: create UNREACHABLE_ASM macro

Create an UNREACHABLE_ASM macro to enable inline asm to annotate dead
end code paths.  This macro is analagous to the unreachable() macro for
C code.

Also add a couple of comments.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 include/linux/compiler-gcc.h | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 0efef9c..08cdf9e 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -198,13 +198,26 @@
 #endif
 
 #ifdef CONFIG_STACK_VALIDATION
-#define annotate_unreachable() ({					\
-	asm("%c0:\t\n"							\
-	    ".pushsection .discard.unreachable\t\n"			\
-	    ".long %c0b - .\t\n"					\
-	    ".popsection\t\n" : : "i" (__LINE__));			\
-})
+/*
+ * This label needs to be unique to prevent GCC from removing what it sees as
+ * duplicate inline asm statements in a function.
+ */
+#define UNREACHABLE_ASM_LABEL __stringify(__LINE__)
+
+/*
+ * Annotate the previous instruction as unreachable.  This allows objtool to
+ * detect dead ends in the code flow.
+ */
+#define UNREACHABLE_ASM							\
+	UNREACHABLE_ASM_LABEL ":\n\t"					\
+	".pushsection .discard.unreachable\n\t"				\
+	".long " UNREACHABLE_ASM_LABEL "b - .\n\t"			\
+	".popsection\n"
+
+#define annotate_unreachable() asm(UNREACHABLE_ASM);
+
 #else
+#define UNREACHABLE_ASM
 #define annotate_unreachable()
 #endif
 
-- 
2.7.4
