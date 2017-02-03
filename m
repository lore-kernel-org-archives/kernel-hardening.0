From: Hoeun Ryu <hoeun.ryu@gmail.com>
Date: Sat,  4 Feb 2017 00:32:39 +0900
Message-Id: <1486135977-27444-1-git-send-email-hoeun.ryu@gmail.com>
Subject: [kernel-hardening] [PATCH 2/3] fork: make number of cached stacks (vmapped) configurable using Kbuild
To: Kees Cook <keescook@chromium.org>, Michal Marek <mmarek@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Emese Revfy <re.emese@gmail.com>, Nicholas Piggin <npiggin@gmail.com>, =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Andy Lutomirski <luto@kernel.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Mateusz Guzik <mguzik@redhat.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Hoeun Ryu <hoeun.ryu@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Introducing NR_VMAP_STACK_CACHE, the number of cached stacks for virtually
mapped kernel stack can be configurable using Kbuild system.
default value is 2.

Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
---
 arch/Kconfig  | 8 ++++++++
 kernel/fork.c | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index d49a8e6..e94c432 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -849,6 +849,14 @@ config VMAP_STACK
 	  the stack to map directly to the KASAN shadow map using a formula
 	  that is incorrect if the stack is in vmalloc space.
 
+config NR_VMAP_STACK_CACHE
+	int "Number of cached stacks"
+	default "2"
+	depends on VMAP_STACK
+	---help---
+	  This determines how many stacks can be cached for virtually
+	  mapped kernel stacks.
+
 config ARCH_WANT_RELAX_ORDER
 	bool
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 54421a9..50de6cf 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -166,7 +166,7 @@ void __weak arch_release_thread_stack(unsigned long *stack)
  * vmalloc() is a bit slow, and calling vfree() enough times will force a TLB
  * flush.  Try to minimize the number of calls by caching stacks.
  */
-#define NR_CACHED_STACKS 2
+#define NR_CACHED_STACKS CONFIG_NR_VMAP_STACK_CACHE
 
 struct vm_stack_cache {
 	struct vm_struct **vm_stacks;
-- 
2.7.4
