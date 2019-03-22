From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next v9 10/19] zinc: Poly1305 MIPS64 and MIPS32r2 implementations
Date: Fri, 22 Mar 2019 01:11:13 -0600
Message-Id: <20190322071122.6677-11-Jason@zx2c4.com>
In-Reply-To: <20190322071122.6677-1-Jason@zx2c4.com>
References: <20190322071122.6677-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>, Andy Polyakov <appro@openssl.org>, Ralf Baechle <ralf@linux-mips.org>, Paul Burton <paul.burton@mips.com>, James Hogan <jhogan@kernel.org>, linux-mips@linux-mips.org, Samuel Neves <sneves@dei.uc.pt>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, Andy Lutomirski <luto@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

The MIPS64 accelerated implementation comes from Andy Polyakov's
implementation and provides nice speedups on commodity Octeon hardware.
While this is CRYPTOGAMS code, the originating code for this happens to
be the same as OpenSSL's commit 9925a82146f2503b4dd11423d0eba649b43450c0

This MIPS32r2 implementation comes from René van Dorst and me and
results in a nice speedup on the usual OpenWRT targets.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: René van Dorst <opensource@vdorst.com>
Co-developed-by: René van Dorst <opensource@vdorst.com>
Co-developed-by: Andy Polyakov <appro@openssl.org>
Cc: Andy Polyakov <appro@openssl.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Burton <paul.burton@mips.com>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-mips@linux-mips.org
Cc: Samuel Neves <sneves@dei.uc.pt>
Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kernel-hardening@lists.openwall.com
Cc: linux-crypto@vger.kernel.org
---
 lib/zinc/Makefile                      |   5 +-
 lib/zinc/poly1305/poly1305-mips-glue.c |  37 ++
 lib/zinc/poly1305/poly1305-mips.S      | 407 +++++++++++++++++++++
 lib/zinc/poly1305/poly1305-mips64.pl   | 467 +++++++++++++++++++++++++
 lib/zinc/poly1305/poly1305.c           |   2 +
 5 files changed, 917 insertions(+), 1 deletion(-)
 create mode 100644 lib/zinc/poly1305/poly1305-mips-glue.c
 create mode 100644 lib/zinc/poly1305/poly1305-mips.S
 create mode 100644 lib/zinc/poly1305/poly1305-mips64.pl

diff --git a/lib/zinc/Makefile b/lib/zinc/Makefile
index 488c5f2e3078..e1efab61ed31 100644
--- a/lib/zinc/Makefile
+++ b/lib/zinc/Makefile
@@ -15,7 +15,10 @@ zinc_poly1305-y := poly1305/poly1305.o
 zinc_poly1305-$(CONFIG_ZINC_ARCH_X86_64) += poly1305/poly1305-x86_64.o
 zinc_poly1305-$(CONFIG_ZINC_ARCH_ARM) += poly1305/poly1305-arm.o
 zinc_poly1305-$(CONFIG_ZINC_ARCH_ARM64) += poly1305/poly1305-arm64.o
-perlasm-targets += poly1305/poly1305-x86_64.S poly1305/poly1305-arm.S poly1305/poly1305-arm64.S
+zinc_poly1305-$(CONFIG_ZINC_ARCH_MIPS) += poly1305/poly1305-mips.o
+AFLAGS_poly1305-mips.o += -O2 # This is required to fill the branch delay slots
+zinc_poly1305-$(CONFIG_ZINC_ARCH_MIPS64) += poly1305/poly1305-mips64.o
+perlasm-targets += poly1305/poly1305-x86_64.S poly1305/poly1305-arm.S poly1305/poly1305-arm64.S poly1305/poly1305-mips64.S
 obj-$(CONFIG_ZINC_POLY1305) += zinc_poly1305.o
 
 quiet_cmd_perlasm = PERLASM $@
diff --git a/lib/zinc/poly1305/poly1305-mips-glue.c b/lib/zinc/poly1305/poly1305-mips-glue.c
new file mode 100644
index 000000000000..a540e9c4eee8
--- /dev/null
+++ b/lib/zinc/poly1305/poly1305-mips-glue.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0 OR MIT
+/*
+ * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+asmlinkage void poly1305_init_mips(void *ctx, const u8 key[16]);
+asmlinkage void poly1305_blocks_mips(void *ctx, const u8 *inp, const size_t len,
+				     const u32 padbit);
+asmlinkage void poly1305_emit_mips(void *ctx, u8 mac[16], const u32 nonce[4]);
+
+static bool *const poly1305_nobs[] __initconst = { };
+static void __init poly1305_fpu_init(void)
+{
+}
+
+static inline bool poly1305_init_arch(void *ctx,
+				      const u8 key[POLY1305_KEY_SIZE])
+{
+	poly1305_init_mips(ctx, key);
+	return true;
+}
+
+static inline bool poly1305_blocks_arch(void *ctx, const u8 *inp,
+					size_t len, const u32 padbit,
+					simd_context_t *simd_context)
+{
+	poly1305_blocks_mips(ctx, inp, len, padbit);
+	return true;
+}
+
+static inline bool poly1305_emit_arch(void *ctx, u8 mac[POLY1305_MAC_SIZE],
+				      const u32 nonce[4],
+				      simd_context_t *simd_context)
+{
+	poly1305_emit_mips(ctx, mac, nonce);
+	return true;
+}
diff --git a/lib/zinc/poly1305/poly1305-mips.S b/lib/zinc/poly1305/poly1305-mips.S
new file mode 100644
index 000000000000..4291c156815b
--- /dev/null
+++ b/lib/zinc/poly1305/poly1305-mips.S
@@ -0,0 +1,407 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Copyright (C) 2016-2018 René van Dorst <opensource@vdorst.com> All Rights Reserved.
+ * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+#define MSB 0
+#define LSB 3
+#else
+#define MSB 3
+#define LSB 0
+#endif
+
+#define POLY1305_BLOCK_SIZE 16
+.text
+#define H0 $t0
+#define H1 $t1
+#define H2 $t2
+#define H3 $t3
+#define H4 $t4
+
+#define R0 $t5
+#define R1 $t6
+#define R2 $t7
+#define R3 $t8
+
+#define O0 $s0
+#define O1 $s4
+#define O2 $v1
+#define O3 $t9
+#define O4 $s5
+
+#define S1 $s1
+#define S2 $s2
+#define S3 $s3
+
+#define SC $at
+#define CA $v0
+
+/* Input arguments */
+#define poly	$a0
+#define src	$a1
+#define srclen	$a2
+#define hibit	$a3
+
+/* Location in the opaque buffer
+ * R[0..3], CA, H[0..4]
+ */
+#define PTR_POLY1305_R(n) ( 0 + (n*4)) ## ($a0)
+#define PTR_POLY1305_CA   (16        ) ## ($a0)
+#define PTR_POLY1305_H(n) (20 + (n*4)) ## ($a0)
+
+#define POLY1305_BLOCK_SIZE 16
+#define POLY1305_STACK_SIZE 32
+
+.set	noat
+.align	4
+.globl	poly1305_blocks_mips
+.ent	poly1305_blocks_mips
+poly1305_blocks_mips:
+	.frame	$sp, POLY1305_STACK_SIZE, $ra
+	/* srclen &= 0xFFFFFFF0 */
+	ins	srclen, $zero, 0, 4
+
+	addiu	$sp, -(POLY1305_STACK_SIZE)
+
+	/* check srclen >= 16 bytes */
+	beqz	srclen, .Lpoly1305_blocks_mips_end
+
+	/* Calculate last round based on src address pointer.
+	 * last round src ptr (srclen) = src + (srclen & 0xFFFFFFF0)
+	 */
+	addu	srclen, src
+
+	lw	R0, PTR_POLY1305_R(0)
+	lw	R1, PTR_POLY1305_R(1)
+	lw	R2, PTR_POLY1305_R(2)
+	lw	R3, PTR_POLY1305_R(3)
+
+	/* store the used save registers. */
+	sw	$s0, 0($sp)
+	sw	$s1, 4($sp)
+	sw	$s2, 8($sp)
+	sw	$s3, 12($sp)
+	sw	$s4, 16($sp)
+	sw	$s5, 20($sp)
+
+	/* load Hx and Carry */
+	lw	CA, PTR_POLY1305_CA
+	lw	H0, PTR_POLY1305_H(0)
+	lw	H1, PTR_POLY1305_H(1)
+	lw	H2, PTR_POLY1305_H(2)
+	lw	H3, PTR_POLY1305_H(3)
+	lw	H4, PTR_POLY1305_H(4)
+
+	/* Sx = Rx + (Rx >> 2) */
+	srl	S1, R1, 2
+	srl	S2, R2, 2
+	srl	S3, R3, 2
+	addu	S1, R1
+	addu	S2, R2
+	addu	S3, R3
+
+	addiu	SC, $zero, 1
+
+.Lpoly1305_loop:
+	lwl	O0, 0+MSB(src)
+	lwl	O1, 4+MSB(src)
+	lwl	O2, 8+MSB(src)
+	lwl	O3,12+MSB(src)
+	lwr	O0, 0+LSB(src)
+	lwr	O1, 4+LSB(src)
+	lwr	O2, 8+LSB(src)
+	lwr	O3,12+LSB(src)
+
+#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+	wsbh	O0
+	wsbh	O1
+	wsbh	O2
+	wsbh	O3
+	rotr	O0, 16
+	rotr	O1, 16
+	rotr	O2, 16
+	rotr	O3, 16
+#endif
+
+	/* h0 = (u32)(d0 = (u64)h0 + inp[0] + c 'Carry_previous cycle'); */
+	addu	H0, CA
+	sltu	CA, H0, CA
+	addu	O0, H0
+	sltu	H0, O0, H0
+	addu	CA, H0
+
+	/* h1 = (u32)(d1 = (u64)h1 + (d0 >> 32) + inp[4]); */
+	addu	H1, CA
+	sltu	CA, H1, CA
+	addu	O1, H1
+	sltu	H1, O1, H1
+	addu	CA, H1
+
+	/* h2 = (u32)(d2 = (u64)h2 + (d1 >> 32) + inp[8]); */
+	addu	H2, CA
+	sltu	CA, H2, CA
+	addu	O2, H2
+	sltu	H2, O2, H2
+	addu	CA, H2
+
+	/* h3 = (u32)(d3 = (u64)h3 + (d2 >> 32) + inp[12]); */
+	addu	H3, CA
+	sltu	CA, H3, CA
+	addu	O3, H3
+	sltu	H3, O3, H3
+	addu	CA, H3
+
+	/* h4 += (u32)(d3 >> 32) + padbit; */
+	addu	H4, hibit
+	addu	O4, H4, CA
+
+	/* D0 */
+	multu	O0, R0
+	maddu	O1, S3
+	maddu	O2, S2
+	maddu	O3, S1
+	mfhi	CA
+	mflo	H0
+
+	/* D1 */
+	multu	O0, R1
+	maddu	O1, R0
+	maddu	O2, S3
+	maddu	O3, S2
+	maddu	O4, S1
+	maddu	CA, SC
+	mfhi	CA
+	mflo	H1
+
+	/* D2 */
+	multu	O0, R2
+	maddu	O1, R1
+	maddu	O2, R0
+	maddu	O3, S3
+	maddu	O4, S2
+	maddu	CA, SC
+	mfhi	CA
+	mflo	H2
+
+	/* D4 */
+	mul	H4, O4, R0
+
+	/* D3 */
+	multu	O0, R3
+	maddu	O1, R2
+	maddu	O2, R1
+	maddu	O3, R0
+	maddu	O4, S3
+	maddu	CA, SC
+	mfhi	CA
+	mflo	H3
+
+	addiu	src, POLY1305_BLOCK_SIZE
+
+	/* h4 += (u32)(d3 >> 32); */
+	addu	O4, H4, CA
+	/* h4 &= 3 */
+	andi	H4, O4, 3
+	/* c = (h4 >> 2) + (h4 & ~3U); */
+	srl	CA, O4, 2
+	ins	O4, $zero, 0, 2
+
+	addu	CA, O4
+
+	/* able to do a 16 byte block. */
+	bne	src, srclen, .Lpoly1305_loop
+
+	/* restore the used save registers. */
+	lw	$s0, 0($sp)
+	lw	$s1, 4($sp)
+	lw	$s2, 8($sp)
+	lw	$s3, 12($sp)
+	lw	$s4, 16($sp)
+	lw	$s5, 20($sp)
+
+	/* store Hx and Carry */
+	sw	CA, PTR_POLY1305_CA
+	sw	H0, PTR_POLY1305_H(0)
+	sw	H1, PTR_POLY1305_H(1)
+	sw	H2, PTR_POLY1305_H(2)
+	sw	H3, PTR_POLY1305_H(3)
+	sw	H4, PTR_POLY1305_H(4)
+
+.Lpoly1305_blocks_mips_end:
+	addiu	$sp, POLY1305_STACK_SIZE
+
+	/* Jump Back */
+	jr	$ra
+.end poly1305_blocks_mips
+.set at
+
+/* Input arguments CTX=$a0, MAC=$a1, NONCE=$a2 */
+#define MAC	$a1
+#define NONCE	$a2
+
+#define G0	$t5
+#define G1	$t6
+#define G2	$t7
+#define G3	$t8
+#define G4	$t9
+
+.set	noat
+.align	4
+.globl	poly1305_emit_mips
+.ent	poly1305_emit_mips
+poly1305_emit_mips:
+	/* load Hx and Carry */
+	lw	CA, PTR_POLY1305_CA
+	lw	H0, PTR_POLY1305_H(0)
+	lw	H1, PTR_POLY1305_H(1)
+	lw	H2, PTR_POLY1305_H(2)
+	lw	H3, PTR_POLY1305_H(3)
+	lw	H4, PTR_POLY1305_H(4)
+
+	/* Add left over carry */
+	addu	H0, CA
+	sltu	CA, H0, CA
+	addu	H1, CA
+	sltu	CA, H1, CA
+	addu	H2, CA
+	sltu	CA, H2, CA
+	addu	H3, CA
+	sltu	CA, H3, CA
+	addu	H4, CA
+
+	/* compare to modulus by computing h + -p */
+	addiu	G0, H0, 5
+	sltu	CA, G0, H0
+	addu	G1, H1, CA
+	sltu	CA, G1, H1
+	addu	G2, H2, CA
+	sltu	CA, G2, H2
+	addu	G3, H3, CA
+	sltu	CA, G3, H3
+	addu	G4, H4, CA
+
+	srl	SC, G4, 2
+
+	/* if there was carry into 131st bit, h3:h0 = g3:g0 */
+	movn	H0, G0, SC
+	movn	H1, G1, SC
+	movn	H2, G2, SC
+	movn	H3, G3, SC
+
+	lwl	G0, 0+MSB(NONCE)
+	lwl	G1, 4+MSB(NONCE)
+	lwl	G2, 8+MSB(NONCE)
+	lwl	G3,12+MSB(NONCE)
+	lwr	G0, 0+LSB(NONCE)
+	lwr	G1, 4+LSB(NONCE)
+	lwr	G2, 8+LSB(NONCE)
+	lwr	G3,12+LSB(NONCE)
+
+	/* mac = (h + nonce) % (2^128) */
+	addu	H0, G0
+	sltu	CA, H0, G0
+
+	/* H1 */
+	addu	H1, CA
+	sltu	CA, H1, CA
+	addu	H1, G1
+	sltu	G1, H1, G1
+	addu	CA, G1
+
+	/* H2 */
+	addu	H2, CA
+	sltu	CA, H2, CA
+	addu	H2, G2
+	sltu	G2, H2, G2
+	addu	CA, G2
+
+	/* H3 */
+	addu	H3, CA
+	addu	H3, G3
+
+#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+	wsbh	H0
+	wsbh	H1
+	wsbh	H2
+	wsbh	H3
+	rotr	H0, 16
+	rotr	H1, 16
+	rotr	H2, 16
+	rotr	H3, 16
+#endif
+
+	/* store MAC */
+	swl	H0, 0+MSB(MAC)
+	swl	H1, 4+MSB(MAC)
+	swl	H2, 8+MSB(MAC)
+	swl	H3,12+MSB(MAC)
+	swr	H0, 0+LSB(MAC)
+	swr	H1, 4+LSB(MAC)
+	swr	H2, 8+LSB(MAC)
+	swr	H3,12+LSB(MAC)
+
+	jr	$ra
+.end poly1305_emit_mips
+
+#define PR0 $t0
+#define PR1 $t1
+#define PR2 $t2
+#define PR3 $t3
+#define PT0 $t4
+
+/* Input arguments CTX=$a0, KEY=$a1 */
+
+.align	4
+.globl	poly1305_init_mips
+.ent	poly1305_init_mips
+poly1305_init_mips:
+	lwl	PR0, 0+MSB($a1)
+	lwl	PR1, 4+MSB($a1)
+	lwl	PR2, 8+MSB($a1)
+	lwl	PR3,12+MSB($a1)
+	lwr	PR0, 0+LSB($a1)
+	lwr	PR1, 4+LSB($a1)
+	lwr	PR2, 8+LSB($a1)
+	lwr	PR3,12+LSB($a1)
+
+	/* store Hx and Carry */
+	sw	$zero, PTR_POLY1305_CA
+	sw	$zero, PTR_POLY1305_H(0)
+	sw	$zero, PTR_POLY1305_H(1)
+	sw	$zero, PTR_POLY1305_H(2)
+	sw	$zero, PTR_POLY1305_H(3)
+	sw	$zero, PTR_POLY1305_H(4)
+
+#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+	wsbh	PR0
+	wsbh	PR1
+	wsbh	PR2
+	wsbh	PR3
+	rotr	PR0, 16
+	rotr	PR1, 16
+	rotr	PR2, 16
+	rotr	PR3, 16
+#endif
+
+	lui	PT0, 0x0FFF
+	ori	PT0, 0xFFFC
+
+	/* AND 0x0fffffff; */
+	ext	PR0, PR0, 0, (32-4)
+
+	/* AND 0x0ffffffc; */
+	and	PR1, PT0
+	and	PR2, PT0
+	and	PR3, PT0
+
+	/* store Rx */
+	sw	PR0, PTR_POLY1305_R(0)
+	sw	PR1, PTR_POLY1305_R(1)
+	sw	PR2, PTR_POLY1305_R(2)
+	sw	PR3, PTR_POLY1305_R(3)
+
+	/* Jump Back  */
+	jr	$ra
+.end poly1305_init_mips
diff --git a/lib/zinc/poly1305/poly1305-mips64.pl b/lib/zinc/poly1305/poly1305-mips64.pl
new file mode 100644
index 000000000000..d30a03d79177
--- /dev/null
+++ b/lib/zinc/poly1305/poly1305-mips64.pl
@@ -0,0 +1,467 @@
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
+# Poly1305 hash for MIPS64.
+#
+# May 2016
+#
+# Numbers are cycles per processed byte with poly1305_blocks alone.
+#
+#		IALU/gcc
+# R1x000	5.64/+120%	(big-endian)
+# Octeon II	3.80/+280%	(little-endian)
+
+######################################################################
+# There is a number of MIPS ABI in use, O32 and N32/64 are most
+# widely used. Then there is a new contender: NUBI. It appears that if
+# one picks the latter, it's possible to arrange code in ABI neutral
+# manner. Therefore let's stick to NUBI register layout:
+#
+($zero,$at,$t0,$t1,$t2)=map("\$$_",(0..2,24,25));
+($a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7)=map("\$$_",(4..11));
+($s0,$s1,$s2,$s3,$s4,$s5,$s6,$s7,$s8,$s9,$s10,$s11)=map("\$$_",(12..23));
+($gp,$tp,$sp,$fp,$ra)=map("\$$_",(3,28..31));
+#
+# The return value is placed in $a0. Following coding rules facilitate
+# interoperability:
+#
+# - never ever touch $tp, "thread pointer", former $gp [o32 can be
+#   excluded from the rule, because it's specified volatile];
+# - copy return value to $t0, former $v0 [or to $a0 if you're adapting
+#   old code];
+# - on O32 populate $a4-$a7 with 'lw $aN,4*N($sp)' if necessary;
+#
+# For reference here is register layout for N32/64 MIPS ABIs:
+#
+# ($zero,$at,$v0,$v1)=map("\$$_",(0..3));
+# ($a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7)=map("\$$_",(4..11));
+# ($t0,$t1,$t2,$t3,$t8,$t9)=map("\$$_",(12..15,24,25));
+# ($s0,$s1,$s2,$s3,$s4,$s5,$s6,$s7)=map("\$$_",(16..23));
+# ($gp,$sp,$fp,$ra)=map("\$$_",(28..31));
+#
+# <appro@openssl.org>
+#
+######################################################################
+
+$flavour = shift || "64"; # supported flavours are o32,n32,64,nubi32,nubi64
+
+die "MIPS64 only" unless ($flavour =~ /64|n32/i);
+
+$v0 = ($flavour =~ /nubi/i) ? $a0 : $t0;
+$SAVED_REGS_MASK = ($flavour =~ /nubi/i) ? "0x0003f000" : "0x00030000";
+
+($ctx,$inp,$len,$padbit) = ($a0,$a1,$a2,$a3);
+($in0,$in1,$tmp0,$tmp1,$tmp2,$tmp3,$tmp4) = ($a4,$a5,$a6,$a7,$at,$t0,$t1);
+
+$code.=<<___;
+#if (defined(_MIPS_ARCH_MIPS64R3) || defined(_MIPS_ARCH_MIPS64R5) || \\
+     defined(_MIPS_ARCH_MIPS64R6)) \\
+     && !defined(_MIPS_ARCH_MIPS64R2)
+# define _MIPS_ARCH_MIPS64R2
+#endif
+
+#if defined(_MIPS_ARCH_MIPS64R6)
+# define dmultu(rs,rt)
+# define mflo(rd,rs,rt)	dmulu	rd,rs,rt
+# define mfhi(rd,rs,rt)	dmuhu	rd,rs,rt
+#else
+# define dmultu(rs,rt)		dmultu	rs,rt
+# define mflo(rd,rs,rt)	mflo	rd
+# define mfhi(rd,rs,rt)	mfhi	rd
+#endif
+
+#ifdef	__KERNEL__
+# define poly1305_init   poly1305_init_mips
+# define poly1305_blocks poly1305_blocks_mips
+# define poly1305_emit   poly1305_emit_mips
+#endif
+
+#if defined(__MIPSEB__) && !defined(MIPSEB)
+# define MIPSEB
+#endif
+
+#ifdef MIPSEB
+# define MSB 0
+# define LSB 7
+#else
+# define MSB 7
+# define LSB 0
+#endif
+
+.text
+.set	noat
+.set	noreorder
+
+.align	5
+.globl	poly1305_init
+.ent	poly1305_init
+poly1305_init:
+	.frame	$sp,0,$ra
+	.set	reorder
+
+	sd	$zero,0($ctx)
+	sd	$zero,8($ctx)
+	sd	$zero,16($ctx)
+
+	beqz	$inp,.Lno_key
+
+#if defined(_MIPS_ARCH_MIPS64R6)
+	ld	$in0,0($inp)
+	ld	$in1,8($inp)
+#else
+	ldl	$in0,0+MSB($inp)
+	ldl	$in1,8+MSB($inp)
+	ldr	$in0,0+LSB($inp)
+	ldr	$in1,8+LSB($inp)
+#endif
+#ifdef	MIPSEB
+# if defined(_MIPS_ARCH_MIPS64R2)
+	dsbh	$in0,$in0		# byte swap
+	 dsbh	$in1,$in1
+	dshd	$in0,$in0
+	 dshd	$in1,$in1
+# else
+	ori	$tmp0,$zero,0xFF
+	dsll	$tmp2,$tmp0,32
+	or	$tmp0,$tmp2		# 0x000000FF000000FF
+
+	and	$tmp1,$in0,$tmp0	# byte swap
+	 and	$tmp3,$in1,$tmp0
+	dsrl	$tmp2,$in0,24
+	 dsrl	$tmp4,$in1,24
+	dsll	$tmp1,24
+	 dsll	$tmp3,24
+	and	$tmp2,$tmp0
+	 and	$tmp4,$tmp0
+	dsll	$tmp0,8			# 0x0000FF000000FF00
+	or	$tmp1,$tmp2
+	 or	$tmp3,$tmp4
+	and	$tmp2,$in0,$tmp0
+	 and	$tmp4,$in1,$tmp0
+	dsrl	$in0,8
+	 dsrl	$in1,8
+	dsll	$tmp2,8
+	 dsll	$tmp4,8
+	and	$in0,$tmp0
+	 and	$in1,$tmp0
+	or	$tmp1,$tmp2
+	 or	$tmp3,$tmp4
+	or	$in0,$tmp1
+	 or	$in1,$tmp3
+	dsrl	$tmp1,$in0,32
+	 dsrl	$tmp3,$in1,32
+	dsll	$in0,32
+	 dsll	$in1,32
+	or	$in0,$tmp1
+	 or	$in1,$tmp3
+# endif
+#endif
+	li	$tmp0,1
+	dsll	$tmp0,32
+	daddiu	$tmp0,-63
+	dsll	$tmp0,28
+	daddiu	$tmp0,-1		# 0ffffffc0fffffff
+
+	and	$in0,$tmp0
+	daddiu	$tmp0,-3		# 0ffffffc0ffffffc
+	and	$in1,$tmp0
+
+	sd	$in0,24($ctx)
+	dsrl	$tmp0,$in1,2
+	sd	$in1,32($ctx)
+	daddu	$tmp0,$in1		# s1 = r1 + (r1 >> 2)
+	sd	$tmp0,40($ctx)
+
+.Lno_key:
+	li	$v0,0			# return 0
+	jr	$ra
+.end	poly1305_init
+___
+{
+my ($h0,$h1,$h2,$r0,$r1,$s1,$d0,$d1,$d2) =
+   ($s0,$s1,$s2,$s3,$s4,$s5,$in0,$in1,$t2);
+
+$code.=<<___;
+.align	5
+.globl	poly1305_blocks
+.ent	poly1305_blocks
+poly1305_blocks:
+	.set	noreorder
+	dsrl	$len,4			# number of complete blocks
+	bnez	$len,poly1305_blocks_internal
+	nop
+	jr	$ra
+	nop
+.end	poly1305_blocks
+
+.align	5
+.ent	poly1305_blocks_internal
+poly1305_blocks_internal:
+	.frame	$sp,6*8,$ra
+	.mask	$SAVED_REGS_MASK,-8
+	.set	noreorder
+	dsubu	$sp,6*8
+	sd	$s5,40($sp)
+	sd	$s4,32($sp)
+___
+$code.=<<___ if ($flavour =~ /nubi/i);	# optimize non-nubi prologue
+	sd	$s3,24($sp)
+	sd	$s2,16($sp)
+	sd	$s1,8($sp)
+	sd	$s0,0($sp)
+___
+$code.=<<___;
+	.set	reorder
+
+	ld	$h0,0($ctx)		# load hash value
+	ld	$h1,8($ctx)
+	ld	$h2,16($ctx)
+
+	ld	$r0,24($ctx)		# load key
+	ld	$r1,32($ctx)
+	ld	$s1,40($ctx)
+
+.Loop:
+#if defined(_MIPS_ARCH_MIPS64R6)
+	ld	$in0,0($inp)		# load input
+	ld	$in1,8($inp)
+#else
+	ldl	$in0,0+MSB($inp)	# load input
+	ldl	$in1,8+MSB($inp)
+	ldr	$in0,0+LSB($inp)
+	ldr	$in1,8+LSB($inp)
+#endif
+	daddiu	$len,-1
+	daddiu	$inp,16
+#ifdef	MIPSEB
+# if defined(_MIPS_ARCH_MIPS64R2)
+	dsbh	$in0,$in0		# byte swap
+	 dsbh	$in1,$in1
+	dshd	$in0,$in0
+	 dshd	$in1,$in1
+# else
+	ori	$tmp0,$zero,0xFF
+	dsll	$tmp2,$tmp0,32
+	or	$tmp0,$tmp2		# 0x000000FF000000FF
+
+	and	$tmp1,$in0,$tmp0	# byte swap
+	 and	$tmp3,$in1,$tmp0
+	dsrl	$tmp2,$in0,24
+	 dsrl	$tmp4,$in1,24
+	dsll	$tmp1,24
+	 dsll	$tmp3,24
+	and	$tmp2,$tmp0
+	 and	$tmp4,$tmp0
+	dsll	$tmp0,8			# 0x0000FF000000FF00
+	or	$tmp1,$tmp2
+	 or	$tmp3,$tmp4
+	and	$tmp2,$in0,$tmp0
+	 and	$tmp4,$in1,$tmp0
+	dsrl	$in0,8
+	 dsrl	$in1,8
+	dsll	$tmp2,8
+	 dsll	$tmp4,8
+	and	$in0,$tmp0
+	 and	$in1,$tmp0
+	or	$tmp1,$tmp2
+	 or	$tmp3,$tmp4
+	or	$in0,$tmp1
+	 or	$in1,$tmp3
+	dsrl	$tmp1,$in0,32
+	 dsrl	$tmp3,$in1,32
+	dsll	$in0,32
+	 dsll	$in1,32
+	or	$in0,$tmp1
+	 or	$in1,$tmp3
+# endif
+#endif
+	daddu	$h0,$in0		# accumulate input
+	daddu	$h1,$in1
+	sltu	$tmp0,$h0,$in0
+	sltu	$tmp1,$h1,$in1
+	daddu	$h1,$tmp0
+
+	dmultu	($r0,$h0)		# h0*r0
+	 daddu	$h2,$padbit
+	 sltu	$tmp0,$h1,$tmp0
+	mflo	($d0,$r0,$h0)
+	mfhi	($d1,$r0,$h0)
+
+	dmultu	($s1,$h1)		# h1*5*r1
+	 daddu	$tmp0,$tmp1
+	 daddu	$h2,$tmp0
+	mflo	($tmp0,$s1,$h1)
+	mfhi	($tmp1,$s1,$h1)
+
+	dmultu	($r1,$h0)		# h0*r1
+	 daddu	$d0,$tmp0
+	 daddu	$d1,$tmp1
+	mflo	($tmp2,$r1,$h0)
+	mfhi	($d2,$r1,$h0)
+	 sltu	$tmp0,$d0,$tmp0
+	 daddu	$d1,$tmp0
+
+	dmultu	($r0,$h1)		# h1*r0
+	 daddu	$d1,$tmp2
+	 sltu	$tmp2,$d1,$tmp2
+	mflo	($tmp0,$r0,$h1)
+	mfhi	($tmp1,$r0,$h1)
+	 daddu	$d2,$tmp2
+
+	dmultu	($s1,$h2)		# h2*5*r1
+	 daddu	$d1,$tmp0
+	 daddu	$d2,$tmp1
+	mflo	($tmp2,$s1,$h2)
+
+	dmultu	($r0,$h2)		# h2*r0
+	 sltu	$tmp0,$d1,$tmp0
+	 daddu	$d2,$tmp0
+	mflo	($tmp3,$r0,$h2)
+
+	daddu	$d1,$tmp2
+	daddu	$d2,$tmp3
+	sltu	$tmp2,$d1,$tmp2
+	daddu	$d2,$tmp2
+
+	li	$tmp0,-4		# final reduction
+	and	$tmp0,$d2
+	dsrl	$tmp1,$d2,2
+	andi	$h2,$d2,3
+	daddu	$tmp0,$tmp1
+	daddu	$h0,$d0,$tmp0
+	sltu	$tmp0,$h0,$tmp0
+	daddu	$h1,$d1,$tmp0
+	sltu	$tmp0,$h1,$tmp0
+	daddu	$h2,$h2,$tmp0
+
+	bnez	$len,.Loop
+
+	sd	$h0,0($ctx)		# store hash value
+	sd	$h1,8($ctx)
+	sd	$h2,16($ctx)
+
+	.set	noreorder
+	ld	$s5,40($sp)		# epilogue
+	ld	$s4,32($sp)
+___
+$code.=<<___ if ($flavour =~ /nubi/i);	# optimize non-nubi epilogue
+	ld	$s3,24($sp)
+	ld	$s2,16($sp)
+	ld	$s1,8($sp)
+	ld	$s0,0($sp)
+___
+$code.=<<___;
+	jr	$ra
+	daddu	$sp,6*8
+.end	poly1305_blocks_internal
+___
+}
+{
+my ($ctx,$mac,$nonce) = ($a0,$a1,$a2);
+
+$code.=<<___;
+.align	5
+.globl	poly1305_emit
+.ent	poly1305_emit
+poly1305_emit:
+	.frame	$sp,0,$ra
+	.set	reorder
+
+	ld	$tmp0,0($ctx)
+	ld	$tmp1,8($ctx)
+	ld	$tmp2,16($ctx)
+
+	daddiu	$in0,$tmp0,5		# compare to modulus
+	sltiu	$tmp3,$in0,5
+	daddu	$in1,$tmp1,$tmp3
+	sltu	$tmp3,$in1,$tmp3
+	daddu	$tmp2,$tmp2,$tmp3
+
+	dsrl	$tmp2,2			# see if it carried/borrowed
+	dsubu	$tmp2,$zero,$tmp2
+	nor	$tmp3,$zero,$tmp2
+
+	and	$in0,$tmp2
+	and	$tmp0,$tmp3
+	and	$in1,$tmp2
+	and	$tmp1,$tmp3
+	or	$in0,$tmp0
+	or	$in1,$tmp1
+
+	lwu	$tmp0,0($nonce)		# load nonce
+	lwu	$tmp1,4($nonce)
+	lwu	$tmp2,8($nonce)
+	lwu	$tmp3,12($nonce)
+	dsll	$tmp1,32
+	dsll	$tmp3,32
+	or	$tmp0,$tmp1
+	or	$tmp2,$tmp3
+
+	daddu	$in0,$tmp0		# accumulate nonce
+	daddu	$in1,$tmp2
+	sltu	$tmp0,$in0,$tmp0
+	daddu	$in1,$tmp0
+
+	dsrl	$tmp0,$in0,8		# write mac value
+	dsrl	$tmp1,$in0,16
+	dsrl	$tmp2,$in0,24
+	sb	$in0,0($mac)
+	dsrl	$tmp3,$in0,32
+	sb	$tmp0,1($mac)
+	dsrl	$tmp0,$in0,40
+	sb	$tmp1,2($mac)
+	dsrl	$tmp1,$in0,48
+	sb	$tmp2,3($mac)
+	dsrl	$tmp2,$in0,56
+	sb	$tmp3,4($mac)
+	dsrl	$tmp3,$in1,8
+	sb	$tmp0,5($mac)
+	dsrl	$tmp0,$in1,16
+	sb	$tmp1,6($mac)
+	dsrl	$tmp1,$in1,24
+	sb	$tmp2,7($mac)
+
+	sb	$in1,8($mac)
+	dsrl	$tmp2,$in1,32
+	sb	$tmp3,9($mac)
+	dsrl	$tmp3,$in1,40
+	sb	$tmp0,10($mac)
+	dsrl	$tmp0,$in1,48
+	sb	$tmp1,11($mac)
+	dsrl	$tmp1,$in1,56
+	sb	$tmp2,12($mac)
+	sb	$tmp3,13($mac)
+	sb	$tmp0,14($mac)
+	sb	$tmp1,15($mac)
+
+	jr	$ra
+.end	poly1305_emit
+.rdata
+.align	2
+___
+}
+
+open SELF,$0;
+while(<SELF>) {
+	next if (/^#!/);
+	last if (!s/^#/\/\// and !/^$/);
+	print;
+}
+close SELF;
+
+$output=pop and open STDOUT,">$output";
+print $code;
+close STDOUT;
+
diff --git a/lib/zinc/poly1305/poly1305.c b/lib/zinc/poly1305/poly1305.c
index 5cfe4a32514f..48e8f75c52da 100644
--- a/lib/zinc/poly1305/poly1305.c
+++ b/lib/zinc/poly1305/poly1305.c
@@ -20,6 +20,8 @@
 #include "poly1305-x86_64-glue.c"
 #elif defined(CONFIG_ZINC_ARCH_ARM) || defined(CONFIG_ZINC_ARCH_ARM64)
 #include "poly1305-arm-glue.c"
+#elif defined(CONFIG_ZINC_ARCH_MIPS) || defined(CONFIG_ZINC_ARCH_MIPS64)
+#include "poly1305-mips-glue.c"
 #else
 static inline bool poly1305_init_arch(void *ctx,
 				      const u8 key[POLY1305_KEY_SIZE])
-- 
2.21.0
