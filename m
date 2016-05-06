Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Fri,  6 May 2016 15:01:35 -0700
Message-Id: <1462572095-11754-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1462572095-11754-1-git-send-email-keescook@chromium.org>
References: <1462572095-11754-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 3/3] x86/KASLR: Build identity mappings on demand
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Currently KASLR only supports relocation in a small physical range (from
16M to 1G), due to using the initial kernel page table identity mapping.
To support ranges above this, we need to have an identity mapping for the
desired memory range before we can decompress (and later run) the kernel.

32-bit kernels already have the needed identity mapping. This patch adds
identity mappings for the needed memory ranges on 64-bit kernels. This
happens in two possible boot paths:

If loaded via startup_32(), we need to set up the needed identity map.

If loaded from a 64-bit bootloader, the bootloader will have already
set up an identity mapping, and we'll start via the compressed kernel's
startup_64(). In this case, the bootloader's page tables need to be
avoided while selecting the new uncompressed kernel location. If not,
the decompressor could overwrite them during decompression.

To accomplish this, we could walk the pagetable and find every page
that is used, and add them to mem_avoid, but this needs extra code and
will require increasing the size of the mem_avoid array.

Instead, we can create a new set of page tables for our own identity
mapping instead. The pages for the new page table will come from the
_pagetable section of the compressed kernel, which means they are
already contained by in mem_avoid array. To do this, we reuse the code
from the uncompressed kernel's identity mapping routines.

The _pgtable will be shared by both the 32-bit and 64-bit paths to reduce
init_size, as now the compressed kernel's _rodata to _end will contribute
to init_size.

To handle the possible mappings, we need to increase the existing page
table buffer size:

When booting via startup_64(), we need to cover the old VO, params,
cmdline and uncompressed kernel. In an extreme case we could have them
all beyond the 512G boundary, which needs (2+2)*4 pages with 2M mappings.
And we'll need 2 for first 2M for VGA RAM. One more is needed for level4.
This gets us to 19 pages total.

When booting via startup_32(), KASLR could move the uncompressed kernel
above 4G, so we need to create extra identity mappings, which should only
need (2+2) pages at most when it is beyond the 512G boundary. So 19
pages is sufficient for this case as well.

The resulting BOOT_*PGT_SIZE defines use the "_SIZE" suffix on their
names to maintain logical consistency with the existing BOOT_HEAP_SIZE
and BOOT_STACK_SIZE defines.

This patch is based on earlier patches from Yinghai Lu and Baoquan He.

Cc: Borislav Petkov <bp@suse.de>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/Makefile    |   3 +
 arch/x86/boot/compressed/head_64.S   |   4 +-
 arch/x86/boot/compressed/kaslr.c     |  17 +++++
 arch/x86/boot/compressed/misc.h      |  11 +++
 arch/x86/boot/compressed/pagetable.c | 135 +++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/boot.h          |  19 +++++
 6 files changed, 187 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/boot/compressed/pagetable.c

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 77ce3a04d46e..cfdd8c3f8af2 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -75,6 +75,9 @@ vmlinux-objs-y := $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 
 vmlinux-objs-$(CONFIG_EARLY_PRINTK) += $(obj)/early_serial_console.o
 vmlinux-objs-$(CONFIG_RANDOMIZE_BASE) += $(obj)/kaslr.o
+ifdef CONFIG_X86_64
+	vmlinux-objs-$(CONFIG_RANDOMIZE_BASE) += $(obj)/pagetable.o
+endif
 
 $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
 
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 7c047002950c..0d80a7ad65cd 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -134,7 +134,7 @@ ENTRY(startup_32)
 	/* Initialize Page tables to 0 */
 	leal	pgtable(%ebx), %edi
 	xorl	%eax, %eax
-	movl	$((4096*6)/4), %ecx
+	movl	$(BOOT_INIT_PGT_SIZE/4), %ecx
 	rep	stosl
 
 	/* Build Level 4 */
@@ -486,4 +486,4 @@ boot_stack_end:
 	.section ".pgtable","a",@nobits
 	.balign 4096
 pgtable:
-	.fill 6*4096, 1, 0
+	.fill BOOT_PGT_SIZE, 1, 0
diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index e8413f6064b2..94a95694a32d 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -241,6 +241,8 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 	 */
 	mem_avoid[MEM_AVOID_ZO_RANGE].start = input;
 	mem_avoid[MEM_AVOID_ZO_RANGE].size = (output + init_size) - input;
+	add_identity_map(mem_avoid[MEM_AVOID_ZO_RANGE].start,
+			 mem_avoid[MEM_AVOID_ZO_RANGE].size);
 
 	/* Avoid initrd. */
 	initrd_start  = (u64)boot_params->ext_ramdisk_image << 32;
@@ -249,6 +251,7 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 	initrd_size |= boot_params->hdr.ramdisk_size;
 	mem_avoid[MEM_AVOID_INITRD].start = initrd_start;
 	mem_avoid[MEM_AVOID_INITRD].size = initrd_size;
+	/* No need to set mapping for initrd, it will be handled in VO. */
 
 	/* Avoid kernel command line. */
 	cmd_line  = (u64)boot_params->ext_cmd_line_ptr << 32;
@@ -259,10 +262,21 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 		;
 	mem_avoid[MEM_AVOID_CMDLINE].start = cmd_line;
 	mem_avoid[MEM_AVOID_CMDLINE].size = cmd_line_size;
+	add_identity_map(mem_avoid[MEM_AVOID_CMDLINE].start,
+			 mem_avoid[MEM_AVOID_CMDLINE].size);
 
 	/* Avoid boot parameters. */
 	mem_avoid[MEM_AVOID_BOOTPARAMS].start = (unsigned long)boot_params;
 	mem_avoid[MEM_AVOID_BOOTPARAMS].size = sizeof(*boot_params);
+	add_identity_map(mem_avoid[MEM_AVOID_BOOTPARAMS].start,
+			 mem_avoid[MEM_AVOID_BOOTPARAMS].size);
+
+	/* We don't need to set a mapping for setup_data. */
+
+#ifdef CONFIG_X86_VERBOSE_BOOTUP
+	/* Make sure video RAM can be used. */
+	add_identity_map(0, PMD_SIZE);
+#endif
 }
 
 /* Does this memory vector overlap a known avoided area? */
@@ -421,6 +435,9 @@ unsigned char *choose_random_location(unsigned long input,
 		goto out;
 
 	choice = random_addr;
+
+	add_identity_map(choice, output_size);
+	finalize_identity_maps();
 out:
 	return (unsigned char *)choice;
 }
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 3a142b9512d3..de3c8a4b8a1d 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -84,6 +84,17 @@ unsigned char *choose_random_location(unsigned long input,
 }
 #endif
 
+#ifdef CONFIG_X86_64
+void add_identity_map(unsigned long start, unsigned long size);
+void finalize_identity_maps(void);
+extern unsigned char _pgtable[];
+#else
+static inline void add_identity_map(unsigned long start, unsigned long size)
+{ }
+static inline void finalize_identity_maps(void)
+{ }
+#endif
+
 #ifdef CONFIG_EARLY_PRINTK
 /* early_serial_console.c */
 extern int early_serial_base;
diff --git a/arch/x86/boot/compressed/pagetable.c b/arch/x86/boot/compressed/pagetable.c
new file mode 100644
index 000000000000..cc5bbc4eafb4
--- /dev/null
+++ b/arch/x86/boot/compressed/pagetable.c
@@ -0,0 +1,135 @@
+/*
+ * This code is used on x86_64 to create page table identity mappings on
+ * demand by building up a new set of page tables (or appending to the
+ * existing ones), and then switching over to them when ready.
+ */
+
+/*
+ * Since we're dealing with identity mappings, physical and virtual
+ * addresses are the same, so override these defines which are ultimately
+ * used by the headers in misc.h.
+ */
+#define __pa(x)  ((unsigned long)(x))
+#define __va(x)  ((void *)((unsigned long)(x)))
+
+#include "misc.h"
+
+/* These actually do the work of building the kernel identity maps. */
+#include <asm/init.h>
+#include <asm/pgtable.h>
+#include "../../mm/ident_map.c"
+
+/* Used by pgtable.h asm code to force instruction serialization. */
+unsigned long __force_order;
+
+/* Used to track our page table allocation area. */
+struct alloc_pgt_data {
+	unsigned char *pgt_buf;
+	unsigned long pgt_buf_size;
+	unsigned long pgt_buf_offset;
+};
+
+/*
+ * Allocates space for a page table entry, using struct alloc_pgt_data
+ * above. Besides the local callers, this is used as the allocation
+ * callback in mapping_info below.
+ */
+static void *alloc_pgt_page(void *context)
+{
+	struct alloc_pgt_data *pages = (struct alloc_pgt_data *)context;
+	unsigned char *entry;
+
+	/* Validate there is space available for a new page. */
+	if (pages->pgt_buf_offset >= pages->pgt_buf_size) {
+		debug_putstr("out of pgt_buf in " __FILE__ "!?\n");
+		debug_putaddr(pages->pgt_buf_offset);
+		debug_putaddr(pages->pgt_buf_size);
+		return NULL;
+	}
+
+	entry = pages->pgt_buf + pages->pgt_buf_offset;
+	pages->pgt_buf_offset += PAGE_SIZE;
+
+	return entry;
+}
+
+/* Used to track our allocated page tables. */
+static struct alloc_pgt_data pgt_data;
+
+/* The top level page table entry pointer. */
+static unsigned long level4p;
+
+/* Locates and clears a region for a new top level page table. */
+static void prepare_level4(void)
+{
+	/*
+	 * It should be impossible for this not to already be true,
+	 * but since calling this a second time would rewind the other
+	 * counters, let's just make sure this is reset too.
+	 */
+	pgt_data.pgt_buf_offset = 0;
+
+	/*
+	 * If we came here via startup_32(), cr3 will be _pgtable already
+	 * and we must append to the existing area instead of entirely
+	 * overwriting it.
+	 */
+	level4p = read_cr3();
+	if (level4p == (unsigned long)_pgtable) {
+		debug_putstr("booted via startup_32()\n");
+		pgt_data.pgt_buf = _pgtable + BOOT_INIT_PGT_SIZE;
+		pgt_data.pgt_buf_size = BOOT_PGT_SIZE - BOOT_INIT_PGT_SIZE;
+		memset(pgt_data.pgt_buf, 0, pgt_data.pgt_buf_size);
+	} else {
+		debug_putstr("booted via startup_64()\n");
+		pgt_data.pgt_buf = _pgtable;
+		pgt_data.pgt_buf_size = BOOT_PGT_SIZE;
+		memset(pgt_data.pgt_buf, 0, pgt_data.pgt_buf_size);
+		level4p = (unsigned long)alloc_pgt_page(&pgt_data);
+	}
+}
+
+/*
+ * Mapping information structure passed to kernel_ident_mapping_init().
+ * Since this never changes, there's no reason to repeatedly fill it
+ * in on the stack when calling add_identity_map().
+ */
+static struct x86_mapping_info mapping_info = {
+	.alloc_pgt_page = alloc_pgt_page,
+	.context = &pgt_data,
+	.pmd_flag = __PAGE_KERNEL_LARGE_EXEC,
+};
+
+/*
+ * Adds the specified range to what will become the new identity mappings.
+ * Once all ranges have been added, the new mapping is activated by calling
+ * finalize_identity_maps() below.
+ */
+void add_identity_map(unsigned long start, unsigned long size)
+{
+	unsigned long end = start + size;
+
+	/* Make sure we have a top level page table ready to use. */
+	if (!level4p)
+		prepare_level4();
+
+	/* Align boundary to 2M. */
+	start = round_down(start, PMD_SIZE);
+	end = round_up(end, PMD_SIZE);
+	if (start >= end)
+		return;
+
+	/* Build the mapping. */
+	kernel_ident_mapping_init(&mapping_info, (pgd_t *)level4p,
+				  start, end);
+}
+
+/*
+ * This switches the page tables to the new level4 that has been built
+ * via calls to add_identity_map() above. If booted via startup_32(),
+ * this is effectively a no-op.
+ */
+void finalize_identity_maps(void)
+{
+	write_cr3(level4p);
+}
diff --git a/arch/x86/include/asm/boot.h b/arch/x86/include/asm/boot.h
index 52e6ca670ed0..abd06b19ddd2 100644
--- a/arch/x86/include/asm/boot.h
+++ b/arch/x86/include/asm/boot.h
@@ -31,6 +31,25 @@
 
 #ifdef CONFIG_X86_64
 # define BOOT_STACK_SIZE	0x4000
+
+# define BOOT_INIT_PGT_SIZE	(6*4096)
+# ifdef CONFIG_RANDOMIZE_BASE
+/*
+ * Assuming all cross the 512GB boundary:
+ * 1 page for level4
+ * (2+2)*4 pages for kernel, param, cmd_line, and randomized kernel
+ * 2 pages for first 2M (video RAM: CONFIG_X86_VERBOSE_BOOTUP).
+ * Total is 19 pages.
+ */
+#  ifdef CONFIG_X86_VERBOSE_BOOTUP
+#   define BOOT_PGT_SIZE	(19*4096)
+#  else /* !CONFIG_X86_VERBOSE_BOOTUP */
+#   define BOOT_PGT_SIZE	(17*4096)
+#  endif
+# else /* !CONFIG_RANDOMIZE_BASE */
+#  define BOOT_PGT_SIZE		BOOT_INIT_PGT_SIZE
+# endif
+
 #else /* !CONFIG_X86_64 */
 # define BOOT_STACK_SIZE	0x1000
 #endif
-- 
2.6.3
