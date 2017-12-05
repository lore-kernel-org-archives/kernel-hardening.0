From: Alexander Popov <alex.popov@linux.com>
Date: Wed,  6 Dec 2017 02:33:46 +0300
Message-Id: <1512516827-29797-6-git-send-email-alex.popov@linux.com>
In-Reply-To: <1512516827-29797-1-git-send-email-alex.popov@linux.com>
References: <1512516827-29797-1-git-send-email-alex.popov@linux.com>
Subject: [kernel-hardening] [PATCH RFC v6 5/6] fs/proc: Show STACKLEAK metrics in the /proc file system
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, x86@kernel.org, alex.popov@linux.com
List-ID: <kernel-hardening.lists.openwall.com>

Introduce CONFIG_STACKLEAK_METRICS providing STACKLEAK information about
tasks via the /proc file system. In particular, /proc/<pid>/lowest_stack
shows the current lowest_stack value and its final value from the previous
syscall. That information can be useful for estimating the STACKLEAK
performance impact for different workloads.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 arch/Kconfig                     | 11 +++++++++++
 arch/x86/entry/entry_32.S        |  4 ++++
 arch/x86/entry/entry_64.S        |  4 ++++
 arch/x86/include/asm/processor.h |  3 +++
 arch/x86/kernel/asm-offsets.c    |  3 +++
 arch/x86/kernel/process_32.c     |  3 +++
 arch/x86/kernel/process_64.c     |  3 +++
 fs/proc/base.c                   | 14 ++++++++++++++
 8 files changed, 45 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index ba8e67b..3d8405c 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -559,6 +559,17 @@ config STACKLEAK_TRACK_MIN_SIZE
 	  this setting, don't break the poison search in erase_kstack.
 	  If unsure, leave the default value 100.
 
+config STACKLEAK_METRICS
+	bool "Show STACKLEAK metrics in the /proc file system"
+	depends on GCC_PLUGIN_STACKLEAK
+	depends on PROC_FS
+	help
+	  If this is set, STACKLEAK metrics for every task are available in
+	  the /proc file system. In particular, /proc/<pid>/lowest_stack
+	  shows the current lowest_stack value and its final value from the
+	  previous syscall. That information can be useful for estimating
+	  the STACKLEAK performance impact for your workloads.
+
 config HAVE_CC_STACKPROTECTOR
 	bool
 	help
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 8e4f815..2b76020 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -116,6 +116,10 @@ ENTRY(erase_kstack)
 	mov	%esp, %ecx
 	sub	%edi, %ecx
 
+#ifdef CONFIG_STACKLEAK_METRICS
+	mov	%edi, TASK_prev_lowest_stack(%ebp)
+#endif
+
 	cmp	$THREAD_SIZE_asm, %ecx
 	jb	3f
 	ud2
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 94f659d..32ee040 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -121,6 +121,10 @@ ENTRY(erase_kstack)
 	mov	%esp, %ecx
 	sub	%edi, %ecx
 
+#ifdef CONFIG_STACKLEAK_METRICS
+	mov	%rdi, TASK_prev_lowest_stack(%r11)
+#endif
+
 	/* Check that the counter value is sane. */
 	cmp	$THREAD_SIZE_asm, %rcx
 	jb	3f
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 520508d..c94fc2f 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -483,6 +483,9 @@ struct thread_struct {
 
 #ifdef CONFIG_GCC_PLUGIN_STACKLEAK
 	unsigned long		lowest_stack;
+# ifdef CONFIG_STACKLEAK_METRICS
+	unsigned long		prev_lowest_stack;
+# endif
 #endif
 
 	unsigned int		sig_on_uaccess_err:1;
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 692c10e..84c5a29 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -43,6 +43,9 @@ void common(void) {
 # ifdef CONFIG_X86_32
 	OFFSET(TASK_thread_sp0, task_struct, thread.sp0);
 # endif
+# ifdef CONFIG_STACKLEAK_METRICS
+	OFFSET(TASK_prev_lowest_stack, task_struct, thread.prev_lowest_stack);
+# endif
 #endif
 
 	BLANK();
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 2bea3bf..5615b3d 100644
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
index 1641463..d4a50ef 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -285,6 +285,9 @@ int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
 #ifdef CONFIG_GCC_PLUGIN_STACKLEAK
 	p->thread.lowest_stack = (unsigned long)task_stack_page(p) +
 						2 * sizeof(unsigned long);
+# ifdef CONFIG_STACKLEAK_METRICS
+	p->thread.prev_lowest_stack = p->thread.lowest_stack;
+# endif
 #endif
 
 	savesegment(gs, p->thread.gsindex);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 28fa852..3569446 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2884,6 +2884,17 @@ static int proc_pid_patch_state(struct seq_file *m, struct pid_namespace *ns,
 }
 #endif /* CONFIG_LIVEPATCH */
 
+#ifdef CONFIG_STACKLEAK_METRICS
+static int proc_lowest_stack(struct seq_file *m, struct pid_namespace *ns,
+				struct pid *pid, struct task_struct *task)
+{
+	seq_printf(m, "prev_lowest_stack: %pK\nlowest_stack: %pK\n",
+		   (void *)task->thread.prev_lowest_stack,
+		   (void *)task->thread.lowest_stack);
+	return 0;
+}
+#endif /* CONFIG_STACKLEAK_METRICS */
+
 /*
  * Thread groups
  */
@@ -2988,6 +2999,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_LIVEPATCH
 	ONE("patch_state",  S_IRUSR, proc_pid_patch_state),
 #endif
+#ifdef CONFIG_STACKLEAK_METRICS
+	ONE("lowest_stack", S_IRUGO, proc_lowest_stack),
+#endif
 };
 
 static int proc_tgid_base_readdir(struct file *file, struct dir_context *ctx)
-- 
2.7.4
