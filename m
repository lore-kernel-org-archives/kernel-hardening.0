From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 18 Jul 2017 15:33:32 -0700
Message-Id: <20170718223333.110371-22-thgarnie@google.com>
In-Reply-To: <20170718223333.110371-1-thgarnie@google.com>
References: <20170718223333.110371-1-thgarnie@google.com>
Subject: [kernel-hardening] [RFC 21/22] x86/module: Add support for mcmodel large and PLTs
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Garnier <thgarnie@google.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Christopher Li <sparse@chrisli.org>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Peter Foley <pefoley2@pefoley.com>, Steven Rostedt <rostedt@goodmis.org>, Tim Chen <tim.c.chen@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org, kvm@vger.kernel.org, linux-pm@vger.kernel.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

With PIE support and KASLR extended range, the modules may be further
away from the kernel than before breaking mcmodel=kernel expectations.

Add an option to build modules with mcmodel=large. The modules generated
code will make no assumptions on placement in memory.

Despite this option, modules still expect kernel functions to be within
2G and generate relative calls. To solve this issue, the PLT arm64 code
was adapted for x86_64. When a relative relocation go outside its range,
a dynamic PLT entry is used to correctly jump to the destination.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/Kconfig              |  10 +++
 arch/x86/Makefile             |  10 ++-
 arch/x86/include/asm/module.h |  16 ++++
 arch/x86/kernel/Makefile      |   2 +
 arch/x86/kernel/module-plts.c | 198 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/module.c      |  18 ++--
 arch/x86/kernel/module.lds    |   4 +
 7 files changed, 251 insertions(+), 7 deletions(-)
 create mode 100644 arch/x86/kernel/module-plts.c
 create mode 100644 arch/x86/kernel/module.lds

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b26ee6751021..60d161391d5a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2086,6 +2086,16 @@ config X86_PIE
 	select DEFAULT_HIDDEN
 	select MODULE_REL_CRCS if MODVERSIONS
 
+config X86_MODULE_MODEL_LARGE
+	bool
+	depends on X86_64 && X86_PIE
+
+config X86_MODULE_PLTS
+	bool
+	depends on X86_64
+	select X86_MODULE_MODEL_LARGE
+	select HAVE_MOD_ARCH_SPECIFIC
+
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs"
 	depends on SMP
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 452a9621af8f..72a90da0149a 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -138,10 +138,18 @@ else
         KBUILD_CFLAGS += -mno-red-zone
 ifdef CONFIG_X86_PIE
         KBUILD_CFLAGS += -fPIC
-        KBUILD_CFLAGS_MODULE += -fno-PIC -mcmodel=kernel
+        KBUILD_CFLAGS_MODULE += -fno-PIC
 else
         KBUILD_CFLAGS += -mcmodel=kernel
 endif
+ifdef CONFIG_X86_MODULE_MODEL_LARGE
+        KBUILD_CFLAGS_MODULE += -mcmodel=large
+else
+        KBUILD_CFLAGS_MODULE += -mcmodel=kernel
+endif
+ifdef CONFIG_X86_MODULE_PLTS
+        KBUILD_LDFLAGS_MODULE += -T $(srctree)/arch/x86/kernel/module.lds
+endif
 
         # -funit-at-a-time shrinks the kernel .text considerably
         # unfortunately it makes reading oopses harder.
diff --git a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
index e3b7819caeef..d054c37656ea 100644
--- a/arch/x86/include/asm/module.h
+++ b/arch/x86/include/asm/module.h
@@ -61,4 +61,20 @@
 # define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY
 #endif
 
+#ifdef CONFIG_X86_MODULE_PLTS
+struct mod_plt_sec {
+	struct elf64_shdr	*plt;
+	int			plt_num_entries;
+	int			plt_max_entries;
+};
+
+struct mod_arch_specific {
+	struct mod_plt_sec	core;
+	struct mod_plt_sec	init;
+};
+#endif
+
+u64 module_emit_plt_entry(struct module *mod, void *loc, const Elf64_Rela *rela,
+			  Elf64_Sym *sym);
+
 #endif /* _ASM_X86_MODULE_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index a01892bdd61a..e294aefb747c 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -142,4 +142,6 @@ ifeq ($(CONFIG_X86_64),y)
 
 	obj-$(CONFIG_PCI_MMCONFIG)	+= mmconf-fam10h_64.o
 	obj-y				+= vsmp_64.o
+
+	obj-$(CONFIG_X86_MODULE_PLTS)	+= module-plts.o
 endif
diff --git a/arch/x86/kernel/module-plts.c b/arch/x86/kernel/module-plts.c
new file mode 100644
index 000000000000..bbf11771f424
--- /dev/null
+++ b/arch/x86/kernel/module-plts.c
@@ -0,0 +1,198 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Generate PLT entries for out-of-bound PC-relative relocations. It is required
+ * when a module can be mapped more than 2G away from the kernel.
+ *
+ * Based on arm64 module-plts implementation.
+ */
+
+#include <linux/elf.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sort.h>
+
+/* jmp    QWORD PTR [rip+0xfffffffffffffff2] */
+const u8 jmp_target[] = { 0xFF, 0x25, 0xF2, 0xFF, 0xFF, 0xFF };
+
+struct plt_entry {
+	u64 target;			/* Hold the target address */
+	u8 jmp[sizeof(jmp_target)];	/* jmp opcode to target */
+};
+
+static bool in_init(const struct module *mod, void *loc)
+{
+	return (u64)loc - (u64)mod->init_layout.base < mod->init_layout.size;
+}
+
+u64 module_emit_plt_entry(struct module *mod, void *loc, const Elf64_Rela *rela,
+			  Elf64_Sym *sym)
+{
+	struct mod_plt_sec *pltsec = !in_init(mod, loc) ? &mod->arch.core :
+							  &mod->arch.init;
+	struct plt_entry *plt = (struct plt_entry *)pltsec->plt->sh_addr;
+	int i = pltsec->plt_num_entries;
+	u64 ret;
+
+	/*
+	 * <target address>
+	 * jmp    QWORD PTR [rip+0xfffffffffffffff2] # Target address
+	 */
+	plt[i].target = sym->st_value;
+	memcpy(plt[i].jmp, jmp_target, sizeof(jmp_target));
+
+	/*
+	 * Check if the entry we just created is a duplicate. Given that the
+	 * relocations are sorted, this will be the last entry we allocated.
+	 * (if one exists).
+	 */
+	if (i > 0 && plt[i].target == plt[i - 2].target) {
+		ret = (u64)&plt[i - 1].jmp;
+	} else {
+		pltsec->plt_num_entries++;
+		BUG_ON(pltsec->plt_num_entries > pltsec->plt_max_entries);
+		ret = (u64)&plt[i].jmp;
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
+static unsigned int count_plts(Elf64_Sym *syms, Elf64_Rela *rela, int num,
+			       Elf64_Word dstidx)
+{
+	unsigned int ret = 0;
+	Elf64_Sym *s;
+	int i;
+
+	for (i = 0; i < num; i++) {
+		switch (ELF64_R_TYPE(rela[i].r_info)) {
+		case R_X86_64_PC32:
+			/*
+			 * We only have to consider branch targets that resolve
+			 * to symbols that are defined in a different section.
+			 * This is not simply a heuristic, it is a fundamental
+			 * limitation, since there is no guaranteed way to emit
+			 * PLT entries sufficiently close to the branch if the
+			 * section size exceeds the range of a branch
+			 * instruction. So ignore relocations against defined
+			 * symbols if they live in the same section as the
+			 * relocation target.
+			 */
+			s = syms + ELF64_R_SYM(rela[i].r_info);
+			if (s->st_shndx == dstidx)
+				break;
+
+			/*
+			 * Jump relocations with non-zero addends against
+			 * undefined symbols are supported by the ELF spec, but
+			 * do not occur in practice (e.g., 'jump n bytes past
+			 * the entry point of undefined function symbol f').
+			 * So we need to support them, but there is no need to
+			 * take them into consideration when trying to optimize
+			 * this code. So let's only check for duplicates when
+			 * the addend is zero: this allows us to record the PLT
+			 * entry address in the symbol table itself, rather than
+			 * having to search the list for duplicates each time we
+			 * emit one.
+			 */
+			if (rela[i].r_addend != 0 || !duplicate_rel(rela, i))
+				ret++;
+			break;
+		}
+	}
+	return ret;
+}
+
+int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
+			      char *secstrings, struct module *mod)
+{
+	unsigned long core_plts = 0;
+	unsigned long init_plts = 0;
+	Elf64_Sym *syms = NULL;
+	int i;
+
+	/*
+	 * Find the empty .plt section so we can expand it to store the PLT
+	 * entries. Record the symtab address as well.
+	 */
+	for (i = 0; i < ehdr->e_shnum; i++) {
+		if (!strcmp(secstrings + sechdrs[i].sh_name, ".plt"))
+			mod->arch.core.plt = sechdrs + i;
+		else if (!strcmp(secstrings + sechdrs[i].sh_name, ".init.plt"))
+			mod->arch.init.plt = sechdrs + i;
+		else if (sechdrs[i].sh_type == SHT_SYMTAB)
+			syms = (Elf64_Sym *)sechdrs[i].sh_addr;
+	}
+
+	if (!mod->arch.core.plt || !mod->arch.init.plt) {
+		pr_err("%s: module PLT section(s) missing\n", mod->name);
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
+		Elf64_Shdr *dstsec = sechdrs + sechdrs[i].sh_info;
+
+		if (sechdrs[i].sh_type != SHT_RELA)
+			continue;
+
+		/* sort by type, symbol index and addend */
+		sort(rels, numrels, sizeof(Elf64_Rela), cmp_rela, NULL);
+
+		if (strncmp(secstrings + dstsec->sh_name, ".init", 5) != 0)
+			core_plts += count_plts(syms, rels, numrels,
+						sechdrs[i].sh_info);
+		else
+			init_plts += count_plts(syms, rels, numrels,
+						sechdrs[i].sh_info);
+	}
+
+	mod->arch.core.plt->sh_type = SHT_NOBITS;
+	mod->arch.core.plt->sh_flags = SHF_EXECINSTR | SHF_ALLOC;
+	mod->arch.core.plt->sh_addralign = L1_CACHE_BYTES;
+	mod->arch.core.plt->sh_size = (core_plts  + 1) * sizeof(struct plt_entry);
+	mod->arch.core.plt_num_entries = 0;
+	mod->arch.core.plt_max_entries = core_plts;
+
+	mod->arch.init.plt->sh_type = SHT_NOBITS;
+	mod->arch.init.plt->sh_flags = SHF_EXECINSTR | SHF_ALLOC;
+	mod->arch.init.plt->sh_addralign = L1_CACHE_BYTES;
+	mod->arch.init.plt->sh_size = (init_plts + 1) * sizeof(struct plt_entry);
+	mod->arch.init.plt_num_entries = 0;
+	mod->arch.init.plt_max_entries = init_plts;
+
+	return 0;
+}
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index f67bd3205df7..a2b31973572b 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -186,10 +186,15 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 		case R_X86_64_PC32:
 			val -= (u64)loc;
 			*(u32 *)loc = val;
-#if 0
-			if ((s64)val != *(s32 *)loc)
-				goto overflow;
-#endif
+			if (IS_ENABLED(CONFIG_X86_MODULE_MODEL_LARGE) &&
+			    (s64)val != *(s32 *)loc) {
+				val = module_emit_plt_entry(me, loc, &rel[i],
+							    sym);
+				val -= (u64)loc;
+				*(u32 *)loc = val;
+				if ((s64)val != *(s32 *)loc)
+					goto overflow;
+			}
 			break;
 		default:
 			pr_err("%s: Unknown rela relocation: %llu\n",
@@ -202,8 +207,9 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 overflow:
 	pr_err("overflow in relocation type %d val %Lx\n",
 	       (int)ELF64_R_TYPE(rel[i].r_info), val);
-	pr_err("`%s' likely not compiled with -mcmodel=kernel\n",
-	       me->name);
+	pr_err("`%s' likely not compiled with -mcmodel=%s\n",
+	       me->name,
+	       IS_ENABLED(CONFIG_X86_MODULE_MODEL_LARGE) ? "large" : "kernel");
 	return -ENOEXEC;
 }
 #endif
diff --git a/arch/x86/kernel/module.lds b/arch/x86/kernel/module.lds
new file mode 100644
index 000000000000..f7c9781a9d48
--- /dev/null
+++ b/arch/x86/kernel/module.lds
@@ -0,0 +1,4 @@
+SECTIONS {
+	.plt (NOLOAD) : { BYTE(0) }
+	.init.plt (NOLOAD) : { BYTE(0) }
+}
-- 
2.13.2.932.g7449e964c-goog
