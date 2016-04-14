Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 14 Apr 2016 15:28:56 -0700
Message-Id: <1460672954-32567-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1460672954-32567-1-git-send-email-keescook@chromium.org>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 03/21] x86, KASLR: Drop CONFIG_RANDOMIZE_BASE_MAX_OFFSET
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Baoquan He <bhe@redhat.com>

Currently CONFIG_RANDOMIZE_BASE_MAX_OFFSET is used to limit the maximum
offset for kernel randomization. This limit doesn't need to be a CONFIG
since it is tied completely to KERNEL_IMAGE_SIZE, and will make no sense
once physical and virtual offsets are randomized separately. This patch
removes CONFIG_RANDOMIZE_BASE_MAX_OFFSET and consolidates the Kconfig
help text.

Signed-off-by: Baoquan He <bhe@redhat.com>
[kees: rewrote changelog, dropped KERNEL_IMAGE_SIZE_DEFAULT, moved earlier]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/Kconfig                     | 57 +++++++++++++-----------------------
 arch/x86/boot/compressed/aslr.c      | 12 ++++----
 arch/x86/include/asm/page_64_types.h |  8 ++---
 arch/x86/mm/init_32.c                |  3 --
 4 files changed, 29 insertions(+), 51 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2dc18605831f..fd9ac711ada8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1936,51 +1936,36 @@ config RANDOMIZE_BASE
 	depends on RELOCATABLE
 	default n
 	---help---
-	   Randomizes the physical and virtual address at which the
-	   kernel image is decompressed, as a security feature that
-	   deters exploit attempts relying on knowledge of the location
-	   of kernel internals.
+	   Randomizes the physical address at which the kernel image
+	   is decompressed and the virtual address where the kernel
+	   image is mapped, as a secrurity feature that deters exploit
+	   attempts relying on knowledge of the location of kernel
+	   internals.
+
+	   The kernel physical address can be randomized from 16M to
+	   64T at most. The kernel virtual address will be offset
+	   by up to KERNEL_IMAGE_SIZE. On 32-bit KERNEL_IMAGE_SIZE is
+	   512MiB. while on 64-bit this is limited by how the kernel
+	   fixmap page table is positioned, so this cannot be larger
+	   than 1GiB currently. Without RANDOMIZE_BASE there is a 512MiB
+	   to 1.5GiB split between kernel and modules. When RANDOMIZE_BASE
+	   is enabled, the modules area will shrink to compensate, up
+	   to a 1GiB to 1GiB split, KERNEL_IMAGE_SIZE changes from 512MiB
+	   to 1GiB.
 
 	   Entropy is generated using the RDRAND instruction if it is
 	   supported. If RDTSC is supported, it is used as well. If
 	   neither RDRAND nor RDTSC are supported, then randomness is
 	   read from the i8254 timer.
 
-	   The kernel will be offset by up to RANDOMIZE_BASE_MAX_OFFSET,
-	   and aligned according to PHYSICAL_ALIGN. Since the kernel is
-	   built using 2GiB addressing, and PHYSICAL_ALGIN must be at a
-	   minimum of 2MiB, only 10 bits of entropy is theoretically
-	   possible. At best, due to page table layouts, 64-bit can use
-	   9 bits of entropy and 32-bit uses 8 bits.
+	   Since the kernel is built using 2GiB addressing, and
+	   PHYSICAL_ALGIN must be at a minimum of 2MiB, only 10 bits of
+	   entropy is theoretically possible. At best, due to page table
+	   layouts, 64-bit can use 9 bits of entropy and 32-bit uses 8
+	   bits.
 
 	   If unsure, say N.
 
-config RANDOMIZE_BASE_MAX_OFFSET
-	hex "Maximum kASLR offset allowed" if EXPERT
-	depends on RANDOMIZE_BASE
-	range 0x0 0x20000000 if X86_32
-	default "0x20000000" if X86_32
-	range 0x0 0x40000000 if X86_64
-	default "0x40000000" if X86_64
-	---help---
-	  The lesser of RANDOMIZE_BASE_MAX_OFFSET and available physical
-	  memory is used to determine the maximal offset in bytes that will
-	  be applied to the kernel when kernel Address Space Layout
-	  Randomization (kASLR) is active. This must be a multiple of
-	  PHYSICAL_ALIGN.
-
-	  On 32-bit this is limited to 512MiB by page table layouts. The
-	  default is 512MiB.
-
-	  On 64-bit this is limited by how the kernel fixmap page table is
-	  positioned, so this cannot be larger than 1GiB currently. Without
-	  RANDOMIZE_BASE, there is a 512MiB to 1.5GiB split between kernel
-	  and modules. When RANDOMIZE_BASE_MAX_OFFSET is above 512MiB, the
-	  modules area will shrink to compensate, up to the current maximum
-	  1GiB to 1GiB split. The default is 1GiB.
-
-	  If unsure, leave at the default value.
-
 # Relocation on x86 needs some additional build support
 config X86_NEED_RELOCS
 	def_bool y
diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 622aa881c6ab..462654097d63 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -206,15 +206,13 @@ static bool mem_avoid_overlap(struct mem_vector *img)
 	return false;
 }
 
-static unsigned long slots[CONFIG_RANDOMIZE_BASE_MAX_OFFSET /
-			   CONFIG_PHYSICAL_ALIGN];
+static unsigned long slots[KERNEL_IMAGE_SIZE / CONFIG_PHYSICAL_ALIGN];
 static unsigned long slot_max;
 
 static void slots_append(unsigned long addr)
 {
 	/* Overflowing the slots list should be impossible. */
-	if (slot_max >= CONFIG_RANDOMIZE_BASE_MAX_OFFSET /
-			CONFIG_PHYSICAL_ALIGN)
+	if (slot_max >= KERNEL_IMAGE_SIZE / CONFIG_PHYSICAL_ALIGN)
 		return;
 
 	slots[slot_max++] = addr;
@@ -240,7 +238,7 @@ static void process_e820_entry(struct e820entry *entry,
 		return;
 
 	/* Ignore entries entirely above our maximum. */
-	if (entry->addr >= CONFIG_RANDOMIZE_BASE_MAX_OFFSET)
+	if (entry->addr >= KERNEL_IMAGE_SIZE)
 		return;
 
 	/* Ignore entries entirely below our minimum. */
@@ -265,8 +263,8 @@ static void process_e820_entry(struct e820entry *entry,
 	region.size -= region.start - entry->addr;
 
 	/* Reduce maximum size to fit end of image within maximum limit. */
-	if (region.start + region.size > CONFIG_RANDOMIZE_BASE_MAX_OFFSET)
-		region.size = CONFIG_RANDOMIZE_BASE_MAX_OFFSET - region.start;
+	if (region.start + region.size > KERNEL_IMAGE_SIZE)
+		region.size = KERNEL_IMAGE_SIZE - region.start;
 
 	/* Walk each aligned slot and check for avoided areas. */
 	for (img.start = region.start, img.size = image_size ;
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 4928cf0d5af0..d5c2f8b40faa 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -47,12 +47,10 @@
  * are fully set up. If kernel ASLR is configured, it can extend the
  * kernel page table mapping, reducing the size of the modules area.
  */
-#define KERNEL_IMAGE_SIZE_DEFAULT      (512 * 1024 * 1024)
-#if defined(CONFIG_RANDOMIZE_BASE) && \
-	CONFIG_RANDOMIZE_BASE_MAX_OFFSET > KERNEL_IMAGE_SIZE_DEFAULT
-#define KERNEL_IMAGE_SIZE   CONFIG_RANDOMIZE_BASE_MAX_OFFSET
+#if defined(CONFIG_RANDOMIZE_BASE)
+#define KERNEL_IMAGE_SIZE	(1024 * 1024 * 1024)
 #else
-#define KERNEL_IMAGE_SIZE      KERNEL_IMAGE_SIZE_DEFAULT
+#define KERNEL_IMAGE_SIZE	(512 * 1024 * 1024)
 #endif
 
 #endif /* _ASM_X86_PAGE_64_DEFS_H */
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index bd7a9b9e2e14..f2ee42d61894 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -804,9 +804,6 @@ void __init mem_init(void)
 	BUILD_BUG_ON(VMALLOC_START			>= VMALLOC_END);
 #undef high_memory
 #undef __FIXADDR_TOP
-#ifdef CONFIG_RANDOMIZE_BASE
-	BUILD_BUG_ON(CONFIG_RANDOMIZE_BASE_MAX_OFFSET > KERNEL_IMAGE_SIZE);
-#endif
 
 #ifdef CONFIG_HIGHMEM
 	BUG_ON(PKMAP_BASE + LAST_PKMAP*PAGE_SIZE	> FIXADDR_START);
-- 
2.6.3
