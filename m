Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <labbott@fedoraproject.org>
Date: Mon, 25 Jan 2016 08:55:53 -0800
Message-Id: <1453740953-18109-4-git-send-email-labbott@fedoraproject.org>
In-Reply-To: <1453740953-18109-1-git-send-email-labbott@fedoraproject.org>
References: <1453740953-18109-1-git-send-email-labbott@fedoraproject.org>
Subject: [kernel-hardening] [RFC][PATCH 3/3] mm/page_poisoning.c: Allow for zero poisoning
To: Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>
Cc: Laura Abbott <labbott@fedoraproject.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>


By default, page poisoning uses a poison value (0xaa) on free. If this
is changed to 0, the page is not only sanitized but zeroing on alloc
with __GFP_ZERO can be skipped as well. The tradeoff is that detecting
corruption from the poisoning is harder to detect. This feature also
cannot be used with hibernation since pages are not guaranteed to be
zeroed after hibernation.

Credit to Mathias Krause and grsecurity for original work

Signed-off-by: Laura Abbott <labbott@fedoraproject.org>

---
 include/linux/poison.h |  4 ++++
 mm/Kconfig.debug       | 13 +++++++++++++
 mm/page_alloc.c        |  8 +++++++-
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/linux/poison.h b/include/linux/poison.h
index 4a27153..51334ed 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -30,7 +30,11 @@
 #define TIMER_ENTRY_STATIC	((void *) 0x300 + POISON_POINTER_DELTA)
 
 /********** mm/debug-pagealloc.c **********/
+#ifdef CONFIG_PAGE_POISONING_ZERO
+#define PAGE_POISON 0x00
+#else
 #define PAGE_POISON 0xaa
+#endif
 
 /********** mm/page_alloc.c ************/
 
diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index c300f5f..8ec7dc6 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -48,3 +48,16 @@ config PAGE_POISONING_NO_SANITY
 
 	   If you are only interested in sanitization, say Y. Otherwise
 	   say N.
+
+config PAGE_POISONING_ZERO
+	bool "Use zero for poisoning instead of random data"
+	depends on !HIBERNATION
+	depends on PAGE_POISONING
+	---help---
+	   Instead of using the existing poison value, fill the pages with
+	   zeros. This makes it harder to detect when errors are occuring
+	   due to sanitization but the zeroing at free means that it is
+	   no longer necessary to write zeros when GFP_ZERO is used on
+	   allocation.
+
+	   If unsure, say N
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c733421..7395eee 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1382,6 +1382,12 @@ static inline int check_new_page(struct page *page)
 	return 0;
 }
 
+static inline bool should_zero(void)
+{
+	return !IS_ENABLED(CONFIG_PAGE_POISONING_ZERO) ||
+		!page_poisoning_enabled();
+}
+
 static int prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
 								int alloc_flags)
 {
@@ -1401,7 +1407,7 @@ static int prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
 	kernel_map_pages(page, 1 << order, 1);
 	kasan_alloc_pages(page, order);
 
-	if (gfp_flags & __GFP_ZERO)
+	if (should_zero() && gfp_flags & __GFP_ZERO)
 		for (i = 0; i < (1 << order); i++)
 			clear_highpage(page + i);
 
-- 
2.5.0
