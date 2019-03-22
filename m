From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next v9 09/19] zinc: Poly1305 ARM and ARM64 implementations
Date: Fri, 22 Mar 2019 01:11:12 -0600
Message-Id: <20190322071122.6677-10-Jason@zx2c4.com>
In-Reply-To: <20190322071122.6677-1-Jason@zx2c4.com>
References: <20190322071122.6677-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Andy Polyakov <appro@openssl.org>, Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, Samuel Neves <sneves@dei.uc.pt>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, Andy Lutomirski <luto@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

These ARM implementations come from Andy Polyakov's implementations, and
perform extremely well on ARMv4+, with optimized paths for NEON and
non-NEON.

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

While this is CRYPTOGAMS code, the originating code for this happens to
be the same as OpenSSL's commit 9925a82146f2503b4dd11423d0eba649b43450c0

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Co-developed-by: Andy Polyakov <appro@openssl.org>
Cc: Andy Polyakov <appro@openssl.org>
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
 lib/zinc/Makefile                     |    4 +-
 lib/zinc/poly1305/poly1305-arm-glue.c |  140 +++
 lib/zinc/poly1305/poly1305-arm.pl     | 1276 +++++++++++++++++++++++++
 lib/zinc/poly1305/poly1305-arm64.pl   |  974 +++++++++++++++++++
 lib/zinc/poly1305/poly1305.c          |    2 +
 5 files changed, 2395 insertions(+), 1 deletion(-)
 create mode 100644 lib/zinc/poly1305/poly1305-arm-glue.c
 create mode 100644 lib/zinc/poly1305/poly1305-arm.pl
 create mode 100644 lib/zinc/poly1305/poly1305-arm64.pl

diff --git a/lib/zinc/Makefile b/lib/zinc/Makefile
index 6ec02f65f96f..488c5f2e3078 100644
--- a/lib/zinc/Makefile
+++ b/lib/zinc/Makefile
@@ -13,7 +13,9 @@ obj-$(CONFIG_ZINC_CHACHA20) += zinc_chacha20.o
 
 zinc_poly1305-y := poly1305/poly1305.o
 zinc_poly1305-$(CONFIG_ZINC_ARCH_X86_64) += poly1305/poly1305-x86_64.o
-perlasm-targets += poly1305/poly1305-x86_64.S
+zinc_poly1305-$(CONFIG_ZINC_ARCH_ARM) += poly1305/poly1305-arm.o
+zinc_poly1305-$(CONFIG_ZINC_ARCH_ARM64) += poly1305/poly1305-arm64.o
+perlasm-targets += poly1305/poly1305-x86_64.S poly1305/poly1305-arm.S poly1305/poly1305-arm64.S
 obj-$(CONFIG_ZINC_POLY1305) += zinc_poly1305.o
 
 quiet_cmd_perlasm = PERLASM $@
diff --git a/lib/zinc/poly1305/poly1305-arm-glue.c b/lib/zinc/poly1305/poly1305-arm-glue.c
new file mode 100644
index 000000000000..a80f0460ea13
--- /dev/null
+++ b/lib/zinc/poly1305/poly1305-arm-glue.c
@@ -0,0 +1,140 @@
+// SPDX-License-Identifier: GPL-2.0 OR MIT
+/*
+ * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
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
diff --git a/lib/zinc/poly1305/poly1305-arm.pl b/lib/zinc/poly1305/poly1305-arm.pl
new file mode 100644
index 000000000000..468f41b76fbd
--- /dev/null
+++ b/lib/zinc/poly1305/poly1305-arm.pl
@@ -0,0 +1,1276 @@
+#!/usr/bin/env perl
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+#
+# This code is taken from the OpenSSL project but the author, Andy Polyakov,
+# has relicensed it under the licenses specified in the SPDX header above.
+# The original headers, including the original license headers, are
+# included below for completeness.
+#
+# ====================================================================
+# Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
+# project. The module is, however, dual licensed under OpenSSL and
+# CRYPTOGAMS licenses depending on where you obtain it. For further
+# details see http://www.openssl.org/~appro/cryptogams/.
+# ====================================================================
+#
+#			IALU(*)/gcc-4.4		NEON
+#
+# ARM11xx(ARMv6)	7.78/+100%		-
+# Cortex-A5		6.35/+130%		3.00
+# Cortex-A8		6.25/+115%		2.36
+# Cortex-A9		5.10/+95%		2.55
+# Cortex-A15		3.85/+85%		1.25(**)
+# Snapdragon S4		5.70/+100%		1.48(**)
+#
+# (*)	this is for -march=armv6, i.e. with bunch of ldrb loading data;
+# (**)	these are trade-off results, they can be improved by ~8% but at
+#	the cost of 15/12% regression on Cortex-A5/A7, it's even possible
+#	to improve Cortex-A9 result, but then A5/A7 loose more than 20%;
+
+$flavour = shift;
+if ($flavour=~/\w[\w\-]*\.\w+$/) { $output=$flavour; undef $flavour; }
+else { while (($output=shift) && ($output!~/\w[\w\-]*\.\w+$/)) {} }
+
+if ($flavour && $flavour ne "void") {
+    $0 =~ m/(.*[\/\\])[^\/\\]+$/; $dir=$1;
+    ( $xlate="${dir}arm-xlate.pl" and -f $xlate ) or
+    ( $xlate="${dir}../../perlasm/arm-xlate.pl" and -f $xlate) or
+    die "can't locate arm-xlate.pl";
+
+    open STDOUT,"| \"$^X\" $xlate $flavour $output";
+} else {
+    open STDOUT,">$output";
+}
+
+($ctx,$inp,$len,$padbit)=map("r$_",(0..3));
+
+$code.=<<___;
+#ifndef	__KERNEL__
+# include "arm_arch.h"
+#else
+# define __ARM_ARCH__ __LINUX_ARM_ARCH__
+# define __ARM_MAX_ARCH__ __LINUX_ARM_ARCH__
+# define poly1305_init   poly1305_init_arm
+# define poly1305_blocks poly1305_blocks_arm
+# define poly1305_emit   poly1305_emit_arm
+#endif
+
+.text
+#if defined(__thumb2__)
+.syntax	unified
+.thumb
+#else
+.code	32
+#endif
+
+.globl	poly1305_emit
+.globl	poly1305_blocks
+.globl	poly1305_init
+.type	poly1305_init,%function
+.align	5
+poly1305_init:
+.Lpoly1305_init:
+	stmdb	sp!,{r4-r11}
+
+	eor	r3,r3,r3
+	cmp	$inp,#0
+	str	r3,[$ctx,#0]		@ zero hash value
+	str	r3,[$ctx,#4]
+	str	r3,[$ctx,#8]
+	str	r3,[$ctx,#12]
+	str	r3,[$ctx,#16]
+	str	r3,[$ctx,#36]		@ is_base2_26
+	add	$ctx,$ctx,#20
+
+#ifdef	__thumb2__
+	it	eq
+#endif
+	moveq	r0,#0
+	beq	.Lno_key
+
+#if	__ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
+	adr	r11,.Lpoly1305_init
+	ldr	r12,.LOPENSSL_armcap
+#endif
+	ldrb	r4,[$inp,#0]
+	mov	r10,#0x0fffffff
+	ldrb	r5,[$inp,#1]
+	and	r3,r10,#-4		@ 0x0ffffffc
+	ldrb	r6,[$inp,#2]
+	ldrb	r7,[$inp,#3]
+	orr	r4,r4,r5,lsl#8
+	ldrb	r5,[$inp,#4]
+	orr	r4,r4,r6,lsl#16
+	ldrb	r6,[$inp,#5]
+	orr	r4,r4,r7,lsl#24
+	ldrb	r7,[$inp,#6]
+	and	r4,r4,r10
+
+#if	__ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
+	ldr	r12,[r11,r12]		@ OPENSSL_armcap_P
+# ifdef	__APPLE__
+	ldr	r12,[r12]
+# endif
+#endif
+	ldrb	r8,[$inp,#7]
+	orr	r5,r5,r6,lsl#8
+	ldrb	r6,[$inp,#8]
+	orr	r5,r5,r7,lsl#16
+	ldrb	r7,[$inp,#9]
+	orr	r5,r5,r8,lsl#24
+	ldrb	r8,[$inp,#10]
+	and	r5,r5,r3
+
+#if	__ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
+	tst	r12,#ARMV7_NEON		@ check for NEON
+# ifdef	__APPLE__
+	adr	r9,poly1305_blocks_neon
+	adr	r11,poly1305_blocks
+#  ifdef __thumb2__
+	it	ne
+#  endif
+	movne	r11,r9
+	adr	r12,poly1305_emit
+	adr	r10,poly1305_emit_neon
+#  ifdef __thumb2__
+	it	ne
+#  endif
+	movne	r12,r10
+# else
+#  ifdef __thumb2__
+	itete	eq
+#  endif
+	addeq	r12,r11,#(poly1305_emit-.Lpoly1305_init)
+	addne	r12,r11,#(poly1305_emit_neon-.Lpoly1305_init)
+	addeq	r11,r11,#(poly1305_blocks-.Lpoly1305_init)
+	addne	r11,r11,#(poly1305_blocks_neon-.Lpoly1305_init)
+# endif
+# ifdef	__thumb2__
+	orr	r12,r12,#1	@ thumb-ify address
+	orr	r11,r11,#1
+# endif
+#endif
+	ldrb	r9,[$inp,#11]
+	orr	r6,r6,r7,lsl#8
+	ldrb	r7,[$inp,#12]
+	orr	r6,r6,r8,lsl#16
+	ldrb	r8,[$inp,#13]
+	orr	r6,r6,r9,lsl#24
+	ldrb	r9,[$inp,#14]
+	and	r6,r6,r3
+
+	ldrb	r10,[$inp,#15]
+	orr	r7,r7,r8,lsl#8
+	str	r4,[$ctx,#0]
+	orr	r7,r7,r9,lsl#16
+	str	r5,[$ctx,#4]
+	orr	r7,r7,r10,lsl#24
+	str	r6,[$ctx,#8]
+	and	r7,r7,r3
+	str	r7,[$ctx,#12]
+#if	__ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
+	stmia	r2,{r11,r12}		@ fill functions table
+	mov	r0,#1
+#else
+	mov	r0,#0
+#endif
+.Lno_key:
+	ldmia	sp!,{r4-r11}
+#if	__ARM_ARCH__>=5
+	ret				@ bx	lr
+#else
+	tst	lr,#1
+	moveq	pc,lr			@ be binary compatible with V4, yet
+	bx	lr			@ interoperable with Thumb ISA:-)
+#endif
+.size	poly1305_init,.-poly1305_init
+___
+{
+my ($h0,$h1,$h2,$h3,$h4,$r0,$r1,$r2,$r3)=map("r$_",(4..12));
+my ($s1,$s2,$s3)=($r1,$r2,$r3);
+
+$code.=<<___;
+.type	poly1305_blocks,%function
+.align	5
+poly1305_blocks:
+.Lpoly1305_blocks:
+	stmdb	sp!,{r3-r11,lr}
+
+	ands	$len,$len,#-16
+	beq	.Lno_data
+
+	cmp	$padbit,#0
+	add	$len,$len,$inp		@ end pointer
+	sub	sp,sp,#32
+
+	ldmia	$ctx,{$h0-$r3}		@ load context
+
+	str	$ctx,[sp,#12]		@ offload stuff
+	mov	lr,$inp
+	str	$len,[sp,#16]
+	str	$r1,[sp,#20]
+	str	$r2,[sp,#24]
+	str	$r3,[sp,#28]
+	b	.Loop
+
+.Loop:
+#if __ARM_ARCH__<7
+	ldrb	r0,[lr],#16		@ load input
+# ifdef	__thumb2__
+	it	hi
+# endif
+	addhi	$h4,$h4,#1		@ 1<<128
+	ldrb	r1,[lr,#-15]
+	ldrb	r2,[lr,#-14]
+	ldrb	r3,[lr,#-13]
+	orr	r1,r0,r1,lsl#8
+	ldrb	r0,[lr,#-12]
+	orr	r2,r1,r2,lsl#16
+	ldrb	r1,[lr,#-11]
+	orr	r3,r2,r3,lsl#24
+	ldrb	r2,[lr,#-10]
+	adds	$h0,$h0,r3		@ accumulate input
+
+	ldrb	r3,[lr,#-9]
+	orr	r1,r0,r1,lsl#8
+	ldrb	r0,[lr,#-8]
+	orr	r2,r1,r2,lsl#16
+	ldrb	r1,[lr,#-7]
+	orr	r3,r2,r3,lsl#24
+	ldrb	r2,[lr,#-6]
+	adcs	$h1,$h1,r3
+
+	ldrb	r3,[lr,#-5]
+	orr	r1,r0,r1,lsl#8
+	ldrb	r0,[lr,#-4]
+	orr	r2,r1,r2,lsl#16
+	ldrb	r1,[lr,#-3]
+	orr	r3,r2,r3,lsl#24
+	ldrb	r2,[lr,#-2]
+	adcs	$h2,$h2,r3
+
+	ldrb	r3,[lr,#-1]
+	orr	r1,r0,r1,lsl#8
+	str	lr,[sp,#8]		@ offload input pointer
+	orr	r2,r1,r2,lsl#16
+	add	$s1,$r1,$r1,lsr#2
+	orr	r3,r2,r3,lsl#24
+#else
+	ldr	r0,[lr],#16		@ load input
+# ifdef	__thumb2__
+	it	hi
+# endif
+	addhi	$h4,$h4,#1		@ padbit
+	ldr	r1,[lr,#-12]
+	ldr	r2,[lr,#-8]
+	ldr	r3,[lr,#-4]
+# ifdef	__ARMEB__
+	rev	r0,r0
+	rev	r1,r1
+	rev	r2,r2
+	rev	r3,r3
+# endif
+	adds	$h0,$h0,r0		@ accumulate input
+	str	lr,[sp,#8]		@ offload input pointer
+	adcs	$h1,$h1,r1
+	add	$s1,$r1,$r1,lsr#2
+	adcs	$h2,$h2,r2
+#endif
+	add	$s2,$r2,$r2,lsr#2
+	adcs	$h3,$h3,r3
+	add	$s3,$r3,$r3,lsr#2
+
+	umull	r2,r3,$h1,$r0
+	 adc	$h4,$h4,#0
+	umull	r0,r1,$h0,$r0
+	umlal	r2,r3,$h4,$s1
+	umlal	r0,r1,$h3,$s1
+	ldr	$r1,[sp,#20]		@ reload $r1
+	umlal	r2,r3,$h2,$s3
+	umlal	r0,r1,$h1,$s3
+	umlal	r2,r3,$h3,$s2
+	umlal	r0,r1,$h2,$s2
+	umlal	r2,r3,$h0,$r1
+	str	r0,[sp,#0]		@ future $h0
+	 mul	r0,$s2,$h4
+	ldr	$r2,[sp,#24]		@ reload $r2
+	adds	r2,r2,r1		@ d1+=d0>>32
+	 eor	r1,r1,r1
+	adc	lr,r3,#0		@ future $h2
+	str	r2,[sp,#4]		@ future $h1
+
+	mul	r2,$s3,$h4
+	eor	r3,r3,r3
+	umlal	r0,r1,$h3,$s3
+	ldr	$r3,[sp,#28]		@ reload $r3
+	umlal	r2,r3,$h3,$r0
+	umlal	r0,r1,$h2,$r0
+	umlal	r2,r3,$h2,$r1
+	umlal	r0,r1,$h1,$r1
+	umlal	r2,r3,$h1,$r2
+	umlal	r0,r1,$h0,$r2
+	umlal	r2,r3,$h0,$r3
+	ldr	$h0,[sp,#0]
+	mul	$h4,$r0,$h4
+	ldr	$h1,[sp,#4]
+
+	adds	$h2,lr,r0		@ d2+=d1>>32
+	ldr	lr,[sp,#8]		@ reload input pointer
+	adc	r1,r1,#0
+	adds	$h3,r2,r1		@ d3+=d2>>32
+	ldr	r0,[sp,#16]		@ reload end pointer
+	adc	r3,r3,#0
+	add	$h4,$h4,r3		@ h4+=d3>>32
+
+	and	r1,$h4,#-4
+	and	$h4,$h4,#3
+	add	r1,r1,r1,lsr#2		@ *=5
+	adds	$h0,$h0,r1
+	adcs	$h1,$h1,#0
+	adcs	$h2,$h2,#0
+	adcs	$h3,$h3,#0
+	adc	$h4,$h4,#0
+
+	cmp	r0,lr			@ done yet?
+	bhi	.Loop
+
+	ldr	$ctx,[sp,#12]
+	add	sp,sp,#32
+	stmia	$ctx,{$h0-$h4}		@ store the result
+
+.Lno_data:
+#if	__ARM_ARCH__>=5
+	ldmia	sp!,{r3-r11,pc}
+#else
+	ldmia	sp!,{r3-r11,lr}
+	tst	lr,#1
+	moveq	pc,lr			@ be binary compatible with V4, yet
+	bx	lr			@ interoperable with Thumb ISA:-)
+#endif
+.size	poly1305_blocks,.-poly1305_blocks
+___
+}
+{
+my ($ctx,$mac,$nonce)=map("r$_",(0..2));
+my ($h0,$h1,$h2,$h3,$h4,$g0,$g1,$g2,$g3)=map("r$_",(3..11));
+my $g4=$h4;
+
+$code.=<<___;
+.type	poly1305_emit,%function
+.align	5
+poly1305_emit:
+	stmdb	sp!,{r4-r11}
+.Lpoly1305_emit_enter:
+
+	ldmia	$ctx,{$h0-$h4}
+	adds	$g0,$h0,#5		@ compare to modulus
+	adcs	$g1,$h1,#0
+	adcs	$g2,$h2,#0
+	adcs	$g3,$h3,#0
+	adc	$g4,$h4,#0
+	tst	$g4,#4			@ did it carry/borrow?
+
+#ifdef	__thumb2__
+	it	ne
+#endif
+	movne	$h0,$g0
+	ldr	$g0,[$nonce,#0]
+#ifdef	__thumb2__
+	it	ne
+#endif
+	movne	$h1,$g1
+	ldr	$g1,[$nonce,#4]
+#ifdef	__thumb2__
+	it	ne
+#endif
+	movne	$h2,$g2
+	ldr	$g2,[$nonce,#8]
+#ifdef	__thumb2__
+	it	ne
+#endif
+	movne	$h3,$g3
+	ldr	$g3,[$nonce,#12]
+
+	adds	$h0,$h0,$g0
+	adcs	$h1,$h1,$g1
+	adcs	$h2,$h2,$g2
+	adc	$h3,$h3,$g3
+
+#if __ARM_ARCH__>=7
+# ifdef __ARMEB__
+	rev	$h0,$h0
+	rev	$h1,$h1
+	rev	$h2,$h2
+	rev	$h3,$h3
+# endif
+	str	$h0,[$mac,#0]
+	str	$h1,[$mac,#4]
+	str	$h2,[$mac,#8]
+	str	$h3,[$mac,#12]
+#else
+	strb	$h0,[$mac,#0]
+	mov	$h0,$h0,lsr#8
+	strb	$h1,[$mac,#4]
+	mov	$h1,$h1,lsr#8
+	strb	$h2,[$mac,#8]
+	mov	$h2,$h2,lsr#8
+	strb	$h3,[$mac,#12]
+	mov	$h3,$h3,lsr#8
+
+	strb	$h0,[$mac,#1]
+	mov	$h0,$h0,lsr#8
+	strb	$h1,[$mac,#5]
+	mov	$h1,$h1,lsr#8
+	strb	$h2,[$mac,#9]
+	mov	$h2,$h2,lsr#8
+	strb	$h3,[$mac,#13]
+	mov	$h3,$h3,lsr#8
+
+	strb	$h0,[$mac,#2]
+	mov	$h0,$h0,lsr#8
+	strb	$h1,[$mac,#6]
+	mov	$h1,$h1,lsr#8
+	strb	$h2,[$mac,#10]
+	mov	$h2,$h2,lsr#8
+	strb	$h3,[$mac,#14]
+	mov	$h3,$h3,lsr#8
+
+	strb	$h0,[$mac,#3]
+	strb	$h1,[$mac,#7]
+	strb	$h2,[$mac,#11]
+	strb	$h3,[$mac,#15]
+#endif
+	ldmia	sp!,{r4-r11}
+#if	__ARM_ARCH__>=5
+	ret				@ bx	lr
+#else
+	tst	lr,#1
+	moveq	pc,lr			@ be binary compatible with V4, yet
+	bx	lr			@ interoperable with Thumb ISA:-)
+#endif
+.size	poly1305_emit,.-poly1305_emit
+___
+{
+my ($R0,$R1,$S1,$R2,$S2,$R3,$S3,$R4,$S4) = map("d$_",(0..9));
+my ($D0,$D1,$D2,$D3,$D4, $H0,$H1,$H2,$H3,$H4) = map("q$_",(5..14));
+my ($T0,$T1,$MASK) = map("q$_",(15,4,0));
+
+my ($in2,$zeros,$tbl0,$tbl1) = map("r$_",(4..7));
+
+$code.=<<___;
+#if (defined(__KERNEL__) && defined(CONFIG_KERNEL_MODE_NEON)) || (!defined(__KERNEL__) && __ARM_MAX_ARCH__>=7)
+.fpu	neon
+
+.type	poly1305_init_neon,%function
+.align	5
+poly1305_init_neon:
+.Lpoly1305_init_neon:
+	ldr	r4,[$ctx,#20]		@ load key base 2^32
+	ldr	r5,[$ctx,#24]
+	ldr	r6,[$ctx,#28]
+	ldr	r7,[$ctx,#32]
+
+	and	r2,r4,#0x03ffffff	@ base 2^32 -> base 2^26
+	mov	r3,r4,lsr#26
+	mov	r4,r5,lsr#20
+	orr	r3,r3,r5,lsl#6
+	mov	r5,r6,lsr#14
+	orr	r4,r4,r6,lsl#12
+	mov	r6,r7,lsr#8
+	orr	r5,r5,r7,lsl#18
+	and	r3,r3,#0x03ffffff
+	and	r4,r4,#0x03ffffff
+	and	r5,r5,#0x03ffffff
+
+	vdup.32	$R0,r2			@ r^1 in both lanes
+	add	r2,r3,r3,lsl#2		@ *5
+	vdup.32	$R1,r3
+	add	r3,r4,r4,lsl#2
+	vdup.32	$S1,r2
+	vdup.32	$R2,r4
+	add	r4,r5,r5,lsl#2
+	vdup.32	$S2,r3
+	vdup.32	$R3,r5
+	add	r5,r6,r6,lsl#2
+	vdup.32	$S3,r4
+	vdup.32	$R4,r6
+	vdup.32	$S4,r5
+
+	mov	$zeros,#2		@ counter
+
+.Lsquare_neon:
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ d0 = h0*r0 + h4*5*r1 + h3*5*r2 + h2*5*r3 + h1*5*r4
+	@ d1 = h1*r0 + h0*r1   + h4*5*r2 + h3*5*r3 + h2*5*r4
+	@ d2 = h2*r0 + h1*r1   + h0*r2   + h4*5*r3 + h3*5*r4
+	@ d3 = h3*r0 + h2*r1   + h1*r2   + h0*r3   + h4*5*r4
+	@ d4 = h4*r0 + h3*r1   + h2*r2   + h1*r3   + h0*r4
+
+	vmull.u32	$D0,$R0,${R0}[1]
+	vmull.u32	$D1,$R1,${R0}[1]
+	vmull.u32	$D2,$R2,${R0}[1]
+	vmull.u32	$D3,$R3,${R0}[1]
+	vmull.u32	$D4,$R4,${R0}[1]
+
+	vmlal.u32	$D0,$R4,${S1}[1]
+	vmlal.u32	$D1,$R0,${R1}[1]
+	vmlal.u32	$D2,$R1,${R1}[1]
+	vmlal.u32	$D3,$R2,${R1}[1]
+	vmlal.u32	$D4,$R3,${R1}[1]
+
+	vmlal.u32	$D0,$R3,${S2}[1]
+	vmlal.u32	$D1,$R4,${S2}[1]
+	vmlal.u32	$D3,$R1,${R2}[1]
+	vmlal.u32	$D2,$R0,${R2}[1]
+	vmlal.u32	$D4,$R2,${R2}[1]
+
+	vmlal.u32	$D0,$R2,${S3}[1]
+	vmlal.u32	$D3,$R0,${R3}[1]
+	vmlal.u32	$D1,$R3,${S3}[1]
+	vmlal.u32	$D2,$R4,${S3}[1]
+	vmlal.u32	$D4,$R1,${R3}[1]
+
+	vmlal.u32	$D3,$R4,${S4}[1]
+	vmlal.u32	$D0,$R1,${S4}[1]
+	vmlal.u32	$D1,$R2,${S4}[1]
+	vmlal.u32	$D2,$R3,${S4}[1]
+	vmlal.u32	$D4,$R0,${R4}[1]
+
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ lazy reduction as discussed in "NEON crypto" by D.J. Bernstein
+	@ and P. Schwabe
+	@
+	@ H0>>+H1>>+H2>>+H3>>+H4
+	@ H3>>+H4>>*5+H0>>+H1
+	@
+	@ Trivia.
+	@
+	@ Result of multiplication of n-bit number by m-bit number is
+	@ n+m bits wide. However! Even though 2^n is a n+1-bit number,
+	@ m-bit number multiplied by 2^n is still n+m bits wide.
+	@
+	@ Sum of two n-bit numbers is n+1 bits wide, sum of three - n+2,
+	@ and so is sum of four. Sum of 2^m n-m-bit numbers and n-bit
+	@ one is n+1 bits wide.
+	@
+	@ >>+ denotes Hnext += Hn>>26, Hn &= 0x3ffffff. This means that
+	@ H0, H2, H3 are guaranteed to be 26 bits wide, while H1 and H4
+	@ can be 27. However! In cases when their width exceeds 26 bits
+	@ they are limited by 2^26+2^6. This in turn means that *sum*
+	@ of the products with these values can still be viewed as sum
+	@ of 52-bit numbers as long as the amount of addends is not a
+	@ power of 2. For example,
+	@
+	@ H4 = H4*R0 + H3*R1 + H2*R2 + H1*R3 + H0 * R4,
+	@
+	@ which can't be larger than 5 * (2^26 + 2^6) * (2^26 + 2^6), or
+	@ 5 * (2^52 + 2*2^32 + 2^12), which in turn is smaller than
+	@ 8 * (2^52) or 2^55. However, the value is then multiplied by
+	@ by 5, so we should be looking at 5 * 5 * (2^52 + 2^33 + 2^12),
+	@ which is less than 32 * (2^52) or 2^57. And when processing
+	@ data we are looking at triple as many addends...
+	@
+	@ In key setup procedure pre-reduced H0 is limited by 5*4+1 and
+	@ 5*H4 - by 5*5 52-bit addends, or 57 bits. But when hashing the
+	@ input H0 is limited by (5*4+1)*3 addends, or 58 bits, while
+	@ 5*H4 by 5*5*3, or 59[!] bits. How is this relevant? vmlal.u32
+	@ instruction accepts 2x32-bit input and writes 2x64-bit result.
+	@ This means that result of reduction have to be compressed upon
+	@ loop wrap-around. This can be done in the process of reduction
+	@ to minimize amount of instructions [as well as amount of
+	@ 128-bit instructions, which benefits low-end processors], but
+	@ one has to watch for H2 (which is narrower than H0) and 5*H4
+	@ not being wider than 58 bits, so that result of right shift
+	@ by 26 bits fits in 32 bits. This is also useful on x86,
+	@ because it allows to use paddd in place for paddq, which
+	@ benefits Atom, where paddq is ridiculously slow.
+
+	vshr.u64	$T0,$D3,#26
+	vmovn.i64	$D3#lo,$D3
+	 vshr.u64	$T1,$D0,#26
+	 vmovn.i64	$D0#lo,$D0
+	vadd.i64	$D4,$D4,$T0		@ h3 -> h4
+	vbic.i32	$D3#lo,#0xfc000000	@ &=0x03ffffff
+	 vadd.i64	$D1,$D1,$T1		@ h0 -> h1
+	 vbic.i32	$D0#lo,#0xfc000000
+
+	vshrn.u64	$T0#lo,$D4,#26
+	vmovn.i64	$D4#lo,$D4
+	 vshr.u64	$T1,$D1,#26
+	 vmovn.i64	$D1#lo,$D1
+	 vadd.i64	$D2,$D2,$T1		@ h1 -> h2
+	vbic.i32	$D4#lo,#0xfc000000
+	 vbic.i32	$D1#lo,#0xfc000000
+
+	vadd.i32	$D0#lo,$D0#lo,$T0#lo
+	vshl.u32	$T0#lo,$T0#lo,#2
+	 vshrn.u64	$T1#lo,$D2,#26
+	 vmovn.i64	$D2#lo,$D2
+	vadd.i32	$D0#lo,$D0#lo,$T0#lo	@ h4 -> h0
+	 vadd.i32	$D3#lo,$D3#lo,$T1#lo	@ h2 -> h3
+	 vbic.i32	$D2#lo,#0xfc000000
+
+	vshr.u32	$T0#lo,$D0#lo,#26
+	vbic.i32	$D0#lo,#0xfc000000
+	 vshr.u32	$T1#lo,$D3#lo,#26
+	 vbic.i32	$D3#lo,#0xfc000000
+	vadd.i32	$D1#lo,$D1#lo,$T0#lo	@ h0 -> h1
+	 vadd.i32	$D4#lo,$D4#lo,$T1#lo	@ h3 -> h4
+
+	subs		$zeros,$zeros,#1
+	beq		.Lsquare_break_neon
+
+	add		$tbl0,$ctx,#(48+0*9*4)
+	add		$tbl1,$ctx,#(48+1*9*4)
+
+	vtrn.32		$R0,$D0#lo		@ r^2:r^1
+	vtrn.32		$R2,$D2#lo
+	vtrn.32		$R3,$D3#lo
+	vtrn.32		$R1,$D1#lo
+	vtrn.32		$R4,$D4#lo
+
+	vshl.u32	$S2,$R2,#2		@ *5
+	vshl.u32	$S3,$R3,#2
+	vshl.u32	$S1,$R1,#2
+	vshl.u32	$S4,$R4,#2
+	vadd.i32	$S2,$S2,$R2
+	vadd.i32	$S1,$S1,$R1
+	vadd.i32	$S3,$S3,$R3
+	vadd.i32	$S4,$S4,$R4
+
+	vst4.32		{${R0}[0],${R1}[0],${S1}[0],${R2}[0]},[$tbl0]!
+	vst4.32		{${R0}[1],${R1}[1],${S1}[1],${R2}[1]},[$tbl1]!
+	vst4.32		{${S2}[0],${R3}[0],${S3}[0],${R4}[0]},[$tbl0]!
+	vst4.32		{${S2}[1],${R3}[1],${S3}[1],${R4}[1]},[$tbl1]!
+	vst1.32		{${S4}[0]},[$tbl0,:32]
+	vst1.32		{${S4}[1]},[$tbl1,:32]
+
+	b		.Lsquare_neon
+
+.align	4
+.Lsquare_break_neon:
+	add		$tbl0,$ctx,#(48+2*4*9)
+	add		$tbl1,$ctx,#(48+3*4*9)
+
+	vmov		$R0,$D0#lo		@ r^4:r^3
+	vshl.u32	$S1,$D1#lo,#2		@ *5
+	vmov		$R1,$D1#lo
+	vshl.u32	$S2,$D2#lo,#2
+	vmov		$R2,$D2#lo
+	vshl.u32	$S3,$D3#lo,#2
+	vmov		$R3,$D3#lo
+	vshl.u32	$S4,$D4#lo,#2
+	vmov		$R4,$D4#lo
+	vadd.i32	$S1,$S1,$D1#lo
+	vadd.i32	$S2,$S2,$D2#lo
+	vadd.i32	$S3,$S3,$D3#lo
+	vadd.i32	$S4,$S4,$D4#lo
+
+	vst4.32		{${R0}[0],${R1}[0],${S1}[0],${R2}[0]},[$tbl0]!
+	vst4.32		{${R0}[1],${R1}[1],${S1}[1],${R2}[1]},[$tbl1]!
+	vst4.32		{${S2}[0],${R3}[0],${S3}[0],${R4}[0]},[$tbl0]!
+	vst4.32		{${S2}[1],${R3}[1],${S3}[1],${R4}[1]},[$tbl1]!
+	vst1.32		{${S4}[0]},[$tbl0]
+	vst1.32		{${S4}[1]},[$tbl1]
+
+	ret				@ bx	lr
+.size	poly1305_init_neon,.-poly1305_init_neon
+
+#ifdef __KERNEL__
+.globl	poly1305_blocks_neon
+#endif
+.type	poly1305_blocks_neon,%function
+.align	5
+poly1305_blocks_neon:
+	ldr	ip,[$ctx,#36]		@ is_base2_26
+	ands	$len,$len,#-16
+	beq	.Lno_data_neon
+
+	cmp	$len,#64
+	bhs	.Lenter_neon
+	tst	ip,ip			@ is_base2_26?
+	beq	.Lpoly1305_blocks
+
+.Lenter_neon:
+	stmdb	sp!,{r4-r7}
+	vstmdb	sp!,{d8-d15}		@ ABI specification says so
+
+	tst	ip,ip			@ is_base2_26?
+	bne	.Lbase2_26_neon
+
+	stmdb	sp!,{r1-r3,lr}
+	bl	.Lpoly1305_init_neon
+
+	ldr	r4,[$ctx,#0]		@ load hash value base 2^32
+	ldr	r5,[$ctx,#4]
+	ldr	r6,[$ctx,#8]
+	ldr	r7,[$ctx,#12]
+	ldr	ip,[$ctx,#16]
+
+	and	r2,r4,#0x03ffffff	@ base 2^32 -> base 2^26
+	mov	r3,r4,lsr#26
+	 veor	$D0#lo,$D0#lo,$D0#lo
+	mov	r4,r5,lsr#20
+	orr	r3,r3,r5,lsl#6
+	 veor	$D1#lo,$D1#lo,$D1#lo
+	mov	r5,r6,lsr#14
+	orr	r4,r4,r6,lsl#12
+	 veor	$D2#lo,$D2#lo,$D2#lo
+	mov	r6,r7,lsr#8
+	orr	r5,r5,r7,lsl#18
+	 veor	$D3#lo,$D3#lo,$D3#lo
+	and	r3,r3,#0x03ffffff
+	orr	r6,r6,ip,lsl#24
+	 veor	$D4#lo,$D4#lo,$D4#lo
+	and	r4,r4,#0x03ffffff
+	mov	r1,#1
+	and	r5,r5,#0x03ffffff
+	str	r1,[$ctx,#36]		@ is_base2_26
+
+	vmov.32	$D0#lo[0],r2
+	vmov.32	$D1#lo[0],r3
+	vmov.32	$D2#lo[0],r4
+	vmov.32	$D3#lo[0],r5
+	vmov.32	$D4#lo[0],r6
+	adr	$zeros,.Lzeros
+
+	ldmia	sp!,{r1-r3,lr}
+	b	.Lbase2_32_neon
+
+.align	4
+.Lbase2_26_neon:
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ load hash value
+
+	veor		$D0#lo,$D0#lo,$D0#lo
+	veor		$D1#lo,$D1#lo,$D1#lo
+	veor		$D2#lo,$D2#lo,$D2#lo
+	veor		$D3#lo,$D3#lo,$D3#lo
+	veor		$D4#lo,$D4#lo,$D4#lo
+	vld4.32		{$D0#lo[0],$D1#lo[0],$D2#lo[0],$D3#lo[0]},[$ctx]!
+	adr		$zeros,.Lzeros
+	vld1.32		{$D4#lo[0]},[$ctx]
+	sub		$ctx,$ctx,#16		@ rewind
+
+.Lbase2_32_neon:
+	add		$in2,$inp,#32
+	mov		$padbit,$padbit,lsl#24
+	tst		$len,#31
+	beq		.Leven
+
+	vld4.32		{$H0#lo[0],$H1#lo[0],$H2#lo[0],$H3#lo[0]},[$inp]!
+	vmov.32		$H4#lo[0],$padbit
+	sub		$len,$len,#16
+	add		$in2,$inp,#32
+
+# ifdef	__ARMEB__
+	vrev32.8	$H0,$H0
+	vrev32.8	$H3,$H3
+	vrev32.8	$H1,$H1
+	vrev32.8	$H2,$H2
+# endif
+	vsri.u32	$H4#lo,$H3#lo,#8	@ base 2^32 -> base 2^26
+	vshl.u32	$H3#lo,$H3#lo,#18
+
+	vsri.u32	$H3#lo,$H2#lo,#14
+	vshl.u32	$H2#lo,$H2#lo,#12
+	vadd.i32	$H4#hi,$H4#lo,$D4#lo	@ add hash value and move to #hi
+
+	vbic.i32	$H3#lo,#0xfc000000
+	vsri.u32	$H2#lo,$H1#lo,#20
+	vshl.u32	$H1#lo,$H1#lo,#6
+
+	vbic.i32	$H2#lo,#0xfc000000
+	vsri.u32	$H1#lo,$H0#lo,#26
+	vadd.i32	$H3#hi,$H3#lo,$D3#lo
+
+	vbic.i32	$H0#lo,#0xfc000000
+	vbic.i32	$H1#lo,#0xfc000000
+	vadd.i32	$H2#hi,$H2#lo,$D2#lo
+
+	vadd.i32	$H0#hi,$H0#lo,$D0#lo
+	vadd.i32	$H1#hi,$H1#lo,$D1#lo
+
+	mov		$tbl1,$zeros
+	add		$tbl0,$ctx,#48
+
+	cmp		$len,$len
+	b		.Long_tail
+
+.align	4
+.Leven:
+	subs		$len,$len,#64
+	it		lo
+	movlo		$in2,$zeros
+
+	vmov.i32	$H4,#1<<24		@ padbit, yes, always
+	vld4.32		{$H0#lo,$H1#lo,$H2#lo,$H3#lo},[$inp]	@ inp[0:1]
+	add		$inp,$inp,#64
+	vld4.32		{$H0#hi,$H1#hi,$H2#hi,$H3#hi},[$in2]	@ inp[2:3] (or 0)
+	add		$in2,$in2,#64
+	itt		hi
+	addhi		$tbl1,$ctx,#(48+1*9*4)
+	addhi		$tbl0,$ctx,#(48+3*9*4)
+
+# ifdef	__ARMEB__
+	vrev32.8	$H0,$H0
+	vrev32.8	$H3,$H3
+	vrev32.8	$H1,$H1
+	vrev32.8	$H2,$H2
+# endif
+	vsri.u32	$H4,$H3,#8		@ base 2^32 -> base 2^26
+	vshl.u32	$H3,$H3,#18
+
+	vsri.u32	$H3,$H2,#14
+	vshl.u32	$H2,$H2,#12
+
+	vbic.i32	$H3,#0xfc000000
+	vsri.u32	$H2,$H1,#20
+	vshl.u32	$H1,$H1,#6
+
+	vbic.i32	$H2,#0xfc000000
+	vsri.u32	$H1,$H0,#26
+
+	vbic.i32	$H0,#0xfc000000
+	vbic.i32	$H1,#0xfc000000
+
+	bls		.Lskip_loop
+
+	vld4.32		{${R0}[1],${R1}[1],${S1}[1],${R2}[1]},[$tbl1]!	@ load r^2
+	vld4.32		{${R0}[0],${R1}[0],${S1}[0],${R2}[0]},[$tbl0]!	@ load r^4
+	vld4.32		{${S2}[1],${R3}[1],${S3}[1],${R4}[1]},[$tbl1]!
+	vld4.32		{${S2}[0],${R3}[0],${S3}[0],${R4}[0]},[$tbl0]!
+	b		.Loop_neon
+
+.align	5
+.Loop_neon:
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ ((inp[0]*r^4+inp[2]*r^2+inp[4])*r^4+inp[6]*r^2
+	@ ((inp[1]*r^4+inp[3]*r^2+inp[5])*r^3+inp[7]*r
+	@   \___________________/
+	@ ((inp[0]*r^4+inp[2]*r^2+inp[4])*r^4+inp[6]*r^2+inp[8])*r^2
+	@ ((inp[1]*r^4+inp[3]*r^2+inp[5])*r^4+inp[7]*r^2+inp[9])*r
+	@   \___________________/ \____________________/
+	@
+	@ Note that we start with inp[2:3]*r^2. This is because it
+	@ doesn't depend on reduction in previous iteration.
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ d4 = h4*r0 + h3*r1   + h2*r2   + h1*r3   + h0*r4
+	@ d3 = h3*r0 + h2*r1   + h1*r2   + h0*r3   + h4*5*r4
+	@ d2 = h2*r0 + h1*r1   + h0*r2   + h4*5*r3 + h3*5*r4
+	@ d1 = h1*r0 + h0*r1   + h4*5*r2 + h3*5*r3 + h2*5*r4
+	@ d0 = h0*r0 + h4*5*r1 + h3*5*r2 + h2*5*r3 + h1*5*r4
+
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ inp[2:3]*r^2
+
+	vadd.i32	$H2#lo,$H2#lo,$D2#lo	@ accumulate inp[0:1]
+	vmull.u32	$D2,$H2#hi,${R0}[1]
+	vadd.i32	$H0#lo,$H0#lo,$D0#lo
+	vmull.u32	$D0,$H0#hi,${R0}[1]
+	vadd.i32	$H3#lo,$H3#lo,$D3#lo
+	vmull.u32	$D3,$H3#hi,${R0}[1]
+	vmlal.u32	$D2,$H1#hi,${R1}[1]
+	vadd.i32	$H1#lo,$H1#lo,$D1#lo
+	vmull.u32	$D1,$H1#hi,${R0}[1]
+
+	vadd.i32	$H4#lo,$H4#lo,$D4#lo
+	vmull.u32	$D4,$H4#hi,${R0}[1]
+	subs		$len,$len,#64
+	vmlal.u32	$D0,$H4#hi,${S1}[1]
+	it		lo
+	movlo		$in2,$zeros
+	vmlal.u32	$D3,$H2#hi,${R1}[1]
+	vld1.32		${S4}[1],[$tbl1,:32]
+	vmlal.u32	$D1,$H0#hi,${R1}[1]
+	vmlal.u32	$D4,$H3#hi,${R1}[1]
+
+	vmlal.u32	$D0,$H3#hi,${S2}[1]
+	vmlal.u32	$D3,$H1#hi,${R2}[1]
+	vmlal.u32	$D4,$H2#hi,${R2}[1]
+	vmlal.u32	$D1,$H4#hi,${S2}[1]
+	vmlal.u32	$D2,$H0#hi,${R2}[1]
+
+	vmlal.u32	$D3,$H0#hi,${R3}[1]
+	vmlal.u32	$D0,$H2#hi,${S3}[1]
+	vmlal.u32	$D4,$H1#hi,${R3}[1]
+	vmlal.u32	$D1,$H3#hi,${S3}[1]
+	vmlal.u32	$D2,$H4#hi,${S3}[1]
+
+	vmlal.u32	$D3,$H4#hi,${S4}[1]
+	vmlal.u32	$D0,$H1#hi,${S4}[1]
+	vmlal.u32	$D4,$H0#hi,${R4}[1]
+	vmlal.u32	$D1,$H2#hi,${S4}[1]
+	vmlal.u32	$D2,$H3#hi,${S4}[1]
+
+	vld4.32		{$H0#hi,$H1#hi,$H2#hi,$H3#hi},[$in2]	@ inp[2:3] (or 0)
+	add		$in2,$in2,#64
+
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ (hash+inp[0:1])*r^4 and accumulate
+
+	vmlal.u32	$D3,$H3#lo,${R0}[0]
+	vmlal.u32	$D0,$H0#lo,${R0}[0]
+	vmlal.u32	$D4,$H4#lo,${R0}[0]
+	vmlal.u32	$D1,$H1#lo,${R0}[0]
+	vmlal.u32	$D2,$H2#lo,${R0}[0]
+	vld1.32		${S4}[0],[$tbl0,:32]
+
+	vmlal.u32	$D3,$H2#lo,${R1}[0]
+	vmlal.u32	$D0,$H4#lo,${S1}[0]
+	vmlal.u32	$D4,$H3#lo,${R1}[0]
+	vmlal.u32	$D1,$H0#lo,${R1}[0]
+	vmlal.u32	$D2,$H1#lo,${R1}[0]
+
+	vmlal.u32	$D3,$H1#lo,${R2}[0]
+	vmlal.u32	$D0,$H3#lo,${S2}[0]
+	vmlal.u32	$D4,$H2#lo,${R2}[0]
+	vmlal.u32	$D1,$H4#lo,${S2}[0]
+	vmlal.u32	$D2,$H0#lo,${R2}[0]
+
+	vmlal.u32	$D3,$H0#lo,${R3}[0]
+	vmlal.u32	$D0,$H2#lo,${S3}[0]
+	vmlal.u32	$D4,$H1#lo,${R3}[0]
+	vmlal.u32	$D1,$H3#lo,${S3}[0]
+	vmlal.u32	$D3,$H4#lo,${S4}[0]
+
+	vmlal.u32	$D2,$H4#lo,${S3}[0]
+	vmlal.u32	$D0,$H1#lo,${S4}[0]
+	vmlal.u32	$D4,$H0#lo,${R4}[0]
+	vmov.i32	$H4,#1<<24		@ padbit, yes, always
+	vmlal.u32	$D1,$H2#lo,${S4}[0]
+	vmlal.u32	$D2,$H3#lo,${S4}[0]
+
+	vld4.32		{$H0#lo,$H1#lo,$H2#lo,$H3#lo},[$inp]	@ inp[0:1]
+	add		$inp,$inp,#64
+# ifdef	__ARMEB__
+	vrev32.8	$H0,$H0
+	vrev32.8	$H1,$H1
+	vrev32.8	$H2,$H2
+	vrev32.8	$H3,$H3
+# endif
+
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ lazy reduction interleaved with base 2^32 -> base 2^26 of
+	@ inp[0:3] previously loaded to $H0-$H3 and smashed to $H0-$H4.
+
+	vshr.u64	$T0,$D3,#26
+	vmovn.i64	$D3#lo,$D3
+	 vshr.u64	$T1,$D0,#26
+	 vmovn.i64	$D0#lo,$D0
+	vadd.i64	$D4,$D4,$T0		@ h3 -> h4
+	vbic.i32	$D3#lo,#0xfc000000
+	  vsri.u32	$H4,$H3,#8		@ base 2^32 -> base 2^26
+	 vadd.i64	$D1,$D1,$T1		@ h0 -> h1
+	  vshl.u32	$H3,$H3,#18
+	 vbic.i32	$D0#lo,#0xfc000000
+
+	vshrn.u64	$T0#lo,$D4,#26
+	vmovn.i64	$D4#lo,$D4
+	 vshr.u64	$T1,$D1,#26
+	 vmovn.i64	$D1#lo,$D1
+	 vadd.i64	$D2,$D2,$T1		@ h1 -> h2
+	  vsri.u32	$H3,$H2,#14
+	vbic.i32	$D4#lo,#0xfc000000
+	  vshl.u32	$H2,$H2,#12
+	 vbic.i32	$D1#lo,#0xfc000000
+
+	vadd.i32	$D0#lo,$D0#lo,$T0#lo
+	vshl.u32	$T0#lo,$T0#lo,#2
+	  vbic.i32	$H3,#0xfc000000
+	 vshrn.u64	$T1#lo,$D2,#26
+	 vmovn.i64	$D2#lo,$D2
+	vaddl.u32	$D0,$D0#lo,$T0#lo	@ h4 -> h0 [widen for a sec]
+	  vsri.u32	$H2,$H1,#20
+	 vadd.i32	$D3#lo,$D3#lo,$T1#lo	@ h2 -> h3
+	  vshl.u32	$H1,$H1,#6
+	 vbic.i32	$D2#lo,#0xfc000000
+	  vbic.i32	$H2,#0xfc000000
+
+	vshrn.u64	$T0#lo,$D0,#26		@ re-narrow
+	vmovn.i64	$D0#lo,$D0
+	  vsri.u32	$H1,$H0,#26
+	  vbic.i32	$H0,#0xfc000000
+	 vshr.u32	$T1#lo,$D3#lo,#26
+	 vbic.i32	$D3#lo,#0xfc000000
+	vbic.i32	$D0#lo,#0xfc000000
+	vadd.i32	$D1#lo,$D1#lo,$T0#lo	@ h0 -> h1
+	 vadd.i32	$D4#lo,$D4#lo,$T1#lo	@ h3 -> h4
+	  vbic.i32	$H1,#0xfc000000
+
+	bhi		.Loop_neon
+
+.Lskip_loop:
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ multiply (inp[0:1]+hash) or inp[2:3] by r^2:r^1
+
+	add		$tbl1,$ctx,#(48+0*9*4)
+	add		$tbl0,$ctx,#(48+1*9*4)
+	adds		$len,$len,#32
+	it		ne
+	movne		$len,#0
+	bne		.Long_tail
+
+	vadd.i32	$H2#hi,$H2#lo,$D2#lo	@ add hash value and move to #hi
+	vadd.i32	$H0#hi,$H0#lo,$D0#lo
+	vadd.i32	$H3#hi,$H3#lo,$D3#lo
+	vadd.i32	$H1#hi,$H1#lo,$D1#lo
+	vadd.i32	$H4#hi,$H4#lo,$D4#lo
+
+.Long_tail:
+	vld4.32		{${R0}[1],${R1}[1],${S1}[1],${R2}[1]},[$tbl1]!	@ load r^1
+	vld4.32		{${R0}[0],${R1}[0],${S1}[0],${R2}[0]},[$tbl0]!	@ load r^2
+
+	vadd.i32	$H2#lo,$H2#lo,$D2#lo	@ can be redundant
+	vmull.u32	$D2,$H2#hi,$R0
+	vadd.i32	$H0#lo,$H0#lo,$D0#lo
+	vmull.u32	$D0,$H0#hi,$R0
+	vadd.i32	$H3#lo,$H3#lo,$D3#lo
+	vmull.u32	$D3,$H3#hi,$R0
+	vadd.i32	$H1#lo,$H1#lo,$D1#lo
+	vmull.u32	$D1,$H1#hi,$R0
+	vadd.i32	$H4#lo,$H4#lo,$D4#lo
+	vmull.u32	$D4,$H4#hi,$R0
+
+	vmlal.u32	$D0,$H4#hi,$S1
+	vld4.32		{${S2}[1],${R3}[1],${S3}[1],${R4}[1]},[$tbl1]!
+	vmlal.u32	$D3,$H2#hi,$R1
+	vld4.32		{${S2}[0],${R3}[0],${S3}[0],${R4}[0]},[$tbl0]!
+	vmlal.u32	$D1,$H0#hi,$R1
+	vmlal.u32	$D4,$H3#hi,$R1
+	vmlal.u32	$D2,$H1#hi,$R1
+
+	vmlal.u32	$D3,$H1#hi,$R2
+	vld1.32		${S4}[1],[$tbl1,:32]
+	vmlal.u32	$D0,$H3#hi,$S2
+	vld1.32		${S4}[0],[$tbl0,:32]
+	vmlal.u32	$D4,$H2#hi,$R2
+	vmlal.u32	$D1,$H4#hi,$S2
+	vmlal.u32	$D2,$H0#hi,$R2
+
+	vmlal.u32	$D3,$H0#hi,$R3
+	 it		ne
+	 addne		$tbl1,$ctx,#(48+2*9*4)
+	vmlal.u32	$D0,$H2#hi,$S3
+	 it		ne
+	 addne		$tbl0,$ctx,#(48+3*9*4)
+	vmlal.u32	$D4,$H1#hi,$R3
+	vmlal.u32	$D1,$H3#hi,$S3
+	vmlal.u32	$D2,$H4#hi,$S3
+
+	vmlal.u32	$D3,$H4#hi,$S4
+	 vorn		$MASK,$MASK,$MASK	@ all-ones, can be redundant
+	vmlal.u32	$D0,$H1#hi,$S4
+	 vshr.u64	$MASK,$MASK,#38
+	vmlal.u32	$D4,$H0#hi,$R4
+	vmlal.u32	$D1,$H2#hi,$S4
+	vmlal.u32	$D2,$H3#hi,$S4
+
+	beq		.Lshort_tail
+
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ (hash+inp[0:1])*r^4:r^3 and accumulate
+
+	vld4.32		{${R0}[1],${R1}[1],${S1}[1],${R2}[1]},[$tbl1]!	@ load r^3
+	vld4.32		{${R0}[0],${R1}[0],${S1}[0],${R2}[0]},[$tbl0]!	@ load r^4
+
+	vmlal.u32	$D2,$H2#lo,$R0
+	vmlal.u32	$D0,$H0#lo,$R0
+	vmlal.u32	$D3,$H3#lo,$R0
+	vmlal.u32	$D1,$H1#lo,$R0
+	vmlal.u32	$D4,$H4#lo,$R0
+
+	vmlal.u32	$D0,$H4#lo,$S1
+	vld4.32		{${S2}[1],${R3}[1],${S3}[1],${R4}[1]},[$tbl1]!
+	vmlal.u32	$D3,$H2#lo,$R1
+	vld4.32		{${S2}[0],${R3}[0],${S3}[0],${R4}[0]},[$tbl0]!
+	vmlal.u32	$D1,$H0#lo,$R1
+	vmlal.u32	$D4,$H3#lo,$R1
+	vmlal.u32	$D2,$H1#lo,$R1
+
+	vmlal.u32	$D3,$H1#lo,$R2
+	vld1.32		${S4}[1],[$tbl1,:32]
+	vmlal.u32	$D0,$H3#lo,$S2
+	vld1.32		${S4}[0],[$tbl0,:32]
+	vmlal.u32	$D4,$H2#lo,$R2
+	vmlal.u32	$D1,$H4#lo,$S2
+	vmlal.u32	$D2,$H0#lo,$R2
+
+	vmlal.u32	$D3,$H0#lo,$R3
+	vmlal.u32	$D0,$H2#lo,$S3
+	vmlal.u32	$D4,$H1#lo,$R3
+	vmlal.u32	$D1,$H3#lo,$S3
+	vmlal.u32	$D2,$H4#lo,$S3
+
+	vmlal.u32	$D3,$H4#lo,$S4
+	 vorn		$MASK,$MASK,$MASK	@ all-ones
+	vmlal.u32	$D0,$H1#lo,$S4
+	 vshr.u64	$MASK,$MASK,#38
+	vmlal.u32	$D4,$H0#lo,$R4
+	vmlal.u32	$D1,$H2#lo,$S4
+	vmlal.u32	$D2,$H3#lo,$S4
+
+.Lshort_tail:
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ horizontal addition
+
+	vadd.i64	$D3#lo,$D3#lo,$D3#hi
+	vadd.i64	$D0#lo,$D0#lo,$D0#hi
+	vadd.i64	$D4#lo,$D4#lo,$D4#hi
+	vadd.i64	$D1#lo,$D1#lo,$D1#hi
+	vadd.i64	$D2#lo,$D2#lo,$D2#hi
+
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ lazy reduction, but without narrowing
+
+	vshr.u64	$T0,$D3,#26
+	vand.i64	$D3,$D3,$MASK
+	 vshr.u64	$T1,$D0,#26
+	 vand.i64	$D0,$D0,$MASK
+	vadd.i64	$D4,$D4,$T0		@ h3 -> h4
+	 vadd.i64	$D1,$D1,$T1		@ h0 -> h1
+
+	vshr.u64	$T0,$D4,#26
+	vand.i64	$D4,$D4,$MASK
+	 vshr.u64	$T1,$D1,#26
+	 vand.i64	$D1,$D1,$MASK
+	 vadd.i64	$D2,$D2,$T1		@ h1 -> h2
+
+	vadd.i64	$D0,$D0,$T0
+	vshl.u64	$T0,$T0,#2
+	 vshr.u64	$T1,$D2,#26
+	 vand.i64	$D2,$D2,$MASK
+	vadd.i64	$D0,$D0,$T0		@ h4 -> h0
+	 vadd.i64	$D3,$D3,$T1		@ h2 -> h3
+
+	vshr.u64	$T0,$D0,#26
+	vand.i64	$D0,$D0,$MASK
+	 vshr.u64	$T1,$D3,#26
+	 vand.i64	$D3,$D3,$MASK
+	vadd.i64	$D1,$D1,$T0		@ h0 -> h1
+	 vadd.i64	$D4,$D4,$T1		@ h3 -> h4
+
+	cmp		$len,#0
+	bne		.Leven
+
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ store hash value
+
+	vst4.32		{$D0#lo[0],$D1#lo[0],$D2#lo[0],$D3#lo[0]},[$ctx]!
+	vst1.32		{$D4#lo[0]},[$ctx]
+
+	vldmia	sp!,{d8-d15}			@ epilogue
+	ldmia	sp!,{r4-r7}
+.Lno_data_neon:
+	ret					@ bx	lr
+.size	poly1305_blocks_neon,.-poly1305_blocks_neon
+
+#ifdef __KERNEL__
+.globl	poly1305_emit_neon
+#endif
+.type	poly1305_emit_neon,%function
+.align	5
+poly1305_emit_neon:
+	ldr	ip,[$ctx,#36]		@ is_base2_26
+
+	stmdb	sp!,{r4-r11}
+
+	tst	ip,ip
+	beq	.Lpoly1305_emit_enter
+
+	ldmia	$ctx,{$h0-$h4}
+	eor	$g0,$g0,$g0
+
+	adds	$h0,$h0,$h1,lsl#26	@ base 2^26 -> base 2^32
+	mov	$h1,$h1,lsr#6
+	adcs	$h1,$h1,$h2,lsl#20
+	mov	$h2,$h2,lsr#12
+	adcs	$h2,$h2,$h3,lsl#14
+	mov	$h3,$h3,lsr#18
+	adcs	$h3,$h3,$h4,lsl#8
+	adc	$h4,$g0,$h4,lsr#24	@ can be partially reduced ...
+
+	and	$g0,$h4,#-4		@ ... so reduce
+	and	$h4,$h3,#3
+	add	$g0,$g0,$g0,lsr#2	@ *= 5
+	adds	$h0,$h0,$g0
+	adcs	$h1,$h1,#0
+	adcs	$h2,$h2,#0
+	adcs	$h3,$h3,#0
+	adc	$h4,$h4,#0
+
+	adds	$g0,$h0,#5		@ compare to modulus
+	adcs	$g1,$h1,#0
+	adcs	$g2,$h2,#0
+	adcs	$g3,$h3,#0
+	adc	$g4,$h4,#0
+	tst	$g4,#4			@ did it carry/borrow?
+
+	it	ne
+	movne	$h0,$g0
+	ldr	$g0,[$nonce,#0]
+	it	ne
+	movne	$h1,$g1
+	ldr	$g1,[$nonce,#4]
+	it	ne
+	movne	$h2,$g2
+	ldr	$g2,[$nonce,#8]
+	it	ne
+	movne	$h3,$g3
+	ldr	$g3,[$nonce,#12]
+
+	adds	$h0,$h0,$g0		@ accumulate nonce
+	adcs	$h1,$h1,$g1
+	adcs	$h2,$h2,$g2
+	adc	$h3,$h3,$g3
+
+# ifdef __ARMEB__
+	rev	$h0,$h0
+	rev	$h1,$h1
+	rev	$h2,$h2
+	rev	$h3,$h3
+# endif
+	str	$h0,[$mac,#0]		@ store the result
+	str	$h1,[$mac,#4]
+	str	$h2,[$mac,#8]
+	str	$h3,[$mac,#12]
+
+	ldmia	sp!,{r4-r11}
+	ret				@ bx	lr
+.size	poly1305_emit_neon,.-poly1305_emit_neon
+
+.align	5
+.Lzeros:
+.long	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
+# ifndef __KERNEL__
+.LOPENSSL_armcap:
+.word	OPENSSL_armcap_P-.Lpoly1305_init
+# endif
+#endif
+___
+}	}
+$code.=<<___;
+.align	2
+#if	__ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
+.comm   OPENSSL_armcap_P,4,4
+#endif
+___
+
+open SELF,$0;
+while(<SELF>) {
+	next if (/^#!/);
+	last if (!s/^#/@/ and !/^$/);
+	print;
+}
+close SELF;
+
+foreach (split("\n",$code)) {
+	s/\`([^\`]*)\`/eval $1/geo;
+
+	s/\bq([0-9]+)#(lo|hi)/sprintf "d%d",2*$1+($2 eq "hi")/geo	or
+	s/\bret\b/bx	lr/go						or
+	s/\bbx\s+lr\b/.word\t0xe12fff1e/go;	# make it possible to compile with -march=armv4
+
+	print $_,"\n";
+}
+close STDOUT; # enforce flush
diff --git a/lib/zinc/poly1305/poly1305-arm64.pl b/lib/zinc/poly1305/poly1305-arm64.pl
new file mode 100644
index 000000000000..d513b45a149b
--- /dev/null
+++ b/lib/zinc/poly1305/poly1305-arm64.pl
@@ -0,0 +1,974 @@
+#!/usr/bin/env perl
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+#
+# This code is taken from the OpenSSL project but the author, Andy Polyakov,
+# has relicensed it under the licenses specified in the SPDX header above.
+# The original headers, including the original license headers, are
+# included below for completeness.
+#
+# ====================================================================
+# Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
+# project. The module is, however, dual licensed under OpenSSL and
+# CRYPTOGAMS licenses depending on where you obtain it. For further
+# details see http://www.openssl.org/~appro/cryptogams/.
+# ====================================================================
+#
+# This module implements Poly1305 hash for ARMv8.
+#
+# June 2015
+#
+# Numbers are cycles per processed byte with poly1305_blocks alone.
+#
+#		IALU/gcc-4.9	NEON
+#
+# Apple A7	1.86/+5%	0.72
+# Cortex-A53	2.69/+58%	1.47
+# Cortex-A57	2.70/+7%	1.14
+# Denver	1.64/+50%	1.18(*)
+# X-Gene	2.13/+68%	2.27
+# Mongoose	1.77/+75%	1.12
+# Kryo		2.70/+55%	1.13
+#
+# (*)	estimate based on resources availability is less than 1.0,
+#	i.e. measured result is worse than expected, presumably binary
+#	translator is not almighty;
+
+$flavour=shift;
+if ($flavour=~/\w[\w\-]*\.\w+$/) { $output=$flavour; undef $flavour; }
+else { while (($output=shift) && ($output!~/\w[\w\-]*\.\w+$/)) {} }
+
+if ($flavour && $flavour ne "void") {
+    $0 =~ m/(.*[\/\\])[^\/\\]+$/; $dir=$1;
+    ( $xlate="${dir}arm-xlate.pl" and -f $xlate ) or
+    ( $xlate="${dir}../../perlasm/arm-xlate.pl" and -f $xlate) or
+    die "can't locate arm-xlate.pl";
+
+    open STDOUT,"| \"$^X\" $xlate $flavour $output";
+} else {
+    open STDOUT,">$output";
+}
+
+my ($ctx,$inp,$len,$padbit) = map("x$_",(0..3));
+my ($mac,$nonce)=($inp,$len);
+
+my ($h0,$h1,$h2,$r0,$r1,$s1,$t0,$t1,$d0,$d1,$d2) = map("x$_",(4..14));
+
+$code.=<<___;
+#ifndef	__KERNEL__
+# include "arm_arch.h"
+.extern	OPENSSL_armcap_P
+#else
+# define poly1305_init   poly1305_init_arm
+# define poly1305_blocks poly1305_blocks_arm
+# define poly1305_emit   poly1305_emit_arm
+#endif
+
+.text
+
+// forward "declarations" are required for Apple
+.globl	poly1305_blocks
+.globl	poly1305_emit
+.globl	poly1305_init
+.type	poly1305_init,%function
+.align	5
+poly1305_init:
+	cmp	$inp,xzr
+	stp	xzr,xzr,[$ctx]		// zero hash value
+	stp	xzr,xzr,[$ctx,#16]	// [along with is_base2_26]
+
+	csel	x0,xzr,x0,eq
+	b.eq	.Lno_key
+
+#ifndef	__KERNEL__
+# ifdef	__ILP32__
+	ldrsw	$t1,.LOPENSSL_armcap_P
+# else
+	ldr	$t1,.LOPENSSL_armcap_P
+# endif
+	adr	$t0,.LOPENSSL_armcap_P
+	ldr	w17,[$t0,$t1]
+#endif
+
+	ldp	$r0,$r1,[$inp]		// load key
+	mov	$s1,#0xfffffffc0fffffff
+	movk	$s1,#0x0fff,lsl#48
+#ifdef	__AARCH64EB__
+	rev	$r0,$r0			// flip bytes
+	rev	$r1,$r1
+#endif
+	and	$r0,$r0,$s1		// &=0ffffffc0fffffff
+	and	$s1,$s1,#-4
+	and	$r1,$r1,$s1		// &=0ffffffc0ffffffc
+	stp	$r0,$r1,[$ctx,#32]	// save key value
+
+#ifndef	__KERNEL__
+	tst	w17,#ARMV7_NEON
+
+	adr	$d0,poly1305_blocks
+	adr	$r0,poly1305_blocks_neon
+	adr	$d1,poly1305_emit
+	adr	$r1,poly1305_emit_neon
+
+	csel	$d0,$d0,$r0,eq
+	csel	$d1,$d1,$r1,eq
+
+# ifdef	__ILP32__
+	stp	w12,w13,[$len]
+# else
+	stp	$d0,$d1,[$len]
+# endif
+
+	mov	x0,#1
+#else
+	mov	x0,#0
+#endif
+.Lno_key:
+	ret
+.size	poly1305_init,.-poly1305_init
+
+.type	poly1305_blocks,%function
+.align	5
+poly1305_blocks:
+	ands	$len,$len,#-16
+	b.eq	.Lno_data
+
+	ldp	$h0,$h1,[$ctx]		// load hash value
+	ldp	$r0,$r1,[$ctx,#32]	// load key value
+	ldr	$h2,[$ctx,#16]
+	add	$s1,$r1,$r1,lsr#2	// s1 = r1 + (r1 >> 2)
+	b	.Loop
+
+.align	5
+.Loop:
+	ldp	$t0,$t1,[$inp],#16	// load input
+	sub	$len,$len,#16
+#ifdef	__AARCH64EB__
+	rev	$t0,$t0
+	rev	$t1,$t1
+#endif
+	adds	$h0,$h0,$t0		// accumulate input
+	adcs	$h1,$h1,$t1
+
+	mul	$d0,$h0,$r0		// h0*r0
+	adc	$h2,$h2,$padbit
+	umulh	$d1,$h0,$r0
+
+	mul	$t0,$h1,$s1		// h1*5*r1
+	umulh	$t1,$h1,$s1
+
+	adds	$d0,$d0,$t0
+	mul	$t0,$h0,$r1		// h0*r1
+	adc	$d1,$d1,$t1
+	umulh	$d2,$h0,$r1
+
+	adds	$d1,$d1,$t0
+	mul	$t0,$h1,$r0		// h1*r0
+	adc	$d2,$d2,xzr
+	umulh	$t1,$h1,$r0
+
+	adds	$d1,$d1,$t0
+	mul	$t0,$h2,$s1		// h2*5*r1
+	adc	$d2,$d2,$t1
+	mul	$t1,$h2,$r0		// h2*r0
+
+	adds	$d1,$d1,$t0
+	adc	$d2,$d2,$t1
+
+	and	$t0,$d2,#-4		// final reduction
+	and	$h2,$d2,#3
+	add	$t0,$t0,$d2,lsr#2
+	adds	$h0,$d0,$t0
+	adcs	$h1,$d1,xzr
+	adc	$h2,$h2,xzr
+
+	cbnz	$len,.Loop
+
+	stp	$h0,$h1,[$ctx]		// store hash value
+	str	$h2,[$ctx,#16]
+
+.Lno_data:
+	ret
+.size	poly1305_blocks,.-poly1305_blocks
+
+.type	poly1305_emit,%function
+.align	5
+poly1305_emit:
+	ldp	$h0,$h1,[$ctx]		// load hash base 2^64
+	ldr	$h2,[$ctx,#16]
+	ldp	$t0,$t1,[$nonce]	// load nonce
+
+	adds	$d0,$h0,#5		// compare to modulus
+	adcs	$d1,$h1,xzr
+	adc	$d2,$h2,xzr
+
+	tst	$d2,#-4			// see if it's carried/borrowed
+
+	csel	$h0,$h0,$d0,eq
+	csel	$h1,$h1,$d1,eq
+
+#ifdef	__AARCH64EB__
+	ror	$t0,$t0,#32		// flip nonce words
+	ror	$t1,$t1,#32
+#endif
+	adds	$h0,$h0,$t0		// accumulate nonce
+	adc	$h1,$h1,$t1
+#ifdef	__AARCH64EB__
+	rev	$h0,$h0			// flip output bytes
+	rev	$h1,$h1
+#endif
+	stp	$h0,$h1,[$mac]		// write result
+
+	ret
+.size	poly1305_emit,.-poly1305_emit
+___
+my ($R0,$R1,$S1,$R2,$S2,$R3,$S3,$R4,$S4) = map("v$_.4s",(0..8));
+my ($IN01_0,$IN01_1,$IN01_2,$IN01_3,$IN01_4) = map("v$_.2s",(9..13));
+my ($IN23_0,$IN23_1,$IN23_2,$IN23_3,$IN23_4) = map("v$_.2s",(14..18));
+my ($ACC0,$ACC1,$ACC2,$ACC3,$ACC4) = map("v$_.2d",(19..23));
+my ($H0,$H1,$H2,$H3,$H4) = map("v$_.2s",(24..28));
+my ($T0,$T1,$MASK) = map("v$_",(29..31));
+
+my ($in2,$zeros)=("x16","x17");
+my $is_base2_26 = $zeros;		# borrow
+
+$code.=<<___;
+.type	__poly1305_mult,%function
+.align	5
+__poly1305_mult:
+	mul	$d0,$h0,$r0		// h0*r0
+	umulh	$d1,$h0,$r0
+
+	mul	$t0,$h1,$s1		// h1*5*r1
+	umulh	$t1,$h1,$s1
+
+	adds	$d0,$d0,$t0
+	mul	$t0,$h0,$r1		// h0*r1
+	adc	$d1,$d1,$t1
+	umulh	$d2,$h0,$r1
+
+	adds	$d1,$d1,$t0
+	mul	$t0,$h1,$r0		// h1*r0
+	adc	$d2,$d2,xzr
+	umulh	$t1,$h1,$r0
+
+	adds	$d1,$d1,$t0
+	mul	$t0,$h2,$s1		// h2*5*r1
+	adc	$d2,$d2,$t1
+	mul	$t1,$h2,$r0		// h2*r0
+
+	adds	$d1,$d1,$t0
+	adc	$d2,$d2,$t1
+
+	and	$t0,$d2,#-4		// final reduction
+	and	$h2,$d2,#3
+	add	$t0,$t0,$d2,lsr#2
+	adds	$h0,$d0,$t0
+	adcs	$h1,$d1,xzr
+	adc	$h2,$h2,xzr
+
+	ret
+.size	__poly1305_mult,.-__poly1305_mult
+
+.type	__poly1305_splat,%function
+.align	5
+__poly1305_splat:
+	and	x12,$h0,#0x03ffffff	// base 2^64 -> base 2^26
+	ubfx	x13,$h0,#26,#26
+	extr	x14,$h1,$h0,#52
+	and	x14,x14,#0x03ffffff
+	ubfx	x15,$h1,#14,#26
+	extr	x16,$h2,$h1,#40
+
+	str	w12,[$ctx,#16*0]	// r0
+	add	w12,w13,w13,lsl#2	// r1*5
+	str	w13,[$ctx,#16*1]	// r1
+	add	w13,w14,w14,lsl#2	// r2*5
+	str	w12,[$ctx,#16*2]	// s1
+	str	w14,[$ctx,#16*3]	// r2
+	add	w14,w15,w15,lsl#2	// r3*5
+	str	w13,[$ctx,#16*4]	// s2
+	str	w15,[$ctx,#16*5]	// r3
+	add	w15,w16,w16,lsl#2	// r4*5
+	str	w14,[$ctx,#16*6]	// s3
+	str	w16,[$ctx,#16*7]	// r4
+	str	w15,[$ctx,#16*8]	// s4
+
+	ret
+.size	__poly1305_splat,.-__poly1305_splat
+
+#if !defined(__KERNEL__) || defined(CONFIG_KERNEL_MODE_NEON)
+#ifdef	__KERNEL__
+.globl	poly1305_blocks_neon
+.globl	poly1305_emit_neon
+#endif
+
+.type	poly1305_blocks_neon,%function
+.align	5
+poly1305_blocks_neon:
+	ldr	$is_base2_26,[$ctx,#24]
+	cmp	$len,#128
+	b.hs	.Lblocks_neon
+	cbz	$is_base2_26,poly1305_blocks
+
+.Lblocks_neon:
+	stp	x29,x30,[sp,#-80]!
+	add	x29,sp,#0
+
+	ands	$len,$len,#-16
+	b.eq	.Lno_data_neon
+
+	cbz	$is_base2_26,.Lbase2_64_neon
+
+	ldp	w10,w11,[$ctx]		// load hash value base 2^26
+	ldp	w12,w13,[$ctx,#8]
+	ldr	w14,[$ctx,#16]
+
+	tst	$len,#31
+	b.eq	.Leven_neon
+
+	ldp	$r0,$r1,[$ctx,#32]	// load key value
+
+	add	$h0,x10,x11,lsl#26	// base 2^26 -> base 2^64
+	lsr	$h1,x12,#12
+	adds	$h0,$h0,x12,lsl#52
+	add	$h1,$h1,x13,lsl#14
+	adc	$h1,$h1,xzr
+	lsr	$h2,x14,#24
+	adds	$h1,$h1,x14,lsl#40
+	adc	$d2,$h2,xzr		// can be partially reduced...
+
+	ldp	$d0,$d1,[$inp],#16	// load input
+	sub	$len,$len,#16
+	add	$s1,$r1,$r1,lsr#2	// s1 = r1 + (r1 >> 2)
+
+	and	$t0,$d2,#-4		// ... so reduce
+	and	$h2,$d2,#3
+	add	$t0,$t0,$d2,lsr#2
+	adds	$h0,$h0,$t0
+	adcs	$h1,$h1,xzr
+	adc	$h2,$h2,xzr
+
+#ifdef	__AARCH64EB__
+	rev	$d0,$d0
+	rev	$d1,$d1
+#endif
+	adds	$h0,$h0,$d0		// accumulate input
+	adcs	$h1,$h1,$d1
+	adc	$h2,$h2,$padbit
+
+	bl	__poly1305_mult
+	ldr	x30,[sp,#8]
+
+	cbz	$padbit,.Lstore_base2_64_neon
+
+	and	x10,$h0,#0x03ffffff	// base 2^64 -> base 2^26
+	ubfx	x11,$h0,#26,#26
+	extr	x12,$h1,$h0,#52
+	and	x12,x12,#0x03ffffff
+	ubfx	x13,$h1,#14,#26
+	extr	x14,$h2,$h1,#40
+
+	cbnz	$len,.Leven_neon
+
+	stp	w10,w11,[$ctx]		// store hash value base 2^26
+	stp	w12,w13,[$ctx,#8]
+	str	w14,[$ctx,#16]
+	b	.Lno_data_neon
+
+.align	4
+.Lstore_base2_64_neon:
+	stp	$h0,$h1,[$ctx]		// store hash value base 2^64
+	stp	$h2,xzr,[$ctx,#16]	// note that is_base2_26 is zeroed
+	b	.Lno_data_neon
+
+.align	4
+.Lbase2_64_neon:
+	ldp	$r0,$r1,[$ctx,#32]	// load key value
+
+	ldp	$h0,$h1,[$ctx]		// load hash value base 2^64
+	ldr	$h2,[$ctx,#16]
+
+	tst	$len,#31
+	b.eq	.Linit_neon
+
+	ldp	$d0,$d1,[$inp],#16	// load input
+	sub	$len,$len,#16
+	add	$s1,$r1,$r1,lsr#2	// s1 = r1 + (r1 >> 2)
+#ifdef	__AARCH64EB__
+	rev	$d0,$d0
+	rev	$d1,$d1
+#endif
+	adds	$h0,$h0,$d0		// accumulate input
+	adcs	$h1,$h1,$d1
+	adc	$h2,$h2,$padbit
+
+	bl	__poly1305_mult
+
+.Linit_neon:
+	and	x10,$h0,#0x03ffffff	// base 2^64 -> base 2^26
+	ubfx	x11,$h0,#26,#26
+	extr	x12,$h1,$h0,#52
+	and	x12,x12,#0x03ffffff
+	ubfx	x13,$h1,#14,#26
+	extr	x14,$h2,$h1,#40
+
+	stp	d8,d9,[sp,#16]		// meet ABI requirements
+	stp	d10,d11,[sp,#32]
+	stp	d12,d13,[sp,#48]
+	stp	d14,d15,[sp,#64]
+
+	fmov	${H0},x10
+	fmov	${H1},x11
+	fmov	${H2},x12
+	fmov	${H3},x13
+	fmov	${H4},x14
+
+	////////////////////////////////// initialize r^n table
+	mov	$h0,$r0			// r^1
+	add	$s1,$r1,$r1,lsr#2	// s1 = r1 + (r1 >> 2)
+	mov	$h1,$r1
+	mov	$h2,xzr
+	add	$ctx,$ctx,#48+12
+	bl	__poly1305_splat
+
+	bl	__poly1305_mult		// r^2
+	sub	$ctx,$ctx,#4
+	bl	__poly1305_splat
+
+	bl	__poly1305_mult		// r^3
+	sub	$ctx,$ctx,#4
+	bl	__poly1305_splat
+
+	bl	__poly1305_mult		// r^4
+	sub	$ctx,$ctx,#4
+	bl	__poly1305_splat
+	ldr	x30,[sp,#8]
+
+	add	$in2,$inp,#32
+	adr	$zeros,.Lzeros
+	subs	$len,$len,#64
+	csel	$in2,$zeros,$in2,lo
+
+	mov	x4,#1
+	str	x4,[$ctx,#-24]		// set is_base2_26
+	sub	$ctx,$ctx,#48		// restore original $ctx
+	b	.Ldo_neon
+
+.align	4
+.Leven_neon:
+	add	$in2,$inp,#32
+	adr	$zeros,.Lzeros
+	subs	$len,$len,#64
+	csel	$in2,$zeros,$in2,lo
+
+	stp	d8,d9,[sp,#16]		// meet ABI requirements
+	stp	d10,d11,[sp,#32]
+	stp	d12,d13,[sp,#48]
+	stp	d14,d15,[sp,#64]
+
+	fmov	${H0},x10
+	fmov	${H1},x11
+	fmov	${H2},x12
+	fmov	${H3},x13
+	fmov	${H4},x14
+
+.Ldo_neon:
+	ldp	x8,x12,[$in2],#16	// inp[2:3] (or zero)
+	ldp	x9,x13,[$in2],#48
+
+	lsl	$padbit,$padbit,#24
+	add	x15,$ctx,#48
+
+#ifdef	__AARCH64EB__
+	rev	x8,x8
+	rev	x12,x12
+	rev	x9,x9
+	rev	x13,x13
+#endif
+	and	x4,x8,#0x03ffffff	// base 2^64 -> base 2^26
+	and	x5,x9,#0x03ffffff
+	ubfx	x6,x8,#26,#26
+	ubfx	x7,x9,#26,#26
+	add	x4,x4,x5,lsl#32		// bfi	x4,x5,#32,#32
+	extr	x8,x12,x8,#52
+	extr	x9,x13,x9,#52
+	add	x6,x6,x7,lsl#32		// bfi	x6,x7,#32,#32
+	fmov	$IN23_0,x4
+	and	x8,x8,#0x03ffffff
+	and	x9,x9,#0x03ffffff
+	ubfx	x10,x12,#14,#26
+	ubfx	x11,x13,#14,#26
+	add	x12,$padbit,x12,lsr#40
+	add	x13,$padbit,x13,lsr#40
+	add	x8,x8,x9,lsl#32		// bfi	x8,x9,#32,#32
+	fmov	$IN23_1,x6
+	add	x10,x10,x11,lsl#32	// bfi	x10,x11,#32,#32
+	add	x12,x12,x13,lsl#32	// bfi	x12,x13,#32,#32
+	fmov	$IN23_2,x8
+	fmov	$IN23_3,x10
+	fmov	$IN23_4,x12
+
+	ldp	x8,x12,[$inp],#16	// inp[0:1]
+	ldp	x9,x13,[$inp],#48
+
+	ld1	{$R0,$R1,$S1,$R2},[x15],#64
+	ld1	{$S2,$R3,$S3,$R4},[x15],#64
+	ld1	{$S4},[x15]
+
+#ifdef	__AARCH64EB__
+	rev	x8,x8
+	rev	x12,x12
+	rev	x9,x9
+	rev	x13,x13
+#endif
+	and	x4,x8,#0x03ffffff	// base 2^64 -> base 2^26
+	and	x5,x9,#0x03ffffff
+	ubfx	x6,x8,#26,#26
+	ubfx	x7,x9,#26,#26
+	add	x4,x4,x5,lsl#32		// bfi	x4,x5,#32,#32
+	extr	x8,x12,x8,#52
+	extr	x9,x13,x9,#52
+	add	x6,x6,x7,lsl#32		// bfi	x6,x7,#32,#32
+	fmov	$IN01_0,x4
+	and	x8,x8,#0x03ffffff
+	and	x9,x9,#0x03ffffff
+	ubfx	x10,x12,#14,#26
+	ubfx	x11,x13,#14,#26
+	add	x12,$padbit,x12,lsr#40
+	add	x13,$padbit,x13,lsr#40
+	add	x8,x8,x9,lsl#32		// bfi	x8,x9,#32,#32
+	fmov	$IN01_1,x6
+	add	x10,x10,x11,lsl#32	// bfi	x10,x11,#32,#32
+	add	x12,x12,x13,lsl#32	// bfi	x12,x13,#32,#32
+	movi	$MASK.2d,#-1
+	fmov	$IN01_2,x8
+	fmov	$IN01_3,x10
+	fmov	$IN01_4,x12
+	ushr	$MASK.2d,$MASK.2d,#38
+
+	b.ls	.Lskip_loop
+
+.align	4
+.Loop_neon:
+	////////////////////////////////////////////////////////////////
+	// ((inp[0]*r^4+inp[2]*r^2+inp[4])*r^4+inp[6]*r^2
+	// ((inp[1]*r^4+inp[3]*r^2+inp[5])*r^3+inp[7]*r
+	//   \___________________/
+	// ((inp[0]*r^4+inp[2]*r^2+inp[4])*r^4+inp[6]*r^2+inp[8])*r^2
+	// ((inp[1]*r^4+inp[3]*r^2+inp[5])*r^4+inp[7]*r^2+inp[9])*r
+	//   \___________________/ \____________________/
+	//
+	// Note that we start with inp[2:3]*r^2. This is because it
+	// doesn't depend on reduction in previous iteration.
+	////////////////////////////////////////////////////////////////
+	// d4 = h0*r4 + h1*r3   + h2*r2   + h3*r1   + h4*r0
+	// d3 = h0*r3 + h1*r2   + h2*r1   + h3*r0   + h4*5*r4
+	// d2 = h0*r2 + h1*r1   + h2*r0   + h3*5*r4 + h4*5*r3
+	// d1 = h0*r1 + h1*r0   + h2*5*r4 + h3*5*r3 + h4*5*r2
+	// d0 = h0*r0 + h1*5*r4 + h2*5*r3 + h3*5*r2 + h4*5*r1
+
+	subs	$len,$len,#64
+	umull	$ACC4,$IN23_0,${R4}[2]
+	csel	$in2,$zeros,$in2,lo
+	umull	$ACC3,$IN23_0,${R3}[2]
+	umull	$ACC2,$IN23_0,${R2}[2]
+	 ldp	x8,x12,[$in2],#16	// inp[2:3] (or zero)
+	umull	$ACC1,$IN23_0,${R1}[2]
+	 ldp	x9,x13,[$in2],#48
+	umull	$ACC0,$IN23_0,${R0}[2]
+#ifdef	__AARCH64EB__
+	 rev	x8,x8
+	 rev	x12,x12
+	 rev	x9,x9
+	 rev	x13,x13
+#endif
+
+	umlal	$ACC4,$IN23_1,${R3}[2]
+	 and	x4,x8,#0x03ffffff	// base 2^64 -> base 2^26
+	umlal	$ACC3,$IN23_1,${R2}[2]
+	 and	x5,x9,#0x03ffffff
+	umlal	$ACC2,$IN23_1,${R1}[2]
+	 ubfx	x6,x8,#26,#26
+	umlal	$ACC1,$IN23_1,${R0}[2]
+	 ubfx	x7,x9,#26,#26
+	umlal	$ACC0,$IN23_1,${S4}[2]
+	 add	x4,x4,x5,lsl#32		// bfi	x4,x5,#32,#32
+
+	umlal	$ACC4,$IN23_2,${R2}[2]
+	 extr	x8,x12,x8,#52
+	umlal	$ACC3,$IN23_2,${R1}[2]
+	 extr	x9,x13,x9,#52
+	umlal	$ACC2,$IN23_2,${R0}[2]
+	 add	x6,x6,x7,lsl#32		// bfi	x6,x7,#32,#32
+	umlal	$ACC1,$IN23_2,${S4}[2]
+	 fmov	$IN23_0,x4
+	umlal	$ACC0,$IN23_2,${S3}[2]
+	 and	x8,x8,#0x03ffffff
+
+	umlal	$ACC4,$IN23_3,${R1}[2]
+	 and	x9,x9,#0x03ffffff
+	umlal	$ACC3,$IN23_3,${R0}[2]
+	 ubfx	x10,x12,#14,#26
+	umlal	$ACC2,$IN23_3,${S4}[2]
+	 ubfx	x11,x13,#14,#26
+	umlal	$ACC1,$IN23_3,${S3}[2]
+	 add	x8,x8,x9,lsl#32		// bfi	x8,x9,#32,#32
+	umlal	$ACC0,$IN23_3,${S2}[2]
+	 fmov	$IN23_1,x6
+
+	add	$IN01_2,$IN01_2,$H2
+	 add	x12,$padbit,x12,lsr#40
+	umlal	$ACC4,$IN23_4,${R0}[2]
+	 add	x13,$padbit,x13,lsr#40
+	umlal	$ACC3,$IN23_4,${S4}[2]
+	 add	x10,x10,x11,lsl#32	// bfi	x10,x11,#32,#32
+	umlal	$ACC2,$IN23_4,${S3}[2]
+	 add	x12,x12,x13,lsl#32	// bfi	x12,x13,#32,#32
+	umlal	$ACC1,$IN23_4,${S2}[2]
+	 fmov	$IN23_2,x8
+	umlal	$ACC0,$IN23_4,${S1}[2]
+	 fmov	$IN23_3,x10
+
+	////////////////////////////////////////////////////////////////
+	// (hash+inp[0:1])*r^4 and accumulate
+
+	add	$IN01_0,$IN01_0,$H0
+	 fmov	$IN23_4,x12
+	umlal	$ACC3,$IN01_2,${R1}[0]
+	 ldp	x8,x12,[$inp],#16	// inp[0:1]
+	umlal	$ACC0,$IN01_2,${S3}[0]
+	 ldp	x9,x13,[$inp],#48
+	umlal	$ACC4,$IN01_2,${R2}[0]
+	umlal	$ACC1,$IN01_2,${S4}[0]
+	umlal	$ACC2,$IN01_2,${R0}[0]
+#ifdef	__AARCH64EB__
+	 rev	x8,x8
+	 rev	x12,x12
+	 rev	x9,x9
+	 rev	x13,x13
+#endif
+
+	add	$IN01_1,$IN01_1,$H1
+	umlal	$ACC3,$IN01_0,${R3}[0]
+	umlal	$ACC4,$IN01_0,${R4}[0]
+	 and	x4,x8,#0x03ffffff	// base 2^64 -> base 2^26
+	umlal	$ACC2,$IN01_0,${R2}[0]
+	 and	x5,x9,#0x03ffffff
+	umlal	$ACC0,$IN01_0,${R0}[0]
+	 ubfx	x6,x8,#26,#26
+	umlal	$ACC1,$IN01_0,${R1}[0]
+	 ubfx	x7,x9,#26,#26
+
+	add	$IN01_3,$IN01_3,$H3
+	 add	x4,x4,x5,lsl#32		// bfi	x4,x5,#32,#32
+	umlal	$ACC3,$IN01_1,${R2}[0]
+	 extr	x8,x12,x8,#52
+	umlal	$ACC4,$IN01_1,${R3}[0]
+	 extr	x9,x13,x9,#52
+	umlal	$ACC0,$IN01_1,${S4}[0]
+	 add	x6,x6,x7,lsl#32		// bfi	x6,x7,#32,#32
+	umlal	$ACC2,$IN01_1,${R1}[0]
+	 fmov	$IN01_0,x4
+	umlal	$ACC1,$IN01_1,${R0}[0]
+	 and	x8,x8,#0x03ffffff
+
+	add	$IN01_4,$IN01_4,$H4
+	 and	x9,x9,#0x03ffffff
+	umlal	$ACC3,$IN01_3,${R0}[0]
+	 ubfx	x10,x12,#14,#26
+	umlal	$ACC0,$IN01_3,${S2}[0]
+	 ubfx	x11,x13,#14,#26
+	umlal	$ACC4,$IN01_3,${R1}[0]
+	 add	x8,x8,x9,lsl#32		// bfi	x8,x9,#32,#32
+	umlal	$ACC1,$IN01_3,${S3}[0]
+	 fmov	$IN01_1,x6
+	umlal	$ACC2,$IN01_3,${S4}[0]
+	 add	x12,$padbit,x12,lsr#40
+
+	umlal	$ACC3,$IN01_4,${S4}[0]
+	 add	x13,$padbit,x13,lsr#40
+	umlal	$ACC0,$IN01_4,${S1}[0]
+	 add	x10,x10,x11,lsl#32	// bfi	x10,x11,#32,#32
+	umlal	$ACC4,$IN01_4,${R0}[0]
+	 add	x12,x12,x13,lsl#32	// bfi	x12,x13,#32,#32
+	umlal	$ACC1,$IN01_4,${S2}[0]
+	 fmov	$IN01_2,x8
+	umlal	$ACC2,$IN01_4,${S3}[0]
+	 fmov	$IN01_3,x10
+	 fmov	$IN01_4,x12
+
+	/////////////////////////////////////////////////////////////////
+	// lazy reduction as discussed in "NEON crypto" by D.J. Bernstein
+	// and P. Schwabe
+	//
+	// [see discussion in poly1305-armv4 module]
+
+	ushr	$T0.2d,$ACC3,#26
+	xtn	$H3,$ACC3
+	 ushr	$T1.2d,$ACC0,#26
+	 and	$ACC0,$ACC0,$MASK.2d
+	add	$ACC4,$ACC4,$T0.2d	// h3 -> h4
+	bic	$H3,#0xfc,lsl#24	// &=0x03ffffff
+	 add	$ACC1,$ACC1,$T1.2d	// h0 -> h1
+
+	ushr	$T0.2d,$ACC4,#26
+	xtn	$H4,$ACC4
+	 ushr	$T1.2d,$ACC1,#26
+	 xtn	$H1,$ACC1
+	bic	$H4,#0xfc,lsl#24
+	 add	$ACC2,$ACC2,$T1.2d	// h1 -> h2
+
+	add	$ACC0,$ACC0,$T0.2d
+	shl	$T0.2d,$T0.2d,#2
+	 shrn	$T1.2s,$ACC2,#26
+	 xtn	$H2,$ACC2
+	add	$ACC0,$ACC0,$T0.2d	// h4 -> h0
+	 bic	$H1,#0xfc,lsl#24
+	 add	$H3,$H3,$T1.2s		// h2 -> h3
+	 bic	$H2,#0xfc,lsl#24
+
+	shrn	$T0.2s,$ACC0,#26
+	xtn	$H0,$ACC0
+	 ushr	$T1.2s,$H3,#26
+	 bic	$H3,#0xfc,lsl#24
+	 bic	$H0,#0xfc,lsl#24
+	add	$H1,$H1,$T0.2s		// h0 -> h1
+	 add	$H4,$H4,$T1.2s		// h3 -> h4
+
+	b.hi	.Loop_neon
+
+.Lskip_loop:
+	dup	$IN23_2,${IN23_2}[0]
+	add	$IN01_2,$IN01_2,$H2
+
+	////////////////////////////////////////////////////////////////
+	// multiply (inp[0:1]+hash) or inp[2:3] by r^2:r^1
+
+	adds	$len,$len,#32
+	b.ne	.Long_tail
+
+	dup	$IN23_2,${IN01_2}[0]
+	add	$IN23_0,$IN01_0,$H0
+	add	$IN23_3,$IN01_3,$H3
+	add	$IN23_1,$IN01_1,$H1
+	add	$IN23_4,$IN01_4,$H4
+
+.Long_tail:
+	dup	$IN23_0,${IN23_0}[0]
+	umull2	$ACC0,$IN23_2,${S3}
+	umull2	$ACC3,$IN23_2,${R1}
+	umull2	$ACC4,$IN23_2,${R2}
+	umull2	$ACC2,$IN23_2,${R0}
+	umull2	$ACC1,$IN23_2,${S4}
+
+	dup	$IN23_1,${IN23_1}[0]
+	umlal2	$ACC0,$IN23_0,${R0}
+	umlal2	$ACC2,$IN23_0,${R2}
+	umlal2	$ACC3,$IN23_0,${R3}
+	umlal2	$ACC4,$IN23_0,${R4}
+	umlal2	$ACC1,$IN23_0,${R1}
+
+	dup	$IN23_3,${IN23_3}[0]
+	umlal2	$ACC0,$IN23_1,${S4}
+	umlal2	$ACC3,$IN23_1,${R2}
+	umlal2	$ACC2,$IN23_1,${R1}
+	umlal2	$ACC4,$IN23_1,${R3}
+	umlal2	$ACC1,$IN23_1,${R0}
+
+	dup	$IN23_4,${IN23_4}[0]
+	umlal2	$ACC3,$IN23_3,${R0}
+	umlal2	$ACC4,$IN23_3,${R1}
+	umlal2	$ACC0,$IN23_3,${S2}
+	umlal2	$ACC1,$IN23_3,${S3}
+	umlal2	$ACC2,$IN23_3,${S4}
+
+	umlal2	$ACC3,$IN23_4,${S4}
+	umlal2	$ACC0,$IN23_4,${S1}
+	umlal2	$ACC4,$IN23_4,${R0}
+	umlal2	$ACC1,$IN23_4,${S2}
+	umlal2	$ACC2,$IN23_4,${S3}
+
+	b.eq	.Lshort_tail
+
+	////////////////////////////////////////////////////////////////
+	// (hash+inp[0:1])*r^4:r^3 and accumulate
+
+	add	$IN01_0,$IN01_0,$H0
+	umlal	$ACC3,$IN01_2,${R1}
+	umlal	$ACC0,$IN01_2,${S3}
+	umlal	$ACC4,$IN01_2,${R2}
+	umlal	$ACC1,$IN01_2,${S4}
+	umlal	$ACC2,$IN01_2,${R0}
+
+	add	$IN01_1,$IN01_1,$H1
+	umlal	$ACC3,$IN01_0,${R3}
+	umlal	$ACC0,$IN01_0,${R0}
+	umlal	$ACC4,$IN01_0,${R4}
+	umlal	$ACC1,$IN01_0,${R1}
+	umlal	$ACC2,$IN01_0,${R2}
+
+	add	$IN01_3,$IN01_3,$H3
+	umlal	$ACC3,$IN01_1,${R2}
+	umlal	$ACC0,$IN01_1,${S4}
+	umlal	$ACC4,$IN01_1,${R3}
+	umlal	$ACC1,$IN01_1,${R0}
+	umlal	$ACC2,$IN01_1,${R1}
+
+	add	$IN01_4,$IN01_4,$H4
+	umlal	$ACC3,$IN01_3,${R0}
+	umlal	$ACC0,$IN01_3,${S2}
+	umlal	$ACC4,$IN01_3,${R1}
+	umlal	$ACC1,$IN01_3,${S3}
+	umlal	$ACC2,$IN01_3,${S4}
+
+	umlal	$ACC3,$IN01_4,${S4}
+	umlal	$ACC0,$IN01_4,${S1}
+	umlal	$ACC4,$IN01_4,${R0}
+	umlal	$ACC1,$IN01_4,${S2}
+	umlal	$ACC2,$IN01_4,${S3}
+
+.Lshort_tail:
+	////////////////////////////////////////////////////////////////
+	// horizontal add
+
+	addp	$ACC3,$ACC3,$ACC3
+	 ldp	d8,d9,[sp,#16]		// meet ABI requirements
+	addp	$ACC0,$ACC0,$ACC0
+	 ldp	d10,d11,[sp,#32]
+	addp	$ACC4,$ACC4,$ACC4
+	 ldp	d12,d13,[sp,#48]
+	addp	$ACC1,$ACC1,$ACC1
+	 ldp	d14,d15,[sp,#64]
+	addp	$ACC2,$ACC2,$ACC2
+
+	////////////////////////////////////////////////////////////////
+	// lazy reduction, but without narrowing
+
+	ushr	$T0.2d,$ACC3,#26
+	and	$ACC3,$ACC3,$MASK.2d
+	 ushr	$T1.2d,$ACC0,#26
+	 and	$ACC0,$ACC0,$MASK.2d
+
+	add	$ACC4,$ACC4,$T0.2d	// h3 -> h4
+	 add	$ACC1,$ACC1,$T1.2d	// h0 -> h1
+
+	ushr	$T0.2d,$ACC4,#26
+	and	$ACC4,$ACC4,$MASK.2d
+	 ushr	$T1.2d,$ACC1,#26
+	 and	$ACC1,$ACC1,$MASK.2d
+	 add	$ACC2,$ACC2,$T1.2d	// h1 -> h2
+
+	add	$ACC0,$ACC0,$T0.2d
+	shl	$T0.2d,$T0.2d,#2
+	 ushr	$T1.2d,$ACC2,#26
+	 and	$ACC2,$ACC2,$MASK.2d
+	add	$ACC0,$ACC0,$T0.2d	// h4 -> h0
+	 add	$ACC3,$ACC3,$T1.2d	// h2 -> h3
+
+	ushr	$T0.2d,$ACC0,#26
+	and	$ACC0,$ACC0,$MASK.2d
+	 ushr	$T1.2d,$ACC3,#26
+	 and	$ACC3,$ACC3,$MASK.2d
+	add	$ACC1,$ACC1,$T0.2d	// h0 -> h1
+	 add	$ACC4,$ACC4,$T1.2d	// h3 -> h4
+
+	////////////////////////////////////////////////////////////////
+	// write the result, can be partially reduced
+
+	st4	{$ACC0,$ACC1,$ACC2,$ACC3}[0],[$ctx],#16
+	st1	{$ACC4}[0],[$ctx]
+
+.Lno_data_neon:
+	ldr	x29,[sp],#80
+	ret
+.size	poly1305_blocks_neon,.-poly1305_blocks_neon
+
+.type	poly1305_emit_neon,%function
+.align	5
+poly1305_emit_neon:
+	ldr	$is_base2_26,[$ctx,#24]
+	cbz	$is_base2_26,poly1305_emit
+
+	ldp	w10,w11,[$ctx]		// load hash value base 2^26
+	ldp	w12,w13,[$ctx,#8]
+	ldr	w14,[$ctx,#16]
+
+	add	$h0,x10,x11,lsl#26	// base 2^26 -> base 2^64
+	lsr	$h1,x12,#12
+	adds	$h0,$h0,x12,lsl#52
+	add	$h1,$h1,x13,lsl#14
+	adc	$h1,$h1,xzr
+	lsr	$h2,x14,#24
+	adds	$h1,$h1,x14,lsl#40
+	adc	$h2,$h2,xzr		// can be partially reduced...
+
+	ldp	$t0,$t1,[$nonce]	// load nonce
+
+	and	$d0,$h2,#-4		// ... so reduce
+	add	$d0,$d0,$h2,lsr#2
+	and	$h2,$h2,#3
+	adds	$h0,$h0,$d0
+	adcs	$h1,$h1,xzr
+	adc	$h2,$h2,xzr
+
+	adds	$d0,$h0,#5		// compare to modulus
+	adcs	$d1,$h1,xzr
+	adc	$d2,$h2,xzr
+
+	tst	$d2,#-4			// see if it's carried/borrowed
+
+	csel	$h0,$h0,$d0,eq
+	csel	$h1,$h1,$d1,eq
+
+#ifdef	__AARCH64EB__
+	ror	$t0,$t0,#32		// flip nonce words
+	ror	$t1,$t1,#32
+#endif
+	adds	$h0,$h0,$t0		// accumulate nonce
+	adc	$h1,$h1,$t1
+#ifdef	__AARCH64EB__
+	rev	$h0,$h0			// flip output bytes
+	rev	$h1,$h1
+#endif
+	stp	$h0,$h1,[$mac]		// write result
+
+	ret
+.size	poly1305_emit_neon,.-poly1305_emit_neon
+#endif
+
+.align	5
+.Lzeros:
+.long	0,0,0,0,0,0,0,0
+#ifndef __KERNEL__
+.LOPENSSL_armcap_P:
+#ifdef	__ILP32__
+.long	OPENSSL_armcap_P-.
+#else
+.quad	OPENSSL_armcap_P-.
+#endif
+#endif
+.align	2
+___
+
+open SELF,$0;
+while(<SELF>) {
+	next if (/^#!/);
+	last if (!s/^#/\/\// and !/^$/);
+	print;
+}
+close SELF;
+
+foreach (split("\n",$code)) {
+	s/\b(shrn\s+v[0-9]+)\.[24]d/$1.2s/			or
+	s/\b(fmov\s+)v([0-9]+)[^,]*,\s*x([0-9]+)/$1d$2,x$3/	or
+	(m/\bdup\b/ and (s/\.[24]s/.2d/g or 1))			or
+	(m/\b(eor|and)/ and (s/\.[248][sdh]/.16b/g or 1))	or
+	(m/\bum(ul|la)l\b/ and (s/\.4s/.2s/g or 1))		or
+	(m/\bum(ul|la)l2\b/ and (s/\.2s/.4s/g or 1))		or
+	(m/\bst[1-4]\s+{[^}]+}\[/ and (s/\.[24]d/.s/g or 1));
+
+	s/\.[124]([sd])\[/.$1\[/;
+
+	print $_,"\n";
+}
+close STDOUT;
diff --git a/lib/zinc/poly1305/poly1305.c b/lib/zinc/poly1305/poly1305.c
index 876a431a06f5..5cfe4a32514f 100644
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
2.21.0
