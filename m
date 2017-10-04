From: Thomas Garnier <thgarnie@google.com>
Date: Wed,  4 Oct 2017 14:19:59 -0700
Message-Id: <20171004212003.28296-24-thgarnie@google.com>
In-Reply-To: <20171004212003.28296-1-thgarnie@google.com>
References: <20171004212003.28296-1-thgarnie@google.com>
Subject: [kernel-hardening] [RFC v3 23/27] x86/modules: Adapt module loading for PIE support
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Garnier <thgarnie@google.com>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Matthias Kaehlcke <mka@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Borislav Petkov <bp@alien8.de>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christopher Li <sparse@chrisli.org>, Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Lukas Wunner <lukas@wunner.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Peter Foley <pefoley2@pefoley.com>, Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <jkosina@suse.cz>, Rob Landley <rob@landley.net>, "H . J . Lu" <hjl.tools@gmail.com>, Baoquan He <bhe@redhat.com>, =?UTF-8?q?Jan=20H=20=2E=20Sch=C3=B6nherr?= <jschoenh@amazon.de>, Daniel Micay <danielmicay@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Adapt module loading to support PIE relocations. Generate dynamic GOT if
a symbol requires it but no entry exist in the kernel GOT.

Position Independent Executable (PIE) support will allow to extended the
KASLR randomization range below the -2G memory limit.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/Makefile             |   4 +
 arch/x86/include/asm/module.h |  14 +++
 arch/x86/kernel/module.c      | 204 ++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 217 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 4cb4f0495ddc..42774185a58a 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -143,7 +143,11 @@ else
         KBUILD_CFLAGS += $(cflags-y)
 
         KBUILD_CFLAGS += -mno-red-zone
+ifdef CONFIG_X86_PIE
+        KBUILD_LDFLAGS_MODULE += -T $(srctree)/arch/x86/kernel/module.lds
+else
         KBUILD_CFLAGS += -mcmodel=kernel
+endif
 
         # -funit-at-a-time shrinks the kernel .text considerably
         # unfortunately it makes reading oopses harder.
diff --git a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
index 9eb7c718aaf8..8e0bd52bbadf 100644
--- a/arch/x86/include/asm/module.h
+++ b/arch/x86/include/asm/module.h
@@ -4,12 +4,23 @@
 #include <asm-generic/module.h>
 #include <asm/orc_types.h>
 
+#ifdef CONFIG_X86_PIE
+struct mod_got_sec {
+	struct elf64_shdr	*got;
+	int			got_num_entries;
+	int			got_max_entries;
+};
+#endif
+
 struct mod_arch_specific {
 #ifdef CONFIG_ORC_UNWINDER
 	unsigned int num_orcs;
 	int *orc_unwind_ip;
 	struct orc_entry *orc_unwind;
 #endif
+#ifdef CONFIG_X86_PIE
+	struct mod_got_sec	core;
+#endif
 };
 
 #ifdef CONFIG_X86_64
@@ -70,4 +81,7 @@ struct mod_arch_specific {
 # define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY
 #endif
 
+
+u64 module_find_got_entry(struct module *mod, u64 addr);
+
 #endif /* _ASM_X86_MODULE_H */
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 62e7d70aadd5..3b9b43a9d63b 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -30,6 +30,7 @@
 #include <linux/gfp.h>
 #include <linux/jump_label.h>
 #include <linux/random.h>
+#include <linux/sort.h>
 
 #include <asm/text-patching.h>
 #include <asm/page.h>
@@ -77,6 +78,195 @@ static unsigned long int get_module_load_offset(void)
 }
 #endif
 
+#ifdef CONFIG_X86_PIE
+static u64 find_got_kernel_entry(Elf64_Sym *sym, const Elf64_Rela *rela)
+{
+	u64 *pos;
+
+	for (pos = (u64*)__start_got; pos < (u64*)__end_got; pos++) {
+		if (*pos == sym->st_value)
+			return (u64)pos + rela->r_addend;
+	}
+
+	return 0;
+}
+
+/* Search the GOT entry for a specific address and a module (optional) */
+u64 module_find_got_entry(struct module *mod, u64 addr)
+{
+	int i;
+	u64 *pos;
+
+	for (pos = (u64*)__start_got; pos < (u64*)__end_got; pos++) {
+		if (*pos == addr)
+			return (u64)pos;
+	}
+
+	if (!mod)
+		return 0;
+
+	pos = (u64*)mod->arch.core.got->sh_addr;
+	for (i = 0; i < mod->arch.core.got_num_entries; i++) {
+		if (pos[i] == addr)
+			return (u64)&pos[i];
+	}
+	return 0;
+}
+
+static u64 module_emit_got_entry(struct module *mod, void *loc,
+				 const Elf64_Rela *rela, Elf64_Sym *sym)
+{
+	struct mod_got_sec *gotsec = &mod->arch.core;
+	u64 *got = (u64*)gotsec->got->sh_addr;
+	int i = gotsec->got_num_entries;
+	u64 ret;
+
+	/* Check if we can use the kernel GOT */
+	ret = find_got_kernel_entry(sym, rela);
+	if (ret)
+		return ret;
+
+	got[i] = sym->st_value;
+
+	/*
+	 * Check if the entry we just created is a duplicate. Given that the
+	 * relocations are sorted, this will be the last entry we allocated.
+	 * (if one exists).
+	 */
+	if (i > 0 && got[i] == got[i - 2]) {
+		ret = (u64)&got[i - 1];
+	} else {
+		gotsec->got_num_entries++;
+		BUG_ON(gotsec->got_num_entries > gotsec->got_max_entries);
+		ret = (u64)&got[i];
+	}
+
+	return ret + rela->r_addend;
+}
+
+#define cmp_3way(a,b)	((a) < (b) ? -1 : (a) > (b))
+
+static int cmp_rela(const void *a, const void *b)
+{
+	const Elf64_Rela *x = a, *y = b;
+	int i;
+
+	/* sort by type, symbol index and addend */
+	i = cmp_3way(ELF64_R_TYPE(x->r_info), ELF64_R_TYPE(y->r_info));
+	if (i == 0)
+		i = cmp_3way(ELF64_R_SYM(x->r_info), ELF64_R_SYM(y->r_info));
+	if (i == 0)
+		i = cmp_3way(x->r_addend, y->r_addend);
+	return i;
+}
+
+static bool duplicate_rel(const Elf64_Rela *rela, int num)
+{
+	/*
+	 * Entries are sorted by type, symbol index and addend. That means
+	 * that, if a duplicate entry exists, it must be in the preceding
+	 * slot.
+	 */
+	return num > 0 && cmp_rela(rela + num, rela + num - 1) == 0;
+}
+
+static unsigned int count_gots(Elf64_Sym *syms, Elf64_Rela *rela, int num)
+{
+	unsigned int ret = 0;
+	Elf64_Sym *s;
+	int i;
+
+	for (i = 0; i < num; i++) {
+		switch (ELF64_R_TYPE(rela[i].r_info)) {
+		case R_X86_64_GOTPCREL:
+			s = syms + ELF64_R_SYM(rela[i].r_info);
+
+			/*
+			 * Use the kernel GOT when possible, else reserve a
+			 * custom one for this module.
+			 */
+			if (!duplicate_rel(rela, i) &&
+			    !find_got_kernel_entry(s, rela + i))
+				ret++;
+			break;
+		}
+	}
+	return ret;
+}
+
+/*
+ * Generate GOT entries for GOTPCREL relocations that do not exists in the
+ * kernel GOT. Based on arm64 module-plts implementation.
+ */
+int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
+			      char *secstrings, struct module *mod)
+{
+	unsigned long gots = 0;
+	Elf_Shdr *symtab = NULL;
+	Elf64_Sym *syms = NULL;
+	char *strings, *name;
+	int i;
+
+	/*
+	 * Find the empty .got section so we can expand it to store the PLT
+	 * entries. Record the symtab address as well.
+	 */
+	for (i = 0; i < ehdr->e_shnum; i++) {
+		if (!strcmp(secstrings + sechdrs[i].sh_name, ".got")) {
+			mod->arch.core.got = sechdrs + i;
+		} else if (sechdrs[i].sh_type == SHT_SYMTAB) {
+			symtab = sechdrs + i;
+			syms = (Elf64_Sym *)symtab->sh_addr;
+		}
+	}
+
+	if (!mod->arch.core.got) {
+		pr_err("%s: module GOT section missing\n", mod->name);
+		return -ENOEXEC;
+	}
+	if (!syms) {
+		pr_err("%s: module symtab section missing\n", mod->name);
+		return -ENOEXEC;
+	}
+
+	for (i = 0; i < ehdr->e_shnum; i++) {
+		Elf64_Rela *rels = (void *)ehdr + sechdrs[i].sh_offset;
+		int numrels = sechdrs[i].sh_size / sizeof(Elf64_Rela);
+
+		if (sechdrs[i].sh_type != SHT_RELA)
+			continue;
+
+		/* sort by type, symbol index and addend */
+		sort(rels, numrels, sizeof(Elf64_Rela), cmp_rela, NULL);
+
+		gots += count_gots(syms, rels, numrels);
+	}
+
+	mod->arch.core.got->sh_type = SHT_NOBITS;
+	mod->arch.core.got->sh_flags = SHF_ALLOC;
+	mod->arch.core.got->sh_addralign = L1_CACHE_BYTES;
+	mod->arch.core.got->sh_size = (gots + 1) * sizeof(u64);
+	mod->arch.core.got_num_entries = 0;
+	mod->arch.core.got_max_entries = gots;
+
+	/*
+	 * If a _GLOBAL_OFFSET_TABLE_ symbol exists, make it absolute for
+	 * modules to correctly reference it. Similar to s390 implementation.
+	 */
+	strings = (void *) ehdr + sechdrs[symtab->sh_link].sh_offset;
+	for (i = 0; i < symtab->sh_size/sizeof(Elf_Sym); i++) {
+		if (syms[i].st_shndx != SHN_UNDEF)
+			continue;
+		name = strings + syms[i].st_name;
+		if (!strcmp(name, "_GLOBAL_OFFSET_TABLE_")) {
+			syms[i].st_shndx = SHN_ABS;
+			break;
+		}
+	}
+	return 0;
+}
+#endif
+
 void *module_alloc(unsigned long size)
 {
 	void *p;
@@ -184,13 +374,18 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 			if ((s64)val != *(s32 *)loc)
 				goto overflow;
 			break;
+#ifdef CONFIG_X86_PIE
+		case R_X86_64_GOTPCREL:
+			val = module_emit_got_entry(me, loc, rel + i, sym);
+			/* fallthrough */
+#endif
+		case R_X86_64_PLT32:
 		case R_X86_64_PC32:
 			val -= (u64)loc;
 			*(u32 *)loc = val;
-#if 0
-			if ((s64)val != *(s32 *)loc)
+			if (IS_ENABLED(CONFIG_X86_PIE) &&
+			    (s64)val != *(s32 *)loc)
 				goto overflow;
-#endif
 			break;
 		default:
 			pr_err("%s: Unknown rela relocation: %llu\n",
@@ -203,8 +398,7 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 overflow:
 	pr_err("overflow in relocation type %d val %Lx\n",
 	       (int)ELF64_R_TYPE(rel[i].r_info), val);
-	pr_err("`%s' likely not compiled with -mcmodel=kernel\n",
-	       me->name);
+	pr_err("`%s' likely too far from the kernel\n", me->name);
 	return -ENOEXEC;
 }
 #endif
-- 
2.14.2.920.gcf0c67979c-goog
