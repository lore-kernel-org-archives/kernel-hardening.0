From: Kees Cook <keescook@chromium.org>
Date: Mon, 19 Jun 2017 13:56:38 -0700
Message-Id: <1497905801-69164-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1497905801-69164-1-git-send-email-keescook@chromium.org>
References: <1497905801-69164-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 1/4] task_struct: Allow randomized layout
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This marks most of the layout of task_struct as randomizable, but leaves
thread_info and scheduler state untouched at the start, and thread_struct
untouched at the end.

Other parts of the kernel use unnamed structures, but the 0-day builder
using gcc-4.4 blows up on static initializers. Officially, it's documented
as only working on gcc 4.6 and later, which further confuses me:
	https://gcc.gnu.org/wiki/C11Status
The structure layout randomization already requires gcc 4.7, but instead
of depending on the plugin being enabled, just check the gcc versions
for wider build testing. At Linus's suggestion, the marking is hidden
in a macro to reduce how ugly it looks. Additionally, indenting is left
unchanged since it would make things harder to read.

Randomization of task_struct is modified from Brad Spengler/PaX Team's
code in the last public patch of grsecurity/PaX based on my understanding
of the code. Changes or omissions from the original code are mine and
don't reflect the original grsecurity/PaX code.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/compiler-gcc.h | 13 ++++++++++++-
 include/linux/compiler.h     |  5 +++++
 include/linux/sched.h        | 14 ++++++++++++++
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 7deaae3dc87d..c4a66c036692 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -231,6 +231,7 @@
 #endif /* GCC_VERSION >= 40500 */
 
 #if GCC_VERSION >= 40600
+
 /*
  * When used with Link Time Optimization, gcc can optimize away C functions or
  * variables which are referenced only from assembly code.  __visible tells the
@@ -238,7 +239,17 @@
  * this.
  */
 #define __visible	__attribute__((externally_visible))
-#endif
+
+/*
+ * RANDSTRUCT_PLUGIN wants to use an anonymous struct, but it is only
+ * possible since GCC 4.6. To provide as much build testing coverage
+ * as possible, this is used for all GCC 4.6+ builds, and not just on
+ * RANDSTRUCT_PLUGIN builds.
+ */
+#define randomized_struct_fields_start	struct {
+#define randomized_struct_fields_end	} __randomize_layout;
+
+#endif /* GCC_VERSION >= 40600 */
 
 
 #if GCC_VERSION >= 40900 && !defined(__CHECKER__)
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 55ee9ee814f8..0b4ac3e8c63e 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -456,6 +456,11 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
 # define __no_randomize_layout
 #endif
 
+#ifndef randomized_struct_fields_start
+# define randomized_struct_fields_start
+# define randomized_struct_fields_end
+#endif
+
 /*
  * Tell gcc if a function is cold. The compiler will assume any path
  * directly leading to the call is unlikely.
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f833254fce00..e2ad3531e7fe 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -490,6 +490,13 @@ struct task_struct {
 #endif
 	/* -1 unrunnable, 0 runnable, >0 stopped: */
 	volatile long			state;
+
+	/*
+	 * This begins the randomizable portion of task_struct. Only
+	 * scheduling-critical items should be added above here.
+	 */
+	randomized_struct_fields_start
+
 	void				*stack;
 	atomic_t			usage;
 	/* Per task flags (PF_*), defined further below: */
@@ -1051,6 +1058,13 @@ struct task_struct {
 	/* Used by LSM modules for access restriction: */
 	void				*security;
 #endif
+
+	/*
+	 * New fields for task_struct should be added above here, so that
+	 * they are included in the randomized portion of task_struct.
+	 */
+	randomized_struct_fields_end
+
 	/* CPU-specific state of this task: */
 	struct thread_struct		thread;
 
-- 
2.7.4
