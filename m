From: Thomas Garnier <thgarnie@google.com>
Date: Wed,  4 Oct 2017 14:19:51 -0700
Message-Id: <20171004212003.28296-16-thgarnie@google.com>
In-Reply-To: <20171004212003.28296-1-thgarnie@google.com>
References: <20171004212003.28296-1-thgarnie@google.com>
Subject: [kernel-hardening] [RFC v3 15/27] compiler: Option to default to hidden symbols
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Garnier <thgarnie@google.com>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Matthias Kaehlcke <mka@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Borislav Petkov <bp@alien8.de>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christopher Li <sparse@chrisli.org>, Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Lukas Wunner <lukas@wunner.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Peter Foley <pefoley2@pefoley.com>, Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <jkosina@suse.cz>, Rob Landley <rob@landley.net>, "H . J . Lu" <hjl.tools@gmail.com>, Baoquan He <bhe@redhat.com>, =?UTF-8?q?Jan=20H=20=2E=20Sch=C3=B6nherr?= <jschoenh@amazon.de>, Daniel Micay <danielmicay@gmail.com>
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
 include/linux/compiler.h             |  8 ++++++++
 init/Kconfig                         |  7 +++++++
 kernel/kallsyms.c                    | 16 ++++++++--------
 kernel/trace/trace.h                 |  4 ++--
 lib/dynamic_debug.c                  |  4 ++--
 10 files changed, 39 insertions(+), 18 deletions(-)

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
index a65cf544686a..7e0b54f605c6 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -67,7 +67,7 @@ static inline void x86_ce4100_early_setup(void) { }
  * This is set up by the setup-routine at boot-time
  */
 extern struct boot_params boot_params;
-extern char _text[];
+extern char _text[] __default_visibility;
 
 static inline bool kaslr_enabled(void)
 {
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 86e8f0b2537b..8f021783a929 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -144,8 +144,8 @@ static bool __init check_loader_disabled_bsp(void)
 	return *res;
 }
 
-extern struct builtin_fw __start_builtin_fw[];
-extern struct builtin_fw __end_builtin_fw[];
+extern struct builtin_fw __start_builtin_fw[] __default_visibility;
+extern struct builtin_fw __end_builtin_fw[] __default_visibility;
 
 bool get_builtin_firmware(struct cpio_data *cd, const char *name)
 {
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 4b57cf5bc81d..77d4727f6594 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -45,8 +45,8 @@ MODULE_LICENSE("GPL");
 
 #ifdef CONFIG_FW_LOADER
 
-extern struct builtin_fw __start_builtin_fw[];
-extern struct builtin_fw __end_builtin_fw[];
+extern struct builtin_fw __start_builtin_fw[] __default_visibility;
+extern struct builtin_fw __end_builtin_fw[] __default_visibility;
 
 static bool fw_get_builtin_firmware(struct firmware *fw, const char *name,
 				    void *buf, size_t size)
diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
index e5da44eddd2f..1aa5d6dac9e1 100644
--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -30,6 +30,9 @@
  *	__irqentry_text_start, __irqentry_text_end
  *	__softirqentry_text_start, __softirqentry_text_end
  */
+#ifdef CONFIG_DEFAULT_HIDDEN
+#pragma GCC visibility push(default)
+#endif
 extern char _text[], _stext[], _etext[];
 extern char _data[], _sdata[], _edata[];
 extern char __bss_start[], __bss_stop[];
@@ -46,6 +49,9 @@ extern char __softirqentry_text_start[], __softirqentry_text_end[];
 
 /* Start and end of .ctors section - used for constructor calls. */
 extern char __ctors_start[], __ctors_end[];
+#ifdef CONFIG_DEFAULT_HIDDEN
+#pragma GCC visibility pop
+#endif
 
 extern __visible const void __nosave_begin, __nosave_end;
 
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index e95a2631e545..6997716f73bf 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -78,6 +78,14 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 #include <linux/compiler-clang.h>
 #endif
 
+/* Useful for Position Independent Code to reduce global references */
+#ifdef CONFIG_DEFAULT_HIDDEN
+#pragma GCC visibility push(hidden)
+#define __default_visibility  __attribute__((visibility ("default")))
+#else
+#define __default_visibility
+#endif
+
 /*
  * Generic compiler-dependent macros required for kernel
  * build go below this comment. Actual compiler/compiler version
diff --git a/init/Kconfig b/init/Kconfig
index ccb1d8daf241..b640201fcff7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1649,6 +1649,13 @@ config PROFILING
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
index 127e7cfafa55..252019c8c3a9 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -32,24 +32,24 @@
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
 
 static inline int is_kernel_inittext(unsigned long addr)
 {
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 652c682707cd..31cb920039a2 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1742,8 +1742,8 @@ extern int trace_event_enable_disable(struct trace_event_file *file,
 				      int enable, int soft_disable);
 extern int tracing_alloc_snapshot(void);
 
-extern const char *__start___trace_bprintk_fmt[];
-extern const char *__stop___trace_bprintk_fmt[];
+extern const char *__start___trace_bprintk_fmt[] __default_visibility;
+extern const char *__stop___trace_bprintk_fmt[] __default_visibility;
 
 extern const char *__start___tracepoint_str[];
 extern const char *__stop___tracepoint_str[];
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index da796e2dc4f5..10ed20177354 100644
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
2.14.2.920.gcf0c67979c-goog
