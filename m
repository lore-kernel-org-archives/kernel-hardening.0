From: Hoeun Ryu <hoeun.ryu@gmail.com>
Date: Sat,  4 Feb 2017 00:33:21 +0900
Message-Id: <1486136013-27565-1-git-send-email-hoeun.ryu@gmail.com>
Subject: [kernel-hardening] [PATCH 3/3] fork: allocate vmapped kernel stacks for cache when a cpu is up
To: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Mateusz Guzik <mguzik@redhat.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Hoeun Ryu <hoeun.ryu@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

when a cpu is up, predefined number of stacks are allocated and cached
immediately.

Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
---
 kernel/fork.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index 50de6cf..ee4067d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -194,6 +194,21 @@ static int alloc_vm_stack_cache(unsigned int cpu)
 	vm_stack_cache->cur = 0;
 	vm_stack_cache->nr = 0;
 
+	for (i = 0; i < NR_CACHED_STACKS; i++) {
+		void *stack = __vmalloc_node_range(THREAD_SIZE, THREAD_SIZE,
+						VMALLOC_START, VMALLOC_END,
+						THREADINFO_GFP | __GFP_HIGHMEM,
+						PAGE_KERNEL,
+						0, cpu_to_node(cpu),
+						__builtin_return_address(0));
+		if (!stack)
+			return -ENOMEM;
+
+		vm_stacks[i] = find_vm_area(stack);
+		vm_stack_cache->cur++;
+		vm_stack_cache->nr++;
+	}
+
 	return 0;
 }
 
-- 
2.7.4
