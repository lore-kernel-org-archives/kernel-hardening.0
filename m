Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Wed, 17 Feb 2016 14:41:13 -0800
Message-Id: <1455748879-21872-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1455748879-21872-1-git-send-email-keescook@chromium.org>
References: <1455748879-21872-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 2/7] init: create cmdline param to disable readonly
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, David Brown <david.brown@linaro.org>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

It may be useful to debug writes to the readonly sections of memory,
so provide a cmdline "rodata=off" to allow for this. This can be
expanded in the future to support "log" and "write" modes, but that
will need to be architecture-specific.

Suggested-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/kernel-parameters.txt |  4 ++++
 init/main.c                         | 27 +++++++++++++++++++++++----
 kernel/debug/kdb/kdb_bp.c           |  4 +---
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e3a9b5863424..3fcbd7a80b27 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3554,6 +3554,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	ro		[KNL] Mount root device read-only on boot
 
+	rodata=		[KNL]
+		on	Mark read-only kernel memory as read-only (default).
+		off	Leave read-only kernel memory writable for debugging.
+
 	root=		[KNL] Root filesystem
 			See name_to_dev_t comment in init/do_mounts.c.
 
diff --git a/init/main.c b/init/main.c
index 5db3a3ab493f..bbc8214a0129 100644
--- a/init/main.c
+++ b/init/main.c
@@ -93,9 +93,6 @@ static int kernel_init(void *);
 extern void init_IRQ(void);
 extern void fork_init(void);
 extern void radix_tree_init(void);
-#ifndef CONFIG_DEBUG_RODATA
-static inline void mark_rodata_ro(void) { }
-#endif
 
 /*
  * Debug helper: via this flag we know that we are in 'early bootup code'
@@ -923,6 +920,28 @@ static int try_to_run_init_process(const char *init_filename)
 
 static noinline void __init kernel_init_freeable(void);
 
+#ifdef CONFIG_DEBUG_RODATA
+static bool rodata_enabled = true;
+static int __init set_debug_rodata(char *str)
+{
+	return strtobool(str, &rodata_enabled);
+}
+__setup("rodata=", set_debug_rodata);
+
+static void mark_readonly(void)
+{
+	if (rodata_enabled)
+		mark_rodata_ro();
+	else
+		pr_info("Kernel memory protection disabled.\n");
+}
+#else
+static inline void mark_readonly(void)
+{
+	pr_warn("This architecture does not have kernel memory protection.\n");
+}
+#endif
+
 static int __ref kernel_init(void *unused)
 {
 	int ret;
@@ -931,7 +950,7 @@ static int __ref kernel_init(void *unused)
 	/* need to finish all async __init code before freeing the memory */
 	async_synchronize_full();
 	free_initmem();
-	mark_rodata_ro();
+	mark_readonly();
 	system_state = SYSTEM_RUNNING;
 	numa_default_policy();
 
diff --git a/kernel/debug/kdb/kdb_bp.c b/kernel/debug/kdb/kdb_bp.c
index e1dbf4a2c69e..90ff129c88a2 100644
--- a/kernel/debug/kdb/kdb_bp.c
+++ b/kernel/debug/kdb/kdb_bp.c
@@ -153,13 +153,11 @@ static int _kdb_bp_install(struct pt_regs *regs, kdb_bp_t *bp)
 	} else {
 		kdb_printf("%s: failed to set breakpoint at 0x%lx\n",
 			   __func__, bp->bp_addr);
-#ifdef CONFIG_DEBUG_RODATA
 		if (!bp->bp_type) {
 			kdb_printf("Software breakpoints are unavailable.\n"
-				   "  Change the kernel CONFIG_DEBUG_RODATA=n\n"
+				   "  Boot the kernel with rodata=off\n"
 				   "  OR use hw breaks: help bph\n");
 		}
-#endif
 		return 1;
 	}
 	return 0;
-- 
2.6.3
