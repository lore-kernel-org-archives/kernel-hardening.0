Date: Tue, 16 Jan 2018 21:50:15 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20180117055015.GA15256@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] fork: Allow stack to be wiped on fork
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@kernel.org>, Laura Abbott <labbott@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, Sahara <keun-o.park@darkmatter.ae>, "Levin, Alexander (Sasha Levin)" <alexander.levin@verizon.com>, Michal Hocko <mhocko@suse.com>, Andrea Arcangeli <aarcange@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

One of the classes of kernel stack content leaks is exposing the contents
of prior heap or stack contents when a new process stack is allocated.
Normally, those stacks are not zeroed, and the old contents remain in
place. With some types of stack content exposure flaws, those contents
can leak to userspace. Kernels built with CONFIG_CLEAR_STACK_FORK will
no longer be vulnerable to this, as the stack will be wiped each time
a stack is assigned to a new process. There's not a meaningful change
in runtime performance; it almost looks like it provides a benefit.

Performing back-to-back kernel builds before:
	Run times: 157.86 157.09 158.90 160.94 160.80
	Mean: 159.12
	Std Dev: 1.54

With CONFIG_CLEAR_STACK_FORK=y:
	Run times: 159.31 157.34 156.71 158.15 160.81
	Mean: 158.46
	Std Dev: 1.46

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/Kconfig                | 8 ++++++++
 include/linux/thread_info.h | 4 +++-
 kernel/fork.c               | 2 +-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 400b9e1b2f27..42d56dad03ec 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -904,6 +904,14 @@ config VMAP_STACK
 	  the stack to map directly to the KASAN shadow map using a formula
 	  that is incorrect if the stack is in vmalloc space.
 
+config CLEAR_STACK_FORK
+	bool "Clear the kernel stack at each fork"
+	help
+	  To resist stack content leak flaws, this clears newly allocated
+	  kernel stacks to keep previously freed heap or stack contents
+	  from being present in the new stack. This has almost no
+	  measurable performance impact.
+
 config ARCH_OPTIONAL_KERNEL_RWX
 	def_bool n
 
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index 34f053a150a9..091f53fe31cc 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -43,7 +43,9 @@ enum {
 #define THREAD_ALIGN	THREAD_SIZE
 #endif
 
-#if IS_ENABLED(CONFIG_DEBUG_STACK_USAGE) || IS_ENABLED(CONFIG_DEBUG_KMEMLEAK)
+#if IS_ENABLED(CONFIG_DEBUG_STACK_USAGE) || \
+    IS_ENABLED(CONFIG_DEBUG_KMEMLEAK) || \
+    IS_ENABLED(CONFIG_CLEAR_STACK_FORK)
 # define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT | __GFP_ZERO)
 #else
 # define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT)
diff --git a/kernel/fork.c b/kernel/fork.c
index 2295fc69717f..215b1ce2b2cd 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -215,7 +215,7 @@ static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
 		if (!s)
 			continue;
 
-#ifdef CONFIG_DEBUG_KMEMLEAK
+#if IS_ENABLED(CONFIG_DEBUG_KMEMLEAK) || IS_ENABLED(CONFIG_CLEAR_STACK_FORK)
 		/* Clear stale pointers from reused stack. */
 		memset(s->addr, 0, THREAD_SIZE);
 #endif
-- 
2.7.4


-- 
Kees Cook
Pixel Security
