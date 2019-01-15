From: Ruslan Nikolaev <nruslan_devel@yahoo.com>
Subject: [PATCH v1 05/06]: Retpoline thunks for PIC modules
Message-ID: <851687ba-39a8-2b97-1b7f-51ab87f4b105@yahoo.com>
Date: Tue, 15 Jan 2019 14:02:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: kernel-hardening@lists.openwall.com
Cc: thgarnie@google.com, x86@kernel.org, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Retpoline thunks for PIC modules

The patch is by Hassan Nadeem and Ruslan Nikolaev. This extends
the prior PIE kernel patch (by Thomas Garnier) to also support
position-independent modules that can be placed anywhere in the
48/64-bit address space (for better KASLR).

Signed-off-by: Ruslan Nikolaev <nruslan_devel@yahoo.com>
---
  Makefile    |    3 +++
  retpoline.S |   47 +++++++++++++++++++++++++++++++++++++++++++++++
  2 files changed, 50 insertions(+)

diff -uprN a/arch/x86/module-lib/Makefile b/arch/x86/module-lib/Makefile
--- a/arch/x86/module-lib/Makefile	1969-12-31 19:00:00.000000000 -0500
+++ b/arch/x86/module-lib/Makefile	2019-01-15 11:32:46.721911879 -0500
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_RETPOLINE) += retpoline.o
\ No newline at end of file
diff -uprN a/arch/x86/module-lib/retpoline.S 
b/arch/x86/module-lib/retpoline.S
--- a/arch/x86/module-lib/retpoline.S	1969-12-31 19:00:00.000000000 -0500
+++ b/arch/x86/module-lib/retpoline.S	2019-01-15 11:32:46.721911879 -0500
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <linux/stringify.h>
+#include <linux/linkage.h>
+#include <asm/dwarf2.h>
+#include <asm/cpufeatures.h>
+#include <asm/alternative-asm.h>
+#include <asm/export.h>
+#include <asm/nospec-branch.h>
+
+.macro THUNK reg
+	.section .text.__x86.indirect_thunk
+
+ENTRY(__x86_indirect_thunk_\reg)
+	CFI_STARTPROC
+	JMP_NOSPEC %\reg
+	CFI_ENDPROC
+ENDPROC(__x86_indirect_thunk_\reg)
+.endm
+
+/*
+ * Despite being an assembler file we can't just use .irp here
+ * because __KSYM_DEPS__ only uses the C preprocessor and would
+ * only see one instance of "__x86_indirect_thunk_\reg" rather
+ * than one per register with the correct names. So we do it
+ * the simple and nasty way...
+ */
+#define GENERATE_THUNK(reg) THUNK reg
+
+GENERATE_THUNK(_ASM_AX)
+GENERATE_THUNK(_ASM_BX)
+GENERATE_THUNK(_ASM_CX)
+GENERATE_THUNK(_ASM_DX)
+GENERATE_THUNK(_ASM_SI)
+GENERATE_THUNK(_ASM_DI)
+GENERATE_THUNK(_ASM_BP)
+#ifdef CONFIG_64BIT
+GENERATE_THUNK(r8)
+GENERATE_THUNK(r9)
+GENERATE_THUNK(r10)
+GENERATE_THUNK(r11)
+GENERATE_THUNK(r12)
+GENERATE_THUNK(r13)
+GENERATE_THUNK(r14)
+GENERATE_THUNK(r15)
+#endif
+
