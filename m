From: Thomas Garnier <thgarnie@chromium.org>
Subject: [PATCH v6 27/27] x86/kaslr: Add option to extend KASLR range from 1GB to 3GB
Date: Thu, 31 Jan 2019 11:24:34 -0800
Message-Id: <20190131192533.34130-28-thgarnie@chromium.org>
In-Reply-To: <20190131192533.34130-1-thgarnie@chromium.org>
References: <20190131192533.34130-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com, Thomas Garnier <thgarnie@chromium.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Palmer Dabbelt <palmer@sifive.com>, Nathan Chancellor <natechancellor@gmail.com>, Thomas Garnier <thgarnie@google.com>, Kees Cook <keescook@chromium.org>, Cao jin <caoj.fnst@cn.fujitsu.com>, "H.J. Lu" <hjl.tools@gmail.com>, Baoquan He <bhe@redhat.com>, Juergen Gross <jgross@suse.com>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Add a new CONFIG_RANDOMIZE_BASE_LARGE option to benefit from PIE
support. It increases the KASLR range from 1GB to 3GB. The new range
stars at 0xffffffff00000000 just above the EFI memory region. This
option is off by default.

The boot code is adapted to create the appropriate page table spanning
three PUD pages.

The relocation table uses 64-bit integers generated with the updated
relocation tool with the large-reloc option.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
---
 Makefile                             |  3 +++
 arch/x86/Kconfig                     | 21 +++++++++++++++++++++
 arch/x86/boot/compressed/Makefile    |  5 +++++
 arch/x86/boot/compressed/misc.c      | 10 +++++++++-
 arch/x86/include/asm/page_64_types.h | 10 ++++++++++
 arch/x86/kernel/head64.c             | 15 ++++++++++++---
 arch/x86/kernel/head_64.S            | 11 ++++++++++-
 7 files changed, 70 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 6e4f0dba45bb..41e0aa0c06b0 100644
--- a/Makefile
+++ b/Makefile
@@ -1106,6 +1106,8 @@ genheader:
 PHONY += prepare-objtool
 prepare-objtool: $(objtool_target)
 ifeq ($(SKIP_STACK_VALIDATION),1)
+# CONFIG_STACK_VALIDATION is not yet support by CONFIG_X86_PIE and warning is displayed before.
+ifndef CONFIG_X86_PIE
 ifdef CONFIG_UNWINDER_ORC
 	@echo "error: Cannot generate ORC metadata for CONFIG_UNWINDER_ORC=y, please install libelf-dev, libelf-devel or elfutils-libelf-devel" >&2
 	@false
@@ -1113,6 +1115,7 @@ else
 	@echo "warning: Cannot use CONFIG_STACK_VALIDATION=y, please install libelf-dev, libelf-devel or elfutils-libelf-devel" >&2
 endif
 endif
+endif
 
 # Generate some files
 # ---------------------------------------------------------------------------
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e4316b8ed130..e61e4fafa1a0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2245,6 +2245,27 @@ config X86_PIE
 	select DYNAMIC_MODULE_BASE
 	select MODULE_REL_CRCS if MODVERSIONS
 
+config RANDOMIZE_BASE_LARGE
+	bool "Increase the randomization range of the kernel image"
+	depends on X86_64 && RANDOMIZE_BASE
+	select X86_PIE
+	select X86_MODULE_PLTS if MODULES
+	default n
+	help
+	  Build the kernel as a Position Independent Executable (PIE) and
+	  increase the available randomization range from 1GB to 3GB.
+
+	  This option impacts performance on kernel CPU intensive workloads up
+	  to 10% due to PIE generated code. Impact on user-mode processes and
+	  typical usage would be significantly less (0.50% when you build the
+	  kernel).
+
+	  The kernel and modules will generate slightly more assembly (1 to 2%
+	  increase on the .text sections). The vmlinux binary will be
+	  significantly smaller due to fewer relocations.
+
+	  If unsure say N
+
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs"
 	depends on SMP
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index f0515ac895a4..02d1ba4877a0 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -121,7 +121,12 @@ $(obj)/vmlinux.bin: vmlinux FORCE
 
 targets += $(patsubst $(obj)/%,%,$(vmlinux-objs-y)) vmlinux.bin.all vmlinux.relocs
 
+# Large randomization require bigger relocation table
+ifeq ($(CONFIG_RANDOMIZE_BASE_LARGE),y)
+CMD_RELOCS = arch/x86/tools/relocs --large-reloc
+else
 CMD_RELOCS = arch/x86/tools/relocs
+endif
 quiet_cmd_relocs = RELOCS  $@
       cmd_relocs = $(CMD_RELOCS) $< > $@;$(CMD_RELOCS) --abs-relocs $<
 $(obj)/vmlinux.relocs: vmlinux FORCE
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 8dd1d5ccae58..28d17bd5bad8 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -171,10 +171,18 @@ void __puthex(unsigned long value)
 }
 
 #if CONFIG_X86_NEED_RELOCS
+
+/* Large randomization go lower than -2G and use large relocation table */
+#ifdef CONFIG_RANDOMIZE_BASE_LARGE
+typedef long rel_t;
+#else
+typedef int rel_t;
+#endif
+
 static void handle_relocations(void *output, unsigned long output_len,
 			       unsigned long virt_addr)
 {
-	int *reloc;
+	rel_t *reloc;
 	unsigned long delta, map, ptr;
 	unsigned long min_addr = (unsigned long)output;
 	unsigned long max_addr = min_addr + (VO___bss_start - VO__text);
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 8f657286d599..acd4f3b400ca 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -48,7 +48,11 @@
 #define __PAGE_OFFSET           __PAGE_OFFSET_BASE_L4
 #endif /* CONFIG_DYNAMIC_MEMORY_LAYOUT */
 
+#ifdef CONFIG_RANDOMIZE_BASE_LARGE
+#define __START_KERNEL_map	_AC(0xffffffff00000000, UL)
+#else
 #define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
+#endif /* CONFIG_RANDOMIZE_BASE_LARGE */
 
 /* See Documentation/x86/x86_64/mm.txt for a description of the memory map. */
 
@@ -67,11 +71,17 @@
  * On KASLR use 1 GiB by default, leaving 1 GiB for modules once the
  * page tables are fully set up.
  *
+ * On PIE, we relocate the binary 2G lower so add this extra space.
+ *
  * If KASLR is disabled we can shrink it to 0.5 GiB and increase the size
  * of the modules area to 1.5 GiB.
  */
 #ifdef CONFIG_RANDOMIZE_BASE
+#ifdef CONFIG_RANDOMIZE_BASE_LARGE
+#define KERNEL_IMAGE_SIZE	(_AC(3, UL) * 1024 * 1024 * 1024)
+#else
 #define KERNEL_IMAGE_SIZE	(1024 * 1024 * 1024)
+#endif
 #else
 #define KERNEL_IMAGE_SIZE	(512 * 1024 * 1024)
 #endif
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index ca2f6ff431af..0da0dc47f08f 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -62,6 +62,7 @@ EXPORT_SYMBOL(vmemmap_base);
 #endif
 
 #define __head	__section(.head.text)
+#define pud_count(x)   (((x + (PUD_SIZE - 1)) & ~(PUD_SIZE - 1)) >> PUD_SHIFT)
 
 /* Required for read_cr3 when building as PIE */
 unsigned long __force_order;
@@ -119,6 +120,8 @@ unsigned long __head __startup_64(unsigned long physaddr,
 	unsigned long vaddr, vaddr_end;
 	unsigned long load_delta, *p;
 	unsigned long pgtable_flags;
+	unsigned long level3_kernel_start, level3_kernel_count;
+	unsigned long level3_fixmap_start;
 	pgdval_t *pgd;
 	p4dval_t *p4d;
 	pudval_t *pud;
@@ -150,6 +153,11 @@ unsigned long __head __startup_64(unsigned long physaddr,
 	/* Include the SME encryption mask in the fixup value */
 	load_delta += sme_get_me_mask();
 
+	/* Look at the randomization spread to adapt page table used */
+	level3_kernel_start = pud_index(__START_KERNEL_map);
+	level3_kernel_count = pud_count(KERNEL_IMAGE_SIZE);
+	level3_fixmap_start = level3_kernel_start + level3_kernel_count;
+
 	/* Fixup the physical addresses in the page table */
 
 	pgd = fixup_pointer(&early_top_pgt, physaddr);
@@ -166,8 +174,9 @@ unsigned long __head __startup_64(unsigned long physaddr,
 	}
 
 	pud = fixup_pointer(&level3_kernel_pgt, physaddr);
-	pud[510] += load_delta;
-	pud[511] += load_delta;
+	for (i = 0; i < level3_kernel_count; i++)
+		pud[level3_kernel_start + i] += load_delta;
+	pud[level3_fixmap_start] += load_delta;
 
 	pmd = fixup_pointer(level2_fixmap_pgt, physaddr);
 	for (i = FIXMAP_PMD_TOP; i > FIXMAP_PMD_TOP - FIXMAP_PMD_NUM; i--)
@@ -226,7 +235,7 @@ unsigned long __head __startup_64(unsigned long physaddr,
 	 */
 
 	pmd = fixup_pointer(level2_kernel_pgt, physaddr);
-	for (i = 0; i < PTRS_PER_PMD; i++) {
+	for (i = 0; i < PTRS_PER_PMD * level3_kernel_count; i++) {
 		if (pmd[i] & _PAGE_PRESENT)
 			pmd[i] += load_delta;
 	}
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 0f1739d7bff7..82d637615d2c 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -42,12 +42,16 @@
 
 #define l4_index(x)	(((x) >> 39) & 511)
 #define pud_index(x)	(((x) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
+#define pud_count(x)   (((x + (PUD_SIZE - 1)) & ~(PUD_SIZE - 1)) >> PUD_SHIFT)
 
 L4_PAGE_OFFSET = l4_index(__PAGE_OFFSET_BASE_L4)
 L4_START_KERNEL = l4_index(__START_KERNEL_map)
 
 L3_START_KERNEL = pud_index(__START_KERNEL_map)
 
+/* Adapt page table L3 space based on range of randomization */
+L3_KERNEL_ENTRY_COUNT = pud_count(KERNEL_IMAGE_SIZE)
+
 	.text
 	__HEAD
 	.code64
@@ -432,7 +436,12 @@ NEXT_PAGE(level4_kernel_pgt)
 NEXT_PAGE(level3_kernel_pgt)
 	.fill	L3_START_KERNEL,8,0
 	/* (2^48-(2*1024*1024*1024)-((2^39)*511))/(2^30) = 510 */
-	.quad	level2_kernel_pgt - __START_KERNEL_map + _KERNPG_TABLE_NOENC
+	i = 0
+	.rept	L3_KERNEL_ENTRY_COUNT
+	.quad	level2_kernel_pgt - __START_KERNEL_map + _KERNPG_TABLE_NOENC \
+		+ PAGE_SIZE*i
+	i = i + 1
+	.endr
 	.quad	level2_fixmap_pgt - __START_KERNEL_map + _PAGE_TABLE_NOENC
 
 NEXT_PAGE(level2_kernel_pgt)
-- 
2.20.1.495.gaa96b0ce6b-goog
