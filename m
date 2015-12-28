Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 28 Dec 2015 12:20:51 +0100
Message-Id: <1451301654-32019-8-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1451301654-32019-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1451301654-32019-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [RFC PATCH 07/10] arm64: use assembly time constants for Image header fields
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, lkml@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Unfortunately, using the linker to emit build time constants into
the Image header will no longer work once we switch to the use of
PIE executables. The reason is that such constants are emitted into
the binary using R_AARCH64_ABS64 relocations, which we will resolve
at runtime, not at build time, and the places targeted by those
relocations will contain zeroes before that.

So move back to assembly time constants. These will be emitted in the
endianness of the target binary, so we will need a post-link fixup
step to byte swap the header fields.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/boot/Makefile        |  1 +
 arch/arm64/kernel/head.S        | 32 ++++++++++------
 arch/arm64/kernel/image.h       | 40 --------------------
 arch/arm64/kernel/vmlinux.lds.S |  2 -
 scripts/arm64fixhdr.pl          | 25 ++++++++++++
 5 files changed, 46 insertions(+), 54 deletions(-)

diff --git a/arch/arm64/boot/Makefile b/arch/arm64/boot/Makefile
index abcbba2f01ba..b2da54b4b796 100644
--- a/arch/arm64/boot/Makefile
+++ b/arch/arm64/boot/Makefile
@@ -18,6 +18,7 @@ targets := Image Image.gz
 
 $(obj)/Image: vmlinux FORCE
 	$(call if_changed,objcopy)
+	@$(srctree)/scripts/arm64fixhdr.pl $@
 
 $(obj)/Image.bz2: $(obj)/Image FORCE
 	$(call if_changed,bzip2)
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 6434c844a0e4..a03ffffd84cb 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -51,6 +51,17 @@
 #define KERNEL_START	_text
 #define KERNEL_END	_end
 
+#ifdef CONFIG_CPU_BIG_ENDIAN
+#define __HEAD_FLAG_BE	1
+#else
+#define __HEAD_FLAG_BE	0
+#endif
+
+#define __HEAD_FLAG_PAGE_SIZE ((PAGE_SHIFT - 10) / 2)
+
+#define __HEAD_FLAGS	((__HEAD_FLAG_BE << 0) |	\
+			 (__HEAD_FLAG_PAGE_SIZE << 1))
+
 /*
  * Kernel startup entry point.
  * ---------------------------
@@ -67,12 +78,12 @@
  * in the entry routines.
  */
 	__HEAD
+_head:
 
 	/*
 	 * DO NOT MODIFY. Image header expected by Linux boot-loaders.
 	 */
 #ifdef CONFIG_EFI
-efi_head:
 	/*
 	 * This add instruction has no meaningful effect except that
 	 * its opcode forms the magic "MZ" signature required by UEFI.
@@ -83,25 +94,22 @@ efi_head:
 	b	stext				// branch to kernel start, magic
 	.long	0				// reserved
 #endif
-	.quad	_kernel_offset_le		// Image load offset from start of RAM, little-endian
-	.quad	_kernel_size_le			// Effective size of kernel image, little-endian
-	.quad	_kernel_flags_le		// Informative flags, little-endian
+	.quad	TEXT_OFFSET			// Image load offset from start of RAM, little-endian
+	.quad	_end - _head			// Effective size of kernel image, little-endian
+	.quad	__HEAD_FLAGS			// Informative flags, little-endian
 	.quad	0				// reserved
 	.quad	0				// reserved
 	.quad	0				// reserved
-	.byte	0x41				// Magic number, "ARM\x64"
-	.byte	0x52
-	.byte	0x4d
-	.byte	0x64
+	.long	0x644d5241			// Magic number, "ARM\x64"
 #ifdef CONFIG_EFI
-	.long	pe_header - efi_head		// Offset to the PE header.
+	.long	pe_header - _head		// Offset to the PE header.
 #else
 	.word	0				// reserved
 #endif
 
 #ifdef CONFIG_EFI
 	.globl	__efistub_stext_offset
-	.set	__efistub_stext_offset, stext - efi_head
+	.set	__efistub_stext_offset, stext - _head
 	.align 3
 pe_header:
 	.ascii	"PE"
@@ -124,7 +132,7 @@ optional_header:
 	.long	_end - stext			// SizeOfCode
 	.long	0				// SizeOfInitializedData
 	.long	0				// SizeOfUninitializedData
-	.long	__efistub_entry - efi_head	// AddressOfEntryPoint
+	.long	__efistub_entry - _head		// AddressOfEntryPoint
 	.long	__efistub_stext_offset		// BaseOfCode
 
 extra_header_fields:
@@ -139,7 +147,7 @@ extra_header_fields:
 	.short	0				// MinorSubsystemVersion
 	.long	0				// Win32VersionValue
 
-	.long	_end - efi_head			// SizeOfImage
+	.long	_end - _head			// SizeOfImage
 
 	// Everything before the kernel image is considered part of the header
 	.long	__efistub_stext_offset		// SizeOfHeaders
diff --git a/arch/arm64/kernel/image.h b/arch/arm64/kernel/image.h
index bc2abb8b1599..5f34770ba924 100644
--- a/arch/arm64/kernel/image.h
+++ b/arch/arm64/kernel/image.h
@@ -22,46 +22,6 @@
 #error This file should only be included in vmlinux.lds.S
 #endif
 
-/*
- * There aren't any ELF relocations we can use to endian-swap values known only
- * at link time (e.g. the subtraction of two symbol addresses), so we must get
- * the linker to endian-swap certain values before emitting them.
- */
-#ifdef CONFIG_CPU_BIG_ENDIAN
-#define DATA_LE64(data)					\
-	((((data) & 0x00000000000000ff) << 56) |	\
-	 (((data) & 0x000000000000ff00) << 40) |	\
-	 (((data) & 0x0000000000ff0000) << 24) |	\
-	 (((data) & 0x00000000ff000000) << 8)  |	\
-	 (((data) & 0x000000ff00000000) >> 8)  |	\
-	 (((data) & 0x0000ff0000000000) >> 24) |	\
-	 (((data) & 0x00ff000000000000) >> 40) |	\
-	 (((data) & 0xff00000000000000) >> 56))
-#else
-#define DATA_LE64(data) ((data) & 0xffffffffffffffff)
-#endif
-
-#ifdef CONFIG_CPU_BIG_ENDIAN
-#define __HEAD_FLAG_BE	1
-#else
-#define __HEAD_FLAG_BE	0
-#endif
-
-#define __HEAD_FLAG_PAGE_SIZE ((PAGE_SHIFT - 10) / 2)
-
-#define __HEAD_FLAGS	((__HEAD_FLAG_BE << 0) |	\
-			 (__HEAD_FLAG_PAGE_SIZE << 1))
-
-/*
- * These will output as part of the Image header, which should be little-endian
- * regardless of the endianness of the kernel. While constant values could be
- * endian swapped in head.S, all are done here for consistency.
- */
-#define HEAD_SYMBOLS						\
-	_kernel_size_le		= DATA_LE64(_end - _text);	\
-	_kernel_offset_le	= DATA_LE64(TEXT_OFFSET);	\
-	_kernel_flags_le	= DATA_LE64(__HEAD_FLAGS);
-
 #ifdef CONFIG_EFI
 
 /*
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 363c2f529951..69dfa376e843 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -171,8 +171,6 @@ SECTIONS
 	_end = .;
 
 	STABS_DEBUG
-
-	HEAD_SYMBOLS
 }
 
 /*
diff --git a/scripts/arm64fixhdr.pl b/scripts/arm64fixhdr.pl
new file mode 100755
index 000000000000..09895f412e5d
--- /dev/null
+++ b/scripts/arm64fixhdr.pl
@@ -0,0 +1,25 @@
+#!/usr/bin/perl -w
+
+# Copyright (C) 2015 Linaro Ltd <ard.biesheuvel@linaro.org>
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2 as
+# published by the Free Software Foundation.
+
+use strict;
+
+undef $/;
+
+my $image = "arch/arm64/boot/Image";
+$image = $ARGV[0] if ($ARGV[0]);
+
+open(my $INFILE, "<", $image) or die("Failed to open $image for reading\n");
+my ($c,$to,$is,$fl,$r2,$r3,$r4,$magic,$pe) = unpack("Q<7L<2", <$INFILE>);
+close($INFILE);
+
+exit 0 if ($magic == 0x644d5241);
+die sprintf("ERROR: incorrect magic 0x%x\n",$magic) if ($magic != 0x41524d64);
+
+open(my $OUTFILE, "+<", $image) or die("Failed to open $image for writing\n");
+print $OUTFILE pack("Q<Q>6L>2",$c,$to,$is,$fl,$r2,$r3,$r4,$magic,$pe);
+close($OUTFILE);
-- 
2.5.0
