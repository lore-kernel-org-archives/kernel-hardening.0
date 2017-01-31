From: Kees Cook <keescook@chromium.org>
Date: Tue, 31 Jan 2017 12:24:20 -0800
Message-Id: <1485894263-91051-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1485894263-91051-1-git-send-email-keescook@chromium.org>
References: <1485894263-91051-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 2/4] util: Move type casts into is_kernel_rodata
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Josh Triplett <josh@joshtriplett.org>, pageexec@freemail.hu, yamada.masahiro@socionext.com, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, sam@ravnborg.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Emese Revfy <re.emese@gmail.com>

This moves type casts into the is_kernel_rodata() function itself so that
parameters can be marked as "nocapture" in the coming initify gcc plugin.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
[kees: expanded commit message]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 mm/util.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/util.c b/mm/util.c
index 3cb2164f4099..a700e3fb1587 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -17,10 +17,10 @@
 
 #include "internal.h"
 
-static inline int is_kernel_rodata(unsigned long addr)
+static inline int is_kernel_rodata(const void *addr)
 {
-	return addr >= (unsigned long)__start_rodata &&
-		addr < (unsigned long)__end_rodata;
+	return (unsigned long)addr >= (unsigned long)__start_rodata &&
+		(unsigned long)addr < (unsigned long)__end_rodata;
 }
 
 /**
@@ -31,7 +31,7 @@ static inline int is_kernel_rodata(unsigned long addr)
  */
 void kfree_const(const void *x)
 {
-	if (!is_kernel_rodata((unsigned long)x))
+	if (!is_kernel_rodata(x))
 		kfree(x);
 }
 EXPORT_SYMBOL(kfree_const);
@@ -68,7 +68,7 @@ EXPORT_SYMBOL(kstrdup);
  */
 const char *kstrdup_const(const char *s, gfp_t gfp)
 {
-	if (is_kernel_rodata((unsigned long)s))
+	if (is_kernel_rodata(s))
 		return s;
 
 	return kstrdup(s, gfp);
-- 
2.7.4
