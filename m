From: Alexander Popov <alex.popov@linux.com>
Date: Mon, 17 Jul 2017 19:45:07 +0300
Message-Id: <1500309907-9357-1-git-send-email-alex.popov@linux.com>
Subject: [kernel-hardening] [PATCH 1/1] mm/slub.c: add a naive detection of double free or corruption
To: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, keescook@chromium.org, alex.popov@linux.com
List-ID: <kernel-hardening.lists.openwall.com>

Add an assertion similar to "fasttop" check in GNU C Library allocator:
an object added to a singly linked freelist should not point to itself.
That helps to detect some double free errors (e.g. CVE-2017-2636) without
slub_debug and KASAN. Testing with hackbench doesn't show any noticeable
performance penalty.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 mm/slub.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/slub.c b/mm/slub.c
index 1d3f983..a106939b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -261,6 +261,7 @@ static inline void *get_freepointer_safe(struct kmem_cache *s, void *object)
 
 static inline void set_freepointer(struct kmem_cache *s, void *object, void *fp)
 {
+	BUG_ON(object == fp); /* naive detection of double free or corruption */
 	*(void **)(object + s->offset) = fp;
 }
 
-- 
2.7.4
