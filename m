From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next v7 08/28] zinc: port Andy Polyakov's ChaCha20 ARM and ARM64 implementations
Date: Sat,  6 Oct 2018 04:56:49 +0200
Message-Id: <20181006025709.4019-9-Jason@zx2c4.com>
In-Reply-To: <20181006025709.4019-1-Jason@zx2c4.com>
References: <20181006025709.4019-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, Samuel Neves <sneves@dei.uc.pt>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

These port and prepare Andy Polyakov's implementations for the kernel,
but don't actually wire up any of the code yet. The wiring will be done
in a subsequent commit, since we'll need to merge these implementations
with another one. We make a few small changes to the assembly:

  - Entries and exits use the proper kernel convention macro.
  - CPU feature checking is done in C by the glue code, so that has been
    removed from the assembly.
  - The function names have been renamed to fit kernel conventions.
  - Labels have been renamed (prefixed with .L) to fit kernel conventions.
  - Constants have been rearranged so that they are closer to the code
    that is using them. [ARM only]
  - The neon code can jump to the scalar code when it makes sense to do
    so.
  - The neon_512 function as a separate function has been removed, leaving
    the decision up to the main neon entry point. [ARM64 only]

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
 lib/zinc/chacha20/chacha20-arm-cryptogams.S   | 367 +++++++++---------
 lib/zinc/chacha20/chacha20-arm64-cryptogams.S |  75 ++--
 2 files changed, 202 insertions(+), 240 deletions(-)

diff --git a/lib/zinc/chacha20/chacha20-arm-cryptogams.S b/lib/zinc/chacha20/chacha20-arm-cryptogams.S
index 05a3a9e6e93f..770bab469171 100644
--- a/lib/zinc/chacha20/chacha20-arm-cryptogams.S
+++ b/lib/zinc/chacha20/chacha20-arm-cryptogams.S
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
 #if defined(__thumb2__) || defined(__clang__)
@@ -24,48 +27,25 @@
 .long	0x61707865,0x3320646e,0x79622d32,0x6b206574	@ endian-neutral
 .Lone:
 .long	1,0,0,0
-.Lrot8:
-.long	0x02010003,0x06050407
-#if __ARM_MAX_ARCH__>=7
-.LOPENSSL_armcap:
-.word   OPENSSL_armcap_P-.LChaCha20_ctr32
-#else
 .word	-1
-#endif
 
-.globl	ChaCha20_ctr32
-.type	ChaCha20_ctr32,%function
 .align	5
-ChaCha20_ctr32:
-.LChaCha20_ctr32:
+ENTRY(chacha20_arm)
 	ldr	r12,[sp,#0]		@ pull pointer to counter and nonce
 	stmdb	sp!,{r0-r2,r4-r11,lr}
-#if __ARM_ARCH__<7 && !defined(__thumb2__)
-	sub	r14,pc,#16		@ ChaCha20_ctr32
-#else
-	adr	r14,.LChaCha20_ctr32
-#endif
 	cmp	r2,#0			@ len==0?
-#ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	eq
 #endif
 	addeq	sp,sp,#4*3
-	beq	.Lno_data
-#if __ARM_MAX_ARCH__>=7
-	cmp	r2,#192			@ test len
-	bls	.Lshort
-	ldr	r4,[r14,#-24]
-	ldr	r4,[r14,r4]
-# ifdef	__APPLE__
-	ldr	r4,[r4]
-# endif
-	tst	r4,#ARMV7_NEON
-	bne	.LChaCha20_neon
-.Lshort:
-#endif
+	beq	.Lno_data_arm
 	ldmia	r12,{r4-r7}		@ load counter and nonce
 	sub	sp,sp,#4*(16)		@ off-load area
-	sub	r14,r14,#64		@ .Lsigma
+#if __LINUX_ARM_ARCH__ < 7 && !defined(__thumb2__)
+	sub	r14,pc,#100		@ .Lsigma
+#else
+	adr	r14,.Lsigma		@ .Lsigma
+#endif
 	stmdb	sp!,{r4-r7}		@ copy counter and nonce
 	ldmia	r3,{r4-r11}		@ load key
 	ldmia	r14,{r0-r3}		@ load sigma
@@ -191,7 +171,7 @@ ChaCha20_ctr32:
 	@ rx and second half at sp+4*(16+8)
 
 	cmp	r11,#64		@ done yet?
-#ifdef	__thumb2__
+#ifdef __thumb2__
 	itete	lo
 #endif
 	addlo	r12,sp,#4*(0)		@ shortcut or ...
@@ -202,49 +182,49 @@ ChaCha20_ctr32:
 	ldr	r8,[sp,#4*(0)]	@ load key material
 	ldr	r9,[sp,#4*(1)]
 
-#if __ARM_ARCH__>=6 || !defined(__ARMEB__)
-# if __ARM_ARCH__<7
+#if __LINUX_ARM_ARCH__ >= 6 || !defined(__ARMEB__)
+#if __LINUX_ARM_ARCH__ < 7
 	orr	r10,r12,r14
 	tst	r10,#3		@ are input and output aligned?
 	ldr	r10,[sp,#4*(2)]
 	bne	.Lunaligned
 	cmp	r11,#64		@ restore flags
-# else
+#else
 	ldr	r10,[sp,#4*(2)]
-# endif
+#endif
 	ldr	r11,[sp,#4*(3)]
 
 	add	r0,r0,r8	@ accumulate key material
 	add	r1,r1,r9
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhs	r8,[r12],#16		@ load input
 	ldrhs	r9,[r12,#-12]
 
 	add	r2,r2,r10
 	add	r3,r3,r11
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhs	r10,[r12,#-8]
 	ldrhs	r11,[r12,#-4]
-# if __ARM_ARCH__>=6 && defined(__ARMEB__)
+#if __LINUX_ARM_ARCH__ >= 6 && defined(__ARMEB__)
 	rev	r0,r0
 	rev	r1,r1
 	rev	r2,r2
 	rev	r3,r3
-# endif
-# ifdef	__thumb2__
+#endif
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	eorhs	r0,r0,r8	@ xor with input
 	eorhs	r1,r1,r9
 	 add	r8,sp,#4*(4)
 	str	r0,[r14],#16		@ store output
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	eorhs	r2,r2,r10
 	eorhs	r3,r3,r11
 	 ldmia	r8,{r8-r11}	@ load key material
@@ -254,34 +234,34 @@ ChaCha20_ctr32:
 
 	add	r4,r8,r4,ror#13 @ accumulate key material
 	add	r5,r9,r5,ror#13
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhs	r8,[r12],#16		@ load input
 	ldrhs	r9,[r12,#-12]
 	add	r6,r10,r6,ror#13
 	add	r7,r11,r7,ror#13
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhs	r10,[r12,#-8]
 	ldrhs	r11,[r12,#-4]
-# if __ARM_ARCH__>=6 && defined(__ARMEB__)
+#if __LINUX_ARM_ARCH__ >= 6 && defined(__ARMEB__)
 	rev	r4,r4
 	rev	r5,r5
 	rev	r6,r6
 	rev	r7,r7
-# endif
-# ifdef	__thumb2__
+#endif
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	eorhs	r4,r4,r8
 	eorhs	r5,r5,r9
 	 add	r8,sp,#4*(8)
 	str	r4,[r14],#16		@ store output
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	eorhs	r6,r6,r10
 	eorhs	r7,r7,r11
 	str	r5,[r14,#-12]
@@ -294,39 +274,39 @@ ChaCha20_ctr32:
 
 	add	r0,r0,r8	@ accumulate key material
 	add	r1,r1,r9
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhs	r8,[r12],#16		@ load input
 	ldrhs	r9,[r12,#-12]
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hi
-# endif
+#endif
 	 strhi	r10,[sp,#4*(16+10)]	@ copy "rx" while at it
 	 strhi	r11,[sp,#4*(16+11)]	@ copy "rx" while at it
 	add	r2,r2,r10
 	add	r3,r3,r11
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhs	r10,[r12,#-8]
 	ldrhs	r11,[r12,#-4]
-# if __ARM_ARCH__>=6 && defined(__ARMEB__)
+#if __LINUX_ARM_ARCH__ >= 6 && defined(__ARMEB__)
 	rev	r0,r0
 	rev	r1,r1
 	rev	r2,r2
 	rev	r3,r3
-# endif
-# ifdef	__thumb2__
+#endif
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	eorhs	r0,r0,r8
 	eorhs	r1,r1,r9
 	 add	r8,sp,#4*(12)
 	str	r0,[r14],#16		@ store output
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	eorhs	r2,r2,r10
 	eorhs	r3,r3,r11
 	str	r1,[r14,#-12]
@@ -336,79 +316,79 @@ ChaCha20_ctr32:
 
 	add	r4,r8,r4,ror#24 @ accumulate key material
 	add	r5,r9,r5,ror#24
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hi
-# endif
+#endif
 	 addhi	r8,r8,#1		@ next counter value
 	 strhi	r8,[sp,#4*(12)]	@ save next counter value
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhs	r8,[r12],#16		@ load input
 	ldrhs	r9,[r12,#-12]
 	add	r6,r10,r6,ror#24
 	add	r7,r11,r7,ror#24
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhs	r10,[r12,#-8]
 	ldrhs	r11,[r12,#-4]
-# if __ARM_ARCH__>=6 && defined(__ARMEB__)
+#if __LINUX_ARM_ARCH__ >= 6 && defined(__ARMEB__)
 	rev	r4,r4
 	rev	r5,r5
 	rev	r6,r6
 	rev	r7,r7
-# endif
-# ifdef	__thumb2__
+#endif
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	eorhs	r4,r4,r8
 	eorhs	r5,r5,r9
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	 it	ne
-# endif
+#endif
 	 ldrne	r8,[sp,#4*(32+2)]	@ re-load len
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	eorhs	r6,r6,r10
 	eorhs	r7,r7,r11
 	str	r4,[r14],#16		@ store output
 	str	r5,[r14,#-12]
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	it	hs
-# endif
+#endif
 	 subhs	r11,r8,#64		@ len-=64
 	str	r6,[r14,#-8]
 	str	r7,[r14,#-4]
 	bhi	.Loop_outer
 
 	beq	.Ldone
-# if __ARM_ARCH__<7
+#if __LINUX_ARM_ARCH__ < 7
 	b	.Ltail
 
 .align	4
 .Lunaligned:				@ unaligned endian-neutral path
 	cmp	r11,#64		@ restore flags
-# endif
 #endif
-#if __ARM_ARCH__<7
+#endif
+#if __LINUX_ARM_ARCH__ < 7
 	ldr	r11,[sp,#4*(3)]
 	add	r0,r8,r0	@ accumulate key material
 	add	r1,r9,r1
 	add	r2,r10,r2
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itete	lo
-# endif
+#endif
 	eorlo	r8,r8,r8		@ zero or ...
 	ldrhsb	r8,[r12],#16			@ ... load input
 	eorlo	r9,r9,r9
 	ldrhsb	r9,[r12,#-12]
 
 	add	r3,r11,r3
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itete	lo
-# endif
+#endif
 	eorlo	r10,r10,r10
 	ldrhsb	r10,[r12,#-8]
 	eorlo	r11,r11,r11
@@ -416,53 +396,53 @@ ChaCha20_ctr32:
 
 	eor	r0,r8,r0		@ xor with input (or zero)
 	eor	r1,r9,r1
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r8,[r12,#-15]		@ load more input
 	ldrhsb	r9,[r12,#-11]
 	eor	r2,r10,r2
 	 strb	r0,[r14],#16		@ store output
 	eor	r3,r11,r3
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r10,[r12,#-7]
 	ldrhsb	r11,[r12,#-3]
 	 strb	r1,[r14,#-12]
 	eor	r0,r8,r0,lsr#8
 	 strb	r2,[r14,#-8]
 	eor	r1,r9,r1,lsr#8
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r8,[r12,#-14]		@ load more input
 	ldrhsb	r9,[r12,#-10]
 	 strb	r3,[r14,#-4]
 	eor	r2,r10,r2,lsr#8
 	 strb	r0,[r14,#-15]
 	eor	r3,r11,r3,lsr#8
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r10,[r12,#-6]
 	ldrhsb	r11,[r12,#-2]
 	 strb	r1,[r14,#-11]
 	eor	r0,r8,r0,lsr#8
 	 strb	r2,[r14,#-7]
 	eor	r1,r9,r1,lsr#8
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r8,[r12,#-13]		@ load more input
 	ldrhsb	r9,[r12,#-9]
 	 strb	r3,[r14,#-3]
 	eor	r2,r10,r2,lsr#8
 	 strb	r0,[r14,#-14]
 	eor	r3,r11,r3,lsr#8
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r10,[r12,#-5]
 	ldrhsb	r11,[r12,#-1]
 	 strb	r1,[r14,#-10]
@@ -482,18 +462,18 @@ ChaCha20_ctr32:
 	add	r4,r8,r4,ror#13	@ accumulate key material
 	add	r5,r9,r5,ror#13
 	add	r6,r10,r6,ror#13
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itete	lo
-# endif
+#endif
 	eorlo	r8,r8,r8		@ zero or ...
 	ldrhsb	r8,[r12],#16			@ ... load input
 	eorlo	r9,r9,r9
 	ldrhsb	r9,[r12,#-12]
 
 	add	r7,r11,r7,ror#13
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itete	lo
-# endif
+#endif
 	eorlo	r10,r10,r10
 	ldrhsb	r10,[r12,#-8]
 	eorlo	r11,r11,r11
@@ -501,53 +481,53 @@ ChaCha20_ctr32:
 
 	eor	r4,r8,r4		@ xor with input (or zero)
 	eor	r5,r9,r5
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r8,[r12,#-15]		@ load more input
 	ldrhsb	r9,[r12,#-11]
 	eor	r6,r10,r6
 	 strb	r4,[r14],#16		@ store output
 	eor	r7,r11,r7
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r10,[r12,#-7]
 	ldrhsb	r11,[r12,#-3]
 	 strb	r5,[r14,#-12]
 	eor	r4,r8,r4,lsr#8
 	 strb	r6,[r14,#-8]
 	eor	r5,r9,r5,lsr#8
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r8,[r12,#-14]		@ load more input
 	ldrhsb	r9,[r12,#-10]
 	 strb	r7,[r14,#-4]
 	eor	r6,r10,r6,lsr#8
 	 strb	r4,[r14,#-15]
 	eor	r7,r11,r7,lsr#8
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r10,[r12,#-6]
 	ldrhsb	r11,[r12,#-2]
 	 strb	r5,[r14,#-11]
 	eor	r4,r8,r4,lsr#8
 	 strb	r6,[r14,#-7]
 	eor	r5,r9,r5,lsr#8
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r8,[r12,#-13]		@ load more input
 	ldrhsb	r9,[r12,#-9]
 	 strb	r7,[r14,#-3]
 	eor	r6,r10,r6,lsr#8
 	 strb	r4,[r14,#-14]
 	eor	r7,r11,r7,lsr#8
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r10,[r12,#-5]
 	ldrhsb	r11,[r12,#-1]
 	 strb	r5,[r14,#-10]
@@ -564,26 +544,26 @@ ChaCha20_ctr32:
 	add	r8,sp,#4*(4+4)
 	ldmia	r8,{r8-r11}		@ load key material
 	ldmia	r0,{r0-r7}		@ load second half
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hi
-# endif
+#endif
 	strhi	r10,[sp,#4*(16+10)]		@ copy "rx"
 	strhi	r11,[sp,#4*(16+11)]		@ copy "rx"
 	add	r0,r8,r0	@ accumulate key material
 	add	r1,r9,r1
 	add	r2,r10,r2
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itete	lo
-# endif
+#endif
 	eorlo	r8,r8,r8		@ zero or ...
 	ldrhsb	r8,[r12],#16			@ ... load input
 	eorlo	r9,r9,r9
 	ldrhsb	r9,[r12,#-12]
 
 	add	r3,r11,r3
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itete	lo
-# endif
+#endif
 	eorlo	r10,r10,r10
 	ldrhsb	r10,[r12,#-8]
 	eorlo	r11,r11,r11
@@ -591,53 +571,53 @@ ChaCha20_ctr32:
 
 	eor	r0,r8,r0		@ xor with input (or zero)
 	eor	r1,r9,r1
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r8,[r12,#-15]		@ load more input
 	ldrhsb	r9,[r12,#-11]
 	eor	r2,r10,r2
 	 strb	r0,[r14],#16		@ store output
 	eor	r3,r11,r3
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r10,[r12,#-7]
 	ldrhsb	r11,[r12,#-3]
 	 strb	r1,[r14,#-12]
 	eor	r0,r8,r0,lsr#8
 	 strb	r2,[r14,#-8]
 	eor	r1,r9,r1,lsr#8
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r8,[r12,#-14]		@ load more input
 	ldrhsb	r9,[r12,#-10]
 	 strb	r3,[r14,#-4]
 	eor	r2,r10,r2,lsr#8
 	 strb	r0,[r14,#-15]
 	eor	r3,r11,r3,lsr#8
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r10,[r12,#-6]
 	ldrhsb	r11,[r12,#-2]
 	 strb	r1,[r14,#-11]
 	eor	r0,r8,r0,lsr#8
 	 strb	r2,[r14,#-7]
 	eor	r1,r9,r1,lsr#8
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r8,[r12,#-13]		@ load more input
 	ldrhsb	r9,[r12,#-9]
 	 strb	r3,[r14,#-3]
 	eor	r2,r10,r2,lsr#8
 	 strb	r0,[r14,#-14]
 	eor	r3,r11,r3,lsr#8
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r10,[r12,#-5]
 	ldrhsb	r11,[r12,#-1]
 	 strb	r1,[r14,#-10]
@@ -654,25 +634,25 @@ ChaCha20_ctr32:
 	add	r8,sp,#4*(4+8)
 	ldmia	r8,{r8-r11}		@ load key material
 	add	r4,r8,r4,ror#24	@ accumulate key material
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hi
-# endif
+#endif
 	addhi	r8,r8,#1			@ next counter value
 	strhi	r8,[sp,#4*(12)]		@ save next counter value
 	add	r5,r9,r5,ror#24
 	add	r6,r10,r6,ror#24
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itete	lo
-# endif
+#endif
 	eorlo	r8,r8,r8		@ zero or ...
 	ldrhsb	r8,[r12],#16			@ ... load input
 	eorlo	r9,r9,r9
 	ldrhsb	r9,[r12,#-12]
 
 	add	r7,r11,r7,ror#24
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itete	lo
-# endif
+#endif
 	eorlo	r10,r10,r10
 	ldrhsb	r10,[r12,#-8]
 	eorlo	r11,r11,r11
@@ -680,53 +660,53 @@ ChaCha20_ctr32:
 
 	eor	r4,r8,r4		@ xor with input (or zero)
 	eor	r5,r9,r5
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r8,[r12,#-15]		@ load more input
 	ldrhsb	r9,[r12,#-11]
 	eor	r6,r10,r6
 	 strb	r4,[r14],#16		@ store output
 	eor	r7,r11,r7
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r10,[r12,#-7]
 	ldrhsb	r11,[r12,#-3]
 	 strb	r5,[r14,#-12]
 	eor	r4,r8,r4,lsr#8
 	 strb	r6,[r14,#-8]
 	eor	r5,r9,r5,lsr#8
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r8,[r12,#-14]		@ load more input
 	ldrhsb	r9,[r12,#-10]
 	 strb	r7,[r14,#-4]
 	eor	r6,r10,r6,lsr#8
 	 strb	r4,[r14,#-15]
 	eor	r7,r11,r7,lsr#8
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r10,[r12,#-6]
 	ldrhsb	r11,[r12,#-2]
 	 strb	r5,[r14,#-11]
 	eor	r4,r8,r4,lsr#8
 	 strb	r6,[r14,#-7]
 	eor	r5,r9,r5,lsr#8
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r8,[r12,#-13]		@ load more input
 	ldrhsb	r9,[r12,#-9]
 	 strb	r7,[r14,#-3]
 	eor	r6,r10,r6,lsr#8
 	 strb	r4,[r14,#-14]
 	eor	r7,r11,r7,lsr#8
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	itt	hs
-# endif
+#endif
 	ldrhsb	r10,[r12,#-5]
 	ldrhsb	r11,[r12,#-1]
 	 strb	r5,[r14,#-10]
@@ -740,13 +720,13 @@ ChaCha20_ctr32:
 	eor	r7,r11,r7,lsr#8
 	 strb	r6,[r14,#-5]
 	 strb	r7,[r14,#-1]
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	it	ne
-# endif
+#endif
 	ldrne	r8,[sp,#4*(32+2)]		@ re-load len
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	it	hs
-# endif
+#endif
 	subhs	r11,r8,#64			@ len-=64
 	bhi	.Loop_outer
 
@@ -768,20 +748,33 @@ ChaCha20_ctr32:
 
 .Ldone:
 	add	sp,sp,#4*(32+3)
-.Lno_data:
+.Lno_data_arm:
 	ldmia	sp!,{r4-r11,pc}
-.size	ChaCha20_ctr32,.-ChaCha20_ctr32
-#if __ARM_MAX_ARCH__>=7
+ENDPROC(chacha20_arm)
+
+#ifdef CONFIG_KERNEL_MODE_NEON
+.align	5
+.Lsigma2:
+.long	0x61707865,0x3320646e,0x79622d32,0x6b206574	@ endian-neutral
+.Lone2:
+.long	1,0,0,0
+.word	-1
+
 .arch	armv7-a
 .fpu	neon
 
-.type	ChaCha20_neon,%function
 .align	5
-ChaCha20_neon:
+ENTRY(chacha20_neon)
 	ldr		r12,[sp,#0]		@ pull pointer to counter and nonce
 	stmdb		sp!,{r0-r2,r4-r11,lr}
-.LChaCha20_neon:
-	adr		r14,.Lsigma
+	cmp		r2,#0			@ len==0?
+#ifdef	__thumb2__
+	itt		eq
+#endif
+	addeq		sp,sp,#4*3
+	beq		.Lno_data_neon
+.Lchacha20_neon_begin:
+	adr		r14,.Lsigma2
 	vstmdb		sp!,{d8-d15}		@ ABI spec says so
 	stmdb		sp!,{r0-r3}
 
@@ -1121,12 +1114,12 @@ ChaCha20_neon:
 	ldr		r10,[r12,#-8]
 	add		r3,r3,r11
 	ldr		r11,[r12,#-4]
-# ifdef	__ARMEB__
+#ifdef	__ARMEB__
 	rev		r0,r0
 	rev		r1,r1
 	rev		r2,r2
 	rev		r3,r3
-# endif
+#endif
 	eor		r0,r0,r8	@ xor with input
 	 add		r8,sp,#4*(4)
 	eor		r1,r1,r9
@@ -1146,12 +1139,12 @@ ChaCha20_neon:
 	ldr		r10,[r12,#-8]
 	add		r7,r11,r7,ror#13
 	ldr		r11,[r12,#-4]
-# ifdef	__ARMEB__
+#ifdef	__ARMEB__
 	rev		r4,r4
 	rev		r5,r5
 	rev		r6,r6
 	rev		r7,r7
-# endif
+#endif
 	eor		r4,r4,r8
 	 add		r8,sp,#4*(8)
 	eor		r5,r5,r9
@@ -1170,24 +1163,24 @@ ChaCha20_neon:
 	ldr		r8,[r12],#16		@ load input
 	add		r1,r1,r9
 	ldr		r9,[r12,#-12]
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	it	hi
-# endif
+#endif
 	 strhi		r10,[sp,#4*(16+10)]	@ copy "rx" while at it
 	add		r2,r2,r10
 	ldr		r10,[r12,#-8]
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	it	hi
-# endif
+#endif
 	 strhi		r11,[sp,#4*(16+11)]	@ copy "rx" while at it
 	add		r3,r3,r11
 	ldr		r11,[r12,#-4]
-# ifdef	__ARMEB__
+#ifdef	__ARMEB__
 	rev		r0,r0
 	rev		r1,r1
 	rev		r2,r2
 	rev		r3,r3
-# endif
+#endif
 	eor		r0,r0,r8
 	 add		r8,sp,#4*(12)
 	eor		r1,r1,r9
@@ -1210,16 +1203,16 @@ ChaCha20_neon:
 	add		r7,r11,r7,ror#24
 	ldr		r10,[r12,#-8]
 	ldr		r11,[r12,#-4]
-# ifdef	__ARMEB__
+#ifdef	__ARMEB__
 	rev		r4,r4
 	rev		r5,r5
 	rev		r6,r6
 	rev		r7,r7
-# endif
+#endif
 	eor		r4,r4,r8
-# ifdef	__thumb2__
+#ifdef __thumb2__
 	it	hi
-# endif
+#endif
 	 ldrhi		r8,[sp,#4*(32+2)]	@ re-load len
 	eor		r5,r5,r9
 	eor		r6,r6,r10
@@ -1379,7 +1372,7 @@ ChaCha20_neon:
 	add		r6,r10,r6,ror#13
 	add		r7,r11,r7,ror#13
 	 ldmia		r8,{r8-r11}	@ load key material
-# ifdef	__ARMEB__
+#ifdef	__ARMEB__
 	rev		r0,r0
 	rev		r1,r1
 	rev		r2,r2
@@ -1388,7 +1381,7 @@ ChaCha20_neon:
 	rev		r5,r5
 	rev		r6,r6
 	rev		r7,r7
-# endif
+#endif
 	stmia		sp,{r0-r7}
 	 add		r0,sp,#4*(16+8)
 
@@ -1408,7 +1401,7 @@ ChaCha20_neon:
 	add		r6,r10,r6,ror#24
 	add		r7,r11,r7,ror#24
 	 ldr		r11,[sp,#4*(32+2)]	@ re-load len
-# ifdef	__ARMEB__
+#ifdef	__ARMEB__
 	rev		r0,r0
 	rev		r1,r1
 	rev		r2,r2
@@ -1417,7 +1410,7 @@ ChaCha20_neon:
 	rev		r5,r5
 	rev		r6,r6
 	rev		r7,r7
-# endif
+#endif
 	stmia		r8,{r0-r7}
 	 add		r10,sp,#4*(0)
 	 sub		r11,r11,#64*3	@ len-=64*3
@@ -1434,7 +1427,7 @@ ChaCha20_neon:
 	add		sp,sp,#4*(32+4)
 	vldmia		sp,{d8-d15}
 	add		sp,sp,#4*(16+3)
+.Lno_data_neon:
 	ldmia		sp!,{r4-r11,pc}
-.size	ChaCha20_neon,.-ChaCha20_neon
-.comm	OPENSSL_armcap_P,4,4
+ENDPROC(chacha20_neon)
 #endif
diff --git a/lib/zinc/chacha20/chacha20-arm64-cryptogams.S b/lib/zinc/chacha20/chacha20-arm64-cryptogams.S
index 4d029bfdad3a..1ae11a5c5a14 100644
--- a/lib/zinc/chacha20/chacha20-arm64-cryptogams.S
+++ b/lib/zinc/chacha20/chacha20-arm64-cryptogams.S
@@ -1,46 +1,24 @@
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
-
-
-
 .align	5
 .Lsigma:
 .quad	0x3320646e61707865,0x6b20657479622d32		// endian-neutral
 .Lone:
 .long	1,0,0,0
-.LOPENSSL_armcap_P:
-#ifdef	__ILP32__
-.long	OPENSSL_armcap_P-.
-#else
-.quad	OPENSSL_armcap_P-.
-#endif
-.byte	67,104,97,67,104,97,50,48,32,102,111,114,32,65,82,77,118,56,44,32,67,82,89,80,84,79,71,65,77,83,32,98,121,32,60,97,112,112,114,111,64,111,112,101,110,115,115,108,46,111,114,103,62,0
-.align	2
 
-.globl	ChaCha20_ctr32
-.type	ChaCha20_ctr32,%function
 .align	5
-ChaCha20_ctr32:
+ENTRY(chacha20_arm)
 	cbz	x2,.Labort
-	adr	x5,.LOPENSSL_armcap_P
-	cmp	x2,#192
-	b.lo	.Lshort
-#ifdef	__ILP32__
-	ldrsw	x6,[x5]
-#else
-	ldr	x6,[x5]
-#endif
-	ldr	w17,[x6,x5]
-	tst	w17,#ARMV7_NEON
-	b.ne	ChaCha20_neon
 
-.Lshort:
 	stp	x29,x30,[sp,#-96]!
 	add	x29,sp,#0
 
@@ -56,7 +34,7 @@ ChaCha20_ctr32:
 	ldp	x24,x25,[x3]		// load key
 	ldp	x26,x27,[x3,#16]
 	ldp	x28,x30,[x4]		// load counter
-#ifdef	__ARMEB__
+#ifdef	__AARCH64EB__
 	ror	x24,x24,#32
 	ror	x25,x25,#32
 	ror	x26,x26,#32
@@ -217,7 +195,7 @@ ChaCha20_ctr32:
 	add	x20,x20,x21,lsl#32
 	ldp	x19,x21,[x1,#48]
 	add	x1,x1,#64
-#ifdef	__ARMEB__
+#ifdef	__AARCH64EB__
 	rev	x5,x5
 	rev	x7,x7
 	rev	x9,x9
@@ -273,7 +251,7 @@ ChaCha20_ctr32:
 	add	x15,x15,x16,lsl#32
 	add	x17,x17,x19,lsl#32
 	add	x20,x20,x21,lsl#32
-#ifdef	__ARMEB__
+#ifdef	__AARCH64EB__
 	rev	x5,x5
 	rev	x7,x7
 	rev	x9,x9
@@ -309,11 +287,13 @@ ChaCha20_ctr32:
 	ldp	x27,x28,[x29,#80]
 	ldp	x29,x30,[sp],#96
 	ret
-.size	ChaCha20_ctr32,.-ChaCha20_ctr32
+ENDPROC(chacha20_arm)
 
-.type	ChaCha20_neon,%function
+#ifdef CONFIG_KERNEL_MODE_NEON
 .align	5
-ChaCha20_neon:
+ENTRY(chacha20_neon)
+	cbz	x2,.Labort_neon
+
 	stp	x29,x30,[sp,#-96]!
 	add	x29,sp,#0
 
@@ -336,7 +316,7 @@ ChaCha20_neon:
 	ldp	x28,x30,[x4]		// load counter
 	ld1	{v27.4s},[x4]
 	ld1	{v31.4s},[x5]
-#ifdef	__ARMEB__
+#ifdef	__AARCH64EB__
 	rev64	v24.4s,v24.4s
 	ror	x24,x24,#32
 	ror	x25,x25,#32
@@ -634,7 +614,7 @@ ChaCha20_neon:
 	add	x20,x20,x21,lsl#32
 	ldp	x19,x21,[x1,#48]
 	add	x1,x1,#64
-#ifdef	__ARMEB__
+#ifdef	__AARCH64EB__
 	rev	x5,x5
 	rev	x7,x7
 	rev	x9,x9
@@ -713,7 +693,7 @@ ChaCha20_neon:
 	add	x20,x20,x21,lsl#32
 	ldp	x19,x21,[x1,#48]
 	add	x1,x1,#64
-#ifdef	__ARMEB__
+#ifdef	__AARCH64EB__
 	rev	x5,x5
 	rev	x7,x7
 	rev	x9,x9
@@ -803,19 +783,6 @@ ChaCha20_neon:
 	ldp	x27,x28,[x29,#80]
 	ldp	x29,x30,[sp],#96
 	ret
-.size	ChaCha20_neon,.-ChaCha20_neon
-.type	ChaCha20_512_neon,%function
-.align	5
-ChaCha20_512_neon:
-	stp	x29,x30,[sp,#-96]!
-	add	x29,sp,#0
-
-	adr	x5,.Lsigma
-	stp	x19,x20,[sp,#16]
-	stp	x21,x22,[sp,#32]
-	stp	x23,x24,[sp,#48]
-	stp	x25,x26,[sp,#64]
-	stp	x27,x28,[sp,#80]
 
 .L512_or_more_neon:
 	sub	sp,sp,#128+64
@@ -828,7 +795,7 @@ ChaCha20_512_neon:
 	ldp	x28,x30,[x4]		// load counter
 	ld1	{v27.4s},[x4]
 	ld1	{v31.4s},[x5]
-#ifdef	__ARMEB__
+#ifdef	__AARCH64EB__
 	rev64	v24.4s,v24.4s
 	ror	x24,x24,#32
 	ror	x25,x25,#32
@@ -1341,7 +1308,7 @@ ChaCha20_512_neon:
 	add	x20,x20,x21,lsl#32
 	ldp	x19,x21,[x1,#48]
 	add	x1,x1,#64
-#ifdef	__ARMEB__
+#ifdef	__AARCH64EB__
 	rev	x5,x5
 	rev	x7,x7
 	rev	x9,x9
@@ -1855,7 +1822,7 @@ ChaCha20_512_neon:
 	add	x1,x1,#64
 	add	v21.4s,v21.4s,v25.4s
 
-#ifdef	__ARMEB__
+#ifdef	__AARCH64EB__
 	rev	x5,x5
 	rev	x7,x7
 	rev	x9,x9
@@ -1969,5 +1936,7 @@ ChaCha20_512_neon:
 	ldp	x25,x26,[x29,#64]
 	ldp	x27,x28,[x29,#80]
 	ldp	x29,x30,[sp],#96
+.Labort_neon:
 	ret
-.size	ChaCha20_512_neon,.-ChaCha20_512_neon
+ENDPROC(chacha20_neon)
+#endif
-- 
2.19.0
