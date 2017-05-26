From: Kees Cook <keescook@chromium.org>
Date: Fri, 26 May 2017 13:17:07 -0700
Message-Id: <1495829844-69341-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1495829844-69341-1-git-send-email-keescook@chromium.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 03/20] compiler: Add __designated_init annotation
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This allows structure annotations for requiring designated initialization
in GCC 5.1.0 and later:
https://gcc.gnu.org/onlinedocs/gcc/Designated-Inits.html

The structure randomization layout plugin will be using this to help
identify structures that need this form of initialization.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/compiler-gcc.h | 8 ++++++++
 include/linux/compiler.h     | 4 ++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 0efef9cf014f..386caf6771ed 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -294,6 +294,14 @@
 #define __no_sanitize_address __attribute__((no_sanitize_address))
 #endif
 
+#if GCC_VERSION >= 50100
+/*
+ * Mark structures as requiring designated initializers.
+ * https://gcc.gnu.org/onlinedocs/gcc/Designated-Inits.html
+ */
+#define __designated_init __attribute__((designated_init))
+#endif
+
 #endif	/* gcc version >= 40000 specific checks */
 
 #if !defined(__noclone)
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 707242fdbb89..bbe881054bf0 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -436,6 +436,10 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
 # define __attribute_const__	/* unimplemented */
 #endif
 
+#ifndef __designated_init
+# define __designated_init
+#endif
+
 #ifndef __latent_entropy
 # define __latent_entropy
 #endif
-- 
2.7.4
