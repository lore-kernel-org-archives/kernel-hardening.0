From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 10 Aug 2017 10:26:09 -0700
Message-Id: <20170810172615.51965-18-thgarnie@google.com>
In-Reply-To: <20170810172615.51965-1-thgarnie@google.com>
References: <20170810172615.51965-1-thgarnie@google.com>
Subject: [kernel-hardening] [RFC v2 17/23] compiler: Option to default to hidden symbols
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Garnier <thgarnie@google.com>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Christopher Li <sparse@chrisli.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lukas Wunner <lukas@wunner.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Markus Trippelsdorf <markus@trippelsdorf.de>, Steven Rostedt <rostedt@goodmis.org>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Peter Foley <pefoley2@pefoley.com>, Tim Chen <tim.c.chen@linux.intel.com>, Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org, kvm@vger.kernel.org, linux-pm@vger.kernel.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Provide an option to default visibility to hidden except for key
symbols. This option is disabled by default and will be used by x86_64
PIE support to remove errors between compilation units.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/boot/boot.h           |  2 +-
 arch/x86/include/asm/setup.h   |  2 +-
 include/asm-generic/sections.h |  6 ++++++
 include/linux/compiler.h       |  8 ++++++++
 init/Kconfig                   |  7 +++++++
 kernel/kallsyms.c              | 16 ++++++++--------
 6 files changed, 31 insertions(+), 10 deletions(-)

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
diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
index 532372c6cf15..27c12f6dd6e2 100644
--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -28,6 +28,9 @@
  *	__entry_text_start, __entry_text_end
  *	__ctors_start, __ctors_end
  */
+#ifdef CONFIG_DEFAULT_HIDDEN
+#pragma GCC visibility push(default)
+#endif
 extern char _text[], _stext[], _etext[];
 extern char _data[], _sdata[], _edata[];
 extern char __bss_start[], __bss_stop[];
@@ -42,6 +45,9 @@ extern char __start_rodata[], __end_rodata[];
 
 /* Start and end of .ctors section - used for constructor calls. */
 extern char __ctors_start[], __ctors_end[];
+#ifdef CONFIG_DEFAULT_HIDDEN
+#pragma GCC visibility pop
+#endif
 
 extern __visible const void __nosave_begin, __nosave_end;
 
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index dfaaeec4a32e..3a79b536cef8 100644
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
index 482a18a88fb9..a886d73993db 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1640,6 +1640,13 @@ config PROFILING
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
-- 
2.14.0.434.g98096fd7a8-goog
