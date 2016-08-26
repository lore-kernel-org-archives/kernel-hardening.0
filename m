Reply-To: kernel-hardening@lists.openwall.com
From: Mark Rutland <mark.rutland@arm.com>
Date: Fri, 26 Aug 2016 15:31:43 +0100
Message-Id: <1472221903-31181-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCH] lib: harden strncpy_from_user
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

The strncpy_from_user() accessor is effectively a copy_from_user()
specialised to copy strings, terminating early at a NUL byte if
possible. In other respects it is identical, and can be used to copy an
arbitrarily large buffer from userspace into the kernel. Conceptually,
it exposes a similar attack surface.

As with copy_from_user(), we check the destination range when the kernel
is built with KASAN, but unlike copy_from_user() we do not check the
destination buffer when using HARDENED_USERCOPY. As strncpy_from_user()
calls get_user() in a loop, we must call check_object_size() explicitly.

This patch adds this instrumentation to strncpy_from_user(), per the
same rationale as with the regular copy_from_user(). In the absence of
hardened usercopy this will have no impact as the instrumentation
expands to an empty static inline function.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>
---
 lib/strncpy_from_user.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/strncpy_from_user.c b/lib/strncpy_from_user.c
index 9c5fe81..7e35fc4 100644
--- a/lib/strncpy_from_user.c
+++ b/lib/strncpy_from_user.c
@@ -1,6 +1,7 @@
 #include <linux/compiler.h>
 #include <linux/export.h>
 #include <linux/kasan-checks.h>
+#include <linux/thread_info.h>
 #include <linux/uaccess.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -111,6 +112,7 @@ long strncpy_from_user(char *dst, const char __user *src, long count)
 		long retval;
 
 		kasan_check_write(dst, count);
+		check_object_size(dst, count, false);
 		user_access_begin();
 		retval = do_strncpy_from_user(dst, src, count, max);
 		user_access_end();
-- 
2.7.4
