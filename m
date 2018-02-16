From: Alexander Popov <alex.popov@linux.com>
Subject: [PATCH RFC v8 5/6] fs/proc: Show STACKLEAK metrics in the /proc file system
Date: Fri, 16 Feb 2018 21:10:56 +0300
Message-Id: <1518804657-24905-6-git-send-email-alex.popov@linux.com>
In-Reply-To: <1518804657-24905-1-git-send-email-alex.popov@linux.com>
References: <1518804657-24905-1-git-send-email-alex.popov@linux.com>
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, x86@kernel.org, alex.popov@linux.com
List-ID: <kernel-hardening.lists.openwall.com>

Introduce CONFIG_STACKLEAK_METRICS providing STACKLEAK information about
tasks via the /proc file system. In particular, /proc/<pid>/stack_depth
shows the maximum kernel stack consumption for the current and previous
syscalls. Although this information is not precise, it  can be useful for
estimating the STACKLEAK performance impact for your workloads.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 arch/Kconfig                     | 12 ++++++++++++
 arch/x86/entry/entry_32.S        |  4 ++++
 arch/x86/entry/entry_64.S        |  4 ++++
 arch/x86/include/asm/processor.h |  3 +++
 arch/x86/kernel/asm-offsets.c    |  3 +++
 arch/x86/kernel/process_32.c     |  3 +++
 arch/x86/kernel/process_64.c     |  3 +++
 fs/proc/base.c                   | 18 ++++++++++++++++++
 8 files changed, 50 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index a4a8fba..42ebfb9 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -572,6 +572,18 @@ config STACKLEAK_TRACK_MIN_SIZE
 	  frame size greater than or equal to this parameter.
 	  If unsure, leave the default value 100.
 
+config STACKLEAK_METRICS
+	bool "Show STACKLEAK metrics in the /proc file system"
+	depends on GCC_PLUGIN_STACKLEAK
+	depends on PROC_FS
+	help
+	  If this is set, STACKLEAK metrics for every task are available in
+	  the /proc file system. In particular, /proc/<pid>/stack_depth
+	  shows the maximum kernel stack consumption for the current and
+	  previous syscalls. Although this information is not precise, it
+	  can be useful for estimating the STACKLEAK performance impact for
+	  your workloads.
+
 config HAVE_CC_STACKPROTECTOR
 	bool
 	help
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 4a7365a..c6613ca 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -134,6 +134,10 @@ ENTRY(erase_kstack)
 	mov	%esp, %ecx
 	sub	%edi, %ecx
 
+#ifdef CONFIG_STACKLEAK_METRICS
+	mov	%edi, TASK_prev_lowest_stack(%ebp)
+#endif
+
 	/* Check that the counter value is sane. */
 	cmp	$THREAD_SIZE_asm, %ecx
 	jb	3f
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 6863af8..b418d3a 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -119,6 +119,10 @@ ENTRY(erase_kstack)
 	 */
 	or	$2 * 8, %rdi
 
+#ifdef CONFIG_STACKLEAK_METRICS
+	mov	%rdi, TASK_prev_lowest_stack(%r11)
+#endif
+
 	/*
 	 * Check whether we are on the thread stack to prepare the counter
 	 * for stack poisoning.
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 5fd8ae1..871e197 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -496,6 +496,9 @@ struct thread_struct {
 
 #ifdef CONFIG_GCC_PLUGIN_STACKLEAK
 	unsigned long		lowest_stack;
+# ifdef CONFIG_STACKLEAK_METRICS
+	unsigned long		prev_lowest_stack;
+# endif
 #endif
 
 	unsigned int		sig_on_uaccess_err:1;
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index ef5d260..f48197a 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -41,6 +41,9 @@ void common(void) {
 	OFFSET(TASK_addr_limit, task_struct, thread.addr_limit);
 #ifdef CONFIG_GCC_PLUGIN_STACKLEAK
 	OFFSET(TASK_lowest_stack, task_struct, thread.lowest_stack);
+# ifdef CONFIG_STACKLEAK_METRICS
+	OFFSET(TASK_prev_lowest_stack, task_struct, thread.prev_lowest_stack);
+# endif
 #endif
 
 	BLANK();
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 6d256ab..48993fe 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -139,6 +139,9 @@ int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
 #ifdef CONFIG_GCC_PLUGIN_STACKLEAK
 	p->thread.lowest_stack = (unsigned long)task_stack_page(p) +
 						2 * sizeof(unsigned long);
+# ifdef CONFIG_STACKLEAK_METRICS
+	p->thread.prev_lowest_stack = p->thread.lowest_stack;
+# endif
 #endif
 
 	if (unlikely(p->flags & PF_KTHREAD)) {
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6dc55f6..0355fba 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -284,6 +284,9 @@ int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
 #ifdef CONFIG_GCC_PLUGIN_STACKLEAK
 	p->thread.lowest_stack = (unsigned long)task_stack_page(p) +
 						2 * sizeof(unsigned long);
+# ifdef CONFIG_STACKLEAK_METRICS
+	p->thread.prev_lowest_stack = p->thread.lowest_stack;
+# endif
 #endif
 
 	savesegment(gs, p->thread.gsindex);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9298324..6a7f9bd 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2914,6 +2914,21 @@ static int proc_pid_patch_state(struct seq_file *m, struct pid_namespace *ns,
 }
 #endif /* CONFIG_LIVEPATCH */
 
+#ifdef CONFIG_STACKLEAK_METRICS
+static int proc_stack_depth(struct seq_file *m, struct pid_namespace *ns,
+				struct pid *pid, struct task_struct *task)
+{
+	unsigned long prev_depth = THREAD_SIZE -
+			(task->thread.prev_lowest_stack & (THREAD_SIZE - 1));
+	unsigned long depth = THREAD_SIZE -
+			(task->thread.lowest_stack & (THREAD_SIZE - 1));
+
+	seq_printf(m, "previous stack depth: %lu\nstack depth: %lu\n",
+							prev_depth, depth);
+	return 0;
+}
+#endif /* CONFIG_STACKLEAK_METRICS */
+
 /*
  * Thread groups
  */
@@ -3018,6 +3033,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_LIVEPATCH
 	ONE("patch_state",  S_IRUSR, proc_pid_patch_state),
 #endif
+#ifdef CONFIG_STACKLEAK_METRICS
+	ONE("stack_depth", S_IRUGO, proc_stack_depth),
+#endif
 };
 
 static int proc_tgid_base_readdir(struct file *file, struct dir_context *ctx)
-- 
2.7.4
