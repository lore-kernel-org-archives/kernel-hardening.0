Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 26 Jul 2015 16:45:19 +0300
From: Vasily Kulikov <segoon@openwall.com>
Message-ID: <20150726134519.GA1111@cachalot>
References: <20150726134324.GA1068@cachalot>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150726134324.GA1068@cachalot>
Subject: [kernel-hardening] [PATCH 2/3] use POISON_POINTER_DELTA for poison pointers
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

TIMER_ENTRY_STATIC and TAIL_MAPPING are defined as poison pointers which
should point to nowhere.  Redefine them using POISON_POINTER_DELTA arithmetics
to make sure they really point to non-mappable area declared by the
target architecture.

Signed-off-by: Vasily Kulikov <segoon@openwall.com> 
---
 include/linux/poison.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/poison.h b/include/linux/poison.h
index ee697b9..a721bcd 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -27,14 +27,14 @@
  * Magic number "tsta" to indicate a static timer initializer
  * for the object debugging code.
  */
-#define TIMER_ENTRY_STATIC	((void *) 0x74737461)
+#define TIMER_ENTRY_STATIC	((void *) 0x300 + POISON_POINTER_DELTA)
 
 /********** mm/debug-pagealloc.c **********/
 #define PAGE_POISON 0xaa
 
 /********** mm/page_alloc.c ************/
 
-#define TAIL_MAPPING	((void *) 0x01014A11 + POISON_POINTER_DELTA)
+#define TAIL_MAPPING	((void *) 0x400 + POISON_POINTER_DELTA)
 
 /********** mm/slab.c **********/
 /*
-- 
2.1.0
