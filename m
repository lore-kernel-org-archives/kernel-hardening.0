From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v4 23/27] x86/modules: Adapt module loading for PIE support
Date: Tue, 29 May 2018 15:15:24 -0700
Message-Id: <20180529221625.33541-24-thgarnie@google.com>
In-Reply-To: <20180529221625.33541-1-thgarnie@google.com>
References: <20180529221625.33541-1-thgarnie@google.com>
To: kernel-hardening@lists.openwall.com
Cc: Thomas Garnier <thgarnie@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Francis Deslauriers <francis.deslauriers@efficios.com>, "H.J. Lu" <hjl.tools@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Adapt module loading to support PIE relocations. Generate dynamic GOT if
a symbol requires it but no entry exists in the kernel GOT.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/Makefile               |   4 +
 arch/x86/include/asm/module.h   |  11 ++
 arch/x86/include/asm/sections.h |   4 +
 arch/x86/kernel/module.c        | 181 +++++++++++++++++++++++++++++++-
 arch/x86/kernel/module.lds      |   3 +
 5 files changed, 198 insertions(+), 5 deletions(-)
 create mode 100644 arch/x86/kernel/module.lds

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 277ffc57ae13..20bb6cbd8938 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -134,7 +134,11 @@ else
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
index 7948a17febb4..68ff05e14288 100644
--- a/arch/x86/include/asm/module.h
+++ b/arch/x86/include/asm/module.h
@@ -5,12 +5,23 @@
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
 #ifdef CONFIG_UNWINDER_ORC
 	unsigned int num_orcs;
 	int *orc_unwind_ip;
 	struct orc_entry *orc_unwind;
 #endif
+#ifdef CONFIG_X86_PIE
+	struct mod_got_sec	core;
+#endif
 };
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/include/asm/sections.h b/arch/x86/include/asm/sections.h
index da3d98bb2bcb..89b3a95c8d11 100644
--- a/arch/x86/include/asm/sections.h
+++ b/arch/x86/include/asm/sections.h
@@ -17,4 +17,8 @@ extern char __entry_trampoline_start[], __entry_trampoline_end[];
 extern char __start_got[], __end_got[];
 #endif
 
+#if defined(CONFIG_X86_PIE)
+extern char __start_got[], __end_got[];
+#endif
+
 #endif	/* _ASM_X86_SECTIONS_H */
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index f58336af095c..88895f3d474b 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -30,6 +30,7 @@
 #include <linux/gfp.h>
 #include <linux/jump_label.h>
 #include <linux/random.h>
+#include <linux/sort.h>
 
 #include <asm/text-patching.h>
 #include <asm/page.h>
@@ -77,6 +78,173 @@ static unsigned long int get_module_load_offset(void)
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
@@ -190,16 +358,20 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 			if ((s64)val != *(s32 *)loc)
 				goto overflow;
 			break;
+#ifdef CONFIG_X86_PIE
+		case R_X86_64_GOTPCREL:
+			val = module_emit_got_entry(me, loc, rel + i, sym);
+			/* fallthrough */
+#endif
 		case R_X86_64_PC32:
 		case R_X86_64_PLT32:
 			if (*(u32 *)loc != 0)
 				goto invalid_relocation;
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
@@ -217,8 +389,7 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 overflow:
 	pr_err("overflow in relocation type %d val %Lx\n",
 	       (int)ELF64_R_TYPE(rel[i].r_info), val);
-	pr_err("`%s' likely not compiled with -mcmodel=kernel\n",
-	       me->name);
+	pr_err("`%s' likely too far from the kernel\n", me->name);
 	return -ENOEXEC;
 }
 #endif
diff --git a/arch/x86/kernel/module.lds b/arch/x86/kernel/module.lds
new file mode 100644
index 000000000000..fd6e95a4b454
--- /dev/null
+++ b/arch/x86/kernel/module.lds
@@ -0,0 +1,3 @@
+SECTIONS {
+	.got (NOLOAD) : { BYTE(0) }
+}
-- 
2.17.0.921.gf22659ad46-goog
