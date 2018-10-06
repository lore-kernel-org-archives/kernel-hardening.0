From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next v7 07/28] zinc: import Andy Polyakov's ChaCha20 ARM and ARM64 implementations
Date: Sat,  6 Oct 2018 04:56:48 +0200
Message-Id: <20181006025709.4019-8-Jason@zx2c4.com>
In-Reply-To: <20181006025709.4019-1-Jason@zx2c4.com>
References: <20181006025709.4019-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Andy Polyakov <appro@openssl.org>, Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, Samuel Neves <sneves@dei.uc.pt>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

These NEON and non-NEON implementations come from Andy Polyakov's
implementation, and are included here in raw form without modification,
so that subsequent commits that fix these up for the kernel can see how
it has changed.

While this is CRYPTOGAMS code, the originating code for this happens to
be the same as OpenSSL's commit 87cc649f30aaf69b351701875b9dac07c29ce8a2

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
 lib/zinc/chacha20/chacha20-arm-cryptogams.S   | 1440 ++++++++++++
 lib/zinc/chacha20/chacha20-arm64-cryptogams.S | 1973 +++++++++++++++++
 2 files changed, 3413 insertions(+)
 create mode 100644 lib/zinc/chacha20/chacha20-arm-cryptogams.S
 create mode 100644 lib/zinc/chacha20/chacha20-arm64-cryptogams.S

diff --git a/lib/zinc/chacha20/chacha20-arm-cryptogams.S b/lib/zinc/chacha20/chacha20-arm-cryptogams.S
new file mode 100644
index 000000000000..05a3a9e6e93f
--- /dev/null
+++ b/lib/zinc/chacha20/chacha20-arm-cryptogams.S
@@ -0,0 +1,1440 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/*
+ * Copyright (C) 2006-2017 CRYPTOGAMS by <appro@openssl.org>. All Rights Reserved.
+ */
+
+#include "arm_arch.h"
+
+.text
+#if defined(__thumb2__) || defined(__clang__)
+.syntax	unified
+#endif
+#if defined(__thumb2__)
+.thumb
+#else
+.code	32
+#endif
+
+#if defined(__thumb2__) || defined(__clang__)
+#define ldrhsb	ldrbhs
+#endif
+
+.align	5
+.Lsigma:
+.long	0x61707865,0x3320646e,0x79622d32,0x6b206574	@ endian-neutral
+.Lone:
+.long	1,0,0,0
+.Lrot8:
+.long	0x02010003,0x06050407
+#if __ARM_MAX_ARCH__>=7
+.LOPENSSL_armcap:
+.word   OPENSSL_armcap_P-.LChaCha20_ctr32
+#else
+.word	-1
+#endif
+
+.globl	ChaCha20_ctr32
+.type	ChaCha20_ctr32,%function
+.align	5
+ChaCha20_ctr32:
+.LChaCha20_ctr32:
+	ldr	r12,[sp,#0]		@ pull pointer to counter and nonce
+	stmdb	sp!,{r0-r2,r4-r11,lr}
+#if __ARM_ARCH__<7 && !defined(__thumb2__)
+	sub	r14,pc,#16		@ ChaCha20_ctr32
+#else
+	adr	r14,.LChaCha20_ctr32
+#endif
+	cmp	r2,#0			@ len==0?
+#ifdef	__thumb2__
+	itt	eq
+#endif
+	addeq	sp,sp,#4*3
+	beq	.Lno_data
+#if __ARM_MAX_ARCH__>=7
+	cmp	r2,#192			@ test len
+	bls	.Lshort
+	ldr	r4,[r14,#-24]
+	ldr	r4,[r14,r4]
+# ifdef	__APPLE__
+	ldr	r4,[r4]
+# endif
+	tst	r4,#ARMV7_NEON
+	bne	.LChaCha20_neon
+.Lshort:
+#endif
+	ldmia	r12,{r4-r7}		@ load counter and nonce
+	sub	sp,sp,#4*(16)		@ off-load area
+	sub	r14,r14,#64		@ .Lsigma
+	stmdb	sp!,{r4-r7}		@ copy counter and nonce
+	ldmia	r3,{r4-r11}		@ load key
+	ldmia	r14,{r0-r3}		@ load sigma
+	stmdb	sp!,{r4-r11}		@ copy key
+	stmdb	sp!,{r0-r3}		@ copy sigma
+	str	r10,[sp,#4*(16+10)]	@ off-load "rx"
+	str	r11,[sp,#4*(16+11)]	@ off-load "rx"
+	b	.Loop_outer_enter
+
+.align	4
+.Loop_outer:
+	ldmia	sp,{r0-r9}		@ load key material
+	str	r11,[sp,#4*(32+2)]	@ save len
+	str	r12,  [sp,#4*(32+1)]	@ save inp
+	str	r14,  [sp,#4*(32+0)]	@ save out
+.Loop_outer_enter:
+	ldr	r11, [sp,#4*(15)]
+	 mov	r4,r4,ror#19	@ twist b[0..3]
+	ldr	r12,[sp,#4*(12)]	@ modulo-scheduled load
+	 mov	r5,r5,ror#19
+	ldr	r10, [sp,#4*(13)]
+	 mov	r6,r6,ror#19
+	ldr	r14,[sp,#4*(14)]
+	 mov	r7,r7,ror#19
+	mov	r11,r11,ror#8	@ twist d[0..3]
+	mov	r12,r12,ror#8
+	mov	r10,r10,ror#8
+	mov	r14,r14,ror#8
+	str	r11, [sp,#4*(16+15)]
+	mov	r11,#10
+	b	.Loop
+
+.align	4
+.Loop:
+	subs	r11,r11,#1
+	add	r0,r0,r4,ror#13
+	add	r1,r1,r5,ror#13
+	eor	r12,r0,r12,ror#24
+	eor	r10,r1,r10,ror#24
+	add	r8,r8,r12,ror#16
+	add	r9,r9,r10,ror#16
+	eor	r4,r8,r4,ror#13
+	eor	r5,r9,r5,ror#13
+	add	r0,r0,r4,ror#20
+	add	r1,r1,r5,ror#20
+	eor	r12,r0,r12,ror#16
+	eor	r10,r1,r10,ror#16
+	add	r8,r8,r12,ror#24
+	str	r10,[sp,#4*(16+13)]
+	add	r9,r9,r10,ror#24
+	ldr	r10,[sp,#4*(16+15)]
+	str	r8,[sp,#4*(16+8)]
+	eor	r4,r4,r8,ror#12
+	str	r9,[sp,#4*(16+9)]
+	eor	r5,r5,r9,ror#12
+	ldr	r8,[sp,#4*(16+10)]
+	add	r2,r2,r6,ror#13
+	ldr	r9,[sp,#4*(16+11)]
+	add	r3,r3,r7,ror#13
+	eor	r14,r2,r14,ror#24
+	eor	r10,r3,r10,ror#24
+	add	r8,r8,r14,ror#16
+	add	r9,r9,r10,ror#16
+	eor	r6,r8,r6,ror#13
+	eor	r7,r9,r7,ror#13
+	add	r2,r2,r6,ror#20
+	add	r3,r3,r7,ror#20
+	eor	r14,r2,r14,ror#16
+	eor	r10,r3,r10,ror#16
+	add	r8,r8,r14,ror#24
+	add	r9,r9,r10,ror#24
+	eor	r6,r6,r8,ror#12
+	eor	r7,r7,r9,ror#12
+	add	r0,r0,r5,ror#13
+	add	r1,r1,r6,ror#13
+	eor	r10,r0,r10,ror#24
+	eor	r12,r1,r12,ror#24
+	add	r8,r8,r10,ror#16
+	add	r9,r9,r12,ror#16
+	eor	r5,r8,r5,ror#13
+	eor	r6,r9,r6,ror#13
+	add	r0,r0,r5,ror#20
+	add	r1,r1,r6,ror#20
+	eor	r10,r0,r10,ror#16
+	eor	r12,r1,r12,ror#16
+	str	r10,[sp,#4*(16+15)]
+	add	r8,r8,r10,ror#24
+	ldr	r10,[sp,#4*(16+13)]
+	add	r9,r9,r12,ror#24
+	str	r8,[sp,#4*(16+10)]
+	eor	r5,r5,r8,ror#12
+	str	r9,[sp,#4*(16+11)]
+	eor	r6,r6,r9,ror#12
+	ldr	r8,[sp,#4*(16+8)]
+	add	r2,r2,r7,ror#13
+	ldr	r9,[sp,#4*(16+9)]
+	add	r3,r3,r4,ror#13
+	eor	r10,r2,r10,ror#24
+	eor	r14,r3,r14,ror#24
+	add	r8,r8,r10,ror#16
+	add	r9,r9,r14,ror#16
+	eor	r7,r8,r7,ror#13
+	eor	r4,r9,r4,ror#13
+	add	r2,r2,r7,ror#20
+	add	r3,r3,r4,ror#20
+	eor	r10,r2,r10,ror#16
+	eor	r14,r3,r14,ror#16
+	add	r8,r8,r10,ror#24
+	add	r9,r9,r14,ror#24
+	eor	r7,r7,r8,ror#12
+	eor	r4,r4,r9,ror#12
+	bne	.Loop
+
+	ldr	r11,[sp,#4*(32+2)]	@ load len
+
+	str	r8, [sp,#4*(16+8)]	@ modulo-scheduled store
+	str	r9, [sp,#4*(16+9)]
+	str	r12,[sp,#4*(16+12)]
+	str	r10, [sp,#4*(16+13)]
+	str	r14,[sp,#4*(16+14)]
+
+	@ at this point we have first half of 512-bit result in
+	@ rx and second half at sp+4*(16+8)
+
+	cmp	r11,#64		@ done yet?
+#ifdef	__thumb2__
+	itete	lo
+#endif
+	addlo	r12,sp,#4*(0)		@ shortcut or ...
+	ldrhs	r12,[sp,#4*(32+1)]	@ ... load inp
+	addlo	r14,sp,#4*(0)		@ shortcut or ...
+	ldrhs	r14,[sp,#4*(32+0)]	@ ... load out
+
+	ldr	r8,[sp,#4*(0)]	@ load key material
+	ldr	r9,[sp,#4*(1)]
+
+#if __ARM_ARCH__>=6 || !defined(__ARMEB__)
+# if __ARM_ARCH__<7
+	orr	r10,r12,r14
+	tst	r10,#3		@ are input and output aligned?
+	ldr	r10,[sp,#4*(2)]
+	bne	.Lunaligned
+	cmp	r11,#64		@ restore flags
+# else
+	ldr	r10,[sp,#4*(2)]
+# endif
+	ldr	r11,[sp,#4*(3)]
+
+	add	r0,r0,r8	@ accumulate key material
+	add	r1,r1,r9
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhs	r8,[r12],#16		@ load input
+	ldrhs	r9,[r12,#-12]
+
+	add	r2,r2,r10
+	add	r3,r3,r11
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhs	r10,[r12,#-8]
+	ldrhs	r11,[r12,#-4]
+# if __ARM_ARCH__>=6 && defined(__ARMEB__)
+	rev	r0,r0
+	rev	r1,r1
+	rev	r2,r2
+	rev	r3,r3
+# endif
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	eorhs	r0,r0,r8	@ xor with input
+	eorhs	r1,r1,r9
+	 add	r8,sp,#4*(4)
+	str	r0,[r14],#16		@ store output
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	eorhs	r2,r2,r10
+	eorhs	r3,r3,r11
+	 ldmia	r8,{r8-r11}	@ load key material
+	str	r1,[r14,#-12]
+	str	r2,[r14,#-8]
+	str	r3,[r14,#-4]
+
+	add	r4,r8,r4,ror#13 @ accumulate key material
+	add	r5,r9,r5,ror#13
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhs	r8,[r12],#16		@ load input
+	ldrhs	r9,[r12,#-12]
+	add	r6,r10,r6,ror#13
+	add	r7,r11,r7,ror#13
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhs	r10,[r12,#-8]
+	ldrhs	r11,[r12,#-4]
+# if __ARM_ARCH__>=6 && defined(__ARMEB__)
+	rev	r4,r4
+	rev	r5,r5
+	rev	r6,r6
+	rev	r7,r7
+# endif
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	eorhs	r4,r4,r8
+	eorhs	r5,r5,r9
+	 add	r8,sp,#4*(8)
+	str	r4,[r14],#16		@ store output
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	eorhs	r6,r6,r10
+	eorhs	r7,r7,r11
+	str	r5,[r14,#-12]
+	 ldmia	r8,{r8-r11}	@ load key material
+	str	r6,[r14,#-8]
+	 add	r0,sp,#4*(16+8)
+	str	r7,[r14,#-4]
+
+	ldmia	r0,{r0-r7}	@ load second half
+
+	add	r0,r0,r8	@ accumulate key material
+	add	r1,r1,r9
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhs	r8,[r12],#16		@ load input
+	ldrhs	r9,[r12,#-12]
+# ifdef	__thumb2__
+	itt	hi
+# endif
+	 strhi	r10,[sp,#4*(16+10)]	@ copy "rx" while at it
+	 strhi	r11,[sp,#4*(16+11)]	@ copy "rx" while at it
+	add	r2,r2,r10
+	add	r3,r3,r11
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhs	r10,[r12,#-8]
+	ldrhs	r11,[r12,#-4]
+# if __ARM_ARCH__>=6 && defined(__ARMEB__)
+	rev	r0,r0
+	rev	r1,r1
+	rev	r2,r2
+	rev	r3,r3
+# endif
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	eorhs	r0,r0,r8
+	eorhs	r1,r1,r9
+	 add	r8,sp,#4*(12)
+	str	r0,[r14],#16		@ store output
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	eorhs	r2,r2,r10
+	eorhs	r3,r3,r11
+	str	r1,[r14,#-12]
+	 ldmia	r8,{r8-r11}	@ load key material
+	str	r2,[r14,#-8]
+	str	r3,[r14,#-4]
+
+	add	r4,r8,r4,ror#24 @ accumulate key material
+	add	r5,r9,r5,ror#24
+# ifdef	__thumb2__
+	itt	hi
+# endif
+	 addhi	r8,r8,#1		@ next counter value
+	 strhi	r8,[sp,#4*(12)]	@ save next counter value
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhs	r8,[r12],#16		@ load input
+	ldrhs	r9,[r12,#-12]
+	add	r6,r10,r6,ror#24
+	add	r7,r11,r7,ror#24
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhs	r10,[r12,#-8]
+	ldrhs	r11,[r12,#-4]
+# if __ARM_ARCH__>=6 && defined(__ARMEB__)
+	rev	r4,r4
+	rev	r5,r5
+	rev	r6,r6
+	rev	r7,r7
+# endif
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	eorhs	r4,r4,r8
+	eorhs	r5,r5,r9
+# ifdef	__thumb2__
+	 it	ne
+# endif
+	 ldrne	r8,[sp,#4*(32+2)]	@ re-load len
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	eorhs	r6,r6,r10
+	eorhs	r7,r7,r11
+	str	r4,[r14],#16		@ store output
+	str	r5,[r14,#-12]
+# ifdef	__thumb2__
+	it	hs
+# endif
+	 subhs	r11,r8,#64		@ len-=64
+	str	r6,[r14,#-8]
+	str	r7,[r14,#-4]
+	bhi	.Loop_outer
+
+	beq	.Ldone
+# if __ARM_ARCH__<7
+	b	.Ltail
+
+.align	4
+.Lunaligned:				@ unaligned endian-neutral path
+	cmp	r11,#64		@ restore flags
+# endif
+#endif
+#if __ARM_ARCH__<7
+	ldr	r11,[sp,#4*(3)]
+	add	r0,r8,r0	@ accumulate key material
+	add	r1,r9,r1
+	add	r2,r10,r2
+# ifdef	__thumb2__
+	itete	lo
+# endif
+	eorlo	r8,r8,r8		@ zero or ...
+	ldrhsb	r8,[r12],#16			@ ... load input
+	eorlo	r9,r9,r9
+	ldrhsb	r9,[r12,#-12]
+
+	add	r3,r11,r3
+# ifdef	__thumb2__
+	itete	lo
+# endif
+	eorlo	r10,r10,r10
+	ldrhsb	r10,[r12,#-8]
+	eorlo	r11,r11,r11
+	ldrhsb	r11,[r12,#-4]
+
+	eor	r0,r8,r0		@ xor with input (or zero)
+	eor	r1,r9,r1
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r8,[r12,#-15]		@ load more input
+	ldrhsb	r9,[r12,#-11]
+	eor	r2,r10,r2
+	 strb	r0,[r14],#16		@ store output
+	eor	r3,r11,r3
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r10,[r12,#-7]
+	ldrhsb	r11,[r12,#-3]
+	 strb	r1,[r14,#-12]
+	eor	r0,r8,r0,lsr#8
+	 strb	r2,[r14,#-8]
+	eor	r1,r9,r1,lsr#8
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r8,[r12,#-14]		@ load more input
+	ldrhsb	r9,[r12,#-10]
+	 strb	r3,[r14,#-4]
+	eor	r2,r10,r2,lsr#8
+	 strb	r0,[r14,#-15]
+	eor	r3,r11,r3,lsr#8
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r10,[r12,#-6]
+	ldrhsb	r11,[r12,#-2]
+	 strb	r1,[r14,#-11]
+	eor	r0,r8,r0,lsr#8
+	 strb	r2,[r14,#-7]
+	eor	r1,r9,r1,lsr#8
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r8,[r12,#-13]		@ load more input
+	ldrhsb	r9,[r12,#-9]
+	 strb	r3,[r14,#-3]
+	eor	r2,r10,r2,lsr#8
+	 strb	r0,[r14,#-14]
+	eor	r3,r11,r3,lsr#8
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r10,[r12,#-5]
+	ldrhsb	r11,[r12,#-1]
+	 strb	r1,[r14,#-10]
+	 strb	r2,[r14,#-6]
+	eor	r0,r8,r0,lsr#8
+	 strb	r3,[r14,#-2]
+	eor	r1,r9,r1,lsr#8
+	 strb	r0,[r14,#-13]
+	eor	r2,r10,r2,lsr#8
+	 strb	r1,[r14,#-9]
+	eor	r3,r11,r3,lsr#8
+	 strb	r2,[r14,#-5]
+	 strb	r3,[r14,#-1]
+	add	r8,sp,#4*(4+0)
+	ldmia	r8,{r8-r11}		@ load key material
+	add	r0,sp,#4*(16+8)
+	add	r4,r8,r4,ror#13	@ accumulate key material
+	add	r5,r9,r5,ror#13
+	add	r6,r10,r6,ror#13
+# ifdef	__thumb2__
+	itete	lo
+# endif
+	eorlo	r8,r8,r8		@ zero or ...
+	ldrhsb	r8,[r12],#16			@ ... load input
+	eorlo	r9,r9,r9
+	ldrhsb	r9,[r12,#-12]
+
+	add	r7,r11,r7,ror#13
+# ifdef	__thumb2__
+	itete	lo
+# endif
+	eorlo	r10,r10,r10
+	ldrhsb	r10,[r12,#-8]
+	eorlo	r11,r11,r11
+	ldrhsb	r11,[r12,#-4]
+
+	eor	r4,r8,r4		@ xor with input (or zero)
+	eor	r5,r9,r5
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r8,[r12,#-15]		@ load more input
+	ldrhsb	r9,[r12,#-11]
+	eor	r6,r10,r6
+	 strb	r4,[r14],#16		@ store output
+	eor	r7,r11,r7
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r10,[r12,#-7]
+	ldrhsb	r11,[r12,#-3]
+	 strb	r5,[r14,#-12]
+	eor	r4,r8,r4,lsr#8
+	 strb	r6,[r14,#-8]
+	eor	r5,r9,r5,lsr#8
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r8,[r12,#-14]		@ load more input
+	ldrhsb	r9,[r12,#-10]
+	 strb	r7,[r14,#-4]
+	eor	r6,r10,r6,lsr#8
+	 strb	r4,[r14,#-15]
+	eor	r7,r11,r7,lsr#8
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r10,[r12,#-6]
+	ldrhsb	r11,[r12,#-2]
+	 strb	r5,[r14,#-11]
+	eor	r4,r8,r4,lsr#8
+	 strb	r6,[r14,#-7]
+	eor	r5,r9,r5,lsr#8
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r8,[r12,#-13]		@ load more input
+	ldrhsb	r9,[r12,#-9]
+	 strb	r7,[r14,#-3]
+	eor	r6,r10,r6,lsr#8
+	 strb	r4,[r14,#-14]
+	eor	r7,r11,r7,lsr#8
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r10,[r12,#-5]
+	ldrhsb	r11,[r12,#-1]
+	 strb	r5,[r14,#-10]
+	 strb	r6,[r14,#-6]
+	eor	r4,r8,r4,lsr#8
+	 strb	r7,[r14,#-2]
+	eor	r5,r9,r5,lsr#8
+	 strb	r4,[r14,#-13]
+	eor	r6,r10,r6,lsr#8
+	 strb	r5,[r14,#-9]
+	eor	r7,r11,r7,lsr#8
+	 strb	r6,[r14,#-5]
+	 strb	r7,[r14,#-1]
+	add	r8,sp,#4*(4+4)
+	ldmia	r8,{r8-r11}		@ load key material
+	ldmia	r0,{r0-r7}		@ load second half
+# ifdef	__thumb2__
+	itt	hi
+# endif
+	strhi	r10,[sp,#4*(16+10)]		@ copy "rx"
+	strhi	r11,[sp,#4*(16+11)]		@ copy "rx"
+	add	r0,r8,r0	@ accumulate key material
+	add	r1,r9,r1
+	add	r2,r10,r2
+# ifdef	__thumb2__
+	itete	lo
+# endif
+	eorlo	r8,r8,r8		@ zero or ...
+	ldrhsb	r8,[r12],#16			@ ... load input
+	eorlo	r9,r9,r9
+	ldrhsb	r9,[r12,#-12]
+
+	add	r3,r11,r3
+# ifdef	__thumb2__
+	itete	lo
+# endif
+	eorlo	r10,r10,r10
+	ldrhsb	r10,[r12,#-8]
+	eorlo	r11,r11,r11
+	ldrhsb	r11,[r12,#-4]
+
+	eor	r0,r8,r0		@ xor with input (or zero)
+	eor	r1,r9,r1
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r8,[r12,#-15]		@ load more input
+	ldrhsb	r9,[r12,#-11]
+	eor	r2,r10,r2
+	 strb	r0,[r14],#16		@ store output
+	eor	r3,r11,r3
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r10,[r12,#-7]
+	ldrhsb	r11,[r12,#-3]
+	 strb	r1,[r14,#-12]
+	eor	r0,r8,r0,lsr#8
+	 strb	r2,[r14,#-8]
+	eor	r1,r9,r1,lsr#8
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r8,[r12,#-14]		@ load more input
+	ldrhsb	r9,[r12,#-10]
+	 strb	r3,[r14,#-4]
+	eor	r2,r10,r2,lsr#8
+	 strb	r0,[r14,#-15]
+	eor	r3,r11,r3,lsr#8
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r10,[r12,#-6]
+	ldrhsb	r11,[r12,#-2]
+	 strb	r1,[r14,#-11]
+	eor	r0,r8,r0,lsr#8
+	 strb	r2,[r14,#-7]
+	eor	r1,r9,r1,lsr#8
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r8,[r12,#-13]		@ load more input
+	ldrhsb	r9,[r12,#-9]
+	 strb	r3,[r14,#-3]
+	eor	r2,r10,r2,lsr#8
+	 strb	r0,[r14,#-14]
+	eor	r3,r11,r3,lsr#8
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r10,[r12,#-5]
+	ldrhsb	r11,[r12,#-1]
+	 strb	r1,[r14,#-10]
+	 strb	r2,[r14,#-6]
+	eor	r0,r8,r0,lsr#8
+	 strb	r3,[r14,#-2]
+	eor	r1,r9,r1,lsr#8
+	 strb	r0,[r14,#-13]
+	eor	r2,r10,r2,lsr#8
+	 strb	r1,[r14,#-9]
+	eor	r3,r11,r3,lsr#8
+	 strb	r2,[r14,#-5]
+	 strb	r3,[r14,#-1]
+	add	r8,sp,#4*(4+8)
+	ldmia	r8,{r8-r11}		@ load key material
+	add	r4,r8,r4,ror#24	@ accumulate key material
+# ifdef	__thumb2__
+	itt	hi
+# endif
+	addhi	r8,r8,#1			@ next counter value
+	strhi	r8,[sp,#4*(12)]		@ save next counter value
+	add	r5,r9,r5,ror#24
+	add	r6,r10,r6,ror#24
+# ifdef	__thumb2__
+	itete	lo
+# endif
+	eorlo	r8,r8,r8		@ zero or ...
+	ldrhsb	r8,[r12],#16			@ ... load input
+	eorlo	r9,r9,r9
+	ldrhsb	r9,[r12,#-12]
+
+	add	r7,r11,r7,ror#24
+# ifdef	__thumb2__
+	itete	lo
+# endif
+	eorlo	r10,r10,r10
+	ldrhsb	r10,[r12,#-8]
+	eorlo	r11,r11,r11
+	ldrhsb	r11,[r12,#-4]
+
+	eor	r4,r8,r4		@ xor with input (or zero)
+	eor	r5,r9,r5
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r8,[r12,#-15]		@ load more input
+	ldrhsb	r9,[r12,#-11]
+	eor	r6,r10,r6
+	 strb	r4,[r14],#16		@ store output
+	eor	r7,r11,r7
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r10,[r12,#-7]
+	ldrhsb	r11,[r12,#-3]
+	 strb	r5,[r14,#-12]
+	eor	r4,r8,r4,lsr#8
+	 strb	r6,[r14,#-8]
+	eor	r5,r9,r5,lsr#8
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r8,[r12,#-14]		@ load more input
+	ldrhsb	r9,[r12,#-10]
+	 strb	r7,[r14,#-4]
+	eor	r6,r10,r6,lsr#8
+	 strb	r4,[r14,#-15]
+	eor	r7,r11,r7,lsr#8
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r10,[r12,#-6]
+	ldrhsb	r11,[r12,#-2]
+	 strb	r5,[r14,#-11]
+	eor	r4,r8,r4,lsr#8
+	 strb	r6,[r14,#-7]
+	eor	r5,r9,r5,lsr#8
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r8,[r12,#-13]		@ load more input
+	ldrhsb	r9,[r12,#-9]
+	 strb	r7,[r14,#-3]
+	eor	r6,r10,r6,lsr#8
+	 strb	r4,[r14,#-14]
+	eor	r7,r11,r7,lsr#8
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	r10,[r12,#-5]
+	ldrhsb	r11,[r12,#-1]
+	 strb	r5,[r14,#-10]
+	 strb	r6,[r14,#-6]
+	eor	r4,r8,r4,lsr#8
+	 strb	r7,[r14,#-2]
+	eor	r5,r9,r5,lsr#8
+	 strb	r4,[r14,#-13]
+	eor	r6,r10,r6,lsr#8
+	 strb	r5,[r14,#-9]
+	eor	r7,r11,r7,lsr#8
+	 strb	r6,[r14,#-5]
+	 strb	r7,[r14,#-1]
+# ifdef	__thumb2__
+	it	ne
+# endif
+	ldrne	r8,[sp,#4*(32+2)]		@ re-load len
+# ifdef	__thumb2__
+	it	hs
+# endif
+	subhs	r11,r8,#64			@ len-=64
+	bhi	.Loop_outer
+
+	beq	.Ldone
+#endif
+
+.Ltail:
+	ldr	r12,[sp,#4*(32+1)]	@ load inp
+	add	r9,sp,#4*(0)
+	ldr	r14,[sp,#4*(32+0)]	@ load out
+
+.Loop_tail:
+	ldrb	r10,[r9],#1	@ read buffer on stack
+	ldrb	r11,[r12],#1		@ read input
+	subs	r8,r8,#1
+	eor	r11,r11,r10
+	strb	r11,[r14],#1		@ store output
+	bne	.Loop_tail
+
+.Ldone:
+	add	sp,sp,#4*(32+3)
+.Lno_data:
+	ldmia	sp!,{r4-r11,pc}
+.size	ChaCha20_ctr32,.-ChaCha20_ctr32
+#if __ARM_MAX_ARCH__>=7
+.arch	armv7-a
+.fpu	neon
+
+.type	ChaCha20_neon,%function
+.align	5
+ChaCha20_neon:
+	ldr		r12,[sp,#0]		@ pull pointer to counter and nonce
+	stmdb		sp!,{r0-r2,r4-r11,lr}
+.LChaCha20_neon:
+	adr		r14,.Lsigma
+	vstmdb		sp!,{d8-d15}		@ ABI spec says so
+	stmdb		sp!,{r0-r3}
+
+	vld1.32		{q1-q2},[r3]		@ load key
+	ldmia		r3,{r4-r11}		@ load key
+
+	sub		sp,sp,#4*(16+16)
+	vld1.32		{q3},[r12]		@ load counter and nonce
+	add		r12,sp,#4*8
+	ldmia		r14,{r0-r3}		@ load sigma
+	vld1.32		{q0},[r14]!		@ load sigma
+	vld1.32		{q12},[r14]!		@ one
+	@ vld1.32	{d30},[r14]		@ rot8
+	vst1.32		{q2-q3},[r12]		@ copy 1/2key|counter|nonce
+	vst1.32		{q0-q1},[sp]		@ copy sigma|1/2key
+
+	str		r10,[sp,#4*(16+10)]	@ off-load "rx"
+	str		r11,[sp,#4*(16+11)]	@ off-load "rx"
+	vshl.i32	d26,d24,#1	@ two
+	vstr		d24,[sp,#4*(16+0)]
+	vshl.i32	d28,d24,#2	@ four
+	vstr		d26,[sp,#4*(16+2)]
+	vmov		q4,q0
+	vstr		d28,[sp,#4*(16+4)]
+	vmov		q8,q0
+	@ vstr		d30,[sp,#4*(16+6)]
+	vmov		q5,q1
+	vmov		q9,q1
+	b		.Loop_neon_enter
+
+.align	4
+.Loop_neon_outer:
+	ldmia		sp,{r0-r9}		@ load key material
+	cmp		r11,#64*2		@ if len<=64*2
+	bls		.Lbreak_neon		@ switch to integer-only
+	@ vldr		d30,[sp,#4*(16+6)]	@ rot8
+	vmov		q4,q0
+	str		r11,[sp,#4*(32+2)]	@ save len
+	vmov		q8,q0
+	str		r12,  [sp,#4*(32+1)]	@ save inp
+	vmov		q5,q1
+	str		r14,  [sp,#4*(32+0)]	@ save out
+	vmov		q9,q1
+.Loop_neon_enter:
+	ldr		r11, [sp,#4*(15)]
+	 mov		r4,r4,ror#19	@ twist b[0..3]
+	vadd.i32	q7,q3,q12		@ counter+1
+	ldr		r12,[sp,#4*(12)]	@ modulo-scheduled load
+	 mov		r5,r5,ror#19
+	vmov		q6,q2
+	ldr		r10, [sp,#4*(13)]
+	 mov		r6,r6,ror#19
+	vmov		q10,q2
+	ldr		r14,[sp,#4*(14)]
+	 mov		r7,r7,ror#19
+	vadd.i32	q11,q7,q12		@ counter+2
+	add		r12,r12,#3	@ counter+3
+	mov		r11,r11,ror#8	@ twist d[0..3]
+	mov		r12,r12,ror#8
+	mov		r10,r10,ror#8
+	mov		r14,r14,ror#8
+	str		r11, [sp,#4*(16+15)]
+	mov		r11,#10
+	b		.Loop_neon
+
+.align	4
+.Loop_neon:
+	subs		r11,r11,#1
+	vadd.i32	q0,q0,q1
+	add	r0,r0,r4,ror#13
+	vadd.i32	q4,q4,q5
+	add	r1,r1,r5,ror#13
+	vadd.i32	q8,q8,q9
+	eor	r12,r0,r12,ror#24
+	veor	q3,q3,q0
+	eor	r10,r1,r10,ror#24
+	veor	q7,q7,q4
+	add	r8,r8,r12,ror#16
+	veor	q11,q11,q8
+	add	r9,r9,r10,ror#16
+	vrev32.16	q3,q3
+	eor	r4,r8,r4,ror#13
+	vrev32.16	q7,q7
+	eor	r5,r9,r5,ror#13
+	vrev32.16	q11,q11
+	add	r0,r0,r4,ror#20
+	vadd.i32	q2,q2,q3
+	add	r1,r1,r5,ror#20
+	vadd.i32	q6,q6,q7
+	eor	r12,r0,r12,ror#16
+	vadd.i32	q10,q10,q11
+	eor	r10,r1,r10,ror#16
+	veor	q12,q1,q2
+	add	r8,r8,r12,ror#24
+	veor	q13,q5,q6
+	str	r10,[sp,#4*(16+13)]
+	veor	q14,q9,q10
+	add	r9,r9,r10,ror#24
+	vshr.u32	q1,q12,#20
+	ldr	r10,[sp,#4*(16+15)]
+	vshr.u32	q5,q13,#20
+	str	r8,[sp,#4*(16+8)]
+	vshr.u32	q9,q14,#20
+	eor	r4,r4,r8,ror#12
+	vsli.32	q1,q12,#12
+	str	r9,[sp,#4*(16+9)]
+	vsli.32	q5,q13,#12
+	eor	r5,r5,r9,ror#12
+	vsli.32	q9,q14,#12
+	ldr	r8,[sp,#4*(16+10)]
+	vadd.i32	q0,q0,q1
+	add	r2,r2,r6,ror#13
+	vadd.i32	q4,q4,q5
+	ldr	r9,[sp,#4*(16+11)]
+	vadd.i32	q8,q8,q9
+	add	r3,r3,r7,ror#13
+	veor	q12,q3,q0
+	eor	r14,r2,r14,ror#24
+	veor	q13,q7,q4
+	eor	r10,r3,r10,ror#24
+	veor	q14,q11,q8
+	add	r8,r8,r14,ror#16
+	vshr.u32	q3,q12,#24
+	add	r9,r9,r10,ror#16
+	vshr.u32	q7,q13,#24
+	eor	r6,r8,r6,ror#13
+	vshr.u32	q11,q14,#24
+	eor	r7,r9,r7,ror#13
+	vsli.32	q3,q12,#8
+	add	r2,r2,r6,ror#20
+	vsli.32	q7,q13,#8
+	add	r3,r3,r7,ror#20
+	vsli.32	q11,q14,#8
+	eor	r14,r2,r14,ror#16
+	vadd.i32	q2,q2,q3
+	eor	r10,r3,r10,ror#16
+	vadd.i32	q6,q6,q7
+	add	r8,r8,r14,ror#24
+	vadd.i32	q10,q10,q11
+	add	r9,r9,r10,ror#24
+	veor	q12,q1,q2
+	eor	r6,r6,r8,ror#12
+	veor	q13,q5,q6
+	eor	r7,r7,r9,ror#12
+	veor	q14,q9,q10
+	vshr.u32	q1,q12,#25
+	vshr.u32	q5,q13,#25
+	vshr.u32	q9,q14,#25
+	vsli.32	q1,q12,#7
+	vsli.32	q5,q13,#7
+	vsli.32	q9,q14,#7
+	vext.8	q2,q2,q2,#8
+	vext.8	q6,q6,q6,#8
+	vext.8	q10,q10,q10,#8
+	vext.8	q1,q1,q1,#4
+	vext.8	q5,q5,q5,#4
+	vext.8	q9,q9,q9,#4
+	vext.8	q3,q3,q3,#12
+	vext.8	q7,q7,q7,#12
+	vext.8	q11,q11,q11,#12
+	vadd.i32	q0,q0,q1
+	add	r0,r0,r5,ror#13
+	vadd.i32	q4,q4,q5
+	add	r1,r1,r6,ror#13
+	vadd.i32	q8,q8,q9
+	eor	r10,r0,r10,ror#24
+	veor	q3,q3,q0
+	eor	r12,r1,r12,ror#24
+	veor	q7,q7,q4
+	add	r8,r8,r10,ror#16
+	veor	q11,q11,q8
+	add	r9,r9,r12,ror#16
+	vrev32.16	q3,q3
+	eor	r5,r8,r5,ror#13
+	vrev32.16	q7,q7
+	eor	r6,r9,r6,ror#13
+	vrev32.16	q11,q11
+	add	r0,r0,r5,ror#20
+	vadd.i32	q2,q2,q3
+	add	r1,r1,r6,ror#20
+	vadd.i32	q6,q6,q7
+	eor	r10,r0,r10,ror#16
+	vadd.i32	q10,q10,q11
+	eor	r12,r1,r12,ror#16
+	veor	q12,q1,q2
+	str	r10,[sp,#4*(16+15)]
+	veor	q13,q5,q6
+	add	r8,r8,r10,ror#24
+	veor	q14,q9,q10
+	ldr	r10,[sp,#4*(16+13)]
+	vshr.u32	q1,q12,#20
+	add	r9,r9,r12,ror#24
+	vshr.u32	q5,q13,#20
+	str	r8,[sp,#4*(16+10)]
+	vshr.u32	q9,q14,#20
+	eor	r5,r5,r8,ror#12
+	vsli.32	q1,q12,#12
+	str	r9,[sp,#4*(16+11)]
+	vsli.32	q5,q13,#12
+	eor	r6,r6,r9,ror#12
+	vsli.32	q9,q14,#12
+	ldr	r8,[sp,#4*(16+8)]
+	vadd.i32	q0,q0,q1
+	add	r2,r2,r7,ror#13
+	vadd.i32	q4,q4,q5
+	ldr	r9,[sp,#4*(16+9)]
+	vadd.i32	q8,q8,q9
+	add	r3,r3,r4,ror#13
+	veor	q12,q3,q0
+	eor	r10,r2,r10,ror#24
+	veor	q13,q7,q4
+	eor	r14,r3,r14,ror#24
+	veor	q14,q11,q8
+	add	r8,r8,r10,ror#16
+	vshr.u32	q3,q12,#24
+	add	r9,r9,r14,ror#16
+	vshr.u32	q7,q13,#24
+	eor	r7,r8,r7,ror#13
+	vshr.u32	q11,q14,#24
+	eor	r4,r9,r4,ror#13
+	vsli.32	q3,q12,#8
+	add	r2,r2,r7,ror#20
+	vsli.32	q7,q13,#8
+	add	r3,r3,r4,ror#20
+	vsli.32	q11,q14,#8
+	eor	r10,r2,r10,ror#16
+	vadd.i32	q2,q2,q3
+	eor	r14,r3,r14,ror#16
+	vadd.i32	q6,q6,q7
+	add	r8,r8,r10,ror#24
+	vadd.i32	q10,q10,q11
+	add	r9,r9,r14,ror#24
+	veor	q12,q1,q2
+	eor	r7,r7,r8,ror#12
+	veor	q13,q5,q6
+	eor	r4,r4,r9,ror#12
+	veor	q14,q9,q10
+	vshr.u32	q1,q12,#25
+	vshr.u32	q5,q13,#25
+	vshr.u32	q9,q14,#25
+	vsli.32	q1,q12,#7
+	vsli.32	q5,q13,#7
+	vsli.32	q9,q14,#7
+	vext.8	q2,q2,q2,#8
+	vext.8	q6,q6,q6,#8
+	vext.8	q10,q10,q10,#8
+	vext.8	q1,q1,q1,#12
+	vext.8	q5,q5,q5,#12
+	vext.8	q9,q9,q9,#12
+	vext.8	q3,q3,q3,#4
+	vext.8	q7,q7,q7,#4
+	vext.8	q11,q11,q11,#4
+	bne		.Loop_neon
+
+	add		r11,sp,#32
+	vld1.32		{q12-q13},[sp]		@ load key material
+	vld1.32		{q14-q15},[r11]
+
+	ldr		r11,[sp,#4*(32+2)]	@ load len
+
+	str		r8, [sp,#4*(16+8)]	@ modulo-scheduled store
+	str		r9, [sp,#4*(16+9)]
+	str		r12,[sp,#4*(16+12)]
+	str		r10, [sp,#4*(16+13)]
+	str		r14,[sp,#4*(16+14)]
+
+	@ at this point we have first half of 512-bit result in
+	@ rx and second half at sp+4*(16+8)
+
+	ldr		r12,[sp,#4*(32+1)]	@ load inp
+	ldr		r14,[sp,#4*(32+0)]	@ load out
+
+	vadd.i32	q0,q0,q12		@ accumulate key material
+	vadd.i32	q4,q4,q12
+	vadd.i32	q8,q8,q12
+	vldr		d24,[sp,#4*(16+0)]	@ one
+
+	vadd.i32	q1,q1,q13
+	vadd.i32	q5,q5,q13
+	vadd.i32	q9,q9,q13
+	vldr		d26,[sp,#4*(16+2)]	@ two
+
+	vadd.i32	q2,q2,q14
+	vadd.i32	q6,q6,q14
+	vadd.i32	q10,q10,q14
+	vadd.i32	d14,d14,d24	@ counter+1
+	vadd.i32	d22,d22,d26	@ counter+2
+
+	vadd.i32	q3,q3,q15
+	vadd.i32	q7,q7,q15
+	vadd.i32	q11,q11,q15
+
+	cmp		r11,#64*4
+	blo		.Ltail_neon
+
+	vld1.8		{q12-q13},[r12]!	@ load input
+	 mov		r11,sp
+	vld1.8		{q14-q15},[r12]!
+	veor		q0,q0,q12		@ xor with input
+	veor		q1,q1,q13
+	vld1.8		{q12-q13},[r12]!
+	veor		q2,q2,q14
+	veor		q3,q3,q15
+	vld1.8		{q14-q15},[r12]!
+
+	veor		q4,q4,q12
+	 vst1.8		{q0-q1},[r14]!	@ store output
+	veor		q5,q5,q13
+	vld1.8		{q12-q13},[r12]!
+	veor		q6,q6,q14
+	 vst1.8		{q2-q3},[r14]!
+	veor		q7,q7,q15
+	vld1.8		{q14-q15},[r12]!
+
+	veor		q8,q8,q12
+	 vld1.32	{q0-q1},[r11]!	@ load for next iteration
+	 veor		d25,d25,d25
+	 vldr		d24,[sp,#4*(16+4)]	@ four
+	veor		q9,q9,q13
+	 vld1.32	{q2-q3},[r11]
+	veor		q10,q10,q14
+	 vst1.8		{q4-q5},[r14]!
+	veor		q11,q11,q15
+	 vst1.8		{q6-q7},[r14]!
+
+	vadd.i32	d6,d6,d24	@ next counter value
+	vldr		d24,[sp,#4*(16+0)]	@ one
+
+	ldmia		sp,{r8-r11}	@ load key material
+	add		r0,r0,r8	@ accumulate key material
+	ldr		r8,[r12],#16		@ load input
+	 vst1.8		{q8-q9},[r14]!
+	add		r1,r1,r9
+	ldr		r9,[r12,#-12]
+	 vst1.8		{q10-q11},[r14]!
+	add		r2,r2,r10
+	ldr		r10,[r12,#-8]
+	add		r3,r3,r11
+	ldr		r11,[r12,#-4]
+# ifdef	__ARMEB__
+	rev		r0,r0
+	rev		r1,r1
+	rev		r2,r2
+	rev		r3,r3
+# endif
+	eor		r0,r0,r8	@ xor with input
+	 add		r8,sp,#4*(4)
+	eor		r1,r1,r9
+	str		r0,[r14],#16		@ store output
+	eor		r2,r2,r10
+	str		r1,[r14,#-12]
+	eor		r3,r3,r11
+	 ldmia		r8,{r8-r11}	@ load key material
+	str		r2,[r14,#-8]
+	str		r3,[r14,#-4]
+
+	add		r4,r8,r4,ror#13 @ accumulate key material
+	ldr		r8,[r12],#16		@ load input
+	add		r5,r9,r5,ror#13
+	ldr		r9,[r12,#-12]
+	add		r6,r10,r6,ror#13
+	ldr		r10,[r12,#-8]
+	add		r7,r11,r7,ror#13
+	ldr		r11,[r12,#-4]
+# ifdef	__ARMEB__
+	rev		r4,r4
+	rev		r5,r5
+	rev		r6,r6
+	rev		r7,r7
+# endif
+	eor		r4,r4,r8
+	 add		r8,sp,#4*(8)
+	eor		r5,r5,r9
+	str		r4,[r14],#16		@ store output
+	eor		r6,r6,r10
+	str		r5,[r14,#-12]
+	eor		r7,r7,r11
+	 ldmia		r8,{r8-r11}	@ load key material
+	str		r6,[r14,#-8]
+	 add		r0,sp,#4*(16+8)
+	str		r7,[r14,#-4]
+
+	ldmia		r0,{r0-r7}	@ load second half
+
+	add		r0,r0,r8	@ accumulate key material
+	ldr		r8,[r12],#16		@ load input
+	add		r1,r1,r9
+	ldr		r9,[r12,#-12]
+# ifdef	__thumb2__
+	it	hi
+# endif
+	 strhi		r10,[sp,#4*(16+10)]	@ copy "rx" while at it
+	add		r2,r2,r10
+	ldr		r10,[r12,#-8]
+# ifdef	__thumb2__
+	it	hi
+# endif
+	 strhi		r11,[sp,#4*(16+11)]	@ copy "rx" while at it
+	add		r3,r3,r11
+	ldr		r11,[r12,#-4]
+# ifdef	__ARMEB__
+	rev		r0,r0
+	rev		r1,r1
+	rev		r2,r2
+	rev		r3,r3
+# endif
+	eor		r0,r0,r8
+	 add		r8,sp,#4*(12)
+	eor		r1,r1,r9
+	str		r0,[r14],#16		@ store output
+	eor		r2,r2,r10
+	str		r1,[r14,#-12]
+	eor		r3,r3,r11
+	 ldmia		r8,{r8-r11}	@ load key material
+	str		r2,[r14,#-8]
+	str		r3,[r14,#-4]
+
+	add		r4,r8,r4,ror#24 @ accumulate key material
+	 add		r8,r8,#4		@ next counter value
+	add		r5,r9,r5,ror#24
+	 str		r8,[sp,#4*(12)]	@ save next counter value
+	ldr		r8,[r12],#16		@ load input
+	add		r6,r10,r6,ror#24
+	 add		r4,r4,#3		@ counter+3
+	ldr		r9,[r12,#-12]
+	add		r7,r11,r7,ror#24
+	ldr		r10,[r12,#-8]
+	ldr		r11,[r12,#-4]
+# ifdef	__ARMEB__
+	rev		r4,r4
+	rev		r5,r5
+	rev		r6,r6
+	rev		r7,r7
+# endif
+	eor		r4,r4,r8
+# ifdef	__thumb2__
+	it	hi
+# endif
+	 ldrhi		r8,[sp,#4*(32+2)]	@ re-load len
+	eor		r5,r5,r9
+	eor		r6,r6,r10
+	str		r4,[r14],#16		@ store output
+	eor		r7,r7,r11
+	str		r5,[r14,#-12]
+	 sub		r11,r8,#64*4	@ len-=64*4
+	str		r6,[r14,#-8]
+	str		r7,[r14,#-4]
+	bhi		.Loop_neon_outer
+
+	b		.Ldone_neon
+
+.align	4
+.Lbreak_neon:
+	@ harmonize NEON and integer-only stack frames: load data
+	@ from NEON frame, but save to integer-only one; distance
+	@ between the two is 4*(32+4+16-32)=4*(20).
+
+	str		r11, [sp,#4*(20+32+2)]	@ save len
+	 add		r11,sp,#4*(32+4)
+	str		r12,   [sp,#4*(20+32+1)]	@ save inp
+	str		r14,   [sp,#4*(20+32+0)]	@ save out
+
+	ldr		r12,[sp,#4*(16+10)]
+	ldr		r14,[sp,#4*(16+11)]
+	 vldmia		r11,{d8-d15}			@ fulfill ABI requirement
+	str		r12,[sp,#4*(20+16+10)]	@ copy "rx"
+	str		r14,[sp,#4*(20+16+11)]	@ copy "rx"
+
+	ldr		r11, [sp,#4*(15)]
+	 mov		r4,r4,ror#19		@ twist b[0..3]
+	ldr		r12,[sp,#4*(12)]		@ modulo-scheduled load
+	 mov		r5,r5,ror#19
+	ldr		r10, [sp,#4*(13)]
+	 mov		r6,r6,ror#19
+	ldr		r14,[sp,#4*(14)]
+	 mov		r7,r7,ror#19
+	mov		r11,r11,ror#8		@ twist d[0..3]
+	mov		r12,r12,ror#8
+	mov		r10,r10,ror#8
+	mov		r14,r14,ror#8
+	str		r11, [sp,#4*(20+16+15)]
+	add		r11,sp,#4*(20)
+	vst1.32		{q0-q1},[r11]!		@ copy key
+	add		sp,sp,#4*(20)			@ switch frame
+	vst1.32		{q2-q3},[r11]
+	mov		r11,#10
+	b		.Loop				@ go integer-only
+
+.align	4
+.Ltail_neon:
+	cmp		r11,#64*3
+	bhs		.L192_or_more_neon
+	cmp		r11,#64*2
+	bhs		.L128_or_more_neon
+	cmp		r11,#64*1
+	bhs		.L64_or_more_neon
+
+	add		r8,sp,#4*(8)
+	vst1.8		{q0-q1},[sp]
+	add		r10,sp,#4*(0)
+	vst1.8		{q2-q3},[r8]
+	b		.Loop_tail_neon
+
+.align	4
+.L64_or_more_neon:
+	vld1.8		{q12-q13},[r12]!
+	vld1.8		{q14-q15},[r12]!
+	veor		q0,q0,q12
+	veor		q1,q1,q13
+	veor		q2,q2,q14
+	veor		q3,q3,q15
+	vst1.8		{q0-q1},[r14]!
+	vst1.8		{q2-q3},[r14]!
+
+	beq		.Ldone_neon
+
+	add		r8,sp,#4*(8)
+	vst1.8		{q4-q5},[sp]
+	add		r10,sp,#4*(0)
+	vst1.8		{q6-q7},[r8]
+	sub		r11,r11,#64*1	@ len-=64*1
+	b		.Loop_tail_neon
+
+.align	4
+.L128_or_more_neon:
+	vld1.8		{q12-q13},[r12]!
+	vld1.8		{q14-q15},[r12]!
+	veor		q0,q0,q12
+	veor		q1,q1,q13
+	vld1.8		{q12-q13},[r12]!
+	veor		q2,q2,q14
+	veor		q3,q3,q15
+	vld1.8		{q14-q15},[r12]!
+
+	veor		q4,q4,q12
+	veor		q5,q5,q13
+	 vst1.8		{q0-q1},[r14]!
+	veor		q6,q6,q14
+	 vst1.8		{q2-q3},[r14]!
+	veor		q7,q7,q15
+	vst1.8		{q4-q5},[r14]!
+	vst1.8		{q6-q7},[r14]!
+
+	beq		.Ldone_neon
+
+	add		r8,sp,#4*(8)
+	vst1.8		{q8-q9},[sp]
+	add		r10,sp,#4*(0)
+	vst1.8		{q10-q11},[r8]
+	sub		r11,r11,#64*2	@ len-=64*2
+	b		.Loop_tail_neon
+
+.align	4
+.L192_or_more_neon:
+	vld1.8		{q12-q13},[r12]!
+	vld1.8		{q14-q15},[r12]!
+	veor		q0,q0,q12
+	veor		q1,q1,q13
+	vld1.8		{q12-q13},[r12]!
+	veor		q2,q2,q14
+	veor		q3,q3,q15
+	vld1.8		{q14-q15},[r12]!
+
+	veor		q4,q4,q12
+	veor		q5,q5,q13
+	vld1.8		{q12-q13},[r12]!
+	veor		q6,q6,q14
+	 vst1.8		{q0-q1},[r14]!
+	veor		q7,q7,q15
+	vld1.8		{q14-q15},[r12]!
+
+	veor		q8,q8,q12
+	 vst1.8		{q2-q3},[r14]!
+	veor		q9,q9,q13
+	 vst1.8		{q4-q5},[r14]!
+	veor		q10,q10,q14
+	 vst1.8		{q6-q7},[r14]!
+	veor		q11,q11,q15
+	vst1.8		{q8-q9},[r14]!
+	vst1.8		{q10-q11},[r14]!
+
+	beq		.Ldone_neon
+
+	ldmia		sp,{r8-r11}	@ load key material
+	add		r0,r0,r8	@ accumulate key material
+	 add		r8,sp,#4*(4)
+	add		r1,r1,r9
+	add		r2,r2,r10
+	add		r3,r3,r11
+	 ldmia		r8,{r8-r11}	@ load key material
+
+	add		r4,r8,r4,ror#13 @ accumulate key material
+	 add		r8,sp,#4*(8)
+	add		r5,r9,r5,ror#13
+	add		r6,r10,r6,ror#13
+	add		r7,r11,r7,ror#13
+	 ldmia		r8,{r8-r11}	@ load key material
+# ifdef	__ARMEB__
+	rev		r0,r0
+	rev		r1,r1
+	rev		r2,r2
+	rev		r3,r3
+	rev		r4,r4
+	rev		r5,r5
+	rev		r6,r6
+	rev		r7,r7
+# endif
+	stmia		sp,{r0-r7}
+	 add		r0,sp,#4*(16+8)
+
+	ldmia		r0,{r0-r7}	@ load second half
+
+	add		r0,r0,r8	@ accumulate key material
+	 add		r8,sp,#4*(12)
+	add		r1,r1,r9
+	add		r2,r2,r10
+	add		r3,r3,r11
+	 ldmia		r8,{r8-r11}	@ load key material
+
+	add		r4,r8,r4,ror#24 @ accumulate key material
+	 add		r8,sp,#4*(8)
+	add		r5,r9,r5,ror#24
+	 add		r4,r4,#3		@ counter+3
+	add		r6,r10,r6,ror#24
+	add		r7,r11,r7,ror#24
+	 ldr		r11,[sp,#4*(32+2)]	@ re-load len
+# ifdef	__ARMEB__
+	rev		r0,r0
+	rev		r1,r1
+	rev		r2,r2
+	rev		r3,r3
+	rev		r4,r4
+	rev		r5,r5
+	rev		r6,r6
+	rev		r7,r7
+# endif
+	stmia		r8,{r0-r7}
+	 add		r10,sp,#4*(0)
+	 sub		r11,r11,#64*3	@ len-=64*3
+
+.Loop_tail_neon:
+	ldrb		r8,[r10],#1	@ read buffer on stack
+	ldrb		r9,[r12],#1		@ read input
+	subs		r11,r11,#1
+	eor		r8,r8,r9
+	strb		r8,[r14],#1		@ store output
+	bne		.Loop_tail_neon
+
+.Ldone_neon:
+	add		sp,sp,#4*(32+4)
+	vldmia		sp,{d8-d15}
+	add		sp,sp,#4*(16+3)
+	ldmia		sp!,{r4-r11,pc}
+.size	ChaCha20_neon,.-ChaCha20_neon
+.comm	OPENSSL_armcap_P,4,4
+#endif
diff --git a/lib/zinc/chacha20/chacha20-arm64-cryptogams.S b/lib/zinc/chacha20/chacha20-arm64-cryptogams.S
new file mode 100644
index 000000000000..4d029bfdad3a
--- /dev/null
+++ b/lib/zinc/chacha20/chacha20-arm64-cryptogams.S
@@ -0,0 +1,1973 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/*
+ * Copyright (C) 2006-2017 CRYPTOGAMS by <appro@openssl.org>. All Rights Reserved.
+ */
+
+#include "arm_arch.h"
+
+.text
+
+
+
+.align	5
+.Lsigma:
+.quad	0x3320646e61707865,0x6b20657479622d32		// endian-neutral
+.Lone:
+.long	1,0,0,0
+.LOPENSSL_armcap_P:
+#ifdef	__ILP32__
+.long	OPENSSL_armcap_P-.
+#else
+.quad	OPENSSL_armcap_P-.
+#endif
+.byte	67,104,97,67,104,97,50,48,32,102,111,114,32,65,82,77,118,56,44,32,67,82,89,80,84,79,71,65,77,83,32,98,121,32,60,97,112,112,114,111,64,111,112,101,110,115,115,108,46,111,114,103,62,0
+.align	2
+
+.globl	ChaCha20_ctr32
+.type	ChaCha20_ctr32,%function
+.align	5
+ChaCha20_ctr32:
+	cbz	x2,.Labort
+	adr	x5,.LOPENSSL_armcap_P
+	cmp	x2,#192
+	b.lo	.Lshort
+#ifdef	__ILP32__
+	ldrsw	x6,[x5]
+#else
+	ldr	x6,[x5]
+#endif
+	ldr	w17,[x6,x5]
+	tst	w17,#ARMV7_NEON
+	b.ne	ChaCha20_neon
+
+.Lshort:
+	stp	x29,x30,[sp,#-96]!
+	add	x29,sp,#0
+
+	adr	x5,.Lsigma
+	stp	x19,x20,[sp,#16]
+	stp	x21,x22,[sp,#32]
+	stp	x23,x24,[sp,#48]
+	stp	x25,x26,[sp,#64]
+	stp	x27,x28,[sp,#80]
+	sub	sp,sp,#64
+
+	ldp	x22,x23,[x5]		// load sigma
+	ldp	x24,x25,[x3]		// load key
+	ldp	x26,x27,[x3,#16]
+	ldp	x28,x30,[x4]		// load counter
+#ifdef	__ARMEB__
+	ror	x24,x24,#32
+	ror	x25,x25,#32
+	ror	x26,x26,#32
+	ror	x27,x27,#32
+	ror	x28,x28,#32
+	ror	x30,x30,#32
+#endif
+
+.Loop_outer:
+	mov	w5,w22			// unpack key block
+	lsr	x6,x22,#32
+	mov	w7,w23
+	lsr	x8,x23,#32
+	mov	w9,w24
+	lsr	x10,x24,#32
+	mov	w11,w25
+	lsr	x12,x25,#32
+	mov	w13,w26
+	lsr	x14,x26,#32
+	mov	w15,w27
+	lsr	x16,x27,#32
+	mov	w17,w28
+	lsr	x19,x28,#32
+	mov	w20,w30
+	lsr	x21,x30,#32
+
+	mov	x4,#10
+	subs	x2,x2,#64
+.Loop:
+	sub	x4,x4,#1
+	add	w5,w5,w9
+	add	w6,w6,w10
+	add	w7,w7,w11
+	add	w8,w8,w12
+	eor	w17,w17,w5
+	eor	w19,w19,w6
+	eor	w20,w20,w7
+	eor	w21,w21,w8
+	ror	w17,w17,#16
+	ror	w19,w19,#16
+	ror	w20,w20,#16
+	ror	w21,w21,#16
+	add	w13,w13,w17
+	add	w14,w14,w19
+	add	w15,w15,w20
+	add	w16,w16,w21
+	eor	w9,w9,w13
+	eor	w10,w10,w14
+	eor	w11,w11,w15
+	eor	w12,w12,w16
+	ror	w9,w9,#20
+	ror	w10,w10,#20
+	ror	w11,w11,#20
+	ror	w12,w12,#20
+	add	w5,w5,w9
+	add	w6,w6,w10
+	add	w7,w7,w11
+	add	w8,w8,w12
+	eor	w17,w17,w5
+	eor	w19,w19,w6
+	eor	w20,w20,w7
+	eor	w21,w21,w8
+	ror	w17,w17,#24
+	ror	w19,w19,#24
+	ror	w20,w20,#24
+	ror	w21,w21,#24
+	add	w13,w13,w17
+	add	w14,w14,w19
+	add	w15,w15,w20
+	add	w16,w16,w21
+	eor	w9,w9,w13
+	eor	w10,w10,w14
+	eor	w11,w11,w15
+	eor	w12,w12,w16
+	ror	w9,w9,#25
+	ror	w10,w10,#25
+	ror	w11,w11,#25
+	ror	w12,w12,#25
+	add	w5,w5,w10
+	add	w6,w6,w11
+	add	w7,w7,w12
+	add	w8,w8,w9
+	eor	w21,w21,w5
+	eor	w17,w17,w6
+	eor	w19,w19,w7
+	eor	w20,w20,w8
+	ror	w21,w21,#16
+	ror	w17,w17,#16
+	ror	w19,w19,#16
+	ror	w20,w20,#16
+	add	w15,w15,w21
+	add	w16,w16,w17
+	add	w13,w13,w19
+	add	w14,w14,w20
+	eor	w10,w10,w15
+	eor	w11,w11,w16
+	eor	w12,w12,w13
+	eor	w9,w9,w14
+	ror	w10,w10,#20
+	ror	w11,w11,#20
+	ror	w12,w12,#20
+	ror	w9,w9,#20
+	add	w5,w5,w10
+	add	w6,w6,w11
+	add	w7,w7,w12
+	add	w8,w8,w9
+	eor	w21,w21,w5
+	eor	w17,w17,w6
+	eor	w19,w19,w7
+	eor	w20,w20,w8
+	ror	w21,w21,#24
+	ror	w17,w17,#24
+	ror	w19,w19,#24
+	ror	w20,w20,#24
+	add	w15,w15,w21
+	add	w16,w16,w17
+	add	w13,w13,w19
+	add	w14,w14,w20
+	eor	w10,w10,w15
+	eor	w11,w11,w16
+	eor	w12,w12,w13
+	eor	w9,w9,w14
+	ror	w10,w10,#25
+	ror	w11,w11,#25
+	ror	w12,w12,#25
+	ror	w9,w9,#25
+	cbnz	x4,.Loop
+
+	add	w5,w5,w22		// accumulate key block
+	add	x6,x6,x22,lsr#32
+	add	w7,w7,w23
+	add	x8,x8,x23,lsr#32
+	add	w9,w9,w24
+	add	x10,x10,x24,lsr#32
+	add	w11,w11,w25
+	add	x12,x12,x25,lsr#32
+	add	w13,w13,w26
+	add	x14,x14,x26,lsr#32
+	add	w15,w15,w27
+	add	x16,x16,x27,lsr#32
+	add	w17,w17,w28
+	add	x19,x19,x28,lsr#32
+	add	w20,w20,w30
+	add	x21,x21,x30,lsr#32
+
+	b.lo	.Ltail
+
+	add	x5,x5,x6,lsl#32	// pack
+	add	x7,x7,x8,lsl#32
+	ldp	x6,x8,[x1,#0]		// load input
+	add	x9,x9,x10,lsl#32
+	add	x11,x11,x12,lsl#32
+	ldp	x10,x12,[x1,#16]
+	add	x13,x13,x14,lsl#32
+	add	x15,x15,x16,lsl#32
+	ldp	x14,x16,[x1,#32]
+	add	x17,x17,x19,lsl#32
+	add	x20,x20,x21,lsl#32
+	ldp	x19,x21,[x1,#48]
+	add	x1,x1,#64
+#ifdef	__ARMEB__
+	rev	x5,x5
+	rev	x7,x7
+	rev	x9,x9
+	rev	x11,x11
+	rev	x13,x13
+	rev	x15,x15
+	rev	x17,x17
+	rev	x20,x20
+#endif
+	eor	x5,x5,x6
+	eor	x7,x7,x8
+	eor	x9,x9,x10
+	eor	x11,x11,x12
+	eor	x13,x13,x14
+	eor	x15,x15,x16
+	eor	x17,x17,x19
+	eor	x20,x20,x21
+
+	stp	x5,x7,[x0,#0]		// store output
+	add	x28,x28,#1			// increment counter
+	stp	x9,x11,[x0,#16]
+	stp	x13,x15,[x0,#32]
+	stp	x17,x20,[x0,#48]
+	add	x0,x0,#64
+
+	b.hi	.Loop_outer
+
+	ldp	x19,x20,[x29,#16]
+	add	sp,sp,#64
+	ldp	x21,x22,[x29,#32]
+	ldp	x23,x24,[x29,#48]
+	ldp	x25,x26,[x29,#64]
+	ldp	x27,x28,[x29,#80]
+	ldp	x29,x30,[sp],#96
+.Labort:
+	ret
+
+.align	4
+.Ltail:
+	add	x2,x2,#64
+.Less_than_64:
+	sub	x0,x0,#1
+	add	x1,x1,x2
+	add	x0,x0,x2
+	add	x4,sp,x2
+	neg	x2,x2
+
+	add	x5,x5,x6,lsl#32	// pack
+	add	x7,x7,x8,lsl#32
+	add	x9,x9,x10,lsl#32
+	add	x11,x11,x12,lsl#32
+	add	x13,x13,x14,lsl#32
+	add	x15,x15,x16,lsl#32
+	add	x17,x17,x19,lsl#32
+	add	x20,x20,x21,lsl#32
+#ifdef	__ARMEB__
+	rev	x5,x5
+	rev	x7,x7
+	rev	x9,x9
+	rev	x11,x11
+	rev	x13,x13
+	rev	x15,x15
+	rev	x17,x17
+	rev	x20,x20
+#endif
+	stp	x5,x7,[sp,#0]
+	stp	x9,x11,[sp,#16]
+	stp	x13,x15,[sp,#32]
+	stp	x17,x20,[sp,#48]
+
+.Loop_tail:
+	ldrb	w10,[x1,x2]
+	ldrb	w11,[x4,x2]
+	add	x2,x2,#1
+	eor	w10,w10,w11
+	strb	w10,[x0,x2]
+	cbnz	x2,.Loop_tail
+
+	stp	xzr,xzr,[sp,#0]
+	stp	xzr,xzr,[sp,#16]
+	stp	xzr,xzr,[sp,#32]
+	stp	xzr,xzr,[sp,#48]
+
+	ldp	x19,x20,[x29,#16]
+	add	sp,sp,#64
+	ldp	x21,x22,[x29,#32]
+	ldp	x23,x24,[x29,#48]
+	ldp	x25,x26,[x29,#64]
+	ldp	x27,x28,[x29,#80]
+	ldp	x29,x30,[sp],#96
+	ret
+.size	ChaCha20_ctr32,.-ChaCha20_ctr32
+
+.type	ChaCha20_neon,%function
+.align	5
+ChaCha20_neon:
+	stp	x29,x30,[sp,#-96]!
+	add	x29,sp,#0
+
+	adr	x5,.Lsigma
+	stp	x19,x20,[sp,#16]
+	stp	x21,x22,[sp,#32]
+	stp	x23,x24,[sp,#48]
+	stp	x25,x26,[sp,#64]
+	stp	x27,x28,[sp,#80]
+	cmp	x2,#512
+	b.hs	.L512_or_more_neon
+
+	sub	sp,sp,#64
+
+	ldp	x22,x23,[x5]		// load sigma
+	ld1	{v24.4s},[x5],#16
+	ldp	x24,x25,[x3]		// load key
+	ldp	x26,x27,[x3,#16]
+	ld1	{v25.4s,v26.4s},[x3]
+	ldp	x28,x30,[x4]		// load counter
+	ld1	{v27.4s},[x4]
+	ld1	{v31.4s},[x5]
+#ifdef	__ARMEB__
+	rev64	v24.4s,v24.4s
+	ror	x24,x24,#32
+	ror	x25,x25,#32
+	ror	x26,x26,#32
+	ror	x27,x27,#32
+	ror	x28,x28,#32
+	ror	x30,x30,#32
+#endif
+	add	v27.4s,v27.4s,v31.4s		// += 1
+	add	v28.4s,v27.4s,v31.4s
+	add	v29.4s,v28.4s,v31.4s
+	shl	v31.4s,v31.4s,#2			// 1 -> 4
+
+.Loop_outer_neon:
+	mov	w5,w22			// unpack key block
+	lsr	x6,x22,#32
+	mov	v0.16b,v24.16b
+	mov	w7,w23
+	lsr	x8,x23,#32
+	mov	v4.16b,v24.16b
+	mov	w9,w24
+	lsr	x10,x24,#32
+	mov	v16.16b,v24.16b
+	mov	w11,w25
+	mov	v1.16b,v25.16b
+	lsr	x12,x25,#32
+	mov	v5.16b,v25.16b
+	mov	w13,w26
+	mov	v17.16b,v25.16b
+	lsr	x14,x26,#32
+	mov	v3.16b,v27.16b
+	mov	w15,w27
+	mov	v7.16b,v28.16b
+	lsr	x16,x27,#32
+	mov	v19.16b,v29.16b
+	mov	w17,w28
+	mov	v2.16b,v26.16b
+	lsr	x19,x28,#32
+	mov	v6.16b,v26.16b
+	mov	w20,w30
+	mov	v18.16b,v26.16b
+	lsr	x21,x30,#32
+
+	mov	x4,#10
+	subs	x2,x2,#256
+.Loop_neon:
+	sub	x4,x4,#1
+	add	v0.4s,v0.4s,v1.4s
+	add	w5,w5,w9
+	add	v4.4s,v4.4s,v5.4s
+	add	w6,w6,w10
+	add	v16.4s,v16.4s,v17.4s
+	add	w7,w7,w11
+	eor	v3.16b,v3.16b,v0.16b
+	add	w8,w8,w12
+	eor	v7.16b,v7.16b,v4.16b
+	eor	w17,w17,w5
+	eor	v19.16b,v19.16b,v16.16b
+	eor	w19,w19,w6
+	rev32	v3.8h,v3.8h
+	eor	w20,w20,w7
+	rev32	v7.8h,v7.8h
+	eor	w21,w21,w8
+	rev32	v19.8h,v19.8h
+	ror	w17,w17,#16
+	add	v2.4s,v2.4s,v3.4s
+	ror	w19,w19,#16
+	add	v6.4s,v6.4s,v7.4s
+	ror	w20,w20,#16
+	add	v18.4s,v18.4s,v19.4s
+	ror	w21,w21,#16
+	eor	v20.16b,v1.16b,v2.16b
+	add	w13,w13,w17
+	eor	v21.16b,v5.16b,v6.16b
+	add	w14,w14,w19
+	eor	v22.16b,v17.16b,v18.16b
+	add	w15,w15,w20
+	ushr	v1.4s,v20.4s,#20
+	add	w16,w16,w21
+	ushr	v5.4s,v21.4s,#20
+	eor	w9,w9,w13
+	ushr	v17.4s,v22.4s,#20
+	eor	w10,w10,w14
+	sli	v1.4s,v20.4s,#12
+	eor	w11,w11,w15
+	sli	v5.4s,v21.4s,#12
+	eor	w12,w12,w16
+	sli	v17.4s,v22.4s,#12
+	ror	w9,w9,#20
+	add	v0.4s,v0.4s,v1.4s
+	ror	w10,w10,#20
+	add	v4.4s,v4.4s,v5.4s
+	ror	w11,w11,#20
+	add	v16.4s,v16.4s,v17.4s
+	ror	w12,w12,#20
+	eor	v20.16b,v3.16b,v0.16b
+	add	w5,w5,w9
+	eor	v21.16b,v7.16b,v4.16b
+	add	w6,w6,w10
+	eor	v22.16b,v19.16b,v16.16b
+	add	w7,w7,w11
+	ushr	v3.4s,v20.4s,#24
+	add	w8,w8,w12
+	ushr	v7.4s,v21.4s,#24
+	eor	w17,w17,w5
+	ushr	v19.4s,v22.4s,#24
+	eor	w19,w19,w6
+	sli	v3.4s,v20.4s,#8
+	eor	w20,w20,w7
+	sli	v7.4s,v21.4s,#8
+	eor	w21,w21,w8
+	sli	v19.4s,v22.4s,#8
+	ror	w17,w17,#24
+	add	v2.4s,v2.4s,v3.4s
+	ror	w19,w19,#24
+	add	v6.4s,v6.4s,v7.4s
+	ror	w20,w20,#24
+	add	v18.4s,v18.4s,v19.4s
+	ror	w21,w21,#24
+	eor	v20.16b,v1.16b,v2.16b
+	add	w13,w13,w17
+	eor	v21.16b,v5.16b,v6.16b
+	add	w14,w14,w19
+	eor	v22.16b,v17.16b,v18.16b
+	add	w15,w15,w20
+	ushr	v1.4s,v20.4s,#25
+	add	w16,w16,w21
+	ushr	v5.4s,v21.4s,#25
+	eor	w9,w9,w13
+	ushr	v17.4s,v22.4s,#25
+	eor	w10,w10,w14
+	sli	v1.4s,v20.4s,#7
+	eor	w11,w11,w15
+	sli	v5.4s,v21.4s,#7
+	eor	w12,w12,w16
+	sli	v17.4s,v22.4s,#7
+	ror	w9,w9,#25
+	ext	v2.16b,v2.16b,v2.16b,#8
+	ror	w10,w10,#25
+	ext	v6.16b,v6.16b,v6.16b,#8
+	ror	w11,w11,#25
+	ext	v18.16b,v18.16b,v18.16b,#8
+	ror	w12,w12,#25
+	ext	v3.16b,v3.16b,v3.16b,#12
+	ext	v7.16b,v7.16b,v7.16b,#12
+	ext	v19.16b,v19.16b,v19.16b,#12
+	ext	v1.16b,v1.16b,v1.16b,#4
+	ext	v5.16b,v5.16b,v5.16b,#4
+	ext	v17.16b,v17.16b,v17.16b,#4
+	add	v0.4s,v0.4s,v1.4s
+	add	w5,w5,w10
+	add	v4.4s,v4.4s,v5.4s
+	add	w6,w6,w11
+	add	v16.4s,v16.4s,v17.4s
+	add	w7,w7,w12
+	eor	v3.16b,v3.16b,v0.16b
+	add	w8,w8,w9
+	eor	v7.16b,v7.16b,v4.16b
+	eor	w21,w21,w5
+	eor	v19.16b,v19.16b,v16.16b
+	eor	w17,w17,w6
+	rev32	v3.8h,v3.8h
+	eor	w19,w19,w7
+	rev32	v7.8h,v7.8h
+	eor	w20,w20,w8
+	rev32	v19.8h,v19.8h
+	ror	w21,w21,#16
+	add	v2.4s,v2.4s,v3.4s
+	ror	w17,w17,#16
+	add	v6.4s,v6.4s,v7.4s
+	ror	w19,w19,#16
+	add	v18.4s,v18.4s,v19.4s
+	ror	w20,w20,#16
+	eor	v20.16b,v1.16b,v2.16b
+	add	w15,w15,w21
+	eor	v21.16b,v5.16b,v6.16b
+	add	w16,w16,w17
+	eor	v22.16b,v17.16b,v18.16b
+	add	w13,w13,w19
+	ushr	v1.4s,v20.4s,#20
+	add	w14,w14,w20
+	ushr	v5.4s,v21.4s,#20
+	eor	w10,w10,w15
+	ushr	v17.4s,v22.4s,#20
+	eor	w11,w11,w16
+	sli	v1.4s,v20.4s,#12
+	eor	w12,w12,w13
+	sli	v5.4s,v21.4s,#12
+	eor	w9,w9,w14
+	sli	v17.4s,v22.4s,#12
+	ror	w10,w10,#20
+	add	v0.4s,v0.4s,v1.4s
+	ror	w11,w11,#20
+	add	v4.4s,v4.4s,v5.4s
+	ror	w12,w12,#20
+	add	v16.4s,v16.4s,v17.4s
+	ror	w9,w9,#20
+	eor	v20.16b,v3.16b,v0.16b
+	add	w5,w5,w10
+	eor	v21.16b,v7.16b,v4.16b
+	add	w6,w6,w11
+	eor	v22.16b,v19.16b,v16.16b
+	add	w7,w7,w12
+	ushr	v3.4s,v20.4s,#24
+	add	w8,w8,w9
+	ushr	v7.4s,v21.4s,#24
+	eor	w21,w21,w5
+	ushr	v19.4s,v22.4s,#24
+	eor	w17,w17,w6
+	sli	v3.4s,v20.4s,#8
+	eor	w19,w19,w7
+	sli	v7.4s,v21.4s,#8
+	eor	w20,w20,w8
+	sli	v19.4s,v22.4s,#8
+	ror	w21,w21,#24
+	add	v2.4s,v2.4s,v3.4s
+	ror	w17,w17,#24
+	add	v6.4s,v6.4s,v7.4s
+	ror	w19,w19,#24
+	add	v18.4s,v18.4s,v19.4s
+	ror	w20,w20,#24
+	eor	v20.16b,v1.16b,v2.16b
+	add	w15,w15,w21
+	eor	v21.16b,v5.16b,v6.16b
+	add	w16,w16,w17
+	eor	v22.16b,v17.16b,v18.16b
+	add	w13,w13,w19
+	ushr	v1.4s,v20.4s,#25
+	add	w14,w14,w20
+	ushr	v5.4s,v21.4s,#25
+	eor	w10,w10,w15
+	ushr	v17.4s,v22.4s,#25
+	eor	w11,w11,w16
+	sli	v1.4s,v20.4s,#7
+	eor	w12,w12,w13
+	sli	v5.4s,v21.4s,#7
+	eor	w9,w9,w14
+	sli	v17.4s,v22.4s,#7
+	ror	w10,w10,#25
+	ext	v2.16b,v2.16b,v2.16b,#8
+	ror	w11,w11,#25
+	ext	v6.16b,v6.16b,v6.16b,#8
+	ror	w12,w12,#25
+	ext	v18.16b,v18.16b,v18.16b,#8
+	ror	w9,w9,#25
+	ext	v3.16b,v3.16b,v3.16b,#4
+	ext	v7.16b,v7.16b,v7.16b,#4
+	ext	v19.16b,v19.16b,v19.16b,#4
+	ext	v1.16b,v1.16b,v1.16b,#12
+	ext	v5.16b,v5.16b,v5.16b,#12
+	ext	v17.16b,v17.16b,v17.16b,#12
+	cbnz	x4,.Loop_neon
+
+	add	w5,w5,w22		// accumulate key block
+	add	v0.4s,v0.4s,v24.4s
+	add	x6,x6,x22,lsr#32
+	add	v4.4s,v4.4s,v24.4s
+	add	w7,w7,w23
+	add	v16.4s,v16.4s,v24.4s
+	add	x8,x8,x23,lsr#32
+	add	v2.4s,v2.4s,v26.4s
+	add	w9,w9,w24
+	add	v6.4s,v6.4s,v26.4s
+	add	x10,x10,x24,lsr#32
+	add	v18.4s,v18.4s,v26.4s
+	add	w11,w11,w25
+	add	v3.4s,v3.4s,v27.4s
+	add	x12,x12,x25,lsr#32
+	add	w13,w13,w26
+	add	v7.4s,v7.4s,v28.4s
+	add	x14,x14,x26,lsr#32
+	add	w15,w15,w27
+	add	v19.4s,v19.4s,v29.4s
+	add	x16,x16,x27,lsr#32
+	add	w17,w17,w28
+	add	v1.4s,v1.4s,v25.4s
+	add	x19,x19,x28,lsr#32
+	add	w20,w20,w30
+	add	v5.4s,v5.4s,v25.4s
+	add	x21,x21,x30,lsr#32
+	add	v17.4s,v17.4s,v25.4s
+
+	b.lo	.Ltail_neon
+
+	add	x5,x5,x6,lsl#32	// pack
+	add	x7,x7,x8,lsl#32
+	ldp	x6,x8,[x1,#0]		// load input
+	add	x9,x9,x10,lsl#32
+	add	x11,x11,x12,lsl#32
+	ldp	x10,x12,[x1,#16]
+	add	x13,x13,x14,lsl#32
+	add	x15,x15,x16,lsl#32
+	ldp	x14,x16,[x1,#32]
+	add	x17,x17,x19,lsl#32
+	add	x20,x20,x21,lsl#32
+	ldp	x19,x21,[x1,#48]
+	add	x1,x1,#64
+#ifdef	__ARMEB__
+	rev	x5,x5
+	rev	x7,x7
+	rev	x9,x9
+	rev	x11,x11
+	rev	x13,x13
+	rev	x15,x15
+	rev	x17,x17
+	rev	x20,x20
+#endif
+	ld1	{v20.16b,v21.16b,v22.16b,v23.16b},[x1],#64
+	eor	x5,x5,x6
+	eor	x7,x7,x8
+	eor	x9,x9,x10
+	eor	x11,x11,x12
+	eor	x13,x13,x14
+	eor	v0.16b,v0.16b,v20.16b
+	eor	x15,x15,x16
+	eor	v1.16b,v1.16b,v21.16b
+	eor	x17,x17,x19
+	eor	v2.16b,v2.16b,v22.16b
+	eor	x20,x20,x21
+	eor	v3.16b,v3.16b,v23.16b
+	ld1	{v20.16b,v21.16b,v22.16b,v23.16b},[x1],#64
+
+	stp	x5,x7,[x0,#0]		// store output
+	add	x28,x28,#4			// increment counter
+	stp	x9,x11,[x0,#16]
+	add	v27.4s,v27.4s,v31.4s		// += 4
+	stp	x13,x15,[x0,#32]
+	add	v28.4s,v28.4s,v31.4s
+	stp	x17,x20,[x0,#48]
+	add	v29.4s,v29.4s,v31.4s
+	add	x0,x0,#64
+
+	st1	{v0.16b,v1.16b,v2.16b,v3.16b},[x0],#64
+	ld1	{v0.16b,v1.16b,v2.16b,v3.16b},[x1],#64
+
+	eor	v4.16b,v4.16b,v20.16b
+	eor	v5.16b,v5.16b,v21.16b
+	eor	v6.16b,v6.16b,v22.16b
+	eor	v7.16b,v7.16b,v23.16b
+	st1	{v4.16b,v5.16b,v6.16b,v7.16b},[x0],#64
+
+	eor	v16.16b,v16.16b,v0.16b
+	eor	v17.16b,v17.16b,v1.16b
+	eor	v18.16b,v18.16b,v2.16b
+	eor	v19.16b,v19.16b,v3.16b
+	st1	{v16.16b,v17.16b,v18.16b,v19.16b},[x0],#64
+
+	b.hi	.Loop_outer_neon
+
+	ldp	x19,x20,[x29,#16]
+	add	sp,sp,#64
+	ldp	x21,x22,[x29,#32]
+	ldp	x23,x24,[x29,#48]
+	ldp	x25,x26,[x29,#64]
+	ldp	x27,x28,[x29,#80]
+	ldp	x29,x30,[sp],#96
+	ret
+
+.Ltail_neon:
+	add	x2,x2,#256
+	cmp	x2,#64
+	b.lo	.Less_than_64
+
+	add	x5,x5,x6,lsl#32	// pack
+	add	x7,x7,x8,lsl#32
+	ldp	x6,x8,[x1,#0]		// load input
+	add	x9,x9,x10,lsl#32
+	add	x11,x11,x12,lsl#32
+	ldp	x10,x12,[x1,#16]
+	add	x13,x13,x14,lsl#32
+	add	x15,x15,x16,lsl#32
+	ldp	x14,x16,[x1,#32]
+	add	x17,x17,x19,lsl#32
+	add	x20,x20,x21,lsl#32
+	ldp	x19,x21,[x1,#48]
+	add	x1,x1,#64
+#ifdef	__ARMEB__
+	rev	x5,x5
+	rev	x7,x7
+	rev	x9,x9
+	rev	x11,x11
+	rev	x13,x13
+	rev	x15,x15
+	rev	x17,x17
+	rev	x20,x20
+#endif
+	eor	x5,x5,x6
+	eor	x7,x7,x8
+	eor	x9,x9,x10
+	eor	x11,x11,x12
+	eor	x13,x13,x14
+	eor	x15,x15,x16
+	eor	x17,x17,x19
+	eor	x20,x20,x21
+
+	stp	x5,x7,[x0,#0]		// store output
+	add	x28,x28,#4			// increment counter
+	stp	x9,x11,[x0,#16]
+	stp	x13,x15,[x0,#32]
+	stp	x17,x20,[x0,#48]
+	add	x0,x0,#64
+	b.eq	.Ldone_neon
+	sub	x2,x2,#64
+	cmp	x2,#64
+	b.lo	.Less_than_128
+
+	ld1	{v20.16b,v21.16b,v22.16b,v23.16b},[x1],#64
+	eor	v0.16b,v0.16b,v20.16b
+	eor	v1.16b,v1.16b,v21.16b
+	eor	v2.16b,v2.16b,v22.16b
+	eor	v3.16b,v3.16b,v23.16b
+	st1	{v0.16b,v1.16b,v2.16b,v3.16b},[x0],#64
+	b.eq	.Ldone_neon
+	sub	x2,x2,#64
+	cmp	x2,#64
+	b.lo	.Less_than_192
+
+	ld1	{v20.16b,v21.16b,v22.16b,v23.16b},[x1],#64
+	eor	v4.16b,v4.16b,v20.16b
+	eor	v5.16b,v5.16b,v21.16b
+	eor	v6.16b,v6.16b,v22.16b
+	eor	v7.16b,v7.16b,v23.16b
+	st1	{v4.16b,v5.16b,v6.16b,v7.16b},[x0],#64
+	b.eq	.Ldone_neon
+	sub	x2,x2,#64
+
+	st1	{v16.16b,v17.16b,v18.16b,v19.16b},[sp]
+	b	.Last_neon
+
+.Less_than_128:
+	st1	{v0.16b,v1.16b,v2.16b,v3.16b},[sp]
+	b	.Last_neon
+.Less_than_192:
+	st1	{v4.16b,v5.16b,v6.16b,v7.16b},[sp]
+	b	.Last_neon
+
+.align	4
+.Last_neon:
+	sub	x0,x0,#1
+	add	x1,x1,x2
+	add	x0,x0,x2
+	add	x4,sp,x2
+	neg	x2,x2
+
+.Loop_tail_neon:
+	ldrb	w10,[x1,x2]
+	ldrb	w11,[x4,x2]
+	add	x2,x2,#1
+	eor	w10,w10,w11
+	strb	w10,[x0,x2]
+	cbnz	x2,.Loop_tail_neon
+
+	stp	xzr,xzr,[sp,#0]
+	stp	xzr,xzr,[sp,#16]
+	stp	xzr,xzr,[sp,#32]
+	stp	xzr,xzr,[sp,#48]
+
+.Ldone_neon:
+	ldp	x19,x20,[x29,#16]
+	add	sp,sp,#64
+	ldp	x21,x22,[x29,#32]
+	ldp	x23,x24,[x29,#48]
+	ldp	x25,x26,[x29,#64]
+	ldp	x27,x28,[x29,#80]
+	ldp	x29,x30,[sp],#96
+	ret
+.size	ChaCha20_neon,.-ChaCha20_neon
+.type	ChaCha20_512_neon,%function
+.align	5
+ChaCha20_512_neon:
+	stp	x29,x30,[sp,#-96]!
+	add	x29,sp,#0
+
+	adr	x5,.Lsigma
+	stp	x19,x20,[sp,#16]
+	stp	x21,x22,[sp,#32]
+	stp	x23,x24,[sp,#48]
+	stp	x25,x26,[sp,#64]
+	stp	x27,x28,[sp,#80]
+
+.L512_or_more_neon:
+	sub	sp,sp,#128+64
+
+	ldp	x22,x23,[x5]		// load sigma
+	ld1	{v24.4s},[x5],#16
+	ldp	x24,x25,[x3]		// load key
+	ldp	x26,x27,[x3,#16]
+	ld1	{v25.4s,v26.4s},[x3]
+	ldp	x28,x30,[x4]		// load counter
+	ld1	{v27.4s},[x4]
+	ld1	{v31.4s},[x5]
+#ifdef	__ARMEB__
+	rev64	v24.4s,v24.4s
+	ror	x24,x24,#32
+	ror	x25,x25,#32
+	ror	x26,x26,#32
+	ror	x27,x27,#32
+	ror	x28,x28,#32
+	ror	x30,x30,#32
+#endif
+	add	v27.4s,v27.4s,v31.4s		// += 1
+	stp	q24,q25,[sp,#0]		// off-load key block, invariant part
+	add	v27.4s,v27.4s,v31.4s		// not typo
+	str	q26,[sp,#32]
+	add	v28.4s,v27.4s,v31.4s
+	add	v29.4s,v28.4s,v31.4s
+	add	v30.4s,v29.4s,v31.4s
+	shl	v31.4s,v31.4s,#2			// 1 -> 4
+
+	stp	d8,d9,[sp,#128+0]		// meet ABI requirements
+	stp	d10,d11,[sp,#128+16]
+	stp	d12,d13,[sp,#128+32]
+	stp	d14,d15,[sp,#128+48]
+
+	sub	x2,x2,#512			// not typo
+
+.Loop_outer_512_neon:
+	mov	v0.16b,v24.16b
+	mov	v4.16b,v24.16b
+	mov	v8.16b,v24.16b
+	mov	v12.16b,v24.16b
+	mov	v16.16b,v24.16b
+	mov	v20.16b,v24.16b
+	mov	v1.16b,v25.16b
+	mov	w5,w22			// unpack key block
+	mov	v5.16b,v25.16b
+	lsr	x6,x22,#32
+	mov	v9.16b,v25.16b
+	mov	w7,w23
+	mov	v13.16b,v25.16b
+	lsr	x8,x23,#32
+	mov	v17.16b,v25.16b
+	mov	w9,w24
+	mov	v21.16b,v25.16b
+	lsr	x10,x24,#32
+	mov	v3.16b,v27.16b
+	mov	w11,w25
+	mov	v7.16b,v28.16b
+	lsr	x12,x25,#32
+	mov	v11.16b,v29.16b
+	mov	w13,w26
+	mov	v15.16b,v30.16b
+	lsr	x14,x26,#32
+	mov	v2.16b,v26.16b
+	mov	w15,w27
+	mov	v6.16b,v26.16b
+	lsr	x16,x27,#32
+	add	v19.4s,v3.4s,v31.4s			// +4
+	mov	w17,w28
+	add	v23.4s,v7.4s,v31.4s			// +4
+	lsr	x19,x28,#32
+	mov	v10.16b,v26.16b
+	mov	w20,w30
+	mov	v14.16b,v26.16b
+	lsr	x21,x30,#32
+	mov	v18.16b,v26.16b
+	stp	q27,q28,[sp,#48]		// off-load key block, variable part
+	mov	v22.16b,v26.16b
+	str	q29,[sp,#80]
+
+	mov	x4,#5
+	subs	x2,x2,#512
+.Loop_upper_neon:
+	sub	x4,x4,#1
+	add	v0.4s,v0.4s,v1.4s
+	add	w5,w5,w9
+	add	v4.4s,v4.4s,v5.4s
+	add	w6,w6,w10
+	add	v8.4s,v8.4s,v9.4s
+	add	w7,w7,w11
+	add	v12.4s,v12.4s,v13.4s
+	add	w8,w8,w12
+	add	v16.4s,v16.4s,v17.4s
+	eor	w17,w17,w5
+	add	v20.4s,v20.4s,v21.4s
+	eor	w19,w19,w6
+	eor	v3.16b,v3.16b,v0.16b
+	eor	w20,w20,w7
+	eor	v7.16b,v7.16b,v4.16b
+	eor	w21,w21,w8
+	eor	v11.16b,v11.16b,v8.16b
+	ror	w17,w17,#16
+	eor	v15.16b,v15.16b,v12.16b
+	ror	w19,w19,#16
+	eor	v19.16b,v19.16b,v16.16b
+	ror	w20,w20,#16
+	eor	v23.16b,v23.16b,v20.16b
+	ror	w21,w21,#16
+	rev32	v3.8h,v3.8h
+	add	w13,w13,w17
+	rev32	v7.8h,v7.8h
+	add	w14,w14,w19
+	rev32	v11.8h,v11.8h
+	add	w15,w15,w20
+	rev32	v15.8h,v15.8h
+	add	w16,w16,w21
+	rev32	v19.8h,v19.8h
+	eor	w9,w9,w13
+	rev32	v23.8h,v23.8h
+	eor	w10,w10,w14
+	add	v2.4s,v2.4s,v3.4s
+	eor	w11,w11,w15
+	add	v6.4s,v6.4s,v7.4s
+	eor	w12,w12,w16
+	add	v10.4s,v10.4s,v11.4s
+	ror	w9,w9,#20
+	add	v14.4s,v14.4s,v15.4s
+	ror	w10,w10,#20
+	add	v18.4s,v18.4s,v19.4s
+	ror	w11,w11,#20
+	add	v22.4s,v22.4s,v23.4s
+	ror	w12,w12,#20
+	eor	v24.16b,v1.16b,v2.16b
+	add	w5,w5,w9
+	eor	v25.16b,v5.16b,v6.16b
+	add	w6,w6,w10
+	eor	v26.16b,v9.16b,v10.16b
+	add	w7,w7,w11
+	eor	v27.16b,v13.16b,v14.16b
+	add	w8,w8,w12
+	eor	v28.16b,v17.16b,v18.16b
+	eor	w17,w17,w5
+	eor	v29.16b,v21.16b,v22.16b
+	eor	w19,w19,w6
+	ushr	v1.4s,v24.4s,#20
+	eor	w20,w20,w7
+	ushr	v5.4s,v25.4s,#20
+	eor	w21,w21,w8
+	ushr	v9.4s,v26.4s,#20
+	ror	w17,w17,#24
+	ushr	v13.4s,v27.4s,#20
+	ror	w19,w19,#24
+	ushr	v17.4s,v28.4s,#20
+	ror	w20,w20,#24
+	ushr	v21.4s,v29.4s,#20
+	ror	w21,w21,#24
+	sli	v1.4s,v24.4s,#12
+	add	w13,w13,w17
+	sli	v5.4s,v25.4s,#12
+	add	w14,w14,w19
+	sli	v9.4s,v26.4s,#12
+	add	w15,w15,w20
+	sli	v13.4s,v27.4s,#12
+	add	w16,w16,w21
+	sli	v17.4s,v28.4s,#12
+	eor	w9,w9,w13
+	sli	v21.4s,v29.4s,#12
+	eor	w10,w10,w14
+	add	v0.4s,v0.4s,v1.4s
+	eor	w11,w11,w15
+	add	v4.4s,v4.4s,v5.4s
+	eor	w12,w12,w16
+	add	v8.4s,v8.4s,v9.4s
+	ror	w9,w9,#25
+	add	v12.4s,v12.4s,v13.4s
+	ror	w10,w10,#25
+	add	v16.4s,v16.4s,v17.4s
+	ror	w11,w11,#25
+	add	v20.4s,v20.4s,v21.4s
+	ror	w12,w12,#25
+	eor	v24.16b,v3.16b,v0.16b
+	add	w5,w5,w10
+	eor	v25.16b,v7.16b,v4.16b
+	add	w6,w6,w11
+	eor	v26.16b,v11.16b,v8.16b
+	add	w7,w7,w12
+	eor	v27.16b,v15.16b,v12.16b
+	add	w8,w8,w9
+	eor	v28.16b,v19.16b,v16.16b
+	eor	w21,w21,w5
+	eor	v29.16b,v23.16b,v20.16b
+	eor	w17,w17,w6
+	ushr	v3.4s,v24.4s,#24
+	eor	w19,w19,w7
+	ushr	v7.4s,v25.4s,#24
+	eor	w20,w20,w8
+	ushr	v11.4s,v26.4s,#24
+	ror	w21,w21,#16
+	ushr	v15.4s,v27.4s,#24
+	ror	w17,w17,#16
+	ushr	v19.4s,v28.4s,#24
+	ror	w19,w19,#16
+	ushr	v23.4s,v29.4s,#24
+	ror	w20,w20,#16
+	sli	v3.4s,v24.4s,#8
+	add	w15,w15,w21
+	sli	v7.4s,v25.4s,#8
+	add	w16,w16,w17
+	sli	v11.4s,v26.4s,#8
+	add	w13,w13,w19
+	sli	v15.4s,v27.4s,#8
+	add	w14,w14,w20
+	sli	v19.4s,v28.4s,#8
+	eor	w10,w10,w15
+	sli	v23.4s,v29.4s,#8
+	eor	w11,w11,w16
+	add	v2.4s,v2.4s,v3.4s
+	eor	w12,w12,w13
+	add	v6.4s,v6.4s,v7.4s
+	eor	w9,w9,w14
+	add	v10.4s,v10.4s,v11.4s
+	ror	w10,w10,#20
+	add	v14.4s,v14.4s,v15.4s
+	ror	w11,w11,#20
+	add	v18.4s,v18.4s,v19.4s
+	ror	w12,w12,#20
+	add	v22.4s,v22.4s,v23.4s
+	ror	w9,w9,#20
+	eor	v24.16b,v1.16b,v2.16b
+	add	w5,w5,w10
+	eor	v25.16b,v5.16b,v6.16b
+	add	w6,w6,w11
+	eor	v26.16b,v9.16b,v10.16b
+	add	w7,w7,w12
+	eor	v27.16b,v13.16b,v14.16b
+	add	w8,w8,w9
+	eor	v28.16b,v17.16b,v18.16b
+	eor	w21,w21,w5
+	eor	v29.16b,v21.16b,v22.16b
+	eor	w17,w17,w6
+	ushr	v1.4s,v24.4s,#25
+	eor	w19,w19,w7
+	ushr	v5.4s,v25.4s,#25
+	eor	w20,w20,w8
+	ushr	v9.4s,v26.4s,#25
+	ror	w21,w21,#24
+	ushr	v13.4s,v27.4s,#25
+	ror	w17,w17,#24
+	ushr	v17.4s,v28.4s,#25
+	ror	w19,w19,#24
+	ushr	v21.4s,v29.4s,#25
+	ror	w20,w20,#24
+	sli	v1.4s,v24.4s,#7
+	add	w15,w15,w21
+	sli	v5.4s,v25.4s,#7
+	add	w16,w16,w17
+	sli	v9.4s,v26.4s,#7
+	add	w13,w13,w19
+	sli	v13.4s,v27.4s,#7
+	add	w14,w14,w20
+	sli	v17.4s,v28.4s,#7
+	eor	w10,w10,w15
+	sli	v21.4s,v29.4s,#7
+	eor	w11,w11,w16
+	ext	v2.16b,v2.16b,v2.16b,#8
+	eor	w12,w12,w13
+	ext	v6.16b,v6.16b,v6.16b,#8
+	eor	w9,w9,w14
+	ext	v10.16b,v10.16b,v10.16b,#8
+	ror	w10,w10,#25
+	ext	v14.16b,v14.16b,v14.16b,#8
+	ror	w11,w11,#25
+	ext	v18.16b,v18.16b,v18.16b,#8
+	ror	w12,w12,#25
+	ext	v22.16b,v22.16b,v22.16b,#8
+	ror	w9,w9,#25
+	ext	v3.16b,v3.16b,v3.16b,#12
+	ext	v7.16b,v7.16b,v7.16b,#12
+	ext	v11.16b,v11.16b,v11.16b,#12
+	ext	v15.16b,v15.16b,v15.16b,#12
+	ext	v19.16b,v19.16b,v19.16b,#12
+	ext	v23.16b,v23.16b,v23.16b,#12
+	ext	v1.16b,v1.16b,v1.16b,#4
+	ext	v5.16b,v5.16b,v5.16b,#4
+	ext	v9.16b,v9.16b,v9.16b,#4
+	ext	v13.16b,v13.16b,v13.16b,#4
+	ext	v17.16b,v17.16b,v17.16b,#4
+	ext	v21.16b,v21.16b,v21.16b,#4
+	add	v0.4s,v0.4s,v1.4s
+	add	w5,w5,w9
+	add	v4.4s,v4.4s,v5.4s
+	add	w6,w6,w10
+	add	v8.4s,v8.4s,v9.4s
+	add	w7,w7,w11
+	add	v12.4s,v12.4s,v13.4s
+	add	w8,w8,w12
+	add	v16.4s,v16.4s,v17.4s
+	eor	w17,w17,w5
+	add	v20.4s,v20.4s,v21.4s
+	eor	w19,w19,w6
+	eor	v3.16b,v3.16b,v0.16b
+	eor	w20,w20,w7
+	eor	v7.16b,v7.16b,v4.16b
+	eor	w21,w21,w8
+	eor	v11.16b,v11.16b,v8.16b
+	ror	w17,w17,#16
+	eor	v15.16b,v15.16b,v12.16b
+	ror	w19,w19,#16
+	eor	v19.16b,v19.16b,v16.16b
+	ror	w20,w20,#16
+	eor	v23.16b,v23.16b,v20.16b
+	ror	w21,w21,#16
+	rev32	v3.8h,v3.8h
+	add	w13,w13,w17
+	rev32	v7.8h,v7.8h
+	add	w14,w14,w19
+	rev32	v11.8h,v11.8h
+	add	w15,w15,w20
+	rev32	v15.8h,v15.8h
+	add	w16,w16,w21
+	rev32	v19.8h,v19.8h
+	eor	w9,w9,w13
+	rev32	v23.8h,v23.8h
+	eor	w10,w10,w14
+	add	v2.4s,v2.4s,v3.4s
+	eor	w11,w11,w15
+	add	v6.4s,v6.4s,v7.4s
+	eor	w12,w12,w16
+	add	v10.4s,v10.4s,v11.4s
+	ror	w9,w9,#20
+	add	v14.4s,v14.4s,v15.4s
+	ror	w10,w10,#20
+	add	v18.4s,v18.4s,v19.4s
+	ror	w11,w11,#20
+	add	v22.4s,v22.4s,v23.4s
+	ror	w12,w12,#20
+	eor	v24.16b,v1.16b,v2.16b
+	add	w5,w5,w9
+	eor	v25.16b,v5.16b,v6.16b
+	add	w6,w6,w10
+	eor	v26.16b,v9.16b,v10.16b
+	add	w7,w7,w11
+	eor	v27.16b,v13.16b,v14.16b
+	add	w8,w8,w12
+	eor	v28.16b,v17.16b,v18.16b
+	eor	w17,w17,w5
+	eor	v29.16b,v21.16b,v22.16b
+	eor	w19,w19,w6
+	ushr	v1.4s,v24.4s,#20
+	eor	w20,w20,w7
+	ushr	v5.4s,v25.4s,#20
+	eor	w21,w21,w8
+	ushr	v9.4s,v26.4s,#20
+	ror	w17,w17,#24
+	ushr	v13.4s,v27.4s,#20
+	ror	w19,w19,#24
+	ushr	v17.4s,v28.4s,#20
+	ror	w20,w20,#24
+	ushr	v21.4s,v29.4s,#20
+	ror	w21,w21,#24
+	sli	v1.4s,v24.4s,#12
+	add	w13,w13,w17
+	sli	v5.4s,v25.4s,#12
+	add	w14,w14,w19
+	sli	v9.4s,v26.4s,#12
+	add	w15,w15,w20
+	sli	v13.4s,v27.4s,#12
+	add	w16,w16,w21
+	sli	v17.4s,v28.4s,#12
+	eor	w9,w9,w13
+	sli	v21.4s,v29.4s,#12
+	eor	w10,w10,w14
+	add	v0.4s,v0.4s,v1.4s
+	eor	w11,w11,w15
+	add	v4.4s,v4.4s,v5.4s
+	eor	w12,w12,w16
+	add	v8.4s,v8.4s,v9.4s
+	ror	w9,w9,#25
+	add	v12.4s,v12.4s,v13.4s
+	ror	w10,w10,#25
+	add	v16.4s,v16.4s,v17.4s
+	ror	w11,w11,#25
+	add	v20.4s,v20.4s,v21.4s
+	ror	w12,w12,#25
+	eor	v24.16b,v3.16b,v0.16b
+	add	w5,w5,w10
+	eor	v25.16b,v7.16b,v4.16b
+	add	w6,w6,w11
+	eor	v26.16b,v11.16b,v8.16b
+	add	w7,w7,w12
+	eor	v27.16b,v15.16b,v12.16b
+	add	w8,w8,w9
+	eor	v28.16b,v19.16b,v16.16b
+	eor	w21,w21,w5
+	eor	v29.16b,v23.16b,v20.16b
+	eor	w17,w17,w6
+	ushr	v3.4s,v24.4s,#24
+	eor	w19,w19,w7
+	ushr	v7.4s,v25.4s,#24
+	eor	w20,w20,w8
+	ushr	v11.4s,v26.4s,#24
+	ror	w21,w21,#16
+	ushr	v15.4s,v27.4s,#24
+	ror	w17,w17,#16
+	ushr	v19.4s,v28.4s,#24
+	ror	w19,w19,#16
+	ushr	v23.4s,v29.4s,#24
+	ror	w20,w20,#16
+	sli	v3.4s,v24.4s,#8
+	add	w15,w15,w21
+	sli	v7.4s,v25.4s,#8
+	add	w16,w16,w17
+	sli	v11.4s,v26.4s,#8
+	add	w13,w13,w19
+	sli	v15.4s,v27.4s,#8
+	add	w14,w14,w20
+	sli	v19.4s,v28.4s,#8
+	eor	w10,w10,w15
+	sli	v23.4s,v29.4s,#8
+	eor	w11,w11,w16
+	add	v2.4s,v2.4s,v3.4s
+	eor	w12,w12,w13
+	add	v6.4s,v6.4s,v7.4s
+	eor	w9,w9,w14
+	add	v10.4s,v10.4s,v11.4s
+	ror	w10,w10,#20
+	add	v14.4s,v14.4s,v15.4s
+	ror	w11,w11,#20
+	add	v18.4s,v18.4s,v19.4s
+	ror	w12,w12,#20
+	add	v22.4s,v22.4s,v23.4s
+	ror	w9,w9,#20
+	eor	v24.16b,v1.16b,v2.16b
+	add	w5,w5,w10
+	eor	v25.16b,v5.16b,v6.16b
+	add	w6,w6,w11
+	eor	v26.16b,v9.16b,v10.16b
+	add	w7,w7,w12
+	eor	v27.16b,v13.16b,v14.16b
+	add	w8,w8,w9
+	eor	v28.16b,v17.16b,v18.16b
+	eor	w21,w21,w5
+	eor	v29.16b,v21.16b,v22.16b
+	eor	w17,w17,w6
+	ushr	v1.4s,v24.4s,#25
+	eor	w19,w19,w7
+	ushr	v5.4s,v25.4s,#25
+	eor	w20,w20,w8
+	ushr	v9.4s,v26.4s,#25
+	ror	w21,w21,#24
+	ushr	v13.4s,v27.4s,#25
+	ror	w17,w17,#24
+	ushr	v17.4s,v28.4s,#25
+	ror	w19,w19,#24
+	ushr	v21.4s,v29.4s,#25
+	ror	w20,w20,#24
+	sli	v1.4s,v24.4s,#7
+	add	w15,w15,w21
+	sli	v5.4s,v25.4s,#7
+	add	w16,w16,w17
+	sli	v9.4s,v26.4s,#7
+	add	w13,w13,w19
+	sli	v13.4s,v27.4s,#7
+	add	w14,w14,w20
+	sli	v17.4s,v28.4s,#7
+	eor	w10,w10,w15
+	sli	v21.4s,v29.4s,#7
+	eor	w11,w11,w16
+	ext	v2.16b,v2.16b,v2.16b,#8
+	eor	w12,w12,w13
+	ext	v6.16b,v6.16b,v6.16b,#8
+	eor	w9,w9,w14
+	ext	v10.16b,v10.16b,v10.16b,#8
+	ror	w10,w10,#25
+	ext	v14.16b,v14.16b,v14.16b,#8
+	ror	w11,w11,#25
+	ext	v18.16b,v18.16b,v18.16b,#8
+	ror	w12,w12,#25
+	ext	v22.16b,v22.16b,v22.16b,#8
+	ror	w9,w9,#25
+	ext	v3.16b,v3.16b,v3.16b,#4
+	ext	v7.16b,v7.16b,v7.16b,#4
+	ext	v11.16b,v11.16b,v11.16b,#4
+	ext	v15.16b,v15.16b,v15.16b,#4
+	ext	v19.16b,v19.16b,v19.16b,#4
+	ext	v23.16b,v23.16b,v23.16b,#4
+	ext	v1.16b,v1.16b,v1.16b,#12
+	ext	v5.16b,v5.16b,v5.16b,#12
+	ext	v9.16b,v9.16b,v9.16b,#12
+	ext	v13.16b,v13.16b,v13.16b,#12
+	ext	v17.16b,v17.16b,v17.16b,#12
+	ext	v21.16b,v21.16b,v21.16b,#12
+	cbnz	x4,.Loop_upper_neon
+
+	add	w5,w5,w22		// accumulate key block
+	add	x6,x6,x22,lsr#32
+	add	w7,w7,w23
+	add	x8,x8,x23,lsr#32
+	add	w9,w9,w24
+	add	x10,x10,x24,lsr#32
+	add	w11,w11,w25
+	add	x12,x12,x25,lsr#32
+	add	w13,w13,w26
+	add	x14,x14,x26,lsr#32
+	add	w15,w15,w27
+	add	x16,x16,x27,lsr#32
+	add	w17,w17,w28
+	add	x19,x19,x28,lsr#32
+	add	w20,w20,w30
+	add	x21,x21,x30,lsr#32
+
+	add	x5,x5,x6,lsl#32	// pack
+	add	x7,x7,x8,lsl#32
+	ldp	x6,x8,[x1,#0]		// load input
+	add	x9,x9,x10,lsl#32
+	add	x11,x11,x12,lsl#32
+	ldp	x10,x12,[x1,#16]
+	add	x13,x13,x14,lsl#32
+	add	x15,x15,x16,lsl#32
+	ldp	x14,x16,[x1,#32]
+	add	x17,x17,x19,lsl#32
+	add	x20,x20,x21,lsl#32
+	ldp	x19,x21,[x1,#48]
+	add	x1,x1,#64
+#ifdef	__ARMEB__
+	rev	x5,x5
+	rev	x7,x7
+	rev	x9,x9
+	rev	x11,x11
+	rev	x13,x13
+	rev	x15,x15
+	rev	x17,x17
+	rev	x20,x20
+#endif
+	eor	x5,x5,x6
+	eor	x7,x7,x8
+	eor	x9,x9,x10
+	eor	x11,x11,x12
+	eor	x13,x13,x14
+	eor	x15,x15,x16
+	eor	x17,x17,x19
+	eor	x20,x20,x21
+
+	stp	x5,x7,[x0,#0]		// store output
+	add	x28,x28,#1			// increment counter
+	mov	w5,w22			// unpack key block
+	lsr	x6,x22,#32
+	stp	x9,x11,[x0,#16]
+	mov	w7,w23
+	lsr	x8,x23,#32
+	stp	x13,x15,[x0,#32]
+	mov	w9,w24
+	lsr	x10,x24,#32
+	stp	x17,x20,[x0,#48]
+	add	x0,x0,#64
+	mov	w11,w25
+	lsr	x12,x25,#32
+	mov	w13,w26
+	lsr	x14,x26,#32
+	mov	w15,w27
+	lsr	x16,x27,#32
+	mov	w17,w28
+	lsr	x19,x28,#32
+	mov	w20,w30
+	lsr	x21,x30,#32
+
+	mov	x4,#5
+.Loop_lower_neon:
+	sub	x4,x4,#1
+	add	v0.4s,v0.4s,v1.4s
+	add	w5,w5,w9
+	add	v4.4s,v4.4s,v5.4s
+	add	w6,w6,w10
+	add	v8.4s,v8.4s,v9.4s
+	add	w7,w7,w11
+	add	v12.4s,v12.4s,v13.4s
+	add	w8,w8,w12
+	add	v16.4s,v16.4s,v17.4s
+	eor	w17,w17,w5
+	add	v20.4s,v20.4s,v21.4s
+	eor	w19,w19,w6
+	eor	v3.16b,v3.16b,v0.16b
+	eor	w20,w20,w7
+	eor	v7.16b,v7.16b,v4.16b
+	eor	w21,w21,w8
+	eor	v11.16b,v11.16b,v8.16b
+	ror	w17,w17,#16
+	eor	v15.16b,v15.16b,v12.16b
+	ror	w19,w19,#16
+	eor	v19.16b,v19.16b,v16.16b
+	ror	w20,w20,#16
+	eor	v23.16b,v23.16b,v20.16b
+	ror	w21,w21,#16
+	rev32	v3.8h,v3.8h
+	add	w13,w13,w17
+	rev32	v7.8h,v7.8h
+	add	w14,w14,w19
+	rev32	v11.8h,v11.8h
+	add	w15,w15,w20
+	rev32	v15.8h,v15.8h
+	add	w16,w16,w21
+	rev32	v19.8h,v19.8h
+	eor	w9,w9,w13
+	rev32	v23.8h,v23.8h
+	eor	w10,w10,w14
+	add	v2.4s,v2.4s,v3.4s
+	eor	w11,w11,w15
+	add	v6.4s,v6.4s,v7.4s
+	eor	w12,w12,w16
+	add	v10.4s,v10.4s,v11.4s
+	ror	w9,w9,#20
+	add	v14.4s,v14.4s,v15.4s
+	ror	w10,w10,#20
+	add	v18.4s,v18.4s,v19.4s
+	ror	w11,w11,#20
+	add	v22.4s,v22.4s,v23.4s
+	ror	w12,w12,#20
+	eor	v24.16b,v1.16b,v2.16b
+	add	w5,w5,w9
+	eor	v25.16b,v5.16b,v6.16b
+	add	w6,w6,w10
+	eor	v26.16b,v9.16b,v10.16b
+	add	w7,w7,w11
+	eor	v27.16b,v13.16b,v14.16b
+	add	w8,w8,w12
+	eor	v28.16b,v17.16b,v18.16b
+	eor	w17,w17,w5
+	eor	v29.16b,v21.16b,v22.16b
+	eor	w19,w19,w6
+	ushr	v1.4s,v24.4s,#20
+	eor	w20,w20,w7
+	ushr	v5.4s,v25.4s,#20
+	eor	w21,w21,w8
+	ushr	v9.4s,v26.4s,#20
+	ror	w17,w17,#24
+	ushr	v13.4s,v27.4s,#20
+	ror	w19,w19,#24
+	ushr	v17.4s,v28.4s,#20
+	ror	w20,w20,#24
+	ushr	v21.4s,v29.4s,#20
+	ror	w21,w21,#24
+	sli	v1.4s,v24.4s,#12
+	add	w13,w13,w17
+	sli	v5.4s,v25.4s,#12
+	add	w14,w14,w19
+	sli	v9.4s,v26.4s,#12
+	add	w15,w15,w20
+	sli	v13.4s,v27.4s,#12
+	add	w16,w16,w21
+	sli	v17.4s,v28.4s,#12
+	eor	w9,w9,w13
+	sli	v21.4s,v29.4s,#12
+	eor	w10,w10,w14
+	add	v0.4s,v0.4s,v1.4s
+	eor	w11,w11,w15
+	add	v4.4s,v4.4s,v5.4s
+	eor	w12,w12,w16
+	add	v8.4s,v8.4s,v9.4s
+	ror	w9,w9,#25
+	add	v12.4s,v12.4s,v13.4s
+	ror	w10,w10,#25
+	add	v16.4s,v16.4s,v17.4s
+	ror	w11,w11,#25
+	add	v20.4s,v20.4s,v21.4s
+	ror	w12,w12,#25
+	eor	v24.16b,v3.16b,v0.16b
+	add	w5,w5,w10
+	eor	v25.16b,v7.16b,v4.16b
+	add	w6,w6,w11
+	eor	v26.16b,v11.16b,v8.16b
+	add	w7,w7,w12
+	eor	v27.16b,v15.16b,v12.16b
+	add	w8,w8,w9
+	eor	v28.16b,v19.16b,v16.16b
+	eor	w21,w21,w5
+	eor	v29.16b,v23.16b,v20.16b
+	eor	w17,w17,w6
+	ushr	v3.4s,v24.4s,#24
+	eor	w19,w19,w7
+	ushr	v7.4s,v25.4s,#24
+	eor	w20,w20,w8
+	ushr	v11.4s,v26.4s,#24
+	ror	w21,w21,#16
+	ushr	v15.4s,v27.4s,#24
+	ror	w17,w17,#16
+	ushr	v19.4s,v28.4s,#24
+	ror	w19,w19,#16
+	ushr	v23.4s,v29.4s,#24
+	ror	w20,w20,#16
+	sli	v3.4s,v24.4s,#8
+	add	w15,w15,w21
+	sli	v7.4s,v25.4s,#8
+	add	w16,w16,w17
+	sli	v11.4s,v26.4s,#8
+	add	w13,w13,w19
+	sli	v15.4s,v27.4s,#8
+	add	w14,w14,w20
+	sli	v19.4s,v28.4s,#8
+	eor	w10,w10,w15
+	sli	v23.4s,v29.4s,#8
+	eor	w11,w11,w16
+	add	v2.4s,v2.4s,v3.4s
+	eor	w12,w12,w13
+	add	v6.4s,v6.4s,v7.4s
+	eor	w9,w9,w14
+	add	v10.4s,v10.4s,v11.4s
+	ror	w10,w10,#20
+	add	v14.4s,v14.4s,v15.4s
+	ror	w11,w11,#20
+	add	v18.4s,v18.4s,v19.4s
+	ror	w12,w12,#20
+	add	v22.4s,v22.4s,v23.4s
+	ror	w9,w9,#20
+	eor	v24.16b,v1.16b,v2.16b
+	add	w5,w5,w10
+	eor	v25.16b,v5.16b,v6.16b
+	add	w6,w6,w11
+	eor	v26.16b,v9.16b,v10.16b
+	add	w7,w7,w12
+	eor	v27.16b,v13.16b,v14.16b
+	add	w8,w8,w9
+	eor	v28.16b,v17.16b,v18.16b
+	eor	w21,w21,w5
+	eor	v29.16b,v21.16b,v22.16b
+	eor	w17,w17,w6
+	ushr	v1.4s,v24.4s,#25
+	eor	w19,w19,w7
+	ushr	v5.4s,v25.4s,#25
+	eor	w20,w20,w8
+	ushr	v9.4s,v26.4s,#25
+	ror	w21,w21,#24
+	ushr	v13.4s,v27.4s,#25
+	ror	w17,w17,#24
+	ushr	v17.4s,v28.4s,#25
+	ror	w19,w19,#24
+	ushr	v21.4s,v29.4s,#25
+	ror	w20,w20,#24
+	sli	v1.4s,v24.4s,#7
+	add	w15,w15,w21
+	sli	v5.4s,v25.4s,#7
+	add	w16,w16,w17
+	sli	v9.4s,v26.4s,#7
+	add	w13,w13,w19
+	sli	v13.4s,v27.4s,#7
+	add	w14,w14,w20
+	sli	v17.4s,v28.4s,#7
+	eor	w10,w10,w15
+	sli	v21.4s,v29.4s,#7
+	eor	w11,w11,w16
+	ext	v2.16b,v2.16b,v2.16b,#8
+	eor	w12,w12,w13
+	ext	v6.16b,v6.16b,v6.16b,#8
+	eor	w9,w9,w14
+	ext	v10.16b,v10.16b,v10.16b,#8
+	ror	w10,w10,#25
+	ext	v14.16b,v14.16b,v14.16b,#8
+	ror	w11,w11,#25
+	ext	v18.16b,v18.16b,v18.16b,#8
+	ror	w12,w12,#25
+	ext	v22.16b,v22.16b,v22.16b,#8
+	ror	w9,w9,#25
+	ext	v3.16b,v3.16b,v3.16b,#12
+	ext	v7.16b,v7.16b,v7.16b,#12
+	ext	v11.16b,v11.16b,v11.16b,#12
+	ext	v15.16b,v15.16b,v15.16b,#12
+	ext	v19.16b,v19.16b,v19.16b,#12
+	ext	v23.16b,v23.16b,v23.16b,#12
+	ext	v1.16b,v1.16b,v1.16b,#4
+	ext	v5.16b,v5.16b,v5.16b,#4
+	ext	v9.16b,v9.16b,v9.16b,#4
+	ext	v13.16b,v13.16b,v13.16b,#4
+	ext	v17.16b,v17.16b,v17.16b,#4
+	ext	v21.16b,v21.16b,v21.16b,#4
+	add	v0.4s,v0.4s,v1.4s
+	add	w5,w5,w9
+	add	v4.4s,v4.4s,v5.4s
+	add	w6,w6,w10
+	add	v8.4s,v8.4s,v9.4s
+	add	w7,w7,w11
+	add	v12.4s,v12.4s,v13.4s
+	add	w8,w8,w12
+	add	v16.4s,v16.4s,v17.4s
+	eor	w17,w17,w5
+	add	v20.4s,v20.4s,v21.4s
+	eor	w19,w19,w6
+	eor	v3.16b,v3.16b,v0.16b
+	eor	w20,w20,w7
+	eor	v7.16b,v7.16b,v4.16b
+	eor	w21,w21,w8
+	eor	v11.16b,v11.16b,v8.16b
+	ror	w17,w17,#16
+	eor	v15.16b,v15.16b,v12.16b
+	ror	w19,w19,#16
+	eor	v19.16b,v19.16b,v16.16b
+	ror	w20,w20,#16
+	eor	v23.16b,v23.16b,v20.16b
+	ror	w21,w21,#16
+	rev32	v3.8h,v3.8h
+	add	w13,w13,w17
+	rev32	v7.8h,v7.8h
+	add	w14,w14,w19
+	rev32	v11.8h,v11.8h
+	add	w15,w15,w20
+	rev32	v15.8h,v15.8h
+	add	w16,w16,w21
+	rev32	v19.8h,v19.8h
+	eor	w9,w9,w13
+	rev32	v23.8h,v23.8h
+	eor	w10,w10,w14
+	add	v2.4s,v2.4s,v3.4s
+	eor	w11,w11,w15
+	add	v6.4s,v6.4s,v7.4s
+	eor	w12,w12,w16
+	add	v10.4s,v10.4s,v11.4s
+	ror	w9,w9,#20
+	add	v14.4s,v14.4s,v15.4s
+	ror	w10,w10,#20
+	add	v18.4s,v18.4s,v19.4s
+	ror	w11,w11,#20
+	add	v22.4s,v22.4s,v23.4s
+	ror	w12,w12,#20
+	eor	v24.16b,v1.16b,v2.16b
+	add	w5,w5,w9
+	eor	v25.16b,v5.16b,v6.16b
+	add	w6,w6,w10
+	eor	v26.16b,v9.16b,v10.16b
+	add	w7,w7,w11
+	eor	v27.16b,v13.16b,v14.16b
+	add	w8,w8,w12
+	eor	v28.16b,v17.16b,v18.16b
+	eor	w17,w17,w5
+	eor	v29.16b,v21.16b,v22.16b
+	eor	w19,w19,w6
+	ushr	v1.4s,v24.4s,#20
+	eor	w20,w20,w7
+	ushr	v5.4s,v25.4s,#20
+	eor	w21,w21,w8
+	ushr	v9.4s,v26.4s,#20
+	ror	w17,w17,#24
+	ushr	v13.4s,v27.4s,#20
+	ror	w19,w19,#24
+	ushr	v17.4s,v28.4s,#20
+	ror	w20,w20,#24
+	ushr	v21.4s,v29.4s,#20
+	ror	w21,w21,#24
+	sli	v1.4s,v24.4s,#12
+	add	w13,w13,w17
+	sli	v5.4s,v25.4s,#12
+	add	w14,w14,w19
+	sli	v9.4s,v26.4s,#12
+	add	w15,w15,w20
+	sli	v13.4s,v27.4s,#12
+	add	w16,w16,w21
+	sli	v17.4s,v28.4s,#12
+	eor	w9,w9,w13
+	sli	v21.4s,v29.4s,#12
+	eor	w10,w10,w14
+	add	v0.4s,v0.4s,v1.4s
+	eor	w11,w11,w15
+	add	v4.4s,v4.4s,v5.4s
+	eor	w12,w12,w16
+	add	v8.4s,v8.4s,v9.4s
+	ror	w9,w9,#25
+	add	v12.4s,v12.4s,v13.4s
+	ror	w10,w10,#25
+	add	v16.4s,v16.4s,v17.4s
+	ror	w11,w11,#25
+	add	v20.4s,v20.4s,v21.4s
+	ror	w12,w12,#25
+	eor	v24.16b,v3.16b,v0.16b
+	add	w5,w5,w10
+	eor	v25.16b,v7.16b,v4.16b
+	add	w6,w6,w11
+	eor	v26.16b,v11.16b,v8.16b
+	add	w7,w7,w12
+	eor	v27.16b,v15.16b,v12.16b
+	add	w8,w8,w9
+	eor	v28.16b,v19.16b,v16.16b
+	eor	w21,w21,w5
+	eor	v29.16b,v23.16b,v20.16b
+	eor	w17,w17,w6
+	ushr	v3.4s,v24.4s,#24
+	eor	w19,w19,w7
+	ushr	v7.4s,v25.4s,#24
+	eor	w20,w20,w8
+	ushr	v11.4s,v26.4s,#24
+	ror	w21,w21,#16
+	ushr	v15.4s,v27.4s,#24
+	ror	w17,w17,#16
+	ushr	v19.4s,v28.4s,#24
+	ror	w19,w19,#16
+	ushr	v23.4s,v29.4s,#24
+	ror	w20,w20,#16
+	sli	v3.4s,v24.4s,#8
+	add	w15,w15,w21
+	sli	v7.4s,v25.4s,#8
+	add	w16,w16,w17
+	sli	v11.4s,v26.4s,#8
+	add	w13,w13,w19
+	sli	v15.4s,v27.4s,#8
+	add	w14,w14,w20
+	sli	v19.4s,v28.4s,#8
+	eor	w10,w10,w15
+	sli	v23.4s,v29.4s,#8
+	eor	w11,w11,w16
+	add	v2.4s,v2.4s,v3.4s
+	eor	w12,w12,w13
+	add	v6.4s,v6.4s,v7.4s
+	eor	w9,w9,w14
+	add	v10.4s,v10.4s,v11.4s
+	ror	w10,w10,#20
+	add	v14.4s,v14.4s,v15.4s
+	ror	w11,w11,#20
+	add	v18.4s,v18.4s,v19.4s
+	ror	w12,w12,#20
+	add	v22.4s,v22.4s,v23.4s
+	ror	w9,w9,#20
+	eor	v24.16b,v1.16b,v2.16b
+	add	w5,w5,w10
+	eor	v25.16b,v5.16b,v6.16b
+	add	w6,w6,w11
+	eor	v26.16b,v9.16b,v10.16b
+	add	w7,w7,w12
+	eor	v27.16b,v13.16b,v14.16b
+	add	w8,w8,w9
+	eor	v28.16b,v17.16b,v18.16b
+	eor	w21,w21,w5
+	eor	v29.16b,v21.16b,v22.16b
+	eor	w17,w17,w6
+	ushr	v1.4s,v24.4s,#25
+	eor	w19,w19,w7
+	ushr	v5.4s,v25.4s,#25
+	eor	w20,w20,w8
+	ushr	v9.4s,v26.4s,#25
+	ror	w21,w21,#24
+	ushr	v13.4s,v27.4s,#25
+	ror	w17,w17,#24
+	ushr	v17.4s,v28.4s,#25
+	ror	w19,w19,#24
+	ushr	v21.4s,v29.4s,#25
+	ror	w20,w20,#24
+	sli	v1.4s,v24.4s,#7
+	add	w15,w15,w21
+	sli	v5.4s,v25.4s,#7
+	add	w16,w16,w17
+	sli	v9.4s,v26.4s,#7
+	add	w13,w13,w19
+	sli	v13.4s,v27.4s,#7
+	add	w14,w14,w20
+	sli	v17.4s,v28.4s,#7
+	eor	w10,w10,w15
+	sli	v21.4s,v29.4s,#7
+	eor	w11,w11,w16
+	ext	v2.16b,v2.16b,v2.16b,#8
+	eor	w12,w12,w13
+	ext	v6.16b,v6.16b,v6.16b,#8
+	eor	w9,w9,w14
+	ext	v10.16b,v10.16b,v10.16b,#8
+	ror	w10,w10,#25
+	ext	v14.16b,v14.16b,v14.16b,#8
+	ror	w11,w11,#25
+	ext	v18.16b,v18.16b,v18.16b,#8
+	ror	w12,w12,#25
+	ext	v22.16b,v22.16b,v22.16b,#8
+	ror	w9,w9,#25
+	ext	v3.16b,v3.16b,v3.16b,#4
+	ext	v7.16b,v7.16b,v7.16b,#4
+	ext	v11.16b,v11.16b,v11.16b,#4
+	ext	v15.16b,v15.16b,v15.16b,#4
+	ext	v19.16b,v19.16b,v19.16b,#4
+	ext	v23.16b,v23.16b,v23.16b,#4
+	ext	v1.16b,v1.16b,v1.16b,#12
+	ext	v5.16b,v5.16b,v5.16b,#12
+	ext	v9.16b,v9.16b,v9.16b,#12
+	ext	v13.16b,v13.16b,v13.16b,#12
+	ext	v17.16b,v17.16b,v17.16b,#12
+	ext	v21.16b,v21.16b,v21.16b,#12
+	cbnz	x4,.Loop_lower_neon
+
+	add	w5,w5,w22		// accumulate key block
+	ldp	q24,q25,[sp,#0]
+	add	x6,x6,x22,lsr#32
+	ldp	q26,q27,[sp,#32]
+	add	w7,w7,w23
+	ldp	q28,q29,[sp,#64]
+	add	x8,x8,x23,lsr#32
+	add	v0.4s,v0.4s,v24.4s
+	add	w9,w9,w24
+	add	v4.4s,v4.4s,v24.4s
+	add	x10,x10,x24,lsr#32
+	add	v8.4s,v8.4s,v24.4s
+	add	w11,w11,w25
+	add	v12.4s,v12.4s,v24.4s
+	add	x12,x12,x25,lsr#32
+	add	v16.4s,v16.4s,v24.4s
+	add	w13,w13,w26
+	add	v20.4s,v20.4s,v24.4s
+	add	x14,x14,x26,lsr#32
+	add	v2.4s,v2.4s,v26.4s
+	add	w15,w15,w27
+	add	v6.4s,v6.4s,v26.4s
+	add	x16,x16,x27,lsr#32
+	add	v10.4s,v10.4s,v26.4s
+	add	w17,w17,w28
+	add	v14.4s,v14.4s,v26.4s
+	add	x19,x19,x28,lsr#32
+	add	v18.4s,v18.4s,v26.4s
+	add	w20,w20,w30
+	add	v22.4s,v22.4s,v26.4s
+	add	x21,x21,x30,lsr#32
+	add	v19.4s,v19.4s,v31.4s			// +4
+	add	x5,x5,x6,lsl#32	// pack
+	add	v23.4s,v23.4s,v31.4s			// +4
+	add	x7,x7,x8,lsl#32
+	add	v3.4s,v3.4s,v27.4s
+	ldp	x6,x8,[x1,#0]		// load input
+	add	v7.4s,v7.4s,v28.4s
+	add	x9,x9,x10,lsl#32
+	add	v11.4s,v11.4s,v29.4s
+	add	x11,x11,x12,lsl#32
+	add	v15.4s,v15.4s,v30.4s
+	ldp	x10,x12,[x1,#16]
+	add	v19.4s,v19.4s,v27.4s
+	add	x13,x13,x14,lsl#32
+	add	v23.4s,v23.4s,v28.4s
+	add	x15,x15,x16,lsl#32
+	add	v1.4s,v1.4s,v25.4s
+	ldp	x14,x16,[x1,#32]
+	add	v5.4s,v5.4s,v25.4s
+	add	x17,x17,x19,lsl#32
+	add	v9.4s,v9.4s,v25.4s
+	add	x20,x20,x21,lsl#32
+	add	v13.4s,v13.4s,v25.4s
+	ldp	x19,x21,[x1,#48]
+	add	v17.4s,v17.4s,v25.4s
+	add	x1,x1,#64
+	add	v21.4s,v21.4s,v25.4s
+
+#ifdef	__ARMEB__
+	rev	x5,x5
+	rev	x7,x7
+	rev	x9,x9
+	rev	x11,x11
+	rev	x13,x13
+	rev	x15,x15
+	rev	x17,x17
+	rev	x20,x20
+#endif
+	ld1	{v24.16b,v25.16b,v26.16b,v27.16b},[x1],#64
+	eor	x5,x5,x6
+	eor	x7,x7,x8
+	eor	x9,x9,x10
+	eor	x11,x11,x12
+	eor	x13,x13,x14
+	eor	v0.16b,v0.16b,v24.16b
+	eor	x15,x15,x16
+	eor	v1.16b,v1.16b,v25.16b
+	eor	x17,x17,x19
+	eor	v2.16b,v2.16b,v26.16b
+	eor	x20,x20,x21
+	eor	v3.16b,v3.16b,v27.16b
+	ld1	{v24.16b,v25.16b,v26.16b,v27.16b},[x1],#64
+
+	stp	x5,x7,[x0,#0]		// store output
+	add	x28,x28,#7			// increment counter
+	stp	x9,x11,[x0,#16]
+	stp	x13,x15,[x0,#32]
+	stp	x17,x20,[x0,#48]
+	add	x0,x0,#64
+	st1	{v0.16b,v1.16b,v2.16b,v3.16b},[x0],#64
+
+	ld1	{v0.16b,v1.16b,v2.16b,v3.16b},[x1],#64
+	eor	v4.16b,v4.16b,v24.16b
+	eor	v5.16b,v5.16b,v25.16b
+	eor	v6.16b,v6.16b,v26.16b
+	eor	v7.16b,v7.16b,v27.16b
+	st1	{v4.16b,v5.16b,v6.16b,v7.16b},[x0],#64
+
+	ld1	{v4.16b,v5.16b,v6.16b,v7.16b},[x1],#64
+	eor	v8.16b,v8.16b,v0.16b
+	ldp	q24,q25,[sp,#0]
+	eor	v9.16b,v9.16b,v1.16b
+	ldp	q26,q27,[sp,#32]
+	eor	v10.16b,v10.16b,v2.16b
+	eor	v11.16b,v11.16b,v3.16b
+	st1	{v8.16b,v9.16b,v10.16b,v11.16b},[x0],#64
+
+	ld1	{v8.16b,v9.16b,v10.16b,v11.16b},[x1],#64
+	eor	v12.16b,v12.16b,v4.16b
+	eor	v13.16b,v13.16b,v5.16b
+	eor	v14.16b,v14.16b,v6.16b
+	eor	v15.16b,v15.16b,v7.16b
+	st1	{v12.16b,v13.16b,v14.16b,v15.16b},[x0],#64
+
+	ld1	{v12.16b,v13.16b,v14.16b,v15.16b},[x1],#64
+	eor	v16.16b,v16.16b,v8.16b
+	eor	v17.16b,v17.16b,v9.16b
+	eor	v18.16b,v18.16b,v10.16b
+	eor	v19.16b,v19.16b,v11.16b
+	st1	{v16.16b,v17.16b,v18.16b,v19.16b},[x0],#64
+
+	shl	v0.4s,v31.4s,#1			// 4 -> 8
+	eor	v20.16b,v20.16b,v12.16b
+	eor	v21.16b,v21.16b,v13.16b
+	eor	v22.16b,v22.16b,v14.16b
+	eor	v23.16b,v23.16b,v15.16b
+	st1	{v20.16b,v21.16b,v22.16b,v23.16b},[x0],#64
+
+	add	v27.4s,v27.4s,v0.4s			// += 8
+	add	v28.4s,v28.4s,v0.4s
+	add	v29.4s,v29.4s,v0.4s
+	add	v30.4s,v30.4s,v0.4s
+
+	b.hs	.Loop_outer_512_neon
+
+	adds	x2,x2,#512
+	ushr	v0.4s,v31.4s,#2			// 4 -> 1
+
+	ldp	d8,d9,[sp,#128+0]		// meet ABI requirements
+	ldp	d10,d11,[sp,#128+16]
+	ldp	d12,d13,[sp,#128+32]
+	ldp	d14,d15,[sp,#128+48]
+
+	stp	q24,q31,[sp,#0]		// wipe off-load area
+	stp	q24,q31,[sp,#32]
+	stp	q24,q31,[sp,#64]
+
+	b.eq	.Ldone_512_neon
+
+	cmp	x2,#192
+	sub	v27.4s,v27.4s,v0.4s			// -= 1
+	sub	v28.4s,v28.4s,v0.4s
+	sub	v29.4s,v29.4s,v0.4s
+	add	sp,sp,#128
+	b.hs	.Loop_outer_neon
+
+	eor	v25.16b,v25.16b,v25.16b
+	eor	v26.16b,v26.16b,v26.16b
+	eor	v27.16b,v27.16b,v27.16b
+	eor	v28.16b,v28.16b,v28.16b
+	eor	v29.16b,v29.16b,v29.16b
+	eor	v30.16b,v30.16b,v30.16b
+	b	.Loop_outer
+
+.Ldone_512_neon:
+	ldp	x19,x20,[x29,#16]
+	add	sp,sp,#128+64
+	ldp	x21,x22,[x29,#32]
+	ldp	x23,x24,[x29,#48]
+	ldp	x25,x26,[x29,#64]
+	ldp	x27,x28,[x29,#80]
+	ldp	x29,x30,[sp],#96
+	ret
+.size	ChaCha20_512_neon,.-ChaCha20_512_neon
-- 
2.19.0
