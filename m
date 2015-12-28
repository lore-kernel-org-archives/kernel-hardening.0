Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 28 Dec 2015 12:20:49 +0100
Message-Id: <1451301654-32019-6-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1451301654-32019-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1451301654-32019-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [RFC PATCH 05/10] arm64: add support for module PLTs
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, lkml@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This adds support for emitting PLTs at module load time for relative
branches that are out of range. This is a prerequisite for KASLR,
which may place the kernel and the modules anywhere in the vmalloc
area, making it likely that branch target offsets exceed the maximum
range of +/- 128 MB.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Kconfig              |   4 +
 arch/arm64/Makefile             |   4 +
 arch/arm64/include/asm/module.h |  11 ++
 arch/arm64/kernel/Makefile      |   1 +
 arch/arm64/kernel/module-plts.c | 137 ++++++++++++++++++++
 arch/arm64/kernel/module.c      |   7 +
 arch/arm64/kernel/module.lds    |   4 +
 7 files changed, 168 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 871f21783866..827e78f33944 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -704,6 +704,10 @@ config ARM64_LSE_ATOMICS
 
 endmenu
 
+config ARM64_MODULE_PLTS
+	bool
+	select HAVE_MOD_ARCH_SPECIFIC
+
 endmenu
 
 menu "Boot options"
diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index cd822d8454c0..d4654830e536 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -45,6 +45,10 @@ ifeq ($(CONFIG_ARM64_ERRATUM_843419), y)
 KBUILD_CFLAGS_MODULE	+= -mcmodel=large
 endif
 
+ifeq ($(CONFIG_ARM64_MODULE_PLTS),y)
+KBUILD_LDFLAGS_MODULE	+= -T $(srctree)/arch/arm64/kernel/module.lds
+endif
+
 # Default value
 head-y		:= arch/arm64/kernel/head.o
 
diff --git a/arch/arm64/include/asm/module.h b/arch/arm64/include/asm/module.h
index e80e232b730e..7b8cd3dc9d8e 100644
--- a/arch/arm64/include/asm/module.h
+++ b/arch/arm64/include/asm/module.h
@@ -20,4 +20,15 @@
 
 #define MODULE_ARCH_VERMAGIC	"aarch64"
 
+#ifdef CONFIG_ARM64_MODULE_PLTS
+struct mod_arch_specific {
+	struct elf64_shdr	*core_plt;
+	struct elf64_shdr	*init_plt;
+	int			core_plt_count;
+	int			init_plt_count;
+};
+#endif
+
+u64 get_module_plt(struct module *mod, void *loc, u64 val);
+
 #endif /* __ASM_MODULE_H */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 474691f8b13a..f42b0fff607f 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -30,6 +30,7 @@ arm64-obj-$(CONFIG_COMPAT)		+= sys32.o kuser32.o signal32.o 	\
 					   ../../arm/kernel/opcodes.o
 arm64-obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o entry-ftrace.o
 arm64-obj-$(CONFIG_MODULES)		+= arm64ksyms.o module.o
+arm64-obj-$(CONFIG_ARM64_MODULE_PLTS)	+= module-plts.o
 arm64-obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o perf_callchain.o
 arm64-obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o
 arm64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)	+= hw_breakpoint.o
diff --git a/arch/arm64/kernel/module-plts.c b/arch/arm64/kernel/module-plts.c
new file mode 100644
index 000000000000..b4199f2b4e69
--- /dev/null
+++ b/arch/arm64/kernel/module-plts.c
@@ -0,0 +1,137 @@
+/*
+ * Copyright (C) 2014-2015 Linaro Ltd. <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/elf.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+struct plt_entry {
+	u32	mov0;	/* movn	x16, #0x...., lsl #32		*/
+	u32	mov1;	/* movk	x16, #0x...., lsl #16		*/
+	u32	mov2;	/* movk	x16, #0x....			*/
+	u32	br;	/* br	x16				*/
+};
+
+static bool in_init(const struct module *mod, void *addr)
+{
+	return (u64)addr - (u64)mod->module_init < mod->init_size;
+}
+
+u64 get_module_plt(struct module *mod, void *loc, u64 val)
+{
+	struct plt_entry entry, *plt;
+	int i, *count;
+
+	entry.mov0 = 0x92c00010 | ((~val & 0xffff00000000) >> (32 - 5));
+	entry.mov1 = 0xf2a00010 | (( val & 0xffff0000) >> (16 - 5));
+	entry.mov2 = 0xf2800010 | (( val & 0xffff) << 5);
+	entry.br   = 0xd61f0200;
+
+	if (in_init(mod, loc)) {
+		plt = (struct plt_entry *)mod->arch.init_plt->sh_addr;
+		count = &mod->arch.init_plt_count;
+	} else {
+		plt = (struct plt_entry *)mod->arch.core_plt->sh_addr;
+		count = &mod->arch.core_plt_count;
+	}
+
+	/* Look for an existing entry pointing to 'val' */
+	for (i = 0; i < *count; i++)
+		if (plt[i].mov2 == entry.mov2 &&
+		    plt[i].mov1 == entry.mov1 &&
+		    plt[i].mov0 == entry.mov0)
+			return (u64)&plt[i];
+
+	i = (*count)++;
+	plt[i] = entry;
+	return (u64)&plt[i];
+}
+
+static int duplicate_rel(Elf64_Addr base, const Elf64_Rela *rela, int num)
+{
+	int i;
+
+	for (i = 0; i < num; i++) {
+		if (rela[i].r_info == rela[num].r_info &&
+		    rela[i].r_addend == rela[num].r_addend)
+			return 1;
+	}
+	return 0;
+}
+
+/* Count how many PLT entries we may need */
+static unsigned int count_plts(Elf64_Addr base, const Elf64_Rela *rela, int num)
+{
+	unsigned int ret = 0;
+	int i;
+
+	/*
+	 * Sure, this is order(n^2), but it's usually short, and not
+	 * time critical
+	 */
+	for (i = 0; i < num; i++)
+		switch (ELF64_R_TYPE(rela[i].r_info)) {
+		case R_AARCH64_JUMP26:
+		case R_AARCH64_CALL26:
+			if (!duplicate_rel(base, rela, i))
+				ret++;
+			break;
+		}
+	return ret;
+}
+
+int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
+			      char *secstrings, struct module *mod)
+{
+	unsigned long core_plts = 0, init_plts = 0;
+	Elf64_Shdr *s, *sechdrs_end = sechdrs + ehdr->e_shnum;
+
+	/*
+	 * To store the PLTs, we expand the .text section for core module code
+	 * and the .init.text section for initialization code.
+	 */
+	for (s = sechdrs; s < sechdrs_end; ++s)
+		if (strcmp(".core.plt", secstrings + s->sh_name) == 0)
+			mod->arch.core_plt = s;
+		else if (strcmp(".init.plt", secstrings + s->sh_name) == 0)
+			mod->arch.init_plt = s;
+
+	if (!mod->arch.core_plt || !mod->arch.init_plt) {
+		pr_err("%s: sections missing\n", mod->name);
+		return -ENOEXEC;
+	}
+
+	for (s = sechdrs + 1; s < sechdrs_end; ++s) {
+		const Elf64_Rela *rels = (void *)ehdr + s->sh_offset;
+		int numrels = s->sh_size / sizeof(Elf64_Rela);
+		Elf64_Shdr *dstsec = sechdrs + s->sh_info;
+
+		if (s->sh_type != SHT_RELA)
+			continue;
+
+		if (strstr(secstrings + s->sh_name, ".init"))
+			init_plts += count_plts(dstsec->sh_addr, rels, numrels);
+		else
+			core_plts += count_plts(dstsec->sh_addr, rels, numrels);
+	}
+
+	mod->arch.core_plt->sh_type = SHT_NOBITS;
+	mod->arch.core_plt->sh_flags = SHF_EXECINSTR | SHF_ALLOC;
+	mod->arch.core_plt->sh_addralign = L1_CACHE_BYTES;
+	mod->arch.core_plt->sh_size = core_plts * sizeof(struct plt_entry);
+	mod->arch.core_plt_count = 0;
+
+	mod->arch.init_plt->sh_type = SHT_NOBITS;
+	mod->arch.init_plt->sh_flags = SHF_EXECINSTR | SHF_ALLOC;
+	mod->arch.init_plt->sh_addralign = L1_CACHE_BYTES;
+	mod->arch.init_plt->sh_size = init_plts * sizeof(struct plt_entry);
+	mod->arch.init_plt_count = 0;
+	pr_debug("%s: core.plt=%lld, init.plt=%lld\n", __func__,
+		 mod->arch.core_plt->sh_size, mod->arch.init_plt->sh_size);
+	return 0;
+}
diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index f4bc779e62e8..14880d77ec6f 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -388,6 +388,13 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 		case R_AARCH64_CALL26:
 			ovf = reloc_insn_imm(RELOC_OP_PREL, loc, val, 2, 26,
 					     AARCH64_INSN_IMM_26);
+
+			if (IS_ENABLED(CONFIG_ARM64_MODULE_PLTS) &&
+			    ovf == -ERANGE) {
+				val = get_module_plt(me, loc, val);
+				ovf = reloc_insn_imm(RELOC_OP_PREL, loc, val, 2,
+						     26, AARCH64_INSN_IMM_26);
+			}
 			break;
 
 		default:
diff --git a/arch/arm64/kernel/module.lds b/arch/arm64/kernel/module.lds
new file mode 100644
index 000000000000..3682fa107918
--- /dev/null
+++ b/arch/arm64/kernel/module.lds
@@ -0,0 +1,4 @@
+SECTIONS {
+        .core.plt : { BYTE(0) }
+        .init.plt : { BYTE(0) }
+}
-- 
2.5.0
