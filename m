From: riel@redhat.com
Date: Fri,  2 Jun 2017 11:20:07 -0400
Message-Id: <20170602152010.2064-4-riel@redhat.com>
In-Reply-To: <20170602152010.2064-1-riel@redhat.com>
References: <20170602152010.2064-1-riel@redhat.com>
Subject: [kernel-hardening] [PATCH 3/6] x86/mmap: properly account for stack randomization in mmap_base
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
 arch/x86/mm/mmap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 19ad095b41df..8c7ba1adb27b 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -95,13 +95,18 @@ unsigned long arch_mmap_rnd(void)
 static unsigned long mmap_base(unsigned long rnd, unsigned long task_size)
 {
 	unsigned long gap = rlimit(RLIMIT_STACK);
+	unsigned long pad = stack_maxrandom_size(task_size);
 	unsigned long gap_min, gap_max;
 
+	/* Values close to RLIM_INFINITY can overflow. */
+	if (gap + pad > gap)
+		gap += pad;
+
 	/*
 	 * Top of mmap area (just below the process stack).
 	 * Leave an at least ~128 MB hole with possible stack randomization.
 	 */
-	gap_min = SIZE_128M + stack_maxrandom_size(task_size);
+	gap_min = SIZE_128M;
 	gap_max = (task_size / 6) * 5;
 
 	if (gap < gap_min)
-- 
2.9.3
