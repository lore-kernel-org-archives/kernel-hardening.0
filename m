From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 26 Jan 2017 08:59:38 -0800
Message-Id: <20170126165940.30799-1-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v2 1/3] x86/mm: Adapt MODULES_END based on Fixmap section size
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Thomas Garnier <thgarnie@google.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@amacapital.net>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Rusty Russell <rusty@rustcorp.com.au>, Christian Borntraeger <borntraeger@de.ibm.com>, Fenghua Yu <fenghua.yu@intel.com>, He Chen <he.chen@linux.intel.com>, Brian Gerst <brgerst@gmail.com>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Adam Buchbinder <adam.buchbinder@gmail.com>, Stanislaw Gruszka <sgruszka@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Dave Hansen <dave.hansen@intel.com>, Chen Yucong <slaoub@gmail.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, David Vrabel <david.vrabel@citrix.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Tim Chen <tim.c.chen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Prarit Bhargava <prarit@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>, Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-pm@vger.kernel.org, linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, lguest@lists.ozlabs.org, kvm@vger.kernel.org, kernel-hardening@lists.openwall.com
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
Based on next-20170125
---
 arch/x86/include/asm/fixmap.h           | 8 ++++++++
 arch/x86/include/asm/pgtable_64_types.h | 3 ---
 arch/x86/kernel/module.c                | 1 +
 arch/x86/mm/dump_pagetables.c           | 1 +
 arch/x86/mm/kasan_init_64.c             | 1 +
 5 files changed, 11 insertions(+), 3 deletions(-)

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
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 477ae806c2fa..fad61caac75e 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -35,6 +35,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/setup.h>
+#include <asm/fixmap.h>
 
 #if 0
 #define DEBUGP(fmt, ...)				\
diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index ea9c49adaa1f..eefd6d015d02 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -18,6 +18,7 @@
 #include <linux/seq_file.h>
 
 #include <asm/pgtable.h>
+#include <asm/fixmap.h>
 
 /*
  * The dumper groups pagetable entries of the same type into one, and for
diff --git a/arch/x86/mm/kasan_init_64.c b/arch/x86/mm/kasan_init_64.c
index 0493c17b8a51..34f167cf3316 100644
--- a/arch/x86/mm/kasan_init_64.c
+++ b/arch/x86/mm/kasan_init_64.c
@@ -8,6 +8,7 @@
 
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
+#include <asm/fixmap.h>
 
 extern pgd_t early_level4_pgt[PTRS_PER_PGD];
 extern struct range pfn_mapped[E820_X_MAX];
-- 
2.11.0.483.g087da7b7c-goog
