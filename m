From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v2 15/27] compiler: Option to default to hidden symbols
Date: Tue, 13 Mar 2018 13:59:33 -0700
Message-Id: <20180313205945.245105-16-thgarnie@google.com>
In-Reply-To: <20180313205945.245105-1-thgarnie@google.com>
References: <20180313205945.245105-1-thgarnie@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kate Stewart <kstewart@linuxfoundation.org>, Thomas Garnier <thgarnie@google.com>, Arnd Bergmann <arnd@arndb.de>, Philippe Ombredanne <pombredanne@nexb.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Matthias Kaehlcke <mka@chromium.org>, Kees Cook <keescook@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Alok Kataria <akataria@vmware.com>, Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Dennis Zhou <dennisszhou@gmail.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Randy Dunlap <rdunlap@infradead.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Christopher Li <sparse@chrisli.org>, Jason Baron <jbaron@akamai.com>, Ashish Kalra <ashish@bluestacks.com>, Kyle McMartin <kyle@redhat.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Lukas Wunner <lukas@wunner.de>, Petr Mladek <pmladek@suse.com>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Ingo Molnar <mingo@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Cao jin <caoj.fnst@cn.fujitsu.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Dave Hansen <dave.hansen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Jia Zhang <qianyue.zj@alibaba-inc.com>, Jiri Slaby <jslaby@suse.cz>, Kyle Huey <me@kylehuey.com>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>, =?UTF-8?q?Jan=20H=20=2E=20Sch=C3=B6nherr?= <jschoenh@amazon.de>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Provide an option to default visibility to hidden except for key
symbols. This option is disabled by default and will be used by x86_64
PIE support to remove errors between compilation units.

The default visibility is also enabled for external symbols that are
compared as they maybe equals (start/end of sections). In this case,
older versions of GCC will remove the comparison if the symbols are
hidden. This issue exists at least on gcc 4.9 and before.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/boot/boot.h                 |  2 +-
 arch/x86/include/asm/setup.h         |  2 +-
 arch/x86/kernel/cpu/microcode/core.c |  4 ++--
 drivers/base/firmware_class.c        |  4 ++--
 include/asm-generic/sections.h       |  6 ++++++
 include/linux/compiler.h             |  7 +++++++
 init/Kconfig                         |  7 +++++++
 kernel/kallsyms.c                    | 16 ++++++++--------
 kernel/trace/trace.h                 |  4 ++--
 lib/dynamic_debug.c                  |  4 ++--
 10 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index ef5a9cc66fb8..d726c35bdd96 100644
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
index 3108e297d87d..dfba64fe1c7e 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -70,7 +70,7 @@ static inline void x86_ce4100_early_setup(void) { }
  * This is set up by the setup-routine at boot-time
  */
 extern struct boot_params boot_params;
-extern char _text[];
+extern char _text[] __default_visibility;
 
 static inline bool kaslr_enabled(void)
 {
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index aa1b9a422f2b..ed5675db6e82 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -141,8 +141,8 @@ static bool __init check_loader_disabled_bsp(void)
 	return *res;
 }
 
-extern struct builtin_fw __start_builtin_fw[];
-extern struct builtin_fw __end_builtin_fw[];
+extern struct builtin_fw __start_builtin_fw[] __default_visibility;
+extern struct builtin_fw __end_builtin_fw[] __default_visibility;
 
 bool get_builtin_firmware(struct cpio_data *cd, const char *name)
 {
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 7dd36ace6152..939a1952d0ab 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -136,8 +136,8 @@ static struct firmware_cache fw_cache;
 
 #ifdef CONFIG_FW_LOADER
 
-extern struct builtin_fw __start_builtin_fw[];
-extern struct builtin_fw __end_builtin_fw[];
+extern struct builtin_fw __start_builtin_fw[] __default_visibility;
+extern struct builtin_fw __end_builtin_fw[] __default_visibility;
 
 static void fw_copy_to_prealloc_buf(struct firmware *fw,
 				    void *buf, size_t size)
diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
index 849cd8eb5ca0..0a0e23405ddd 100644
--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -32,6 +32,9 @@
  *	__softirqentry_text_start, __softirqentry_text_end
  *	__start_opd, __end_opd
  */
+#ifdef CONFIG_DEFAULT_HIDDEN
+#pragma GCC visibility push(default)
+#endif
 extern char _text[], _stext[], _etext[];
 extern char _data[], _sdata[], _edata[];
 extern char __bss_start[], __bss_stop[];
@@ -49,6 +52,9 @@ extern char __start_once[], __end_once[];
 
 /* Start and end of .ctors section - used for constructor calls. */
 extern char __ctors_start[], __ctors_end[];
+#ifdef CONFIG_DEFAULT_HIDDEN
+#pragma GCC visibility pop
+#endif
 
 /* Start and end of .opd section - used for function descriptors. */
 extern char __start_opd[], __end_opd[];
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index ab4711c63601..a9ac84e37af9 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -278,6 +278,13 @@ unsigned long read_word_at_a_time(const void *addr)
 	__u.__val;					\
 })
 
+#ifdef CONFIG_DEFAULT_HIDDEN
+#pragma GCC visibility push(hidden)
+#define __default_visibility  __attribute__((visibility ("default")))
+#else
+#define __default_visibility
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif /* __ASSEMBLY__ */
diff --git a/init/Kconfig b/init/Kconfig
index acc9087546ac..c924babc6d47 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1667,6 +1667,13 @@ config PROFILING
 config TRACEPOINTS
 	bool
 
+#
+# Default to hidden visibility for all symbols.
+# Useful for Position Independent Code to reduce global references.
+#
+config DEFAULT_HIDDEN
+	bool
+
 source "arch/Kconfig"
 
 endmenu		# General setup
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index a23e21ada81b..f4e58b7a6daf 100644
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
 extern const unsigned long kallsyms_num_syms
-__attribute__((weak, section(".rodata")));
+__attribute__((weak, section(".rodata"))) __default_visibility;
 
 extern const unsigned long kallsyms_relative_base
-__attribute__((weak, section(".rodata")));
+__attribute__((weak, section(".rodata"))) __default_visibility;
 
-extern const u8 kallsyms_token_table[] __weak;
-extern const u16 kallsyms_token_index[] __weak;
+extern const u8 kallsyms_token_table[] __weak __default_visibility;
+extern const u16 kallsyms_token_index[] __weak __default_visibility;
 
-extern const unsigned long kallsyms_markers[] __weak;
+extern const unsigned long kallsyms_markers[] __weak __default_visibility;
 
 /*
  * Expand a compressed symbol data into the resulting uncompressed string,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2a6d0325a761..5aebb0dcecba 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1741,8 +1741,8 @@ extern int trace_event_enable_disable(struct trace_event_file *file,
 				      int enable, int soft_disable);
 extern int tracing_alloc_snapshot(void);
 
-extern const char *__start___trace_bprintk_fmt[];
-extern const char *__stop___trace_bprintk_fmt[];
+extern const char *__start___trace_bprintk_fmt[] __default_visibility;
+extern const char *__stop___trace_bprintk_fmt[] __default_visibility;
 
 extern const char *__start___tracepoint_str[];
 extern const char *__stop___tracepoint_str[];
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index c7c96bc7654a..40b752b53627 100644
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
2.16.2.660.g709887971b-goog
