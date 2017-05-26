From: Kees Cook <keescook@chromium.org>
Date: Fri, 26 May 2017 13:17:23 -0700
Message-Id: <1495829844-69341-20-git-send-email-keescook@chromium.org>
In-Reply-To: <1495829844-69341-1-git-send-email-keescook@chromium.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 19/20] [RFC] task_struct: Allow randomized layout
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
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
for wider build testing. (But I'd rather find a way to avoid the #ifdef
entirely.)

One question about formatting remains: should this patch indent all the
randomized fields, due to the added unnamed struct, which would make
this patch white-space huge, or should I leave the indentation level
alone, to avoid massive churn? I opted for making the patch more readable,
but can easily do the indentation here or as a separate patch. It's not
obvious to me what is the least invasive change to make...

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/sched.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b1298ad4da63..a9f7f957169c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -490,6 +490,12 @@ struct task_struct {
 #endif
 	/* -1 unrunnable, 0 runnable, >0 stopped: */
 	volatile long			state;
+
+	/* This begins the randomizable portion of task_struct... */
+#if GCC_VERSION >= 40600
+	struct {
+#endif
+
 	void				*stack;
 	atomic_t			usage;
 	/* Per task flags (PF_*), defined further below: */
@@ -1052,6 +1058,14 @@ struct task_struct {
 	/* Used by LSM modules for access restriction: */
 	void				*security;
 #endif
+
+	/*
+	 * New fields for task_struct should be added above here.
+	 */
+#if GCC_VERSION >= 40600
+	} __randomize_layout;
+#endif
+
 	/* CPU-specific state of this task: */
 	struct thread_struct		thread;
 
-- 
2.7.4
