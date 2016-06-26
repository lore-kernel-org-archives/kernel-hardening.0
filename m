Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Sun, 26 Jun 2016 14:55:27 -0700
Message-Id: <f49fbe4a40e1630981614b910fbfbcaa387e6c8f.1466974736.git.luto@kernel.org>
In-Reply-To: <cover.1466974736.git.luto@kernel.org>
References: <cover.1466974736.git.luto@kernel.org>
In-Reply-To: <cover.1466974736.git.luto@kernel.org>
References: <cover.1466974736.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v4 05/29] x86/mm: Remove kernel_unmap_pages_in_pgd() and efi_cleanup_page_tables()
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, linux-efi@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

kernel_unmap_pages_in_pgd() is dangerous: if a pgd entry in
init_mm.pgd were to be cleared, callers would need to ensure that
the pgd entry hadn't been propagated to any other pgd.

Its only caller was efi_cleanup_page_tables(), and that, in turn,
was unused, so just delete both functions.  This leaves a couple of
other helpers unused, so delete them, too.

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-efi@vger.kernel.org
Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/include/asm/efi.h           |  1 -
 arch/x86/include/asm/pgtable_types.h |  2 --
 arch/x86/mm/pageattr.c               | 28 ----------------------------
 arch/x86/platform/efi/efi.c          |  2 --
 arch/x86/platform/efi/efi_32.c       |  3 ---
 arch/x86/platform/efi/efi_64.c       |  5 -----
 6 files changed, 41 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 78d1e7467eae..45ea38df86d4 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -125,7 +125,6 @@ extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
 extern void efi_sync_low_kernel_mappings(void);
 extern int __init efi_alloc_page_tables(void);
 extern int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages);
-extern void __init efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages);
 extern void __init old_map_region(efi_memory_desc_t *md);
 extern void __init runtime_code_page_mkexec(void);
 extern void __init efi_runtime_update_mappings(void);
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 7b5efe264eff..0b9f58ad10c8 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -475,8 +475,6 @@ extern pmd_t *lookup_pmd_address(unsigned long address);
 extern phys_addr_t slow_virt_to_phys(void *__address);
 extern int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 				   unsigned numpages, unsigned long page_flags);
-void kernel_unmap_pages_in_pgd(pgd_t *root, unsigned long address,
-			       unsigned numpages);
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* _ASM_X86_PGTABLE_DEFS_H */
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 6a8026918bf6..762162af3662 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -746,18 +746,6 @@ static bool try_to_free_pmd_page(pmd_t *pmd)
 	return true;
 }
 
-static bool try_to_free_pud_page(pud_t *pud)
-{
-	int i;
-
-	for (i = 0; i < PTRS_PER_PUD; i++)
-		if (!pud_none(pud[i]))
-			return false;
-
-	free_page((unsigned long)pud);
-	return true;
-}
-
 static bool unmap_pte_range(pmd_t *pmd, unsigned long start, unsigned long end)
 {
 	pte_t *pte = pte_offset_kernel(pmd, start);
@@ -871,16 +859,6 @@ static void unmap_pud_range(pgd_t *pgd, unsigned long start, unsigned long end)
 	 */
 }
 
-static void unmap_pgd_range(pgd_t *root, unsigned long addr, unsigned long end)
-{
-	pgd_t *pgd_entry = root + pgd_index(addr);
-
-	unmap_pud_range(pgd_entry, addr, end);
-
-	if (try_to_free_pud_page((pud_t *)pgd_page_vaddr(*pgd_entry)))
-		pgd_clear(pgd_entry);
-}
-
 static int alloc_pte_page(pmd_t *pmd)
 {
 	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
@@ -1993,12 +1971,6 @@ out:
 	return retval;
 }
 
-void kernel_unmap_pages_in_pgd(pgd_t *root, unsigned long address,
-			       unsigned numpages)
-{
-	unmap_pgd_range(root, address, address + (numpages << PAGE_SHIFT));
-}
-
 /*
  * The testcases use internal knowledge of the implementation that shouldn't
  * be exposed to the rest of the kernel. Include these directly here.
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index f93545e7dc54..62986e5fbdba 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -978,8 +978,6 @@ static void __init __efi_enter_virtual_mode(void)
 	 * EFI mixed mode we need all of memory to be accessible when
 	 * we pass parameters to the EFI runtime services in the
 	 * thunking code.
-	 *
-	 * efi_cleanup_page_tables(__pa(new_memmap), 1 << pg_shift);
 	 */
 	free_pages((unsigned long)new_memmap, pg_shift);
 
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 338402b91d2e..cef39b097649 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -49,9 +49,6 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 {
 	return 0;
 }
-void __init efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages)
-{
-}
 
 void __init efi_map_region(efi_memory_desc_t *md)
 {
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index b226b3f497f1..d288dcea1ffe 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -285,11 +285,6 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	return 0;
 }
 
-void __init efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages)
-{
-	kernel_unmap_pages_in_pgd(efi_pgd, pa_memmap, num_pages);
-}
-
 static void __init __map_region(efi_memory_desc_t *md, u64 va)
 {
 	unsigned long flags = _PAGE_RW;
-- 
2.7.4
