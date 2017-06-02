From: riel@redhat.com
Date: Fri,  2 Jun 2017 11:20:08 -0400
Message-Id: <20170602152010.2064-5-riel@redhat.com>
In-Reply-To: <20170602152010.2064-1-riel@redhat.com>
References: <20170602152010.2064-1-riel@redhat.com>
Subject: [kernel-hardening] [PATCH 4/6] arm64/mmap: properly account for stack randomization in mmap_base
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

>From Daniel Micay's linux-hardened tree.

Reported-by: Florian Weimer <fweimer@redhat.com>
Signed-off-by: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 arch/arm64/mm/mmap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
index 7b0d55756eb1..3f15eb193e33 100644
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -34,7 +34,7 @@
  * Leave enough space between the mmap area and the stack to honour ulimit in
  * the face of randomisation.
  */
-#define MIN_GAP (SZ_128M + ((STACK_RND_MASK << PAGE_SHIFT) + 1))
+#define MIN_GAP (SZ_128M)
 #define MAX_GAP	(STACK_TOP/6*5)
 
 static int mmap_is_legacy(void)
@@ -64,6 +64,11 @@ unsigned long arch_mmap_rnd(void)
 static unsigned long mmap_base(unsigned long rnd)
 {
 	unsigned long gap = rlimit(RLIMIT_STACK);
+	unsigned long pad = STACK_RND_MASK << PAGE_SHIFT;
+
+	/* Values close to RLIM_INFINITY can overflow. */
+	if (gap + pad > gap)
+		gap += pad;
 
 	if (gap < MIN_GAP)
 		gap = MIN_GAP;
-- 
2.9.3
