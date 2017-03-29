From: Kees Cook <keescook@chromium.org>
Date: Wed, 29 Mar 2017 11:15:57 -0700
Message-Id: <1490811363-93944-6-git-send-email-keescook@chromium.org>
In-Reply-To: <1490811363-93944-1-git-send-email-keescook@chromium.org>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [RFC v2][PATCH 05/11] ARM: mm: dump: Add domain to output
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

This adds the memory domain (on non-LPAE) to the PMD and PTE dumps. This
isn't in the regular PMD bits because I couldn't find a clean way to
fall back to retain some of the PMD bits when reporting PTE. So this is
special-cased currently.

New output example:

  ---[ Modules ]---
  0x7f000000-0x7f001000       4K KERNEL      ro x  SHD MEM/CACHED/WBWA
  0x7f001000-0x7f002000       4K KERNEL      ro NX SHD MEM/CACHED/WBWA
  0x7f002000-0x7f004000       8K KERNEL      RW NX SHD MEM/CACHED/WBWA
  ---[ Kernel Mapping ]---
  0x80000000-0x80100000       1M KERNEL      RW NX SHD
  0x80100000-0x80800000       7M KERNEL      ro x  SHD
  0x80800000-0x80b00000       3M KERNEL      ro NX SHD
  0x80b00000-0xa0000000     501M KERNEL      RW NX SHD
  ...
  ---[ Vectors ]---
  0xffff0000-0xffff1000       4K VECTORS USR ro x  SHD MEM/CACHED/WBWA
  0xffff1000-0xffff2000       4K VECTORS     ro x  SHD MEM/CACHED/WBWA

Signed-off-by: Kees Cook <keescook@chromium.org>
---
This patch is already queued in the ARM tree, but I'm including it here too
since a following patch updates the list of domain names from this patch...
---
 arch/arm/mm/dump.c | 54 ++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
index 21192d6eda40..35ff45470dbf 100644
--- a/arch/arm/mm/dump.c
+++ b/arch/arm/mm/dump.c
@@ -17,6 +17,7 @@
 #include <linux/mm.h>
 #include <linux/seq_file.h>
 
+#include <asm/domain.h>
 #include <asm/fixmap.h>
 #include <asm/memory.h>
 #include <asm/pgtable.h>
@@ -43,6 +44,7 @@ struct pg_state {
 	unsigned long start_address;
 	unsigned level;
 	u64 current_prot;
+	const char *current_domain;
 };
 
 struct prot_bits {
@@ -216,7 +218,8 @@ static void dump_prot(struct pg_state *st, const struct prot_bits *bits, size_t
 	}
 }
 
-static void note_page(struct pg_state *st, unsigned long addr, unsigned level, u64 val)
+static void note_page(struct pg_state *st, unsigned long addr,
+		      unsigned int level, u64 val, const char *domain)
 {
 	static const char units[] = "KMGTPE";
 	u64 prot = val & pg_level[level].mask;
@@ -224,8 +227,10 @@ static void note_page(struct pg_state *st, unsigned long addr, unsigned level, u
 	if (!st->level) {
 		st->level = level;
 		st->current_prot = prot;
+		st->current_domain = domain;
 		seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
 	} else if (prot != st->current_prot || level != st->level ||
+		   domain != st->current_domain ||
 		   addr >= st->marker[1].start_address) {
 		const char *unit = units;
 		unsigned long delta;
@@ -240,6 +245,8 @@ static void note_page(struct pg_state *st, unsigned long addr, unsigned level, u
 				unit++;
 			}
 			seq_printf(st->seq, "%9lu%c", delta, *unit);
+			if (st->current_domain)
+				seq_printf(st->seq, " %s", st->current_domain);
 			if (pg_level[st->level].bits)
 				dump_prot(st, pg_level[st->level].bits, pg_level[st->level].num);
 			seq_printf(st->seq, "\n");
@@ -251,11 +258,13 @@ static void note_page(struct pg_state *st, unsigned long addr, unsigned level, u
 		}
 		st->start_address = addr;
 		st->current_prot = prot;
+		st->current_domain = domain;
 		st->level = level;
 	}
 }
 
-static void walk_pte(struct pg_state *st, pmd_t *pmd, unsigned long start)
+static void walk_pte(struct pg_state *st, pmd_t *pmd, unsigned long start,
+		     const char *domain)
 {
 	pte_t *pte = pte_offset_kernel(pmd, 0);
 	unsigned long addr;
@@ -263,25 +272,50 @@ static void walk_pte(struct pg_state *st, pmd_t *pmd, unsigned long start)
 
 	for (i = 0; i < PTRS_PER_PTE; i++, pte++) {
 		addr = start + i * PAGE_SIZE;
-		note_page(st, addr, 4, pte_val(*pte));
+		note_page(st, addr, 4, pte_val(*pte), domain);
 	}
 }
 
+static const char *get_domain_name(pmd_t *pmd)
+{
+#ifndef CONFIG_ARM_LPAE
+	switch (pmd_val(*pmd) & PMD_DOMAIN_MASK) {
+	case PMD_DOMAIN(DOMAIN_KERNEL):
+		return "KERNEL ";
+	case PMD_DOMAIN(DOMAIN_USER):
+		return "USER   ";
+	case PMD_DOMAIN(DOMAIN_IO):
+		return "IO     ";
+	case PMD_DOMAIN(DOMAIN_VECTORS):
+		return "VECTORS";
+	default:
+		return "unknown";
+	}
+#endif
+	return NULL;
+}
+
 static void walk_pmd(struct pg_state *st, pud_t *pud, unsigned long start)
 {
 	pmd_t *pmd = pmd_offset(pud, 0);
 	unsigned long addr;
 	unsigned i;
+	const char *domain;
 
 	for (i = 0; i < PTRS_PER_PMD; i++, pmd++) {
 		addr = start + i * PMD_SIZE;
+		domain = get_domain_name(pmd);
 		if (pmd_none(*pmd) || pmd_large(*pmd) || !pmd_present(*pmd))
-			note_page(st, addr, 3, pmd_val(*pmd));
+			note_page(st, addr, 3, pmd_val(*pmd), domain);
 		else
-			walk_pte(st, pmd, addr);
+			walk_pte(st, pmd, addr, domain);
 
-		if (SECTION_SIZE < PMD_SIZE && pmd_large(pmd[1]))
-			note_page(st, addr + SECTION_SIZE, 3, pmd_val(pmd[1]));
+		if (SECTION_SIZE < PMD_SIZE && pmd_large(pmd[1])) {
+			addr += SECTION_SIZE;
+			pmd++;
+			domain = get_domain_name(pmd);
+			note_page(st, addr, 3, pmd_val(*pmd), domain);
+		}
 	}
 }
 
@@ -296,7 +330,7 @@ static void walk_pud(struct pg_state *st, pgd_t *pgd, unsigned long start)
 		if (!pud_none(*pud)) {
 			walk_pmd(st, pud, addr);
 		} else {
-			note_page(st, addr, 2, pud_val(*pud));
+			note_page(st, addr, 2, pud_val(*pud), NULL);
 		}
 	}
 }
@@ -317,11 +351,11 @@ static void walk_pgd(struct seq_file *m)
 		if (!pgd_none(*pgd)) {
 			walk_pud(&st, pgd, addr);
 		} else {
-			note_page(&st, addr, 1, pgd_val(*pgd));
+			note_page(&st, addr, 1, pgd_val(*pgd), NULL);
 		}
 	}
 
-	note_page(&st, 0, 0, 0);
+	note_page(&st, 0, 0, 0, NULL);
 }
 
 static int ptdump_show(struct seq_file *m, void *v)
-- 
2.7.4
