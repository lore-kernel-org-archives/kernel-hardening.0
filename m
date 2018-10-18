From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next v8 14/28] zinc: import Andy Polyakov's Poly1305 ARM and ARM64 implementations
Date: Thu, 18 Oct 2018 16:56:58 +0200
Message-Id: <20181018145712.7538-15-Jason@zx2c4.com>
In-Reply-To: <20181018145712.7538-1-Jason@zx2c4.com>
References: <20181018145712.7538-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-crypto@vger.kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Andy Polyakov <appro@openssl.org>, Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, Samuel Neves <sneves@dei.uc.pt>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

These NEON and non-NEON implementations come from Andy Polyakov's
implementation, and are included here in raw form without modification,
so that subsequent commits that fix these up for the kernel can see how
it has changed.

While this is CRYPTOGAMS code, the originating code for this happens to
be the same as OpenSSL's commit 5bb1cd2292b388263a0cc05392bb99141212aa53

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Based-on-code-from: Andy Polyakov <appro@openssl.org>
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
 lib/zinc/poly1305/poly1305-arm-cryptogams.S   | 1172 +++++++++++++++++
 lib/zinc/poly1305/poly1305-arm64-cryptogams.S |  869 ++++++++++++
 2 files changed, 2041 insertions(+)
 create mode 100644 lib/zinc/poly1305/poly1305-arm-cryptogams.S
 create mode 100644 lib/zinc/poly1305/poly1305-arm64-cryptogams.S

diff --git a/lib/zinc/poly1305/poly1305-arm-cryptogams.S b/lib/zinc/poly1305/poly1305-arm-cryptogams.S
new file mode 100644
index 000000000000..884b465030e4
--- /dev/null
+++ b/lib/zinc/poly1305/poly1305-arm-cryptogams.S
@@ -0,0 +1,1172 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/*
+ * Copyright (C) 2006-2017 CRYPTOGAMS by <appro@openssl.org>. All Rights Reserved.
+ */
+
+#include "arm_arch.h"
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
+	cmp	r1,#0
+	str	r3,[r0,#0]		@ zero hash value
+	str	r3,[r0,#4]
+	str	r3,[r0,#8]
+	str	r3,[r0,#12]
+	str	r3,[r0,#16]
+	str	r3,[r0,#36]		@ is_base2_26
+	add	r0,r0,#20
+
+#ifdef	__thumb2__
+	it	eq
+#endif
+	moveq	r0,#0
+	beq	.Lno_key
+
+#if	__ARM_MAX_ARCH__>=7
+	adr	r11,.Lpoly1305_init
+	ldr	r12,.LOPENSSL_armcap
+#endif
+	ldrb	r4,[r1,#0]
+	mov	r10,#0x0fffffff
+	ldrb	r5,[r1,#1]
+	and	r3,r10,#-4		@ 0x0ffffffc
+	ldrb	r6,[r1,#2]
+	ldrb	r7,[r1,#3]
+	orr	r4,r4,r5,lsl#8
+	ldrb	r5,[r1,#4]
+	orr	r4,r4,r6,lsl#16
+	ldrb	r6,[r1,#5]
+	orr	r4,r4,r7,lsl#24
+	ldrb	r7,[r1,#6]
+	and	r4,r4,r10
+
+#if	__ARM_MAX_ARCH__>=7
+	ldr	r12,[r11,r12]		@ OPENSSL_armcap_P
+# ifdef	__APPLE__
+	ldr	r12,[r12]
+# endif
+#endif
+	ldrb	r8,[r1,#7]
+	orr	r5,r5,r6,lsl#8
+	ldrb	r6,[r1,#8]
+	orr	r5,r5,r7,lsl#16
+	ldrb	r7,[r1,#9]
+	orr	r5,r5,r8,lsl#24
+	ldrb	r8,[r1,#10]
+	and	r5,r5,r3
+
+#if	__ARM_MAX_ARCH__>=7
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
+	ldrb	r9,[r1,#11]
+	orr	r6,r6,r7,lsl#8
+	ldrb	r7,[r1,#12]
+	orr	r6,r6,r8,lsl#16
+	ldrb	r8,[r1,#13]
+	orr	r6,r6,r9,lsl#24
+	ldrb	r9,[r1,#14]
+	and	r6,r6,r3
+
+	ldrb	r10,[r1,#15]
+	orr	r7,r7,r8,lsl#8
+	str	r4,[r0,#0]
+	orr	r7,r7,r9,lsl#16
+	str	r5,[r0,#4]
+	orr	r7,r7,r10,lsl#24
+	str	r6,[r0,#8]
+	and	r7,r7,r3
+	str	r7,[r0,#12]
+#if	__ARM_MAX_ARCH__>=7
+	stmia	r2,{r11,r12}		@ fill functions table
+	mov	r0,#1
+#else
+	mov	r0,#0
+#endif
+.Lno_key:
+	ldmia	sp!,{r4-r11}
+#if	__ARM_ARCH__>=5
+	bx	lr				@ bx	lr
+#else
+	tst	lr,#1
+	moveq	pc,lr			@ be binary compatible with V4, yet
+	.word	0xe12fff1e			@ interoperable with Thumb ISA:-)
+#endif
+.size	poly1305_init,.-poly1305_init
+.type	poly1305_blocks,%function
+.align	5
+poly1305_blocks:
+.Lpoly1305_blocks:
+	stmdb	sp!,{r3-r11,lr}
+
+	ands	r2,r2,#-16
+	beq	.Lno_data
+
+	cmp	r3,#0
+	add	r2,r2,r1		@ end pointer
+	sub	sp,sp,#32
+
+	ldmia	r0,{r4-r12}		@ load context
+
+	str	r0,[sp,#12]		@ offload stuff
+	mov	lr,r1
+	str	r2,[sp,#16]
+	str	r10,[sp,#20]
+	str	r11,[sp,#24]
+	str	r12,[sp,#28]
+	b	.Loop
+
+.Loop:
+#if __ARM_ARCH__<7
+	ldrb	r0,[lr],#16		@ load input
+# ifdef	__thumb2__
+	it	hi
+# endif
+	addhi	r8,r8,#1		@ 1<<128
+	ldrb	r1,[lr,#-15]
+	ldrb	r2,[lr,#-14]
+	ldrb	r3,[lr,#-13]
+	orr	r1,r0,r1,lsl#8
+	ldrb	r0,[lr,#-12]
+	orr	r2,r1,r2,lsl#16
+	ldrb	r1,[lr,#-11]
+	orr	r3,r2,r3,lsl#24
+	ldrb	r2,[lr,#-10]
+	adds	r4,r4,r3		@ accumulate input
+
+	ldrb	r3,[lr,#-9]
+	orr	r1,r0,r1,lsl#8
+	ldrb	r0,[lr,#-8]
+	orr	r2,r1,r2,lsl#16
+	ldrb	r1,[lr,#-7]
+	orr	r3,r2,r3,lsl#24
+	ldrb	r2,[lr,#-6]
+	adcs	r5,r5,r3
+
+	ldrb	r3,[lr,#-5]
+	orr	r1,r0,r1,lsl#8
+	ldrb	r0,[lr,#-4]
+	orr	r2,r1,r2,lsl#16
+	ldrb	r1,[lr,#-3]
+	orr	r3,r2,r3,lsl#24
+	ldrb	r2,[lr,#-2]
+	adcs	r6,r6,r3
+
+	ldrb	r3,[lr,#-1]
+	orr	r1,r0,r1,lsl#8
+	str	lr,[sp,#8]		@ offload input pointer
+	orr	r2,r1,r2,lsl#16
+	add	r10,r10,r10,lsr#2
+	orr	r3,r2,r3,lsl#24
+#else
+	ldr	r0,[lr],#16		@ load input
+# ifdef	__thumb2__
+	it	hi
+# endif
+	addhi	r8,r8,#1		@ padbit
+	ldr	r1,[lr,#-12]
+	ldr	r2,[lr,#-8]
+	ldr	r3,[lr,#-4]
+# ifdef	__ARMEB__
+	rev	r0,r0
+	rev	r1,r1
+	rev	r2,r2
+	rev	r3,r3
+# endif
+	adds	r4,r4,r0		@ accumulate input
+	str	lr,[sp,#8]		@ offload input pointer
+	adcs	r5,r5,r1
+	add	r10,r10,r10,lsr#2
+	adcs	r6,r6,r2
+#endif
+	add	r11,r11,r11,lsr#2
+	adcs	r7,r7,r3
+	add	r12,r12,r12,lsr#2
+
+	umull	r2,r3,r5,r9
+	 adc	r8,r8,#0
+	umull	r0,r1,r4,r9
+	umlal	r2,r3,r8,r10
+	umlal	r0,r1,r7,r10
+	ldr	r10,[sp,#20]		@ reload r10
+	umlal	r2,r3,r6,r12
+	umlal	r0,r1,r5,r12
+	umlal	r2,r3,r7,r11
+	umlal	r0,r1,r6,r11
+	umlal	r2,r3,r4,r10
+	str	r0,[sp,#0]		@ future r4
+	 mul	r0,r11,r8
+	ldr	r11,[sp,#24]		@ reload r11
+	adds	r2,r2,r1		@ d1+=d0>>32
+	 eor	r1,r1,r1
+	adc	lr,r3,#0		@ future r6
+	str	r2,[sp,#4]		@ future r5
+
+	mul	r2,r12,r8
+	eor	r3,r3,r3
+	umlal	r0,r1,r7,r12
+	ldr	r12,[sp,#28]		@ reload r12
+	umlal	r2,r3,r7,r9
+	umlal	r0,r1,r6,r9
+	umlal	r2,r3,r6,r10
+	umlal	r0,r1,r5,r10
+	umlal	r2,r3,r5,r11
+	umlal	r0,r1,r4,r11
+	umlal	r2,r3,r4,r12
+	ldr	r4,[sp,#0]
+	mul	r8,r9,r8
+	ldr	r5,[sp,#4]
+
+	adds	r6,lr,r0		@ d2+=d1>>32
+	ldr	lr,[sp,#8]		@ reload input pointer
+	adc	r1,r1,#0
+	adds	r7,r2,r1		@ d3+=d2>>32
+	ldr	r0,[sp,#16]		@ reload end pointer
+	adc	r3,r3,#0
+	add	r8,r8,r3		@ h4+=d3>>32
+
+	and	r1,r8,#-4
+	and	r8,r8,#3
+	add	r1,r1,r1,lsr#2		@ *=5
+	adds	r4,r4,r1
+	adcs	r5,r5,#0
+	adcs	r6,r6,#0
+	adcs	r7,r7,#0
+	adc	r8,r8,#0
+
+	cmp	r0,lr			@ done yet?
+	bhi	.Loop
+
+	ldr	r0,[sp,#12]
+	add	sp,sp,#32
+	stmia	r0,{r4-r8}		@ store the result
+
+.Lno_data:
+#if	__ARM_ARCH__>=5
+	ldmia	sp!,{r3-r11,pc}
+#else
+	ldmia	sp!,{r3-r11,lr}
+	tst	lr,#1
+	moveq	pc,lr			@ be binary compatible with V4, yet
+	.word	0xe12fff1e			@ interoperable with Thumb ISA:-)
+#endif
+.size	poly1305_blocks,.-poly1305_blocks
+.type	poly1305_emit,%function
+.align	5
+poly1305_emit:
+	stmdb	sp!,{r4-r11}
+.Lpoly1305_emit_enter:
+
+	ldmia	r0,{r3-r7}
+	adds	r8,r3,#5		@ compare to modulus
+	adcs	r9,r4,#0
+	adcs	r10,r5,#0
+	adcs	r11,r6,#0
+	adc	r7,r7,#0
+	tst	r7,#4			@ did it carry/borrow?
+
+#ifdef	__thumb2__
+	it	ne
+#endif
+	movne	r3,r8
+	ldr	r8,[r2,#0]
+#ifdef	__thumb2__
+	it	ne
+#endif
+	movne	r4,r9
+	ldr	r9,[r2,#4]
+#ifdef	__thumb2__
+	it	ne
+#endif
+	movne	r5,r10
+	ldr	r10,[r2,#8]
+#ifdef	__thumb2__
+	it	ne
+#endif
+	movne	r6,r11
+	ldr	r11,[r2,#12]
+
+	adds	r3,r3,r8
+	adcs	r4,r4,r9
+	adcs	r5,r5,r10
+	adc	r6,r6,r11
+
+#if __ARM_ARCH__>=7
+# ifdef __ARMEB__
+	rev	r3,r3
+	rev	r4,r4
+	rev	r5,r5
+	rev	r6,r6
+# endif
+	str	r3,[r1,#0]
+	str	r4,[r1,#4]
+	str	r5,[r1,#8]
+	str	r6,[r1,#12]
+#else
+	strb	r3,[r1,#0]
+	mov	r3,r3,lsr#8
+	strb	r4,[r1,#4]
+	mov	r4,r4,lsr#8
+	strb	r5,[r1,#8]
+	mov	r5,r5,lsr#8
+	strb	r6,[r1,#12]
+	mov	r6,r6,lsr#8
+
+	strb	r3,[r1,#1]
+	mov	r3,r3,lsr#8
+	strb	r4,[r1,#5]
+	mov	r4,r4,lsr#8
+	strb	r5,[r1,#9]
+	mov	r5,r5,lsr#8
+	strb	r6,[r1,#13]
+	mov	r6,r6,lsr#8
+
+	strb	r3,[r1,#2]
+	mov	r3,r3,lsr#8
+	strb	r4,[r1,#6]
+	mov	r4,r4,lsr#8
+	strb	r5,[r1,#10]
+	mov	r5,r5,lsr#8
+	strb	r6,[r1,#14]
+	mov	r6,r6,lsr#8
+
+	strb	r3,[r1,#3]
+	strb	r4,[r1,#7]
+	strb	r5,[r1,#11]
+	strb	r6,[r1,#15]
+#endif
+	ldmia	sp!,{r4-r11}
+#if	__ARM_ARCH__>=5
+	bx	lr				@ bx	lr
+#else
+	tst	lr,#1
+	moveq	pc,lr			@ be binary compatible with V4, yet
+	.word	0xe12fff1e			@ interoperable with Thumb ISA:-)
+#endif
+.size	poly1305_emit,.-poly1305_emit
+#if	__ARM_MAX_ARCH__>=7
+.fpu	neon
+
+.type	poly1305_init_neon,%function
+.align	5
+poly1305_init_neon:
+	ldr	r4,[r0,#20]		@ load key base 2^32
+	ldr	r5,[r0,#24]
+	ldr	r6,[r0,#28]
+	ldr	r7,[r0,#32]
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
+	vdup.32	d0,r2			@ r^1 in both lanes
+	add	r2,r3,r3,lsl#2		@ *5
+	vdup.32	d1,r3
+	add	r3,r4,r4,lsl#2
+	vdup.32	d2,r2
+	vdup.32	d3,r4
+	add	r4,r5,r5,lsl#2
+	vdup.32	d4,r3
+	vdup.32	d5,r5
+	add	r5,r6,r6,lsl#2
+	vdup.32	d6,r4
+	vdup.32	d7,r6
+	vdup.32	d8,r5
+
+	mov	r5,#2		@ counter
+
+.Lsquare_neon:
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ d0 = h0*r0 + h4*5*r1 + h3*5*r2 + h2*5*r3 + h1*5*r4
+	@ d1 = h1*r0 + h0*r1   + h4*5*r2 + h3*5*r3 + h2*5*r4
+	@ d2 = h2*r0 + h1*r1   + h0*r2   + h4*5*r3 + h3*5*r4
+	@ d3 = h3*r0 + h2*r1   + h1*r2   + h0*r3   + h4*5*r4
+	@ d4 = h4*r0 + h3*r1   + h2*r2   + h1*r3   + h0*r4
+
+	vmull.u32	q5,d0,d0[1]
+	vmull.u32	q6,d1,d0[1]
+	vmull.u32	q7,d3,d0[1]
+	vmull.u32	q8,d5,d0[1]
+	vmull.u32	q9,d7,d0[1]
+
+	vmlal.u32	q5,d7,d2[1]
+	vmlal.u32	q6,d0,d1[1]
+	vmlal.u32	q7,d1,d1[1]
+	vmlal.u32	q8,d3,d1[1]
+	vmlal.u32	q9,d5,d1[1]
+
+	vmlal.u32	q5,d5,d4[1]
+	vmlal.u32	q6,d7,d4[1]
+	vmlal.u32	q8,d1,d3[1]
+	vmlal.u32	q7,d0,d3[1]
+	vmlal.u32	q9,d3,d3[1]
+
+	vmlal.u32	q5,d3,d6[1]
+	vmlal.u32	q8,d0,d5[1]
+	vmlal.u32	q6,d5,d6[1]
+	vmlal.u32	q7,d7,d6[1]
+	vmlal.u32	q9,d1,d5[1]
+
+	vmlal.u32	q8,d7,d8[1]
+	vmlal.u32	q5,d1,d8[1]
+	vmlal.u32	q6,d3,d8[1]
+	vmlal.u32	q7,d5,d8[1]
+	vmlal.u32	q9,d0,d7[1]
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
+	vshr.u64	q15,q8,#26
+	vmovn.i64	d16,q8
+	 vshr.u64	q4,q5,#26
+	 vmovn.i64	d10,q5
+	vadd.i64	q9,q9,q15		@ h3 -> h4
+	vbic.i32	d16,#0xfc000000	@ &=0x03ffffff
+	 vadd.i64	q6,q6,q4		@ h0 -> h1
+	 vbic.i32	d10,#0xfc000000
+
+	vshrn.u64	d30,q9,#26
+	vmovn.i64	d18,q9
+	 vshr.u64	q4,q6,#26
+	 vmovn.i64	d12,q6
+	 vadd.i64	q7,q7,q4		@ h1 -> h2
+	vbic.i32	d18,#0xfc000000
+	 vbic.i32	d12,#0xfc000000
+
+	vadd.i32	d10,d10,d30
+	vshl.u32	d30,d30,#2
+	 vshrn.u64	d8,q7,#26
+	 vmovn.i64	d14,q7
+	vadd.i32	d10,d10,d30	@ h4 -> h0
+	 vadd.i32	d16,d16,d8	@ h2 -> h3
+	 vbic.i32	d14,#0xfc000000
+
+	vshr.u32	d30,d10,#26
+	vbic.i32	d10,#0xfc000000
+	 vshr.u32	d8,d16,#26
+	 vbic.i32	d16,#0xfc000000
+	vadd.i32	d12,d12,d30	@ h0 -> h1
+	 vadd.i32	d18,d18,d8	@ h3 -> h4
+
+	subs		r5,r5,#1
+	beq		.Lsquare_break_neon
+
+	add		r6,r0,#(48+0*9*4)
+	add		r7,r0,#(48+1*9*4)
+
+	vtrn.32		d0,d10		@ r^2:r^1
+	vtrn.32		d3,d14
+	vtrn.32		d5,d16
+	vtrn.32		d1,d12
+	vtrn.32		d7,d18
+
+	vshl.u32	d4,d3,#2		@ *5
+	vshl.u32	d6,d5,#2
+	vshl.u32	d2,d1,#2
+	vshl.u32	d8,d7,#2
+	vadd.i32	d4,d4,d3
+	vadd.i32	d2,d2,d1
+	vadd.i32	d6,d6,d5
+	vadd.i32	d8,d8,d7
+
+	vst4.32		{d0[0],d1[0],d2[0],d3[0]},[r6]!
+	vst4.32		{d0[1],d1[1],d2[1],d3[1]},[r7]!
+	vst4.32		{d4[0],d5[0],d6[0],d7[0]},[r6]!
+	vst4.32		{d4[1],d5[1],d6[1],d7[1]},[r7]!
+	vst1.32		{d8[0]},[r6,:32]
+	vst1.32		{d8[1]},[r7,:32]
+
+	b		.Lsquare_neon
+
+.align	4
+.Lsquare_break_neon:
+	add		r6,r0,#(48+2*4*9)
+	add		r7,r0,#(48+3*4*9)
+
+	vmov		d0,d10		@ r^4:r^3
+	vshl.u32	d2,d12,#2		@ *5
+	vmov		d1,d12
+	vshl.u32	d4,d14,#2
+	vmov		d3,d14
+	vshl.u32	d6,d16,#2
+	vmov		d5,d16
+	vshl.u32	d8,d18,#2
+	vmov		d7,d18
+	vadd.i32	d2,d2,d12
+	vadd.i32	d4,d4,d14
+	vadd.i32	d6,d6,d16
+	vadd.i32	d8,d8,d18
+
+	vst4.32		{d0[0],d1[0],d2[0],d3[0]},[r6]!
+	vst4.32		{d0[1],d1[1],d2[1],d3[1]},[r7]!
+	vst4.32		{d4[0],d5[0],d6[0],d7[0]},[r6]!
+	vst4.32		{d4[1],d5[1],d6[1],d7[1]},[r7]!
+	vst1.32		{d8[0]},[r6]
+	vst1.32		{d8[1]},[r7]
+
+	bx	lr				@ bx	lr
+.size	poly1305_init_neon,.-poly1305_init_neon
+
+.type	poly1305_blocks_neon,%function
+.align	5
+poly1305_blocks_neon:
+	ldr	ip,[r0,#36]		@ is_base2_26
+	ands	r2,r2,#-16
+	beq	.Lno_data_neon
+
+	cmp	r2,#64
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
+	bl	poly1305_init_neon
+
+	ldr	r4,[r0,#0]		@ load hash value base 2^32
+	ldr	r5,[r0,#4]
+	ldr	r6,[r0,#8]
+	ldr	r7,[r0,#12]
+	ldr	ip,[r0,#16]
+
+	and	r2,r4,#0x03ffffff	@ base 2^32 -> base 2^26
+	mov	r3,r4,lsr#26
+	 veor	d10,d10,d10
+	mov	r4,r5,lsr#20
+	orr	r3,r3,r5,lsl#6
+	 veor	d12,d12,d12
+	mov	r5,r6,lsr#14
+	orr	r4,r4,r6,lsl#12
+	 veor	d14,d14,d14
+	mov	r6,r7,lsr#8
+	orr	r5,r5,r7,lsl#18
+	 veor	d16,d16,d16
+	and	r3,r3,#0x03ffffff
+	orr	r6,r6,ip,lsl#24
+	 veor	d18,d18,d18
+	and	r4,r4,#0x03ffffff
+	mov	r1,#1
+	and	r5,r5,#0x03ffffff
+	str	r1,[r0,#36]		@ is_base2_26
+
+	vmov.32	d10[0],r2
+	vmov.32	d12[0],r3
+	vmov.32	d14[0],r4
+	vmov.32	d16[0],r5
+	vmov.32	d18[0],r6
+	adr	r5,.Lzeros
+
+	ldmia	sp!,{r1-r3,lr}
+	b	.Lbase2_32_neon
+
+.align	4
+.Lbase2_26_neon:
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ load hash value
+
+	veor		d10,d10,d10
+	veor		d12,d12,d12
+	veor		d14,d14,d14
+	veor		d16,d16,d16
+	veor		d18,d18,d18
+	vld4.32		{d10[0],d12[0],d14[0],d16[0]},[r0]!
+	adr		r5,.Lzeros
+	vld1.32		{d18[0]},[r0]
+	sub		r0,r0,#16		@ rewind
+
+.Lbase2_32_neon:
+	add		r4,r1,#32
+	mov		r3,r3,lsl#24
+	tst		r2,#31
+	beq		.Leven
+
+	vld4.32		{d20[0],d22[0],d24[0],d26[0]},[r1]!
+	vmov.32		d28[0],r3
+	sub		r2,r2,#16
+	add		r4,r1,#32
+
+# ifdef	__ARMEB__
+	vrev32.8	q10,q10
+	vrev32.8	q13,q13
+	vrev32.8	q11,q11
+	vrev32.8	q12,q12
+# endif
+	vsri.u32	d28,d26,#8	@ base 2^32 -> base 2^26
+	vshl.u32	d26,d26,#18
+
+	vsri.u32	d26,d24,#14
+	vshl.u32	d24,d24,#12
+	vadd.i32	d29,d28,d18	@ add hash value and move to #hi
+
+	vbic.i32	d26,#0xfc000000
+	vsri.u32	d24,d22,#20
+	vshl.u32	d22,d22,#6
+
+	vbic.i32	d24,#0xfc000000
+	vsri.u32	d22,d20,#26
+	vadd.i32	d27,d26,d16
+
+	vbic.i32	d20,#0xfc000000
+	vbic.i32	d22,#0xfc000000
+	vadd.i32	d25,d24,d14
+
+	vadd.i32	d21,d20,d10
+	vadd.i32	d23,d22,d12
+
+	mov		r7,r5
+	add		r6,r0,#48
+
+	cmp		r2,r2
+	b		.Long_tail
+
+.align	4
+.Leven:
+	subs		r2,r2,#64
+	it		lo
+	movlo		r4,r5
+
+	vmov.i32	q14,#1<<24		@ padbit, yes, always
+	vld4.32		{d20,d22,d24,d26},[r1]	@ inp[0:1]
+	add		r1,r1,#64
+	vld4.32		{d21,d23,d25,d27},[r4]	@ inp[2:3] (or 0)
+	add		r4,r4,#64
+	itt		hi
+	addhi		r7,r0,#(48+1*9*4)
+	addhi		r6,r0,#(48+3*9*4)
+
+# ifdef	__ARMEB__
+	vrev32.8	q10,q10
+	vrev32.8	q13,q13
+	vrev32.8	q11,q11
+	vrev32.8	q12,q12
+# endif
+	vsri.u32	q14,q13,#8		@ base 2^32 -> base 2^26
+	vshl.u32	q13,q13,#18
+
+	vsri.u32	q13,q12,#14
+	vshl.u32	q12,q12,#12
+
+	vbic.i32	q13,#0xfc000000
+	vsri.u32	q12,q11,#20
+	vshl.u32	q11,q11,#6
+
+	vbic.i32	q12,#0xfc000000
+	vsri.u32	q11,q10,#26
+
+	vbic.i32	q10,#0xfc000000
+	vbic.i32	q11,#0xfc000000
+
+	bls		.Lskip_loop
+
+	vld4.32		{d0[1],d1[1],d2[1],d3[1]},[r7]!	@ load r^2
+	vld4.32		{d0[0],d1[0],d2[0],d3[0]},[r6]!	@ load r^4
+	vld4.32		{d4[1],d5[1],d6[1],d7[1]},[r7]!
+	vld4.32		{d4[0],d5[0],d6[0],d7[0]},[r6]!
+	b		.Loop_neon
+
+.align	5
+.Loop_neon:
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ ((inp[0]*r^4+inp[2]*r^2+inp[4])*r^4+inp[6]*r^2
+	@ ((inp[1]*r^4+inp[3]*r^2+inp[5])*r^3+inp[7]*r
+	@   ___________________/
+	@ ((inp[0]*r^4+inp[2]*r^2+inp[4])*r^4+inp[6]*r^2+inp[8])*r^2
+	@ ((inp[1]*r^4+inp[3]*r^2+inp[5])*r^4+inp[7]*r^2+inp[9])*r
+	@   ___________________/ ____________________/
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
+	vadd.i32	d24,d24,d14	@ accumulate inp[0:1]
+	vmull.u32	q7,d25,d0[1]
+	vadd.i32	d20,d20,d10
+	vmull.u32	q5,d21,d0[1]
+	vadd.i32	d26,d26,d16
+	vmull.u32	q8,d27,d0[1]
+	vmlal.u32	q7,d23,d1[1]
+	vadd.i32	d22,d22,d12
+	vmull.u32	q6,d23,d0[1]
+
+	vadd.i32	d28,d28,d18
+	vmull.u32	q9,d29,d0[1]
+	subs		r2,r2,#64
+	vmlal.u32	q5,d29,d2[1]
+	it		lo
+	movlo		r4,r5
+	vmlal.u32	q8,d25,d1[1]
+	vld1.32		d8[1],[r7,:32]
+	vmlal.u32	q6,d21,d1[1]
+	vmlal.u32	q9,d27,d1[1]
+
+	vmlal.u32	q5,d27,d4[1]
+	vmlal.u32	q8,d23,d3[1]
+	vmlal.u32	q9,d25,d3[1]
+	vmlal.u32	q6,d29,d4[1]
+	vmlal.u32	q7,d21,d3[1]
+
+	vmlal.u32	q8,d21,d5[1]
+	vmlal.u32	q5,d25,d6[1]
+	vmlal.u32	q9,d23,d5[1]
+	vmlal.u32	q6,d27,d6[1]
+	vmlal.u32	q7,d29,d6[1]
+
+	vmlal.u32	q8,d29,d8[1]
+	vmlal.u32	q5,d23,d8[1]
+	vmlal.u32	q9,d21,d7[1]
+	vmlal.u32	q6,d25,d8[1]
+	vmlal.u32	q7,d27,d8[1]
+
+	vld4.32		{d21,d23,d25,d27},[r4]	@ inp[2:3] (or 0)
+	add		r4,r4,#64
+
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ (hash+inp[0:1])*r^4 and accumulate
+
+	vmlal.u32	q8,d26,d0[0]
+	vmlal.u32	q5,d20,d0[0]
+	vmlal.u32	q9,d28,d0[0]
+	vmlal.u32	q6,d22,d0[0]
+	vmlal.u32	q7,d24,d0[0]
+	vld1.32		d8[0],[r6,:32]
+
+	vmlal.u32	q8,d24,d1[0]
+	vmlal.u32	q5,d28,d2[0]
+	vmlal.u32	q9,d26,d1[0]
+	vmlal.u32	q6,d20,d1[0]
+	vmlal.u32	q7,d22,d1[0]
+
+	vmlal.u32	q8,d22,d3[0]
+	vmlal.u32	q5,d26,d4[0]
+	vmlal.u32	q9,d24,d3[0]
+	vmlal.u32	q6,d28,d4[0]
+	vmlal.u32	q7,d20,d3[0]
+
+	vmlal.u32	q8,d20,d5[0]
+	vmlal.u32	q5,d24,d6[0]
+	vmlal.u32	q9,d22,d5[0]
+	vmlal.u32	q6,d26,d6[0]
+	vmlal.u32	q8,d28,d8[0]
+
+	vmlal.u32	q7,d28,d6[0]
+	vmlal.u32	q5,d22,d8[0]
+	vmlal.u32	q9,d20,d7[0]
+	vmov.i32	q14,#1<<24		@ padbit, yes, always
+	vmlal.u32	q6,d24,d8[0]
+	vmlal.u32	q7,d26,d8[0]
+
+	vld4.32		{d20,d22,d24,d26},[r1]	@ inp[0:1]
+	add		r1,r1,#64
+# ifdef	__ARMEB__
+	vrev32.8	q10,q10
+	vrev32.8	q11,q11
+	vrev32.8	q12,q12
+	vrev32.8	q13,q13
+# endif
+
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ lazy reduction interleaved with base 2^32 -> base 2^26 of
+	@ inp[0:3] previously loaded to q10-q13 and smashed to q10-q14.
+
+	vshr.u64	q15,q8,#26
+	vmovn.i64	d16,q8
+	 vshr.u64	q4,q5,#26
+	 vmovn.i64	d10,q5
+	vadd.i64	q9,q9,q15		@ h3 -> h4
+	vbic.i32	d16,#0xfc000000
+	  vsri.u32	q14,q13,#8		@ base 2^32 -> base 2^26
+	 vadd.i64	q6,q6,q4		@ h0 -> h1
+	  vshl.u32	q13,q13,#18
+	 vbic.i32	d10,#0xfc000000
+
+	vshrn.u64	d30,q9,#26
+	vmovn.i64	d18,q9
+	 vshr.u64	q4,q6,#26
+	 vmovn.i64	d12,q6
+	 vadd.i64	q7,q7,q4		@ h1 -> h2
+	  vsri.u32	q13,q12,#14
+	vbic.i32	d18,#0xfc000000
+	  vshl.u32	q12,q12,#12
+	 vbic.i32	d12,#0xfc000000
+
+	vadd.i32	d10,d10,d30
+	vshl.u32	d30,d30,#2
+	  vbic.i32	q13,#0xfc000000
+	 vshrn.u64	d8,q7,#26
+	 vmovn.i64	d14,q7
+	vaddl.u32	q5,d10,d30	@ h4 -> h0 [widen for a sec]
+	  vsri.u32	q12,q11,#20
+	 vadd.i32	d16,d16,d8	@ h2 -> h3
+	  vshl.u32	q11,q11,#6
+	 vbic.i32	d14,#0xfc000000
+	  vbic.i32	q12,#0xfc000000
+
+	vshrn.u64	d30,q5,#26		@ re-narrow
+	vmovn.i64	d10,q5
+	  vsri.u32	q11,q10,#26
+	  vbic.i32	q10,#0xfc000000
+	 vshr.u32	d8,d16,#26
+	 vbic.i32	d16,#0xfc000000
+	vbic.i32	d10,#0xfc000000
+	vadd.i32	d12,d12,d30	@ h0 -> h1
+	 vadd.i32	d18,d18,d8	@ h3 -> h4
+	  vbic.i32	q11,#0xfc000000
+
+	bhi		.Loop_neon
+
+.Lskip_loop:
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ multiply (inp[0:1]+hash) or inp[2:3] by r^2:r^1
+
+	add		r7,r0,#(48+0*9*4)
+	add		r6,r0,#(48+1*9*4)
+	adds		r2,r2,#32
+	it		ne
+	movne		r2,#0
+	bne		.Long_tail
+
+	vadd.i32	d25,d24,d14	@ add hash value and move to #hi
+	vadd.i32	d21,d20,d10
+	vadd.i32	d27,d26,d16
+	vadd.i32	d23,d22,d12
+	vadd.i32	d29,d28,d18
+
+.Long_tail:
+	vld4.32		{d0[1],d1[1],d2[1],d3[1]},[r7]!	@ load r^1
+	vld4.32		{d0[0],d1[0],d2[0],d3[0]},[r6]!	@ load r^2
+
+	vadd.i32	d24,d24,d14	@ can be redundant
+	vmull.u32	q7,d25,d0
+	vadd.i32	d20,d20,d10
+	vmull.u32	q5,d21,d0
+	vadd.i32	d26,d26,d16
+	vmull.u32	q8,d27,d0
+	vadd.i32	d22,d22,d12
+	vmull.u32	q6,d23,d0
+	vadd.i32	d28,d28,d18
+	vmull.u32	q9,d29,d0
+
+	vmlal.u32	q5,d29,d2
+	vld4.32		{d4[1],d5[1],d6[1],d7[1]},[r7]!
+	vmlal.u32	q8,d25,d1
+	vld4.32		{d4[0],d5[0],d6[0],d7[0]},[r6]!
+	vmlal.u32	q6,d21,d1
+	vmlal.u32	q9,d27,d1
+	vmlal.u32	q7,d23,d1
+
+	vmlal.u32	q8,d23,d3
+	vld1.32		d8[1],[r7,:32]
+	vmlal.u32	q5,d27,d4
+	vld1.32		d8[0],[r6,:32]
+	vmlal.u32	q9,d25,d3
+	vmlal.u32	q6,d29,d4
+	vmlal.u32	q7,d21,d3
+
+	vmlal.u32	q8,d21,d5
+	 it		ne
+	 addne		r7,r0,#(48+2*9*4)
+	vmlal.u32	q5,d25,d6
+	 it		ne
+	 addne		r6,r0,#(48+3*9*4)
+	vmlal.u32	q9,d23,d5
+	vmlal.u32	q6,d27,d6
+	vmlal.u32	q7,d29,d6
+
+	vmlal.u32	q8,d29,d8
+	 vorn		q0,q0,q0	@ all-ones, can be redundant
+	vmlal.u32	q5,d23,d8
+	 vshr.u64	q0,q0,#38
+	vmlal.u32	q9,d21,d7
+	vmlal.u32	q6,d25,d8
+	vmlal.u32	q7,d27,d8
+
+	beq		.Lshort_tail
+
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ (hash+inp[0:1])*r^4:r^3 and accumulate
+
+	vld4.32		{d0[1],d1[1],d2[1],d3[1]},[r7]!	@ load r^3
+	vld4.32		{d0[0],d1[0],d2[0],d3[0]},[r6]!	@ load r^4
+
+	vmlal.u32	q7,d24,d0
+	vmlal.u32	q5,d20,d0
+	vmlal.u32	q8,d26,d0
+	vmlal.u32	q6,d22,d0
+	vmlal.u32	q9,d28,d0
+
+	vmlal.u32	q5,d28,d2
+	vld4.32		{d4[1],d5[1],d6[1],d7[1]},[r7]!
+	vmlal.u32	q8,d24,d1
+	vld4.32		{d4[0],d5[0],d6[0],d7[0]},[r6]!
+	vmlal.u32	q6,d20,d1
+	vmlal.u32	q9,d26,d1
+	vmlal.u32	q7,d22,d1
+
+	vmlal.u32	q8,d22,d3
+	vld1.32		d8[1],[r7,:32]
+	vmlal.u32	q5,d26,d4
+	vld1.32		d8[0],[r6,:32]
+	vmlal.u32	q9,d24,d3
+	vmlal.u32	q6,d28,d4
+	vmlal.u32	q7,d20,d3
+
+	vmlal.u32	q8,d20,d5
+	vmlal.u32	q5,d24,d6
+	vmlal.u32	q9,d22,d5
+	vmlal.u32	q6,d26,d6
+	vmlal.u32	q7,d28,d6
+
+	vmlal.u32	q8,d28,d8
+	 vorn		q0,q0,q0	@ all-ones
+	vmlal.u32	q5,d22,d8
+	 vshr.u64	q0,q0,#38
+	vmlal.u32	q9,d20,d7
+	vmlal.u32	q6,d24,d8
+	vmlal.u32	q7,d26,d8
+
+.Lshort_tail:
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ horizontal addition
+
+	vadd.i64	d16,d16,d17
+	vadd.i64	d10,d10,d11
+	vadd.i64	d18,d18,d19
+	vadd.i64	d12,d12,d13
+	vadd.i64	d14,d14,d15
+
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ lazy reduction, but without narrowing
+
+	vshr.u64	q15,q8,#26
+	vand.i64	q8,q8,q0
+	 vshr.u64	q4,q5,#26
+	 vand.i64	q5,q5,q0
+	vadd.i64	q9,q9,q15		@ h3 -> h4
+	 vadd.i64	q6,q6,q4		@ h0 -> h1
+
+	vshr.u64	q15,q9,#26
+	vand.i64	q9,q9,q0
+	 vshr.u64	q4,q6,#26
+	 vand.i64	q6,q6,q0
+	 vadd.i64	q7,q7,q4		@ h1 -> h2
+
+	vadd.i64	q5,q5,q15
+	vshl.u64	q15,q15,#2
+	 vshr.u64	q4,q7,#26
+	 vand.i64	q7,q7,q0
+	vadd.i64	q5,q5,q15		@ h4 -> h0
+	 vadd.i64	q8,q8,q4		@ h2 -> h3
+
+	vshr.u64	q15,q5,#26
+	vand.i64	q5,q5,q0
+	 vshr.u64	q4,q8,#26
+	 vand.i64	q8,q8,q0
+	vadd.i64	q6,q6,q15		@ h0 -> h1
+	 vadd.i64	q9,q9,q4		@ h3 -> h4
+
+	cmp		r2,#0
+	bne		.Leven
+
+	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+	@ store hash value
+
+	vst4.32		{d10[0],d12[0],d14[0],d16[0]},[r0]!
+	vst1.32		{d18[0]},[r0]
+
+	vldmia	sp!,{d8-d15}			@ epilogue
+	ldmia	sp!,{r4-r7}
+.Lno_data_neon:
+	bx	lr					@ bx	lr
+.size	poly1305_blocks_neon,.-poly1305_blocks_neon
+
+.type	poly1305_emit_neon,%function
+.align	5
+poly1305_emit_neon:
+	ldr	ip,[r0,#36]		@ is_base2_26
+
+	stmdb	sp!,{r4-r11}
+
+	tst	ip,ip
+	beq	.Lpoly1305_emit_enter
+
+	ldmia	r0,{r3-r7}
+	eor	r8,r8,r8
+
+	adds	r3,r3,r4,lsl#26	@ base 2^26 -> base 2^32
+	mov	r4,r4,lsr#6
+	adcs	r4,r4,r5,lsl#20
+	mov	r5,r5,lsr#12
+	adcs	r5,r5,r6,lsl#14
+	mov	r6,r6,lsr#18
+	adcs	r6,r6,r7,lsl#8
+	adc	r7,r8,r7,lsr#24	@ can be partially reduced ...
+
+	and	r8,r7,#-4		@ ... so reduce
+	and	r7,r6,#3
+	add	r8,r8,r8,lsr#2	@ *= 5
+	adds	r3,r3,r8
+	adcs	r4,r4,#0
+	adcs	r5,r5,#0
+	adcs	r6,r6,#0
+	adc	r7,r7,#0
+
+	adds	r8,r3,#5		@ compare to modulus
+	adcs	r9,r4,#0
+	adcs	r10,r5,#0
+	adcs	r11,r6,#0
+	adc	r7,r7,#0
+	tst	r7,#4			@ did it carry/borrow?
+
+	it	ne
+	movne	r3,r8
+	ldr	r8,[r2,#0]
+	it	ne
+	movne	r4,r9
+	ldr	r9,[r2,#4]
+	it	ne
+	movne	r5,r10
+	ldr	r10,[r2,#8]
+	it	ne
+	movne	r6,r11
+	ldr	r11,[r2,#12]
+
+	adds	r3,r3,r8		@ accumulate nonce
+	adcs	r4,r4,r9
+	adcs	r5,r5,r10
+	adc	r6,r6,r11
+
+# ifdef __ARMEB__
+	rev	r3,r3
+	rev	r4,r4
+	rev	r5,r5
+	rev	r6,r6
+# endif
+	str	r3,[r1,#0]		@ store the result
+	str	r4,[r1,#4]
+	str	r5,[r1,#8]
+	str	r6,[r1,#12]
+
+	ldmia	sp!,{r4-r11}
+	bx	lr				@ bx	lr
+.size	poly1305_emit_neon,.-poly1305_emit_neon
+
+.align	5
+.Lzeros:
+.long	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
+.LOPENSSL_armcap:
+.word	OPENSSL_armcap_P-.Lpoly1305_init
+#endif
+.asciz	"Poly1305 for ARMv4/NEON, CRYPTOGAMS by <appro@openssl.org>"
+.align	2
+#if	__ARM_MAX_ARCH__>=7
+.comm   OPENSSL_armcap_P,4,4
+#endif
diff --git a/lib/zinc/poly1305/poly1305-arm64-cryptogams.S b/lib/zinc/poly1305/poly1305-arm64-cryptogams.S
new file mode 100644
index 000000000000..0ecb50a83ec0
--- /dev/null
+++ b/lib/zinc/poly1305/poly1305-arm64-cryptogams.S
@@ -0,0 +1,869 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/*
+ * Copyright (C) 2006-2017 CRYPTOGAMS by <appro@openssl.org>. All Rights Reserved.
+ */
+
+#include "arm_arch.h"
+
+.text
+
+// forward "declarations" are required for Apple
+
+.globl	poly1305_blocks
+.globl	poly1305_emit
+
+.globl	poly1305_init
+.type	poly1305_init,%function
+.align	5
+poly1305_init:
+	cmp	x1,xzr
+	stp	xzr,xzr,[x0]		// zero hash value
+	stp	xzr,xzr,[x0,#16]	// [along with is_base2_26]
+
+	csel	x0,xzr,x0,eq
+	b.eq	.Lno_key
+
+#ifdef	__ILP32__
+	ldrsw	x11,.LOPENSSL_armcap_P
+#else
+	ldr	x11,.LOPENSSL_armcap_P
+#endif
+	adr	x10,.LOPENSSL_armcap_P
+
+	ldp	x7,x8,[x1]		// load key
+	mov	x9,#0xfffffffc0fffffff
+	movk	x9,#0x0fff,lsl#48
+	ldr	w17,[x10,x11]
+#ifdef	__ARMEB__
+	rev	x7,x7			// flip bytes
+	rev	x8,x8
+#endif
+	and	x7,x7,x9		// &=0ffffffc0fffffff
+	and	x9,x9,#-4
+	and	x8,x8,x9		// &=0ffffffc0ffffffc
+	stp	x7,x8,[x0,#32]	// save key value
+
+	tst	w17,#ARMV7_NEON
+
+	adr	x12,poly1305_blocks
+	adr	x7,poly1305_blocks_neon
+	adr	x13,poly1305_emit
+	adr	x8,poly1305_emit_neon
+
+	csel	x12,x12,x7,eq
+	csel	x13,x13,x8,eq
+
+#ifdef	__ILP32__
+	stp	w12,w13,[x2]
+#else
+	stp	x12,x13,[x2]
+#endif
+
+	mov	x0,#1
+.Lno_key:
+	ret
+.size	poly1305_init,.-poly1305_init
+
+.type	poly1305_blocks,%function
+.align	5
+poly1305_blocks:
+	ands	x2,x2,#-16
+	b.eq	.Lno_data
+
+	ldp	x4,x5,[x0]		// load hash value
+	ldp	x7,x8,[x0,#32]	// load key value
+	ldr	x6,[x0,#16]
+	add	x9,x8,x8,lsr#2	// s1 = r1 + (r1 >> 2)
+	b	.Loop
+
+.align	5
+.Loop:
+	ldp	x10,x11,[x1],#16	// load input
+	sub	x2,x2,#16
+#ifdef	__ARMEB__
+	rev	x10,x10
+	rev	x11,x11
+#endif
+	adds	x4,x4,x10		// accumulate input
+	adcs	x5,x5,x11
+
+	mul	x12,x4,x7		// h0*r0
+	adc	x6,x6,x3
+	umulh	x13,x4,x7
+
+	mul	x10,x5,x9		// h1*5*r1
+	umulh	x11,x5,x9
+
+	adds	x12,x12,x10
+	mul	x10,x4,x8		// h0*r1
+	adc	x13,x13,x11
+	umulh	x14,x4,x8
+
+	adds	x13,x13,x10
+	mul	x10,x5,x7		// h1*r0
+	adc	x14,x14,xzr
+	umulh	x11,x5,x7
+
+	adds	x13,x13,x10
+	mul	x10,x6,x9		// h2*5*r1
+	adc	x14,x14,x11
+	mul	x11,x6,x7		// h2*r0
+
+	adds	x13,x13,x10
+	adc	x14,x14,x11
+
+	and	x10,x14,#-4		// final reduction
+	and	x6,x14,#3
+	add	x10,x10,x14,lsr#2
+	adds	x4,x12,x10
+	adcs	x5,x13,xzr
+	adc	x6,x6,xzr
+
+	cbnz	x2,.Loop
+
+	stp	x4,x5,[x0]		// store hash value
+	str	x6,[x0,#16]
+
+.Lno_data:
+	ret
+.size	poly1305_blocks,.-poly1305_blocks
+
+.type	poly1305_emit,%function
+.align	5
+poly1305_emit:
+	ldp	x4,x5,[x0]		// load hash base 2^64
+	ldr	x6,[x0,#16]
+	ldp	x10,x11,[x2]	// load nonce
+
+	adds	x12,x4,#5		// compare to modulus
+	adcs	x13,x5,xzr
+	adc	x14,x6,xzr
+
+	tst	x14,#-4			// see if it's carried/borrowed
+
+	csel	x4,x4,x12,eq
+	csel	x5,x5,x13,eq
+
+#ifdef	__ARMEB__
+	ror	x10,x10,#32		// flip nonce words
+	ror	x11,x11,#32
+#endif
+	adds	x4,x4,x10		// accumulate nonce
+	adc	x5,x5,x11
+#ifdef	__ARMEB__
+	rev	x4,x4			// flip output bytes
+	rev	x5,x5
+#endif
+	stp	x4,x5,[x1]		// write result
+
+	ret
+.size	poly1305_emit,.-poly1305_emit
+.type	poly1305_mult,%function
+.align	5
+poly1305_mult:
+	mul	x12,x4,x7		// h0*r0
+	umulh	x13,x4,x7
+
+	mul	x10,x5,x9		// h1*5*r1
+	umulh	x11,x5,x9
+
+	adds	x12,x12,x10
+	mul	x10,x4,x8		// h0*r1
+	adc	x13,x13,x11
+	umulh	x14,x4,x8
+
+	adds	x13,x13,x10
+	mul	x10,x5,x7		// h1*r0
+	adc	x14,x14,xzr
+	umulh	x11,x5,x7
+
+	adds	x13,x13,x10
+	mul	x10,x6,x9		// h2*5*r1
+	adc	x14,x14,x11
+	mul	x11,x6,x7		// h2*r0
+
+	adds	x13,x13,x10
+	adc	x14,x14,x11
+
+	and	x10,x14,#-4		// final reduction
+	and	x6,x14,#3
+	add	x10,x10,x14,lsr#2
+	adds	x4,x12,x10
+	adcs	x5,x13,xzr
+	adc	x6,x6,xzr
+
+	ret
+.size	poly1305_mult,.-poly1305_mult
+
+.type	poly1305_splat,%function
+.align	5
+poly1305_splat:
+	and	x12,x4,#0x03ffffff	// base 2^64 -> base 2^26
+	ubfx	x13,x4,#26,#26
+	extr	x14,x5,x4,#52
+	and	x14,x14,#0x03ffffff
+	ubfx	x15,x5,#14,#26
+	extr	x16,x6,x5,#40
+
+	str	w12,[x0,#16*0]	// r0
+	add	w12,w13,w13,lsl#2	// r1*5
+	str	w13,[x0,#16*1]	// r1
+	add	w13,w14,w14,lsl#2	// r2*5
+	str	w12,[x0,#16*2]	// s1
+	str	w14,[x0,#16*3]	// r2
+	add	w14,w15,w15,lsl#2	// r3*5
+	str	w13,[x0,#16*4]	// s2
+	str	w15,[x0,#16*5]	// r3
+	add	w15,w16,w16,lsl#2	// r4*5
+	str	w14,[x0,#16*6]	// s3
+	str	w16,[x0,#16*7]	// r4
+	str	w15,[x0,#16*8]	// s4
+
+	ret
+.size	poly1305_splat,.-poly1305_splat
+
+.type	poly1305_blocks_neon,%function
+.align	5
+poly1305_blocks_neon:
+	ldr	x17,[x0,#24]
+	cmp	x2,#128
+	b.hs	.Lblocks_neon
+	cbz	x17,poly1305_blocks
+
+.Lblocks_neon:
+	stp	x29,x30,[sp,#-80]!
+	add	x29,sp,#0
+
+	ands	x2,x2,#-16
+	b.eq	.Lno_data_neon
+
+	cbz	x17,.Lbase2_64_neon
+
+	ldp	w10,w11,[x0]		// load hash value base 2^26
+	ldp	w12,w13,[x0,#8]
+	ldr	w14,[x0,#16]
+
+	tst	x2,#31
+	b.eq	.Leven_neon
+
+	ldp	x7,x8,[x0,#32]	// load key value
+
+	add	x4,x10,x11,lsl#26	// base 2^26 -> base 2^64
+	lsr	x5,x12,#12
+	adds	x4,x4,x12,lsl#52
+	add	x5,x5,x13,lsl#14
+	adc	x5,x5,xzr
+	lsr	x6,x14,#24
+	adds	x5,x5,x14,lsl#40
+	adc	x14,x6,xzr		// can be partially reduced...
+
+	ldp	x12,x13,[x1],#16	// load input
+	sub	x2,x2,#16
+	add	x9,x8,x8,lsr#2	// s1 = r1 + (r1 >> 2)
+
+	and	x10,x14,#-4		// ... so reduce
+	and	x6,x14,#3
+	add	x10,x10,x14,lsr#2
+	adds	x4,x4,x10
+	adcs	x5,x5,xzr
+	adc	x6,x6,xzr
+
+#ifdef	__ARMEB__
+	rev	x12,x12
+	rev	x13,x13
+#endif
+	adds	x4,x4,x12		// accumulate input
+	adcs	x5,x5,x13
+	adc	x6,x6,x3
+
+	bl	poly1305_mult
+	ldr	x30,[sp,#8]
+
+	cbz	x3,.Lstore_base2_64_neon
+
+	and	x10,x4,#0x03ffffff	// base 2^64 -> base 2^26
+	ubfx	x11,x4,#26,#26
+	extr	x12,x5,x4,#52
+	and	x12,x12,#0x03ffffff
+	ubfx	x13,x5,#14,#26
+	extr	x14,x6,x5,#40
+
+	cbnz	x2,.Leven_neon
+
+	stp	w10,w11,[x0]		// store hash value base 2^26
+	stp	w12,w13,[x0,#8]
+	str	w14,[x0,#16]
+	b	.Lno_data_neon
+
+.align	4
+.Lstore_base2_64_neon:
+	stp	x4,x5,[x0]		// store hash value base 2^64
+	stp	x6,xzr,[x0,#16]	// note that is_base2_26 is zeroed
+	b	.Lno_data_neon
+
+.align	4
+.Lbase2_64_neon:
+	ldp	x7,x8,[x0,#32]	// load key value
+
+	ldp	x4,x5,[x0]		// load hash value base 2^64
+	ldr	x6,[x0,#16]
+
+	tst	x2,#31
+	b.eq	.Linit_neon
+
+	ldp	x12,x13,[x1],#16	// load input
+	sub	x2,x2,#16
+	add	x9,x8,x8,lsr#2	// s1 = r1 + (r1 >> 2)
+#ifdef	__ARMEB__
+	rev	x12,x12
+	rev	x13,x13
+#endif
+	adds	x4,x4,x12		// accumulate input
+	adcs	x5,x5,x13
+	adc	x6,x6,x3
+
+	bl	poly1305_mult
+
+.Linit_neon:
+	and	x10,x4,#0x03ffffff	// base 2^64 -> base 2^26
+	ubfx	x11,x4,#26,#26
+	extr	x12,x5,x4,#52
+	and	x12,x12,#0x03ffffff
+	ubfx	x13,x5,#14,#26
+	extr	x14,x6,x5,#40
+
+	stp	d8,d9,[sp,#16]		// meet ABI requirements
+	stp	d10,d11,[sp,#32]
+	stp	d12,d13,[sp,#48]
+	stp	d14,d15,[sp,#64]
+
+	fmov	d24,x10
+	fmov	d25,x11
+	fmov	d26,x12
+	fmov	d27,x13
+	fmov	d28,x14
+
+	////////////////////////////////// initialize r^n table
+	mov	x4,x7			// r^1
+	add	x9,x8,x8,lsr#2	// s1 = r1 + (r1 >> 2)
+	mov	x5,x8
+	mov	x6,xzr
+	add	x0,x0,#48+12
+	bl	poly1305_splat
+
+	bl	poly1305_mult		// r^2
+	sub	x0,x0,#4
+	bl	poly1305_splat
+
+	bl	poly1305_mult		// r^3
+	sub	x0,x0,#4
+	bl	poly1305_splat
+
+	bl	poly1305_mult		// r^4
+	sub	x0,x0,#4
+	bl	poly1305_splat
+	ldr	x30,[sp,#8]
+
+	add	x16,x1,#32
+	adr	x17,.Lzeros
+	subs	x2,x2,#64
+	csel	x16,x17,x16,lo
+
+	mov	x4,#1
+	str	x4,[x0,#-24]		// set is_base2_26
+	sub	x0,x0,#48		// restore original x0
+	b	.Ldo_neon
+
+.align	4
+.Leven_neon:
+	add	x16,x1,#32
+	adr	x17,.Lzeros
+	subs	x2,x2,#64
+	csel	x16,x17,x16,lo
+
+	stp	d8,d9,[sp,#16]		// meet ABI requirements
+	stp	d10,d11,[sp,#32]
+	stp	d12,d13,[sp,#48]
+	stp	d14,d15,[sp,#64]
+
+	fmov	d24,x10
+	fmov	d25,x11
+	fmov	d26,x12
+	fmov	d27,x13
+	fmov	d28,x14
+
+.Ldo_neon:
+	ldp	x8,x12,[x16],#16	// inp[2:3] (or zero)
+	ldp	x9,x13,[x16],#48
+
+	lsl	x3,x3,#24
+	add	x15,x0,#48
+
+#ifdef	__ARMEB__
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
+	fmov	d14,x4
+	and	x8,x8,#0x03ffffff
+	and	x9,x9,#0x03ffffff
+	ubfx	x10,x12,#14,#26
+	ubfx	x11,x13,#14,#26
+	add	x12,x3,x12,lsr#40
+	add	x13,x3,x13,lsr#40
+	add	x8,x8,x9,lsl#32		// bfi	x8,x9,#32,#32
+	fmov	d15,x6
+	add	x10,x10,x11,lsl#32	// bfi	x10,x11,#32,#32
+	add	x12,x12,x13,lsl#32	// bfi	x12,x13,#32,#32
+	fmov	d16,x8
+	fmov	d17,x10
+	fmov	d18,x12
+
+	ldp	x8,x12,[x1],#16	// inp[0:1]
+	ldp	x9,x13,[x1],#48
+
+	ld1	{v0.4s,v1.4s,v2.4s,v3.4s},[x15],#64
+	ld1	{v4.4s,v5.4s,v6.4s,v7.4s},[x15],#64
+	ld1	{v8.4s},[x15]
+
+#ifdef	__ARMEB__
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
+	fmov	d9,x4
+	and	x8,x8,#0x03ffffff
+	and	x9,x9,#0x03ffffff
+	ubfx	x10,x12,#14,#26
+	ubfx	x11,x13,#14,#26
+	add	x12,x3,x12,lsr#40
+	add	x13,x3,x13,lsr#40
+	add	x8,x8,x9,lsl#32		// bfi	x8,x9,#32,#32
+	fmov	d10,x6
+	add	x10,x10,x11,lsl#32	// bfi	x10,x11,#32,#32
+	add	x12,x12,x13,lsl#32	// bfi	x12,x13,#32,#32
+	movi	v31.2d,#-1
+	fmov	d11,x8
+	fmov	d12,x10
+	fmov	d13,x12
+	ushr	v31.2d,v31.2d,#38
+
+	b.ls	.Lskip_loop
+
+.align	4
+.Loop_neon:
+	////////////////////////////////////////////////////////////////
+	// ((inp[0]*r^4+inp[2]*r^2+inp[4])*r^4+inp[6]*r^2
+	// ((inp[1]*r^4+inp[3]*r^2+inp[5])*r^3+inp[7]*r
+	//   ___________________/
+	// ((inp[0]*r^4+inp[2]*r^2+inp[4])*r^4+inp[6]*r^2+inp[8])*r^2
+	// ((inp[1]*r^4+inp[3]*r^2+inp[5])*r^4+inp[7]*r^2+inp[9])*r
+	//   ___________________/ ____________________/
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
+	subs	x2,x2,#64
+	umull	v23.2d,v14.2s,v7.s[2]
+	csel	x16,x17,x16,lo
+	umull	v22.2d,v14.2s,v5.s[2]
+	umull	v21.2d,v14.2s,v3.s[2]
+	ldp	x8,x12,[x16],#16	// inp[2:3] (or zero)
+	umull	v20.2d,v14.2s,v1.s[2]
+	ldp	x9,x13,[x16],#48
+	umull	v19.2d,v14.2s,v0.s[2]
+#ifdef	__ARMEB__
+	rev	x8,x8
+	rev	x12,x12
+	rev	x9,x9
+	rev	x13,x13
+#endif
+
+	umlal	v23.2d,v15.2s,v5.s[2]
+	and	x4,x8,#0x03ffffff	// base 2^64 -> base 2^26
+	umlal	v22.2d,v15.2s,v3.s[2]
+	and	x5,x9,#0x03ffffff
+	umlal	v21.2d,v15.2s,v1.s[2]
+	ubfx	x6,x8,#26,#26
+	umlal	v20.2d,v15.2s,v0.s[2]
+	ubfx	x7,x9,#26,#26
+	umlal	v19.2d,v15.2s,v8.s[2]
+	add	x4,x4,x5,lsl#32		// bfi	x4,x5,#32,#32
+
+	umlal	v23.2d,v16.2s,v3.s[2]
+	extr	x8,x12,x8,#52
+	umlal	v22.2d,v16.2s,v1.s[2]
+	extr	x9,x13,x9,#52
+	umlal	v21.2d,v16.2s,v0.s[2]
+	add	x6,x6,x7,lsl#32		// bfi	x6,x7,#32,#32
+	umlal	v20.2d,v16.2s,v8.s[2]
+	fmov	d14,x4
+	umlal	v19.2d,v16.2s,v6.s[2]
+	and	x8,x8,#0x03ffffff
+
+	umlal	v23.2d,v17.2s,v1.s[2]
+	and	x9,x9,#0x03ffffff
+	umlal	v22.2d,v17.2s,v0.s[2]
+	ubfx	x10,x12,#14,#26
+	umlal	v21.2d,v17.2s,v8.s[2]
+	ubfx	x11,x13,#14,#26
+	umlal	v20.2d,v17.2s,v6.s[2]
+	add	x8,x8,x9,lsl#32		// bfi	x8,x9,#32,#32
+	umlal	v19.2d,v17.2s,v4.s[2]
+	fmov	d15,x6
+
+	add	v11.2s,v11.2s,v26.2s
+	add	x12,x3,x12,lsr#40
+	umlal	v23.2d,v18.2s,v0.s[2]
+	add	x13,x3,x13,lsr#40
+	umlal	v22.2d,v18.2s,v8.s[2]
+	add	x10,x10,x11,lsl#32	// bfi	x10,x11,#32,#32
+	umlal	v21.2d,v18.2s,v6.s[2]
+	add	x12,x12,x13,lsl#32	// bfi	x12,x13,#32,#32
+	umlal	v20.2d,v18.2s,v4.s[2]
+	fmov	d16,x8
+	umlal	v19.2d,v18.2s,v2.s[2]
+	fmov	d17,x10
+
+	////////////////////////////////////////////////////////////////
+	// (hash+inp[0:1])*r^4 and accumulate
+
+	add	v9.2s,v9.2s,v24.2s
+	fmov	d18,x12
+	umlal	v22.2d,v11.2s,v1.s[0]
+	ldp	x8,x12,[x1],#16	// inp[0:1]
+	umlal	v19.2d,v11.2s,v6.s[0]
+	ldp	x9,x13,[x1],#48
+	umlal	v23.2d,v11.2s,v3.s[0]
+	umlal	v20.2d,v11.2s,v8.s[0]
+	umlal	v21.2d,v11.2s,v0.s[0]
+#ifdef	__ARMEB__
+	rev	x8,x8
+	rev	x12,x12
+	rev	x9,x9
+	rev	x13,x13
+#endif
+
+	add	v10.2s,v10.2s,v25.2s
+	umlal	v22.2d,v9.2s,v5.s[0]
+	umlal	v23.2d,v9.2s,v7.s[0]
+	and	x4,x8,#0x03ffffff	// base 2^64 -> base 2^26
+	umlal	v21.2d,v9.2s,v3.s[0]
+	and	x5,x9,#0x03ffffff
+	umlal	v19.2d,v9.2s,v0.s[0]
+	ubfx	x6,x8,#26,#26
+	umlal	v20.2d,v9.2s,v1.s[0]
+	ubfx	x7,x9,#26,#26
+
+	add	v12.2s,v12.2s,v27.2s
+	add	x4,x4,x5,lsl#32		// bfi	x4,x5,#32,#32
+	umlal	v22.2d,v10.2s,v3.s[0]
+	extr	x8,x12,x8,#52
+	umlal	v23.2d,v10.2s,v5.s[0]
+	extr	x9,x13,x9,#52
+	umlal	v19.2d,v10.2s,v8.s[0]
+	add	x6,x6,x7,lsl#32		// bfi	x6,x7,#32,#32
+	umlal	v21.2d,v10.2s,v1.s[0]
+	fmov	d9,x4
+	umlal	v20.2d,v10.2s,v0.s[0]
+	and	x8,x8,#0x03ffffff
+
+	add	v13.2s,v13.2s,v28.2s
+	and	x9,x9,#0x03ffffff
+	umlal	v22.2d,v12.2s,v0.s[0]
+	ubfx	x10,x12,#14,#26
+	umlal	v19.2d,v12.2s,v4.s[0]
+	ubfx	x11,x13,#14,#26
+	umlal	v23.2d,v12.2s,v1.s[0]
+	add	x8,x8,x9,lsl#32		// bfi	x8,x9,#32,#32
+	umlal	v20.2d,v12.2s,v6.s[0]
+	fmov	d10,x6
+	umlal	v21.2d,v12.2s,v8.s[0]
+	add	x12,x3,x12,lsr#40
+
+	umlal	v22.2d,v13.2s,v8.s[0]
+	add	x13,x3,x13,lsr#40
+	umlal	v19.2d,v13.2s,v2.s[0]
+	add	x10,x10,x11,lsl#32	// bfi	x10,x11,#32,#32
+	umlal	v23.2d,v13.2s,v0.s[0]
+	add	x12,x12,x13,lsl#32	// bfi	x12,x13,#32,#32
+	umlal	v20.2d,v13.2s,v4.s[0]
+	fmov	d11,x8
+	umlal	v21.2d,v13.2s,v6.s[0]
+	fmov	d12,x10
+	fmov	d13,x12
+
+	/////////////////////////////////////////////////////////////////
+	// lazy reduction as discussed in "NEON crypto" by D.J. Bernstein
+	// and P. Schwabe
+	//
+	// [see discussion in poly1305-armv4 module]
+
+	ushr	v29.2d,v22.2d,#26
+	xtn	v27.2s,v22.2d
+	ushr	v30.2d,v19.2d,#26
+	and	v19.16b,v19.16b,v31.16b
+	add	v23.2d,v23.2d,v29.2d	// h3 -> h4
+	bic	v27.2s,#0xfc,lsl#24	// &=0x03ffffff
+	add	v20.2d,v20.2d,v30.2d	// h0 -> h1
+
+	ushr	v29.2d,v23.2d,#26
+	xtn	v28.2s,v23.2d
+	ushr	v30.2d,v20.2d,#26
+	xtn	v25.2s,v20.2d
+	bic	v28.2s,#0xfc,lsl#24
+	add	v21.2d,v21.2d,v30.2d	// h1 -> h2
+
+	add	v19.2d,v19.2d,v29.2d
+	shl	v29.2d,v29.2d,#2
+	shrn	v30.2s,v21.2d,#26
+	xtn	v26.2s,v21.2d
+	add	v19.2d,v19.2d,v29.2d	// h4 -> h0
+	bic	v25.2s,#0xfc,lsl#24
+	add	v27.2s,v27.2s,v30.2s		// h2 -> h3
+	bic	v26.2s,#0xfc,lsl#24
+
+	shrn	v29.2s,v19.2d,#26
+	xtn	v24.2s,v19.2d
+	ushr	v30.2s,v27.2s,#26
+	bic	v27.2s,#0xfc,lsl#24
+	bic	v24.2s,#0xfc,lsl#24
+	add	v25.2s,v25.2s,v29.2s		// h0 -> h1
+	add	v28.2s,v28.2s,v30.2s		// h3 -> h4
+
+	b.hi	.Loop_neon
+
+.Lskip_loop:
+	dup	v16.2d,v16.d[0]
+	add	v11.2s,v11.2s,v26.2s
+
+	////////////////////////////////////////////////////////////////
+	// multiply (inp[0:1]+hash) or inp[2:3] by r^2:r^1
+
+	adds	x2,x2,#32
+	b.ne	.Long_tail
+
+	dup	v16.2d,v11.d[0]
+	add	v14.2s,v9.2s,v24.2s
+	add	v17.2s,v12.2s,v27.2s
+	add	v15.2s,v10.2s,v25.2s
+	add	v18.2s,v13.2s,v28.2s
+
+.Long_tail:
+	dup	v14.2d,v14.d[0]
+	umull2	v19.2d,v16.4s,v6.4s
+	umull2	v22.2d,v16.4s,v1.4s
+	umull2	v23.2d,v16.4s,v3.4s
+	umull2	v21.2d,v16.4s,v0.4s
+	umull2	v20.2d,v16.4s,v8.4s
+
+	dup	v15.2d,v15.d[0]
+	umlal2	v19.2d,v14.4s,v0.4s
+	umlal2	v21.2d,v14.4s,v3.4s
+	umlal2	v22.2d,v14.4s,v5.4s
+	umlal2	v23.2d,v14.4s,v7.4s
+	umlal2	v20.2d,v14.4s,v1.4s
+
+	dup	v17.2d,v17.d[0]
+	umlal2	v19.2d,v15.4s,v8.4s
+	umlal2	v22.2d,v15.4s,v3.4s
+	umlal2	v21.2d,v15.4s,v1.4s
+	umlal2	v23.2d,v15.4s,v5.4s
+	umlal2	v20.2d,v15.4s,v0.4s
+
+	dup	v18.2d,v18.d[0]
+	umlal2	v22.2d,v17.4s,v0.4s
+	umlal2	v23.2d,v17.4s,v1.4s
+	umlal2	v19.2d,v17.4s,v4.4s
+	umlal2	v20.2d,v17.4s,v6.4s
+	umlal2	v21.2d,v17.4s,v8.4s
+
+	umlal2	v22.2d,v18.4s,v8.4s
+	umlal2	v19.2d,v18.4s,v2.4s
+	umlal2	v23.2d,v18.4s,v0.4s
+	umlal2	v20.2d,v18.4s,v4.4s
+	umlal2	v21.2d,v18.4s,v6.4s
+
+	b.eq	.Lshort_tail
+
+	////////////////////////////////////////////////////////////////
+	// (hash+inp[0:1])*r^4:r^3 and accumulate
+
+	add	v9.2s,v9.2s,v24.2s
+	umlal	v22.2d,v11.2s,v1.2s
+	umlal	v19.2d,v11.2s,v6.2s
+	umlal	v23.2d,v11.2s,v3.2s
+	umlal	v20.2d,v11.2s,v8.2s
+	umlal	v21.2d,v11.2s,v0.2s
+
+	add	v10.2s,v10.2s,v25.2s
+	umlal	v22.2d,v9.2s,v5.2s
+	umlal	v19.2d,v9.2s,v0.2s
+	umlal	v23.2d,v9.2s,v7.2s
+	umlal	v20.2d,v9.2s,v1.2s
+	umlal	v21.2d,v9.2s,v3.2s
+
+	add	v12.2s,v12.2s,v27.2s
+	umlal	v22.2d,v10.2s,v3.2s
+	umlal	v19.2d,v10.2s,v8.2s
+	umlal	v23.2d,v10.2s,v5.2s
+	umlal	v20.2d,v10.2s,v0.2s
+	umlal	v21.2d,v10.2s,v1.2s
+
+	add	v13.2s,v13.2s,v28.2s
+	umlal	v22.2d,v12.2s,v0.2s
+	umlal	v19.2d,v12.2s,v4.2s
+	umlal	v23.2d,v12.2s,v1.2s
+	umlal	v20.2d,v12.2s,v6.2s
+	umlal	v21.2d,v12.2s,v8.2s
+
+	umlal	v22.2d,v13.2s,v8.2s
+	umlal	v19.2d,v13.2s,v2.2s
+	umlal	v23.2d,v13.2s,v0.2s
+	umlal	v20.2d,v13.2s,v4.2s
+	umlal	v21.2d,v13.2s,v6.2s
+
+.Lshort_tail:
+	////////////////////////////////////////////////////////////////
+	// horizontal add
+
+	addp	v22.2d,v22.2d,v22.2d
+	ldp	d8,d9,[sp,#16]		// meet ABI requirements
+	addp	v19.2d,v19.2d,v19.2d
+	ldp	d10,d11,[sp,#32]
+	addp	v23.2d,v23.2d,v23.2d
+	ldp	d12,d13,[sp,#48]
+	addp	v20.2d,v20.2d,v20.2d
+	ldp	d14,d15,[sp,#64]
+	addp	v21.2d,v21.2d,v21.2d
+
+	////////////////////////////////////////////////////////////////
+	// lazy reduction, but without narrowing
+
+	ushr	v29.2d,v22.2d,#26
+	and	v22.16b,v22.16b,v31.16b
+	ushr	v30.2d,v19.2d,#26
+	and	v19.16b,v19.16b,v31.16b
+
+	add	v23.2d,v23.2d,v29.2d	// h3 -> h4
+	add	v20.2d,v20.2d,v30.2d	// h0 -> h1
+
+	ushr	v29.2d,v23.2d,#26
+	and	v23.16b,v23.16b,v31.16b
+	ushr	v30.2d,v20.2d,#26
+	and	v20.16b,v20.16b,v31.16b
+	add	v21.2d,v21.2d,v30.2d	// h1 -> h2
+
+	add	v19.2d,v19.2d,v29.2d
+	shl	v29.2d,v29.2d,#2
+	ushr	v30.2d,v21.2d,#26
+	and	v21.16b,v21.16b,v31.16b
+	add	v19.2d,v19.2d,v29.2d	// h4 -> h0
+	add	v22.2d,v22.2d,v30.2d	// h2 -> h3
+
+	ushr	v29.2d,v19.2d,#26
+	and	v19.16b,v19.16b,v31.16b
+	ushr	v30.2d,v22.2d,#26
+	and	v22.16b,v22.16b,v31.16b
+	add	v20.2d,v20.2d,v29.2d	// h0 -> h1
+	add	v23.2d,v23.2d,v30.2d	// h3 -> h4
+
+	////////////////////////////////////////////////////////////////
+	// write the result, can be partially reduced
+
+	st4	{v19.s,v20.s,v21.s,v22.s}[0],[x0],#16
+	st1	{v23.s}[0],[x0]
+
+.Lno_data_neon:
+	ldr	x29,[sp],#80
+	ret
+.size	poly1305_blocks_neon,.-poly1305_blocks_neon
+
+.type	poly1305_emit_neon,%function
+.align	5
+poly1305_emit_neon:
+	ldr	x17,[x0,#24]
+	cbz	x17,poly1305_emit
+
+	ldp	w10,w11,[x0]		// load hash value base 2^26
+	ldp	w12,w13,[x0,#8]
+	ldr	w14,[x0,#16]
+
+	add	x4,x10,x11,lsl#26	// base 2^26 -> base 2^64
+	lsr	x5,x12,#12
+	adds	x4,x4,x12,lsl#52
+	add	x5,x5,x13,lsl#14
+	adc	x5,x5,xzr
+	lsr	x6,x14,#24
+	adds	x5,x5,x14,lsl#40
+	adc	x6,x6,xzr		// can be partially reduced...
+
+	ldp	x10,x11,[x2]	// load nonce
+
+	and	x12,x6,#-4		// ... so reduce
+	add	x12,x12,x6,lsr#2
+	and	x6,x6,#3
+	adds	x4,x4,x12
+	adcs	x5,x5,xzr
+	adc	x6,x6,xzr
+
+	adds	x12,x4,#5		// compare to modulus
+	adcs	x13,x5,xzr
+	adc	x14,x6,xzr
+
+	tst	x14,#-4			// see if it's carried/borrowed
+
+	csel	x4,x4,x12,eq
+	csel	x5,x5,x13,eq
+
+#ifdef	__ARMEB__
+	ror	x10,x10,#32		// flip nonce words
+	ror	x11,x11,#32
+#endif
+	adds	x4,x4,x10		// accumulate nonce
+	adc	x5,x5,x11
+#ifdef	__ARMEB__
+	rev	x4,x4			// flip output bytes
+	rev	x5,x5
+#endif
+	stp	x4,x5,[x1]		// write result
+
+	ret
+.size	poly1305_emit_neon,.-poly1305_emit_neon
+
+.align	5
+.Lzeros:
+.long	0,0,0,0,0,0,0,0
+.LOPENSSL_armcap_P:
+#ifdef	__ILP32__
+.long	OPENSSL_armcap_P-.
+#else
+.quad	OPENSSL_armcap_P-.
+#endif
+.byte	80,111,108,121,49,51,48,53,32,102,111,114,32,65,82,77,118,56,44,32,67,82,89,80,84,79,71,65,77,83,32,98,121,32,60,97,112,112,114,111,64,111,112,101,110,115,115,108,46,111,114,103,62,0
+.align	2
+.align	2
-- 
2.19.1
