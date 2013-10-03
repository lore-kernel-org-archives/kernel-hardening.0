Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu,  3 Oct 2013 13:53:25 -0700
Message-Id: <1380833605-26313-8-git-send-email-keescook@chromium.org>
In-Reply-To: <1380833605-26313-1-git-send-email-keescook@chromium.org>
References: <1380833605-26313-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 7/7] x86, kaslr: raise max positions to 1GiB on x86_64
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, kernel-hardening@lists.openwall.com, adurbin@google.com, Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, "H. Peter Anvin" <hpa@zytor.com>, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On 64-bit, this raises the maximum location to 1GiB, the upper limit
currently, since the kernel fixmap page mappings need to be moved to
use the other 1GiB (which would be the theoretical limit when building
with -mcmodel=kernel).

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/Kconfig                        |   16 +++++++++++++---
 arch/x86/include/asm/page_64_types.h    |   15 ++++++++++++---
 arch/x86/include/asm/pgtable_64_types.h |    2 +-
 arch/x86/mm/init_32.c                   |    3 +++
 4 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 992701d..51f4399 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1746,13 +1746,23 @@ config RANDOMIZE_BASE
 config RANDOMIZE_BASE_MAX_OFFSET
 	hex "Maximum ASLR offset allowed"
 	depends on RANDOMIZE_BASE
-	default "0x10000000"
-	range 0x0 0x10000000
+	range 0x0 0x20000000 if X86_32
+	default "0x20000000" if X86_32
+	range 0x0 0x40000000 if X86_64
+	default "0x40000000" if X86_64
 	---help---
 	 Determines the maximal offset in bytes that will be applied to the
 	 kernel when Address Space Layout Randomization (ASLR) is active.
 	 Must be less than or equal to the actual physical memory on the
-	 system. This must be a power of two.
+	 system. This must be a multiple of CONFIG_PHYSICAL_ALIGN.
+
+	 On 32-bit this is limited to 512MiB.
+
+	 On 64-bit this is limited by how the kernel fixmap page table is
+	 positioned, so this cannot be larger that 1GiB currently. Normally
+	 there is a 512MiB to 1.5GiB split between kernel and modules. When
+	 this is raised above the 512MiB default, the modules area will
+	 shrink to compensate, up to the current maximum 1GiB to 1GiB split.
 
 # Relocation on x86 needs some additional build support
 config X86_NEED_RELOCS
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 43dcd80..8de6d9c 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -39,9 +39,18 @@
 #define __VIRTUAL_MASK_SHIFT	47
 
 /*
- * Kernel image size is limited to 512 MB (see level2_kernel_pgt in
- * arch/x86/kernel/head_64.S), and it is mapped here:
+ * Kernel image size is limited to 1GiB due to the fixmap living in the
+ * next 1GiB (see level2_kernel_pgt in arch/x86/kernel/head_64.S). Use
+ * 512MiB by default, leaving 1.5GiB for modules once the page tables
+ * are fully set up. If kernel ASLR is configured, it can extend the
+ * kernel page table mapping, reducing the size of the modules area.
  */
-#define KERNEL_IMAGE_SIZE	(512 * 1024 * 1024)
+#define KERNEL_IMAGE_SIZE_DEFAULT      (512 * 1024 * 1024)
+#if defined(CONFIG_RANDOMIZE_BASE) && \
+	CONFIG_RANDOMIZE_BASE_MAX_OFFSET > KERNEL_IMAGE_SIZE_DEFAULT
+#define KERNEL_IMAGE_SIZE   CONFIG_RANDOMIZE_BASE_MAX_OFFSET
+#else
+#define KERNEL_IMAGE_SIZE      KERNEL_IMAGE_SIZE_DEFAULT
+#endif
 
 #endif /* _ASM_X86_PAGE_64_DEFS_H */
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 2d88344..c883bf7 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -58,7 +58,7 @@ typedef struct { pteval_t pte; } pte_t;
 #define VMALLOC_START    _AC(0xffffc90000000000, UL)
 #define VMALLOC_END      _AC(0xffffe8ffffffffff, UL)
 #define VMEMMAP_START	 _AC(0xffffea0000000000, UL)
-#define MODULES_VADDR    _AC(0xffffffffa0000000, UL)
+#define MODULES_VADDR    (__START_KERNEL_map + KERNEL_IMAGE_SIZE)
 #define MODULES_END      _AC(0xffffffffff000000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
 
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 4287f1f..5bdc543 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -806,6 +806,9 @@ void __init mem_init(void)
 	BUILD_BUG_ON(VMALLOC_START			>= VMALLOC_END);
 #undef high_memory
 #undef __FIXADDR_TOP
+#ifdef CONFIG_RANDOMIZE_BASE
+	BUILD_BUG_ON(CONFIG_RANDOMIZE_BASE_MAX_OFFSET > KERNEL_IMAGE_SIZE);
+#endif
 
 #ifdef CONFIG_HIGHMEM
 	BUG_ON(PKMAP_BASE + LAST_PKMAP*PAGE_SIZE	> FIXADDR_START);
-- 
1.7.9.5
