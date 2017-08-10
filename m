From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 10 Aug 2017 10:26:10 -0700
Message-Id: <20170810172615.51965-19-thgarnie@google.com>
In-Reply-To: <20170810172615.51965-1-thgarnie@google.com>
References: <20170810172615.51965-1-thgarnie@google.com>
Subject: [kernel-hardening] [RFC v2 18/23] x86/relocs: Handle DYN relocations for PIE support
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Garnier <thgarnie@google.com>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Christopher Li <sparse@chrisli.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lukas Wunner <lukas@wunner.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Markus Trippelsdorf <markus@trippelsdorf.de>, Steven Rostedt <rostedt@goodmis.org>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Peter Foley <pefoley2@pefoley.com>, Tim Chen <tim.c.chen@linux.intel.com>, Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org, kvm@vger.kernel.org, linux-pm@vger.kernel.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Change the relocation tool to correctly handle DYN/PIE kernel where
the relocation table does not reference symbols and percpu support is
not needed. Also add support for R_X86_64_RELATIVE relocations that can
be handled like a 64-bit relocation due to the usage of -Bsymbolic.

Position Independent Executable (PIE) support will allow to extended the
KASLR randomization range below the -2G memory limit.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/tools/relocs.c | 74 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 65 insertions(+), 9 deletions(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 73eb7fd4aec4..70f523dd68ff 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -642,6 +642,13 @@ static void add_reloc(struct relocs *r, uint32_t offset)
 	r->offset[r->count++] = offset;
 }
 
+/* Relocation found in a DYN binary, support only for 64-bit PIE */
+static int is_dyn_reloc(struct section *sec)
+{
+	return ELF_BITS == 64 && ehdr.e_type == ET_DYN &&
+		sec->shdr.sh_info == SHT_NULL;
+}
+
 static void walk_relocs(int (*process)(struct section *sec, Elf_Rel *rel,
 			Elf_Sym *sym, const char *symname))
 {
@@ -652,6 +659,7 @@ static void walk_relocs(int (*process)(struct section *sec, Elf_Rel *rel,
 		Elf_Sym *sh_symtab;
 		struct section *sec_applies, *sec_symtab;
 		int j;
+		int dyn_reloc = 0;
 		struct section *sec = &secs[i];
 
 		if (sec->shdr.sh_type != SHT_REL_TYPE) {
@@ -660,14 +668,20 @@ static void walk_relocs(int (*process)(struct section *sec, Elf_Rel *rel,
 		sec_symtab  = sec->link;
 		sec_applies = &secs[sec->shdr.sh_info];
 		if (!(sec_applies->shdr.sh_flags & SHF_ALLOC)) {
-			continue;
+			if (!is_dyn_reloc(sec_applies))
+				continue;
+			dyn_reloc = 1;
 		}
 		sh_symtab = sec_symtab->symtab;
 		sym_strtab = sec_symtab->link->strtab;
 		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf_Rel); j++) {
 			Elf_Rel *rel = &sec->reltab[j];
-			Elf_Sym *sym = &sh_symtab[ELF_R_SYM(rel->r_info)];
-			const char *symname = sym_name(sym_strtab, sym);
+			Elf_Sym *sym = NULL;
+			const char *symname = NULL;
+			if (!dyn_reloc) {
+				sym = &sh_symtab[ELF_R_SYM(rel->r_info)];
+				symname = sym_name(sym_strtab, sym);
+			}
 
 			process(sec, rel, sym, symname);
 		}
@@ -746,16 +760,21 @@ static int is_percpu_sym(ElfW(Sym) *sym, const char *symname)
 		strncmp(symname, "init_per_cpu_", 13);
 }
 
-
 static int do_reloc64(struct section *sec, Elf_Rel *rel, ElfW(Sym) *sym,
 		      const char *symname)
 {
 	unsigned r_type = ELF64_R_TYPE(rel->r_info);
 	ElfW(Addr) offset = rel->r_offset;
-	int shn_abs = (sym->st_shndx == SHN_ABS) && !is_reloc(S_REL, symname);
+	int shn_abs = 0;
+	int dyn_reloc = is_dyn_reloc(sec);
 
-	if (sym->st_shndx == SHN_UNDEF)
-		return 0;
+	if (!dyn_reloc) {
+		shn_abs = (sym->st_shndx == SHN_ABS) &&
+			!is_reloc(S_REL, symname);
+
+		if (sym->st_shndx == SHN_UNDEF)
+			return 0;
+	}
 
 	/*
 	 * Adjust the offset if this reloc applies to the percpu section.
@@ -769,6 +788,9 @@ static int do_reloc64(struct section *sec, Elf_Rel *rel, ElfW(Sym) *sym,
 		break;
 
 	case R_X86_64_PC32:
+		if (dyn_reloc)
+			die("PC32 reloc in PIE DYN binary");
+
 		/*
 		 * PC relative relocations don't need to be adjusted unless
 		 * referencing a percpu symbol.
@@ -783,7 +805,7 @@ static int do_reloc64(struct section *sec, Elf_Rel *rel, ElfW(Sym) *sym,
 		/*
 		 * References to the percpu area don't need to be adjusted.
 		 */
-		if (is_percpu_sym(sym, symname))
+		if (!dyn_reloc && is_percpu_sym(sym, symname))
 			break;
 
 		if (shn_abs) {
@@ -814,6 +836,14 @@ static int do_reloc64(struct section *sec, Elf_Rel *rel, ElfW(Sym) *sym,
 			add_reloc(&relocs32, offset);
 		break;
 
+	case R_X86_64_RELATIVE:
+		/*
+		 * -Bsymbolic means we don't need the addend and we can reuse
+		 * the original relocs64.
+		 */
+		add_reloc(&relocs64, offset);
+		break;
+
 	default:
 		die("Unsupported relocation type: %s (%d)\n",
 		    rel_type(r_type), r_type);
@@ -1044,6 +1074,21 @@ static void emit_relocs(int as_text, int use_real_mode)
 	}
 }
 
+/* Print a different header based on the type of relocation */
+static void print_reloc_header(struct section *sec) {
+	static int header_printed = 0;
+	int header_type = is_dyn_reloc(sec) ? 2 : 1;
+
+	if (header_printed == header_type)
+		return;
+	header_printed = header_type;
+
+	if (header_type == 2)
+		printf("reloc type\toffset\tvalue\n");
+	else
+		printf("reloc section\treloc type\tsymbol\tsymbol section\n");
+}
+
 /*
  * As an aid to debugging problems with different linkers
  * print summary information about the relocs.
@@ -1053,6 +1098,18 @@ static void emit_relocs(int as_text, int use_real_mode)
 static int do_reloc_info(struct section *sec, Elf_Rel *rel, ElfW(Sym) *sym,
 				const char *symname)
 {
+
+	print_reloc_header(sec);
+
+#if ELF_BITS == 64
+	if (is_dyn_reloc(sec)) {
+		printf("%s\t0x%lx\t0x%lx\n",
+		       rel_type(ELF_R_TYPE(rel->r_info)),
+		       rel->r_offset,
+		       rel->r_addend);
+		return 0;
+	}
+#endif
 	printf("%s\t%s\t%s\t%s\n",
 		sec_name(sec->shdr.sh_info),
 		rel_type(ELF_R_TYPE(rel->r_info)),
@@ -1063,7 +1120,6 @@ static int do_reloc_info(struct section *sec, Elf_Rel *rel, ElfW(Sym) *sym,
 
 static void print_reloc_info(void)
 {
-	printf("reloc section\treloc type\tsymbol\tsymbol section\n");
 	walk_relocs(do_reloc_info);
 }
 
-- 
2.14.0.434.g98096fd7a8-goog
