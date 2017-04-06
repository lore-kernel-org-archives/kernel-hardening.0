From: Kees Cook <keescook@chromium.org>
Date: Thu,  6 Apr 2017 14:18:17 -0700
Message-Id: <1491513513-84351-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1491513513-84351-1-git-send-email-keescook@chromium.org>
References: <1491513513-84351-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 02/18] compiler: Add __designated_init annotation
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Michael Leibowitz <michael.leibowitz@intel.com>
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
index 5f4d8f8b75da..cf541e49841e 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -321,6 +321,14 @@
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
index b8642a3a1f4f..40e584448605 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -440,6 +440,10 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
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
