From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH v3 1/3] modules: Create arch versions of module alloc/free
Date: Fri, 19 Oct 2018 13:47:21 -0700
Message-Id: <20181019204723.3903-2-rick.p.edgecombe@intel.com>
In-Reply-To: <20181019204723.3903-1-rick.p.edgecombe@intel.com>
References: <20181019204723.3903-1-rick.p.edgecombe@intel.com>
To: kernel-hardening@lists.openwall.com, daniel@iogearbox.net, keescook@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com, davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org, arnd@arndb.de, jeyu@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, jannh@google.com
Cc: kristen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, deneen.t.dock@intel.com, Rick Edgecombe <rick.p.edgecombe@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

In prep for module space rlimit, create a singular cross platform
module_alloc and module_memfree that call into arch specific
implementations.

This has only been tested on x86.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/arm/kernel/module.c       |  2 +-
 arch/arm64/kernel/module.c     |  2 +-
 arch/mips/kernel/module.c      |  2 +-
 arch/nds32/kernel/module.c     |  2 +-
 arch/nios2/kernel/module.c     |  4 ++--
 arch/parisc/kernel/module.c    |  2 +-
 arch/s390/kernel/module.c      |  2 +-
 arch/sparc/kernel/module.c     |  2 +-
 arch/unicore32/kernel/module.c |  2 +-
 arch/x86/kernel/module.c       |  2 +-
 kernel/module.c                | 14 ++++++++++++--
 11 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index 3ff571c2c71c..359838a4bb06 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -38,7 +38,7 @@
 #endif
 
 #ifdef CONFIG_MMU
-void *module_alloc(unsigned long size)
+void *arch_module_alloc(unsigned long size)
 {
 	gfp_t gfp_mask = GFP_KERNEL;
 	void *p;
diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index f0f27aeefb73..a6891eb2fc16 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -30,7 +30,7 @@
 #include <asm/insn.h>
 #include <asm/sections.h>
 
-void *module_alloc(unsigned long size)
+void *arch_module_alloc(unsigned long size)
 {
 	gfp_t gfp_mask = GFP_KERNEL;
 	void *p;
diff --git a/arch/mips/kernel/module.c b/arch/mips/kernel/module.c
index 491605137b03..e9ee8e7544f9 100644
--- a/arch/mips/kernel/module.c
+++ b/arch/mips/kernel/module.c
@@ -45,7 +45,7 @@ static LIST_HEAD(dbe_list);
 static DEFINE_SPINLOCK(dbe_lock);
 
 #ifdef MODULE_START
-void *module_alloc(unsigned long size)
+void *arch_module_alloc(unsigned long size)
 {
 	return __vmalloc_node_range(size, 1, MODULE_START, MODULE_END,
 				GFP_KERNEL, PAGE_KERNEL, 0, NUMA_NO_NODE,
diff --git a/arch/nds32/kernel/module.c b/arch/nds32/kernel/module.c
index 1e31829cbc2a..75535daa22a5 100644
--- a/arch/nds32/kernel/module.c
+++ b/arch/nds32/kernel/module.c
@@ -7,7 +7,7 @@
 #include <linux/moduleloader.h>
 #include <asm/pgtable.h>
 
-void *module_alloc(unsigned long size)
+void *arch_module_alloc(unsigned long size)
 {
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
 				    GFP_KERNEL, PAGE_KERNEL, 0, NUMA_NO_NODE,
diff --git a/arch/nios2/kernel/module.c b/arch/nios2/kernel/module.c
index e2e3f13f98d5..cd059a8e9a7b 100644
--- a/arch/nios2/kernel/module.c
+++ b/arch/nios2/kernel/module.c
@@ -28,7 +28,7 @@
  * from 0x80000000 (vmalloc area) to 0xc00000000 (kernel) (kmalloc returns
  * addresses in 0xc0000000)
  */
-void *module_alloc(unsigned long size)
+void *arch_module_alloc(unsigned long size)
 {
 	if (size == 0)
 		return NULL;
@@ -36,7 +36,7 @@ void *module_alloc(unsigned long size)
 }
 
 /* Free memory returned from module_alloc */
-void module_memfree(void *module_region)
+void arch_module_memfree(void *module_region)
 {
 	kfree(module_region);
 }
diff --git a/arch/parisc/kernel/module.c b/arch/parisc/kernel/module.c
index b5b3cb00f1fb..72ab3c8b103b 100644
--- a/arch/parisc/kernel/module.c
+++ b/arch/parisc/kernel/module.c
@@ -213,7 +213,7 @@ static inline int reassemble_22(int as22)
 		((as22 & 0x0003ff) << 3));
 }
 
-void *module_alloc(unsigned long size)
+void *arch_module_alloc(unsigned long size)
 {
 	/* using RWX means less protection for modules, but it's
 	 * easier than trying to map the text, data, init_text and
diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index d298d3cb46d0..e07c4a9384c0 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -30,7 +30,7 @@
 
 #define PLT_ENTRY_SIZE 20
 
-void *module_alloc(unsigned long size)
+void *arch_module_alloc(unsigned long size)
 {
 	if (PAGE_ALIGN(size) > MODULES_LEN)
 		return NULL;
diff --git a/arch/sparc/kernel/module.c b/arch/sparc/kernel/module.c
index df39580f398d..870581ba9205 100644
--- a/arch/sparc/kernel/module.c
+++ b/arch/sparc/kernel/module.c
@@ -40,7 +40,7 @@ static void *module_map(unsigned long size)
 }
 #endif /* CONFIG_SPARC64 */
 
-void *module_alloc(unsigned long size)
+void *arch_module_alloc(unsigned long size)
 {
 	void *ret;
 
diff --git a/arch/unicore32/kernel/module.c b/arch/unicore32/kernel/module.c
index e191b3448bd3..53ea96459d8c 100644
--- a/arch/unicore32/kernel/module.c
+++ b/arch/unicore32/kernel/module.c
@@ -22,7 +22,7 @@
 #include <asm/pgtable.h>
 #include <asm/sections.h>
 
-void *module_alloc(unsigned long size)
+void *arch_module_alloc(unsigned long size)
 {
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
 				GFP_KERNEL, PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index f58336af095c..032e49180577 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -77,7 +77,7 @@ static unsigned long int get_module_load_offset(void)
 }
 #endif
 
-void *module_alloc(unsigned long size)
+void *arch_module_alloc(unsigned long size)
 {
 	void *p;
 
diff --git a/kernel/module.c b/kernel/module.c
index 6746c85511fe..41c22aba8209 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2110,11 +2110,16 @@ static void free_module_elf(struct module *mod)
 }
 #endif /* CONFIG_LIVEPATCH */
 
-void __weak module_memfree(void *module_region)
+void __weak arch_module_memfree(void *module_region)
 {
 	vfree(module_region);
 }
 
+void module_memfree(void *module_region)
+{
+	arch_module_memfree(module_region);
+}
+
 void __weak module_arch_cleanup(struct module *mod)
 {
 }
@@ -2728,11 +2733,16 @@ static void dynamic_debug_remove(struct module *mod, struct _ddebug *debug)
 		ddebug_remove_module(mod->name);
 }
 
-void * __weak module_alloc(unsigned long size)
+void * __weak arch_module_alloc(unsigned long size)
 {
 	return vmalloc_exec(size);
 }
 
+void *module_alloc(unsigned long size)
+{
+	return arch_module_alloc(size);
+}
+
 #ifdef CONFIG_DEBUG_KMEMLEAK
 static void kmemleak_load_module(const struct module *mod,
 				 const struct load_info *info)
-- 
2.17.1
