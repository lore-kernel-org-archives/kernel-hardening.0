From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next v7 09/28] zinc: ChaCha20 ARM and ARM64 implementations
Date: Sat,  6 Oct 2018 04:56:50 +0200
Message-Id: <20181006025709.4019-10-Jason@zx2c4.com>
In-Reply-To: <20181006025709.4019-1-Jason@zx2c4.com>
References: <20181006025709.4019-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, Samuel Neves <sneves@dei.uc.pt>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

These wire Andy Polyakov's implementations up to the kernel for ARMv7,8
NEON, and introduce Eric Biggers' ultra-fast scalar implementation for
CPUs without NEON or for CPUs with slow NEON (Cortex-A5,7).

This commit does the following:
  - Adds the glue code for the assembly implementations.
  - Renames the ARMv8 code into place, since it can at this point be
    used wholesale.
  - Merges Andy Polyakov's ARMv7 NEON code with Eric Biggers' <=ARMv7
    scalar code.

This commit delivers approximately the same or much better performance than
the existing crypto API's code and has been measured to do as such on:

  - ARM1176JZF-S [ARMv6]
  - Cortex-A7    [ARMv7]
  - Cortex-A8    [ARMv7]
  - Cortex-A9    [ARMv7]
  - Cortex-A17   [ARMv7]
  - Cortex-A53   [ARMv8]
  - Cortex-A55   [ARMv8]
  - Cortex-A73   [ARMv8]
  - Cortex-A75   [ARMv8]

Interestingly, Andy Polyakov's scalar code is slower than Eric Biggers',
but is also significantly shorter. This has the advantage that it does
not evict other code from L1 cache -- particularly on ARM11 chips -- and
so in certain circumstances it can actually be faster. However, it wasn't
found that this had an affect on any code existing in the kernel today.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Co-authored-by: Eric Biggers <ebiggers@google.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Samuel Neves <sneves@dei.uc.pt>
Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kernel-hardening@lists.openwall.com
Cc: linux-crypto@vger.kernel.org
---

Notes:
    Eric Biggers' scalar code is brand new, and quite possibly prematurely
    added to this commit, and so it may require a bit of revision. In initial
    evaluation and fuzzing so far, it seems fine. But we'll be looking at this
    a bit more as well.

 lib/zinc/Makefile                             |   2 +
 lib/zinc/chacha20/chacha20-arm-glue.c         |  98 ++++
 ...acha20-arm-cryptogams.S => chacha20-arm.S} | 503 ++++++++++++++++--
 ...20-arm64-cryptogams.S => chacha20-arm64.S} |   0
 lib/zinc/chacha20/chacha20.c                  |   2 +
 5 files changed, 567 insertions(+), 38 deletions(-)
 create mode 100644 lib/zinc/chacha20/chacha20-arm-glue.c
 rename lib/zinc/chacha20/{chacha20-arm-cryptogams.S => chacha20-arm.S} (71%)
 rename lib/zinc/chacha20/{chacha20-arm64-cryptogams.S => chacha20-arm64.S} (100%)

diff --git a/lib/zinc/Makefile b/lib/zinc/Makefile
index 223a0816c918..e47f64e12bbd 100644
--- a/lib/zinc/Makefile
+++ b/lib/zinc/Makefile
@@ -4,4 +4,6 @@ ccflags-$(CONFIG_ZINC_DEBUG) += -DDEBUG
 
 zinc_chacha20-y := chacha20/chacha20.o
 zinc_chacha20-$(CONFIG_ZINC_ARCH_X86_64) += chacha20/chacha20-x86_64.o
+zinc_chacha20-$(CONFIG_ZINC_ARCH_ARM) += chacha20/chacha20-arm.o
+zinc_chacha20-$(CONFIG_ZINC_ARCH_ARM64) += chacha20/chacha20-arm64.o
 obj-$(CONFIG_ZINC_CHACHA20) += zinc_chacha20.o
diff --git a/lib/zinc/chacha20/chacha20-arm-glue.c b/lib/zinc/chacha20/chacha20-arm-glue.c
new file mode 100644
index 000000000000..a0da95d3b9c4
--- /dev/null
+++ b/lib/zinc/chacha20/chacha20-arm-glue.c
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: GPL-2.0 OR MIT
+/*
+ * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#include <asm/hwcap.h>
+#include <asm/neon.h>
+#if defined(CONFIG_ZINC_ARCH_ARM)
+#include <asm/system_info.h>
+#include <asm/cputype.h>
+#endif
+
+asmlinkage void chacha20_arm(u8 *out, const u8 *in, const size_t len,
+			     const u32 key[8], const u32 counter[4]);
+asmlinkage void hchacha20_arm(const u32 state[16], u32 out[8]);
+asmlinkage void chacha20_neon(u8 *out, const u8 *in, const size_t len,
+			      const u32 key[8], const u32 counter[4]);
+
+static bool chacha20_use_neon __ro_after_init;
+static bool *const chacha20_nobs[] __initconst = { &chacha20_use_neon };
+static void __init chacha20_fpu_init(void)
+{
+#if defined(CONFIG_ZINC_ARCH_ARM64)
+	chacha20_use_neon = elf_hwcap & HWCAP_ASIMD;
+#elif defined(CONFIG_ZINC_ARCH_ARM)
+	switch (read_cpuid_part()) {
+	case ARM_CPU_PART_CORTEX_A7:
+	case ARM_CPU_PART_CORTEX_A5:
+		/* The Cortex-A7 and Cortex-A5 do not perform well with the NEON
+		 * implementation but do incredibly with the scalar one and use
+		 * less power.
+		 */
+		break;
+	default:
+		chacha20_use_neon = elf_hwcap & HWCAP_NEON;
+	}
+#endif
+}
+
+static inline bool chacha20_arch(struct chacha20_ctx *ctx, u8 *dst,
+				 const u8 *src, size_t len,
+				 simd_context_t *simd_context)
+{
+	/* SIMD disables preemption, so relax after processing each page. */
+	BUILD_BUG_ON(PAGE_SIZE < CHACHA20_BLOCK_SIZE ||
+		     PAGE_SIZE % CHACHA20_BLOCK_SIZE);
+
+	for (;;) {
+		if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) && chacha20_use_neon &&
+		    len >= CHACHA20_BLOCK_SIZE * 3 && simd_use(simd_context)) {
+			const size_t bytes = min_t(size_t, len, PAGE_SIZE);
+
+			chacha20_neon(dst, src, bytes, ctx->key, ctx->counter);
+			ctx->counter[0] += (bytes + 63) / 64;
+			len -= bytes;
+			if (!len)
+				break;
+			dst += bytes;
+			src += bytes;
+			simd_relax(simd_context);
+		} else {
+			chacha20_arm(dst, src, len, ctx->key, ctx->counter);
+			ctx->counter[0] += (len + 63) / 64;
+			break;
+		}
+	}
+
+	return true;
+}
+
+static inline bool hchacha20_arch(u32 derived_key[CHACHA20_KEY_WORDS],
+				  const u8 nonce[HCHACHA20_NONCE_SIZE],
+				  const u8 key[HCHACHA20_KEY_SIZE],
+				  simd_context_t *simd_context)
+{
+	if (IS_ENABLED(CONFIG_ZINC_ARCH_ARM)) {
+		u32 x[] = { CHACHA20_CONSTANT_EXPA,
+			    CHACHA20_CONSTANT_ND_3,
+			    CHACHA20_CONSTANT_2_BY,
+			    CHACHA20_CONSTANT_TE_K,
+			    get_unaligned_le32(key + 0),
+			    get_unaligned_le32(key + 4),
+			    get_unaligned_le32(key + 8),
+			    get_unaligned_le32(key + 12),
+			    get_unaligned_le32(key + 16),
+			    get_unaligned_le32(key + 20),
+			    get_unaligned_le32(key + 24),
+			    get_unaligned_le32(key + 28),
+			    get_unaligned_le32(nonce + 0),
+			    get_unaligned_le32(nonce + 4),
+			    get_unaligned_le32(nonce + 8),
+			    get_unaligned_le32(nonce + 12)
+			  };
+		hchacha20_arm(x, derived_key);
+		return true;
+	}
+	return false;
+}
diff --git a/lib/zinc/chacha20/chacha20-arm-cryptogams.S b/lib/zinc/chacha20/chacha20-arm.S
similarity index 71%
rename from lib/zinc/chacha20/chacha20-arm-cryptogams.S
rename to lib/zinc/chacha20/chacha20-arm.S
index 770bab469171..79ed18fbcce3 100644
--- a/lib/zinc/chacha20/chacha20-arm-cryptogams.S
+++ b/lib/zinc/chacha20/chacha20-arm.S
@@ -1,12 +1,475 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
+ * Copyright (C) 2018 Google, Inc.
  * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  * Copyright (C) 2006-2017 CRYPTOGAMS by <appro@openssl.org>. All Rights Reserved.
- *
- * This is based in part on Andy Polyakov's implementation from CRYPTOGAMS.
  */
 
 #include <linux/linkage.h>
+#include <asm/assembler.h>
+
+/*
+ * The following scalar routine was written by Eric Biggers.
+ *
+ * Design notes:
+ *
+ * 16 registers would be needed to hold the state matrix, but only 14 are
+ * available because 'sp' and 'pc' cannot be used.  So we spill the elements
+ * (x8, x9) to the stack and swap them out with (x10, x11).  This adds one
+ * 'ldrd' and one 'strd' instruction per round.
+ *
+ * All rotates are performed using the implicit rotate operand accepted by the
+ * 'add' and 'eor' instructions.  This is faster than using explicit rotate
+ * instructions.  To make this work, we allow the values in the second and last
+ * rows of the ChaCha state matrix (rows 'b' and 'd') to temporarily have the
+ * wrong rotation amount.  The rotation amount is then fixed up just in time
+ * when the values are used.  'brot' is the number of bits the values in row 'b'
+ * need to be rotated right to arrive at the correct values, and 'drot'
+ * similarly for row 'd'.  (brot, drot) start out as (0, 0) but we make it such
+ * that they end up as (25, 24) after every round.
+ */
+
+	// ChaCha state registers
+	X0	.req	r0
+	X1	.req	r1
+	X2	.req	r2
+	X3	.req	r3
+	X4	.req	r4
+	X5	.req	r5
+	X6	.req	r6
+	X7	.req	r7
+	X8_X10	.req	r8	// shared by x8 and x10
+	X9_X11	.req	r9	// shared by x9 and x11
+	X12	.req	r10
+	X13	.req	r11
+	X14	.req	r12
+	X15	.req	r14
+
+.Lexpand_32byte_k:
+	// "expand 32-byte k"
+	.word	0x61707865, 0x3320646e, 0x79622d32, 0x6b206574
+
+#ifdef __thumb2__
+#  define adrl adr
+#endif
+
+.macro __rev		out, in,  t0, t1, t2
+.if __LINUX_ARM_ARCH__ >= 6
+	rev		\out, \in
+.else
+	lsl		\t0, \in, #24
+	and		\t1, \in, #0xff00
+	and		\t2, \in, #0xff0000
+	orr		\out, \t0, \in, lsr #24
+	orr		\out, \out, \t1, lsl #8
+	orr		\out, \out, \t2, lsr #8
+.endif
+.endm
+
+.macro _le32_bswap	x,  t0, t1, t2
+#ifdef __ARMEB__
+	__rev		\x, \x,  \t0, \t1, \t2
+#endif
+.endm
+
+.macro _le32_bswap_4x	a, b, c, d,  t0, t1, t2
+	_le32_bswap	\a,  \t0, \t1, \t2
+	_le32_bswap	\b,  \t0, \t1, \t2
+	_le32_bswap	\c,  \t0, \t1, \t2
+	_le32_bswap	\d,  \t0, \t1, \t2
+.endm
+
+.macro __ldrd		a, b, src, offset
+#if __LINUX_ARM_ARCH__ >= 6
+	ldrd		\a, \b, [\src, #\offset]
+#else
+	ldr		\a, [\src, #\offset]
+	ldr		\b, [\src, #\offset + 4]
+#endif
+.endm
+
+.macro __strd		a, b, dst, offset
+#if __LINUX_ARM_ARCH__ >= 6
+	strd		\a, \b, [\dst, #\offset]
+#else
+	str		\a, [\dst, #\offset]
+	str		\b, [\dst, #\offset + 4]
+#endif
+.endm
+
+.macro _halfround	a1, b1, c1, d1,  a2, b2, c2, d2
+
+	// a += b; d ^= a; d = rol(d, 16);
+	add		\a1, \a1, \b1, ror #brot
+	add		\a2, \a2, \b2, ror #brot
+	eor		\d1, \a1, \d1, ror #drot
+	eor		\d2, \a2, \d2, ror #drot
+	// drot == 32 - 16 == 16
+
+	// c += d; b ^= c; b = rol(b, 12);
+	add		\c1, \c1, \d1, ror #16
+	add		\c2, \c2, \d2, ror #16
+	eor		\b1, \c1, \b1, ror #brot
+	eor		\b2, \c2, \b2, ror #brot
+	// brot == 32 - 12 == 20
+
+	// a += b; d ^= a; d = rol(d, 8);
+	add		\a1, \a1, \b1, ror #20
+	add		\a2, \a2, \b2, ror #20
+	eor		\d1, \a1, \d1, ror #16
+	eor		\d2, \a2, \d2, ror #16
+	// drot == 32 - 8 == 24
+
+	// c += d; b ^= c; b = rol(b, 7);
+	add		\c1, \c1, \d1, ror #24
+	add		\c2, \c2, \d2, ror #24
+	eor		\b1, \c1, \b1, ror #20
+	eor		\b2, \c2, \b2, ror #20
+	// brot == 32 - 7 == 25
+.endm
+
+.macro _doubleround
+
+	// column round
+
+	// quarterrounds: (x0, x4, x8, x12) and (x1, x5, x9, x13)
+	_halfround	X0, X4, X8_X10, X12,  X1, X5, X9_X11, X13
+
+	// save (x8, x9); restore (x10, x11)
+	__strd		X8_X10, X9_X11, sp, 0
+	__ldrd		X8_X10, X9_X11, sp, 8
+
+	// quarterrounds: (x2, x6, x10, x14) and (x3, x7, x11, x15)
+	_halfround	X2, X6, X8_X10, X14,  X3, X7, X9_X11, X15
+
+	.set brot, 25
+	.set drot, 24
+
+	// diagonal round
+
+	// quarterrounds: (x0, x5, x10, x15) and (x1, x6, x11, x12)
+	_halfround	X0, X5, X8_X10, X15,  X1, X6, X9_X11, X12
+
+	// save (x10, x11); restore (x8, x9)
+	__strd		X8_X10, X9_X11, sp, 8
+	__ldrd		X8_X10, X9_X11, sp, 0
+
+	// quarterrounds: (x2, x7, x8, x13) and (x3, x4, x9, x14)
+	_halfround	X2, X7, X8_X10, X13,  X3, X4, X9_X11, X14
+.endm
+
+.macro _chacha_permute	nrounds
+	.set brot, 0
+	.set drot, 0
+	.rept \nrounds / 2
+	 _doubleround
+	.endr
+.endm
+
+.macro _chacha		nrounds
+
+.Lnext_block\@:
+	// Stack: unused0-unused1 x10-x11 x0-x15 OUT IN LEN
+	// Registers contain x0-x9,x12-x15.
+
+	// Do the core ChaCha permutation to update x0-x15.
+	_chacha_permute	\nrounds
+
+	add		sp, #8
+	// Stack: x10-x11 orig_x0-orig_x15 OUT IN LEN
+	// Registers contain x0-x9,x12-x15.
+	// x4-x7 are rotated by 'brot'; x12-x15 are rotated by 'drot'.
+
+	// Free up some registers (r8-r12,r14) by pushing (x8-x9,x12-x15).
+	push		{X8_X10, X9_X11, X12, X13, X14, X15}
+
+	// Load (OUT, IN, LEN).
+	ldr		r14, [sp, #96]
+	ldr		r12, [sp, #100]
+	ldr		r11, [sp, #104]
+
+	orr		r10, r14, r12
+
+	// Use slow path if fewer than 64 bytes remain.
+	cmp		r11, #64
+	blt		.Lxor_slowpath\@
+
+	// Use slow path if IN and/or OUT isn't 4-byte aligned.  Needed even on
+	// ARMv6+, since ldmia and stmia (used below) still require alignment.
+	tst		r10, #3
+	bne		.Lxor_slowpath\@
+
+	// Fast path: XOR 64 bytes of aligned data.
+
+	// Stack: x8-x9 x12-x15 x10-x11 orig_x0-orig_x15 OUT IN LEN
+	// Registers: r0-r7 are x0-x7; r8-r11 are free; r12 is IN; r14 is OUT.
+	// x4-x7 are rotated by 'brot'; x12-x15 are rotated by 'drot'.
+
+	// x0-x3
+	__ldrd		r8, r9, sp, 32
+	__ldrd		r10, r11, sp, 40
+	add		X0, X0, r8
+	add		X1, X1, r9
+	add		X2, X2, r10
+	add		X3, X3, r11
+	_le32_bswap_4x	X0, X1, X2, X3,  r8, r9, r10
+	ldmia		r12!, {r8-r11}
+	eor		X0, X0, r8
+	eor		X1, X1, r9
+	eor		X2, X2, r10
+	eor		X3, X3, r11
+	stmia		r14!, {X0-X3}
+
+	// x4-x7
+	__ldrd		r8, r9, sp, 48
+	__ldrd		r10, r11, sp, 56
+	add		X4, r8, X4, ror #brot
+	add		X5, r9, X5, ror #brot
+	ldmia		r12!, {X0-X3}
+	add		X6, r10, X6, ror #brot
+	add		X7, r11, X7, ror #brot
+	_le32_bswap_4x	X4, X5, X6, X7,  r8, r9, r10
+	eor		X4, X4, X0
+	eor		X5, X5, X1
+	eor		X6, X6, X2
+	eor		X7, X7, X3
+	stmia		r14!, {X4-X7}
+
+	// x8-x15
+	pop		{r0-r7}			// (x8-x9,x12-x15,x10-x11)
+	__ldrd		r8, r9, sp, 32
+	__ldrd		r10, r11, sp, 40
+	add		r0, r0, r8		// x8
+	add		r1, r1, r9		// x9
+	add		r6, r6, r10		// x10
+	add		r7, r7, r11		// x11
+	_le32_bswap_4x	r0, r1, r6, r7,  r8, r9, r10
+	ldmia		r12!, {r8-r11}
+	eor		r0, r0, r8		// x8
+	eor		r1, r1, r9		// x9
+	eor		r6, r6, r10		// x10
+	eor		r7, r7, r11		// x11
+	stmia		r14!, {r0,r1,r6,r7}
+	ldmia		r12!, {r0,r1,r6,r7}
+	__ldrd		r8, r9, sp, 48
+	__ldrd		r10, r11, sp, 56
+	add		r2, r8, r2, ror #drot	// x12
+	add		r3, r9, r3, ror #drot	// x13
+	add		r4, r10, r4, ror #drot	// x14
+	add		r5, r11, r5, ror #drot	// x15
+	_le32_bswap_4x	r2, r3, r4, r5,  r9, r10, r11
+	  ldr		r9, [sp, #72]		// load LEN
+	eor		r2, r2, r0		// x12
+	eor		r3, r3, r1		// x13
+	eor		r4, r4, r6		// x14
+	eor		r5, r5, r7		// x15
+	  subs		r9, #64			// decrement and check LEN
+	stmia		r14!, {r2-r5}
+
+	beq		.Ldone\@
+
+.Lprepare_for_next_block\@:
+
+	// Stack: x0-x15 OUT IN LEN
+
+	// Increment block counter (x12)
+	add		r8, #1
+
+	// Store updated (OUT, IN, LEN)
+	str		r14, [sp, #64]
+	str		r12, [sp, #68]
+	str		r9, [sp, #72]
+
+	  mov		r14, sp
+
+	// Store updated block counter (x12)
+	str		r8, [sp, #48]
+
+	  sub		sp, #16
+
+	// Reload state and do next block
+	ldmia		r14!, {r0-r11}		// load x0-x11
+	__strd		r10, r11, sp, 8		// store x10-x11 before state
+	ldmia		r14, {r10-r12,r14}	// load x12-x15
+	b		.Lnext_block\@
+
+.Lxor_slowpath\@:
+	// Slow path: < 64 bytes remaining, or unaligned input or output buffer.
+	// We handle it by storing the 64 bytes of keystream to the stack, then
+	// XOR-ing the needed portion with the data.
+
+	// Allocate keystream buffer
+	sub		sp, #64
+	mov		r14, sp
+
+	// Stack: ks0-ks15 x8-x9 x12-x15 x10-x11 orig_x0-orig_x15 OUT IN LEN
+	// Registers: r0-r7 are x0-x7; r8-r11 are free; r12 is IN; r14 is &ks0.
+	// x4-x7 are rotated by 'brot'; x12-x15 are rotated by 'drot'.
+
+	// Save keystream for x0-x3
+	__ldrd		r8, r9, sp, 96
+	__ldrd		r10, r11, sp, 104
+	add		X0, X0, r8
+	add		X1, X1, r9
+	add		X2, X2, r10
+	add		X3, X3, r11
+	_le32_bswap_4x	X0, X1, X2, X3,  r8, r9, r10
+	stmia		r14!, {X0-X3}
+
+	// Save keystream for x4-x7
+	__ldrd		r8, r9, sp, 112
+	__ldrd		r10, r11, sp, 120
+	add		X4, r8, X4, ror #brot
+	add		X5, r9, X5, ror #brot
+	add		X6, r10, X6, ror #brot
+	add		X7, r11, X7, ror #brot
+	_le32_bswap_4x	X4, X5, X6, X7,  r8, r9, r10
+	  add		r8, sp, #64
+	stmia		r14!, {X4-X7}
+
+	// Save keystream for x8-x15
+	ldm		r8, {r0-r7}		// (x8-x9,x12-x15,x10-x11)
+	__ldrd		r8, r9, sp, 128
+	__ldrd		r10, r11, sp, 136
+	add		r0, r0, r8		// x8
+	add		r1, r1, r9		// x9
+	add		r6, r6, r10		// x10
+	add		r7, r7, r11		// x11
+	_le32_bswap_4x	r0, r1, r6, r7,  r8, r9, r10
+	stmia		r14!, {r0,r1,r6,r7}
+	__ldrd		r8, r9, sp, 144
+	__ldrd		r10, r11, sp, 152
+	add		r2, r8, r2, ror #drot	// x12
+	add		r3, r9, r3, ror #drot	// x13
+	add		r4, r10, r4, ror #drot	// x14
+	add		r5, r11, r5, ror #drot	// x15
+	_le32_bswap_4x	r2, r3, r4, r5,  r9, r10, r11
+	stmia		r14, {r2-r5}
+
+	// Stack: ks0-ks15 unused0-unused7 x0-x15 OUT IN LEN
+	// Registers: r8 is block counter, r12 is IN.
+
+	ldr		r9, [sp, #168]		// LEN
+	ldr		r14, [sp, #160]		// OUT
+	cmp		r9, #64
+	  mov		r0, sp
+	movle		r1, r9
+	movgt		r1, #64
+	// r1 is number of bytes to XOR, in range [1, 64]
+
+.if __LINUX_ARM_ARCH__ < 6
+	orr		r2, r12, r14
+	tst		r2, #3			// IN or OUT misaligned?
+	bne		.Lxor_next_byte\@
+.endif
+
+	// XOR a word at a time
+.rept 16
+	subs		r1, #4
+	blt		.Lxor_words_done\@
+	ldr		r2, [r12], #4
+	ldr		r3, [r0], #4
+	eor		r2, r2, r3
+	str		r2, [r14], #4
+.endr
+	b		.Lxor_slowpath_done\@
+.Lxor_words_done\@:
+	ands		r1, r1, #3
+	beq		.Lxor_slowpath_done\@
+
+	// XOR a byte at a time
+.Lxor_next_byte\@:
+	ldrb		r2, [r12], #1
+	ldrb		r3, [r0], #1
+	eor		r2, r2, r3
+	strb		r2, [r14], #1
+	subs		r1, #1
+	bne		.Lxor_next_byte\@
+
+.Lxor_slowpath_done\@:
+	subs		r9, #64
+	add		sp, #96
+	bgt		.Lprepare_for_next_block\@
+
+.Ldone\@:
+.endm	// _chacha
+
+/*
+ * void chacha20_arm(u8 *out, const u8 *in, size_t len, const u32 key[8],
+ *		     const u32 iv[4]);
+ */
+ENTRY(chacha20_arm)
+	cmp		r2, #0			// len == 0?
+	reteq		lr
+
+	push		{r0-r2,r4-r11,lr}
+
+	// Push state x0-x15 onto stack.
+	// Also store an extra copy of x10-x11 just before the state.
+
+	ldr		r4, [sp, #48]		// iv
+	mov		r0, sp
+	sub		sp, #80
+
+	// iv: x12-x15
+	ldm		r4, {X12,X13,X14,X15}
+	stmdb		r0!, {X12,X13,X14,X15}
+
+	// key: x4-x11
+	__ldrd		X8_X10, X9_X11, r3, 24
+	__strd		X8_X10, X9_X11, sp, 8
+	stmdb		r0!, {X8_X10, X9_X11}
+	ldm		r3, {X4-X9_X11}
+	stmdb		r0!, {X4-X9_X11}
+
+	// constants: x0-x3
+	adrl		X3, .Lexpand_32byte_k
+	ldm		X3, {X0-X3}
+	__strd		X0, X1, sp, 16
+	__strd		X2, X3, sp, 24
+
+	_chacha		20
+
+	add		sp, #76
+	pop		{r4-r11, pc}
+ENDPROC(chacha20_arm)
+
+/*
+ * void hchacha20_arm(const u32 state[16], u32 out[8]);
+ */
+ENTRY(hchacha20_arm)
+	push		{r1,r4-r11,lr}
+
+	mov		r14, r0
+	ldmia		r14!, {r0-r11}		// load x0-x11
+	push		{r10-r11}		// store x10-x11 to stack
+	ldm		r14, {r10-r12,r14}	// load x12-x15
+	sub		sp, #8
+
+	_chacha_permute	20
+
+	// Skip over (unused0-unused1, x10-x11)
+	add		sp, #16
+
+	// Fix up rotations of x12-x15
+	ror		X12, X12, #drot
+	ror		X13, X13, #drot
+	  pop		{r4}			// load 'out'
+	ror		X14, X14, #drot
+	ror		X15, X15, #drot
+
+	// Store (x0-x3,x12-x15) to 'out'
+	stm		r4, {X0,X1,X2,X3,X12,X13,X14,X15}
+
+	pop		{r4-r11,pc}
+ENDPROC(hchacha20_arm)
+
+#ifdef CONFIG_KERNEL_MODE_NEON
+/*
+ * This following NEON routine was ported from Andy Polyakov's implementation
+ * from CRYPTOGAMS. It begins with parts of the CRYPTOGAMS scalar routine,
+ * since certain NEON code paths actually branch to it.
+ */
 
 .text
 #if defined(__thumb2__) || defined(__clang__)
@@ -22,39 +485,6 @@
 #define ldrhsb	ldrbhs
 #endif
 
-.align	5
-.Lsigma:
-.long	0x61707865,0x3320646e,0x79622d32,0x6b206574	@ endian-neutral
-.Lone:
-.long	1,0,0,0
-.word	-1
-
-.align	5
-ENTRY(chacha20_arm)
-	ldr	r12,[sp,#0]		@ pull pointer to counter and nonce
-	stmdb	sp!,{r0-r2,r4-r11,lr}
-	cmp	r2,#0			@ len==0?
-#ifdef __thumb2__
-	itt	eq
-#endif
-	addeq	sp,sp,#4*3
-	beq	.Lno_data_arm
-	ldmia	r12,{r4-r7}		@ load counter and nonce
-	sub	sp,sp,#4*(16)		@ off-load area
-#if __LINUX_ARM_ARCH__ < 7 && !defined(__thumb2__)
-	sub	r14,pc,#100		@ .Lsigma
-#else
-	adr	r14,.Lsigma		@ .Lsigma
-#endif
-	stmdb	sp!,{r4-r7}		@ copy counter and nonce
-	ldmia	r3,{r4-r11}		@ load key
-	ldmia	r14,{r0-r3}		@ load sigma
-	stmdb	sp!,{r4-r11}		@ copy key
-	stmdb	sp!,{r0-r3}		@ copy sigma
-	str	r10,[sp,#4*(16+10)]	@ off-load "rx"
-	str	r11,[sp,#4*(16+11)]	@ off-load "rx"
-	b	.Loop_outer_enter
-
 .align	4
 .Loop_outer:
 	ldmia	sp,{r0-r9}		@ load key material
@@ -748,11 +1178,8 @@ ENTRY(chacha20_arm)
 
 .Ldone:
 	add	sp,sp,#4*(32+3)
-.Lno_data_arm:
 	ldmia	sp!,{r4-r11,pc}
-ENDPROC(chacha20_arm)
 
-#ifdef CONFIG_KERNEL_MODE_NEON
 .align	5
 .Lsigma2:
 .long	0x61707865,0x3320646e,0x79622d32,0x6b206574	@ endian-neutral
diff --git a/lib/zinc/chacha20/chacha20-arm64-cryptogams.S b/lib/zinc/chacha20/chacha20-arm64.S
similarity index 100%
rename from lib/zinc/chacha20/chacha20-arm64-cryptogams.S
rename to lib/zinc/chacha20/chacha20-arm64.S
diff --git a/lib/zinc/chacha20/chacha20.c b/lib/zinc/chacha20/chacha20.c
index 22a21431c221..3698fcd8ae7f 100644
--- a/lib/zinc/chacha20/chacha20.c
+++ b/lib/zinc/chacha20/chacha20.c
@@ -18,6 +18,8 @@
 
 #if defined(CONFIG_ZINC_ARCH_X86_64)
 #include "chacha20-x86_64-glue.c"
+#elif defined(CONFIG_ZINC_ARCH_ARM) || defined(CONFIG_ZINC_ARCH_ARM64)
+#include "chacha20-arm-glue.c"
 #else
 static bool *const chacha20_nobs[] __initconst = { };
 static void __init chacha20_fpu_init(void)
-- 
2.19.0
