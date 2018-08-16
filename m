From: Alexander Popov <alex.popov@linux.com>
Subject: [PATCH v15 4/7] fs/proc: Show STACKLEAK metrics in the /proc file system
Date: Fri, 17 Aug 2018 01:17:01 +0300
Message-Id: <1534457824-7211-5-git-send-email-alex.popov@linux.com>
In-Reply-To: <1534457824-7211-1-git-send-email-alex.popov@linux.com>
References: <1534457824-7211-1-git-send-email-alex.popov@linux.com>
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, x86@kernel.org, linux-kernel@vger.kernel.org, alex.popov@linux.com
List-ID: <kernel-hardening.lists.openwall.com>

Introduce CONFIG_STACKLEAK_METRICS providing STACKLEAK information about
tasks via the /proc file system. In particular, /proc/<pid>/stack_depth
shows the maximum kernel stack consumption for the current and previous
syscalls. Although this information is not precise, it can be useful for
estimating the STACKLEAK performance impact for your workloads.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 fs/proc/base.c              | 18 ++++++++++++++++++
 include/linux/sched.h       |  1 +
 include/linux/stackleak.h   |  3 +++
 kernel/stackleak.c          |  4 ++++
 scripts/gcc-plugins/Kconfig | 12 ++++++++++++
 5 files changed, 38 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index aaffc0c..66ee5b7 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2893,6 +2893,21 @@ static int proc_pid_patch_state(struct seq_file *m, struct pid_namespace *ns,
 }
 #endif /* CONFIG_LIVEPATCH */
 
+#ifdef CONFIG_STACKLEAK_METRICS
+static int proc_stack_depth(struct seq_file *m, struct pid_namespace *ns,
+				struct pid *pid, struct task_struct *task)
+{
+	unsigned long prev_depth = THREAD_SIZE -
+				(task->prev_lowest_stack & (THREAD_SIZE - 1));
+	unsigned long depth = THREAD_SIZE -
+				(task->lowest_stack & (THREAD_SIZE - 1));
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
@@ -2994,6 +3009,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_LIVEPATCH
 	ONE("patch_state",  S_IRUSR, proc_pid_patch_state),
 #endif
+#ifdef CONFIG_STACKLEAK_METRICS
+	ONE("stack_depth", S_IRUGO, proc_stack_depth),
+#endif
 };
 
 static int proc_tgid_base_readdir(struct file *file, struct dir_context *ctx)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index bbf2f7a..2540d0e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1189,6 +1189,7 @@ struct task_struct {
 
 #ifdef CONFIG_GCC_PLUGIN_STACKLEAK
 	unsigned long			lowest_stack;
+	unsigned long			prev_lowest_stack;
 #endif
 
 	/*
diff --git a/include/linux/stackleak.h b/include/linux/stackleak.h
index 628c2b9..b911b97 100644
--- a/include/linux/stackleak.h
+++ b/include/linux/stackleak.h
@@ -18,6 +18,9 @@
 static inline void stackleak_task_init(struct task_struct *t)
 {
 	t->lowest_stack = (unsigned long)end_of_stack(t) + sizeof(unsigned long);
+# ifdef CONFIG_STACKLEAK_METRICS
+	t->prev_lowest_stack = t->lowest_stack;
+# endif
 }
 #else /* !CONFIG_GCC_PLUGIN_STACKLEAK */
 static inline void stackleak_task_init(struct task_struct *t) { }
diff --git a/kernel/stackleak.c b/kernel/stackleak.c
index 628485d..f662395 100644
--- a/kernel/stackleak.c
+++ b/kernel/stackleak.c
@@ -41,6 +41,10 @@ asmlinkage void stackleak_erase(void)
 	if (kstack_ptr == boundary)
 		kstack_ptr += sizeof(unsigned long);
 
+#ifdef CONFIG_STACKLEAK_METRICS
+	current->prev_lowest_stack = kstack_ptr;
+#endif
+
 	/*
 	 * Now write the poison value to the kernel stack. Start from
 	 * 'kstack_ptr' and move up till the new 'boundary'. We assume that
diff --git a/scripts/gcc-plugins/Kconfig b/scripts/gcc-plugins/Kconfig
index cd69bff..f15093b 100644
--- a/scripts/gcc-plugins/Kconfig
+++ b/scripts/gcc-plugins/Kconfig
@@ -170,4 +170,16 @@ config STACKLEAK_TRACK_MIN_SIZE
 	  a stack frame size greater than or equal to this parameter.
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
 endif
-- 
2.7.4
