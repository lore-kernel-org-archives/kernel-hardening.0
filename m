From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 14 Aug 2017 13:53:59 +0100
Message-Id: <20170814125411.22604-19-ard.biesheuvel@linaro.org>
In-Reply-To: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 18/30] ARM: kernel: make vmlinux buildable as a PIE executable
To: kernel-hardening@lists.openwall.com
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Update the build flags and linker script to allow vmlinux to be build
as a PIE  binary, which retains relocation information about absolute
symbol references so that they can be fixed up at runtime. This will
be used for implementing KASLR,

Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/Kconfig                 |  4 ++++
 arch/arm/Makefile                |  5 +++++
 arch/arm/include/asm/assembler.h |  7 ++++++-
 arch/arm/kernel/vmlinux.lds.S    |  9 +++++++++
 include/linux/hidden.h           | 21 ++++++++++++++++++++
 5 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 61a0cb15067e..300add3b8023 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2085,6 +2085,10 @@ config DMI
 	  firmware need to be enabled. This would require the DMI subsystem
 	  to be enabled much earlier than we do on ARM, which is non-trivial.
 
+config RELOCATABLE
+	bool
+	select HAVE_ARCH_PREL32_RELOCATIONS
+
 endmenu
 
 menu "CPU Power Management"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 47d3a1ab08d2..88d9c33e24f5 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -52,6 +52,11 @@ AS		+= -EL
 LD		+= -EL
 endif
 
+ifeq ($(CONFIG_RELOCATABLE),y)
+KBUILD_CFLAGS	+= -include $(srctree)/include/linux/hidden.h -fpic
+LDFLAGS_vmlinux	+= -pie -shared -Bsymbolic
+endif
+
 #
 # The Scalar Replacement of Aggregates (SRA) optimization pass in GCC 4.9 and
 # later may result in code being generated that handles signed short and signed
diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 09b6b28f2595..b2254c1dc2de 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -550,7 +550,12 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
 	 * mov_l - move a constant value or [relocated] address into a register
 	 */
 	.macro		mov_l, dst:req, imm:req, cond
-	.if		__LINUX_ARM_ARCH__ < 7
+	.if		CONFIG_RELOCATABLE == 1
+	ldr_l		\dst, 333f, \cond
+	.section	".data.rel.ro.local", "aw", %progbits
+333:	.long		\imm
+	.previous
+	.elseif		__LINUX_ARM_ARCH__ < 7
 	ldr\cond	\dst, =\imm
 	.else
 	W(movw\cond\())	\dst, #:lower16:\imm
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index c83a7ba737d6..5853d4be2067 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -89,6 +89,9 @@ SECTIONS
 #endif
 		*(.discard)
 		*(.discard.*)
+		*(.ARM.exidx.discard.text)
+		*(.interp .dynamic)
+		*(.dynsym .dynstr .hash)
 	}
 
 	. = PAGE_OFFSET + TEXT_OFFSET;
@@ -209,6 +212,12 @@ SECTIONS
 		__smpalt_end = .;
 	}
 #endif
+	.rel.dyn : ALIGN(8) {
+		__rel_begin = .;
+		*(.rel .rel.* .rel.dyn)
+	}
+	__rel_end = ADDR(.rel.dyn) + SIZEOF(.rel.dyn);
+
 	.init.pv_table : {
 		__pv_table_begin = .;
 		*(.pv_table)
diff --git a/include/linux/hidden.h b/include/linux/hidden.h
new file mode 100644
index 000000000000..49b7823eed6e
--- /dev/null
+++ b/include/linux/hidden.h
@@ -0,0 +1,21 @@
+
+/*
+ * GCC assumes that we are building shared libraries or hosted binaries
+ * when the -fpic or -fpie switches are used. This results in all references
+ * to symbols with external linkage to be redirected via entries in the global
+ * offset table (GOT), which keeps .text pages clean and reduces the footprint
+ * of CoWed dirty pages to the GOT itself. It also allows symbol preemption,
+ * which is mandatory under ELF rules for shared libraries.
+ *
+ * For the kernel, we use PIC so that we can relocate the executable image at
+ * runtime. This does not involve CoW or symbol preemption, and we'd rather
+ * have relative references instead of absolute ones whenever possible.
+ * So set the default visibility to hidden: this informs the compiler that
+ * none of our symbols will ever be exported from a shared library, allowing
+ * it to use relative references where possible.
+ *
+ * Note that simply passing -fvisibility=hidden is not sufficient to achieve
+ * this: In that case, definitions will be marked hidden, but declarations
+ * will not, and we still end up with GOT entries unnecessarily.
+ */
+#pragma GCC visibility push(hidden)
-- 
2.11.0
