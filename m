From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 18 Jul 2017 15:33:31 -0700
Message-Id: <20170718223333.110371-21-thgarnie@google.com>
In-Reply-To: <20170718223333.110371-1-thgarnie@google.com>
References: <20170718223333.110371-1-thgarnie@google.com>
Subject: [kernel-hardening] [RFC 20/22] x86/relocs: Add option to generate 64-bit relocations
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Garnier <thgarnie@google.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Christopher Li <sparse@chrisli.org>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Peter Foley <pefoley2@pefoley.com>, Steven Rostedt <rostedt@goodmis.org>, Tim Chen <tim.c.chen@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org, kvm@vger.kernel.org, linux-pm@vger.kernel.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

The x86 relocation tool generates a list of 32-bit signed integers. There
was no need to use 64-bit integers because all addresses where above the 2G
top of the memory.

This change add a large-reloc option to generate 64-bit unsigned integers.
It can be used when the kernel plan to go below the top 2G and 32-bit
integers are not enough.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/tools/relocs.c        | 60 +++++++++++++++++++++++++++++++++---------
 arch/x86/tools/relocs.h        |  4 +--
 arch/x86/tools/relocs_common.c | 15 +++++++----
 3 files changed, 60 insertions(+), 19 deletions(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 70f523dd68ff..19b3e6c594b1 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -12,8 +12,14 @@
 
 static Elf_Ehdr ehdr;
 
+#if ELF_BITS == 64
+typedef uint64_t rel_off_t;
+#else
+typedef uint32_t rel_off_t;
+#endif
+
 struct relocs {
-	uint32_t	*offset;
+	rel_off_t	*offset;
 	unsigned long	count;
 	unsigned long	size;
 };
@@ -627,7 +633,7 @@ static void print_absolute_relocs(void)
 		printf("\n");
 }
 
-static void add_reloc(struct relocs *r, uint32_t offset)
+static void add_reloc(struct relocs *r, rel_off_t offset)
 {
 	if (r->count == r->size) {
 		unsigned long newsize = r->size + 50000;
@@ -983,26 +989,48 @@ static void sort_relocs(struct relocs *r)
 	qsort(r->offset, r->count, sizeof(r->offset[0]), cmp_relocs);
 }
 
-static int write32(uint32_t v, FILE *f)
+static int write32(rel_off_t rel, FILE *f)
 {
-	unsigned char buf[4];
+	unsigned char buf[sizeof(uint32_t)];
+	uint32_t v = (uint32_t)rel;
 
 	put_unaligned_le32(v, buf);
-	return fwrite(buf, 1, 4, f) == 4 ? 0 : -1;
+	return fwrite(buf, 1, sizeof(buf), f) == sizeof(buf) ? 0 : -1;
 }
 
-static int write32_as_text(uint32_t v, FILE *f)
+static int write32_as_text(rel_off_t rel, FILE *f)
 {
+	uint32_t v = (uint32_t)rel;
 	return fprintf(f, "\t.long 0x%08"PRIx32"\n", v) > 0 ? 0 : -1;
 }
 
-static void emit_relocs(int as_text, int use_real_mode)
+static int write64(rel_off_t rel, FILE *f)
+{
+	unsigned char buf[sizeof(uint64_t)];
+	uint64_t v = (uint64_t)rel;
+
+	put_unaligned_le64(v, buf);
+	return fwrite(buf, 1, sizeof(buf), f) == sizeof(buf) ? 0 : -1;
+}
+
+static int write64_as_text(rel_off_t rel, FILE *f)
+{
+	uint64_t v = (uint64_t)rel;
+	return fprintf(f, "\t.quad 0x%016"PRIx64"\n", v) > 0 ? 0 : -1;
+}
+
+static void emit_relocs(int as_text, int use_real_mode, int use_large_reloc)
 {
 	int i;
-	int (*write_reloc)(uint32_t, FILE *) = write32;
+	int (*write_reloc)(rel_off_t, FILE *);
 	int (*do_reloc)(struct section *sec, Elf_Rel *rel, Elf_Sym *sym,
 			const char *symname);
 
+	if (use_large_reloc)
+		write_reloc = write64;
+	else
+		write_reloc = write32;
+
 #if ELF_BITS == 64
 	if (!use_real_mode)
 		do_reloc = do_reloc64;
@@ -1013,6 +1041,9 @@ static void emit_relocs(int as_text, int use_real_mode)
 		do_reloc = do_reloc32;
 	else
 		do_reloc = do_reloc_real;
+
+	/* Large relocations only for 64-bit */
+	use_large_reloc = 0;
 #endif
 
 	/* Collect up the relocations */
@@ -1036,8 +1067,13 @@ static void emit_relocs(int as_text, int use_real_mode)
 		 * gas will like.
 		 */
 		printf(".section \".data.reloc\",\"a\"\n");
-		printf(".balign 4\n");
-		write_reloc = write32_as_text;
+		if (use_large_reloc) {
+			printf(".balign 8\n");
+			write_reloc = write64_as_text;
+		} else {
+			printf(".balign 4\n");
+			write_reloc = write32_as_text;
+		}
 	}
 
 	if (use_real_mode) {
@@ -1131,7 +1167,7 @@ static void print_reloc_info(void)
 
 void process(FILE *fp, int use_real_mode, int as_text,
 	     int show_absolute_syms, int show_absolute_relocs,
-	     int show_reloc_info)
+	     int show_reloc_info, int use_large_reloc)
 {
 	regex_init(use_real_mode);
 	read_ehdr(fp);
@@ -1153,5 +1189,5 @@ void process(FILE *fp, int use_real_mode, int as_text,
 		print_reloc_info();
 		return;
 	}
-	emit_relocs(as_text, use_real_mode);
+	emit_relocs(as_text, use_real_mode, use_large_reloc);
 }
diff --git a/arch/x86/tools/relocs.h b/arch/x86/tools/relocs.h
index 1d23bf953a4a..cb771cc4412d 100644
--- a/arch/x86/tools/relocs.h
+++ b/arch/x86/tools/relocs.h
@@ -30,8 +30,8 @@ enum symtype {
 
 void process_32(FILE *fp, int use_real_mode, int as_text,
 		int show_absolute_syms, int show_absolute_relocs,
-		int show_reloc_info);
+		int show_reloc_info, int use_large_reloc);
 void process_64(FILE *fp, int use_real_mode, int as_text,
 		int show_absolute_syms, int show_absolute_relocs,
-		int show_reloc_info);
+		int show_reloc_info, int use_large_reloc);
 #endif /* RELOCS_H */
diff --git a/arch/x86/tools/relocs_common.c b/arch/x86/tools/relocs_common.c
index acab636bcb34..9cf1391af50a 100644
--- a/arch/x86/tools/relocs_common.c
+++ b/arch/x86/tools/relocs_common.c
@@ -11,14 +11,14 @@ void die(char *fmt, ...)
 
 static void usage(void)
 {
-	die("relocs [--abs-syms|--abs-relocs|--reloc-info|--text|--realmode]" \
-	    " vmlinux\n");
+	die("relocs [--abs-syms|--abs-relocs|--reloc-info|--text|--realmode|" \
+	    "--large-reloc]  vmlinux\n");
 }
 
 int main(int argc, char **argv)
 {
 	int show_absolute_syms, show_absolute_relocs, show_reloc_info;
-	int as_text, use_real_mode;
+	int as_text, use_real_mode, use_large_reloc;
 	const char *fname;
 	FILE *fp;
 	int i;
@@ -29,6 +29,7 @@ int main(int argc, char **argv)
 	show_reloc_info = 0;
 	as_text = 0;
 	use_real_mode = 0;
+	use_large_reloc = 0;
 	fname = NULL;
 	for (i = 1; i < argc; i++) {
 		char *arg = argv[i];
@@ -53,6 +54,10 @@ int main(int argc, char **argv)
 				use_real_mode = 1;
 				continue;
 			}
+			if (strcmp(arg, "--large-reloc") == 0) {
+				use_large_reloc = 1;
+				continue;
+			}
 		}
 		else if (!fname) {
 			fname = arg;
@@ -74,11 +79,11 @@ int main(int argc, char **argv)
 	if (e_ident[EI_CLASS] == ELFCLASS64)
 		process_64(fp, use_real_mode, as_text,
 			   show_absolute_syms, show_absolute_relocs,
-			   show_reloc_info);
+			   show_reloc_info, use_large_reloc);
 	else
 		process_32(fp, use_real_mode, as_text,
 			   show_absolute_syms, show_absolute_relocs,
-			   show_reloc_info);
+			   show_reloc_info, use_large_reloc);
 	fclose(fp);
 	return 0;
 }
-- 
2.13.2.932.g7449e964c-goog
