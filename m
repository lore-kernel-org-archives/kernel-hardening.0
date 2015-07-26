Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 26 Jul 2015 16:43:24 +0300
From: Vasily Kulikov <segoon@openwall.com>
Message-ID: <20150726134324.GA1068@cachalot>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH 1/3] fix LIST_POISON{1,2} offset
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, Ingo Molnar <mingo@elte.hu>
List-ID: <kernel-hardening.lists.openwall.com>

Poison pointer values should be small enough to find a room in
non-mmap'able/hardly-mmap'able space.  E.g. on x86 "poison pointer
space" is located starting from 0x0.  Given unprivileged users cannot
mmap anything below mmap_min_addr, it should be safe to use poison
pointers lower than mmap_min_addr.

The current poison pointer values of LIST_POISON{1,2} might be
too big for mmap_min_addr values equal or less than 1 MB (common case,
e.g. Ubuntu uses only 0x10000).  There is little point to use such a big
value given the "poison pointer space" below 1 MB is not yet exhausted.
Changing it to a smaller value solves the problem for small
mmap_min_addr setups.

The values are suggested by Solar Designer:
http://www.openwall.com/lists/oss-security/2015/05/02/6

Signed-off-by: Vasily Kulikov <segoon@openwall.com> 
---
 include/linux/poison.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/poison.h b/include/linux/poison.h
index 7b2a7fc..ee697b9 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -19,8 +19,8 @@
  * under normal circumstances, used to verify that nobody uses
  * non-initialized list entries.
  */
-#define LIST_POISON1  ((void *) 0x00100100 + POISON_POINTER_DELTA)
-#define LIST_POISON2  ((void *) 0x00200200 + POISON_POINTER_DELTA)
+#define LIST_POISON1  ((void *) 0x100 + POISON_POINTER_DELTA)
+#define LIST_POISON2  ((void *) 0x200 + POISON_POINTER_DELTA)
 
 /********** include/linux/timer.h **********/
 /*
-- 
2.1.0
