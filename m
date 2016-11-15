Reply-To: kernel-hardening@lists.openwall.com
From: Michael Ellerman <mpe@ellerman.id.au>
Date: Tue, 15 Nov 2016 21:57:02 +1100
Message-Id: <1479207422-6535-1-git-send-email-mpe@ellerman.id.au>
Subject: [kernel-hardening] [PATCH] slab: Add POISON_POINTER_DELTA to ZERO_SIZE_PTR
To: akpm@linux-foundation.org
Cc: cl@linux.com, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

POISON_POINTER_DELTA is defined in poison.h, and is intended to be used
to shift poison values so that they don't alias userspace.

We should add it to ZERO_SIZE_PTR so that attackers can't use
ZERO_SIZE_PTR as a way to get a pointer to userspace.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 include/linux/slab.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 084b12bad198..17ddd7aea2dd 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -12,6 +12,7 @@
 #define	_LINUX_SLAB_H
 
 #include <linux/gfp.h>
+#include <linux/poison.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
 
@@ -109,7 +110,7 @@
  * ZERO_SIZE_PTR can be passed to kfree though in the same way that NULL can.
  * Both make kfree a no-op.
  */
-#define ZERO_SIZE_PTR ((void *)16)
+#define ZERO_SIZE_PTR ((void *)(16 + POISON_POINTER_DELTA))
 
 #define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) <= \
 				(unsigned long)ZERO_SIZE_PTR)
-- 
2.7.4
