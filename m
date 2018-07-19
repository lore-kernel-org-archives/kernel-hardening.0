From: Alexander Popov <alex.popov@linux.com>
Subject: [PATCH v14 7/7] stackleak, sysctl: Allow runtime disabling of kernel stack erasing
Date: Thu, 19 Jul 2018 14:31:29 +0300
Message-Id: <1531999889-18343-1-git-send-email-alex.popov@linux.com>
In-Reply-To: <20180717071223.GA29533@gmail.com>
References: <20180717071223.GA29533@gmail.com>
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Kees Cook <keescook@google.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, x86@kernel.org, linux-kernel@vger.kernel.org, alex.popov@linux.com
List-ID: <kernel-hardening.lists.openwall.com>

Introduce CONFIG_STACKLEAK_RUNTIME_DISABLE option, which provides
'stack_erasing_bypass' sysctl. It can be used in runtime to disable
kernel stack erasing for kernels built with CONFIG_GCC_PLUGIN_STACKLEAK.
Stack erasing will then remain disabled and STACKLEAK_METRICS will not
be updated until the next boot.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 Documentation/sysctl/kernel.txt | 19 +++++++++++++++++++
 include/linux/stackleak.h       |  6 ++++++
 kernel/stackleak.c              | 40 ++++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c                 | 15 ++++++++++++++-
 scripts/gcc-plugins/Kconfig     | 10 ++++++++++
 5 files changed, 89 insertions(+), 1 deletion(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index eded671d..63b7493 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -87,6 +87,7 @@ show up in /proc/sys/kernel:
 - shmmni
 - softlockup_all_cpu_backtrace
 - soft_watchdog
+- stack_erasing_bypass
 - stop-a                      [ SPARC only ]
 - sysrq                       ==> Documentation/admin-guide/sysrq.rst
 - sysctl_writes_strict
@@ -962,6 +963,24 @@ detect a hard lockup condition.
 
 ==============================================================
 
+stack_erasing_bypass
+
+This parameter can be used to disable kernel stack erasing at the end
+of syscalls for kernels built with CONFIG_GCC_PLUGIN_STACKLEAK.
+
+That erasing reduces the information which kernel stack leak bugs
+can reveal and blocks some uninitialized stack variable attacks.
+The tradeoff is the performance impact: on a single CPU system kernel
+compilation sees a 1% slowdown, other systems and workloads may vary.
+
+  0: do nothing - stack erasing is enabled by default.
+
+  1: enable stack erasing bypass - stack erasing will then remain
+     disabled and STACKLEAK_METRICS will not be updated until the
+     next boot.
+
+==============================================================
+
 tainted:
 
 Non-zero if the kernel has been tainted. Numeric values, which can be
diff --git a/include/linux/stackleak.h b/include/linux/stackleak.h
index b911b97..e1fc3d1 100644
--- a/include/linux/stackleak.h
+++ b/include/linux/stackleak.h
@@ -22,6 +22,12 @@ static inline void stackleak_task_init(struct task_struct *t)
 	t->prev_lowest_stack = t->lowest_stack;
 # endif
 }
+
+#ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
+int stack_erasing_bypass_sysctl(struct ctl_table *table, int write,
+			void __user *buffer, size_t *lenp, loff_t *ppos);
+#endif
+
 #else /* !CONFIG_GCC_PLUGIN_STACKLEAK */
 static inline void stackleak_task_init(struct task_struct *t) { }
 #endif
diff --git a/kernel/stackleak.c b/kernel/stackleak.c
index f5c4111..f731c9a 100644
--- a/kernel/stackleak.c
+++ b/kernel/stackleak.c
@@ -14,6 +14,36 @@
 
 #include <linux/stackleak.h>
 
+#ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
+#include <linux/jump_label.h>
+
+static DEFINE_STATIC_KEY_FALSE(stack_erasing_bypass);
+
+int stack_erasing_bypass_sysctl(struct ctl_table *table, int write,
+			void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret = 0;
+	int state = static_branch_unlikely(&stack_erasing_bypass);
+
+	table->data = &state;
+	table->maxlen = sizeof(int);
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	if (ret || !write)
+		return ret;
+
+	/* Stack erasing re-enabling is not supported */
+	if (static_branch_unlikely(&stack_erasing_bypass))
+		return -EOPNOTSUPP;
+
+	if (state) {
+		static_branch_enable(&stack_erasing_bypass);
+		pr_warn("stackleak: stack erasing is disabled until reboot\n");
+	}
+
+	return ret;
+}
+#endif /* CONFIG_STACKLEAK_RUNTIME_DISABLE */
+
 asmlinkage void stackleak_erase(void)
 {
 	/* It would be nice not to have 'kstack_ptr' and 'boundary' on stack */
@@ -22,6 +52,11 @@ asmlinkage void stackleak_erase(void)
 	unsigned int poison_count = 0;
 	const unsigned int depth = STACKLEAK_SEARCH_DEPTH / sizeof(unsigned long);
 
+#ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
+	if (static_branch_unlikely(&stack_erasing_bypass))
+		return;
+#endif
+
 	/* Search for the poison value in the kernel stack */
 	while (kstack_ptr > boundary && poison_count <= depth) {
 		if (*(unsigned long *)kstack_ptr == STACKLEAK_POISON)
@@ -78,6 +113,11 @@ void __used stackleak_track_stack(void)
 	 */
 	unsigned long sp = (unsigned long)&sp;
 
+#ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
+	if (static_branch_unlikely(&stack_erasing_bypass))
+		return;
+#endif
+
 	/*
 	 * Having CONFIG_STACKLEAK_TRACK_MIN_SIZE larger than
 	 * STACKLEAK_SEARCH_DEPTH makes the poison search in
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 2d9837c..0ac25ca 100644
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
@@ -1230,6 +1232,17 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &one,
 	},
 #endif
+#ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
+	{
+		.procname	= "stack_erasing_bypass",
+		.data		= NULL,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= stack_erasing_bypass_sysctl,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+#endif
 	{ }
 };
 
diff --git a/scripts/gcc-plugins/Kconfig b/scripts/gcc-plugins/Kconfig
index 292161d..0028945 100644
--- a/scripts/gcc-plugins/Kconfig
+++ b/scripts/gcc-plugins/Kconfig
@@ -182,4 +182,14 @@ config STACKLEAK_METRICS
 	  can be useful for estimating the STACKLEAK performance impact for
 	  your workloads.
 
+config STACKLEAK_RUNTIME_DISABLE
+	bool "Allow runtime disabling of kernel stack erasing"
+	depends on GCC_PLUGIN_STACKLEAK
+	help
+	  This option provides 'stack_erasing_bypass' sysctl, which can be
+	  used in runtime to disable kernel stack erasing for kernels built
+	  with CONFIG_GCC_PLUGIN_STACKLEAK. Stack erasing will then remain
+	  disabled and STACKLEAK_METRICS will not be updated until the
+	  next boot.
+
 endif
-- 
2.7.4
