From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC/PoC PATCH 2/3] gcc: plugins: add ROP shield plugin for arm64
Date: Thu,  2 Aug 2018 15:21:31 +0200
Message-Id: <20180802132133.23999-3-ard.biesheuvel@linaro.org>
In-Reply-To: <20180802132133.23999-1-ard.biesheuvel@linaro.org>
References: <20180802132133.23999-1-ard.biesheuvel@linaro.org>
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, christoffer.dall@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, labbott@fedoraproject.org, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Add a plugin that mangles every 'ret' instruction so bit 55 in the
stack pointer register is cleared first, and every 'bl' or 'blr'
instruction so that the bit is set again right after the call
returns. This should make it very difficult for ROP attacks to be
staged, given that the supply of gadgets is now reduced to those
that start with the 'reset bit #55' sequence, which only occurs right
after a function return when all caller save registers are dead.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/Kconfig                                  |   4 +
 drivers/firmware/efi/libstub/Makefile         |   3 +-
 scripts/Makefile.gcc-plugins                  |   7 ++
 scripts/gcc-plugins/arm64_rop_shield_plugin.c | 116 ++++++++++++++++++++
 4 files changed, 129 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 1aa59063f1fd..d61d1249d986 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -549,6 +549,10 @@ config GCC_PLUGIN_RANDSTRUCT_PERFORMANCE
 	  in structures.  This reduces the performance hit of RANDSTRUCT
 	  at the cost of weakened randomization.
 
+config GCC_PLUGIN_ARM64_ROP_SHIELD
+	bool
+	depends on GCC_PLUGINS && ARM64
+
 config HAVE_STACKPROTECTOR
 	bool
 	help
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index a34e9290a699..9b1510e5957f 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -20,7 +20,8 @@ cflags-$(CONFIG_EFI_ARMSTUB)	+= -I$(srctree)/scripts/dtc/libfdt
 KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
 				   -D__NO_FORTIFY \
 				   $(call cc-option,-ffreestanding) \
-				   $(call cc-option,-fno-stack-protector)
+				   $(call cc-option,-fno-stack-protector) \
+				   $(DISABLE_ARM64_ROP_SHIELD_PLUGIN)
 
 GCOV_PROFILE			:= n
 KASAN_SANITIZE			:= n
diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index c961b9a65d11..f4f9c27fb3a0 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -17,10 +17,17 @@ gcc-plugin-$(CONFIG_GCC_PLUGIN_RANDSTRUCT)	+= randomize_layout_plugin.so
 gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_RANDSTRUCT)	+= -DRANDSTRUCT_PLUGIN
 gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_RANDSTRUCT_PERFORMANCE)	+= -fplugin-arg-randomize_layout_plugin-performance-mode
 
+ifdef CONFIG_GCC_PLUGIN_ARM64_ROP_SHIELD
+gcc-plugin-y				+= arm64_rop_shield_plugin.so
+gcc-plugin-cflags-y			+= -DARM64_ROP_SHIELD_PLUGIN
+DISABLE_ARM64_ROP_SHIELD_PLUGIN		+= -fplugin-arg-arm64_rop_shield_plugin-disable
+endif
+
 GCC_PLUGINS_CFLAGS := $(strip $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
 
 export GCC_PLUGINS_CFLAGS GCC_PLUGIN GCC_PLUGIN_SUBDIR
 export DISABLE_LATENT_ENTROPY_PLUGIN
+export DISABLE_ARM64_ROP_SHIELD_PLUGIN
 
 # sancov_plugin.so can be only in CFLAGS_KCOV because avoid duplication.
 GCC_PLUGINS_CFLAGS := $(filter-out %/sancov_plugin.so, $(GCC_PLUGINS_CFLAGS))
diff --git a/scripts/gcc-plugins/arm64_rop_shield_plugin.c b/scripts/gcc-plugins/arm64_rop_shield_plugin.c
new file mode 100644
index 000000000000..e87f4a9b9ab0
--- /dev/null
+++ b/scripts/gcc-plugins/arm64_rop_shield_plugin.c
@@ -0,0 +1,116 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2018 Ard Biesheuvel <ard.biesheuvel@linaro.org>
+ */
+
+#include "gcc-common.h"
+
+__visible int plugin_is_GPL_compatible;
+
+static unsigned int arm64_rop_shield_execute(void)
+{
+	rtx_insn *insn;
+	rtx body, x, y;
+
+	for (insn = get_insns(); insn; insn = NEXT_INSN(insn)) {
+		if (JUMP_P(insn)) {
+			body = PATTERN(insn);
+
+			if (GET_CODE(body) != RETURN)
+				continue;
+
+			x = gen_rtx_ASM_OPERANDS(VOIDmode,
+						 "mov	x16, sp		   \n\t"
+						 "and	sp, x16, #~(1 << 55)",
+						 "",
+						 0,
+						 rtvec_alloc(0),
+						 rtvec_alloc(0),
+						 rtvec_alloc(0),
+						 UNKNOWN_LOCATION);
+			MEM_VOLATILE_P(x) = true;
+
+			/*
+			 * According to the AAPCS spec, x16 may only be used by
+			 * subroutine calls that are exposed via a jump/call
+			 * ELF relocation, and so the compiler may assume it is
+			 * preserved across a call to a function in the same
+			 * compilation unit. So mark x16 as clobbered
+			 * explicitly.
+			 */
+			y = gen_rtx_CLOBBER(VOIDmode, gen_rtx_REG(Pmode, 16));
+
+			emit_insn_before(gen_rtx_PARALLEL(VOIDmode,
+							  gen_rtvec(2, x, y)),
+					 insn);
+		}
+
+		if (CALL_P(insn)) {
+			rtx_insn *next;
+
+			/*
+			 * We can use x30 here without marking it as clobbered.
+			 * The bl instruction already clobbers it, and whether
+			 * we returned here via a plain 'ret' instruction or via
+			 * some other way is unspecified, so it is no longer
+			 * live when we get here.
+			 */
+			x = gen_rtx_ASM_OPERANDS(VOIDmode,
+						 "mov	x30, sp		   \n\t"
+						 "orr	sp, x30, #(1 << 55)",
+						 "",
+						 0,
+						 rtvec_alloc(0),
+						 rtvec_alloc(0),
+						 rtvec_alloc(0),
+						 UNKNOWN_LOCATION);
+			MEM_VOLATILE_P(x) = true;
+
+			next = NEXT_INSN(insn);
+			if (NOTE_P(next))
+				insn = next;
+
+			emit_insn_after(x, insn);
+		}
+	}
+	return 0;
+}
+
+#define PASS_NAME arm64_rop_shield
+
+#define NO_GATE
+#define TODO_FLAGS_FINISH TODO_dump_func
+#include "gcc-generate-rtl-pass.h"
+
+__visible int plugin_init(struct plugin_name_args *plugin_info,
+			  struct plugin_gcc_version *version)
+{
+	const struct plugin_argument *argv = plugin_info->argv;
+	int argc = plugin_info->argc;
+	bool enable = true;
+	int i;
+
+	if (!plugin_default_version_check(version, &gcc_version)) {
+		error(G_("incompatible gcc/plugin versions"));
+		return 1;
+	}
+
+	PASS_INFO(arm64_rop_shield, "shorten", 1, PASS_POS_INSERT_BEFORE);
+
+	for (i = 0; i < argc; i++) {
+		if (!strcmp(argv[i].key, "disable")) {
+			enable = false;
+			continue;
+		}
+		error(G_("unknown option '-fplugin-arg-%s-%s'"),
+		      plugin_info->base_name, argv[i].key);
+	}
+
+	if (!enable)
+		return 0;
+
+	register_callback(plugin_info->base_name, PLUGIN_PASS_MANAGER_SETUP,
+			  NULL, &arm64_rop_shield_pass_info);
+
+	return 0;
+}
-- 
2.18.0
