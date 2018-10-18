From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next v8 15/28] zinc: Poly1305 ARM and ARM64 implementations
Date: Thu, 18 Oct 2018 16:56:59 +0200
Message-Id: <20181018145712.7538-16-Jason@zx2c4.com>
In-Reply-To: <20181018145712.7538-1-Jason@zx2c4.com>
References: <20181018145712.7538-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-crypto@vger.kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, Samuel Neves <sneves@dei.uc.pt>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

These wire Andy Polyakov's implementations up to the kernel. We make a
few small changes to the assembly:

- Entries and exits use the proper kernel convention macro.
- CPU feature checking is done in C by the glue code, so that has been
  removed from the assembly.
- The function names have been renamed to fit kernel conventions.
- Labels have been renamed to fit kernel conventions.
- The neon code can jump to the scalar code when it makes sense to do
  so.

The NEON code uses base 2^26, while the scalar code uses base 2^64 on 64-bit
and base 2^32 on 32-bit. If we hit the unfortunate situation of using NEON
and then having to go back to scalar -- because the user is silly and has
called the update function from two separate contexts -- then we need to
convert back to the original base before proceeding. It is possible to
reason that the initial reduction below is sufficient given the
implementation invariants. However, for an avoidance of doubt and because
this is not performance critical, we do the full reduction anyway. This
conversion is found in the glue code, and a proof of correctness may be
easily obtained from Z3: <https://xn--4db.cc/ltPtHCKN/py>.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
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
 lib/zinc/Makefile                             |   2 +
 lib/zinc/poly1305/poly1305-arm-glue.c         | 140 +++++++++++++++++
 ...ly1305-arm-cryptogams.S => poly1305-arm.S} | 147 ++++++------------
 ...05-arm64-cryptogams.S => poly1305-arm64.S} | 127 +++++----------
 lib/zinc/poly1305/poly1305.c                  |   2 +
 5 files changed, 231 insertions(+), 187 deletions(-)
 create mode 100644 lib/zinc/poly1305/poly1305-arm-glue.c
 rename lib/zinc/poly1305/{poly1305-arm-cryptogams.S => poly1305-arm.S} (91%)
 rename lib/zinc/poly1305/{poly1305-arm64-cryptogams.S => poly1305-arm64.S} (89%)

diff --git a/lib/zinc/Makefile b/lib/zinc/Makefile
index a8943d960b6a..c09fd3de60f9 100644
--- a/lib/zinc/Makefile
+++ b/lib/zinc/Makefile
@@ -12,4 +12,6 @@ obj-$(CONFIG_ZINC_CHACHA20) += zinc_chacha20.o
 
 zinc_poly1305-y := poly1305/poly1305.o
 zinc_poly1305-$(CONFIG_ZINC_ARCH_X86_64) += poly1305/poly1305-x86_64.o
+zinc_poly1305-$(CONFIG_ZINC_ARCH_ARM) += poly1305/poly1305-arm.o
+zinc_poly1305-$(CONFIG_ZINC_ARCH_ARM64) += poly1305/poly1305-arm64.o
 obj-$(CONFIG_ZINC_POLY1305) += zinc_poly1305.o
diff --git a/lib/zinc/poly1305/poly1305-arm-glue.c b/lib/zinc/poly1305/poly1305-arm-glue.c
new file mode 100644
index 000000000000..f4f08ecffbf6
--- /dev/null
+++ b/lib/zinc/poly1305/poly1305-arm-glue.c
@@ -0,0 +1,140 @@
+// SPDX-License-Identifier: GPL-2.0 OR MIT
+/*
+ * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#include <asm/hwcap.h>
+#include <asm/neon.h>
+
+asmlinkage void poly1305_init_arm(void *ctx, const u8 key[16]);
+asmlinkage void poly1305_blocks_arm(void *ctx, const u8 *inp, const size_t len,
+				    const u32 padbit);
+asmlinkage void poly1305_emit_arm(void *ctx, u8 mac[16], const u32 nonce[4]);
+asmlinkage void poly1305_blocks_neon(void *ctx, const u8 *inp, const size_t len,
+				     const u32 padbit);
+asmlinkage void poly1305_emit_neon(void *ctx, u8 mac[16], const u32 nonce[4]);
+
+static bool poly1305_use_neon __ro_after_init;
+static bool *const poly1305_nobs[] __initconst = { &poly1305_use_neon };
+
+static void __init poly1305_fpu_init(void)
+{
+#if defined(CONFIG_ZINC_ARCH_ARM64)
+	poly1305_use_neon = elf_hwcap & HWCAP_ASIMD;
+#elif defined(CONFIG_ZINC_ARCH_ARM)
+	poly1305_use_neon = elf_hwcap & HWCAP_NEON;
+#endif
+}
+
+#if defined(CONFIG_ZINC_ARCH_ARM64)
+struct poly1305_arch_internal {
+	union {
+		u32 h[5];
+		struct {
+			u64 h0, h1, h2;
+		};
+	};
+	u64 is_base2_26;
+	u64 r[2];
+};
+#elif defined(CONFIG_ZINC_ARCH_ARM)
+struct poly1305_arch_internal {
+	union {
+		u32 h[5];
+		struct {
+			u64 h0, h1;
+			u32 h2;
+		} __packed;
+	};
+	u32 r[4];
+	u32 is_base2_26;
+};
+#endif
+
+/* The NEON code uses base 2^26, while the scalar code uses base 2^64 on 64-bit
+ * and base 2^32 on 32-bit. If we hit the unfortunate situation of using NEON
+ * and then having to go back to scalar -- because the user is silly and has
+ * called the update function from two separate contexts -- then we need to
+ * convert back to the original base before proceeding. The below function is
+ * written for 64-bit integers, and so we have to swap words at the end on
+ * big-endian 32-bit. It is possible to reason that the initial reduction below
+ * is sufficient given the implementation invariants. However, for an avoidance
+ * of doubt and because this is not performance critical, we do the full
+ * reduction anyway.
+ */
+static void convert_to_base2_64(void *ctx)
+{
+	struct poly1305_arch_internal *state = ctx;
+	u32 cy;
+
+	if (!IS_ENABLED(CONFIG_KERNEL_MODE_NEON) || !state->is_base2_26)
+		return;
+
+	cy = state->h[0] >> 26; state->h[0] &= 0x3ffffff; state->h[1] += cy;
+	cy = state->h[1] >> 26; state->h[1] &= 0x3ffffff; state->h[2] += cy;
+	cy = state->h[2] >> 26; state->h[2] &= 0x3ffffff; state->h[3] += cy;
+	cy = state->h[3] >> 26; state->h[3] &= 0x3ffffff; state->h[4] += cy;
+	state->h0 = ((u64)state->h[2] << 52) | ((u64)state->h[1] << 26) | state->h[0];
+	state->h1 = ((u64)state->h[4] << 40) | ((u64)state->h[3] << 14) | (state->h[2] >> 12);
+	state->h2 = state->h[4] >> 24;
+	if (IS_ENABLED(CONFIG_ZINC_ARCH_ARM) && IS_ENABLED(CONFIG_CPU_BIG_ENDIAN)) {
+		state->h0 = rol64(state->h0, 32);
+		state->h1 = rol64(state->h1, 32);
+	}
+#define ULT(a, b) ((a ^ ((a ^ b) | ((a - b) ^ b))) >> (sizeof(a) * 8 - 1))
+	cy = (state->h2 >> 2) + (state->h2 & ~3ULL);
+	state->h2 &= 3;
+	state->h0 += cy;
+	state->h1 += (cy = ULT(state->h0, cy));
+	state->h2 += ULT(state->h1, cy);
+#undef ULT
+	state->is_base2_26 = 0;
+}
+
+static inline bool poly1305_init_arch(void *ctx,
+				      const u8 key[POLY1305_KEY_SIZE])
+{
+	poly1305_init_arm(ctx, key);
+	return true;
+}
+
+static inline bool poly1305_blocks_arch(void *ctx, const u8 *inp,
+					size_t len, const u32 padbit,
+					simd_context_t *simd_context)
+{
+	/* SIMD disables preemption, so relax after processing each page. */
+	BUILD_BUG_ON(PAGE_SIZE < POLY1305_BLOCK_SIZE ||
+		     PAGE_SIZE % POLY1305_BLOCK_SIZE);
+
+	if (!IS_ENABLED(CONFIG_KERNEL_MODE_NEON) || !poly1305_use_neon ||
+	    !simd_use(simd_context)) {
+		convert_to_base2_64(ctx);
+		poly1305_blocks_arm(ctx, inp, len, padbit);
+		return true;
+	}
+
+	for (;;) {
+		const size_t bytes = min_t(size_t, len, PAGE_SIZE);
+
+		poly1305_blocks_neon(ctx, inp, bytes, padbit);
+		len -= bytes;
+		if (!len)
+			break;
+		inp += bytes;
+		simd_relax(simd_context);
+	}
+	return true;
+}
+
+static inline bool poly1305_emit_arch(void *ctx, u8 mac[POLY1305_MAC_SIZE],
+				      const u32 nonce[4],
+				      simd_context_t *simd_context)
+{
+	if (!IS_ENABLED(CONFIG_KERNEL_MODE_NEON) || !poly1305_use_neon ||
+	    !simd_use(simd_context)) {
+		convert_to_base2_64(ctx);
+		poly1305_emit_arm(ctx, mac, nonce);
+	} else
+		poly1305_emit_neon(ctx, mac, nonce);
+	return true;
+}
diff --git a/lib/zinc/poly1305/poly1305-arm-cryptogams.S b/lib/zinc/poly1305/poly1305-arm.S
similarity index 91%
rename from lib/zinc/poly1305/poly1305-arm-cryptogams.S
rename to lib/zinc/poly1305/poly1305-arm.S
index 884b465030e4..4a0e9d451119 100644
--- a/lib/zinc/poly1305/poly1305-arm-cryptogams.S
+++ b/lib/zinc/poly1305/poly1305-arm.S
@@ -1,9 +1,12 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
+ * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  * Copyright (C) 2006-2017 CRYPTOGAMS by <appro@openssl.org>. All Rights Reserved.
+ *
+ * This is based in part on Andy Polyakov's implementation from CRYPTOGAMS.
  */
 
-#include "arm_arch.h"
+#include <linux/linkage.h>
 
 .text
 #if defined(__thumb2__)
@@ -13,13 +16,8 @@
 .code	32
 #endif
 
-.globl	poly1305_emit
-.globl	poly1305_blocks
-.globl	poly1305_init
-.type	poly1305_init,%function
 .align	5
-poly1305_init:
-.Lpoly1305_init:
+ENTRY(poly1305_init_arm)
 	stmdb	sp!,{r4-r11}
 
 	eor	r3,r3,r3
@@ -38,10 +36,6 @@ poly1305_init:
 	moveq	r0,#0
 	beq	.Lno_key
 
-#if	__ARM_MAX_ARCH__>=7
-	adr	r11,.Lpoly1305_init
-	ldr	r12,.LOPENSSL_armcap
-#endif
 	ldrb	r4,[r1,#0]
 	mov	r10,#0x0fffffff
 	ldrb	r5,[r1,#1]
@@ -56,12 +50,6 @@ poly1305_init:
 	ldrb	r7,[r1,#6]
 	and	r4,r4,r10
 
-#if	__ARM_MAX_ARCH__>=7
-	ldr	r12,[r11,r12]		@ OPENSSL_armcap_P
-# ifdef	__APPLE__
-	ldr	r12,[r12]
-# endif
-#endif
 	ldrb	r8,[r1,#7]
 	orr	r5,r5,r6,lsl#8
 	ldrb	r6,[r1,#8]
@@ -71,35 +59,6 @@ poly1305_init:
 	ldrb	r8,[r1,#10]
 	and	r5,r5,r3
 
-#if	__ARM_MAX_ARCH__>=7
-	tst	r12,#ARMV7_NEON		@ check for NEON
-# ifdef	__APPLE__
-	adr	r9,poly1305_blocks_neon
-	adr	r11,poly1305_blocks
-#  ifdef __thumb2__
-	it	ne
-#  endif
-	movne	r11,r9
-	adr	r12,poly1305_emit
-	adr	r10,poly1305_emit_neon
-#  ifdef __thumb2__
-	it	ne
-#  endif
-	movne	r12,r10
-# else
-#  ifdef __thumb2__
-	itete	eq
-#  endif
-	addeq	r12,r11,#(poly1305_emit-.Lpoly1305_init)
-	addne	r12,r11,#(poly1305_emit_neon-.Lpoly1305_init)
-	addeq	r11,r11,#(poly1305_blocks-.Lpoly1305_init)
-	addne	r11,r11,#(poly1305_blocks_neon-.Lpoly1305_init)
-# endif
-# ifdef	__thumb2__
-	orr	r12,r12,#1	@ thumb-ify address
-	orr	r11,r11,#1
-# endif
-#endif
 	ldrb	r9,[r1,#11]
 	orr	r6,r6,r7,lsl#8
 	ldrb	r7,[r1,#12]
@@ -118,26 +77,20 @@ poly1305_init:
 	str	r6,[r0,#8]
 	and	r7,r7,r3
 	str	r7,[r0,#12]
-#if	__ARM_MAX_ARCH__>=7
-	stmia	r2,{r11,r12}		@ fill functions table
-	mov	r0,#1
-#else
-	mov	r0,#0
-#endif
 .Lno_key:
 	ldmia	sp!,{r4-r11}
-#if	__ARM_ARCH__>=5
+#if __LINUX_ARM_ARCH__ >= 5
 	bx	lr				@ bx	lr
 #else
 	tst	lr,#1
 	moveq	pc,lr			@ be binary compatible with V4, yet
 	.word	0xe12fff1e			@ interoperable with Thumb ISA:-)
 #endif
-.size	poly1305_init,.-poly1305_init
-.type	poly1305_blocks,%function
+ENDPROC(poly1305_init_arm)
+
 .align	5
-poly1305_blocks:
-.Lpoly1305_blocks:
+ENTRY(poly1305_blocks_arm)
+.Lpoly1305_blocks_arm:
 	stmdb	sp!,{r3-r11,lr}
 
 	ands	r2,r2,#-16
@@ -158,11 +111,11 @@ poly1305_blocks:
 	b	.Loop
 
 .Loop:
-#if __ARM_ARCH__<7
+#if __LINUX_ARM_ARCH__ < 7
 	ldrb	r0,[lr],#16		@ load input
-# ifdef	__thumb2__
+#ifdef	__thumb2__
 	it	hi
-# endif
+#endif
 	addhi	r8,r8,#1		@ 1<<128
 	ldrb	r1,[lr,#-15]
 	ldrb	r2,[lr,#-14]
@@ -201,19 +154,19 @@ poly1305_blocks:
 	orr	r3,r2,r3,lsl#24
 #else
 	ldr	r0,[lr],#16		@ load input
-# ifdef	__thumb2__
+#ifdef	__thumb2__
 	it	hi
-# endif
+#endif
 	addhi	r8,r8,#1		@ padbit
 	ldr	r1,[lr,#-12]
 	ldr	r2,[lr,#-8]
 	ldr	r3,[lr,#-4]
-# ifdef	__ARMEB__
+#ifdef	__ARMEB__
 	rev	r0,r0
 	rev	r1,r1
 	rev	r2,r2
 	rev	r3,r3
-# endif
+#endif
 	adds	r4,r4,r0		@ accumulate input
 	str	lr,[sp,#8]		@ offload input pointer
 	adcs	r5,r5,r1
@@ -283,7 +236,7 @@ poly1305_blocks:
 	stmia	r0,{r4-r8}		@ store the result
 
 .Lno_data:
-#if	__ARM_ARCH__>=5
+#if __LINUX_ARM_ARCH__ >= 5
 	ldmia	sp!,{r3-r11,pc}
 #else
 	ldmia	sp!,{r3-r11,lr}
@@ -291,13 +244,12 @@ poly1305_blocks:
 	moveq	pc,lr			@ be binary compatible with V4, yet
 	.word	0xe12fff1e			@ interoperable with Thumb ISA:-)
 #endif
-.size	poly1305_blocks,.-poly1305_blocks
-.type	poly1305_emit,%function
+ENDPROC(poly1305_blocks_arm)
+
 .align	5
-poly1305_emit:
+ENTRY(poly1305_emit_arm)
 	stmdb	sp!,{r4-r11}
 .Lpoly1305_emit_enter:
-
 	ldmia	r0,{r3-r7}
 	adds	r8,r3,#5		@ compare to modulus
 	adcs	r9,r4,#0
@@ -332,13 +284,13 @@ poly1305_emit:
 	adcs	r5,r5,r10
 	adc	r6,r6,r11
 
-#if __ARM_ARCH__>=7
-# ifdef __ARMEB__
+#if __LINUX_ARM_ARCH__ >= 7
+#ifdef __ARMEB__
 	rev	r3,r3
 	rev	r4,r4
 	rev	r5,r5
 	rev	r6,r6
-# endif
+#endif
 	str	r3,[r1,#0]
 	str	r4,[r1,#4]
 	str	r5,[r1,#8]
@@ -377,20 +329,22 @@ poly1305_emit:
 	strb	r6,[r1,#15]
 #endif
 	ldmia	sp!,{r4-r11}
-#if	__ARM_ARCH__>=5
+#if __LINUX_ARM_ARCH__ >= 5
 	bx	lr				@ bx	lr
 #else
 	tst	lr,#1
 	moveq	pc,lr			@ be binary compatible with V4, yet
 	.word	0xe12fff1e			@ interoperable with Thumb ISA:-)
 #endif
-.size	poly1305_emit,.-poly1305_emit
-#if	__ARM_MAX_ARCH__>=7
+ENDPROC(poly1305_emit_arm)
+
+
+#ifdef CONFIG_KERNEL_MODE_NEON
 .fpu	neon
 
-.type	poly1305_init_neon,%function
 .align	5
-poly1305_init_neon:
+ENTRY(poly1305_init_neon)
+.Lpoly1305_init_neon:
 	ldr	r4,[r0,#20]		@ load key base 2^32
 	ldr	r5,[r0,#24]
 	ldr	r6,[r0,#28]
@@ -600,11 +554,10 @@ poly1305_init_neon:
 	vst1.32		{d8[1]},[r7]
 
 	bx	lr				@ bx	lr
-.size	poly1305_init_neon,.-poly1305_init_neon
+ENDPROC(poly1305_init_neon)
 
-.type	poly1305_blocks_neon,%function
 .align	5
-poly1305_blocks_neon:
+ENTRY(poly1305_blocks_neon)
 	ldr	ip,[r0,#36]		@ is_base2_26
 	ands	r2,r2,#-16
 	beq	.Lno_data_neon
@@ -612,7 +565,7 @@ poly1305_blocks_neon:
 	cmp	r2,#64
 	bhs	.Lenter_neon
 	tst	ip,ip			@ is_base2_26?
-	beq	.Lpoly1305_blocks
+	beq	.Lpoly1305_blocks_arm
 
 .Lenter_neon:
 	stmdb	sp!,{r4-r7}
@@ -622,7 +575,7 @@ poly1305_blocks_neon:
 	bne	.Lbase2_26_neon
 
 	stmdb	sp!,{r1-r3,lr}
-	bl	poly1305_init_neon
+	bl	.Lpoly1305_init_neon
 
 	ldr	r4,[r0,#0]		@ load hash value base 2^32
 	ldr	r5,[r0,#4]
@@ -686,12 +639,12 @@ poly1305_blocks_neon:
 	sub		r2,r2,#16
 	add		r4,r1,#32
 
-# ifdef	__ARMEB__
+#ifdef	__ARMEB__
 	vrev32.8	q10,q10
 	vrev32.8	q13,q13
 	vrev32.8	q11,q11
 	vrev32.8	q12,q12
-# endif
+#endif
 	vsri.u32	d28,d26,#8	@ base 2^32 -> base 2^26
 	vshl.u32	d26,d26,#18
 
@@ -735,12 +688,12 @@ poly1305_blocks_neon:
 	addhi		r7,r0,#(48+1*9*4)
 	addhi		r6,r0,#(48+3*9*4)
 
-# ifdef	__ARMEB__
+#ifdef	__ARMEB__
 	vrev32.8	q10,q10
 	vrev32.8	q13,q13
 	vrev32.8	q11,q11
 	vrev32.8	q12,q12
-# endif
+#endif
 	vsri.u32	q14,q13,#8		@ base 2^32 -> base 2^26
 	vshl.u32	q13,q13,#18
 
@@ -866,12 +819,12 @@ poly1305_blocks_neon:
 
 	vld4.32		{d20,d22,d24,d26},[r1]	@ inp[0:1]
 	add		r1,r1,#64
-# ifdef	__ARMEB__
+#ifdef	__ARMEB__
 	vrev32.8	q10,q10
 	vrev32.8	q11,q11
 	vrev32.8	q12,q12
 	vrev32.8	q13,q13
-# endif
+#endif
 
 	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 	@ lazy reduction interleaved with base 2^32 -> base 2^26 of
@@ -1086,11 +1039,10 @@ poly1305_blocks_neon:
 	ldmia	sp!,{r4-r7}
 .Lno_data_neon:
 	bx	lr					@ bx	lr
-.size	poly1305_blocks_neon,.-poly1305_blocks_neon
+ENDPROC(poly1305_blocks_neon)
 
-.type	poly1305_emit_neon,%function
 .align	5
-poly1305_emit_neon:
+ENTRY(poly1305_emit_neon)
 	ldr	ip,[r0,#36]		@ is_base2_26
 
 	stmdb	sp!,{r4-r11}
@@ -1144,12 +1096,12 @@ poly1305_emit_neon:
 	adcs	r5,r5,r10
 	adc	r6,r6,r11
 
-# ifdef __ARMEB__
+#ifdef __ARMEB__
 	rev	r3,r3
 	rev	r4,r4
 	rev	r5,r5
 	rev	r6,r6
-# endif
+#endif
 	str	r3,[r1,#0]		@ store the result
 	str	r4,[r1,#4]
 	str	r5,[r1,#8]
@@ -1157,16 +1109,9 @@ poly1305_emit_neon:
 
 	ldmia	sp!,{r4-r11}
 	bx	lr				@ bx	lr
-.size	poly1305_emit_neon,.-poly1305_emit_neon
+ENDPROC(poly1305_emit_neon)
 
 .align	5
 .Lzeros:
 .long	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
-.LOPENSSL_armcap:
-.word	OPENSSL_armcap_P-.Lpoly1305_init
-#endif
-.asciz	"Poly1305 for ARMv4/NEON, CRYPTOGAMS by <appro@openssl.org>"
-.align	2
-#if	__ARM_MAX_ARCH__>=7
-.comm   OPENSSL_armcap_P,4,4
 #endif
diff --git a/lib/zinc/poly1305/poly1305-arm64-cryptogams.S b/lib/zinc/poly1305/poly1305-arm64.S
similarity index 89%
rename from lib/zinc/poly1305/poly1305-arm64-cryptogams.S
rename to lib/zinc/poly1305/poly1305-arm64.S
index 0ecb50a83ec0..5f4e7fb0a836 100644
--- a/lib/zinc/poly1305/poly1305-arm64-cryptogams.S
+++ b/lib/zinc/poly1305/poly1305-arm64.S
@@ -1,21 +1,16 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
+ * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  * Copyright (C) 2006-2017 CRYPTOGAMS by <appro@openssl.org>. All Rights Reserved.
+ *
+ * This is based in part on Andy Polyakov's implementation from CRYPTOGAMS.
  */
 
-#include "arm_arch.h"
-
+#include <linux/linkage.h>
 .text
 
-// forward "declarations" are required for Apple
-
-.globl	poly1305_blocks
-.globl	poly1305_emit
-
-.globl	poly1305_init
-.type	poly1305_init,%function
 .align	5
-poly1305_init:
+ENTRY(poly1305_init_arm)
 	cmp	x1,xzr
 	stp	xzr,xzr,[x0]		// zero hash value
 	stp	xzr,xzr,[x0,#16]	// [along with is_base2_26]
@@ -23,18 +18,10 @@ poly1305_init:
 	csel	x0,xzr,x0,eq
 	b.eq	.Lno_key
 
-#ifdef	__ILP32__
-	ldrsw	x11,.LOPENSSL_armcap_P
-#else
-	ldr	x11,.LOPENSSL_armcap_P
-#endif
-	adr	x10,.LOPENSSL_armcap_P
-
 	ldp	x7,x8,[x1]		// load key
 	mov	x9,#0xfffffffc0fffffff
 	movk	x9,#0x0fff,lsl#48
-	ldr	w17,[x10,x11]
-#ifdef	__ARMEB__
+#ifdef	__AARCH64EB__
 	rev	x7,x7			// flip bytes
 	rev	x8,x8
 #endif
@@ -43,30 +30,12 @@ poly1305_init:
 	and	x8,x8,x9		// &=0ffffffc0ffffffc
 	stp	x7,x8,[x0,#32]	// save key value
 
-	tst	w17,#ARMV7_NEON
-
-	adr	x12,poly1305_blocks
-	adr	x7,poly1305_blocks_neon
-	adr	x13,poly1305_emit
-	adr	x8,poly1305_emit_neon
-
-	csel	x12,x12,x7,eq
-	csel	x13,x13,x8,eq
-
-#ifdef	__ILP32__
-	stp	w12,w13,[x2]
-#else
-	stp	x12,x13,[x2]
-#endif
-
-	mov	x0,#1
 .Lno_key:
 	ret
-.size	poly1305_init,.-poly1305_init
+ENDPROC(poly1305_init_arm)
 
-.type	poly1305_blocks,%function
 .align	5
-poly1305_blocks:
+ENTRY(poly1305_blocks_arm)
 	ands	x2,x2,#-16
 	b.eq	.Lno_data
 
@@ -80,7 +49,7 @@ poly1305_blocks:
 .Loop:
 	ldp	x10,x11,[x1],#16	// load input
 	sub	x2,x2,#16
-#ifdef	__ARMEB__
+#ifdef	__AARCH64EB__
 	rev	x10,x10
 	rev	x11,x11
 #endif
@@ -126,11 +95,10 @@ poly1305_blocks:
 
 .Lno_data:
 	ret
-.size	poly1305_blocks,.-poly1305_blocks
+ENDPROC(poly1305_blocks_arm)
 
-.type	poly1305_emit,%function
 .align	5
-poly1305_emit:
+ENTRY(poly1305_emit_arm)
 	ldp	x4,x5,[x0]		// load hash base 2^64
 	ldr	x6,[x0,#16]
 	ldp	x10,x11,[x2]	// load nonce
@@ -144,23 +112,23 @@ poly1305_emit:
 	csel	x4,x4,x12,eq
 	csel	x5,x5,x13,eq
 
-#ifdef	__ARMEB__
+#ifdef	__AARCH64EB__
 	ror	x10,x10,#32		// flip nonce words
 	ror	x11,x11,#32
 #endif
 	adds	x4,x4,x10		// accumulate nonce
 	adc	x5,x5,x11
-#ifdef	__ARMEB__
+#ifdef	__AARCH64EB__
 	rev	x4,x4			// flip output bytes
 	rev	x5,x5
 #endif
 	stp	x4,x5,[x1]		// write result
 
 	ret
-.size	poly1305_emit,.-poly1305_emit
-.type	poly1305_mult,%function
+ENDPROC(poly1305_emit_arm)
+
 .align	5
-poly1305_mult:
+__poly1305_mult:
 	mul	x12,x4,x7		// h0*r0
 	umulh	x13,x4,x7
 
@@ -193,11 +161,8 @@ poly1305_mult:
 	adc	x6,x6,xzr
 
 	ret
-.size	poly1305_mult,.-poly1305_mult
 
-.type	poly1305_splat,%function
-.align	5
-poly1305_splat:
+__poly1305_splat:
 	and	x12,x4,#0x03ffffff	// base 2^64 -> base 2^26
 	ubfx	x13,x4,#26,#26
 	extr	x14,x5,x4,#52
@@ -220,15 +185,14 @@ poly1305_splat:
 	str	w15,[x0,#16*8]	// s4
 
 	ret
-.size	poly1305_splat,.-poly1305_splat
 
-.type	poly1305_blocks_neon,%function
+#ifdef CONFIG_KERNEL_MODE_NEON
 .align	5
-poly1305_blocks_neon:
+ENTRY(poly1305_blocks_neon)
 	ldr	x17,[x0,#24]
 	cmp	x2,#128
 	b.hs	.Lblocks_neon
-	cbz	x17,poly1305_blocks
+	cbz	x17,poly1305_blocks_arm
 
 .Lblocks_neon:
 	stp	x29,x30,[sp,#-80]!
@@ -268,7 +232,7 @@ poly1305_blocks_neon:
 	adcs	x5,x5,xzr
 	adc	x6,x6,xzr
 
-#ifdef	__ARMEB__
+#ifdef	__AARCH64EB__
 	rev	x12,x12
 	rev	x13,x13
 #endif
@@ -276,7 +240,7 @@ poly1305_blocks_neon:
 	adcs	x5,x5,x13
 	adc	x6,x6,x3
 
-	bl	poly1305_mult
+	bl	__poly1305_mult
 	ldr	x30,[sp,#8]
 
 	cbz	x3,.Lstore_base2_64_neon
@@ -314,7 +278,7 @@ poly1305_blocks_neon:
 	ldp	x12,x13,[x1],#16	// load input
 	sub	x2,x2,#16
 	add	x9,x8,x8,lsr#2	// s1 = r1 + (r1 >> 2)
-#ifdef	__ARMEB__
+#ifdef	__AARCH64EB__
 	rev	x12,x12
 	rev	x13,x13
 #endif
@@ -322,7 +286,7 @@ poly1305_blocks_neon:
 	adcs	x5,x5,x13
 	adc	x6,x6,x3
 
-	bl	poly1305_mult
+	bl	__poly1305_mult
 
 .Linit_neon:
 	and	x10,x4,#0x03ffffff	// base 2^64 -> base 2^26
@@ -349,19 +313,19 @@ poly1305_blocks_neon:
 	mov	x5,x8
 	mov	x6,xzr
 	add	x0,x0,#48+12
-	bl	poly1305_splat
+	bl	__poly1305_splat
 
-	bl	poly1305_mult		// r^2
+	bl	__poly1305_mult		// r^2
 	sub	x0,x0,#4
-	bl	poly1305_splat
+	bl	__poly1305_splat
 
-	bl	poly1305_mult		// r^3
+	bl	__poly1305_mult		// r^3
 	sub	x0,x0,#4
-	bl	poly1305_splat
+	bl	__poly1305_splat
 
-	bl	poly1305_mult		// r^4
+	bl	__poly1305_mult		// r^4
 	sub	x0,x0,#4
-	bl	poly1305_splat
+	bl	__poly1305_splat
 	ldr	x30,[sp,#8]
 
 	add	x16,x1,#32
@@ -399,7 +363,7 @@ poly1305_blocks_neon:
 	lsl	x3,x3,#24
 	add	x15,x0,#48
 
-#ifdef	__ARMEB__
+#ifdef	__AARCH64EB__
 	rev	x8,x8
 	rev	x12,x12
 	rev	x9,x9
@@ -435,7 +399,7 @@ poly1305_blocks_neon:
 	ld1	{v4.4s,v5.4s,v6.4s,v7.4s},[x15],#64
 	ld1	{v8.4s},[x15]
 
-#ifdef	__ARMEB__
+#ifdef	__AARCH64EB__
 	rev	x8,x8
 	rev	x12,x12
 	rev	x9,x9
@@ -496,7 +460,7 @@ poly1305_blocks_neon:
 	umull	v20.2d,v14.2s,v1.s[2]
 	ldp	x9,x13,[x16],#48
 	umull	v19.2d,v14.2s,v0.s[2]
-#ifdef	__ARMEB__
+#ifdef	__AARCH64EB__
 	rev	x8,x8
 	rev	x12,x12
 	rev	x9,x9
@@ -561,7 +525,7 @@ poly1305_blocks_neon:
 	umlal	v23.2d,v11.2s,v3.s[0]
 	umlal	v20.2d,v11.2s,v8.s[0]
 	umlal	v21.2d,v11.2s,v0.s[0]
-#ifdef	__ARMEB__
+#ifdef	__AARCH64EB__
 	rev	x8,x8
 	rev	x12,x12
 	rev	x9,x9
@@ -801,13 +765,12 @@ poly1305_blocks_neon:
 .Lno_data_neon:
 	ldr	x29,[sp],#80
 	ret
-.size	poly1305_blocks_neon,.-poly1305_blocks_neon
+ENDPROC(poly1305_blocks_neon)
 
-.type	poly1305_emit_neon,%function
 .align	5
-poly1305_emit_neon:
+ENTRY(poly1305_emit_neon)
 	ldr	x17,[x0,#24]
-	cbz	x17,poly1305_emit
+	cbz	x17,poly1305_emit_arm
 
 	ldp	w10,w11,[x0]		// load hash value base 2^26
 	ldp	w12,w13,[x0,#8]
@@ -840,30 +803,22 @@ poly1305_emit_neon:
 	csel	x4,x4,x12,eq
 	csel	x5,x5,x13,eq
 
-#ifdef	__ARMEB__
+#ifdef	__AARCH64EB__
 	ror	x10,x10,#32		// flip nonce words
 	ror	x11,x11,#32
 #endif
 	adds	x4,x4,x10		// accumulate nonce
 	adc	x5,x5,x11
-#ifdef	__ARMEB__
+#ifdef	__AARCH64EB__
 	rev	x4,x4			// flip output bytes
 	rev	x5,x5
 #endif
 	stp	x4,x5,[x1]		// write result
 
 	ret
-.size	poly1305_emit_neon,.-poly1305_emit_neon
+ENDPROC(poly1305_emit_neon)
 
 .align	5
 .Lzeros:
 .long	0,0,0,0,0,0,0,0
-.LOPENSSL_armcap_P:
-#ifdef	__ILP32__
-.long	OPENSSL_armcap_P-.
-#else
-.quad	OPENSSL_armcap_P-.
 #endif
-.byte	80,111,108,121,49,51,48,53,32,102,111,114,32,65,82,77,118,56,44,32,67,82,89,80,84,79,71,65,77,83,32,98,121,32,60,97,112,112,114,111,64,111,112,101,110,115,115,108,46,111,114,103,62,0
-.align	2
-.align	2
diff --git a/lib/zinc/poly1305/poly1305.c b/lib/zinc/poly1305/poly1305.c
index 0a580f1328fc..21d9a0b9c11c 100644
--- a/lib/zinc/poly1305/poly1305.c
+++ b/lib/zinc/poly1305/poly1305.c
@@ -18,6 +18,8 @@
 
 #if defined(CONFIG_ZINC_ARCH_X86_64)
 #include "poly1305-x86_64-glue.c"
+#elif defined(CONFIG_ZINC_ARCH_ARM) || defined(CONFIG_ZINC_ARCH_ARM64)
+#include "poly1305-arm-glue.c"
 #else
 static inline bool poly1305_init_arch(void *ctx,
 				      const u8 key[POLY1305_KEY_SIZE])
-- 
2.19.1
