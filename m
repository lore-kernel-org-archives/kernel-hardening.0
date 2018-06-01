From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v3 10/16] treewide: Use struct_size() for vmalloc()-family
Date: Thu, 31 May 2018 17:42:27 -0700
Message-Id: <20180601004233.37822-11-keescook@chromium.org>
In-Reply-To: <20180601004233.37822-1-keescook@chromium.org>
References: <20180601004233.37822-1-keescook@chromium.org>
To: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Matthew Wilcox <willy@infradead.org>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

This only finds one hit in the entire tree, but here's the Coccinelle:

// Directly refer to structure's field
@@
identifier alloc =~ "vmalloc|vzalloc";
identifier VAR, ELEMENT;
expression COUNT;
@@

- alloc(sizeof(*VAR) + COUNT * sizeof(*VAR->ELEMENT))
+ alloc(struct_size(VAR, ELEMENT, COUNT))

// mr = kzalloc(sizeof(*mr) + m * sizeof(mr->map[0]), GFP_KERNEL);
@@
identifier alloc =~ "vmalloc|vzalloc";
identifier VAR, ELEMENT;
expression COUNT;
@@

- alloc(sizeof(*VAR) + COUNT * sizeof(VAR->ELEMENT[0]))
+ alloc(struct_size(VAR, ELEMENT, COUNT))

// Same pattern, but can't trivially locate the trailing element name,
// or variable name.
@@
identifier alloc =~ "vmalloc|vzalloc";
expression SOMETHING, COUNT, ELEMENT;
@@

- alloc(sizeof(SOMETHING) + COUNT * sizeof(ELEMENT))
+ alloc(CHECKME_struct_size(&SOMETHING, ELEMENT, COUNT))

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/gpu/drm/nouveau/nvkm/core/ramht.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/core/ramht.c b/drivers/gpu/drm/nouveau/nvkm/core/ramht.c
index ccba4ae73cc5..8162e3d2359c 100644
--- a/drivers/gpu/drm/nouveau/nvkm/core/ramht.c
+++ b/drivers/gpu/drm/nouveau/nvkm/core/ramht.c
@@ -144,8 +144,7 @@ nvkm_ramht_new(struct nvkm_device *device, u32 size, u32 align,
 	struct nvkm_ramht *ramht;
 	int ret, i;
 
-	if (!(ramht = *pramht = vzalloc(sizeof(*ramht) +
-					(size >> 3) * sizeof(*ramht->data))))
+	if (!(ramht = *pramht = vzalloc(struct_size(ramht, data, (size >> 3)))))
 		return -ENOMEM;
 
 	ramht->device = device;
-- 
2.17.0
