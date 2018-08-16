From: Alexander Popov <alex.popov@linux.com>
Subject: [PATCH v15 6/7] stackleak: Allow runtime disabling of kernel stack erasing
Date: Fri, 17 Aug 2018 01:17:03 +0300
Message-Id: <1534457824-7211-7-git-send-email-alex.popov@linux.com>
In-Reply-To: <1534457824-7211-1-git-send-email-alex.popov@linux.com>
References: <1534457824-7211-1-git-send-email-alex.popov@linux.com>
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, x86@kernel.org, linux-kernel@vger.kernel.org, alex.popov@linux.com
List-ID: <kernel-hardening.lists.openwall.com>

Introduce CONFIG_STACKLEAK_RUNTIME_DISABLE option, which provides
'stack_erasing' sysctl. It can be used in runtime to control kernel
stack erasing for kernels built with CONFIG_GCC_PLUGIN_STACKLEAK.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 Documentation/sysctl/kernel.txt | 18 ++++++++++++++++++
 include/linux/stackleak.h       |  6 ++++++
 kernel/stackleak.c              | 38 ++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c                 | 15 ++++++++++++++-
 scripts/gcc-plugins/Kconfig     |  8 ++++++++
 5 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index eded671d..1feae79 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -87,6 +87,7 @@ show up in /proc/sys/kernel:
 - shmmni
 - softlockup_all_cpu_backtrace
 - soft_watchdog
+- stack_erasing
 - stop-a                      [ SPARC only ]
 - sysrq                       ==> Documentation/admin-guide/sysrq.rst
 - sysctl_writes_strict
@@ -962,6 +963,23 @@ detect a hard lockup condition.
 
 ==============================================================
 
+stack_erasing
+
+This parameter can be used to control kernel stack erasing at the end
+of syscalls for kernels built with CONFIG_GCC_PLUGIN_STACKLEAK.
+
+That erasing reduces the information which kernel stack leak bugs
+can reveal and blocks some uninitialized stack variable attacks.
+The tradeoff is the performance impact: on a single CPU system kernel
+compilation sees a 1% slowdown, other systems and workloads may vary.
+
+  0: kernel stack erasing is disabled, STACKLEAK_METRICS are not updated.
+
+  1: kernel stack erasing is enabled (default), it is performed before
+     returning to the userspace at the end of syscalls.
+
+==============================================================
+
 tainted:
 
 Non-zero if the kernel has been tainted. Numeric values, which can be
diff --git a/include/linux/stackleak.h b/include/linux/stackleak.h
index b911b97..3d5c327 100644
--- a/include/linux/stackleak.h
+++ b/include/linux/stackleak.h
@@ -22,6 +22,12 @@ static inline void stackleak_task_init(struct task_struct *t)
 	t->prev_lowest_stack = t->lowest_stack;
 # endif
 }
+
+#ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
+int stack_erasing_sysctl(struct ctl_table *table, int write,
+			void __user *buffer, size_t *lenp, loff_t *ppos);
+#endif
+
 #else /* !CONFIG_GCC_PLUGIN_STACKLEAK */
 static inline void stackleak_task_init(struct task_struct *t) { }
 #endif
diff --git a/kernel/stackleak.c b/kernel/stackleak.c
index f662395..e428929 100644
--- a/kernel/stackleak.c
+++ b/kernel/stackleak.c
@@ -12,6 +12,41 @@
 
 #include <linux/stackleak.h>
 
+#ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
+#include <linux/jump_label.h>
+#include <linux/sysctl.h>
+
+static DEFINE_STATIC_KEY_FALSE(stack_erasing_bypass);
+
+int stack_erasing_sysctl(struct ctl_table *table, int write,
+			void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret = 0;
+	int state = !static_branch_unlikely(&stack_erasing_bypass);
+	int prev_state = state;
+
+	table->data = &state;
+	table->maxlen = sizeof(int);
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	state = !!state;
+	if (ret || !write || state == prev_state)
+		return ret;
+
+	if (state)
+		static_branch_disable(&stack_erasing_bypass);
+	else
+		static_branch_enable(&stack_erasing_bypass);
+
+	pr_warn("stackleak: kernel stack erasing is %s\n",
+					state ? "enabled" : "disabled");
+	return ret;
+}
+
+#define skip_erasing()	static_branch_unlikely(&stack_erasing_bypass)
+#else
+#define skip_erasing()	false
+#endif /* CONFIG_STACKLEAK_RUNTIME_DISABLE */
+
 asmlinkage void stackleak_erase(void)
 {
 	/* It would be nice not to have 'kstack_ptr' and 'boundary' on stack */
@@ -20,6 +55,9 @@ asmlinkage void stackleak_erase(void)
 	unsigned int poison_count = 0;
 	const unsigned int depth = STACKLEAK_SEARCH_DEPTH / sizeof(unsigned long);
 
+	if (skip_erasing())
+		return;
+
 	/* Check that 'lowest_stack' value is sane */
 	if (unlikely(kstack_ptr - boundary >= THREAD_SIZE))
 		kstack_ptr = boundary;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f22f76b..faa216d 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -91,7 +91,9 @@
 #ifdef CONFIG_CHR_DEV_SG
 #include <scsi/sg.h>
 #endif
-
+#ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
+#include <linux/stackleak.h>
+#endif
 #ifdef CONFIG_LOCKUP_DETECTOR
 #include <linux/nmi.h>
 #endif
@@ -1222,6 +1224,17 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &one,
 	},
 #endif
+#ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
+	{
+		.procname	= "stack_erasing",
+		.data		= NULL,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= stack_erasing_sysctl,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+#endif
 	{ }
 };
 
diff --git a/scripts/gcc-plugins/Kconfig b/scripts/gcc-plugins/Kconfig
index f15093b..8b01c8e 100644
--- a/scripts/gcc-plugins/Kconfig
+++ b/scripts/gcc-plugins/Kconfig
@@ -182,4 +182,12 @@ config STACKLEAK_METRICS
 	  can be useful for estimating the STACKLEAK performance impact for
 	  your workloads.
 
+config STACKLEAK_RUNTIME_DISABLE
+	bool "Allow runtime disabling of kernel stack erasing"
+	depends on GCC_PLUGIN_STACKLEAK
+	help
+	  This option provides 'stack_erasing' sysctl, which can be used in
+	  runtime to control kernel stack erasing for kernels built with
+	  CONFIG_GCC_PLUGIN_STACKLEAK.
+
 endif
-- 
2.7.4
