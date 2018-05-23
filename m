From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v3 26/27] x86/relocs: Add option to generate 64-bit relocations
Date: Wed, 23 May 2018 12:54:20 -0700
Message-Id: <20180523195421.180248-27-thgarnie@google.com>
In-Reply-To: <20180523195421.180248-1-thgarnie@google.com>
References: <20180523195421.180248-1-thgarnie@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Garnier <thgarnie@google.com>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, Yonghong Song <yhs@fb.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Kees Cook <keescook@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Alok Kataria <akataria@vmware.com>, Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@siemens.com>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Dennis Zhou <dennisszhou@gmail.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Alexey Dobriyan <adobriyan@gmail.com>, Masami Hiramatsu <mhiramat@kernel.org>, Cao jin <caoj.fnst@cn.fujitsu.com>, Francis Deslauriers <francis.deslauriers@efficios.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Randy Dunlap <rdunlap@infradead.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christopher Li <sparse@chrisli.org>, Jason Baron <jbaron@akamai.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Lukas Wunner <lukas@wunner.de>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Ingo Molnar <mingo@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw@amazon.co.uk>, Dave Hansen <dave.hansen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Jia Zhang <qianyue.zj@alibaba-inc.com>, Ricardo Neri <ricardo.neri-calderon@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Jan Beulich <JBeulich@suse.com>, Matthias Kaehlcke <mka@chromium.org>, Baoquan He <bhe@redhat.com>, =?UTF-8?q?Jan=20H=20=2E=20Sch=C3=B6nherr?= <jschoenh@amazon.de>, Daniel Micay <danielmicay@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

The x86 relocation tool generates a list of 32-bit signed integers. There
was no need to use 64-bit integers because all addresses where above the 2G
top of the memory.

This change add a large-reloc option to generate 64-bit unsigned integers.
It can be used when the kernel plan to go below the top 2G and 32-bit
integers are not enough.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/tools/relocs.c        | 60 +++++++++++++++++++++++++++-------
 arch/x86/tools/relocs.h        |  4 +--
 arch/x86/tools/relocs_common.c | 15 ++++++---
 3 files changed, 60 insertions(+), 19 deletions(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 29283ad3950f..a29cccceaac6 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -13,8 +13,14 @@
 
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
@@ -685,7 +691,7 @@ static void print_absolute_relocs(void)
 		printf("\n");
 }
 
-static void add_reloc(struct relocs *r, uint32_t offset)
+static void add_reloc(struct relocs *r, rel_off_t offset)
 {
 	if (r->count == r->size) {
 		unsigned long newsize = r->size + 50000;
@@ -1061,26 +1067,48 @@ static void sort_relocs(struct relocs *r)
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
@@ -1091,6 +1119,9 @@ static void emit_relocs(int as_text, int use_real_mode)
 		do_reloc = do_reloc32;
 	else
 		do_reloc = do_reloc_real;
+
+	/* Large relocations only for 64-bit */
+	use_large_reloc = 0;
 #endif
 
 	/* Collect up the relocations */
@@ -1114,8 +1145,13 @@ static void emit_relocs(int as_text, int use_real_mode)
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
@@ -1183,7 +1219,7 @@ static void print_reloc_info(void)
 
 void process(FILE *fp, int use_real_mode, int as_text,
 	     int show_absolute_syms, int show_absolute_relocs,
-	     int show_reloc_info)
+	     int show_reloc_info, int use_large_reloc)
 {
 	regex_init(use_real_mode);
 	read_ehdr(fp);
@@ -1206,5 +1242,5 @@ void process(FILE *fp, int use_real_mode, int as_text,
 		print_reloc_info();
 		return;
 	}
-	emit_relocs(as_text, use_real_mode);
+	emit_relocs(as_text, use_real_mode, use_large_reloc);
 }
diff --git a/arch/x86/tools/relocs.h b/arch/x86/tools/relocs.h
index 43c83c0fd22c..3d401da59df7 100644
--- a/arch/x86/tools/relocs.h
+++ b/arch/x86/tools/relocs.h
@@ -31,8 +31,8 @@ enum symtype {
 
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
index 6634352a20bc..11f49adf1c06 100644
--- a/arch/x86/tools/relocs_common.c
+++ b/arch/x86/tools/relocs_common.c
@@ -12,14 +12,14 @@ void die(char *fmt, ...)
 
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
@@ -30,6 +30,7 @@ int main(int argc, char **argv)
 	show_reloc_info = 0;
 	as_text = 0;
 	use_real_mode = 0;
+	use_large_reloc = 0;
 	fname = NULL;
 	for (i = 1; i < argc; i++) {
 		char *arg = argv[i];
@@ -54,6 +55,10 @@ int main(int argc, char **argv)
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
@@ -75,11 +80,11 @@ int main(int argc, char **argv)
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
2.17.0.441.gb46fe60e1d-goog
