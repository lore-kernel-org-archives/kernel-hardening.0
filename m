From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v3 22/27] x86/modules: Add option to start module section after kernel
Date: Wed, 23 May 2018 12:54:16 -0700
Message-Id: <20180523195421.180248-23-thgarnie@google.com>
In-Reply-To: <20180523195421.180248-1-thgarnie@google.com>
References: <20180523195421.180248-1-thgarnie@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Garnier <thgarnie@google.com>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, Yonghong Song <yhs@fb.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Kees Cook <keescook@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Alok Kataria <akataria@vmware.com>, Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@siemens.com>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Dennis Zhou <dennisszhou@gmail.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Alexey Dobriyan <adobriyan@gmail.com>, Masami Hiramatsu <mhiramat@kernel.org>, Cao jin <caoj.fnst@cn.fujitsu.com>, Francis Deslauriers <francis.deslauriers@efficios.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Randy Dunlap <rdunlap@infradead.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christopher Li <sparse@chrisli.org>, Jason Baron <jbaron@akamai.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Lukas Wunner <lukas@wunner.de>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Ingo Molnar <mingo@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw@amazon.co.uk>, Dave Hansen <dave.hansen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Jia Zhang <qianyue.zj@alibaba-inc.com>, Ricardo Neri <ricardo.neri-calderon@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Jan Beulich <JBeulich@suse.com>, Matthias Kaehlcke <mka@chromium.org>, Baoquan He <bhe@redhat.com>, =?UTF-8?q?Jan=20H=20=2E=20Sch=C3=B6nherr?= <jschoenh@amazon.de>, Daniel Micay <danielmicay@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Add an option so the module section is just after the mapped kernel. It
will ensure position independent modules are always at the right
distance from the kernel and do not require mcmodule=large. It also
optimize the available size for modules by getting rid of the empty
space on kernel randomization range.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 Documentation/x86/x86_64/mm.txt         | 3 +++
 arch/x86/Kconfig                        | 4 ++++
 arch/x86/include/asm/pgtable_64_types.h | 6 ++++++
 arch/x86/kernel/head64.c                | 5 ++++-
 arch/x86/mm/dump_pagetables.c           | 3 ++-
 5 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/Documentation/x86/x86_64/mm.txt b/Documentation/x86/x86_64/mm.txt
index 600bc2afa27d..e3810a1db74b 100644
--- a/Documentation/x86/x86_64/mm.txt
+++ b/Documentation/x86/x86_64/mm.txt
@@ -79,3 +79,6 @@ Their order is preserved but their base will be offset early at boot time.
 Be very careful vs. KASLR when changing anything here. The KASLR address
 range must not overlap with anything except the KASAN shadow area, which is
 correct as KASAN disables KASLR.
+
+If CONFIG_DYNAMIC_MODULE_BASE is enabled, the module section follows the end of
+the mapped kernel.
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0fc2e981458d..28eb2b3757bf 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2199,6 +2199,10 @@ config RANDOMIZE_MEMORY_PHYSICAL_PADDING
 
 	   If unsure, leave at the default value.
 
+# Module section starts just after the end of the kernel module
+config DYNAMIC_MODULE_BASE
+	bool
+
 config X86_GLOBAL_STACKPROTECTOR
 	bool "Stack cookie using a global variable"
 	depends on CC_STACKPROTECTOR_AUTO
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index adb47552e6bb..3ab25b908879 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -7,6 +7,7 @@
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
 #include <asm/kaslr.h>
+#include <asm/sections.h>
 
 /*
  * These are used to make use of C type-checking..
@@ -126,7 +127,12 @@ extern unsigned int ptrs_per_p4d;
 
 #define VMALLOC_END		(VMALLOC_START + (VMALLOC_SIZE_TB << 40) - 1)
 
+#ifdef CONFIG_DYNAMIC_MODULE_BASE
+#define MODULES_VADDR		ALIGN(((unsigned long)_end + PAGE_SIZE), PMD_SIZE)
+#else
 #define MODULES_VADDR		(__START_KERNEL_map + KERNEL_IMAGE_SIZE)
+#endif
+
 /* The module sections ends with the start of the fixmap */
 #define MODULES_END		_AC(0xffffffffff000000, UL)
 #define MODULES_LEN		(MODULES_END - MODULES_VADDR)
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index fa661fb97127..3a1ce822e1c0 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -394,12 +394,15 @@ asmlinkage __visible void __init x86_64_start_kernel(char * real_mode_data)
 	 * Build-time sanity checks on the kernel image and module
 	 * area mappings. (these are purely build-time and produce no code)
 	 */
+#ifndef CONFIG_DYNAMIC_MODULE_BASE
 	BUILD_BUG_ON(MODULES_VADDR < __START_KERNEL_map);
 	BUILD_BUG_ON(MODULES_VADDR - __START_KERNEL_map < KERNEL_IMAGE_SIZE);
-	BUILD_BUG_ON(MODULES_LEN + KERNEL_IMAGE_SIZE > 2*PUD_SIZE);
+	BUILD_BUG_ON(!IS_ENABLED(CONFIG_RANDOMIZE_BASE_LARGE) &&
+		     MODULES_LEN + KERNEL_IMAGE_SIZE > 2*PUD_SIZE);
 	BUILD_BUG_ON((__START_KERNEL_map & ~PMD_MASK) != 0);
 	BUILD_BUG_ON((MODULES_VADDR & ~PMD_MASK) != 0);
 	BUILD_BUG_ON(!(MODULES_VADDR > __START_KERNEL));
+#endif
 	MAYBE_BUILD_BUG_ON(!(((MODULES_END - 1) & PGDIR_MASK) ==
 				(__START_KERNEL & PGDIR_MASK)));
 	BUILD_BUG_ON(__fix_to_virt(__end_of_fixed_addresses) <= MODULES_END);
diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index cc7ff5957194..dca4098ce4fd 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -105,7 +105,7 @@ static struct addr_marker address_markers[] = {
 	[EFI_END_NR]		= { EFI_VA_END,		"EFI Runtime Services" },
 #endif
 	[HIGH_KERNEL_NR]	= { __START_KERNEL_map,	"High Kernel Mapping" },
-	[MODULES_VADDR_NR]	= { MODULES_VADDR,	"Modules" },
+	[MODULES_VADDR_NR]	= { 0/*MODULES_VADDR*/,	"Modules" },
 	[MODULES_END_NR]	= { MODULES_END,	"End Modules" },
 	[FIXADDR_START_NR]	= { FIXADDR_START,	"Fixmap Area" },
 	[END_OF_SPACE_NR]	= { -1,			NULL }
@@ -600,6 +600,7 @@ static int __init pt_dump_init(void)
 	address_markers[KASAN_SHADOW_START_NR].start_address = KASAN_SHADOW_START;
 	address_markers[KASAN_SHADOW_END_NR].start_address = KASAN_SHADOW_END;
 #endif
+	address_markers[MODULES_VADDR_NR].start_address = MODULES_VADDR;
 #endif
 #ifdef CONFIG_X86_32
 	address_markers[VMALLOC_START_NR].start_address = VMALLOC_START;
-- 
2.17.0.441.gb46fe60e1d-goog
