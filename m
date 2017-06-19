From: Kees Cook <keescook@chromium.org>
Date: Mon, 19 Jun 2017 16:36:35 -0700
Message-Id: <1497915397-93805-22-git-send-email-keescook@chromium.org>
In-Reply-To: <1497915397-93805-1-git-send-email-keescook@chromium.org>
References: <1497915397-93805-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 21/23] usercopy: Restrict non-usercopy caches to size 0
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, David Windsor <dave@nullcore.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

With all known usercopied cache whitelists now defined in the kernel, switch
the default usercopy region of kmem_cache_create() to size 0. Any new caches
with usercopy regions will now need to use kmem_cache_create_usercopy()
instead of kmem_cache_create().

This patch is modified from Brad Spengler/PaX Team's PAX_USERCOPY
whitelisting code in the last public patch of grsecurity/PaX based on my
understanding of the code. Changes or omissions from the original code are
mine and don't reflect the original grsecurity/PaX code.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: David Windsor <dave@nullcore.net>
---
 mm/slab_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 685321a0d355..2365dd21623d 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -512,7 +512,7 @@ struct kmem_cache *
 kmem_cache_create(const char *name, size_t size, size_t align,
 		unsigned long flags, void (*ctor)(void *))
 {
-	return kmem_cache_create_usercopy(name, size, align, flags, 0, size,
+	return kmem_cache_create_usercopy(name, size, align, flags, 0, 0,
 					  ctor);
 }
 EXPORT_SYMBOL(kmem_cache_create);
-- 
2.7.4
