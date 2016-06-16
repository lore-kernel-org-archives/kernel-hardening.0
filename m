Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 15 Jun 2016 17:28:26 -0700
Message-Id: <24279d4009c821de64109055665429fad2a7bff7.1466036668.git.luto@kernel.org>
In-Reply-To: <cover.1466036668.git.luto@kernel.org>
References: <cover.1466036668.git.luto@kernel.org>
In-Reply-To: <cover.1466036668.git.luto@kernel.org>
References: <cover.1466036668.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH 04/13] mm: Track NR_KERNEL_STACK in pages instead of number of stacks
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, x86@kernel.org, Borislav Petkov <bp@alien8.de>
Cc: Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Andy Lutomirski <luto@kernel.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org
List-ID: <kernel-hardening.lists.openwall.com>

Currently, NR_KERNEL_STACK tracks the number of kernel stacks in a
zone.  This only makes sense if each kernel stack exists entirely in
one zone, and allowing vmapped stacks could break this assumption.

It turns out that the code for tracking kernel stack allocations in
units of pages is slightly simpler, so just switch to counting
pages.

Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 fs/proc/meminfo.c | 2 +-
 kernel/fork.c     | 3 ++-
 mm/page_alloc.c   | 3 +--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 83720460c5bc..8338c0569a8d 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -145,7 +145,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 				global_page_state(NR_SLAB_UNRECLAIMABLE)),
 		K(global_page_state(NR_SLAB_RECLAIMABLE)),
 		K(global_page_state(NR_SLAB_UNRECLAIMABLE)),
-		global_page_state(NR_KERNEL_STACK) * THREAD_SIZE / 1024,
+		K(global_page_state(NR_KERNEL_STACK)),
 		K(global_page_state(NR_PAGETABLE)),
 #ifdef CONFIG_QUICKLIST
 		K(quicklist_total_size()),
diff --git a/kernel/fork.c b/kernel/fork.c
index 5c2c355aa97f..95bebde59d79 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -225,7 +225,8 @@ static void account_kernel_stack(struct thread_info *ti, int account)
 {
 	struct zone *zone = page_zone(virt_to_page(ti));
 
-	mod_zone_page_state(zone, NR_KERNEL_STACK, account);
+	mod_zone_page_state(zone, NR_KERNEL_STACK,
+			    THREAD_SIZE / PAGE_SIZE * account);
 }
 
 void free_task(struct task_struct *tsk)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6903b695ebae..2b0203b3a976 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4457,8 +4457,7 @@ void show_free_areas(unsigned int filter)
 			K(zone_page_state(zone, NR_SHMEM)),
 			K(zone_page_state(zone, NR_SLAB_RECLAIMABLE)),
 			K(zone_page_state(zone, NR_SLAB_UNRECLAIMABLE)),
-			zone_page_state(zone, NR_KERNEL_STACK) *
-				THREAD_SIZE / 1024,
+			K(zone_page_state(zone, NR_KERNEL_STACK)),
 			K(zone_page_state(zone, NR_PAGETABLE)),
 			K(zone_page_state(zone, NR_UNSTABLE_NFS)),
 			K(zone_page_state(zone, NR_BOUNCE)),
-- 
2.7.4
