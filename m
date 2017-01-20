From: Thomas Garnier <thgarnie@google.com>
Date: Fri, 20 Jan 2017 08:41:24 -0800
Message-Id: <20170120164126.27624-1-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v1 1/3] x86/mm: Adapt MODULES_END based on Fixmap section size
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Garnier <thgarnie@google.com>, Kees Cook <keescook@chromium.org>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, Brian Gerst <brgerst@gmail.com>, He Chen <he.chen@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>, Chen Yucong <slaoub@gmail.com>, Baoquan He <bhe@redhat.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, kvm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This patch aligns MODULES_END to the beginning of the Fixmap section.
It optimizes the space available for both sections. The address is
pre-computed based on the number of pages required by the Fixmap
section.

It will allow GDT remapping in the Fixmap section. The current
MODULES_END static address does not provide enough space for the kernel
to support a large number of processors.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
Based on next-20170119
---
 arch/x86/include/asm/fixmap.h           | 8 ++++++++
 arch/x86/include/asm/pgtable_64_types.h | 3 ---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 8554f960e21b..c46289799b02 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -132,6 +132,14 @@ enum fixed_addresses {
 
 extern void reserve_top_address(unsigned long reserve);
 
+/* On 64bit, the module sections ends with the start of the fixmap */
+#ifdef CONFIG_X86_64
+#define MODULES_VADDR    (__START_KERNEL_map + KERNEL_IMAGE_SIZE)
+#define MODULES_END   __fix_to_virt(__end_of_fixed_addresses + 1)
+#define MODULES_LEN   (MODULES_END - MODULES_VADDR)
+#endif /* CONFIG_X86_64 */
+
+
 #define FIXADDR_SIZE	(__end_of_permanent_fixed_addresses << PAGE_SHIFT)
 #define FIXADDR_START		(FIXADDR_TOP - FIXADDR_SIZE)
 
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 3a264200c62f..de8bace10200 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -66,9 +66,6 @@ typedef struct { pteval_t pte; } pte_t;
 #define VMEMMAP_START	__VMEMMAP_BASE
 #endif /* CONFIG_RANDOMIZE_MEMORY */
 #define VMALLOC_END	(VMALLOC_START + _AC((VMALLOC_SIZE_TB << 40) - 1, UL))
-#define MODULES_VADDR    (__START_KERNEL_map + KERNEL_IMAGE_SIZE)
-#define MODULES_END      _AC(0xffffffffff000000, UL)
-#define MODULES_LEN   (MODULES_END - MODULES_VADDR)
 #define ESPFIX_PGD_ENTRY _AC(-2, UL)
 #define ESPFIX_BASE_ADDR (ESPFIX_PGD_ENTRY << PGDIR_SHIFT)
 #define EFI_VA_START	 ( -4 * (_AC(1, UL) << 30))
-- 
2.11.0.483.g087da7b7c-goog
