Reply-To: kernel-hardening@lists.openwall.com
From: Michael Ellerman <mpe@ellerman.id.au>
Date: Thu, 17 Nov 2016 20:51:07 +1100
Message-Id: <1479376267-18486-1-git-send-email-mpe@ellerman.id.au>
Subject: [kernel-hardening] [PATCH v2] slab: Add POISON_POINTER_DELTA to ZERO_SIZE_PTR
To: akpm@linux-foundation.org
Cc: cl@linux.com, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

POISON_POINTER_DELTA is defined in poison.h, and is intended to be used
to shift poison values so that they don't alias userspace.

We should add it to ZERO_SIZE_PTR so that attackers can't use
ZERO_SIZE_PTR as a way to get a non-NULL pointer to userspace.

Currently ZERO_OR_NULL_PTR() uses a trick of doing a single check that
x <= ZERO_SIZE_PTR, and ignoring the fact that it also matches 1-15.
That no longer really works once we add the poison delta, so split it
into two checks. Assign x to a temporary to avoid evaluating it
twice (suggested by Kees Cook).

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 include/linux/slab.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

v2: Rework ZERO_OR_NULL_PTR() to do the two checks separately.

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 084b12bad198..404419d9860f 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -12,6 +12,7 @@
 #define	_LINUX_SLAB_H
 
 #include <linux/gfp.h>
+#include <linux/poison.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
 
@@ -109,10 +110,13 @@
  * ZERO_SIZE_PTR can be passed to kfree though in the same way that NULL can.
  * Both make kfree a no-op.
  */
-#define ZERO_SIZE_PTR ((void *)16)
+#define ZERO_SIZE_PTR ((void *)(16 + POISON_POINTER_DELTA))
 
-#define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) <= \
-				(unsigned long)ZERO_SIZE_PTR)
+#define ZERO_OR_NULL_PTR(x)				\
+	({						\
+		void *p = (void *)(x);			\
+		(p == NULL || p == ZERO_SIZE_PTR);	\
+	})
 
 #include <linux/kmemleak.h>
 #include <linux/kasan.h>
-- 
2.7.4
