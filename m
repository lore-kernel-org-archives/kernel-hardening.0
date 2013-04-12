Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Fri, 12 Apr 2013 13:13:42 -0700
Message-Id: <1365797627-20874-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1365797627-20874-1-git-send-email-keescook@chromium.org>
References: <1365797627-20874-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 1/6] x86: relocs: generalize Elf structure names
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

In preparation for making the reloc tool operate on 64-bit relocations,
generalize the structure names for easy recompilation via #defines.

Based on work by Neill Clift and Michael Davidson.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/tools/relocs.c |  170 +++++++++++++++++++++++++++--------------------
 1 file changed, 99 insertions(+), 71 deletions(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 79d67bd..fd28ef7 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -12,20 +12,42 @@
 #include <regex.h>
 #include <tools/le_byteshift.h>
 
+#define ElfW(type)		_ElfW(ELF_BITS, type)
+#define _ElfW(bits, type)	__ElfW(bits, type)
+#define __ElfW(bits, type)	Elf##bits##_##type
+
+#define ELF_BITS		32
+#define ELF_MACHINE		EM_386
+#define ELF_MACHINE_NAME	"i386"
+#define SHT_REL_TYPE		SHT_REL
+
+#define ELF_CLASS		ELFCLASS32
+#define ELF_R_SYM(val)		ELF32_R_SYM(val)
+#define ELF_R_TYPE(val)		ELF32_R_TYPE(val)
+#define ELF_ST_TYPE(o)		ELF32_ST_TYPE(o)
+#define ELF_ST_BIND(o)		ELF32_ST_BIND(o)
+#define ELF_ST_VISIBILITY(o)	ELF32_ST_VISIBILITY(o)
+
+#define Elf_Rel			ElfW(Rel)
+#define Elf_Ehdr		ElfW(Ehdr)
+#define Elf_Phdr		ElfW(Phdr)
+#define Elf_Shdr		ElfW(Shdr)
+#define Elf_Sym			ElfW(Sym)
+
 static void die(char *fmt, ...);
 
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
-static Elf32_Ehdr ehdr;
+static Elf_Ehdr ehdr;
 static unsigned long reloc_count, reloc_idx;
 static unsigned long *relocs;
 static unsigned long reloc16_count, reloc16_idx;
 static unsigned long *relocs16;
 
 struct section {
-	Elf32_Shdr     shdr;
+	Elf_Shdr       shdr;
 	struct section *link;
-	Elf32_Sym      *symtab;
-	Elf32_Rel      *reltab;
+	Elf_Sym        *symtab;
+	Elf_Rel        *reltab;
 	char           *strtab;
 };
 static struct section *secs;
@@ -240,7 +262,7 @@ static const char *sec_name(unsigned shndx)
 	return name;
 }
 
-static const char *sym_name(const char *sym_strtab, Elf32_Sym *sym)
+static const char *sym_name(const char *sym_strtab, Elf_Sym *sym)
 {
 	const char *name;
 	name = "<noname>";
@@ -274,6 +296,12 @@ static uint32_t elf32_to_cpu(uint32_t val)
 	return le32_to_cpu(val);
 }
 
+#define elf_half_to_cpu(x)	elf16_to_cpu(x)
+#define elf_word_to_cpu(x)	elf32_to_cpu(x)
+#define elf_addr_to_cpu(x)	elf32_to_cpu(x)
+#define elf_off_to_cpu(x)	elf32_to_cpu(x)
+#define elf_xword_to_cpu(x)	elf32_to_cpu(x)
+
 static void read_ehdr(FILE *fp)
 {
 	if (fread(&ehdr, sizeof(ehdr), 1, fp) != 1) {
@@ -283,8 +311,8 @@ static void read_ehdr(FILE *fp)
 	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) != 0) {
 		die("No ELF magic\n");
 	}
-	if (ehdr.e_ident[EI_CLASS] != ELFCLASS32) {
-		die("Not a 32 bit executable\n");
+	if (ehdr.e_ident[EI_CLASS] != ELF_CLASS) {
+		die("Not a %d bit executable\n", ELF_BITS);
 	}
 	if (ehdr.e_ident[EI_DATA] != ELFDATA2LSB) {
 		die("Not a LSB ELF executable\n");
@@ -293,36 +321,36 @@ static void read_ehdr(FILE *fp)
 		die("Unknown ELF version\n");
 	}
 	/* Convert the fields to native endian */
-	ehdr.e_type      = elf16_to_cpu(ehdr.e_type);
-	ehdr.e_machine   = elf16_to_cpu(ehdr.e_machine);
-	ehdr.e_version   = elf32_to_cpu(ehdr.e_version);
-	ehdr.e_entry     = elf32_to_cpu(ehdr.e_entry);
-	ehdr.e_phoff     = elf32_to_cpu(ehdr.e_phoff);
-	ehdr.e_shoff     = elf32_to_cpu(ehdr.e_shoff);
-	ehdr.e_flags     = elf32_to_cpu(ehdr.e_flags);
-	ehdr.e_ehsize    = elf16_to_cpu(ehdr.e_ehsize);
-	ehdr.e_phentsize = elf16_to_cpu(ehdr.e_phentsize);
-	ehdr.e_phnum     = elf16_to_cpu(ehdr.e_phnum);
-	ehdr.e_shentsize = elf16_to_cpu(ehdr.e_shentsize);
-	ehdr.e_shnum     = elf16_to_cpu(ehdr.e_shnum);
-	ehdr.e_shstrndx  = elf16_to_cpu(ehdr.e_shstrndx);
+	ehdr.e_type      = elf_half_to_cpu(ehdr.e_type);
+	ehdr.e_machine   = elf_half_to_cpu(ehdr.e_machine);
+	ehdr.e_version   = elf_word_to_cpu(ehdr.e_version);
+	ehdr.e_entry     = elf_addr_to_cpu(ehdr.e_entry);
+	ehdr.e_phoff     = elf_off_to_cpu(ehdr.e_phoff);
+	ehdr.e_shoff     = elf_off_to_cpu(ehdr.e_shoff);
+	ehdr.e_flags     = elf_word_to_cpu(ehdr.e_flags);
+	ehdr.e_ehsize    = elf_half_to_cpu(ehdr.e_ehsize);
+	ehdr.e_phentsize = elf_half_to_cpu(ehdr.e_phentsize);
+	ehdr.e_phnum     = elf_half_to_cpu(ehdr.e_phnum);
+	ehdr.e_shentsize = elf_half_to_cpu(ehdr.e_shentsize);
+	ehdr.e_shnum     = elf_half_to_cpu(ehdr.e_shnum);
+	ehdr.e_shstrndx  = elf_half_to_cpu(ehdr.e_shstrndx);
 
 	if ((ehdr.e_type != ET_EXEC) && (ehdr.e_type != ET_DYN)) {
 		die("Unsupported ELF header type\n");
 	}
-	if (ehdr.e_machine != EM_386) {
-		die("Not for x86\n");
+	if (ehdr.e_machine != ELF_MACHINE) {
+		die("Not for %s\n", ELF_MACHINE_NAME);
 	}
 	if (ehdr.e_version != EV_CURRENT) {
 		die("Unknown ELF version\n");
 	}
-	if (ehdr.e_ehsize != sizeof(Elf32_Ehdr)) {
+	if (ehdr.e_ehsize != sizeof(Elf_Ehdr)) {
 		die("Bad Elf header size\n");
 	}
-	if (ehdr.e_phentsize != sizeof(Elf32_Phdr)) {
+	if (ehdr.e_phentsize != sizeof(Elf_Phdr)) {
 		die("Bad program header entry\n");
 	}
-	if (ehdr.e_shentsize != sizeof(Elf32_Shdr)) {
+	if (ehdr.e_shentsize != sizeof(Elf_Shdr)) {
 		die("Bad section header entry\n");
 	}
 	if (ehdr.e_shstrndx >= ehdr.e_shnum) {
@@ -333,7 +361,7 @@ static void read_ehdr(FILE *fp)
 static void read_shdrs(FILE *fp)
 {
 	int i;
-	Elf32_Shdr shdr;
+	Elf_Shdr shdr;
 
 	secs = calloc(ehdr.e_shnum, sizeof(struct section));
 	if (!secs) {
@@ -349,16 +377,16 @@ static void read_shdrs(FILE *fp)
 		if (fread(&shdr, sizeof shdr, 1, fp) != 1)
 			die("Cannot read ELF section headers %d/%d: %s\n",
 			    i, ehdr.e_shnum, strerror(errno));
-		sec->shdr.sh_name      = elf32_to_cpu(shdr.sh_name);
-		sec->shdr.sh_type      = elf32_to_cpu(shdr.sh_type);
-		sec->shdr.sh_flags     = elf32_to_cpu(shdr.sh_flags);
-		sec->shdr.sh_addr      = elf32_to_cpu(shdr.sh_addr);
-		sec->shdr.sh_offset    = elf32_to_cpu(shdr.sh_offset);
-		sec->shdr.sh_size      = elf32_to_cpu(shdr.sh_size);
-		sec->shdr.sh_link      = elf32_to_cpu(shdr.sh_link);
-		sec->shdr.sh_info      = elf32_to_cpu(shdr.sh_info);
-		sec->shdr.sh_addralign = elf32_to_cpu(shdr.sh_addralign);
-		sec->shdr.sh_entsize   = elf32_to_cpu(shdr.sh_entsize);
+		sec->shdr.sh_name      = elf_word_to_cpu(shdr.sh_name);
+		sec->shdr.sh_type      = elf_word_to_cpu(shdr.sh_type);
+		sec->shdr.sh_flags     = elf_xword_to_cpu(shdr.sh_flags);
+		sec->shdr.sh_addr      = elf_addr_to_cpu(shdr.sh_addr);
+		sec->shdr.sh_offset    = elf_off_to_cpu(shdr.sh_offset);
+		sec->shdr.sh_size      = elf_xword_to_cpu(shdr.sh_size);
+		sec->shdr.sh_link      = elf_word_to_cpu(shdr.sh_link);
+		sec->shdr.sh_info      = elf_word_to_cpu(shdr.sh_info);
+		sec->shdr.sh_addralign = elf_xword_to_cpu(shdr.sh_addralign);
+		sec->shdr.sh_entsize   = elf_xword_to_cpu(shdr.sh_entsize);
 		if (sec->shdr.sh_link < ehdr.e_shnum)
 			sec->link = &secs[sec->shdr.sh_link];
 	}
@@ -412,12 +440,12 @@ static void read_symtabs(FILE *fp)
 			die("Cannot read symbol table: %s\n",
 				strerror(errno));
 		}
-		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Sym); j++) {
-			Elf32_Sym *sym = &sec->symtab[j];
-			sym->st_name  = elf32_to_cpu(sym->st_name);
-			sym->st_value = elf32_to_cpu(sym->st_value);
-			sym->st_size  = elf32_to_cpu(sym->st_size);
-			sym->st_shndx = elf16_to_cpu(sym->st_shndx);
+		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf_Sym); j++) {
+			Elf_Sym *sym = &sec->symtab[j];
+			sym->st_name  = elf_word_to_cpu(sym->st_name);
+			sym->st_value = elf_addr_to_cpu(sym->st_value);
+			sym->st_size  = elf_xword_to_cpu(sym->st_size);
+			sym->st_shndx = elf_half_to_cpu(sym->st_shndx);
 		}
 	}
 }
@@ -428,7 +456,7 @@ static void read_relocs(FILE *fp)
 	int i,j;
 	for (i = 0; i < ehdr.e_shnum; i++) {
 		struct section *sec = &secs[i];
-		if (sec->shdr.sh_type != SHT_REL) {
+		if (sec->shdr.sh_type != SHT_REL_TYPE) {
 			continue;
 		}
 		sec->reltab = malloc(sec->shdr.sh_size);
@@ -445,10 +473,10 @@ static void read_relocs(FILE *fp)
 			die("Cannot read symbol table: %s\n",
 				strerror(errno));
 		}
-		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Rel); j++) {
-			Elf32_Rel *rel = &sec->reltab[j];
-			rel->r_offset = elf32_to_cpu(rel->r_offset);
-			rel->r_info   = elf32_to_cpu(rel->r_info);
+		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf_Rel); j++) {
+			Elf_Rel *rel = &sec->reltab[j];
+			rel->r_offset = elf_addr_to_cpu(rel->r_offset);
+			rel->r_info   = elf_xword_to_cpu(rel->r_info);
 		}
 	}
 }
@@ -468,8 +496,8 @@ static void print_absolute_symbols(void)
 			continue;
 		}
 		sym_strtab = sec->link->strtab;
-		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Sym); j++) {
-			Elf32_Sym *sym;
+		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf_Sym); j++) {
+			Elf_Sym *sym;
 			const char *name;
 			sym = &sec->symtab[j];
 			name = sym_name(sym_strtab, sym);
@@ -478,9 +506,9 @@ static void print_absolute_symbols(void)
 			}
 			printf("%5d %08x %5d %10s %10s %12s %s\n",
 				j, sym->st_value, sym->st_size,
-				sym_type(ELF32_ST_TYPE(sym->st_info)),
-				sym_bind(ELF32_ST_BIND(sym->st_info)),
-				sym_visibility(ELF32_ST_VISIBILITY(sym->st_other)),
+				sym_type(ELF_ST_TYPE(sym->st_info)),
+				sym_bind(ELF_ST_BIND(sym->st_info)),
+				sym_visibility(ELF_ST_VISIBILITY(sym->st_other)),
 				name);
 		}
 	}
@@ -495,9 +523,9 @@ static void print_absolute_relocs(void)
 		struct section *sec = &secs[i];
 		struct section *sec_applies, *sec_symtab;
 		char *sym_strtab;
-		Elf32_Sym *sh_symtab;
+		Elf_Sym *sh_symtab;
 		int j;
-		if (sec->shdr.sh_type != SHT_REL) {
+		if (sec->shdr.sh_type != SHT_REL_TYPE) {
 			continue;
 		}
 		sec_symtab  = sec->link;
@@ -507,12 +535,12 @@ static void print_absolute_relocs(void)
 		}
 		sh_symtab  = sec_symtab->symtab;
 		sym_strtab = sec_symtab->link->strtab;
-		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Rel); j++) {
-			Elf32_Rel *rel;
-			Elf32_Sym *sym;
+		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf_Rel); j++) {
+			Elf_Rel *rel;
+			Elf_Sym *sym;
 			const char *name;
 			rel = &sec->reltab[j];
-			sym = &sh_symtab[ELF32_R_SYM(rel->r_info)];
+			sym = &sh_symtab[ELF_R_SYM(rel->r_info)];
 			name = sym_name(sym_strtab, sym);
 			if (sym->st_shndx != SHN_ABS) {
 				continue;
@@ -545,7 +573,7 @@ static void print_absolute_relocs(void)
 			printf("%08x %08x %10s %08x  %s\n",
 				rel->r_offset,
 				rel->r_info,
-				rel_type(ELF32_R_TYPE(rel->r_info)),
+				rel_type(ELF_R_TYPE(rel->r_info)),
 				sym->st_value,
 				name);
 		}
@@ -555,19 +583,19 @@ static void print_absolute_relocs(void)
 		printf("\n");
 }
 
-static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym),
+static void walk_relocs(void (*visit)(Elf_Rel *rel, Elf_Sym *sym),
 			int use_real_mode)
 {
 	int i;
 	/* Walk through the relocations */
 	for (i = 0; i < ehdr.e_shnum; i++) {
 		char *sym_strtab;
-		Elf32_Sym *sh_symtab;
+		Elf_Sym *sh_symtab;
 		struct section *sec_applies, *sec_symtab;
 		int j;
 		struct section *sec = &secs[i];
 
-		if (sec->shdr.sh_type != SHT_REL) {
+		if (sec->shdr.sh_type != SHT_REL_TYPE) {
 			continue;
 		}
 		sec_symtab  = sec->link;
@@ -577,16 +605,16 @@ static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym),
 		}
 		sh_symtab = sec_symtab->symtab;
 		sym_strtab = sec_symtab->link->strtab;
-		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Rel); j++) {
-			Elf32_Rel *rel;
-			Elf32_Sym *sym;
+		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf_Rel); j++) {
+			Elf_Rel *rel;
+			Elf_Sym *sym;
 			unsigned r_type;
 			const char *symname;
 			int shn_abs;
 
 			rel = &sec->reltab[j];
-			sym = &sh_symtab[ELF32_R_SYM(rel->r_info)];
-			r_type = ELF32_R_TYPE(rel->r_info);
+			sym = &sh_symtab[ELF_R_SYM(rel->r_info)];
+			r_type = ELF_R_TYPE(rel->r_info);
 
 			shn_abs = sym->st_shndx == SHN_ABS;
 
@@ -647,18 +675,18 @@ static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym),
 	}
 }
 
-static void count_reloc(Elf32_Rel *rel, Elf32_Sym *sym)
+static void count_reloc(Elf_Rel *rel, Elf_Sym *sym)
 {
-	if (ELF32_R_TYPE(rel->r_info) == R_386_16)
+	if (ELF_R_TYPE(rel->r_info) == R_386_16)
 		reloc16_count++;
 	else
 		reloc_count++;
 }
 
-static void collect_reloc(Elf32_Rel *rel, Elf32_Sym *sym)
+static void collect_reloc(Elf_Rel *rel, Elf_Sym *sym)
 {
 	/* Remember the address that needs to be adjusted. */
-	if (ELF32_R_TYPE(rel->r_info) == R_386_16)
+	if (ELF_R_TYPE(rel->r_info) == R_386_16)
 		relocs16[reloc16_idx++] = rel->r_offset;
 	else
 		relocs[reloc_idx++] = rel->r_offset;
-- 
1.7.9.5
