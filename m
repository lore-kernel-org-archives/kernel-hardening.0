Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue, 21 Jun 2016 17:47:05 -0700
Message-Id: <1466556426-32664-9-git-send-email-keescook@chromium.org>
In-Reply-To: <1466556426-32664-1-git-send-email-keescook@chromium.org>
References: <1466556426-32664-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v7 8/9] x86/mm: Enable KASLR for vmemmap memory region (x86_64)
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Andy Lutomirski <luto@kernel.org>, x86@kernel.org, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Juergen Gross <jgross@suse.com>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Dave Young <dyoung@redhat.com>, Joerg Roedel <jroedel@suse.de>, Lv Zheng <lv.zheng@intel.com>, Mark Salter <msalter@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, Stephen Smalley <sds@tycho.nsa.gov>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Jan Beulich <JBeulich@suse.com>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Thomas Garnier <thgarnie@google.com>

Add vmemmap in the list of randomized memory regions.

The vmemmap region holds a representation of the physical memory (through
a struct page array). An attacker could use this region to disclose the
kernel memory layout (walking the page linked list).

Signed-off-by: Thomas Garnier <thgarnie@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/kaslr.h            |  1 +
 arch/x86/include/asm/pgtable_64_types.h |  4 +++-
 arch/x86/mm/kaslr.c                     | 24 +++++++++++++++++++++++-
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kaslr.h b/arch/x86/include/asm/kaslr.h
index 2674ee3de748..1052a797d71d 100644
--- a/arch/x86/include/asm/kaslr.h
+++ b/arch/x86/include/asm/kaslr.h
@@ -6,6 +6,7 @@ unsigned long kaslr_get_random_long(const char *purpose);
 #ifdef CONFIG_RANDOMIZE_MEMORY
 extern unsigned long page_offset_base;
 extern unsigned long vmalloc_base;
+extern unsigned long vmemmap_base;
 
 void kernel_randomize_memory(void);
 #else
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 6fdef9eef2d5..3a264200c62f 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -57,11 +57,13 @@ typedef struct { pteval_t pte; } pte_t;
 #define MAXMEM		_AC(__AC(1, UL) << MAX_PHYSMEM_BITS, UL)
 #define VMALLOC_SIZE_TB	_AC(32, UL)
 #define __VMALLOC_BASE	_AC(0xffffc90000000000, UL)
-#define VMEMMAP_START	_AC(0xffffea0000000000, UL)
+#define __VMEMMAP_BASE	_AC(0xffffea0000000000, UL)
 #ifdef CONFIG_RANDOMIZE_MEMORY
 #define VMALLOC_START	vmalloc_base
+#define VMEMMAP_START	vmemmap_base
 #else
 #define VMALLOC_START	__VMALLOC_BASE
+#define VMEMMAP_START	__VMEMMAP_BASE
 #endif /* CONFIG_RANDOMIZE_MEMORY */
 #define VMALLOC_END	(VMALLOC_START + _AC((VMALLOC_SIZE_TB << 40) - 1, UL))
 #define MODULES_VADDR    (__START_KERNEL_map + KERNEL_IMAGE_SIZE)
diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index c939cfe1b516..4f91dc273062 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -44,13 +44,22 @@
  * ensure that this order is correct and won't be changed.
  */
 static const unsigned long vaddr_start = __PAGE_OFFSET_BASE;
-static const unsigned long vaddr_end = VMEMMAP_START;
+
+#if defined(CONFIG_X86_ESPFIX64)
+static const unsigned long vaddr_end = ESPFIX_BASE_ADDR;
+#elif defined(CONFIG_EFI)
+static const unsigned long vaddr_end = EFI_VA_START;
+#else
+static const unsigned long vaddr_end = __START_KERNEL_map;
+#endif
 
 /* Default values */
 unsigned long page_offset_base = __PAGE_OFFSET_BASE;
 EXPORT_SYMBOL(page_offset_base);
 unsigned long vmalloc_base = __VMALLOC_BASE;
 EXPORT_SYMBOL(vmalloc_base);
+unsigned long vmemmap_base = __VMEMMAP_BASE;
+EXPORT_SYMBOL(vmemmap_base);
 
 /*
  * Memory regions randomized by KASLR (except modules that use a separate logic
@@ -63,6 +72,7 @@ static __initdata struct kaslr_memory_region {
 } kaslr_regions[] = {
 	{ &page_offset_base, 64/* Maximum */ },
 	{ &vmalloc_base, VMALLOC_SIZE_TB },
+	{ &vmemmap_base, 1 },
 };
 
 /* Get size in bytes used by the memory region */
@@ -89,6 +99,18 @@ void __init kernel_randomize_memory(void)
 	struct rnd_state rand_state;
 	unsigned long remain_entropy;
 
+	/*
+	 * All these BUILD_BUG_ON checks ensures the memory layout is
+	 * consistent with the vaddr_start/vaddr_end variables.
+	 */
+	BUILD_BUG_ON(vaddr_start >= vaddr_end);
+	BUILD_BUG_ON(config_enabled(CONFIG_X86_ESPFIX64) &&
+		     vaddr_end >= EFI_VA_START);
+	BUILD_BUG_ON((config_enabled(CONFIG_X86_ESPFIX64) ||
+		      config_enabled(CONFIG_EFI)) &&
+		     vaddr_end >= __START_KERNEL_map);
+	BUILD_BUG_ON(vaddr_end > __START_KERNEL_map);
+
 	if (!kaslr_memory_enabled())
 		return;
 
-- 
2.7.4
