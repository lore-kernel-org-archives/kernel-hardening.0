Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Fri, 12 Apr 2013 13:13:43 -0700
Message-Id: <1365797627-20874-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1365797627-20874-1-git-send-email-keescook@chromium.org>
References: <1365797627-20874-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 2/6] x86: relocs: consolidate processing logic
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Instead of counting and then processing relocations, do it in a single
pass. This splits the processing logic into separate functions for
realmode and 32-bit (and paves the way for 64-bit). Also extracts helper
functions when emitting relocations.

Based on work by Neill Clift and Michael Davidson.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/tools/relocs.c |  304 ++++++++++++++++++++++++++---------------------
 1 file changed, 170 insertions(+), 134 deletions(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index fd28ef7..bdc5930 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -2,6 +2,7 @@
 #include <stdarg.h>
 #include <stdlib.h>
 #include <stdint.h>
+#include <inttypes.h>
 #include <string.h>
 #include <errno.h>
 #include <unistd.h>
@@ -38,10 +39,15 @@ static void die(char *fmt, ...);
 
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 static Elf_Ehdr ehdr;
-static unsigned long reloc_count, reloc_idx;
-static unsigned long *relocs;
-static unsigned long reloc16_count, reloc16_idx;
-static unsigned long *relocs16;
+
+struct relocs {
+	uint32_t	*offset;
+	unsigned long	count;
+	unsigned long	size;
+};
+
+static struct relocs relocs16;
+static struct relocs relocs32;
 
 struct section {
 	Elf_Shdr       shdr;
@@ -583,8 +589,23 @@ static void print_absolute_relocs(void)
 		printf("\n");
 }
 
-static void walk_relocs(void (*visit)(Elf_Rel *rel, Elf_Sym *sym),
-			int use_real_mode)
+static void add_reloc(struct relocs *r, uint32_t offset)
+{
+	if (r->count == r->size) {
+		unsigned long newsize = r->size + 50000;
+		void *mem = realloc(r->offset, newsize * sizeof(r->offset[0]));
+
+		if (!mem)
+			die("realloc of %ld entries for relocs failed\n",
+                                newsize);
+		r->offset = mem;
+		r->size = newsize;
+	}
+	r->offset[r->count++] = offset;
+}
+
+static void walk_relocs(int (*process)(struct section *sec, Elf_Rel *rel,
+			Elf_Sym *sym, const char *symname))
 {
 	int i;
 	/* Walk through the relocations */
@@ -606,100 +627,142 @@ static void walk_relocs(void (*visit)(Elf_Rel *rel, Elf_Sym *sym),
 		sh_symtab = sec_symtab->symtab;
 		sym_strtab = sec_symtab->link->strtab;
 		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf_Rel); j++) {
-			Elf_Rel *rel;
-			Elf_Sym *sym;
-			unsigned r_type;
-			const char *symname;
-			int shn_abs;
+			Elf_Rel *rel = &sec->reltab[j];
+			Elf_Sym *sym = &sh_symtab[ELF_R_SYM(rel->r_info)];
+			const char *symname = sym_name(sym_strtab, sym);
 
-			rel = &sec->reltab[j];
-			sym = &sh_symtab[ELF_R_SYM(rel->r_info)];
-			r_type = ELF_R_TYPE(rel->r_info);
-
-			shn_abs = sym->st_shndx == SHN_ABS;
-
-			switch (r_type) {
-			case R_386_NONE:
-			case R_386_PC32:
-			case R_386_PC16:
-			case R_386_PC8:
-				/*
-				 * NONE can be ignored and and PC relative
-				 * relocations don't need to be adjusted.
-				 */
+			process(sec, rel, sym, symname);
+		}
+	}
+}
+
+static int do_reloc(struct section *sec, Elf_Rel *rel, Elf_Sym *sym,
+		    const char *symname)
+{
+	unsigned r_type = ELF32_R_TYPE(rel->r_info);
+	int shn_abs = (sym->st_shndx == SHN_ABS) && !is_reloc(S_REL, symname);
+
+	switch (r_type) {
+	case R_386_NONE:
+	case R_386_PC32:
+	case R_386_PC16:
+	case R_386_PC8:
+		/*
+		 * NONE can be ignored and PC relative relocations don't
+		 * need to be adjusted.
+		 */
+		break;
+
+	case R_386_32:
+		if (shn_abs) {
+			/*
+			 * Whitelisted absolute symbols do not require
+			 * relocation.
+			 */
+			if (is_reloc(S_ABS, symname))
 				break;
 
-			case R_386_16:
-				symname = sym_name(sym_strtab, sym);
-				if (!use_real_mode)
-					goto bad;
-				if (shn_abs) {
-					if (is_reloc(S_ABS, symname))
-						break;
-					else if (!is_reloc(S_SEG, symname))
-						goto bad;
-				} else {
-					if (is_reloc(S_LIN, symname))
-						goto bad;
-					else
-						break;
-				}
-				visit(rel, sym);
+			die("Invalid absolute %s relocation: %s\n",
+			    rel_type(r_type), symname);
+			break;
+		}
+
+		add_reloc(&relocs32, rel->r_offset);
+		break;
+
+	default:
+		die("Unsupported relocation type: %s (%d)\n",
+		    rel_type(r_type), r_type);
+		break;
+	}
+
+	return 0;
+}
+
+static int do_reloc_real(struct section *sec, Elf_Rel *rel, Elf_Sym *sym,
+			 const char *symname)
+{
+	unsigned r_type = ELF32_R_TYPE(rel->r_info);
+	int shn_abs = (sym->st_shndx == SHN_ABS) && !is_reloc(S_REL, symname);
+
+	switch (r_type) {
+	case R_386_NONE:
+	case R_386_PC32:
+	case R_386_PC16:
+	case R_386_PC8:
+		/*
+		 * NONE can be ignored and PC relative relocations don't
+		 * need to be adjusted.
+		 */
+		break;
+
+	case R_386_16:
+		if (shn_abs) {
+			/*
+			 * Whitelisted absolute symbols do not require
+			 * relocation.
+			 */
+			if (is_reloc(S_ABS, symname))
 				break;
 
-			case R_386_32:
-				symname = sym_name(sym_strtab, sym);
-				if (shn_abs) {
-					if (is_reloc(S_ABS, symname))
-						break;
-					else if (!is_reloc(S_REL, symname))
-						goto bad;
-				} else {
-					if (use_real_mode &&
-					    !is_reloc(S_LIN, symname))
-						break;
-				}
-				visit(rel, sym);
+			if (is_reloc(S_SEG, symname)) {
+				add_reloc(&relocs16, rel->r_offset);
+				break;
+			}
+		} else {
+			if (!is_reloc(S_LIN, symname))
 				break;
-			default:
-				die("Unsupported relocation type: %s (%d)\n",
-				    rel_type(r_type), r_type);
+		}
+		die("Invalid %s %s relocation: %s\n",
+		    shn_abs ? "absolute" : "relative",
+		    rel_type(r_type), symname);
+		break;
+
+	case R_386_32:
+		if (shn_abs) {
+			/*
+			 * Whitelisted absolute symbols do not require
+			 * relocation.
+			 */
+			if (is_reloc(S_ABS, symname))
+				break;
+
+			if (is_reloc(S_REL, symname)) {
+				add_reloc(&relocs32, rel->r_offset);
 				break;
-			bad:
-				symname = sym_name(sym_strtab, sym);
-				die("Invalid %s %s relocation: %s\n",
-				    shn_abs ? "absolute" : "relative",
-				    rel_type(r_type), symname);
 			}
+		} else {
+			if (is_reloc(S_LIN, symname))
+				add_reloc(&relocs32, rel->r_offset);
+			break;
 		}
-	}
-}
+		die("Invalid %s %s relocation: %s\n",
+		    shn_abs ? "absolute" : "relative",
+		    rel_type(r_type), symname);
+		break;
 
-static void count_reloc(Elf_Rel *rel, Elf_Sym *sym)
-{
-	if (ELF_R_TYPE(rel->r_info) == R_386_16)
-		reloc16_count++;
-	else
-		reloc_count++;
-}
+	default:
+		die("Unsupported relocation type: %s (%d)\n",
+		    rel_type(r_type), r_type);
+		break;
+	}
 
-static void collect_reloc(Elf_Rel *rel, Elf_Sym *sym)
-{
-	/* Remember the address that needs to be adjusted. */
-	if (ELF_R_TYPE(rel->r_info) == R_386_16)
-		relocs16[reloc16_idx++] = rel->r_offset;
-	else
-		relocs[reloc_idx++] = rel->r_offset;
+	return 0;
 }
 
 static int cmp_relocs(const void *va, const void *vb)
 {
-	const unsigned long *a, *b;
+	const uint32_t *a, *b;
 	a = va; b = vb;
 	return (*a == *b)? 0 : (*a > *b)? 1 : -1;
 }
 
-static int write32(unsigned int v, FILE *f)
+static void sort_relocs(struct relocs *r)
+{
+	qsort(r->offset, r->count, sizeof(r->offset[0]), cmp_relocs);
+}
+
+static int write32(uint32_t v, FILE *f)
 {
 	unsigned char buf[4];
 
@@ -707,33 +770,25 @@ static int write32(unsigned int v, FILE *f)
 	return fwrite(buf, 1, 4, f) == 4 ? 0 : -1;
 }
 
+static int write32_as_text(uint32_t v, FILE *f)
+{
+	return fprintf(f, "\t.long 0x%08"PRIx32"\n", v) > 0 ? 0 : -1;
+}
+
 static void emit_relocs(int as_text, int use_real_mode)
 {
 	int i;
-	/* Count how many relocations I have and allocate space for them. */
-	reloc_count = 0;
-	walk_relocs(count_reloc, use_real_mode);
-	relocs = malloc(reloc_count * sizeof(relocs[0]));
-	if (!relocs) {
-		die("malloc of %d entries for relocs failed\n",
-			reloc_count);
-	}
+	int (*write_reloc)(uint32_t, FILE *) = write32;
 
-	relocs16 = malloc(reloc16_count * sizeof(relocs[0]));
-	if (!relocs16) {
-		die("malloc of %d entries for relocs16 failed\n",
-			reloc16_count);
-	}
 	/* Collect up the relocations */
-	reloc_idx = 0;
-	walk_relocs(collect_reloc, use_real_mode);
+	walk_relocs(use_real_mode ? do_reloc_real : do_reloc);
 
-	if (reloc16_count && !use_real_mode)
+	if (relocs16.count && !use_real_mode)
 		die("Segment relocations found but --realmode not specified\n");
 
 	/* Order the relocations for more efficient processing */
-	qsort(relocs, reloc_count, sizeof(relocs[0]), cmp_relocs);
-	qsort(relocs16, reloc16_count, sizeof(relocs16[0]), cmp_relocs);
+	sort_relocs(&relocs16);
+	sort_relocs(&relocs32);
 
 	/* Print the relocations */
 	if (as_text) {
@@ -742,43 +797,24 @@ static void emit_relocs(int as_text, int use_real_mode)
 		 */
 		printf(".section \".data.reloc\",\"a\"\n");
 		printf(".balign 4\n");
-		if (use_real_mode) {
-			printf("\t.long %lu\n", reloc16_count);
-			for (i = 0; i < reloc16_count; i++)
-				printf("\t.long 0x%08lx\n", relocs16[i]);
-			printf("\t.long %lu\n", reloc_count);
-			for (i = 0; i < reloc_count; i++) {
-				printf("\t.long 0x%08lx\n", relocs[i]);
-			}
-		} else {
-			/* Print a stop */
-			printf("\t.long 0x%08lx\n", (unsigned long)0);
-			for (i = 0; i < reloc_count; i++) {
-				printf("\t.long 0x%08lx\n", relocs[i]);
-			}
-		}
-
-		printf("\n");
+		write_reloc = write32_as_text;
 	}
-	else {
-		if (use_real_mode) {
-			write32(reloc16_count, stdout);
-			for (i = 0; i < reloc16_count; i++)
-				write32(relocs16[i], stdout);
-			write32(reloc_count, stdout);
-
-			/* Now print each relocation */
-			for (i = 0; i < reloc_count; i++)
-				write32(relocs[i], stdout);
-		} else {
-			/* Print a stop */
-			write32(0, stdout);
 
-			/* Now print each relocation */
-			for (i = 0; i < reloc_count; i++) {
-				write32(relocs[i], stdout);
-			}
-		}
+	if (use_real_mode) {
+		write_reloc(relocs16.count, stdout);
+		for (i = 0; i < relocs16.count; i++)
+			write_reloc(relocs16.offset[i], stdout);
+
+		write_reloc(relocs32.count, stdout);
+		for (i = 0; i < relocs32.count; i++)
+			write_reloc(relocs32.offset[i], stdout);
+	} else {
+		/* Print a stop */
+		write_reloc(0, stdout);
+
+		/* Now print each relocation */
+		for (i = 0; i < relocs32.count; i++)
+			write_reloc(relocs32.offset[i], stdout);
 	}
 }
 
-- 
1.7.9.5
