Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 15 Jun 2016 17:28:27 -0700
Message-Id: <31f2e076a21321eedd71babb1a4791c5ad171a20.1466036668.git.luto@kernel.org>
In-Reply-To: <cover.1466036668.git.luto@kernel.org>
References: <cover.1466036668.git.luto@kernel.org>
In-Reply-To: <cover.1466036668.git.luto@kernel.org>
References: <cover.1466036668.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH 05/13] mm: Move memcg stack accounting to account_kernel_stack
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, x86@kernel.org, Borislav Petkov <bp@alien8.de>
Cc: Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Andy Lutomirski <luto@kernel.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org
List-ID: <kernel-hardening.lists.openwall.com>

We should account for stacks regardless of stack size.  Move it into
account_kernel_stack.

Fixes: 12580e4b54ba8 ("mm: memcontrol: report kernel stack usage in cgroup2 memory.stat")
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 kernel/fork.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 95bebde59d79..59e52f2120a3 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -165,20 +165,12 @@ static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
 	struct page *page = alloc_kmem_pages_node(node, THREADINFO_GFP,
 						  THREAD_SIZE_ORDER);
 
-	if (page)
-		memcg_kmem_update_page_stat(page, MEMCG_KERNEL_STACK,
-					    1 << THREAD_SIZE_ORDER);
-
 	return page ? page_address(page) : NULL;
 }
 
 static inline void free_thread_info(struct thread_info *ti)
 {
-	struct page *page = virt_to_page(ti);
-
-	memcg_kmem_update_page_stat(page, MEMCG_KERNEL_STACK,
-				    -(1 << THREAD_SIZE_ORDER));
-	__free_kmem_pages(page, THREAD_SIZE_ORDER);
+	free_kmem_pages((unsigned long)ti, THREAD_SIZE_ORDER);
 }
 # else
 static struct kmem_cache *thread_info_cache;
@@ -227,6 +219,11 @@ static void account_kernel_stack(struct thread_info *ti, int account)
 
 	mod_zone_page_state(zone, NR_KERNEL_STACK,
 			    THREAD_SIZE / PAGE_SIZE * account);
+
+	/* All stack pages belong to the same memcg. */
+	memcg_kmem_update_page_stat(
+		virt_to_page(ti), MEMCG_KERNEL_STACK,
+		account * (THREAD_SIZE / PAGE_SIZE));
 }
 
 void free_task(struct task_struct *tsk)
-- 
2.7.4
