Reply-To: kernel-hardening@lists.openwall.com
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Date: Mon, 08 Aug 2016 15:31:31 +0200
Message-ID: <2206547.eDj3RJQyE5@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Subject: [kernel-hardening] [Resend][PATCH] x86/power/64: Always create temporary identity mapping correctly
To: Linux PM list <linux-pm@vger.kernel.org>, Thomas Garnier <thgarnie@google.com>, the arch/x86 maintainers <x86@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Pavel Machek <pavel@ucw.cz>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bpetkov@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The low-level resume-from-hibernation code on x86-64 uses
kernel_ident_mapping_init() to create the temoprary identity mapping,
but that function assumes that the offset between kernel virtual
addresses and physical addresses is aligned on the PGD level.

However, with a randomized identity mapping base, it may be aligned
on the PUD level and if that happens, the temporary identity mapping
created by set_up_temporary_mappings() will not reflect the actual
kernel identity mapping and the image restoration will fail as a
result (leading to a kernel panic most of the time).

To fix this problem, rework kernel_ident_mapping_init() to support
unaligned offsets between KVA and PA up to the PMD level and make
set_up_temporary_mappings() use it as approprtiate.

Reported-by: Thomas Garnier <thgarnie@google.com>
Suggested-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
---

This is sort of urgent, because hibernation doesn't work with KASLR on x86-64
in 4.8-rc1 AFAICS and this should make them work together again.

Unless anyone sees any problems with it, I'll queue it up for 4.8-rc2.

Thomas, would it be possible to test it with KASLR enabled, please?

Thanks,
Rafael

---
 arch/x86/include/asm/init.h   |    4 ++--
 arch/x86/mm/ident_map.c       |   19 +++++++++++--------
 arch/x86/power/hibernate_64.c |    2 +-
 3 files changed, 14 insertions(+), 11 deletions(-)

Index: linux-pm/arch/x86/include/asm/init.h
===================================================================
--- linux-pm.orig/arch/x86/include/asm/init.h
+++ linux-pm/arch/x86/include/asm/init.h
@@ -5,10 +5,10 @@ struct x86_mapping_info {
 	void *(*alloc_pgt_page)(void *); /* allocate buf for page table */
 	void *context;			 /* context for alloc_pgt_page */
 	unsigned long pmd_flag;		 /* page flag for PMD entry */
-	bool kernel_mapping;		 /* kernel mapping or ident mapping */
+	unsigned long offset;		 /* ident mapping offset */
 };
 
 int kernel_ident_mapping_init(struct x86_mapping_info *info, pgd_t *pgd_page,
-				unsigned long addr, unsigned long end);
+				unsigned long pstart, unsigned long pend);
 
 #endif /* _ASM_X86_INIT_H */
Index: linux-pm/arch/x86/mm/ident_map.c
===================================================================
--- linux-pm.orig/arch/x86/mm/ident_map.c
+++ linux-pm/arch/x86/mm/ident_map.c
@@ -3,15 +3,17 @@
  * included by both the compressed kernel and the regular kernel.
  */
 
-static void ident_pmd_init(unsigned long pmd_flag, pmd_t *pmd_page,
+static void ident_pmd_init(struct x86_mapping_info *info, pmd_t *pmd_page,
 			   unsigned long addr, unsigned long end)
 {
 	addr &= PMD_MASK;
 	for (; addr < end; addr += PMD_SIZE) {
 		pmd_t *pmd = pmd_page + pmd_index(addr);
 
-		if (!pmd_present(*pmd))
-			set_pmd(pmd, __pmd(addr | pmd_flag));
+		if (pmd_present(*pmd))
+			continue;
+
+		set_pmd(pmd, __pmd((addr - info->offset) | info->pmd_flag));
 	}
 }
 
@@ -30,13 +32,13 @@ static int ident_pud_init(struct x86_map
 
 		if (pud_present(*pud)) {
 			pmd = pmd_offset(pud, 0);
-			ident_pmd_init(info->pmd_flag, pmd, addr, next);
+			ident_pmd_init(info, pmd, addr, next);
 			continue;
 		}
 		pmd = (pmd_t *)info->alloc_pgt_page(info->context);
 		if (!pmd)
 			return -ENOMEM;
-		ident_pmd_init(info->pmd_flag, pmd, addr, next);
+		ident_pmd_init(info, pmd, addr, next);
 		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
 	}
 
@@ -44,14 +46,15 @@ static int ident_pud_init(struct x86_map
 }
 
 int kernel_ident_mapping_init(struct x86_mapping_info *info, pgd_t *pgd_page,
-			      unsigned long addr, unsigned long end)
+			      unsigned long pstart, unsigned long pend)
 {
+	unsigned long addr = pstart + info->offset;
+	unsigned long end = pend + info->offset;
 	unsigned long next;
 	int result;
-	int off = info->kernel_mapping ? pgd_index(__PAGE_OFFSET) : 0;
 
 	for (; addr < end; addr = next) {
-		pgd_t *pgd = pgd_page + pgd_index(addr) + off;
+		pgd_t *pgd = pgd_page + pgd_index(addr);
 		pud_t *pud;
 
 		next = (addr & PGDIR_MASK) + PGDIR_SIZE;
Index: linux-pm/arch/x86/power/hibernate_64.c
===================================================================
--- linux-pm.orig/arch/x86/power/hibernate_64.c
+++ linux-pm/arch/x86/power/hibernate_64.c
@@ -87,7 +87,7 @@ static int set_up_temporary_mappings(voi
 	struct x86_mapping_info info = {
 		.alloc_pgt_page	= alloc_pgt_page,
 		.pmd_flag	= __PAGE_KERNEL_LARGE_EXEC,
-		.kernel_mapping = true,
+		.offset		= __PAGE_OFFSET,
 	};
 	unsigned long mstart, mend;
 	pgd_t *pgd;
