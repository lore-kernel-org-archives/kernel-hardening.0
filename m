Reply-To: kernel-hardening@lists.openwall.com
From: Yinghai Lu <yinghai@kernel.org>
Date: Wed,  3 Aug 2016 11:23:08 -0700
Message-Id: <20160803182308.19227-1-yinghai@kernel.org>
In-Reply-To: <CAE9FiQVtD+eBoHEeNWGUnNAtJkDCEsq2JLg0RC9grSG7Eje3tQ@mail.gmail.com>
References: <1470071280-78706-1-git-send-email-thgarnie@google.com> <1470071280-78706-2-git-send-email-thgarnie@google.com> <CAE9FiQXPnXa_Ep2nk+y5boZ9Csdk_yoH5Ws8SaExn0-VHU9bBg@mail.gmail.com> <CAJcbSZE1kPpL_hWLK70fGhgjP3xRBaZ=r32E9q1SBwhCbqOp5Q@mail.gmail.com> <CAE9FiQVtD+eBoHEeNWGUnNAtJkDCEsq2JLg0RC9grSG7Eje3tQ@mail.gmail.com>
Subject: [kernel-hardening] [PATCH v2] x86/power/64: Support unaligned addresses for temporary mapping
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>
Cc: the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, kernel-hardening@lists.openwall.com, Thomas Garnier <thgarnie@google.com>, Yinghai Lu <yinghai@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Thomas Garnier <thgarnie@google.com>

Correctly setup the temporary mapping for hibernation. Previous
implementation assumed the offset between KVA and PA was aligned on the PGD level.
With KASLR memory randomization enabled, the offset is randomized on the PUD
level. This change supports unaligned up to PMD.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
[yinghai: change loop to virtual address]
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/ident_map.c |   54 ++++++++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 22 deletions(-)

Index: linux-2.6/arch/x86/mm/ident_map.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/ident_map.c
+++ linux-2.6/arch/x86/mm/ident_map.c
@@ -3,40 +3,47 @@
  * included by both the compressed kernel and the regular kernel.
  */
 
-static void ident_pmd_init(unsigned long pmd_flag, pmd_t *pmd_page,
+static void ident_pmd_init(struct x86_mapping_info *info, pmd_t *pmd_page,
 			   unsigned long addr, unsigned long end)
 {
-	addr &= PMD_MASK;
-	for (; addr < end; addr += PMD_SIZE) {
-		pmd_t *pmd = pmd_page + pmd_index(addr);
+	unsigned long off = info->kernel_mapping ? __PAGE_OFFSET : 0;
+	unsigned long vaddr = addr + off;
+	unsigned long vend = end + off;
+
+	vaddr &= PMD_MASK;
+	for (; vaddr < vend; vaddr += PMD_SIZE) {
+		pmd_t *pmd = pmd_page + pmd_index(vaddr);
 
 		if (!pmd_present(*pmd))
-			set_pmd(pmd, __pmd(addr | pmd_flag));
+			set_pmd(pmd, __pmd((vaddr - off) | info->pmd_flag));
 	}
 }
 
 static int ident_pud_init(struct x86_mapping_info *info, pud_t *pud_page,
 			  unsigned long addr, unsigned long end)
 {
-	unsigned long next;
+	unsigned long off = info->kernel_mapping ? __PAGE_OFFSET : 0;
+	unsigned long vaddr = addr + off;
+	unsigned long vend = end + off;
+	unsigned long vnext;
 
-	for (; addr < end; addr = next) {
-		pud_t *pud = pud_page + pud_index(addr);
+	for (; vaddr < vend; vaddr = vnext) {
+		pud_t *pud = pud_page + pud_index(vaddr);
 		pmd_t *pmd;
 
-		next = (addr & PUD_MASK) + PUD_SIZE;
-		if (next > end)
-			next = end;
+		vnext = (vaddr & PUD_MASK) + PUD_SIZE;
+		if (vnext > vend)
+			vnext = vend;
 
 		if (pud_present(*pud)) {
 			pmd = pmd_offset(pud, 0);
-			ident_pmd_init(info->pmd_flag, pmd, addr, next);
+			ident_pmd_init(info, pmd, vaddr - off, vnext - off);
 			continue;
 		}
 		pmd = (pmd_t *)info->alloc_pgt_page(info->context);
 		if (!pmd)
 			return -ENOMEM;
-		ident_pmd_init(info->pmd_flag, pmd, addr, next);
+		ident_pmd_init(info, pmd, vaddr - off, vnext - off);
 		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
 	}
 
@@ -46,21 +53,24 @@ static int ident_pud_init(struct x86_map
 int kernel_ident_mapping_init(struct x86_mapping_info *info, pgd_t *pgd_page,
 			      unsigned long addr, unsigned long end)
 {
-	unsigned long next;
 	int result;
-	int off = info->kernel_mapping ? pgd_index(__PAGE_OFFSET) : 0;
+	unsigned long off = info->kernel_mapping ? __PAGE_OFFSET : 0;
+	unsigned long vaddr = addr + off;
+	unsigned long vend = end + off;
+	unsigned long vnext;
 
-	for (; addr < end; addr = next) {
-		pgd_t *pgd = pgd_page + pgd_index(addr) + off;
+	for (; vaddr < vend; vaddr = vnext) {
+		pgd_t *pgd = pgd_page + pgd_index(vaddr);
 		pud_t *pud;
 
-		next = (addr & PGDIR_MASK) + PGDIR_SIZE;
-		if (next > end)
-			next = end;
+		vnext = (vaddr & PGDIR_MASK) + PGDIR_SIZE;
+		if (vnext > vend)
+			vnext = vend;
 
 		if (pgd_present(*pgd)) {
 			pud = pud_offset(pgd, 0);
-			result = ident_pud_init(info, pud, addr, next);
+			result = ident_pud_init(info, pud, vaddr - off,
+						vnext - off);
 			if (result)
 				return result;
 			continue;
@@ -69,7 +79,7 @@ int kernel_ident_mapping_init(struct x86
 		pud = (pud_t *)info->alloc_pgt_page(info->context);
 		if (!pud)
 			return -ENOMEM;
-		result = ident_pud_init(info, pud, addr, next);
+		result = ident_pud_init(info, pud, vaddr - off, vnext - off);
 		if (result)
 			return result;
 		set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
