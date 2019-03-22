From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next v9 05/19] zinc: ChaCha20 ARM and ARM64 implementations
Date: Fri, 22 Mar 2019 01:11:08 -0600
Message-Id: <20190322071122.6677-6-Jason@zx2c4.com>
In-Reply-To: <20190322071122.6677-1-Jason@zx2c4.com>
References: <20190322071122.6677-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Andy Polyakov <appro@openssl.org>, Eric Biggers <ebiggers@google.com>, Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, Samuel Neves <sneves@dei.uc.pt>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, Andy Lutomirski <luto@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

These ARM implementations come from Andy Polyakov's implementation, as
well as an ultra-fast unrolled scalar version optimized for ARMv7 from
Eric Biggers, which performs well on platforms with slow NEON like
Cortex A7 and A5.

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

While this is CRYPTOGAMS code, the originating code for this happens to
be the same as OpenSSL's commit 9925a82146f2503b4dd11423d0eba649b43450c0

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Co-authored-by: Andy Polyakov <appro@openssl.org>
Co-authored-by: Eric Biggers <ebiggers@google.com>
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
 lib/zinc/Makefile                         |    4 +-
 lib/zinc/chacha20/chacha20-arm-glue.c     |   98 ++
 lib/zinc/chacha20/chacha20-arm.pl         | 1227 +++++++++++++++++++++
 lib/zinc/chacha20/chacha20-arm64.pl       | 1163 +++++++++++++++++++
 lib/zinc/chacha20/chacha20-unrolled-arm.S |  461 ++++++++
 lib/zinc/chacha20/chacha20.c              |    2 +
 6 files changed, 2954 insertions(+), 1 deletion(-)
 create mode 100644 lib/zinc/chacha20/chacha20-arm-glue.c
 create mode 100644 lib/zinc/chacha20/chacha20-arm.pl
 create mode 100644 lib/zinc/chacha20/chacha20-arm64.pl
 create mode 100644 lib/zinc/chacha20/chacha20-unrolled-arm.S

diff --git a/lib/zinc/Makefile b/lib/zinc/Makefile
index 7eb3ed68a012..841029072542 100644
--- a/lib/zinc/Makefile
+++ b/lib/zinc/Makefile
@@ -4,7 +4,9 @@ ccflags-$(CONFIG_ZINC_DEBUG) += -DDEBUG
 
 zinc_chacha20-y := chacha20/chacha20.o
 zinc_chacha20-$(CONFIG_ZINC_ARCH_X86_64) += chacha20/chacha20-x86_64.o
-perlasm-targets += chacha20/chacha20-x86_64.S
+zinc_chacha20-$(CONFIG_ZINC_ARCH_ARM) += chacha20/chacha20-arm.o chacha20/chacha20-unrolled-arm.o
+zinc_chacha20-$(CONFIG_ZINC_ARCH_ARM64) += chacha20/chacha20-arm64.o
+perlasm-targets += chacha20/chacha20-x86_64.S chacha20/chacha20-arm.S chacha20/chacha20-arm64.S
 obj-$(CONFIG_ZINC_CHACHA20) += zinc_chacha20.o
 
 quiet_cmd_perlasm = PERLASM $@
diff --git a/lib/zinc/chacha20/chacha20-arm-glue.c b/lib/zinc/chacha20/chacha20-arm-glue.c
new file mode 100644
index 000000000000..84c3bb7487b3
--- /dev/null
+++ b/lib/zinc/chacha20/chacha20-arm-glue.c
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: GPL-2.0 OR MIT
+/*
+ * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
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
diff --git a/lib/zinc/chacha20/chacha20-arm.pl b/lib/zinc/chacha20/chacha20-arm.pl
new file mode 100644
index 000000000000..6a7d62cfd2ae
--- /dev/null
+++ b/lib/zinc/chacha20/chacha20-arm.pl
@@ -0,0 +1,1227 @@
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
+# December 2014
+#
+# ChaCha20 for ARMv4.
+#
+# September 2018
+#
+# Improve scalar performance per Eric Biggers' suggestion to eliminate
+# separate rotates. This requires b[0..3] and d[0..3] to be maintained
+# pre-rotated, hence odd twists prior inner loop and when accumulating
+# key material. Since amount of instructions is reduced as result, even
+# NEON performance is improved somewhat, most notably by ~9% on low-end
+# Cortex-A5/A7. Full unroll was shown to provide even better scalar
+# performance on Cortex-A5/A7, naturally at the cost of manyfold size
+# increase. We let it be. Oversized code works in benchmarks, but is not
+# necessarily optimal in real life, when it's likely to be out-of-cache
+# upon entry and evict significant part of cache upon completion.
+#
+# Performance in cycles per byte out of large buffer.
+#
+#			IALU/gcc-4.4    1xNEON      3xNEON+1xIALU
+#
+# Cortex-A5		14.2(*)/+160%   21.8        12.9(**)
+# Cortex-A8		10.2(*)/+190%   13.9        6.10
+# Cortex-A9		10.8(*)/+150%   14.3        6.50
+# Cortex-A15		11.0/+40%       16.0        4.90
+# Snapdragon S4		13.9(***)/+90%  13.6        4.90
+#
+# (*)	most "favourable" result for aligned data on little-endian
+#	processor, result for misaligned data is 10-15% lower;
+# (**)	pure 4xNEON [with "vertical" layout] was shown to provide ~8%
+#	better performance on Cortex-A5/A7, but not on others;
+# (***)	it's 17% slower than original, trade-off is considered
+#	acceptable, because of improvement on others, specifically
+#	+36% on Cortex-A5/A7 and +20% on Cortex-A9;
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
+sub AUTOLOAD()		# thunk [simplified] x86-style perlasm
+{ my $opcode = $AUTOLOAD; $opcode =~ s/.*:://; $opcode =~ s/_/\./;
+  my $arg = pop;
+    $arg = "#$arg" if ($arg*1 eq $arg);
+    $code .= "\t$opcode\t".join(',',@_,$arg)."\n";
+}
+
+my @x=map("r$_",(0..7,"x","x","x","x",12,"x",14,"x"));
+my @t=map("r$_",(8..11));
+
+sub ROUND {
+my ($a0,$b0,$c0,$d0)=@_;
+my ($a1,$b1,$c1,$d1)=map(($_&~3)+(($_+1)&3),($a0,$b0,$c0,$d0));
+my ($a2,$b2,$c2,$d2)=map(($_&~3)+(($_+1)&3),($a1,$b1,$c1,$d1));
+my ($a3,$b3,$c3,$d3)=map(($_&~3)+(($_+1)&3),($a2,$b2,$c2,$d2));
+my $odd = $d0&1;
+my ($xc,$xc_) = (@t[0..1]);
+my ($xd,$xd_) = $odd ? (@t[2],@x[$d1]) : (@x[$d0],@t[2]);
+my @ret;
+
+	# Consider order in which variables are addressed by their
+	# index:
+	#
+	#       a   b   c   d
+	#
+	#       0   4   8  12 < even round
+	#       1   5   9  13
+	#       2   6  10  14
+	#       3   7  11  15
+	#       0   5  10  15 < odd round
+	#       1   6  11  12
+	#       2   7   8  13
+	#       3   4   9  14
+	#
+	# 'a', 'b' are permanently allocated in registers, @x[0..7],
+	# while 'c's and pair of 'd's are maintained in memory. If
+	# you observe 'c' column, you'll notice that pair of 'c's is
+	# invariant between rounds. This means that we have to reload
+	# them once per round, in the middle. This is why you'll see
+	# bunch of 'c' stores and loads in the middle, but none in
+	# the beginning or end. If you observe 'd' column, you'll
+	# notice that 15 and 13 are reused in next pair of rounds.
+	# This is why these two are chosen for offloading to memory,
+	# to make loads count more.
+							push @ret,(
+	"&add	(@x[$a0],@x[$a0],@x[$b0],'ror#13')",
+	 "&add	(@x[$a1],@x[$a1],@x[$b1],'ror#13')",
+	"&eor	($xd,@x[$a0],$xd,'ror#24')",
+	 "&eor	($xd_,@x[$a1],$xd_,'ror#24')",
+
+	"&add	($xc,$xc,$xd,'ror#16')",
+	 "&add	($xc_,$xc_,$xd_,'ror#16')",
+	"&eor	(@x[$b0],$xc, @x[$b0],'ror#13')",
+	 "&eor	(@x[$b1],$xc_,@x[$b1],'ror#13')",
+
+	"&add	(@x[$a0],@x[$a0],@x[$b0],'ror#20')",
+	 "&add	(@x[$a1],@x[$a1],@x[$b1],'ror#20')",
+	"&eor	($xd,@x[$a0],$xd,'ror#16')",
+	 "&eor	($xd_,@x[$a1],$xd_,'ror#16')"		);
+							push @ret,(
+	"&str	($xd,'[sp,#4*(16+$d0)]')"		) if ($odd);
+							push @ret,(
+	"&add	($xc,$xc,$xd,'ror#24')"			);
+							push @ret,(
+	"&ldr	($xd,'[sp,#4*(16+$d2)]')"		) if ($odd);
+							push @ret,(
+	 "&str	($xd_,'[sp,#4*(16+$d1)]')"		) if (!$odd);
+							push @ret,(
+	 "&add	($xc_,$xc_,$xd_,'ror#24')"		);
+							push @ret,(
+	 "&ldr	($xd_,'[sp,#4*(16+$d3)]')"		) if (!$odd);
+							push @ret,(
+	"&str	($xc,'[sp,#4*(16+$c0)]')",
+	"&eor	(@x[$b0],@x[$b0],$xc,'ror#12')",
+	 "&str	($xc_,'[sp,#4*(16+$c1)]')",
+	 "&eor	(@x[$b1],@x[$b1],$xc_,'ror#12')"	);
+
+	$xd=@x[$d2]					if (!$odd);
+	$xd_=@x[$d3]					if ($odd);
+							push @ret,(
+	"&ldr	($xc,'[sp,#4*(16+$c2)]')",
+	"&add	(@x[$a2],@x[$a2],@x[$b2],'ror#13')",
+	 "&ldr	($xc_,'[sp,#4*(16+$c3)]')",
+	 "&add	(@x[$a3],@x[$a3],@x[$b3],'ror#13')",
+	"&eor	($xd,@x[$a2],$xd,'ror#24')",
+	 "&eor	($xd_,@x[$a3],$xd_,'ror#24')",
+
+	"&add	($xc,$xc,$xd,'ror#16')",
+	 "&add	($xc_,$xc_,$xd_,'ror#16')",
+	"&eor	(@x[$b2],$xc, @x[$b2],'ror#13')",
+	 "&eor	(@x[$b3],$xc_,@x[$b3],'ror#13')",
+
+	"&add	(@x[$a2],@x[$a2],@x[$b2],'ror#20')",
+	 "&add	(@x[$a3],@x[$a3],@x[$b3],'ror#20')",
+	"&eor	($xd,@x[$a2],$xd,'ror#16')",
+	 "&eor	($xd_,@x[$a3],$xd_,'ror#16')",
+
+	"&add	($xc,$xc,$xd,'ror#24')",
+	 "&add	($xc_,$xc_,$xd_,'ror#24')",
+	"&eor	(@x[$b2],@x[$b2],$xc,'ror#12')",
+	 "&eor	(@x[$b3],@x[$b3],$xc_,'ror#12')"	);
+
+	@ret;
+}
+
+$code.=<<___;
+#ifndef __KERNEL__
+# include "arm_arch.h"
+#else
+# define __ARM_ARCH__ __LINUX_ARM_ARCH__
+# define __ARM_MAX_ARCH__ __LINUX_ARM_ARCH__
+# define ChaCha20_ctr32 chacha20_arm_cryptogams
+# define ChaCha20_neon  chacha20_neon
+#endif
+
+.text
+#if defined(__thumb2__) || defined(__clang__)
+.syntax	unified
+# define ldrhsb	ldrbhs
+#endif
+#if defined(__thumb2__)
+.thumb
+#else
+.code	32
+#endif
+
+.align	5
+.Lsigma:
+.long	0x61707865,0x3320646e,0x79622d32,0x6b206574	@ endian-neutral
+.Lone:
+.long	1,0,0,0
+.Lrot8:
+.long	0x02010003,0x06050407
+#if __ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
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
+#if __ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
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
+	str	r10,[sp,#4*(16+10)]	@ off-load "@x[10]"
+	str	r11,[sp,#4*(16+11)]	@ off-load "@x[11]"
+	b	.Loop_outer_enter
+
+.align	4
+.Loop_outer:
+	ldmia	sp,{r0-r9}		@ load key material
+	str	@t[3],[sp,#4*(32+2)]	@ save len
+	str	r12,  [sp,#4*(32+1)]	@ save inp
+	str	r14,  [sp,#4*(32+0)]	@ save out
+.Loop_outer_enter:
+	ldr	@t[3], [sp,#4*(15)]
+	 mov	@x[4],@x[4],ror#19	@ twist b[0..3]
+	ldr	@x[12],[sp,#4*(12)]	@ modulo-scheduled load
+	 mov	@x[5],@x[5],ror#19
+	ldr	@t[2], [sp,#4*(13)]
+	 mov	@x[6],@x[6],ror#19
+	ldr	@x[14],[sp,#4*(14)]
+	 mov	@x[7],@x[7],ror#19
+	mov	@t[3],@t[3],ror#8	@ twist d[0..3]
+	mov	@x[12],@x[12],ror#8
+	mov	@t[2],@t[2],ror#8
+	mov	@x[14],@x[14],ror#8
+	str	@t[3], [sp,#4*(16+15)]
+	mov	@t[3],#10
+	b	.Loop
+
+.align	4
+.Loop:
+	subs	@t[3],@t[3],#1
+___
+	foreach (&ROUND(0, 4, 8,12)) { eval; }
+	foreach (&ROUND(0, 5,10,15)) { eval; }
+$code.=<<___;
+	bne	.Loop
+
+	ldr	@t[3],[sp,#4*(32+2)]	@ load len
+
+	str	@t[0], [sp,#4*(16+8)]	@ modulo-scheduled store
+	str	@t[1], [sp,#4*(16+9)]
+	str	@x[12],[sp,#4*(16+12)]
+	str	@t[2], [sp,#4*(16+13)]
+	str	@x[14],[sp,#4*(16+14)]
+
+	@ at this point we have first half of 512-bit result in
+	@ @x[0-7] and second half at sp+4*(16+8)
+
+	cmp	@t[3],#64		@ done yet?
+#ifdef	__thumb2__
+	itete	lo
+#endif
+	addlo	r12,sp,#4*(0)		@ shortcut or ...
+	ldrhs	r12,[sp,#4*(32+1)]	@ ... load inp
+	addlo	r14,sp,#4*(0)		@ shortcut or ...
+	ldrhs	r14,[sp,#4*(32+0)]	@ ... load out
+
+	ldr	@t[0],[sp,#4*(0)]	@ load key material
+	ldr	@t[1],[sp,#4*(1)]
+
+#if __ARM_ARCH__>=6 || !defined(__ARMEB__)
+# if __ARM_ARCH__<7
+	orr	@t[2],r12,r14
+	tst	@t[2],#3		@ are input and output aligned?
+	ldr	@t[2],[sp,#4*(2)]
+	bne	.Lunaligned
+	cmp	@t[3],#64		@ restore flags
+# else
+	ldr	@t[2],[sp,#4*(2)]
+# endif
+	ldr	@t[3],[sp,#4*(3)]
+
+	add	@x[0],@x[0],@t[0]	@ accumulate key material
+	add	@x[1],@x[1],@t[1]
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhs	@t[0],[r12],#16		@ load input
+	ldrhs	@t[1],[r12,#-12]
+
+	add	@x[2],@x[2],@t[2]
+	add	@x[3],@x[3],@t[3]
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhs	@t[2],[r12,#-8]
+	ldrhs	@t[3],[r12,#-4]
+# if __ARM_ARCH__>=6 && defined(__ARMEB__)
+	rev	@x[0],@x[0]
+	rev	@x[1],@x[1]
+	rev	@x[2],@x[2]
+	rev	@x[3],@x[3]
+# endif
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	eorhs	@x[0],@x[0],@t[0]	@ xor with input
+	eorhs	@x[1],@x[1],@t[1]
+	 add	@t[0],sp,#4*(4)
+	str	@x[0],[r14],#16		@ store output
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	eorhs	@x[2],@x[2],@t[2]
+	eorhs	@x[3],@x[3],@t[3]
+	 ldmia	@t[0],{@t[0]-@t[3]}	@ load key material
+	str	@x[1],[r14,#-12]
+	str	@x[2],[r14,#-8]
+	str	@x[3],[r14,#-4]
+
+	add	@x[4],@t[0],@x[4],ror#13 @ accumulate key material
+	add	@x[5],@t[1],@x[5],ror#13
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhs	@t[0],[r12],#16		@ load input
+	ldrhs	@t[1],[r12,#-12]
+	add	@x[6],@t[2],@x[6],ror#13
+	add	@x[7],@t[3],@x[7],ror#13
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhs	@t[2],[r12,#-8]
+	ldrhs	@t[3],[r12,#-4]
+# if __ARM_ARCH__>=6 && defined(__ARMEB__)
+	rev	@x[4],@x[4]
+	rev	@x[5],@x[5]
+	rev	@x[6],@x[6]
+	rev	@x[7],@x[7]
+# endif
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	eorhs	@x[4],@x[4],@t[0]
+	eorhs	@x[5],@x[5],@t[1]
+	 add	@t[0],sp,#4*(8)
+	str	@x[4],[r14],#16		@ store output
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	eorhs	@x[6],@x[6],@t[2]
+	eorhs	@x[7],@x[7],@t[3]
+	str	@x[5],[r14,#-12]
+	 ldmia	@t[0],{@t[0]-@t[3]}	@ load key material
+	str	@x[6],[r14,#-8]
+	 add	@x[0],sp,#4*(16+8)
+	str	@x[7],[r14,#-4]
+
+	ldmia	@x[0],{@x[0]-@x[7]}	@ load second half
+
+	add	@x[0],@x[0],@t[0]	@ accumulate key material
+	add	@x[1],@x[1],@t[1]
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhs	@t[0],[r12],#16		@ load input
+	ldrhs	@t[1],[r12,#-12]
+# ifdef	__thumb2__
+	itt	hi
+# endif
+	 strhi	@t[2],[sp,#4*(16+10)]	@ copy "@x[10]" while at it
+	 strhi	@t[3],[sp,#4*(16+11)]	@ copy "@x[11]" while at it
+	add	@x[2],@x[2],@t[2]
+	add	@x[3],@x[3],@t[3]
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhs	@t[2],[r12,#-8]
+	ldrhs	@t[3],[r12,#-4]
+# if __ARM_ARCH__>=6 && defined(__ARMEB__)
+	rev	@x[0],@x[0]
+	rev	@x[1],@x[1]
+	rev	@x[2],@x[2]
+	rev	@x[3],@x[3]
+# endif
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	eorhs	@x[0],@x[0],@t[0]
+	eorhs	@x[1],@x[1],@t[1]
+	 add	@t[0],sp,#4*(12)
+	str	@x[0],[r14],#16		@ store output
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	eorhs	@x[2],@x[2],@t[2]
+	eorhs	@x[3],@x[3],@t[3]
+	str	@x[1],[r14,#-12]
+	 ldmia	@t[0],{@t[0]-@t[3]}	@ load key material
+	str	@x[2],[r14,#-8]
+	str	@x[3],[r14,#-4]
+
+	add	@x[4],@t[0],@x[4],ror#24 @ accumulate key material
+	add	@x[5],@t[1],@x[5],ror#24
+# ifdef	__thumb2__
+	itt	hi
+# endif
+	 addhi	@t[0],@t[0],#1		@ next counter value
+	 strhi	@t[0],[sp,#4*(12)]	@ save next counter value
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhs	@t[0],[r12],#16		@ load input
+	ldrhs	@t[1],[r12,#-12]
+	add	@x[6],@t[2],@x[6],ror#24
+	add	@x[7],@t[3],@x[7],ror#24
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhs	@t[2],[r12,#-8]
+	ldrhs	@t[3],[r12,#-4]
+# if __ARM_ARCH__>=6 && defined(__ARMEB__)
+	rev	@x[4],@x[4]
+	rev	@x[5],@x[5]
+	rev	@x[6],@x[6]
+	rev	@x[7],@x[7]
+# endif
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	eorhs	@x[4],@x[4],@t[0]
+	eorhs	@x[5],@x[5],@t[1]
+# ifdef	__thumb2__
+	 it	ne
+# endif
+	 ldrne	@t[0],[sp,#4*(32+2)]	@ re-load len
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	eorhs	@x[6],@x[6],@t[2]
+	eorhs	@x[7],@x[7],@t[3]
+	str	@x[4],[r14],#16		@ store output
+	str	@x[5],[r14,#-12]
+# ifdef	__thumb2__
+	it	hs
+# endif
+	 subhs	@t[3],@t[0],#64		@ len-=64
+	str	@x[6],[r14,#-8]
+	str	@x[7],[r14,#-4]
+	bhi	.Loop_outer
+
+	beq	.Ldone
+# if __ARM_ARCH__<7
+	b	.Ltail
+
+.align	4
+.Lunaligned:				@ unaligned endian-neutral path
+	cmp	@t[3],#64		@ restore flags
+# endif
+#endif
+#if __ARM_ARCH__<7
+	ldr	@t[3],[sp,#4*(3)]
+___
+for ($i=0;$i<16;$i+=4) {
+my $j=$i&0x7;
+my $twist="";
+if ($i==4)     { $twist = ",ror#13"; }
+elsif ($i==12) { $twist = ",ror#24"; }
+
+$code.=<<___	if ($i==4);
+	add	@x[0],sp,#4*(16+8)
+___
+$code.=<<___	if ($i==8);
+	ldmia	@x[0],{@x[0]-@x[7]}		@ load second half
+# ifdef	__thumb2__
+	itt	hi
+# endif
+	strhi	@t[2],[sp,#4*(16+10)]		@ copy "@x[10]"
+	strhi	@t[3],[sp,#4*(16+11)]		@ copy "@x[11]"
+___
+$code.=<<___;
+	add	@x[$j+0],@t[0],@x[$j+0]$twist	@ accumulate key material
+___
+$code.=<<___	if ($i==12);
+# ifdef	__thumb2__
+	itt	hi
+# endif
+	addhi	@t[0],@t[0],#1			@ next counter value
+	strhi	@t[0],[sp,#4*(12)]		@ save next counter value
+___
+$code.=<<___;
+	add	@x[$j+1],@t[1],@x[$j+1]$twist
+	add	@x[$j+2],@t[2],@x[$j+2]$twist
+# ifdef	__thumb2__
+	itete	lo
+# endif
+	eorlo	@t[0],@t[0],@t[0]		@ zero or ...
+	ldrhsb	@t[0],[r12],#16			@ ... load input
+	eorlo	@t[1],@t[1],@t[1]
+	ldrhsb	@t[1],[r12,#-12]
+
+	add	@x[$j+3],@t[3],@x[$j+3]$twist
+# ifdef	__thumb2__
+	itete	lo
+# endif
+	eorlo	@t[2],@t[2],@t[2]
+	ldrhsb	@t[2],[r12,#-8]
+	eorlo	@t[3],@t[3],@t[3]
+	ldrhsb	@t[3],[r12,#-4]
+
+	eor	@x[$j+0],@t[0],@x[$j+0]		@ xor with input (or zero)
+	eor	@x[$j+1],@t[1],@x[$j+1]
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	@t[0],[r12,#-15]		@ load more input
+	ldrhsb	@t[1],[r12,#-11]
+	eor	@x[$j+2],@t[2],@x[$j+2]
+	 strb	@x[$j+0],[r14],#16		@ store output
+	eor	@x[$j+3],@t[3],@x[$j+3]
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	@t[2],[r12,#-7]
+	ldrhsb	@t[3],[r12,#-3]
+	 strb	@x[$j+1],[r14,#-12]
+	eor	@x[$j+0],@t[0],@x[$j+0],lsr#8
+	 strb	@x[$j+2],[r14,#-8]
+	eor	@x[$j+1],@t[1],@x[$j+1],lsr#8
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	@t[0],[r12,#-14]		@ load more input
+	ldrhsb	@t[1],[r12,#-10]
+	 strb	@x[$j+3],[r14,#-4]
+	eor	@x[$j+2],@t[2],@x[$j+2],lsr#8
+	 strb	@x[$j+0],[r14,#-15]
+	eor	@x[$j+3],@t[3],@x[$j+3],lsr#8
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	@t[2],[r12,#-6]
+	ldrhsb	@t[3],[r12,#-2]
+	 strb	@x[$j+1],[r14,#-11]
+	eor	@x[$j+0],@t[0],@x[$j+0],lsr#8
+	 strb	@x[$j+2],[r14,#-7]
+	eor	@x[$j+1],@t[1],@x[$j+1],lsr#8
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	@t[0],[r12,#-13]		@ load more input
+	ldrhsb	@t[1],[r12,#-9]
+	 strb	@x[$j+3],[r14,#-3]
+	eor	@x[$j+2],@t[2],@x[$j+2],lsr#8
+	 strb	@x[$j+0],[r14,#-14]
+	eor	@x[$j+3],@t[3],@x[$j+3],lsr#8
+# ifdef	__thumb2__
+	itt	hs
+# endif
+	ldrhsb	@t[2],[r12,#-5]
+	ldrhsb	@t[3],[r12,#-1]
+	 strb	@x[$j+1],[r14,#-10]
+	 strb	@x[$j+2],[r14,#-6]
+	eor	@x[$j+0],@t[0],@x[$j+0],lsr#8
+	 strb	@x[$j+3],[r14,#-2]
+	eor	@x[$j+1],@t[1],@x[$j+1],lsr#8
+	 strb	@x[$j+0],[r14,#-13]
+	eor	@x[$j+2],@t[2],@x[$j+2],lsr#8
+	 strb	@x[$j+1],[r14,#-9]
+	eor	@x[$j+3],@t[3],@x[$j+3],lsr#8
+	 strb	@x[$j+2],[r14,#-5]
+	 strb	@x[$j+3],[r14,#-1]
+___
+$code.=<<___	if ($i<12);
+	add	@t[0],sp,#4*(4+$i)
+	ldmia	@t[0],{@t[0]-@t[3]}		@ load key material
+___
+}
+$code.=<<___;
+# ifdef	__thumb2__
+	it	ne
+# endif
+	ldrne	@t[0],[sp,#4*(32+2)]		@ re-load len
+# ifdef	__thumb2__
+	it	hs
+# endif
+	subhs	@t[3],@t[0],#64			@ len-=64
+	bhi	.Loop_outer
+
+	beq	.Ldone
+#endif
+
+.Ltail:
+	ldr	r12,[sp,#4*(32+1)]	@ load inp
+	add	@t[1],sp,#4*(0)
+	ldr	r14,[sp,#4*(32+0)]	@ load out
+
+.Loop_tail:
+	ldrb	@t[2],[@t[1]],#1	@ read buffer on stack
+	ldrb	@t[3],[r12],#1		@ read input
+	subs	@t[0],@t[0],#1
+	eor	@t[3],@t[3],@t[2]
+	strb	@t[3],[r14],#1		@ store output
+	bne	.Loop_tail
+
+.Ldone:
+	add	sp,sp,#4*(32+3)
+.Lno_data:
+#if __ARM_ARCH__>=5
+	ldmia	sp!,{r4-r11,pc}
+#else
+	ldmia	sp!,{r4-r12,lr}
+	tst	lr,#1
+	moveq	pc,lr			@ be binary compatible with V4, yet
+	.long	0xe12fff1e		@ interoperable with Thumb ISA:-)
+#endif
+.size	ChaCha20_ctr32,.-ChaCha20_ctr32
+___
+
+{{{
+my ($a0,$b0,$c0,$d0,$a1,$b1,$c1,$d1,$a2,$b2,$c2,$d2,$t0,$t1,$t2,$t3) =
+    map("q$_",(0..15));
+
+# This can replace vshr-by-24+vsli-by-8. It gives ~3% improvement on
+# Cortex-A5/A7, but hurts Cortex-A9 by 5% and Snapdragon S4 by 14%!
+sub vperm()
+{ my ($dst,$src,$tbl) = @_;
+    $code .= "	vtbl.8	$dst#lo,{$src#lo},$tbl#lo\n";
+    $code .= "	vtbl.8	$dst#hi,{$src#hi},$tbl#lo\n";
+}
+
+sub NEONROUND {
+my $odd = pop;
+my ($a,$b,$c,$d,$t)=@_;
+
+	(
+	"&vadd_i32	($a,$a,$b)",
+	"&veor		($d,$d,$a)",
+	"&vrev32_16	($d,$d)",	# vrot ($d,16)
+
+	"&vadd_i32	($c,$c,$d)",
+	"&veor		($t,$b,$c)",
+	"&vshr_u32	($b,$t,20)",
+	"&vsli_32	($b,$t,12)",
+
+	"&vadd_i32	($a,$a,$b)",
+	"&veor		($t,$d,$a)",
+	"&vshr_u32	($d,$t,24)",
+	"&vsli_32	($d,$t,8)",
+	#"&vperm	($d,$t,$t3)",
+
+	"&vadd_i32	($c,$c,$d)",
+	"&veor		($t,$b,$c)",
+	"&vshr_u32	($b,$t,25)",
+	"&vsli_32	($b,$t,7)",
+
+	"&vext_8	($c,$c,$c,8)",
+	"&vext_8	($b,$b,$b,$odd?12:4)",
+	"&vext_8	($d,$d,$d,$odd?4:12)"
+	);
+}
+
+$code.=<<___;
+#if (defined(__KERNEL__) && defined(CONFIG_KERNEL_MODE_NEON)) || (!defined(__KERNEL__) && __ARM_MAX_ARCH__>=7)
+.arch	armv7-a
+.fpu	neon
+
+# ifdef __KERNEL__
+.globl	ChaCha20_neon
+@ For optimal performance it's appropriate for caller to enforce
+@ minimum input length, 193 bytes is suggested.
+# endif
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
+	vld1.32		{$b0-$c0},[r3]		@ load key
+	ldmia		r3,{r4-r11}		@ load key
+
+	sub		sp,sp,#4*(16+16)
+	vld1.32		{$d0},[r12]		@ load counter and nonce
+	add		r12,sp,#4*8
+	ldmia		r14,{r0-r3}		@ load sigma
+	vld1.32		{$a0},[r14]!		@ load sigma
+	vld1.32		{$t0},[r14]!		@ one
+	@ vld1.32	{$t3#lo},[r14]		@ rot8
+	vst1.32		{$c0-$d0},[r12]		@ copy 1/2key|counter|nonce
+	vst1.32		{$a0-$b0},[sp]		@ copy sigma|1/2key
+
+	str		r10,[sp,#4*(16+10)]	@ off-load "@x[10]"
+	str		r11,[sp,#4*(16+11)]	@ off-load "@x[11]"
+	vshl.i32	$t1#lo,$t0#lo,#1	@ two
+	vstr		$t0#lo,[sp,#4*(16+0)]
+	vshl.i32	$t2#lo,$t0#lo,#2	@ four
+	vstr		$t1#lo,[sp,#4*(16+2)]
+	vmov		$a1,$a0
+	vstr		$t2#lo,[sp,#4*(16+4)]
+	vmov		$a2,$a0
+	@ vstr		$t3#lo,[sp,#4*(16+6)]
+	vmov		$b1,$b0
+	vmov		$b2,$b0
+	b		.Loop_neon_enter
+
+.align	4
+.Loop_neon_outer:
+	ldmia		sp,{r0-r9}		@ load key material
+	cmp		@t[3],#64*2		@ if len<=64*2
+	bls		.Lbreak_neon		@ switch to integer-only
+	@ vldr		$t3#lo,[sp,#4*(16+6)]	@ rot8
+	vmov		$a1,$a0
+	str		@t[3],[sp,#4*(32+2)]	@ save len
+	vmov		$a2,$a0
+	str		r12,  [sp,#4*(32+1)]	@ save inp
+	vmov		$b1,$b0
+	str		r14,  [sp,#4*(32+0)]	@ save out
+	vmov		$b2,$b0
+.Loop_neon_enter:
+	ldr		@t[3], [sp,#4*(15)]
+	 mov		@x[4],@x[4],ror#19	@ twist b[0..3]
+	vadd.i32	$d1,$d0,$t0		@ counter+1
+	ldr		@x[12],[sp,#4*(12)]	@ modulo-scheduled load
+	 mov		@x[5],@x[5],ror#19
+	vmov		$c1,$c0
+	ldr		@t[2], [sp,#4*(13)]
+	 mov		@x[6],@x[6],ror#19
+	vmov		$c2,$c0
+	ldr		@x[14],[sp,#4*(14)]
+	 mov		@x[7],@x[7],ror#19
+	vadd.i32	$d2,$d1,$t0		@ counter+2
+	add		@x[12],@x[12],#3	@ counter+3
+	mov		@t[3],@t[3],ror#8	@ twist d[0..3]
+	mov		@x[12],@x[12],ror#8
+	mov		@t[2],@t[2],ror#8
+	mov		@x[14],@x[14],ror#8
+	str		@t[3], [sp,#4*(16+15)]
+	mov		@t[3],#10
+	b		.Loop_neon
+
+.align	4
+.Loop_neon:
+	subs		@t[3],@t[3],#1
+___
+	my @thread0=&NEONROUND($a0,$b0,$c0,$d0,$t0,0);
+	my @thread1=&NEONROUND($a1,$b1,$c1,$d1,$t1,0);
+	my @thread2=&NEONROUND($a2,$b2,$c2,$d2,$t2,0);
+	my @thread3=&ROUND(0,4,8,12);
+
+	foreach (@thread0) {
+		eval;			eval(shift(@thread3));
+		eval(shift(@thread1));	eval(shift(@thread3));
+		eval(shift(@thread2));	eval(shift(@thread3));
+	}
+
+	@thread0=&NEONROUND($a0,$b0,$c0,$d0,$t0,1);
+	@thread1=&NEONROUND($a1,$b1,$c1,$d1,$t1,1);
+	@thread2=&NEONROUND($a2,$b2,$c2,$d2,$t2,1);
+	@thread3=&ROUND(0,5,10,15);
+
+	foreach (@thread0) {
+		eval;			eval(shift(@thread3));
+		eval(shift(@thread1));	eval(shift(@thread3));
+		eval(shift(@thread2));	eval(shift(@thread3));
+	}
+$code.=<<___;
+	bne		.Loop_neon
+
+	add		@t[3],sp,#32
+	vld1.32		{$t0-$t1},[sp]		@ load key material
+	vld1.32		{$t2-$t3},[@t[3]]
+
+	ldr		@t[3],[sp,#4*(32+2)]	@ load len
+
+	str		@t[0], [sp,#4*(16+8)]	@ modulo-scheduled store
+	str		@t[1], [sp,#4*(16+9)]
+	str		@x[12],[sp,#4*(16+12)]
+	str		@t[2], [sp,#4*(16+13)]
+	str		@x[14],[sp,#4*(16+14)]
+
+	@ at this point we have first half of 512-bit result in
+	@ @x[0-7] and second half at sp+4*(16+8)
+
+	ldr		r12,[sp,#4*(32+1)]	@ load inp
+	ldr		r14,[sp,#4*(32+0)]	@ load out
+
+	vadd.i32	$a0,$a0,$t0		@ accumulate key material
+	vadd.i32	$a1,$a1,$t0
+	vadd.i32	$a2,$a2,$t0
+	vldr		$t0#lo,[sp,#4*(16+0)]	@ one
+
+	vadd.i32	$b0,$b0,$t1
+	vadd.i32	$b1,$b1,$t1
+	vadd.i32	$b2,$b2,$t1
+	vldr		$t1#lo,[sp,#4*(16+2)]	@ two
+
+	vadd.i32	$c0,$c0,$t2
+	vadd.i32	$c1,$c1,$t2
+	vadd.i32	$c2,$c2,$t2
+	vadd.i32	$d1#lo,$d1#lo,$t0#lo	@ counter+1
+	vadd.i32	$d2#lo,$d2#lo,$t1#lo	@ counter+2
+
+	vadd.i32	$d0,$d0,$t3
+	vadd.i32	$d1,$d1,$t3
+	vadd.i32	$d2,$d2,$t3
+
+	cmp		@t[3],#64*4
+	blo		.Ltail_neon
+
+	vld1.8		{$t0-$t1},[r12]!	@ load input
+	 mov		@t[3],sp
+	vld1.8		{$t2-$t3},[r12]!
+	veor		$a0,$a0,$t0		@ xor with input
+	veor		$b0,$b0,$t1
+	vld1.8		{$t0-$t1},[r12]!
+	veor		$c0,$c0,$t2
+	veor		$d0,$d0,$t3
+	vld1.8		{$t2-$t3},[r12]!
+
+	veor		$a1,$a1,$t0
+	 vst1.8		{$a0-$b0},[r14]!	@ store output
+	veor		$b1,$b1,$t1
+	vld1.8		{$t0-$t1},[r12]!
+	veor		$c1,$c1,$t2
+	 vst1.8		{$c0-$d0},[r14]!
+	veor		$d1,$d1,$t3
+	vld1.8		{$t2-$t3},[r12]!
+
+	veor		$a2,$a2,$t0
+	 vld1.32	{$a0-$b0},[@t[3]]!	@ load for next iteration
+	 veor		$t0#hi,$t0#hi,$t0#hi
+	 vldr		$t0#lo,[sp,#4*(16+4)]	@ four
+	veor		$b2,$b2,$t1
+	 vld1.32	{$c0-$d0},[@t[3]]
+	veor		$c2,$c2,$t2
+	 vst1.8		{$a1-$b1},[r14]!
+	veor		$d2,$d2,$t3
+	 vst1.8		{$c1-$d1},[r14]!
+
+	vadd.i32	$d0#lo,$d0#lo,$t0#lo	@ next counter value
+	vldr		$t0#lo,[sp,#4*(16+0)]	@ one
+
+	ldmia		sp,{@t[0]-@t[3]}	@ load key material
+	add		@x[0],@x[0],@t[0]	@ accumulate key material
+	ldr		@t[0],[r12],#16		@ load input
+	 vst1.8		{$a2-$b2},[r14]!
+	add		@x[1],@x[1],@t[1]
+	ldr		@t[1],[r12,#-12]
+	 vst1.8		{$c2-$d2},[r14]!
+	add		@x[2],@x[2],@t[2]
+	ldr		@t[2],[r12,#-8]
+	add		@x[3],@x[3],@t[3]
+	ldr		@t[3],[r12,#-4]
+# ifdef	__ARMEB__
+	rev		@x[0],@x[0]
+	rev		@x[1],@x[1]
+	rev		@x[2],@x[2]
+	rev		@x[3],@x[3]
+# endif
+	eor		@x[0],@x[0],@t[0]	@ xor with input
+	 add		@t[0],sp,#4*(4)
+	eor		@x[1],@x[1],@t[1]
+	str		@x[0],[r14],#16		@ store output
+	eor		@x[2],@x[2],@t[2]
+	str		@x[1],[r14,#-12]
+	eor		@x[3],@x[3],@t[3]
+	 ldmia		@t[0],{@t[0]-@t[3]}	@ load key material
+	str		@x[2],[r14,#-8]
+	str		@x[3],[r14,#-4]
+
+	add		@x[4],@t[0],@x[4],ror#13 @ accumulate key material
+	ldr		@t[0],[r12],#16		@ load input
+	add		@x[5],@t[1],@x[5],ror#13
+	ldr		@t[1],[r12,#-12]
+	add		@x[6],@t[2],@x[6],ror#13
+	ldr		@t[2],[r12,#-8]
+	add		@x[7],@t[3],@x[7],ror#13
+	ldr		@t[3],[r12,#-4]
+# ifdef	__ARMEB__
+	rev		@x[4],@x[4]
+	rev		@x[5],@x[5]
+	rev		@x[6],@x[6]
+	rev		@x[7],@x[7]
+# endif
+	eor		@x[4],@x[4],@t[0]
+	 add		@t[0],sp,#4*(8)
+	eor		@x[5],@x[5],@t[1]
+	str		@x[4],[r14],#16		@ store output
+	eor		@x[6],@x[6],@t[2]
+	str		@x[5],[r14,#-12]
+	eor		@x[7],@x[7],@t[3]
+	 ldmia		@t[0],{@t[0]-@t[3]}	@ load key material
+	str		@x[6],[r14,#-8]
+	 add		@x[0],sp,#4*(16+8)
+	str		@x[7],[r14,#-4]
+
+	ldmia		@x[0],{@x[0]-@x[7]}	@ load second half
+
+	add		@x[0],@x[0],@t[0]	@ accumulate key material
+	ldr		@t[0],[r12],#16		@ load input
+	add		@x[1],@x[1],@t[1]
+	ldr		@t[1],[r12,#-12]
+# ifdef	__thumb2__
+	it	hi
+# endif
+	 strhi		@t[2],[sp,#4*(16+10)]	@ copy "@x[10]" while at it
+	add		@x[2],@x[2],@t[2]
+	ldr		@t[2],[r12,#-8]
+# ifdef	__thumb2__
+	it	hi
+# endif
+	 strhi		@t[3],[sp,#4*(16+11)]	@ copy "@x[11]" while at it
+	add		@x[3],@x[3],@t[3]
+	ldr		@t[3],[r12,#-4]
+# ifdef	__ARMEB__
+	rev		@x[0],@x[0]
+	rev		@x[1],@x[1]
+	rev		@x[2],@x[2]
+	rev		@x[3],@x[3]
+# endif
+	eor		@x[0],@x[0],@t[0]
+	 add		@t[0],sp,#4*(12)
+	eor		@x[1],@x[1],@t[1]
+	str		@x[0],[r14],#16		@ store output
+	eor		@x[2],@x[2],@t[2]
+	str		@x[1],[r14,#-12]
+	eor		@x[3],@x[3],@t[3]
+	 ldmia		@t[0],{@t[0]-@t[3]}	@ load key material
+	str		@x[2],[r14,#-8]
+	str		@x[3],[r14,#-4]
+
+	add		@x[4],@t[0],@x[4],ror#24 @ accumulate key material
+	 add		@t[0],@t[0],#4		@ next counter value
+	add		@x[5],@t[1],@x[5],ror#24
+	 str		@t[0],[sp,#4*(12)]	@ save next counter value
+	ldr		@t[0],[r12],#16		@ load input
+	add		@x[6],@t[2],@x[6],ror#24
+	 add		@x[4],@x[4],#3		@ counter+3
+	ldr		@t[1],[r12,#-12]
+	add		@x[7],@t[3],@x[7],ror#24
+	ldr		@t[2],[r12,#-8]
+	ldr		@t[3],[r12,#-4]
+# ifdef	__ARMEB__
+	rev		@x[4],@x[4]
+	rev		@x[5],@x[5]
+	rev		@x[6],@x[6]
+	rev		@x[7],@x[7]
+# endif
+	eor		@x[4],@x[4],@t[0]
+# ifdef	__thumb2__
+	it	hi
+# endif
+	 ldrhi		@t[0],[sp,#4*(32+2)]	@ re-load len
+	eor		@x[5],@x[5],@t[1]
+	eor		@x[6],@x[6],@t[2]
+	str		@x[4],[r14],#16		@ store output
+	eor		@x[7],@x[7],@t[3]
+	str		@x[5],[r14,#-12]
+	 sub		@t[3],@t[0],#64*4	@ len-=64*4
+	str		@x[6],[r14,#-8]
+	str		@x[7],[r14,#-4]
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
+	str		@t[3], [sp,#4*(20+32+2)]	@ save len
+	 add		@t[3],sp,#4*(32+4)
+	str		r12,   [sp,#4*(20+32+1)]	@ save inp
+	str		r14,   [sp,#4*(20+32+0)]	@ save out
+
+	ldr		@x[12],[sp,#4*(16+10)]
+	ldr		@x[14],[sp,#4*(16+11)]
+	 vldmia		@t[3],{d8-d15}			@ fulfill ABI requirement
+	str		@x[12],[sp,#4*(20+16+10)]	@ copy "@x[10]"
+	str		@x[14],[sp,#4*(20+16+11)]	@ copy "@x[11]"
+
+	ldr		@t[3], [sp,#4*(15)]
+	 mov		@x[4],@x[4],ror#19		@ twist b[0..3]
+	ldr		@x[12],[sp,#4*(12)]		@ modulo-scheduled load
+	 mov		@x[5],@x[5],ror#19
+	ldr		@t[2], [sp,#4*(13)]
+	 mov		@x[6],@x[6],ror#19
+	ldr		@x[14],[sp,#4*(14)]
+	 mov		@x[7],@x[7],ror#19
+	mov		@t[3],@t[3],ror#8		@ twist d[0..3]
+	mov		@x[12],@x[12],ror#8
+	mov		@t[2],@t[2],ror#8
+	mov		@x[14],@x[14],ror#8
+	str		@t[3], [sp,#4*(20+16+15)]
+	add		@t[3],sp,#4*(20)
+	vst1.32		{$a0-$b0},[@t[3]]!		@ copy key
+	add		sp,sp,#4*(20)			@ switch frame
+	vst1.32		{$c0-$d0},[@t[3]]
+	mov		@t[3],#10
+	b		.Loop				@ go integer-only
+
+.align	4
+.Ltail_neon:
+	cmp		@t[3],#64*3
+	bhs		.L192_or_more_neon
+	cmp		@t[3],#64*2
+	bhs		.L128_or_more_neon
+	cmp		@t[3],#64*1
+	bhs		.L64_or_more_neon
+
+	add		@t[0],sp,#4*(8)
+	vst1.8		{$a0-$b0},[sp]
+	add		@t[2],sp,#4*(0)
+	vst1.8		{$c0-$d0},[@t[0]]
+	b		.Loop_tail_neon
+
+.align	4
+.L64_or_more_neon:
+	vld1.8		{$t0-$t1},[r12]!
+	vld1.8		{$t2-$t3},[r12]!
+	veor		$a0,$a0,$t0
+	veor		$b0,$b0,$t1
+	veor		$c0,$c0,$t2
+	veor		$d0,$d0,$t3
+	vst1.8		{$a0-$b0},[r14]!
+	vst1.8		{$c0-$d0},[r14]!
+
+	beq		.Ldone_neon
+
+	add		@t[0],sp,#4*(8)
+	vst1.8		{$a1-$b1},[sp]
+	add		@t[2],sp,#4*(0)
+	vst1.8		{$c1-$d1},[@t[0]]
+	sub		@t[3],@t[3],#64*1	@ len-=64*1
+	b		.Loop_tail_neon
+
+.align	4
+.L128_or_more_neon:
+	vld1.8		{$t0-$t1},[r12]!
+	vld1.8		{$t2-$t3},[r12]!
+	veor		$a0,$a0,$t0
+	veor		$b0,$b0,$t1
+	vld1.8		{$t0-$t1},[r12]!
+	veor		$c0,$c0,$t2
+	veor		$d0,$d0,$t3
+	vld1.8		{$t2-$t3},[r12]!
+
+	veor		$a1,$a1,$t0
+	veor		$b1,$b1,$t1
+	 vst1.8		{$a0-$b0},[r14]!
+	veor		$c1,$c1,$t2
+	 vst1.8		{$c0-$d0},[r14]!
+	veor		$d1,$d1,$t3
+	vst1.8		{$a1-$b1},[r14]!
+	vst1.8		{$c1-$d1},[r14]!
+
+	beq		.Ldone_neon
+
+	add		@t[0],sp,#4*(8)
+	vst1.8		{$a2-$b2},[sp]
+	add		@t[2],sp,#4*(0)
+	vst1.8		{$c2-$d2},[@t[0]]
+	sub		@t[3],@t[3],#64*2	@ len-=64*2
+	b		.Loop_tail_neon
+
+.align	4
+.L192_or_more_neon:
+	vld1.8		{$t0-$t1},[r12]!
+	vld1.8		{$t2-$t3},[r12]!
+	veor		$a0,$a0,$t0
+	veor		$b0,$b0,$t1
+	vld1.8		{$t0-$t1},[r12]!
+	veor		$c0,$c0,$t2
+	veor		$d0,$d0,$t3
+	vld1.8		{$t2-$t3},[r12]!
+
+	veor		$a1,$a1,$t0
+	veor		$b1,$b1,$t1
+	vld1.8		{$t0-$t1},[r12]!
+	veor		$c1,$c1,$t2
+	 vst1.8		{$a0-$b0},[r14]!
+	veor		$d1,$d1,$t3
+	vld1.8		{$t2-$t3},[r12]!
+
+	veor		$a2,$a2,$t0
+	 vst1.8		{$c0-$d0},[r14]!
+	veor		$b2,$b2,$t1
+	 vst1.8		{$a1-$b1},[r14]!
+	veor		$c2,$c2,$t2
+	 vst1.8		{$c1-$d1},[r14]!
+	veor		$d2,$d2,$t3
+	vst1.8		{$a2-$b2},[r14]!
+	vst1.8		{$c2-$d2},[r14]!
+
+	beq		.Ldone_neon
+
+	ldmia		sp,{@t[0]-@t[3]}	@ load key material
+	add		@x[0],@x[0],@t[0]	@ accumulate key material
+	 add		@t[0],sp,#4*(4)
+	add		@x[1],@x[1],@t[1]
+	add		@x[2],@x[2],@t[2]
+	add		@x[3],@x[3],@t[3]
+	 ldmia		@t[0],{@t[0]-@t[3]}	@ load key material
+
+	add		@x[4],@t[0],@x[4],ror#13 @ accumulate key material
+	 add		@t[0],sp,#4*(8)
+	add		@x[5],@t[1],@x[5],ror#13
+	add		@x[6],@t[2],@x[6],ror#13
+	add		@x[7],@t[3],@x[7],ror#13
+	 ldmia		@t[0],{@t[0]-@t[3]}	@ load key material
+# ifdef	__ARMEB__
+	rev		@x[0],@x[0]
+	rev		@x[1],@x[1]
+	rev		@x[2],@x[2]
+	rev		@x[3],@x[3]
+	rev		@x[4],@x[4]
+	rev		@x[5],@x[5]
+	rev		@x[6],@x[6]
+	rev		@x[7],@x[7]
+# endif
+	stmia		sp,{@x[0]-@x[7]}
+	 add		@x[0],sp,#4*(16+8)
+
+	ldmia		@x[0],{@x[0]-@x[7]}	@ load second half
+
+	add		@x[0],@x[0],@t[0]	@ accumulate key material
+	 add		@t[0],sp,#4*(12)
+	add		@x[1],@x[1],@t[1]
+	add		@x[2],@x[2],@t[2]
+	add		@x[3],@x[3],@t[3]
+	 ldmia		@t[0],{@t[0]-@t[3]}	@ load key material
+
+	add		@x[4],@t[0],@x[4],ror#24 @ accumulate key material
+	 add		@t[0],sp,#4*(8)
+	add		@x[5],@t[1],@x[5],ror#24
+	 add		@x[4],@x[4],#3		@ counter+3
+	add		@x[6],@t[2],@x[6],ror#24
+	add		@x[7],@t[3],@x[7],ror#24
+	 ldr		@t[3],[sp,#4*(32+2)]	@ re-load len
+# ifdef	__ARMEB__
+	rev		@x[0],@x[0]
+	rev		@x[1],@x[1]
+	rev		@x[2],@x[2]
+	rev		@x[3],@x[3]
+	rev		@x[4],@x[4]
+	rev		@x[5],@x[5]
+	rev		@x[6],@x[6]
+	rev		@x[7],@x[7]
+# endif
+	stmia		@t[0],{@x[0]-@x[7]}
+	 add		@t[2],sp,#4*(0)
+	 sub		@t[3],@t[3],#64*3	@ len-=64*3
+
+.Loop_tail_neon:
+	ldrb		@t[0],[@t[2]],#1	@ read buffer on stack
+	ldrb		@t[1],[r12],#1		@ read input
+	subs		@t[3],@t[3],#1
+	eor		@t[0],@t[0],@t[1]
+	strb		@t[0],[r14],#1		@ store output
+	bne		.Loop_tail_neon
+
+.Ldone_neon:
+	add		sp,sp,#4*(32+4)
+	vldmia		sp,{d8-d15}
+	add		sp,sp,#4*(16+3)
+	ldmia		sp!,{r4-r11,pc}
+.size	ChaCha20_neon,.-ChaCha20_neon
+# ifndef __KERNEL__
+.comm	OPENSSL_armcap_P,4,4
+# endif
+#endif
+___
+}}}
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
+	s/\bq([0-9]+)#(lo|hi)/sprintf "d%d",2*$1+($2 eq "hi")/geo;
+
+	print $_,"\n";
+}
+close STDOUT;
diff --git a/lib/zinc/chacha20/chacha20-arm64.pl b/lib/zinc/chacha20/chacha20-arm64.pl
new file mode 100644
index 000000000000..fc63cc818eca
--- /dev/null
+++ b/lib/zinc/chacha20/chacha20-arm64.pl
@@ -0,0 +1,1163 @@
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
+# June 2015
+#
+# ChaCha20 for ARMv8.
+#
+# Performance in cycles per byte out of large buffer.
+#
+#			IALU/gcc-4.9    3xNEON+1xIALU	6xNEON+2xIALU(*)
+#
+# Apple A7		5.50/+49%       3.33            1.70
+# Cortex-A53		8.40/+80%       4.72		4.72(**)
+# Cortex-A57		8.06/+43%       4.90            4.43(***)
+# Denver		4.50/+82%       2.63		2.67(**)
+# X-Gene		9.50/+46%       8.82		8.89(**)
+# Mongoose		8.00/+44%	3.64		3.25(***)
+# Kryo			8.17/+50%	4.83		4.65(***)
+#
+# (*)	since no non-Apple processor exhibits significantly better
+#	performance, the code path is #ifdef __APPLE__-ed;
+# (**)	it's expected that doubling interleave factor doesn't help
+#	all processors, only those with higher NEON latency and
+#	higher instruction issue rate;
+# (***)	expected improvement was actually higher;
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
+sub AUTOLOAD()		# thunk [simplified] x86-style perlasm
+{ my $opcode = $AUTOLOAD; $opcode =~ s/.*:://; $opcode =~ s/_/\./;
+  my $arg = pop;
+    $arg = "#$arg" if ($arg*1 eq $arg);
+    $code .= "\t$opcode\t".join(',',@_,$arg)."\n";
+}
+
+my ($out,$inp,$len,$key,$ctr) = map("x$_",(0..4));
+
+my @x=map("x$_",(5..17,19..21));
+my @d=map("x$_",(22..28,30));
+
+sub ROUND {
+my ($a0,$b0,$c0,$d0)=@_;
+my ($a1,$b1,$c1,$d1)=map(($_&~3)+(($_+1)&3),($a0,$b0,$c0,$d0));
+my ($a2,$b2,$c2,$d2)=map(($_&~3)+(($_+1)&3),($a1,$b1,$c1,$d1));
+my ($a3,$b3,$c3,$d3)=map(($_&~3)+(($_+1)&3),($a2,$b2,$c2,$d2));
+
+    (
+	"&add_32	(@x[$a0],@x[$a0],@x[$b0])",
+	 "&add_32	(@x[$a1],@x[$a1],@x[$b1])",
+	  "&add_32	(@x[$a2],@x[$a2],@x[$b2])",
+	   "&add_32	(@x[$a3],@x[$a3],@x[$b3])",
+	"&eor_32	(@x[$d0],@x[$d0],@x[$a0])",
+	 "&eor_32	(@x[$d1],@x[$d1],@x[$a1])",
+	  "&eor_32	(@x[$d2],@x[$d2],@x[$a2])",
+	   "&eor_32	(@x[$d3],@x[$d3],@x[$a3])",
+	"&ror_32	(@x[$d0],@x[$d0],16)",
+	 "&ror_32	(@x[$d1],@x[$d1],16)",
+	  "&ror_32	(@x[$d2],@x[$d2],16)",
+	   "&ror_32	(@x[$d3],@x[$d3],16)",
+
+	"&add_32	(@x[$c0],@x[$c0],@x[$d0])",
+	 "&add_32	(@x[$c1],@x[$c1],@x[$d1])",
+	  "&add_32	(@x[$c2],@x[$c2],@x[$d2])",
+	   "&add_32	(@x[$c3],@x[$c3],@x[$d3])",
+	"&eor_32	(@x[$b0],@x[$b0],@x[$c0])",
+	 "&eor_32	(@x[$b1],@x[$b1],@x[$c1])",
+	  "&eor_32	(@x[$b2],@x[$b2],@x[$c2])",
+	   "&eor_32	(@x[$b3],@x[$b3],@x[$c3])",
+	"&ror_32	(@x[$b0],@x[$b0],20)",
+	 "&ror_32	(@x[$b1],@x[$b1],20)",
+	  "&ror_32	(@x[$b2],@x[$b2],20)",
+	   "&ror_32	(@x[$b3],@x[$b3],20)",
+
+	"&add_32	(@x[$a0],@x[$a0],@x[$b0])",
+	 "&add_32	(@x[$a1],@x[$a1],@x[$b1])",
+	  "&add_32	(@x[$a2],@x[$a2],@x[$b2])",
+	   "&add_32	(@x[$a3],@x[$a3],@x[$b3])",
+	"&eor_32	(@x[$d0],@x[$d0],@x[$a0])",
+	 "&eor_32	(@x[$d1],@x[$d1],@x[$a1])",
+	  "&eor_32	(@x[$d2],@x[$d2],@x[$a2])",
+	   "&eor_32	(@x[$d3],@x[$d3],@x[$a3])",
+	"&ror_32	(@x[$d0],@x[$d0],24)",
+	 "&ror_32	(@x[$d1],@x[$d1],24)",
+	  "&ror_32	(@x[$d2],@x[$d2],24)",
+	   "&ror_32	(@x[$d3],@x[$d3],24)",
+
+	"&add_32	(@x[$c0],@x[$c0],@x[$d0])",
+	 "&add_32	(@x[$c1],@x[$c1],@x[$d1])",
+	  "&add_32	(@x[$c2],@x[$c2],@x[$d2])",
+	   "&add_32	(@x[$c3],@x[$c3],@x[$d3])",
+	"&eor_32	(@x[$b0],@x[$b0],@x[$c0])",
+	 "&eor_32	(@x[$b1],@x[$b1],@x[$c1])",
+	  "&eor_32	(@x[$b2],@x[$b2],@x[$c2])",
+	   "&eor_32	(@x[$b3],@x[$b3],@x[$c3])",
+	"&ror_32	(@x[$b0],@x[$b0],25)",
+	 "&ror_32	(@x[$b1],@x[$b1],25)",
+	  "&ror_32	(@x[$b2],@x[$b2],25)",
+	   "&ror_32	(@x[$b3],@x[$b3],25)"
+    );
+}
+
+$code.=<<___;
+#ifndef	__KERNEL__
+# include "arm_arch.h"
+.extern	OPENSSL_armcap_P
+#else
+# define ChaCha20_ctr32 chacha20_arm
+# define ChaCha20_neon  chacha20_neon
+#endif
+
+.text
+
+.align	5
+.Lsigma:
+.quad	0x3320646e61707865,0x6b20657479622d32		// endian-neutral
+.Lone:
+.long	1,0,0,0
+#ifndef	__KERNEL__
+.LOPENSSL_armcap_P:
+# ifdef	__ILP32__
+.long	OPENSSL_armcap_P-.
+# else
+.quad	OPENSSL_armcap_P-.
+# endif
+#endif
+
+.globl	ChaCha20_ctr32
+.type	ChaCha20_ctr32,%function
+.align	5
+ChaCha20_ctr32:
+	cbz	$len,.Labort
+#ifndef	__KERNEL__
+	adr	@x[0],.LOPENSSL_armcap_P
+	cmp	$len,#192
+	b.lo	.Lshort
+# ifdef	__ILP32__
+	ldrsw	@x[1],[@x[0]]
+# else
+	ldr	@x[1],[@x[0]]
+# endif
+	ldr	w17,[@x[1],@x[0]]
+	tst	w17,#ARMV7_NEON
+	b.ne	ChaCha20_neon
+
+.Lshort:
+#endif
+	stp	x29,x30,[sp,#-96]!
+	add	x29,sp,#0
+
+	adr	@x[0],.Lsigma
+	stp	x19,x20,[sp,#16]
+	stp	x21,x22,[sp,#32]
+	stp	x23,x24,[sp,#48]
+	stp	x25,x26,[sp,#64]
+	stp	x27,x28,[sp,#80]
+	sub	sp,sp,#64
+
+	ldp	@d[0],@d[1],[@x[0]]		// load sigma
+	ldp	@d[2],@d[3],[$key]		// load key
+	ldp	@d[4],@d[5],[$key,#16]
+	ldp	@d[6],@d[7],[$ctr]		// load counter
+#ifdef	__AARCH64EB__
+	ror	@d[2],@d[2],#32
+	ror	@d[3],@d[3],#32
+	ror	@d[4],@d[4],#32
+	ror	@d[5],@d[5],#32
+	ror	@d[6],@d[6],#32
+	ror	@d[7],@d[7],#32
+#endif
+
+.Loop_outer:
+	mov.32	@x[0],@d[0]			// unpack key block
+	lsr	@x[1],@d[0],#32
+	mov.32	@x[2],@d[1]
+	lsr	@x[3],@d[1],#32
+	mov.32	@x[4],@d[2]
+	lsr	@x[5],@d[2],#32
+	mov.32	@x[6],@d[3]
+	lsr	@x[7],@d[3],#32
+	mov.32	@x[8],@d[4]
+	lsr	@x[9],@d[4],#32
+	mov.32	@x[10],@d[5]
+	lsr	@x[11],@d[5],#32
+	mov.32	@x[12],@d[6]
+	lsr	@x[13],@d[6],#32
+	mov.32	@x[14],@d[7]
+	lsr	@x[15],@d[7],#32
+
+	mov	$ctr,#10
+	subs	$len,$len,#64
+.Loop:
+	sub	$ctr,$ctr,#1
+___
+	foreach (&ROUND(0, 4, 8,12)) { eval; }
+	foreach (&ROUND(0, 5,10,15)) { eval; }
+$code.=<<___;
+	cbnz	$ctr,.Loop
+
+	add.32	@x[0],@x[0],@d[0]		// accumulate key block
+	add	@x[1],@x[1],@d[0],lsr#32
+	add.32	@x[2],@x[2],@d[1]
+	add	@x[3],@x[3],@d[1],lsr#32
+	add.32	@x[4],@x[4],@d[2]
+	add	@x[5],@x[5],@d[2],lsr#32
+	add.32	@x[6],@x[6],@d[3]
+	add	@x[7],@x[7],@d[3],lsr#32
+	add.32	@x[8],@x[8],@d[4]
+	add	@x[9],@x[9],@d[4],lsr#32
+	add.32	@x[10],@x[10],@d[5]
+	add	@x[11],@x[11],@d[5],lsr#32
+	add.32	@x[12],@x[12],@d[6]
+	add	@x[13],@x[13],@d[6],lsr#32
+	add.32	@x[14],@x[14],@d[7]
+	add	@x[15],@x[15],@d[7],lsr#32
+
+	b.lo	.Ltail
+
+	add	@x[0],@x[0],@x[1],lsl#32	// pack
+	add	@x[2],@x[2],@x[3],lsl#32
+	ldp	@x[1],@x[3],[$inp,#0]		// load input
+	add	@x[4],@x[4],@x[5],lsl#32
+	add	@x[6],@x[6],@x[7],lsl#32
+	ldp	@x[5],@x[7],[$inp,#16]
+	add	@x[8],@x[8],@x[9],lsl#32
+	add	@x[10],@x[10],@x[11],lsl#32
+	ldp	@x[9],@x[11],[$inp,#32]
+	add	@x[12],@x[12],@x[13],lsl#32
+	add	@x[14],@x[14],@x[15],lsl#32
+	ldp	@x[13],@x[15],[$inp,#48]
+	add	$inp,$inp,#64
+#ifdef	__AARCH64EB__
+	rev	@x[0],@x[0]
+	rev	@x[2],@x[2]
+	rev	@x[4],@x[4]
+	rev	@x[6],@x[6]
+	rev	@x[8],@x[8]
+	rev	@x[10],@x[10]
+	rev	@x[12],@x[12]
+	rev	@x[14],@x[14]
+#endif
+	eor	@x[0],@x[0],@x[1]
+	eor	@x[2],@x[2],@x[3]
+	eor	@x[4],@x[4],@x[5]
+	eor	@x[6],@x[6],@x[7]
+	eor	@x[8],@x[8],@x[9]
+	eor	@x[10],@x[10],@x[11]
+	eor	@x[12],@x[12],@x[13]
+	eor	@x[14],@x[14],@x[15]
+
+	stp	@x[0],@x[2],[$out,#0]		// store output
+	 add	@d[6],@d[6],#1			// increment counter
+	stp	@x[4],@x[6],[$out,#16]
+	stp	@x[8],@x[10],[$out,#32]
+	stp	@x[12],@x[14],[$out,#48]
+	add	$out,$out,#64
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
+	add	$len,$len,#64
+.Less_than_64:
+	sub	$out,$out,#1
+	add	$inp,$inp,$len
+	add	$out,$out,$len
+	add	$ctr,sp,$len
+	neg	$len,$len
+
+	add	@x[0],@x[0],@x[1],lsl#32	// pack
+	add	@x[2],@x[2],@x[3],lsl#32
+	add	@x[4],@x[4],@x[5],lsl#32
+	add	@x[6],@x[6],@x[7],lsl#32
+	add	@x[8],@x[8],@x[9],lsl#32
+	add	@x[10],@x[10],@x[11],lsl#32
+	add	@x[12],@x[12],@x[13],lsl#32
+	add	@x[14],@x[14],@x[15],lsl#32
+#ifdef	__AARCH64EB__
+	rev	@x[0],@x[0]
+	rev	@x[2],@x[2]
+	rev	@x[4],@x[4]
+	rev	@x[6],@x[6]
+	rev	@x[8],@x[8]
+	rev	@x[10],@x[10]
+	rev	@x[12],@x[12]
+	rev	@x[14],@x[14]
+#endif
+	stp	@x[0],@x[2],[sp,#0]
+	stp	@x[4],@x[6],[sp,#16]
+	stp	@x[8],@x[10],[sp,#32]
+	stp	@x[12],@x[14],[sp,#48]
+
+.Loop_tail:
+	ldrb	w10,[$inp,$len]
+	ldrb	w11,[$ctr,$len]
+	add	$len,$len,#1
+	eor	w10,w10,w11
+	strb	w10,[$out,$len]
+	cbnz	$len,.Loop_tail
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
+___
+
+{{{
+my ($A0,$B0,$C0,$D0,$A1,$B1,$C1,$D1,$A2,$B2,$C2,$D2,$T0,$T1,$T2,$T3) =
+    map("v$_.4s",(0..7,16..23));
+my (@K)=map("v$_.4s",(24..30));
+my $ONE="v31.4s";
+
+sub NEONROUND {
+my $odd = pop;
+my ($a,$b,$c,$d,$t)=@_;
+
+	(
+	"&add		('$a','$a','$b')",
+	"&eor		('$d','$d','$a')",
+	"&rev32_16	('$d','$d')",		# vrot ($d,16)
+
+	"&add		('$c','$c','$d')",
+	"&eor		('$t','$b','$c')",
+	"&ushr		('$b','$t',20)",
+	"&sli		('$b','$t',12)",
+
+	"&add		('$a','$a','$b')",
+	"&eor		('$t','$d','$a')",
+	"&ushr		('$d','$t',24)",
+	"&sli		('$d','$t',8)",
+
+	"&add		('$c','$c','$d')",
+	"&eor		('$t','$b','$c')",
+	"&ushr		('$b','$t',25)",
+	"&sli		('$b','$t',7)",
+
+	"&ext		('$c','$c','$c',8)",
+	"&ext		('$d','$d','$d',$odd?4:12)",
+	"&ext		('$b','$b','$b',$odd?12:4)"
+	);
+}
+
+$code.=<<___;
+#if !defined(__KERNEL__) || defined(CONFIG_KERNEL_MODE_NEON)
+#ifdef __KERNEL__
+.globl  ChaCha20_neon
+.type   ChaCha20_neon,%function
+#endif
+.type	ChaCha20_neon,%function
+.align	5
+ChaCha20_neon:
+	stp	x29,x30,[sp,#-96]!
+	add	x29,sp,#0
+
+	adr	@x[0],.Lsigma
+	stp	x19,x20,[sp,#16]
+	stp	x21,x22,[sp,#32]
+	stp	x23,x24,[sp,#48]
+	stp	x25,x26,[sp,#64]
+	stp	x27,x28,[sp,#80]
+#ifdef	__APPLE__
+	cmp	$len,#512
+	b.hs	.L512_or_more_neon
+#endif
+
+	sub	sp,sp,#64
+
+	ldp	@d[0],@d[1],[@x[0]]		// load sigma
+	ld1	{@K[0]},[@x[0]],#16
+	ldp	@d[2],@d[3],[$key]		// load key
+	ldp	@d[4],@d[5],[$key,#16]
+	ld1	{@K[1],@K[2]},[$key]
+	ldp	@d[6],@d[7],[$ctr]		// load counter
+	ld1	{@K[3]},[$ctr]
+	ld1	{$ONE},[@x[0]]
+#ifdef	__AARCH64EB__
+	rev64	@K[0],@K[0]
+	ror	@d[2],@d[2],#32
+	ror	@d[3],@d[3],#32
+	ror	@d[4],@d[4],#32
+	ror	@d[5],@d[5],#32
+	ror	@d[6],@d[6],#32
+	ror	@d[7],@d[7],#32
+#endif
+	add	@K[3],@K[3],$ONE		// += 1
+	add	@K[4],@K[3],$ONE
+	add	@K[5],@K[4],$ONE
+	shl	$ONE,$ONE,#2			// 1 -> 4
+
+.Loop_outer_neon:
+	mov.32	@x[0],@d[0]			// unpack key block
+	lsr	@x[1],@d[0],#32
+	 mov	$A0,@K[0]
+	mov.32	@x[2],@d[1]
+	lsr	@x[3],@d[1],#32
+	 mov	$A1,@K[0]
+	mov.32	@x[4],@d[2]
+	lsr	@x[5],@d[2],#32
+	 mov	$A2,@K[0]
+	mov.32	@x[6],@d[3]
+	 mov	$B0,@K[1]
+	lsr	@x[7],@d[3],#32
+	 mov	$B1,@K[1]
+	mov.32	@x[8],@d[4]
+	 mov	$B2,@K[1]
+	lsr	@x[9],@d[4],#32
+	 mov	$D0,@K[3]
+	mov.32	@x[10],@d[5]
+	 mov	$D1,@K[4]
+	lsr	@x[11],@d[5],#32
+	 mov	$D2,@K[5]
+	mov.32	@x[12],@d[6]
+	 mov	$C0,@K[2]
+	lsr	@x[13],@d[6],#32
+	 mov	$C1,@K[2]
+	mov.32	@x[14],@d[7]
+	 mov	$C2,@K[2]
+	lsr	@x[15],@d[7],#32
+
+	mov	$ctr,#10
+	subs	$len,$len,#256
+.Loop_neon:
+	sub	$ctr,$ctr,#1
+___
+	my @thread0=&NEONROUND($A0,$B0,$C0,$D0,$T0,0);
+	my @thread1=&NEONROUND($A1,$B1,$C1,$D1,$T1,0);
+	my @thread2=&NEONROUND($A2,$B2,$C2,$D2,$T2,0);
+	my @thread3=&ROUND(0,4,8,12);
+
+	foreach (@thread0) {
+		eval;			eval(shift(@thread3));
+		eval(shift(@thread1));	eval(shift(@thread3));
+		eval(shift(@thread2));	eval(shift(@thread3));
+	}
+
+	@thread0=&NEONROUND($A0,$B0,$C0,$D0,$T0,1);
+	@thread1=&NEONROUND($A1,$B1,$C1,$D1,$T1,1);
+	@thread2=&NEONROUND($A2,$B2,$C2,$D2,$T2,1);
+	@thread3=&ROUND(0,5,10,15);
+
+	foreach (@thread0) {
+		eval;			eval(shift(@thread3));
+		eval(shift(@thread1));	eval(shift(@thread3));
+		eval(shift(@thread2));	eval(shift(@thread3));
+	}
+$code.=<<___;
+	cbnz	$ctr,.Loop_neon
+
+	add.32	@x[0],@x[0],@d[0]		// accumulate key block
+	 add	$A0,$A0,@K[0]
+	add	@x[1],@x[1],@d[0],lsr#32
+	 add	$A1,$A1,@K[0]
+	add.32	@x[2],@x[2],@d[1]
+	 add	$A2,$A2,@K[0]
+	add	@x[3],@x[3],@d[1],lsr#32
+	 add	$C0,$C0,@K[2]
+	add.32	@x[4],@x[4],@d[2]
+	 add	$C1,$C1,@K[2]
+	add	@x[5],@x[5],@d[2],lsr#32
+	 add	$C2,$C2,@K[2]
+	add.32	@x[6],@x[6],@d[3]
+	 add	$D0,$D0,@K[3]
+	add	@x[7],@x[7],@d[3],lsr#32
+	add.32	@x[8],@x[8],@d[4]
+	 add	$D1,$D1,@K[4]
+	add	@x[9],@x[9],@d[4],lsr#32
+	add.32	@x[10],@x[10],@d[5]
+	 add	$D2,$D2,@K[5]
+	add	@x[11],@x[11],@d[5],lsr#32
+	add.32	@x[12],@x[12],@d[6]
+	 add	$B0,$B0,@K[1]
+	add	@x[13],@x[13],@d[6],lsr#32
+	add.32	@x[14],@x[14],@d[7]
+	 add	$B1,$B1,@K[1]
+	add	@x[15],@x[15],@d[7],lsr#32
+	 add	$B2,$B2,@K[1]
+
+	b.lo	.Ltail_neon
+
+	add	@x[0],@x[0],@x[1],lsl#32	// pack
+	add	@x[2],@x[2],@x[3],lsl#32
+	ldp	@x[1],@x[3],[$inp,#0]		// load input
+	add	@x[4],@x[4],@x[5],lsl#32
+	add	@x[6],@x[6],@x[7],lsl#32
+	ldp	@x[5],@x[7],[$inp,#16]
+	add	@x[8],@x[8],@x[9],lsl#32
+	add	@x[10],@x[10],@x[11],lsl#32
+	ldp	@x[9],@x[11],[$inp,#32]
+	add	@x[12],@x[12],@x[13],lsl#32
+	add	@x[14],@x[14],@x[15],lsl#32
+	ldp	@x[13],@x[15],[$inp,#48]
+	add	$inp,$inp,#64
+#ifdef	__AARCH64EB__
+	rev	@x[0],@x[0]
+	rev	@x[2],@x[2]
+	rev	@x[4],@x[4]
+	rev	@x[6],@x[6]
+	rev	@x[8],@x[8]
+	rev	@x[10],@x[10]
+	rev	@x[12],@x[12]
+	rev	@x[14],@x[14]
+#endif
+	ld1.8	{$T0-$T3},[$inp],#64
+	eor	@x[0],@x[0],@x[1]
+	eor	@x[2],@x[2],@x[3]
+	eor	@x[4],@x[4],@x[5]
+	eor	@x[6],@x[6],@x[7]
+	eor	@x[8],@x[8],@x[9]
+	 eor	$A0,$A0,$T0
+	eor	@x[10],@x[10],@x[11]
+	 eor	$B0,$B0,$T1
+	eor	@x[12],@x[12],@x[13]
+	 eor	$C0,$C0,$T2
+	eor	@x[14],@x[14],@x[15]
+	 eor	$D0,$D0,$T3
+	 ld1.8	{$T0-$T3},[$inp],#64
+
+	stp	@x[0],@x[2],[$out,#0]		// store output
+	 add	@d[6],@d[6],#4			// increment counter
+	stp	@x[4],@x[6],[$out,#16]
+	 add	@K[3],@K[3],$ONE		// += 4
+	stp	@x[8],@x[10],[$out,#32]
+	 add	@K[4],@K[4],$ONE
+	stp	@x[12],@x[14],[$out,#48]
+	 add	@K[5],@K[5],$ONE
+	add	$out,$out,#64
+
+	st1.8	{$A0-$D0},[$out],#64
+	ld1.8	{$A0-$D0},[$inp],#64
+
+	eor	$A1,$A1,$T0
+	eor	$B1,$B1,$T1
+	eor	$C1,$C1,$T2
+	eor	$D1,$D1,$T3
+	st1.8	{$A1-$D1},[$out],#64
+
+	eor	$A2,$A2,$A0
+	eor	$B2,$B2,$B0
+	eor	$C2,$C2,$C0
+	eor	$D2,$D2,$D0
+	st1.8	{$A2-$D2},[$out],#64
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
+	add	$len,$len,#256
+	cmp	$len,#64
+	b.lo	.Less_than_64
+
+	add	@x[0],@x[0],@x[1],lsl#32	// pack
+	add	@x[2],@x[2],@x[3],lsl#32
+	ldp	@x[1],@x[3],[$inp,#0]		// load input
+	add	@x[4],@x[4],@x[5],lsl#32
+	add	@x[6],@x[6],@x[7],lsl#32
+	ldp	@x[5],@x[7],[$inp,#16]
+	add	@x[8],@x[8],@x[9],lsl#32
+	add	@x[10],@x[10],@x[11],lsl#32
+	ldp	@x[9],@x[11],[$inp,#32]
+	add	@x[12],@x[12],@x[13],lsl#32
+	add	@x[14],@x[14],@x[15],lsl#32
+	ldp	@x[13],@x[15],[$inp,#48]
+	add	$inp,$inp,#64
+#ifdef	__AARCH64EB__
+	rev	@x[0],@x[0]
+	rev	@x[2],@x[2]
+	rev	@x[4],@x[4]
+	rev	@x[6],@x[6]
+	rev	@x[8],@x[8]
+	rev	@x[10],@x[10]
+	rev	@x[12],@x[12]
+	rev	@x[14],@x[14]
+#endif
+	eor	@x[0],@x[0],@x[1]
+	eor	@x[2],@x[2],@x[3]
+	eor	@x[4],@x[4],@x[5]
+	eor	@x[6],@x[6],@x[7]
+	eor	@x[8],@x[8],@x[9]
+	eor	@x[10],@x[10],@x[11]
+	eor	@x[12],@x[12],@x[13]
+	eor	@x[14],@x[14],@x[15]
+
+	stp	@x[0],@x[2],[$out,#0]		// store output
+	 add	@d[6],@d[6],#4			// increment counter
+	stp	@x[4],@x[6],[$out,#16]
+	stp	@x[8],@x[10],[$out,#32]
+	stp	@x[12],@x[14],[$out,#48]
+	add	$out,$out,#64
+	b.eq	.Ldone_neon
+	sub	$len,$len,#64
+	cmp	$len,#64
+	b.lo	.Less_than_128
+
+	ld1.8	{$T0-$T3},[$inp],#64
+	eor	$A0,$A0,$T0
+	eor	$B0,$B0,$T1
+	eor	$C0,$C0,$T2
+	eor	$D0,$D0,$T3
+	st1.8	{$A0-$D0},[$out],#64
+	b.eq	.Ldone_neon
+	sub	$len,$len,#64
+	cmp	$len,#64
+	b.lo	.Less_than_192
+
+	ld1.8	{$T0-$T3},[$inp],#64
+	eor	$A1,$A1,$T0
+	eor	$B1,$B1,$T1
+	eor	$C1,$C1,$T2
+	eor	$D1,$D1,$T3
+	st1.8	{$A1-$D1},[$out],#64
+	b.eq	.Ldone_neon
+	sub	$len,$len,#64
+
+	st1.8	{$A2-$D2},[sp]
+	b	.Last_neon
+
+.Less_than_128:
+	st1.8	{$A0-$D0},[sp]
+	b	.Last_neon
+.Less_than_192:
+	st1.8	{$A1-$D1},[sp]
+	b	.Last_neon
+
+.align	4
+.Last_neon:
+	sub	$out,$out,#1
+	add	$inp,$inp,$len
+	add	$out,$out,$len
+	add	$ctr,sp,$len
+	neg	$len,$len
+
+.Loop_tail_neon:
+	ldrb	w10,[$inp,$len]
+	ldrb	w11,[$ctr,$len]
+	add	$len,$len,#1
+	eor	w10,w10,w11
+	strb	w10,[$out,$len]
+	cbnz	$len,.Loop_tail_neon
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
+___
+{
+my ($T0,$T1,$T2,$T3,$T4,$T5)=@K;
+my ($A0,$B0,$C0,$D0,$A1,$B1,$C1,$D1,$A2,$B2,$C2,$D2,
+    $A3,$B3,$C3,$D3,$A4,$B4,$C4,$D4,$A5,$B5,$C5,$D5) = map("v$_.4s",(0..23));
+
+$code.=<<___;
+#ifdef	__APPLE__
+.type	ChaCha20_512_neon,%function
+.align	5
+ChaCha20_512_neon:
+	stp	x29,x30,[sp,#-96]!
+	add	x29,sp,#0
+
+	adr	@x[0],.Lsigma
+	stp	x19,x20,[sp,#16]
+	stp	x21,x22,[sp,#32]
+	stp	x23,x24,[sp,#48]
+	stp	x25,x26,[sp,#64]
+	stp	x27,x28,[sp,#80]
+
+.L512_or_more_neon:
+	sub	sp,sp,#128+64
+
+	ldp	@d[0],@d[1],[@x[0]]		// load sigma
+	ld1	{@K[0]},[@x[0]],#16
+	ldp	@d[2],@d[3],[$key]		// load key
+	ldp	@d[4],@d[5],[$key,#16]
+	ld1	{@K[1],@K[2]},[$key]
+	ldp	@d[6],@d[7],[$ctr]		// load counter
+	ld1	{@K[3]},[$ctr]
+	ld1	{$ONE},[@x[0]]
+# ifdef	__AARCH64EB__
+	rev64	@K[0],@K[0]
+	ror	@d[2],@d[2],#32
+	ror	@d[3],@d[3],#32
+	ror	@d[4],@d[4],#32
+	ror	@d[5],@d[5],#32
+	ror	@d[6],@d[6],#32
+	ror	@d[7],@d[7],#32
+# endif
+	add	@K[3],@K[3],$ONE		// += 1
+	stp	@K[0],@K[1],[sp,#0]		// off-load key block, invariant part
+	add	@K[3],@K[3],$ONE		// not typo
+	str	@K[2],[sp,#32]
+	add	@K[4],@K[3],$ONE
+	add	@K[5],@K[4],$ONE
+	add	@K[6],@K[5],$ONE
+	shl	$ONE,$ONE,#2			// 1 -> 4
+
+	stp	d8,d9,[sp,#128+0]		// meet ABI requirements
+	stp	d10,d11,[sp,#128+16]
+	stp	d12,d13,[sp,#128+32]
+	stp	d14,d15,[sp,#128+48]
+
+	sub	$len,$len,#512			// not typo
+
+.Loop_outer_512_neon:
+	 mov	$A0,@K[0]
+	 mov	$A1,@K[0]
+	 mov	$A2,@K[0]
+	 mov	$A3,@K[0]
+	 mov	$A4,@K[0]
+	 mov	$A5,@K[0]
+	 mov	$B0,@K[1]
+	mov.32	@x[0],@d[0]			// unpack key block
+	 mov	$B1,@K[1]
+	lsr	@x[1],@d[0],#32
+	 mov	$B2,@K[1]
+	mov.32	@x[2],@d[1]
+	 mov	$B3,@K[1]
+	lsr	@x[3],@d[1],#32
+	 mov	$B4,@K[1]
+	mov.32	@x[4],@d[2]
+	 mov	$B5,@K[1]
+	lsr	@x[5],@d[2],#32
+	 mov	$D0,@K[3]
+	mov.32	@x[6],@d[3]
+	 mov	$D1,@K[4]
+	lsr	@x[7],@d[3],#32
+	 mov	$D2,@K[5]
+	mov.32	@x[8],@d[4]
+	 mov	$D3,@K[6]
+	lsr	@x[9],@d[4],#32
+	 mov	$C0,@K[2]
+	mov.32	@x[10],@d[5]
+	 mov	$C1,@K[2]
+	lsr	@x[11],@d[5],#32
+	 add	$D4,$D0,$ONE			// +4
+	mov.32	@x[12],@d[6]
+	 add	$D5,$D1,$ONE			// +4
+	lsr	@x[13],@d[6],#32
+	 mov	$C2,@K[2]
+	mov.32	@x[14],@d[7]
+	 mov	$C3,@K[2]
+	lsr	@x[15],@d[7],#32
+	 mov	$C4,@K[2]
+	 stp	@K[3],@K[4],[sp,#48]		// off-load key block, variable part
+	 mov	$C5,@K[2]
+	 str	@K[5],[sp,#80]
+
+	mov	$ctr,#5
+	subs	$len,$len,#512
+.Loop_upper_neon:
+	sub	$ctr,$ctr,#1
+___
+	my @thread0=&NEONROUND($A0,$B0,$C0,$D0,$T0,0);
+	my @thread1=&NEONROUND($A1,$B1,$C1,$D1,$T1,0);
+	my @thread2=&NEONROUND($A2,$B2,$C2,$D2,$T2,0);
+	my @thread3=&NEONROUND($A3,$B3,$C3,$D3,$T3,0);
+	my @thread4=&NEONROUND($A4,$B4,$C4,$D4,$T4,0);
+	my @thread5=&NEONROUND($A5,$B5,$C5,$D5,$T5,0);
+	my @thread67=(&ROUND(0,4,8,12),&ROUND(0,5,10,15));
+	my $diff = ($#thread0+1)*6 - $#thread67 - 1;
+	my $i = 0;
+
+	foreach (@thread0) {
+		eval;			eval(shift(@thread67));
+		eval(shift(@thread1));	eval(shift(@thread67));
+		eval(shift(@thread2));	eval(shift(@thread67));
+		eval(shift(@thread3));	eval(shift(@thread67));
+		eval(shift(@thread4));	eval(shift(@thread67));
+		eval(shift(@thread5));	eval(shift(@thread67));
+	}
+
+	@thread0=&NEONROUND($A0,$B0,$C0,$D0,$T0,1);
+	@thread1=&NEONROUND($A1,$B1,$C1,$D1,$T1,1);
+	@thread2=&NEONROUND($A2,$B2,$C2,$D2,$T2,1);
+	@thread3=&NEONROUND($A3,$B3,$C3,$D3,$T3,1);
+	@thread4=&NEONROUND($A4,$B4,$C4,$D4,$T4,1);
+	@thread5=&NEONROUND($A5,$B5,$C5,$D5,$T5,1);
+	@thread67=(&ROUND(0,4,8,12),&ROUND(0,5,10,15));
+
+	foreach (@thread0) {
+		eval;			eval(shift(@thread67));
+		eval(shift(@thread1));	eval(shift(@thread67));
+		eval(shift(@thread2));	eval(shift(@thread67));
+		eval(shift(@thread3));	eval(shift(@thread67));
+		eval(shift(@thread4));	eval(shift(@thread67));
+		eval(shift(@thread5));	eval(shift(@thread67));
+	}
+$code.=<<___;
+	cbnz	$ctr,.Loop_upper_neon
+
+	add.32	@x[0],@x[0],@d[0]		// accumulate key block
+	add	@x[1],@x[1],@d[0],lsr#32
+	add.32	@x[2],@x[2],@d[1]
+	add	@x[3],@x[3],@d[1],lsr#32
+	add.32	@x[4],@x[4],@d[2]
+	add	@x[5],@x[5],@d[2],lsr#32
+	add.32	@x[6],@x[6],@d[3]
+	add	@x[7],@x[7],@d[3],lsr#32
+	add.32	@x[8],@x[8],@d[4]
+	add	@x[9],@x[9],@d[4],lsr#32
+	add.32	@x[10],@x[10],@d[5]
+	add	@x[11],@x[11],@d[5],lsr#32
+	add.32	@x[12],@x[12],@d[6]
+	add	@x[13],@x[13],@d[6],lsr#32
+	add.32	@x[14],@x[14],@d[7]
+	add	@x[15],@x[15],@d[7],lsr#32
+
+	add	@x[0],@x[0],@x[1],lsl#32	// pack
+	add	@x[2],@x[2],@x[3],lsl#32
+	ldp	@x[1],@x[3],[$inp,#0]		// load input
+	add	@x[4],@x[4],@x[5],lsl#32
+	add	@x[6],@x[6],@x[7],lsl#32
+	ldp	@x[5],@x[7],[$inp,#16]
+	add	@x[8],@x[8],@x[9],lsl#32
+	add	@x[10],@x[10],@x[11],lsl#32
+	ldp	@x[9],@x[11],[$inp,#32]
+	add	@x[12],@x[12],@x[13],lsl#32
+	add	@x[14],@x[14],@x[15],lsl#32
+	ldp	@x[13],@x[15],[$inp,#48]
+	add	$inp,$inp,#64
+# ifdef	__AARCH64EB__
+	rev	@x[0],@x[0]
+	rev	@x[2],@x[2]
+	rev	@x[4],@x[4]
+	rev	@x[6],@x[6]
+	rev	@x[8],@x[8]
+	rev	@x[10],@x[10]
+	rev	@x[12],@x[12]
+	rev	@x[14],@x[14]
+# endif
+	eor	@x[0],@x[0],@x[1]
+	eor	@x[2],@x[2],@x[3]
+	eor	@x[4],@x[4],@x[5]
+	eor	@x[6],@x[6],@x[7]
+	eor	@x[8],@x[8],@x[9]
+	eor	@x[10],@x[10],@x[11]
+	eor	@x[12],@x[12],@x[13]
+	eor	@x[14],@x[14],@x[15]
+
+	 stp	@x[0],@x[2],[$out,#0]		// store output
+	 add	@d[6],@d[6],#1			// increment counter
+	mov.32	@x[0],@d[0]			// unpack key block
+	lsr	@x[1],@d[0],#32
+	 stp	@x[4],@x[6],[$out,#16]
+	mov.32	@x[2],@d[1]
+	lsr	@x[3],@d[1],#32
+	 stp	@x[8],@x[10],[$out,#32]
+	mov.32	@x[4],@d[2]
+	lsr	@x[5],@d[2],#32
+	 stp	@x[12],@x[14],[$out,#48]
+	 add	$out,$out,#64
+	mov.32	@x[6],@d[3]
+	lsr	@x[7],@d[3],#32
+	mov.32	@x[8],@d[4]
+	lsr	@x[9],@d[4],#32
+	mov.32	@x[10],@d[5]
+	lsr	@x[11],@d[5],#32
+	mov.32	@x[12],@d[6]
+	lsr	@x[13],@d[6],#32
+	mov.32	@x[14],@d[7]
+	lsr	@x[15],@d[7],#32
+
+	mov	$ctr,#5
+.Loop_lower_neon:
+	sub	$ctr,$ctr,#1
+___
+	@thread0=&NEONROUND($A0,$B0,$C0,$D0,$T0,0);
+	@thread1=&NEONROUND($A1,$B1,$C1,$D1,$T1,0);
+	@thread2=&NEONROUND($A2,$B2,$C2,$D2,$T2,0);
+	@thread3=&NEONROUND($A3,$B3,$C3,$D3,$T3,0);
+	@thread4=&NEONROUND($A4,$B4,$C4,$D4,$T4,0);
+	@thread5=&NEONROUND($A5,$B5,$C5,$D5,$T5,0);
+	@thread67=(&ROUND(0,4,8,12),&ROUND(0,5,10,15));
+
+	foreach (@thread0) {
+		eval;			eval(shift(@thread67));
+		eval(shift(@thread1));	eval(shift(@thread67));
+		eval(shift(@thread2));	eval(shift(@thread67));
+		eval(shift(@thread3));	eval(shift(@thread67));
+		eval(shift(@thread4));	eval(shift(@thread67));
+		eval(shift(@thread5));	eval(shift(@thread67));
+	}
+
+	@thread0=&NEONROUND($A0,$B0,$C0,$D0,$T0,1);
+	@thread1=&NEONROUND($A1,$B1,$C1,$D1,$T1,1);
+	@thread2=&NEONROUND($A2,$B2,$C2,$D2,$T2,1);
+	@thread3=&NEONROUND($A3,$B3,$C3,$D3,$T3,1);
+	@thread4=&NEONROUND($A4,$B4,$C4,$D4,$T4,1);
+	@thread5=&NEONROUND($A5,$B5,$C5,$D5,$T5,1);
+	@thread67=(&ROUND(0,4,8,12),&ROUND(0,5,10,15));
+
+	foreach (@thread0) {
+		eval;			eval(shift(@thread67));
+		eval(shift(@thread1));	eval(shift(@thread67));
+		eval(shift(@thread2));	eval(shift(@thread67));
+		eval(shift(@thread3));	eval(shift(@thread67));
+		eval(shift(@thread4));	eval(shift(@thread67));
+		eval(shift(@thread5));	eval(shift(@thread67));
+	}
+$code.=<<___;
+	cbnz	$ctr,.Loop_lower_neon
+
+	add.32	@x[0],@x[0],@d[0]		// accumulate key block
+	 ldp	@K[0],@K[1],[sp,#0]
+	add	@x[1],@x[1],@d[0],lsr#32
+	 ldp	@K[2],@K[3],[sp,#32]
+	add.32	@x[2],@x[2],@d[1]
+	 ldp	@K[4],@K[5],[sp,#64]
+	add	@x[3],@x[3],@d[1],lsr#32
+	 add	$A0,$A0,@K[0]
+	add.32	@x[4],@x[4],@d[2]
+	 add	$A1,$A1,@K[0]
+	add	@x[5],@x[5],@d[2],lsr#32
+	 add	$A2,$A2,@K[0]
+	add.32	@x[6],@x[6],@d[3]
+	 add	$A3,$A3,@K[0]
+	add	@x[7],@x[7],@d[3],lsr#32
+	 add	$A4,$A4,@K[0]
+	add.32	@x[8],@x[8],@d[4]
+	 add	$A5,$A5,@K[0]
+	add	@x[9],@x[9],@d[4],lsr#32
+	 add	$C0,$C0,@K[2]
+	add.32	@x[10],@x[10],@d[5]
+	 add	$C1,$C1,@K[2]
+	add	@x[11],@x[11],@d[5],lsr#32
+	 add	$C2,$C2,@K[2]
+	add.32	@x[12],@x[12],@d[6]
+	 add	$C3,$C3,@K[2]
+	add	@x[13],@x[13],@d[6],lsr#32
+	 add	$C4,$C4,@K[2]
+	add.32	@x[14],@x[14],@d[7]
+	 add	$C5,$C5,@K[2]
+	add	@x[15],@x[15],@d[7],lsr#32
+	 add	$D4,$D4,$ONE			// +4
+	add	@x[0],@x[0],@x[1],lsl#32	// pack
+	 add	$D5,$D5,$ONE			// +4
+	add	@x[2],@x[2],@x[3],lsl#32
+	 add	$D0,$D0,@K[3]
+	ldp	@x[1],@x[3],[$inp,#0]		// load input
+	 add	$D1,$D1,@K[4]
+	add	@x[4],@x[4],@x[5],lsl#32
+	 add	$D2,$D2,@K[5]
+	add	@x[6],@x[6],@x[7],lsl#32
+	 add	$D3,$D3,@K[6]
+	ldp	@x[5],@x[7],[$inp,#16]
+	 add	$D4,$D4,@K[3]
+	add	@x[8],@x[8],@x[9],lsl#32
+	 add	$D5,$D5,@K[4]
+	add	@x[10],@x[10],@x[11],lsl#32
+	 add	$B0,$B0,@K[1]
+	ldp	@x[9],@x[11],[$inp,#32]
+	 add	$B1,$B1,@K[1]
+	add	@x[12],@x[12],@x[13],lsl#32
+	 add	$B2,$B2,@K[1]
+	add	@x[14],@x[14],@x[15],lsl#32
+	 add	$B3,$B3,@K[1]
+	ldp	@x[13],@x[15],[$inp,#48]
+	 add	$B4,$B4,@K[1]
+	add	$inp,$inp,#64
+	 add	$B5,$B5,@K[1]
+
+# ifdef	__AARCH64EB__
+	rev	@x[0],@x[0]
+	rev	@x[2],@x[2]
+	rev	@x[4],@x[4]
+	rev	@x[6],@x[6]
+	rev	@x[8],@x[8]
+	rev	@x[10],@x[10]
+	rev	@x[12],@x[12]
+	rev	@x[14],@x[14]
+# endif
+	ld1.8	{$T0-$T3},[$inp],#64
+	eor	@x[0],@x[0],@x[1]
+	eor	@x[2],@x[2],@x[3]
+	eor	@x[4],@x[4],@x[5]
+	eor	@x[6],@x[6],@x[7]
+	eor	@x[8],@x[8],@x[9]
+	 eor	$A0,$A0,$T0
+	eor	@x[10],@x[10],@x[11]
+	 eor	$B0,$B0,$T1
+	eor	@x[12],@x[12],@x[13]
+	 eor	$C0,$C0,$T2
+	eor	@x[14],@x[14],@x[15]
+	 eor	$D0,$D0,$T3
+	 ld1.8	{$T0-$T3},[$inp],#64
+
+	stp	@x[0],@x[2],[$out,#0]		// store output
+	 add	@d[6],@d[6],#7			// increment counter
+	stp	@x[4],@x[6],[$out,#16]
+	stp	@x[8],@x[10],[$out,#32]
+	stp	@x[12],@x[14],[$out,#48]
+	add	$out,$out,#64
+	st1.8	{$A0-$D0},[$out],#64
+
+	ld1.8	{$A0-$D0},[$inp],#64
+	eor	$A1,$A1,$T0
+	eor	$B1,$B1,$T1
+	eor	$C1,$C1,$T2
+	eor	$D1,$D1,$T3
+	st1.8	{$A1-$D1},[$out],#64
+
+	ld1.8	{$A1-$D1},[$inp],#64
+	eor	$A2,$A2,$A0
+	 ldp	@K[0],@K[1],[sp,#0]
+	eor	$B2,$B2,$B0
+	 ldp	@K[2],@K[3],[sp,#32]
+	eor	$C2,$C2,$C0
+	eor	$D2,$D2,$D0
+	st1.8	{$A2-$D2},[$out],#64
+
+	ld1.8	{$A2-$D2},[$inp],#64
+	eor	$A3,$A3,$A1
+	eor	$B3,$B3,$B1
+	eor	$C3,$C3,$C1
+	eor	$D3,$D3,$D1
+	st1.8	{$A3-$D3},[$out],#64
+
+	ld1.8	{$A3-$D3},[$inp],#64
+	eor	$A4,$A4,$A2
+	eor	$B4,$B4,$B2
+	eor	$C4,$C4,$C2
+	eor	$D4,$D4,$D2
+	st1.8	{$A4-$D4},[$out],#64
+
+	shl	$A0,$ONE,#1			// 4 -> 8
+	eor	$A5,$A5,$A3
+	eor	$B5,$B5,$B3
+	eor	$C5,$C5,$C3
+	eor	$D5,$D5,$D3
+	st1.8	{$A5-$D5},[$out],#64
+
+	add	@K[3],@K[3],$A0			// += 8
+	add	@K[4],@K[4],$A0
+	add	@K[5],@K[5],$A0
+	add	@K[6],@K[6],$A0
+
+	b.hs	.Loop_outer_512_neon
+
+	adds	$len,$len,#512
+	ushr	$A0,$ONE,#2			// 4 -> 1
+
+	ldp	d8,d9,[sp,#128+0]		// meet ABI requirements
+	ldp	d10,d11,[sp,#128+16]
+	ldp	d12,d13,[sp,#128+32]
+	ldp	d14,d15,[sp,#128+48]
+
+	stp	@K[0],$ONE,[sp,#0]		// wipe off-load area
+	stp	@K[0],$ONE,[sp,#32]
+	stp	@K[0],$ONE,[sp,#64]
+
+	b.eq	.Ldone_512_neon
+
+	cmp	$len,#192
+	sub	@K[3],@K[3],$A0			// -= 1
+	sub	@K[4],@K[4],$A0
+	sub	@K[5],@K[5],$A0
+	add	sp,sp,#128
+	b.hs	.Loop_outer_neon
+
+	eor	@K[1],@K[1],@K[1]
+	eor	@K[2],@K[2],@K[2]
+	eor	@K[3],@K[3],@K[3]
+	eor	@K[4],@K[4],@K[4]
+	eor	@K[5],@K[5],@K[5]
+	eor	@K[6],@K[6],@K[6]
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
+#endif
+#endif
+___
+}
+}}}
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
+	s/\`([^\`]*)\`/eval $1/geo;
+
+	(s/\b([a-z]+)\.32\b/$1/ and (s/x([0-9]+)/w$1/g or 1))	or
+	(m/\b(eor|ext|mov)\b/ and (s/\.4s/\.16b/g or 1))	or
+	(s/\b((?:ld|st)1)\.8\b/$1/ and (s/\.4s/\.16b/g or 1))	or
+	(m/\b(ld|st)[rp]\b/ and (s/v([0-9]+)\.4s/q$1/g or 1))	or
+	(s/\brev32\.16\b/rev32/ and (s/\.4s/\.8h/g or 1));
+
+	print $_,"\n";
+}
+close STDOUT;	# flush
diff --git a/lib/zinc/chacha20/chacha20-unrolled-arm.S b/lib/zinc/chacha20/chacha20-unrolled-arm.S
new file mode 100644
index 000000000000..2140319b64a0
--- /dev/null
+++ b/lib/zinc/chacha20/chacha20-unrolled-arm.S
@@ -0,0 +1,461 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2018 Google, Inc.
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+/*
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
diff --git a/lib/zinc/chacha20/chacha20.c b/lib/zinc/chacha20/chacha20.c
index b47aefd65e80..d4e6316eb5a3 100644
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
2.21.0
