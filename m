From: Thomas Garnier <thgarnie@chromium.org>
Subject: [PATCH v6 15/27] compiler: Option to default to hidden symbols
Date: Thu, 31 Jan 2019 11:24:22 -0800
Message-Id: <20190131192533.34130-16-thgarnie@chromium.org>
In-Reply-To: <20190131192533.34130-1-thgarnie@chromium.org>
References: <20190131192533.34130-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com, Thomas Garnier <thgarnie@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Luis Chamberlain <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>, Thomas Garnier <thgarnie@google.com>, Jordan Borgner <mail@jordan-borgner.de>, Masami Hiramatsu <mhiramat@kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Andi Kleen <ak@linux.intel.com>, Jan Beulich <JBeulich@suse.com>, Song Liu <songliubraving@fb.com>, Adrian Hunter <adrian.hunter@intel.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Provide an option to default visibility to hidden except for key
symbols. This option is disabled by default and will be used by x86_64
PIE support to remove errors between compilation units.

The default visibility is also enabled for external symbols that are
compared as they maybe equals (start/end of sections). In this case,
older versions of GCC will remove the comparison if the symbols are
hidden. This issue exists at least on gcc 4.9 and before.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
---
 arch/x86/boot/boot.h                 |  2 +-
 arch/x86/include/asm/setup.h         |  2 +-
 arch/x86/kernel/cpu/microcode/core.c |  4 ++--
 drivers/base/firmware_loader/main.c  |  4 ++--
 include/asm-generic/sections.h       |  6 ++++++
 include/linux/compiler.h             |  7 +++++++
 init/Kconfig                         |  7 +++++++
 kernel/kallsyms.c                    | 16 ++++++++--------
 kernel/trace/trace.h                 |  4 ++--
 lib/dynamic_debug.c                  |  4 ++--
 10 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 32a09eb5c101..c4afcfecc817 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -193,7 +193,7 @@ static inline bool memcmp_gs(const void *s1, addr_t s2, size_t len)
 }
 
 /* Heap -- available for dynamic lists. */
-extern char _end[];
+extern char _end[] __default_visibility;
 extern char *HEAP;
 extern char *heap_end;
 #define RESET_HEAP() ((void *)( HEAP = _end ))
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index ed8ec011a9fd..74f0a8d87986 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -71,7 +71,7 @@ static inline void x86_ce4100_early_setup(void) { }
  * This is set up by the setup-routine at boot-time
  */
 extern struct boot_params boot_params;
-extern char _text[];
+extern char _text[] __default_visibility;
 
 static inline bool kaslr_enabled(void)
 {
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 97f9ada9ceda..04ca89e65f79 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -149,8 +149,8 @@ static bool __init check_loader_disabled_bsp(void)
 	return *res;
 }
 
-extern struct builtin_fw __start_builtin_fw[];
-extern struct builtin_fw __end_builtin_fw[];
+extern struct builtin_fw __start_builtin_fw[] __default_visibility;
+extern struct builtin_fw __end_builtin_fw[] __default_visibility;
 
 bool get_builtin_firmware(struct cpio_data *cd, const char *name)
 {
diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index 8e9213b36e31..f04096161a52 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -94,8 +94,8 @@ static struct firmware_cache fw_cache;
 
 #ifdef CONFIG_FW_LOADER
 
-extern struct builtin_fw __start_builtin_fw[];
-extern struct builtin_fw __end_builtin_fw[];
+extern struct builtin_fw __start_builtin_fw[] __default_visibility;
+extern struct builtin_fw __end_builtin_fw[] __default_visibility;
 
 static void fw_copy_to_prealloc_buf(struct firmware *fw,
 				    void *buf, size_t size)
diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
index d79abca81a52..94f072f3a48d 100644
--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -32,6 +32,9 @@
  *	__softirqentry_text_start, __softirqentry_text_end
  *	__start_opd, __end_opd
  */
+#ifdef CONFIG_DEFAULT_HIDDEN_SYMS
+#pragma GCC visibility push(default)
+#endif
 extern char _text[], _stext[], _etext[];
 extern char _data[], _sdata[], _edata[];
 extern char __bss_start[], __bss_stop[];
@@ -49,6 +52,9 @@ extern char __start_once[], __end_once[];
 
 /* Start and end of .ctors section - used for constructor calls. */
 extern char __ctors_start[], __ctors_end[];
+#ifdef CONFIG_DEFAULT_HIDDEN_SYMS
+#pragma GCC visibility pop
+#endif
 
 /* Start and end of .opd section - used for function descriptors. */
 extern char __start_opd[], __end_opd[];
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 87692fdae97a..5c0723604a52 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -287,6 +287,13 @@ unsigned long read_word_at_a_time(const void *addr)
 	__u.__val;					\
 })
 
+#ifdef CONFIG_DEFAULT_HIDDEN_SYMS
+#pragma GCC visibility push(hidden)
+#define __default_visibility  __attribute__((visibility ("default")))
+#else
+#define __default_visibility
+#endif
+
 #endif /* __KERNEL__ */
 
 /*
diff --git a/init/Kconfig b/init/Kconfig
index bb383615823a..116e0de4817f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1848,6 +1848,13 @@ config CMDLINE_OVERRIDE
 
 endif
 
+#
+# Default to hidden visibility for all symbols.
+# Useful for Position Independent Code to reduce global references.
+#
+config DEFAULT_HIDDEN_SYMS
+	bool
+
 endmenu		# General setup
 
 source "arch/Kconfig"
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 14934afa9e68..547affc40b68 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -29,24 +29,24 @@
  * These will be re-linked against their real values
  * during the second link stage.
  */
-extern const unsigned long kallsyms_addresses[] __weak;
-extern const int kallsyms_offsets[] __weak;
-extern const u8 kallsyms_names[] __weak;
+extern const unsigned long kallsyms_addresses[] __weak __default_visibility;
+extern const int kallsyms_offsets[] __weak __default_visibility;
+extern const u8 kallsyms_names[] __weak __default_visibility;
 
 /*
  * Tell the compiler that the count isn't in the small data section if the arch
  * has one (eg: FRV).
  */
 extern const unsigned int kallsyms_num_syms
-__attribute__((weak, section(".rodata")));
+__attribute__((weak, section(".rodata"))) __default_visibility;
 
 extern const unsigned long kallsyms_relative_base
-__attribute__((weak, section(".rodata")));
+__attribute__((weak, section(".rodata"))) __default_visibility;
 
-extern const u8 kallsyms_token_table[] __weak;
-extern const u16 kallsyms_token_index[] __weak;
+extern const u8 kallsyms_token_table[] __weak __default_visibility;
+extern const u16 kallsyms_token_index[] __weak __default_visibility;
 
-extern const unsigned int kallsyms_markers[] __weak;
+extern const unsigned int kallsyms_markers[] __weak __default_visibility;
 
 /*
  * Expand a compressed symbol data into the resulting uncompressed string,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 08900828d282..5246977a2db7 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1809,8 +1809,8 @@ extern int trace_event_enable_disable(struct trace_event_file *file,
 				      int enable, int soft_disable);
 extern int tracing_alloc_snapshot(void);
 
-extern const char *__start___trace_bprintk_fmt[];
-extern const char *__stop___trace_bprintk_fmt[];
+extern const char *__start___trace_bprintk_fmt[] __default_visibility;
+extern const char *__stop___trace_bprintk_fmt[] __default_visibility;
 
 extern const char *__start___tracepoint_str[];
 extern const char *__stop___tracepoint_str[];
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index dbf2b457e47e..05482e65ae7d 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -37,8 +37,8 @@
 #include <linux/device.h>
 #include <linux/netdevice.h>
 
-extern struct _ddebug __start___verbose[];
-extern struct _ddebug __stop___verbose[];
+extern struct _ddebug __start___verbose[] __default_visibility;
+extern struct _ddebug __stop___verbose[] __default_visibility;
 
 struct ddebug_table {
 	struct list_head link;
-- 
2.20.1.495.gaa96b0ce6b-goog
