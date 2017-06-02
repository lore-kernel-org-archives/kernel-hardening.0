From: riel@redhat.com
Date: Fri,  2 Jun 2017 11:20:10 -0400
Message-Id: <20170602152010.2064-7-riel@redhat.com>
In-Reply-To: <20170602152010.2064-1-riel@redhat.com>
References: <20170602152010.2064-1-riel@redhat.com>
Subject: [kernel-hardening] [PATCH 6/6] powerpc,mmap: properly account for stack randomization in mmap_base
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, akpm@linux-foundation.org, mingo@kernel.org, oleg@redhat.com, lwoodman@redhat.com, mhocko@suse.de, danielmicay@gmail.com, will.deacon@arm.com, benh@kernel.crashing.org
List-ID: <kernel-hardening.lists.openwall.com>

From: Rik van Riel <riel@redhat.com>

When RLIMIT_STACK is, for example, 256MB, the current code results in
a gap between the top of the task and mmap_base of 256MB, failing to
take into account the amount by which the stack address was randomized.
In other words, the stack gets less than RLIMIT_STACK space.

Ensure that the gap between the stack and mmap_base always takes stack
randomization into account.

Inspired by Daniel Micay's linux-hardened tree.

Reported-by: Florian Weimer <fweimer@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 arch/powerpc/mm/mmap.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/mm/mmap.c b/arch/powerpc/mm/mmap.c
index 9dbd2a733d6b..354cfa22e5d4 100644
--- a/arch/powerpc/mm/mmap.c
+++ b/arch/powerpc/mm/mmap.c
@@ -34,16 +34,9 @@
 /*
  * Top of mmap area (just below the process stack).
  *
- * Leave at least a ~128 MB hole on 32bit applications.
- *
- * On 64bit applications we randomise the stack by 1GB so we need to
- * space our mmap start address by a further 1GB, otherwise there is a
- * chance the mmap area will end up closer to the stack than our ulimit
- * requires.
+ * Leave at least a ~128 MB hole.
  */
-#define MIN_GAP32 (128*1024*1024)
-#define MIN_GAP64 ((128 + 1024)*1024*1024UL)
-#define MIN_GAP ((is_32bit_task()) ? MIN_GAP32 : MIN_GAP64)
+#define MIN_GAP (128*1024*1024)
 #define MAX_GAP (TASK_SIZE/6*5)
 
 static inline int mmap_is_legacy(void)
@@ -71,9 +64,26 @@ unsigned long arch_mmap_rnd(void)
 	return rnd << PAGE_SHIFT;
 }
 
+static inline unsigned long stack_maxrandom_size(void)
+{
+	if (!(current->flags & PF_RANDOMIZE))
+		return 0;
+
+	/* 8MB for 32bit, 1GB for 64bit */
+	if (is_32bit_task())
+		return (1<<23);
+	else
+		return (1<<30);
+}
+
 static inline unsigned long mmap_base(unsigned long rnd)
 {
 	unsigned long gap = rlimit(RLIMIT_STACK);
+	unsigned long pad = stack_maxrandom_size();
+
+	/* Values close to RLIM_INFINITY can overflow. */
+	if (gap + pad > gap)
+		gap += pad;
 
 	if (gap < MIN_GAP)
 		gap = MIN_GAP;
-- 
2.9.3
