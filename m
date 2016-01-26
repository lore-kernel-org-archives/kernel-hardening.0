Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 26 Jan 2016 18:10:38 +0100
Message-Id: <1453828249-14467-12-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v4 11/22] arm64: avoid R_AARCH64_ABS64 relocations for Image header fields
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, labbott@fedoraproject.org, matt@codeblueprint.co.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Unfortunately, the current way of using the linker to emit build time
constants into the Image header will no longer work once we switch to
the use of PIE executables. The reason is that such constants are emitted
into the binary using R_AARCH64_ABS64 relocations, which are resolved at
runtime, not at build time, and the places targeted by those relocations
will contain zeroes before that.

So refactor the endian swapping linker script constant generation code so
that it emits the upper and lower 32-bit words separately.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/assembler.h | 11 +++++++
 arch/arm64/kernel/head.S           |  6 ++--
 arch/arm64/kernel/image.h          | 32 ++++++++++++--------
 3 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index d8bfcc1ce923..70f7b9e04598 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -222,4 +222,15 @@ lr	.req	x30		// link register
 	.size	__pi_##x, . - x;	\
 	ENDPROC(x)
 
+	/*
+	 * Emit a 64-bit absolute little endian symbol reference in a way that
+	 * ensures that it will be resolved at build time, even when building a
+	 * PIE binary. This requires cooperation from the linker script, which
+	 * must emit the lo32/hi32 halves individually.
+	 */
+	.macro	le64sym, sym
+	.long	\sym\()_lo32
+	.long	\sym\()_hi32
+	.endm
+
 #endif	/* __ASM_ASSEMBLER_H */
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 85181cb60f46..2a39d4ab02bf 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -83,9 +83,9 @@ efi_head:
 	b	stext				// branch to kernel start, magic
 	.long	0				// reserved
 #endif
-	.quad	_kernel_offset_le		// Image load offset from start of RAM, little-endian
-	.quad	_kernel_size_le			// Effective size of kernel image, little-endian
-	.quad	_kernel_flags_le		// Informative flags, little-endian
+	le64sym	_kernel_offset_le		// Image load offset from start of RAM, little-endian
+	le64sym	_kernel_size_le			// Effective size of kernel image, little-endian
+	le64sym	_kernel_flags_le		// Informative flags, little-endian
 	.quad	0				// reserved
 	.quad	0				// reserved
 	.quad	0				// reserved
diff --git a/arch/arm64/kernel/image.h b/arch/arm64/kernel/image.h
index bc2abb8b1599..b64c9b0a4492 100644
--- a/arch/arm64/kernel/image.h
+++ b/arch/arm64/kernel/image.h
@@ -26,21 +26,27 @@
  * There aren't any ELF relocations we can use to endian-swap values known only
  * at link time (e.g. the subtraction of two symbol addresses), so we must get
  * the linker to endian-swap certain values before emitting them.
+ *
+ * Note that, in order for this to work when building the ELF64 PIE executable
+ * (for KASLR), these values should not be referenced via R_AARCH64_ABS64
+ * relocations, since these are fixed up at runtime rather than at build time
+ * when PIE is in effect. So we need to split them up in 32-bit high and low
+ * words.
  */
 #ifdef CONFIG_CPU_BIG_ENDIAN
-#define DATA_LE64(data)					\
-	((((data) & 0x00000000000000ff) << 56) |	\
-	 (((data) & 0x000000000000ff00) << 40) |	\
-	 (((data) & 0x0000000000ff0000) << 24) |	\
-	 (((data) & 0x00000000ff000000) << 8)  |	\
-	 (((data) & 0x000000ff00000000) >> 8)  |	\
-	 (((data) & 0x0000ff0000000000) >> 24) |	\
-	 (((data) & 0x00ff000000000000) >> 40) |	\
-	 (((data) & 0xff00000000000000) >> 56))
+#define DATA_LE32(data)				\
+	((((data) & 0x000000ff) << 24) |	\
+	 (((data) & 0x0000ff00) << 8)  |	\
+	 (((data) & 0x00ff0000) >> 8)  |	\
+	 (((data) & 0xff000000) >> 24))
 #else
-#define DATA_LE64(data) ((data) & 0xffffffffffffffff)
+#define DATA_LE32(data) ((data) & 0xffffffff)
 #endif
 
+#define DEFINE_IMAGE_LE64(sym, data)				\
+	sym##_lo32 = DATA_LE32((data) & 0xffffffff);		\
+	sym##_hi32 = DATA_LE32((data) >> 32)
+
 #ifdef CONFIG_CPU_BIG_ENDIAN
 #define __HEAD_FLAG_BE	1
 #else
@@ -58,9 +64,9 @@
  * endian swapped in head.S, all are done here for consistency.
  */
 #define HEAD_SYMBOLS						\
-	_kernel_size_le		= DATA_LE64(_end - _text);	\
-	_kernel_offset_le	= DATA_LE64(TEXT_OFFSET);	\
-	_kernel_flags_le	= DATA_LE64(__HEAD_FLAGS);
+	DEFINE_IMAGE_LE64(_kernel_size_le, _end - _text);	\
+	DEFINE_IMAGE_LE64(_kernel_offset_le, TEXT_OFFSET);	\
+	DEFINE_IMAGE_LE64(_kernel_flags_le, __HEAD_FLAGS);
 
 #ifdef CONFIG_EFI
 
-- 
2.5.0
