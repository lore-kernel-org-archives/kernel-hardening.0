Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue, 21 Jun 2016 17:47:04 -0700
Message-Id: <1466556426-32664-8-git-send-email-keescook@chromium.org>
In-Reply-To: <1466556426-32664-1-git-send-email-keescook@chromium.org>
References: <1466556426-32664-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v7 7/9] x86/mm: Enable KASLR for vmalloc memory region (x86_64)
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Andy Lutomirski <luto@kernel.org>, x86@kernel.org, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Juergen Gross <jgross@suse.com>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Dave Young <dyoung@redhat.com>, Joerg Roedel <jroedel@suse.de>, Lv Zheng <lv.zheng@intel.com>, Mark Salter <msalter@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, Stephen Smalley <sds@tycho.nsa.gov>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Jan Beulich <JBeulich@suse.com>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Thomas Garnier <thgarnie@google.com>

Add vmalloc in the list of randomized memory regions.

The vmalloc memory region contains the allocation made through the vmalloc
API. The allocations are done sequentially to prevent fragmentation and
each allocation address can easily be deduced especially from boot.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/kaslr.h            |  1 +
 arch/x86/include/asm/pgtable_64_types.h | 15 +++++++++++----
 arch/x86/mm/kaslr.c                     |  5 ++++-
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kaslr.h b/arch/x86/include/asm/kaslr.h
index 62b1b815a83a..2674ee3de748 100644
--- a/arch/x86/include/asm/kaslr.h
+++ b/arch/x86/include/asm/kaslr.h
@@ -5,6 +5,7 @@ unsigned long kaslr_get_random_long(const char *purpose);
 
 #ifdef CONFIG_RANDOMIZE_MEMORY
 extern unsigned long page_offset_base;
+extern unsigned long vmalloc_base;
 
 void kernel_randomize_memory(void);
 #else
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index e6844dfb4471..6fdef9eef2d5 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -5,6 +5,7 @@
 
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
+#include <asm/kaslr.h>
 
 /*
  * These are used to make use of C type-checking..
@@ -53,10 +54,16 @@ typedef struct { pteval_t pte; } pte_t;
 #define PGDIR_MASK	(~(PGDIR_SIZE - 1))
 
 /* See Documentation/x86/x86_64/mm.txt for a description of the memory map. */
-#define MAXMEM		 _AC(__AC(1, UL) << MAX_PHYSMEM_BITS, UL)
-#define VMALLOC_START    _AC(0xffffc90000000000, UL)
-#define VMALLOC_END      _AC(0xffffe8ffffffffff, UL)
-#define VMEMMAP_START	 _AC(0xffffea0000000000, UL)
+#define MAXMEM		_AC(__AC(1, UL) << MAX_PHYSMEM_BITS, UL)
+#define VMALLOC_SIZE_TB	_AC(32, UL)
+#define __VMALLOC_BASE	_AC(0xffffc90000000000, UL)
+#define VMEMMAP_START	_AC(0xffffea0000000000, UL)
+#ifdef CONFIG_RANDOMIZE_MEMORY
+#define VMALLOC_START	vmalloc_base
+#else
+#define VMALLOC_START	__VMALLOC_BASE
+#endif /* CONFIG_RANDOMIZE_MEMORY */
+#define VMALLOC_END	(VMALLOC_START + _AC((VMALLOC_SIZE_TB << 40) - 1, UL))
 #define MODULES_VADDR    (__START_KERNEL_map + KERNEL_IMAGE_SIZE)
 #define MODULES_END      _AC(0xffffffffff000000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index 609ecf2b37ed..c939cfe1b516 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -44,11 +44,13 @@
  * ensure that this order is correct and won't be changed.
  */
 static const unsigned long vaddr_start = __PAGE_OFFSET_BASE;
-static const unsigned long vaddr_end = VMALLOC_START;
+static const unsigned long vaddr_end = VMEMMAP_START;
 
 /* Default values */
 unsigned long page_offset_base = __PAGE_OFFSET_BASE;
 EXPORT_SYMBOL(page_offset_base);
+unsigned long vmalloc_base = __VMALLOC_BASE;
+EXPORT_SYMBOL(vmalloc_base);
 
 /*
  * Memory regions randomized by KASLR (except modules that use a separate logic
@@ -60,6 +62,7 @@ static __initdata struct kaslr_memory_region {
 	unsigned long size_tb;
 } kaslr_regions[] = {
 	{ &page_offset_base, 64/* Maximum */ },
+	{ &vmalloc_base, VMALLOC_SIZE_TB },
 };
 
 /* Get size in bytes used by the memory region */
-- 
2.7.4
