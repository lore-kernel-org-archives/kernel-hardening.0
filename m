Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 14 Apr 2016 15:29:05 -0700
Message-Id: <1460672954-32567-13-git-send-email-keescook@chromium.org>
In-Reply-To: <1460672954-32567-1-git-send-email-keescook@chromium.org>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 12/21] x86, 64bit: Set ident_mapping for KASLR
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Yinghai Lu <yinghai@kernel.org>

Currently KASLR only supports relocation in a small physical range (from
16M to 1G), due to using the initial kernel page table identify mapping.
To support ranges above this, we need to have an identity mapping for
the desired memory range before we can decompress (and later run) the
kernel.

This patch adds an identity mapping for needed memory range. This happens
in two possible boot paths:

If loaded via startup_32, we need to set up the identity mapping we need.

If loaded from a 64-bit bootloader, the bootloader will have
already set up an identity mapping, and we'll start via ZO's
(arch/x86/boot/compressed/vmlinux) startup_64. In this case, the
bootloader's page tables need to be avoided when we select the new VO
(vmlinux) location. If not, the decompressor could overwrite them during
decompression.

To accomplish avoiding the bootloader's page tables, we could walk the
pagetable and find every page that is used, and add them to mem_avoid,
but this needs extra code and will require increasing the size of the
mem_avoid array.

Instead, we can create new ident mapping instead, and pages for the
pagetable will come from the _pagetable section of ZO, which means they
are already in mem_avoid array. To do this, we reuse the code for the
kernel's identity mapping.

The _pgtable will be shared by 32-bit and 64-bit path to reduce init_size,
as now ZO _rodata to _end will contribute init_size.

To handle the possible mappings, we need to increase the pgt buffer size:

When booting via startup_64, as we need to cover the old VO, params,
cmdline and new VO. In an extreme case we could have them all beyond the
512G boundary, which needs (2+2)*4 pages with 2M mappings. And we'll
need 2 for first 2M for VGA RAM. One more is needed for level4. This
gets us to 19 pages total.

When booting via startup_32, KASLR could move new VO above 4G, so we
need to set extra identity mappings for new VO, which should only need
(2+2) pages at most when it is beyond the 512G boundary. So 19 pages
is sufficient for this case as well.

Cc: Kees Cook <keescook@chromium.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Baoquan He <bhe@redhat.com>
[kees: rewrote changelog]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/Makefile   |  3 ++
 arch/x86/boot/compressed/aslr.c     | 14 ++++++
 arch/x86/boot/compressed/head_64.S  |  4 +-
 arch/x86/boot/compressed/misc.h     | 11 +++++
 arch/x86/boot/compressed/misc_pgt.c | 93 +++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/boot.h         | 19 ++++++++
 6 files changed, 142 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/boot/compressed/misc_pgt.c

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index aa421126556d..af9ea6f0baa2 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -63,6 +63,9 @@ vmlinux-objs-y := $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 
 vmlinux-objs-$(CONFIG_EARLY_PRINTK) += $(obj)/early_serial_console.o
 vmlinux-objs-$(CONFIG_RANDOMIZE_BASE) += $(obj)/aslr.o
+ifdef CONFIG_X86_64
+	vmlinux-objs-$(CONFIG_RANDOMIZE_BASE) += $(obj)/misc_pgt.o
+endif
 
 $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
 
diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 277c7a4ec3a3..cd261debead9 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -194,6 +194,7 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 	 */
 	mem_avoid[0].start = input;
 	mem_avoid[0].size = (output + init_size) - input;
+	fill_pagetable(mem_avoid[0].start, mem_avoid[0].size);
 
 	/* Avoid initrd. */
 	initrd_start  = (u64)real_mode->ext_ramdisk_image << 32;
@@ -202,6 +203,7 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 	initrd_size |= real_mode->hdr.ramdisk_size;
 	mem_avoid[1].start = initrd_start;
 	mem_avoid[1].size = initrd_size;
+	/* No need to set mapping for initrd */
 
 	/* Avoid kernel command line. */
 	cmd_line  = (u64)real_mode->ext_cmd_line_ptr << 32;
@@ -212,10 +214,19 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 		;
 	mem_avoid[2].start = cmd_line;
 	mem_avoid[2].size = cmd_line_size;
+	fill_pagetable(mem_avoid[2].start, mem_avoid[2].size);
 
 	/* Avoid params */
 	mem_avoid[3].start = (unsigned long)real_mode;
 	mem_avoid[3].size = sizeof(*real_mode);
+	fill_pagetable(mem_avoid[3].start, mem_avoid[3].size);
+
+	/* don't need to set mapping for setup_data */
+
+#ifdef CONFIG_X86_VERBOSE_BOOTUP
+	/* for video ram */
+	fill_pagetable(0, PMD_SIZE);
+#endif
 }
 
 /* Does this memory vector overlap a known avoided area? */
@@ -371,6 +382,9 @@ unsigned char *choose_kernel_location(unsigned char *input,
 		goto out;
 
 	choice = random;
+
+	fill_pagetable(choice, output_size);
+	switch_pagetable();
 out:
 	return (unsigned char *)choice;
 }
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 36914515dd76..075bb15f9494 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -126,7 +126,7 @@ ENTRY(startup_32)
 	/* Initialize Page tables to 0 */
 	leal	pgtable(%ebx), %edi
 	xorl	%eax, %eax
-	movl	$((4096*6)/4), %ecx
+	movl	$(BOOT_INIT_PGT_SIZE/4), %ecx
 	rep	stosl
 
 	/* Build Level 4 */
@@ -478,4 +478,4 @@ boot_stack_end:
 	.section ".pgtable","a",@nobits
 	.balign 4096
 pgtable:
-	.fill 6*4096, 1, 0
+	.fill BOOT_PGT_SIZE, 1, 0
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index dcf01c22400e..11736a6a6670 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -84,6 +84,17 @@ unsigned char *choose_kernel_location(unsigned char *input,
 }
 #endif
 
+#ifdef CONFIG_X86_64
+void fill_pagetable(unsigned long start, unsigned long size);
+void switch_pagetable(void);
+extern unsigned char _pgtable[];
+#else
+static inline void fill_pagetable(unsigned long start, unsigned long size)
+{ }
+static inline void switch_pagetable(void)
+{ }
+#endif
+
 #ifdef CONFIG_EARLY_PRINTK
 /* early_serial_console.c */
 extern int early_serial_base;
diff --git a/arch/x86/boot/compressed/misc_pgt.c b/arch/x86/boot/compressed/misc_pgt.c
new file mode 100644
index 000000000000..816551d0327c
--- /dev/null
+++ b/arch/x86/boot/compressed/misc_pgt.c
@@ -0,0 +1,93 @@
+#define __pa(x)  ((unsigned long)(x))
+#define __va(x)  ((void *)((unsigned long)(x)))
+
+#include "misc.h"
+
+#include <asm/init.h>
+#include <asm/pgtable.h>
+
+#include "../../mm/ident_map.c"
+#include "../string.h"
+
+struct alloc_pgt_data {
+	unsigned char *pgt_buf;
+	unsigned long pgt_buf_size;
+	unsigned long pgt_buf_offset;
+};
+
+static void *alloc_pgt_page(void *context)
+{
+	struct alloc_pgt_data *d = (struct alloc_pgt_data *)context;
+	unsigned char *p = (unsigned char *)d->pgt_buf;
+
+	if (d->pgt_buf_offset >= d->pgt_buf_size) {
+		debug_putstr("out of pgt_buf in misc.c\n");
+		debug_putaddr(d->pgt_buf_offset);
+		debug_putaddr(d->pgt_buf_size);
+		return NULL;
+	}
+
+	p += d->pgt_buf_offset;
+	d->pgt_buf_offset += PAGE_SIZE;
+
+	return p;
+}
+
+/*
+ * Use a normal definition of memset() from string.c. There are already
+ * included header files which expect a definition of memset() and by
+ * the time we define memset macro, it is too late.
+ */
+#undef memset
+
+unsigned long __force_order;
+static struct alloc_pgt_data pgt_data;
+static struct x86_mapping_info mapping_info;
+static pgd_t *level4p;
+
+void fill_pagetable(unsigned long start, unsigned long size)
+{
+	unsigned long end = start + size;
+
+	if (!level4p) {
+		pgt_data.pgt_buf_offset = 0;
+		mapping_info.alloc_pgt_page = alloc_pgt_page;
+		mapping_info.context = &pgt_data;
+		mapping_info.pmd_flag = __PAGE_KERNEL_LARGE_EXEC;
+
+		/*
+		 * come from startup_32 ?
+		 * then cr3 is _pgtable, we can reuse it.
+		 */
+		level4p = (pgd_t *)read_cr3();
+		if ((unsigned long)level4p == (unsigned long)_pgtable) {
+			pgt_data.pgt_buf = (unsigned char *)_pgtable +
+						 BOOT_INIT_PGT_SIZE;
+			pgt_data.pgt_buf_size = BOOT_PGT_SIZE -
+						 BOOT_INIT_PGT_SIZE;
+			memset((unsigned char *)pgt_data.pgt_buf, 0,
+				pgt_data.pgt_buf_size);
+			debug_putstr("boot via startup_32\n");
+		} else {
+			pgt_data.pgt_buf = (unsigned char *)_pgtable;
+			pgt_data.pgt_buf_size = BOOT_PGT_SIZE;
+			memset((unsigned char *)pgt_data.pgt_buf, 0,
+				pgt_data.pgt_buf_size);
+			debug_putstr("boot via startup_64\n");
+			level4p = (pgd_t *)alloc_pgt_page(&pgt_data);
+		}
+	}
+
+	/* align boundary to 2M */
+	start = round_down(start, PMD_SIZE);
+	end = round_up(end, PMD_SIZE);
+	if (start >= end)
+		return;
+
+	kernel_ident_mapping_init(&mapping_info, level4p, start, end);
+}
+
+void switch_pagetable(void)
+{
+	write_cr3((unsigned long)level4p);
+}
diff --git a/arch/x86/include/asm/boot.h b/arch/x86/include/asm/boot.h
index 6b8d6e8cd449..52a9cbc1419f 100644
--- a/arch/x86/include/asm/boot.h
+++ b/arch/x86/include/asm/boot.h
@@ -32,7 +32,26 @@
 #endif /* !CONFIG_KERNEL_BZIP2 */
 
 #ifdef CONFIG_X86_64
+
 #define BOOT_STACK_SIZE	0x4000
+
+#define BOOT_INIT_PGT_SIZE (6*4096)
+#ifdef CONFIG_RANDOMIZE_BASE
+/*
+ * 1 page for level4, 2 pages for first 2M.
+ * (2+2)*4 pages for kernel, param, cmd_line, random kernel
+ * if all cross 512G boundary.
+ * So total will be 19 pages.
+ */
+#ifdef CONFIG_X86_VERBOSE_BOOTUP
+#define BOOT_PGT_SIZE (19*4096)
+#else
+#define BOOT_PGT_SIZE (17*4096)
+#endif
+#else
+#define BOOT_PGT_SIZE BOOT_INIT_PGT_SIZE
+#endif
+
 #else
 #define BOOT_STACK_SIZE	0x1000
 #endif
-- 
2.6.3
