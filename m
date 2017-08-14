From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 14 Aug 2017 13:54:06 +0100
Message-Id: <20170814125411.22604-26-ard.biesheuvel@linaro.org>
In-Reply-To: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 25/30] ARM: compressed: factor out zImage header and make it extensible
To: kernel-hardening@lists.openwall.com
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

To prepare for adding metadata to the zImage to put KASLR randomization
under the control of the bootloader, factor out the zImage header, and
make it extensible by adding two new fields: a magic number that cannot
be mistaken for a valid instruction, to prevent misidentification, and
an offset into the binary where an array of optional headers is placed.

Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/boot/compressed/head.S        |  7 +---
 arch/arm/boot/compressed/vmlinux.lds.S |  5 ++-
 arch/arm/include/asm/zimage.h          | 39 ++++++++++++++++++++
 3 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 583cc6899d98..e451738d8954 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -11,6 +11,7 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 #include <asm/v7m.h>
+#include <asm/zimage.h>
 
 #include "efi-header.S"
 
@@ -139,11 +140,7 @@ start:
 #endif
 		W(b)	1f
 
-		.word	_magic_sig	@ Magic numbers to help the loader
-		.word	_magic_start	@ absolute load/run zImage address
-		.word	_magic_end	@ zImage end address
-		.word	0x04030201	@ endianness flag
-
+		__ZIMAGE_HEADER
 		__EFI_HEADER
 1:
  ARM_BE8(	setend	be		)	@ go BE8 if compiled for BE8
diff --git a/arch/arm/boot/compressed/vmlinux.lds.S b/arch/arm/boot/compressed/vmlinux.lds.S
index 81c493156ce8..27696bc315d3 100644
--- a/arch/arm/boot/compressed/vmlinux.lds.S
+++ b/arch/arm/boot/compressed/vmlinux.lds.S
@@ -6,6 +6,8 @@
  * published by the Free Software Foundation.
  */
 
+#include <asm/zimage.h>
+
 #ifdef CONFIG_CPU_ENDIAN_BE8
 #define ZIMAGE_MAGIC(x) ( (((x) >> 24) & 0x000000ff) | \
 			  (((x) >>  8) & 0x0000ff00) | \
@@ -72,9 +74,10 @@ SECTIONS
   .pad			: { BYTE(0); . = ALIGN(8); }
   _edata = .;
 
-  _magic_sig = ZIMAGE_MAGIC(0x016f2818);
+  _magic_sig = ZIMAGE_MAGIC(ZIMAGE_HEADER_MAGIC);
   _magic_start = ZIMAGE_MAGIC(_start);
   _magic_end = ZIMAGE_MAGIC(_edata);
+  _magic_opt_sig = ZIMAGE_MAGIC(ZIMAGE_OPTIONAL_HEADER_MAGIC);
 
   . = BSS_START;
   __bss_start = .;
diff --git a/arch/arm/include/asm/zimage.h b/arch/arm/include/asm/zimage.h
new file mode 100644
index 000000000000..ff65cc3bb716
--- /dev/null
+++ b/arch/arm/include/asm/zimage.h
@@ -0,0 +1,39 @@
+/*
+ * Copyright (C) 2017 Linaro Ltd;  <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __ASM_ZIMAGE_H
+#define __ASM_ZIMAGE_H
+
+#define ZIMAGE_HEADER_MAGIC		0x016f2818
+#define ZIMAGE_OPTIONAL_HEADER_MAGIC	0xe7fedef0
+
+#if defined(__ASSEMBLY__) && !defined(LINKER_SCRIPT)
+
+	.macro		__ZIMAGE_HEADER
+	.word		_magic_sig	@ Magic numbers to help the loader
+	.word		_magic_start	@ absolute load/run zImage address
+	.word		_magic_end	@ zImage end address
+	.word		0x04030201	@ endianness flag
+
+	/* optional headers */
+	.word		_magic_opt_sig	@ optional header magic number
+	.word		__zimage_opt_header - .
+
+	.pushsection	".rodata", "a", %progbits
+__zimage_opt_header:
+	/*
+	 * Each header starts with a u16[2] containing id and size of the
+	 * entire header, including the u16[] itself.
+	 */
+	.long		0xffffffff	@ end of optional headers
+	.popsection
+	.endm
+
+#endif
+#endif
-- 
2.11.0
