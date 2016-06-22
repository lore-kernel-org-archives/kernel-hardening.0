Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue, 21 Jun 2016 17:47:00 -0700
Message-Id: <1466556426-32664-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1466556426-32664-1-git-send-email-keescook@chromium.org>
References: <1466556426-32664-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v7 3/9] x86/mm: PUD VA support for physical mapping (x86_64)
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Andy Lutomirski <luto@kernel.org>, x86@kernel.org, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Juergen Gross <jgross@suse.com>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Dave Young <dyoung@redhat.com>, Joerg Roedel <jroedel@suse.de>, Lv Zheng <lv.zheng@intel.com>, Mark Salter <msalter@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, Stephen Smalley <sds@tycho.nsa.gov>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Jan Beulich <JBeulich@suse.com>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Thomas Garnier <thgarnie@google.com>

Minor change that allows early boot physical mapping of PUD level virtual
addresses. The current implementation expects the virtual address to be
PUD aligned. For KASLR memory randomization, we need to be able to
randomize the offset used on the PUD table.

It has no impact on current usage.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/mm/init_64.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 6714712bd5da..7bf1ddb54537 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -465,7 +465,8 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long paddr, unsigned long paddr_end,
 
 /*
  * Create PUD level page table mapping for physical addresses. The virtual
- * and physical address have to be aligned at this level.
+ * and physical address do not have to be aligned at this level. KASLR can
+ * randomize virtual addresses up to this level.
  * It returns the last physical address mapped.
  */
 static unsigned long __meminit
@@ -474,14 +475,18 @@ phys_pud_init(pud_t *pud_page, unsigned long paddr, unsigned long paddr_end,
 {
 	unsigned long pages = 0, paddr_next;
 	unsigned long paddr_last = paddr_end;
-	int i = pud_index(paddr);
+	unsigned long vaddr = (unsigned long)__va(paddr);
+	int i = pud_index(vaddr);
 
 	for (; i < PTRS_PER_PUD; i++, paddr = paddr_next) {
-		pud_t *pud = pud_page + pud_index(paddr);
+		pud_t *pud;
 		pmd_t *pmd;
 		pgprot_t prot = PAGE_KERNEL;
 
+		vaddr = (unsigned long)__va(paddr);
+		pud = pud_page + pud_index(vaddr);
 		paddr_next = (paddr & PUD_MASK) + PUD_SIZE;
+
 		if (paddr >= paddr_end) {
 			if (!after_bootmem &&
 			    !e820_any_mapped(paddr & PUD_MASK, paddr_next,
@@ -551,7 +556,7 @@ phys_pud_init(pud_t *pud_page, unsigned long paddr, unsigned long paddr_end,
 
 /*
  * Create page table mapping for the physical memory for specific physical
- * addresses. The virtual and physical addresses have to be aligned on PUD level
+ * addresses. The virtual and physical addresses have to be aligned on PMD level
  * down. It returns the last physical address mapped.
  */
 unsigned long __meminit
-- 
2.7.4
