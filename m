From: Hoeun Ryu <hoeun.ryu@gmail.com>
Date: Thu,  9 Feb 2017 13:03:47 +0900
Message-Id: <1486613040-30555-2-git-send-email-hoeun.ryu@gmail.com>
In-Reply-To: <1486613040-30555-1-git-send-email-hoeun.ryu@gmail.com>
References: <1486613040-30555-1-git-send-email-hoeun.ryu@gmail.com>
Subject: [kernel-hardening] [PATCH v2 2/2] fork: make number of cached stacks (vmapped) configurable using Kbuild
To: Kees Cook <keescook@chromium.org>, Michal Marek <mmarek@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Emese Revfy <re.emese@gmail.com>, Ingo Molnar <mingo@kernel.org>, =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Nicholas Piggin <npiggin@gmail.com>, Andy Lutomirski <luto@kernel.org>, Michal Hocko <mhocko@suse.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Mateusz Guzik <mguzik@redhat.com>
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
index d49a8e6..066d111 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -849,6 +849,14 @@ config VMAP_STACK
 	  the stack to map directly to the KASAN shadow map using a formula
 	  that is incorrect if the stack is in vmalloc space.
 
+config NR_VMAP_STACK_CACHE
+	int "Number of cached stacks"
+	default "2"
+	depends on VMAP_STACK
+	help
+	  This determines how many stacks can be cached for virtually
+	  mapped kernel stacks.
+
 config ARCH_WANT_RELAX_ORDER
 	bool
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 7911ed2..73ba1da 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -166,7 +166,7 @@ void __weak arch_release_thread_stack(unsigned long *stack)
  * vmalloc() is a bit slow, and calling vfree() enough times will force a TLB
  * flush.  Try to minimize the number of calls by caching stacks.
  */
-#define NR_CACHED_STACKS 2
+#define NR_CACHED_STACKS CONFIG_NR_VMAP_STACK_CACHE
 static DEFINE_PER_CPU(struct vm_struct *, cached_stacks[NR_CACHED_STACKS]);
 #endif
 
-- 
2.7.4
