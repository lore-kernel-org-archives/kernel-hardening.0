From: Ruslan Nikolaev <nruslan_devel@yahoo.com>
Subject: [PATCH v1 04/06]: The PLT stub for PIC modules
Message-ID: <6a7e9f8a-75e1-c9a2-94c2-471e8d0ce85c@yahoo.com>
Date: Tue, 15 Jan 2019 14:01:06 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: kernel-hardening@lists.openwall.com
Cc: thgarnie@google.com, x86@kernel.org, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

The PLT stub for PIC modules

The patch is by Hassan Nadeem and Ruslan Nikolaev. This extends
the prior PIE kernel patch (by Thomas Garnier) to also support
position-independent modules that can be placed anywhere in the
48/64-bit address space (for better KASLR).

Signed-off-by: Ruslan Nikolaev <nruslan_devel@yahoo.com>
---
  Makefile          |    3 ++-
  module-plt-stub.S |   23 +++++++++++++++++++++++
  2 files changed, 25 insertions(+), 1 deletion(-)

diff -uprN a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile	2019-01-15 11:20:45.271168382 -0500
+++ b/arch/x86/kernel/Makefile	2019-01-15 11:30:12.576999665 -0500
@@ -104,7 +104,8 @@ obj-$(CONFIG_KEXEC_CORE)	+= relocate_ker
  obj-$(CONFIG_KEXEC_FILE)	+= kexec-bzimage64.o
  obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
  obj-y				+= kprobes/
-obj-$(CONFIG_MODULES)		+= module.o
+obj-$(CONFIG_MODULES)		+= module.o module-plt-stub.o
+OBJECT_FILES_NON_STANDARD_module-plt-stub.o := y
  obj-$(CONFIG_DOUBLEFAULT)	+= doublefault.o
  obj-$(CONFIG_KGDB)		+= kgdb.o
  obj-$(CONFIG_VM86)		+= vm86_32.o
diff -uprN a/arch/x86/kernel/module-plt-stub.S 
b/arch/x86/kernel/module-plt-stub.S
--- a/arch/x86/kernel/module-plt-stub.S	1969-12-31 19:00:00.000000000 -0500
+++ b/arch/x86/kernel/module-plt-stub.S	2019-01-15 11:30:12.580999706 -0500
@@ -0,0 +1,23 @@
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
+/* The following code is used for PLT generation only
+   and should never be executed directly. */
+.section .rodata
+.globl __THUNK_FOR_PLT
+.globl __THUNK_FOR_PLT_SIZE
+__THUNK_FOR_PLT:
+#ifdef CONFIG_RETPOLINE
+	movq 0(%rip), %rax
+	JMP_NOSPEC %rax
+#else
+	jmpq   *0(%rip)
+#endif
+__THUNK_FOR_PLT_SIZE: .long . - __THUNK_FOR_PLT
