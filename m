Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue, 21 Jun 2016 17:47:03 -0700
Message-Id: <1466556426-32664-7-git-send-email-keescook@chromium.org>
In-Reply-To: <1466556426-32664-1-git-send-email-keescook@chromium.org>
References: <1466556426-32664-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v7 6/9] x86/mm: Enable KASLR for physical mapping memory region (x86_64)
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Andy Lutomirski <luto@kernel.org>, x86@kernel.org, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Juergen Gross <jgross@suse.com>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Dave Young <dyoung@redhat.com>, Joerg Roedel <jroedel@suse.de>, Lv Zheng <lv.zheng@intel.com>, Mark Salter <msalter@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, Stephen Smalley <sds@tycho.nsa.gov>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Jan Beulich <JBeulich@suse.com>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Thomas Garnier <thgarnie@google.com>

Add the physical mapping in the list of randomized memory regions.

The physical memory mapping holds most allocations from boot and heap
allocators. Knowing the base address and physical memory size, an attacker
can deduce the PDE virtual address for the vDSO memory page. This attack
was demonstrated at CanSecWest 2016, in the "Getting Physical: Extreme
Abuse of Intel Based Paged Systems" https://goo.gl/ANpWdV (see second part
of the presentation). The exploits used against Linux worked successfully
against 4.6+ but fail with KASLR memory enabled (https://goo.gl/iTtXMJ).
Similar research was done at Google leading to this patch proposal.
Variants exists to overwrite /proc or /sys objects ACLs leading to
elevation of privileges. These variants were tested against 4.6+.

The page offset used by the compressed kernel retains the static value
since it is not yet randomized during this boot stage.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/pagetable.c |  3 +++
 arch/x86/include/asm/kaslr.h         |  2 ++
 arch/x86/include/asm/page_64_types.h | 11 ++++++++++-
 arch/x86/kernel/head_64.S            |  2 +-
 arch/x86/mm/kaslr.c                  | 18 +++++++++++++++---
 5 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/arch/x86/boot/compressed/pagetable.c b/arch/x86/boot/compressed/pagetable.c
index 6e31a6aac4d3..56589d0a804b 100644
--- a/arch/x86/boot/compressed/pagetable.c
+++ b/arch/x86/boot/compressed/pagetable.c
@@ -20,6 +20,9 @@
 /* These actually do the work of building the kernel identity maps. */
 #include <asm/init.h>
 #include <asm/pgtable.h>
+/* Use the static base for this part of the boot process */
+#undef __PAGE_OFFSET
+#define __PAGE_OFFSET __PAGE_OFFSET_BASE
 #include "../../mm/ident_map.c"
 
 /* Used by pgtable.h asm code to force instruction serialization. */
diff --git a/arch/x86/include/asm/kaslr.h b/arch/x86/include/asm/kaslr.h
index 683c9d736314..62b1b815a83a 100644
--- a/arch/x86/include/asm/kaslr.h
+++ b/arch/x86/include/asm/kaslr.h
@@ -4,6 +4,8 @@
 unsigned long kaslr_get_random_long(const char *purpose);
 
 #ifdef CONFIG_RANDOMIZE_MEMORY
+extern unsigned long page_offset_base;
+
 void kernel_randomize_memory(void);
 #else
 static inline void kernel_randomize_memory(void) { }
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index d5c2f8b40faa..9215e0527647 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -1,6 +1,10 @@
 #ifndef _ASM_X86_PAGE_64_DEFS_H
 #define _ASM_X86_PAGE_64_DEFS_H
 
+#ifndef __ASSEMBLY__
+#include <asm/kaslr.h>
+#endif
+
 #ifdef CONFIG_KASAN
 #define KASAN_STACK_ORDER 1
 #else
@@ -32,7 +36,12 @@
  * hypervisor to fit.  Choosing 16 slots here is arbitrary, but it's
  * what Xen requires.
  */
-#define __PAGE_OFFSET           _AC(0xffff880000000000, UL)
+#define __PAGE_OFFSET_BASE      _AC(0xffff880000000000, UL)
+#ifdef CONFIG_RANDOMIZE_MEMORY
+#define __PAGE_OFFSET           page_offset_base
+#else
+#define __PAGE_OFFSET           __PAGE_OFFSET_BASE
+#endif /* CONFIG_RANDOMIZE_MEMORY */
 
 #define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
 
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 5df831ef1442..03a2aa067ff3 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -38,7 +38,7 @@
 
 #define pud_index(x)	(((x) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
 
-L4_PAGE_OFFSET = pgd_index(__PAGE_OFFSET)
+L4_PAGE_OFFSET = pgd_index(__PAGE_OFFSET_BASE)
 L4_START_KERNEL = pgd_index(__START_KERNEL_map)
 L3_START_KERNEL = pud_index(__START_KERNEL_map)
 
diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index d5380a48e8fb..609ecf2b37ed 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -43,8 +43,12 @@
  * before. You also need to add a BUILD_BUG_ON in kernel_randomize_memory to
  * ensure that this order is correct and won't be changed.
  */
-static const unsigned long vaddr_start;
-static const unsigned long vaddr_end;
+static const unsigned long vaddr_start = __PAGE_OFFSET_BASE;
+static const unsigned long vaddr_end = VMALLOC_START;
+
+/* Default values */
+unsigned long page_offset_base = __PAGE_OFFSET_BASE;
+EXPORT_SYMBOL(page_offset_base);
 
 /*
  * Memory regions randomized by KASLR (except modules that use a separate logic
@@ -55,6 +59,7 @@ static __initdata struct kaslr_memory_region {
 	unsigned long *base;
 	unsigned long size_tb;
 } kaslr_regions[] = {
+	{ &page_offset_base, 64/* Maximum */ },
 };
 
 /* Get size in bytes used by the memory region */
@@ -77,13 +82,20 @@ void __init kernel_randomize_memory(void)
 {
 	size_t i;
 	unsigned long vaddr = vaddr_start;
-	unsigned long rand;
+	unsigned long rand, memory_tb;
 	struct rnd_state rand_state;
 	unsigned long remain_entropy;
 
 	if (!kaslr_memory_enabled())
 		return;
 
+	BUG_ON(kaslr_regions[0].base != &page_offset_base);
+	memory_tb = ((max_pfn << PAGE_SHIFT) >> TB_SHIFT);
+
+	/* Adapt phyiscal memory region size based on available memory */
+	if (memory_tb < kaslr_regions[0].size_tb)
+		kaslr_regions[0].size_tb = memory_tb;
+
 	/* Calculate entropy available between regions */
 	remain_entropy = vaddr_end - vaddr_start;
 	for (i = 0; i < ARRAY_SIZE(kaslr_regions); i++)
-- 
2.7.4
