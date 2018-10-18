From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next v8 13/28] zinc: Poly1305 x86_64 implementation
Date: Thu, 18 Oct 2018 16:56:57 +0200
Message-Id: <20181018145712.7538-14-Jason@zx2c4.com>
In-Reply-To: <20181018145712.7538-1-Jason@zx2c4.com>
References: <20181018145712.7538-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-crypto@vger.kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Samuel Neves <sneves@dei.uc.pt>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This ports AVX, AVX-2, and AVX-512F implementations for Poly1305.
The AVX-512F implementation is disabled on Skylake, due to throttling.
These come from Andy Polyakov's implementation, with the following
modifications from Samuel Neves:

  - Some cosmetic changes, like renaming labels to .Lname, constants,
    and other Linux conventions.

  - CPU feature checking is done in C by the glue code, so that has been
    removed from the assembly.

  - poly1305_blocks_avx512 jumped to the middle of the poly1305_blocks_avx2
    for the final blocks. To appease objtool, the relevant tail avx2 code
    was duplicated for the avx512 function.

  - The original uses %rbp as a scratch register. However, the kernel
    expects %rbp to be a valid frame pointer at any given time in order
    to do proper unwinding. Thus we need to alter the code in order to
    preserve it. The most straightforward manner in which this was
    accomplished was by replacing $d3, formerly %r10, by %rdi, and
    replacing %rbp by %r10. Because %rdi, a pointer to the context
    structure, does not change and is not used by poly1305_iteration,
    it is safe to use it here, and the overhead of saving and restoring
    it should be minimal.

  - The original hardcodes returns as .byte 0xf3,0xc3, aka "rep ret".
    We replace this by "ret". "rep ret" was meant to help with AMD K8
    chips, cf. http://repzret.org/p/repzret. It makes no sense to
    continue to use this kludge for code that won't even run on ancient
    AMD chips.

The AVX code uses base 2^26, while the scalar code uses base 2^64. If we hit
the unfortunate situation of using AVX and then having to go back to scalar
-- because the user is silly and has called the update function from two
separate contexts -- then we need to convert back to the original base before
proceeding. It is possible to reason that the initial reduction below is
sufficient given the implementation invariants. However, for an avoidance of
doubt and because this is not performance critical, we do the full reduction
anyway. This conversion is found in the glue code, and a proof of
correctness may be easily obtained from Z3: <https://xn--4db.cc/ltPtHCKN/py>.

Cycle counts on a Core i7 6700HQ using the AVX-2 codepath, comparing
this implementation ("new") to the implementation in the current crypto
api ("old"):

size	old	new
----	----	----
0	70	68
16	92	90
32	134	104
48	172	120
64	218	136
80	254	158
96	298	174
112	342	192
128	388	212
144	428	228
160	466	246
176	510	264
192	550	282
208	594	302
224	628	316
240	676	334
256	716	354
272	764	374
288	802	352
304	420	366
320	428	360
336	484	378
352	426	384
368	478	400
384	488	394
400	542	408
416	486	416
432	534	430
448	544	422
464	600	438
480	540	448
496	594	464
512	602	456
528	656	476
544	600	480
560	650	494
576	664	490
592	714	508
608	656	514
624	708	532
640	716	524
656	770	536
672	716	548
688	770	562
704	774	552
720	826	568
736	768	574
752	822	592
768	830	584
784	884	602
800	828	610
816	884	628
832	888	618
848	942	632
864	884	644
880	936	660
896	948	652
912	1000	664
928	942	676
944	994	690
960	1002	680
976	1054	694
992	1002	706
1008	1052	720

Cycle counts on a Xeon Gold 5120 using the AVX-512 codepath:

size	old	new
----	----	----
0	74	70
16	96	92
32	136	106
48	184	124
64	218	138
80	260	160
96	300	176
112	342	194
128	384	212
144	420	226
160	464	248
176	504	264
192	544	282
208	582	300
224	624	318
240	662	338
256	708	358
272	748	372
288	788	358
304	422	370
320	432	364
336	486	380
352	434	390
368	480	408
384	490	398
400	542	412
416	492	426
432	538	436
448	546	432
464	600	448
480	548	456
496	594	476
512	606	470
528	656	480
544	606	498
560	652	512
576	662	508
592	716	522
608	664	538
624	710	552
640	720	516
656	772	526
672	722	544
688	768	556
704	778	556
720	832	568
736	780	584
752	826	600
768	836	560
784	888	572
800	838	588
816	884	604
832	894	598
848	946	612
864	896	628
880	942	644
896	952	608
912	1004	616
928	954	634
944	1000	646
960	1008	646
976	1062	658
992	1012	674
1008	1058	690

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Samuel Neves <sneves@dei.uc.pt>
Co-developed-by: Samuel Neves <sneves@dei.uc.pt>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org
Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kernel-hardening@lists.openwall.com
Cc: linux-crypto@vger.kernel.org
---
 lib/zinc/Makefile                             |    1 +
 lib/zinc/poly1305/poly1305-x86_64-glue.c      |  154 ++
 ...-x86_64-cryptogams.S => poly1305-x86_64.S} | 2459 ++++++-----------
 lib/zinc/poly1305/poly1305.c                  |    4 +
 4 files changed, 1002 insertions(+), 1616 deletions(-)
 create mode 100644 lib/zinc/poly1305/poly1305-x86_64-glue.c
 rename lib/zinc/poly1305/{poly1305-x86_64-cryptogams.S => poly1305-x86_64.S} (58%)

diff --git a/lib/zinc/Makefile b/lib/zinc/Makefile
index 6fc9626c55fa..a8943d960b6a 100644
--- a/lib/zinc/Makefile
+++ b/lib/zinc/Makefile
@@ -11,4 +11,5 @@ AFLAGS_chacha20-mips.o += -O2 # This is required to fill the branch delay slots
 obj-$(CONFIG_ZINC_CHACHA20) += zinc_chacha20.o
 
 zinc_poly1305-y := poly1305/poly1305.o
+zinc_poly1305-$(CONFIG_ZINC_ARCH_X86_64) += poly1305/poly1305-x86_64.o
 obj-$(CONFIG_ZINC_POLY1305) += zinc_poly1305.o
diff --git a/lib/zinc/poly1305/poly1305-x86_64-glue.c b/lib/zinc/poly1305/poly1305-x86_64-glue.c
new file mode 100644
index 000000000000..ccf5f1952503
--- /dev/null
+++ b/lib/zinc/poly1305/poly1305-x86_64-glue.c
@@ -0,0 +1,154 @@
+// SPDX-License-Identifier: GPL-2.0 OR MIT
+/*
+ * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#include <asm/cpufeature.h>
+#include <asm/processor.h>
+#include <asm/intel-family.h>
+
+asmlinkage void poly1305_init_x86_64(void *ctx,
+				     const u8 key[POLY1305_KEY_SIZE]);
+asmlinkage void poly1305_blocks_x86_64(void *ctx, const u8 *inp,
+				       const size_t len, const u32 padbit);
+asmlinkage void poly1305_emit_x86_64(void *ctx, u8 mac[POLY1305_MAC_SIZE],
+				     const u32 nonce[4]);
+asmlinkage void poly1305_emit_avx(void *ctx, u8 mac[POLY1305_MAC_SIZE],
+				  const u32 nonce[4]);
+asmlinkage void poly1305_blocks_avx(void *ctx, const u8 *inp, const size_t len,
+				    const u32 padbit);
+asmlinkage void poly1305_blocks_avx2(void *ctx, const u8 *inp, const size_t len,
+				     const u32 padbit);
+asmlinkage void poly1305_blocks_avx512(void *ctx, const u8 *inp,
+				       const size_t len, const u32 padbit);
+
+static bool poly1305_use_avx __ro_after_init;
+static bool poly1305_use_avx2 __ro_after_init;
+static bool poly1305_use_avx512 __ro_after_init;
+static bool *const poly1305_nobs[] __initconst = {
+	&poly1305_use_avx, &poly1305_use_avx2, &poly1305_use_avx512 };
+
+static void __init poly1305_fpu_init(void)
+{
+	poly1305_use_avx =
+		boot_cpu_has(X86_FEATURE_AVX) &&
+		cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL);
+	poly1305_use_avx2 =
+		boot_cpu_has(X86_FEATURE_AVX) &&
+		boot_cpu_has(X86_FEATURE_AVX2) &&
+		cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL);
+	poly1305_use_avx512 =
+		boot_cpu_has(X86_FEATURE_AVX) &&
+		boot_cpu_has(X86_FEATURE_AVX2) &&
+		boot_cpu_has(X86_FEATURE_AVX512F) &&
+		cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM |
+				  XFEATURE_MASK_AVX512, NULL) &&
+		/* Skylake downclocks unacceptably much when using zmm. */
+		boot_cpu_data.x86_model != INTEL_FAM6_SKYLAKE_X;
+}
+
+static inline bool poly1305_init_arch(void *ctx,
+				      const u8 key[POLY1305_KEY_SIZE])
+{
+	poly1305_init_x86_64(ctx, key);
+	return true;
+}
+
+struct poly1305_arch_internal {
+	union {
+		struct {
+			u32 h[5];
+			u32 is_base2_26;
+		};
+		u64 hs[3];
+	};
+	u64 r[2];
+	u64 pad;
+	struct { u32 r2, r1, r4, r3; } rn[9];
+};
+
+/* The AVX code uses base 2^26, while the scalar code uses base 2^64. If we hit
+ * the unfortunate situation of using AVX and then having to go back to scalar
+ * -- because the user is silly and has called the update function from two
+ * separate contexts -- then we need to convert back to the original base before
+ * proceeding. It is possible to reason that the initial reduction below is
+ * sufficient given the implementation invariants. However, for an avoidance of
+ * doubt and because this is not performance critical, we do the full reduction
+ * anyway.
+ */
+static void convert_to_base2_64(void *ctx)
+{
+	struct poly1305_arch_internal *state = ctx;
+	u32 cy;
+
+	if (!state->is_base2_26)
+		return;
+
+	cy = state->h[0] >> 26; state->h[0] &= 0x3ffffff; state->h[1] += cy;
+	cy = state->h[1] >> 26; state->h[1] &= 0x3ffffff; state->h[2] += cy;
+	cy = state->h[2] >> 26; state->h[2] &= 0x3ffffff; state->h[3] += cy;
+	cy = state->h[3] >> 26; state->h[3] &= 0x3ffffff; state->h[4] += cy;
+	state->hs[0] = ((u64)state->h[2] << 52) | ((u64)state->h[1] << 26) | state->h[0];
+	state->hs[1] = ((u64)state->h[4] << 40) | ((u64)state->h[3] << 14) | (state->h[2] >> 12);
+	state->hs[2] = state->h[4] >> 24;
+#define ULT(a, b) ((a ^ ((a ^ b) | ((a - b) ^ b))) >> (sizeof(a) * 8 - 1))
+	cy = (state->hs[2] >> 2) + (state->hs[2] & ~3ULL);
+	state->hs[2] &= 3;
+	state->hs[0] += cy;
+	state->hs[1] += (cy = ULT(state->hs[0], cy));
+	state->hs[2] += ULT(state->hs[1], cy);
+#undef ULT
+	state->is_base2_26 = 0;
+}
+
+static inline bool poly1305_blocks_arch(void *ctx, const u8 *inp,
+					size_t len, const u32 padbit,
+					simd_context_t *simd_context)
+{
+	struct poly1305_arch_internal *state = ctx;
+
+	/* SIMD disables preemption, so relax after processing each page. */
+	BUILD_BUG_ON(PAGE_SIZE < POLY1305_BLOCK_SIZE ||
+		     PAGE_SIZE % POLY1305_BLOCK_SIZE);
+
+	if (!IS_ENABLED(CONFIG_AS_AVX) || !poly1305_use_avx ||
+	    (len < (POLY1305_BLOCK_SIZE * 18) && !state->is_base2_26) ||
+	    !simd_use(simd_context)) {
+		convert_to_base2_64(ctx);
+		poly1305_blocks_x86_64(ctx, inp, len, padbit);
+		return true;
+	}
+
+	for (;;) {
+		const size_t bytes = min_t(size_t, len, PAGE_SIZE);
+
+		if (IS_ENABLED(CONFIG_AS_AVX512) && poly1305_use_avx512)
+			poly1305_blocks_avx512(ctx, inp, bytes, padbit);
+		else if (IS_ENABLED(CONFIG_AS_AVX2) && poly1305_use_avx2)
+			poly1305_blocks_avx2(ctx, inp, bytes, padbit);
+		else
+			poly1305_blocks_avx(ctx, inp, bytes, padbit);
+		len -= bytes;
+		if (!len)
+			break;
+		inp += bytes;
+		simd_relax(simd_context);
+	}
+
+	return true;
+}
+
+static inline bool poly1305_emit_arch(void *ctx, u8 mac[POLY1305_MAC_SIZE],
+				      const u32 nonce[4],
+				      simd_context_t *simd_context)
+{
+	struct poly1305_arch_internal *state = ctx;
+
+	if (!IS_ENABLED(CONFIG_AS_AVX) || !poly1305_use_avx ||
+	    !state->is_base2_26 || !simd_use(simd_context)) {
+		convert_to_base2_64(ctx);
+		poly1305_emit_x86_64(ctx, mac, nonce);
+	} else
+		poly1305_emit_avx(ctx, mac, nonce);
+	return true;
+}
diff --git a/lib/zinc/poly1305/poly1305-x86_64-cryptogams.S b/lib/zinc/poly1305/poly1305-x86_64.S
similarity index 58%
rename from lib/zinc/poly1305/poly1305-x86_64-cryptogams.S
rename to lib/zinc/poly1305/poly1305-x86_64.S
index ed634757354b..3c3f2b4d880b 100644
--- a/lib/zinc/poly1305/poly1305-x86_64-cryptogams.S
+++ b/lib/zinc/poly1305/poly1305-x86_64.S
@@ -1,22 +1,27 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
+ * Copyright (C) 2017 Samuel Neves <sneves@dei.uc.pt>. All Rights Reserved.
+ * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  * Copyright (C) 2006-2017 CRYPTOGAMS by <appro@openssl.org>. All Rights Reserved.
+ *
+ * This is based in part on Andy Polyakov's implementation from CRYPTOGAMS.
  */
 
-.text	
-
+#include <linux/linkage.h>
 
+.section .rodata.cst192.Lconst, "aM", @progbits, 192
+.align	64
+.Lconst:
+.long	0x0ffffff,0,0x0ffffff,0,0x0ffffff,0,0x0ffffff,0
+.long	16777216,0,16777216,0,16777216,0,16777216,0
+.long	0x3ffffff,0,0x3ffffff,0,0x3ffffff,0,0x3ffffff,0
+.long	2,2,2,3,2,0,2,1
+.long	0,0,0,1, 0,2,0,3, 0,4,0,5, 0,6,0,7
 
-.globl	poly1305_init
-.hidden	poly1305_init
-.globl	poly1305_blocks
-.hidden	poly1305_blocks
-.globl	poly1305_emit
-.hidden	poly1305_emit
+.text
 
-.type	poly1305_init,@function
 .align	32
-poly1305_init:
+ENTRY(poly1305_init_x86_64)
 	xorq	%rax,%rax
 	movq	%rax,0(%rdi)
 	movq	%rax,8(%rdi)
@@ -25,61 +30,30 @@ poly1305_init:
 	cmpq	$0,%rsi
 	je	.Lno_key
 
-	leaq	poly1305_blocks(%rip),%r10
-	leaq	poly1305_emit(%rip),%r11
-	movq	OPENSSL_ia32cap_P+4(%rip),%r9
-	leaq	poly1305_blocks_avx(%rip),%rax
-	leaq	poly1305_emit_avx(%rip),%rcx
-	btq	$28,%r9
-	cmovcq	%rax,%r10
-	cmovcq	%rcx,%r11
-	leaq	poly1305_blocks_avx2(%rip),%rax
-	btq	$37,%r9
-	cmovcq	%rax,%r10
-	movq	$2149646336,%rax
-	shrq	$32,%r9
-	andq	%rax,%r9
-	cmpq	%rax,%r9
-	je	.Linit_base2_44
 	movq	$0x0ffffffc0fffffff,%rax
 	movq	$0x0ffffffc0ffffffc,%rcx
 	andq	0(%rsi),%rax
 	andq	8(%rsi),%rcx
 	movq	%rax,24(%rdi)
 	movq	%rcx,32(%rdi)
-	movq	%r10,0(%rdx)
-	movq	%r11,8(%rdx)
 	movl	$1,%eax
 .Lno_key:
-	.byte	0xf3,0xc3
-.size	poly1305_init,.-poly1305_init
+	ret
+ENDPROC(poly1305_init_x86_64)
 
-.type	poly1305_blocks,@function
 .align	32
-poly1305_blocks:
-.cfi_startproc	
+ENTRY(poly1305_blocks_x86_64)
 .Lblocks:
 	shrq	$4,%rdx
 	jz	.Lno_data
 
 	pushq	%rbx
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%rbx,-16
-	pushq	%rbp
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%rbp,-24
 	pushq	%r12
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r12,-32
 	pushq	%r13
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r13,-40
 	pushq	%r14
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r14,-48
 	pushq	%r15
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r15,-56
+	pushq	%rdi
+
 .Lblocks_body:
 
 	movq	%rdx,%r15
@@ -89,7 +63,7 @@ poly1305_blocks:
 
 	movq	0(%rdi),%r14
 	movq	8(%rdi),%rbx
-	movq	16(%rdi),%rbp
+	movq	16(%rdi),%r10
 
 	movq	%r13,%r12
 	shrq	$2,%r13
@@ -99,14 +73,15 @@ poly1305_blocks:
 
 .align	32
 .Loop:
+
 	addq	0(%rsi),%r14
 	adcq	8(%rsi),%rbx
 	leaq	16(%rsi),%rsi
-	adcq	%rcx,%rbp
+	adcq	%rcx,%r10
 	mulq	%r14
 	movq	%rax,%r9
 	movq	%r11,%rax
-	movq	%rdx,%r10
+	movq	%rdx,%rdi
 
 	mulq	%r14
 	movq	%rax,%r14
@@ -116,62 +91,55 @@ poly1305_blocks:
 	mulq	%rbx
 	addq	%rax,%r9
 	movq	%r13,%rax
-	adcq	%rdx,%r10
+	adcq	%rdx,%rdi
 
 	mulq	%rbx
-	movq	%rbp,%rbx
+	movq	%r10,%rbx
 	addq	%rax,%r14
 	adcq	%rdx,%r8
 
 	imulq	%r13,%rbx
 	addq	%rbx,%r9
 	movq	%r8,%rbx
-	adcq	$0,%r10
+	adcq	$0,%rdi
 
-	imulq	%r11,%rbp
+	imulq	%r11,%r10
 	addq	%r9,%rbx
 	movq	$-4,%rax
-	adcq	%rbp,%r10
+	adcq	%r10,%rdi
 
-	andq	%r10,%rax
-	movq	%r10,%rbp
-	shrq	$2,%r10
-	andq	$3,%rbp
-	addq	%r10,%rax
+	andq	%rdi,%rax
+	movq	%rdi,%r10
+	shrq	$2,%rdi
+	andq	$3,%r10
+	addq	%rdi,%rax
 	addq	%rax,%r14
 	adcq	$0,%rbx
-	adcq	$0,%rbp
+	adcq	$0,%r10
+
 	movq	%r12,%rax
 	decq	%r15
 	jnz	.Loop
 
+	movq	0(%rsp),%rdi
+
 	movq	%r14,0(%rdi)
 	movq	%rbx,8(%rdi)
-	movq	%rbp,16(%rdi)
-
-	movq	0(%rsp),%r15
-.cfi_restore	%r15
-	movq	8(%rsp),%r14
-.cfi_restore	%r14
-	movq	16(%rsp),%r13
-.cfi_restore	%r13
-	movq	24(%rsp),%r12
-.cfi_restore	%r12
-	movq	32(%rsp),%rbp
-.cfi_restore	%rbp
+	movq	%r10,16(%rdi)
+
+	movq	8(%rsp),%r15
+	movq	16(%rsp),%r14
+	movq	24(%rsp),%r13
+	movq	32(%rsp),%r12
 	movq	40(%rsp),%rbx
-.cfi_restore	%rbx
 	leaq	48(%rsp),%rsp
-.cfi_adjust_cfa_offset	-48
 .Lno_data:
 .Lblocks_epilogue:
-	.byte	0xf3,0xc3
-.cfi_endproc	
-.size	poly1305_blocks,.-poly1305_blocks
+	ret
+ENDPROC(poly1305_blocks_x86_64)
 
-.type	poly1305_emit,@function
 .align	32
-poly1305_emit:
+ENTRY(poly1305_emit_x86_64)
 .Lemit:
 	movq	0(%rdi),%r8
 	movq	8(%rdi),%r9
@@ -191,15 +159,14 @@ poly1305_emit:
 	movq	%rax,0(%rsi)
 	movq	%rcx,8(%rsi)
 
-	.byte	0xf3,0xc3
-.size	poly1305_emit,.-poly1305_emit
-.type	__poly1305_block,@function
-.align	32
-__poly1305_block:
+	ret
+ENDPROC(poly1305_emit_x86_64)
+
+.macro __poly1305_block
 	mulq	%r14
 	movq	%rax,%r9
 	movq	%r11,%rax
-	movq	%rdx,%r10
+	movq	%rdx,%rdi
 
 	mulq	%r14
 	movq	%rax,%r14
@@ -209,45 +176,44 @@ __poly1305_block:
 	mulq	%rbx
 	addq	%rax,%r9
 	movq	%r13,%rax
-	adcq	%rdx,%r10
+	adcq	%rdx,%rdi
 
 	mulq	%rbx
-	movq	%rbp,%rbx
+	movq	%r10,%rbx
 	addq	%rax,%r14
 	adcq	%rdx,%r8
 
 	imulq	%r13,%rbx
 	addq	%rbx,%r9
 	movq	%r8,%rbx
-	adcq	$0,%r10
+	adcq	$0,%rdi
 
-	imulq	%r11,%rbp
+	imulq	%r11,%r10
 	addq	%r9,%rbx
 	movq	$-4,%rax
-	adcq	%rbp,%r10
+	adcq	%r10,%rdi
 
-	andq	%r10,%rax
-	movq	%r10,%rbp
-	shrq	$2,%r10
-	andq	$3,%rbp
-	addq	%r10,%rax
+	andq	%rdi,%rax
+	movq	%rdi,%r10
+	shrq	$2,%rdi
+	andq	$3,%r10
+	addq	%rdi,%rax
 	addq	%rax,%r14
 	adcq	$0,%rbx
-	adcq	$0,%rbp
-	.byte	0xf3,0xc3
-.size	__poly1305_block,.-__poly1305_block
+	adcq	$0,%r10
+.endm
 
-.type	__poly1305_init_avx,@function
-.align	32
-__poly1305_init_avx:
+.macro __poly1305_init_avx
 	movq	%r11,%r14
 	movq	%r12,%rbx
-	xorq	%rbp,%rbp
+	xorq	%r10,%r10
 
 	leaq	48+64(%rdi),%rdi
 
 	movq	%r12,%rax
-	call	__poly1305_block
+	movq	%rdi,0(%rsp)
+	__poly1305_block
+	movq	0(%rsp),%rdi
 
 	movl	$0x3ffffff,%eax
 	movl	$0x3ffffff,%edx
@@ -305,7 +271,7 @@ __poly1305_init_avx:
 	movl	%edx,36(%rdi)
 	shrq	$26,%r9
 
-	movq	%rbp,%rax
+	movq	%r10,%rax
 	shlq	$24,%rax
 	orq	%rax,%r8
 	movl	%r8d,48(%rdi)
@@ -316,7 +282,9 @@ __poly1305_init_avx:
 	movl	%r9d,68(%rdi)
 
 	movq	%r12,%rax
-	call	__poly1305_block
+	movq	%rdi,0(%rsp)
+	__poly1305_block
+	movq	0(%rsp),%rdi
 
 	movl	$0x3ffffff,%eax
 	movq	%r14,%r8
@@ -348,7 +316,7 @@ __poly1305_init_avx:
 	shrq	$26,%r8
 	movl	%edx,44(%rdi)
 
-	movq	%rbp,%rax
+	movq	%r10,%rax
 	shlq	$24,%rax
 	orq	%rax,%r8
 	movl	%r8d,60(%rdi)
@@ -356,7 +324,9 @@ __poly1305_init_avx:
 	movl	%r8d,76(%rdi)
 
 	movq	%r12,%rax
-	call	__poly1305_block
+	movq	%rdi,0(%rsp)
+	__poly1305_block
+	movq	0(%rsp),%rdi
 
 	movl	$0x3ffffff,%eax
 	movq	%r14,%r8
@@ -388,7 +358,7 @@ __poly1305_init_avx:
 	shrq	$26,%r8
 	movl	%edx,40(%rdi)
 
-	movq	%rbp,%rax
+	movq	%r10,%rax
 	shlq	$24,%rax
 	orq	%rax,%r8
 	movl	%r8d,56(%rdi)
@@ -396,13 +366,12 @@ __poly1305_init_avx:
 	movl	%r8d,72(%rdi)
 
 	leaq	-48-64(%rdi),%rdi
-	.byte	0xf3,0xc3
-.size	__poly1305_init_avx,.-__poly1305_init_avx
+.endm
 
-.type	poly1305_blocks_avx,@function
+#ifdef CONFIG_AS_AVX
 .align	32
-poly1305_blocks_avx:
-.cfi_startproc	
+ENTRY(poly1305_blocks_avx)
+
 	movl	20(%rdi),%r8d
 	cmpq	$128,%rdx
 	jae	.Lblocks_avx
@@ -422,30 +391,19 @@ poly1305_blocks_avx:
 	jz	.Leven_avx
 
 	pushq	%rbx
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%rbx,-16
-	pushq	%rbp
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%rbp,-24
 	pushq	%r12
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r12,-32
 	pushq	%r13
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r13,-40
 	pushq	%r14
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r14,-48
 	pushq	%r15
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r15,-56
+	pushq	%rdi
+
 .Lblocks_avx_body:
 
 	movq	%rdx,%r15
 
 	movq	0(%rdi),%r8
 	movq	8(%rdi),%r9
-	movl	16(%rdi),%ebp
+	movl	16(%rdi),%r10d
 
 	movq	24(%rdi),%r11
 	movq	32(%rdi),%r13
@@ -465,21 +423,21 @@ poly1305_blocks_avx:
 	addq	%r12,%r14
 	adcq	%r9,%rbx
 
-	movq	%rbp,%r8
+	movq	%r10,%r8
 	shlq	$40,%r8
-	shrq	$24,%rbp
+	shrq	$24,%r10
 	addq	%r8,%rbx
-	adcq	$0,%rbp
+	adcq	$0,%r10
 
 	movq	$-4,%r9
-	movq	%rbp,%r8
-	andq	%rbp,%r9
+	movq	%r10,%r8
+	andq	%r10,%r9
 	shrq	$2,%r8
-	andq	$3,%rbp
+	andq	$3,%r10
 	addq	%r9,%r8
 	addq	%r8,%r14
 	adcq	$0,%rbx
-	adcq	$0,%rbp
+	adcq	$0,%r10
 
 	movq	%r13,%r12
 	movq	%r13,%rax
@@ -489,9 +447,11 @@ poly1305_blocks_avx:
 	addq	0(%rsi),%r14
 	adcq	8(%rsi),%rbx
 	leaq	16(%rsi),%rsi
-	adcq	%rcx,%rbp
+	adcq	%rcx,%r10
 
-	call	__poly1305_block
+	movq	%rdi,0(%rsp)
+	__poly1305_block
+	movq	0(%rsp),%rdi
 
 	testq	%rcx,%rcx
 	jz	.Lstore_base2_64_avx
@@ -508,11 +468,11 @@ poly1305_blocks_avx:
 	andq	$0x3ffffff,%rdx
 	shrq	$14,%rbx
 	orq	%r11,%r14
-	shlq	$24,%rbp
+	shlq	$24,%r10
 	andq	$0x3ffffff,%r14
 	shrq	$40,%r12
 	andq	$0x3ffffff,%rbx
-	orq	%r12,%rbp
+	orq	%r12,%r10
 
 	subq	$16,%r15
 	jz	.Lstore_base2_26_avx
@@ -521,14 +481,14 @@ poly1305_blocks_avx:
 	vmovd	%edx,%xmm1
 	vmovd	%r14d,%xmm2
 	vmovd	%ebx,%xmm3
-	vmovd	%ebp,%xmm4
+	vmovd	%r10d,%xmm4
 	jmp	.Lproceed_avx
 
 .align	32
 .Lstore_base2_64_avx:
 	movq	%r14,0(%rdi)
 	movq	%rbx,8(%rdi)
-	movq	%rbp,16(%rdi)
+	movq	%r10,16(%rdi)
 	jmp	.Ldone_avx
 
 .align	16
@@ -537,49 +497,30 @@ poly1305_blocks_avx:
 	movl	%edx,4(%rdi)
 	movl	%r14d,8(%rdi)
 	movl	%ebx,12(%rdi)
-	movl	%ebp,16(%rdi)
+	movl	%r10d,16(%rdi)
 .align	16
 .Ldone_avx:
-	movq	0(%rsp),%r15
-.cfi_restore	%r15
-	movq	8(%rsp),%r14
-.cfi_restore	%r14
-	movq	16(%rsp),%r13
-.cfi_restore	%r13
-	movq	24(%rsp),%r12
-.cfi_restore	%r12
-	movq	32(%rsp),%rbp
-.cfi_restore	%rbp
+	movq	8(%rsp),%r15
+	movq	16(%rsp),%r14
+	movq	24(%rsp),%r13
+	movq	32(%rsp),%r12
 	movq	40(%rsp),%rbx
-.cfi_restore	%rbx
 	leaq	48(%rsp),%rsp
-.cfi_adjust_cfa_offset	-48
+
 .Lno_data_avx:
 .Lblocks_avx_epilogue:
-	.byte	0xf3,0xc3
-.cfi_endproc	
+	ret
 
 .align	32
 .Lbase2_64_avx:
-.cfi_startproc	
+
 	pushq	%rbx
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%rbx,-16
-	pushq	%rbp
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%rbp,-24
 	pushq	%r12
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r12,-32
 	pushq	%r13
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r13,-40
 	pushq	%r14
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r14,-48
 	pushq	%r15
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r15,-56
+	pushq	%rdi
+
 .Lbase2_64_avx_body:
 
 	movq	%rdx,%r15
@@ -589,7 +530,7 @@ poly1305_blocks_avx:
 
 	movq	0(%rdi),%r14
 	movq	8(%rdi),%rbx
-	movl	16(%rdi),%ebp
+	movl	16(%rdi),%r10d
 
 	movq	%r13,%r12
 	movq	%r13,%rax
@@ -602,10 +543,12 @@ poly1305_blocks_avx:
 	addq	0(%rsi),%r14
 	adcq	8(%rsi),%rbx
 	leaq	16(%rsi),%rsi
-	adcq	%rcx,%rbp
+	adcq	%rcx,%r10
 	subq	$16,%r15
 
-	call	__poly1305_block
+	movq	%rdi,0(%rsp)
+	__poly1305_block
+	movq	0(%rsp),%rdi
 
 .Linit_avx:
 
@@ -620,46 +563,38 @@ poly1305_blocks_avx:
 	andq	$0x3ffffff,%rdx
 	shrq	$14,%rbx
 	orq	%r8,%r14
-	shlq	$24,%rbp
+	shlq	$24,%r10
 	andq	$0x3ffffff,%r14
 	shrq	$40,%r9
 	andq	$0x3ffffff,%rbx
-	orq	%r9,%rbp
+	orq	%r9,%r10
 
 	vmovd	%eax,%xmm0
 	vmovd	%edx,%xmm1
 	vmovd	%r14d,%xmm2
 	vmovd	%ebx,%xmm3
-	vmovd	%ebp,%xmm4
+	vmovd	%r10d,%xmm4
 	movl	$1,20(%rdi)
 
-	call	__poly1305_init_avx
+	__poly1305_init_avx
 
 .Lproceed_avx:
 	movq	%r15,%rdx
 
-	movq	0(%rsp),%r15
-.cfi_restore	%r15
-	movq	8(%rsp),%r14
-.cfi_restore	%r14
-	movq	16(%rsp),%r13
-.cfi_restore	%r13
-	movq	24(%rsp),%r12
-.cfi_restore	%r12
-	movq	32(%rsp),%rbp
-.cfi_restore	%rbp
+	movq	8(%rsp),%r15
+	movq	16(%rsp),%r14
+	movq	24(%rsp),%r13
+	movq	32(%rsp),%r12
 	movq	40(%rsp),%rbx
-.cfi_restore	%rbx
 	leaq	48(%rsp),%rax
 	leaq	48(%rsp),%rsp
-.cfi_adjust_cfa_offset	-48
+
 .Lbase2_64_avx_epilogue:
 	jmp	.Ldo_avx
-.cfi_endproc	
+
 
 .align	32
 .Leven_avx:
-.cfi_startproc	
 	vmovd	0(%rdi),%xmm0
 	vmovd	4(%rdi),%xmm1
 	vmovd	8(%rdi),%xmm2
@@ -667,8 +602,10 @@ poly1305_blocks_avx:
 	vmovd	16(%rdi),%xmm4
 
 .Ldo_avx:
+	leaq	8(%rsp),%r10
+	andq	$-32,%rsp
+	subq	$8,%rsp
 	leaq	-88(%rsp),%r11
-.cfi_def_cfa	%r11,0x60
 	subq	$0x178,%rsp
 	subq	$64,%rdx
 	leaq	-32(%rsi),%rax
@@ -678,8 +615,6 @@ poly1305_blocks_avx:
 	leaq	112(%rdi),%rdi
 	leaq	.Lconst(%rip),%rcx
 
-
-
 	vmovdqu	32(%rsi),%xmm5
 	vmovdqu	48(%rsi),%xmm6
 	vmovdqa	64(%rcx),%xmm15
@@ -754,25 +689,6 @@ poly1305_blocks_avx:
 .align	32
 .Loop_avx:
 
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
 	vpmuludq	%xmm5,%xmm14,%xmm10
 	vpmuludq	%xmm6,%xmm14,%xmm11
 	vmovdqa	%xmm2,32(%r11)
@@ -866,15 +782,6 @@ poly1305_blocks_avx:
 	subq	$64,%rdx
 	cmovcq	%rax,%rsi
 
-
-
-
-
-
-
-
-
-
 	vpmuludq	%xmm0,%xmm9,%xmm5
 	vpmuludq	%xmm1,%xmm9,%xmm6
 	vpaddq	%xmm5,%xmm10,%xmm10
@@ -957,10 +864,6 @@ poly1305_blocks_avx:
 	vpand	%xmm15,%xmm8,%xmm8
 	vpor	32(%rcx),%xmm9,%xmm9
 
-
-
-
-
 	vpsrlq	$26,%xmm3,%xmm13
 	vpand	%xmm15,%xmm3,%xmm3
 	vpaddq	%xmm13,%xmm4,%xmm4
@@ -995,9 +898,6 @@ poly1305_blocks_avx:
 	ja	.Loop_avx
 
 .Lskip_loop_avx:
-
-
-
 	vpshufd	$0x10,%xmm14,%xmm14
 	addq	$32,%rdx
 	jnz	.Long_tail_avx
@@ -1015,12 +915,6 @@ poly1305_blocks_avx:
 	vmovdqa	%xmm3,48(%r11)
 	vmovdqa	%xmm4,64(%r11)
 
-
-
-
-
-
-
 	vpmuludq	%xmm7,%xmm14,%xmm12
 	vpmuludq	%xmm5,%xmm14,%xmm10
 	vpshufd	$0x10,-48(%rdi),%xmm2
@@ -1107,9 +1001,6 @@ poly1305_blocks_avx:
 	vpaddq	48(%r11),%xmm3,%xmm3
 	vpaddq	64(%r11),%xmm4,%xmm4
 
-
-
-
 	vpmuludq	%xmm0,%xmm9,%xmm5
 	vpaddq	%xmm5,%xmm10,%xmm10
 	vpmuludq	%xmm1,%xmm9,%xmm6
@@ -1175,8 +1066,6 @@ poly1305_blocks_avx:
 
 .Lshort_tail_avx:
 
-
-
 	vpsrldq	$8,%xmm14,%xmm9
 	vpsrldq	$8,%xmm13,%xmm8
 	vpsrldq	$8,%xmm11,%xmm6
@@ -1188,9 +1077,6 @@ poly1305_blocks_avx:
 	vpaddq	%xmm6,%xmm11,%xmm11
 	vpaddq	%xmm7,%xmm12,%xmm12
 
-
-
-
 	vpsrlq	$26,%xmm13,%xmm3
 	vpand	%xmm15,%xmm13,%xmm13
 	vpaddq	%xmm3,%xmm14,%xmm14
@@ -1227,16 +1113,14 @@ poly1305_blocks_avx:
 	vmovd	%xmm12,-104(%rdi)
 	vmovd	%xmm13,-100(%rdi)
 	vmovd	%xmm14,-96(%rdi)
-	leaq	88(%r11),%rsp
-.cfi_def_cfa	%rsp,8
+	leaq	-8(%r10),%rsp
+
 	vzeroupper
-	.byte	0xf3,0xc3
-.cfi_endproc	
-.size	poly1305_blocks_avx,.-poly1305_blocks_avx
+	ret
+ENDPROC(poly1305_blocks_avx)
 
-.type	poly1305_emit_avx,@function
 .align	32
-poly1305_emit_avx:
+ENTRY(poly1305_emit_avx)
 	cmpl	$0,20(%rdi)
 	je	.Lemit
 
@@ -1286,12 +1170,14 @@ poly1305_emit_avx:
 	movq	%rax,0(%rsi)
 	movq	%rcx,8(%rsi)
 
-	.byte	0xf3,0xc3
-.size	poly1305_emit_avx,.-poly1305_emit_avx
-.type	poly1305_blocks_avx2,@function
+	ret
+ENDPROC(poly1305_emit_avx)
+#endif /* CONFIG_AS_AVX */
+
+#ifdef CONFIG_AS_AVX2
 .align	32
-poly1305_blocks_avx2:
-.cfi_startproc	
+ENTRY(poly1305_blocks_avx2)
+
 	movl	20(%rdi),%r8d
 	cmpq	$128,%rdx
 	jae	.Lblocks_avx2
@@ -1311,30 +1197,19 @@ poly1305_blocks_avx2:
 	jz	.Leven_avx2
 
 	pushq	%rbx
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%rbx,-16
-	pushq	%rbp
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%rbp,-24
 	pushq	%r12
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r12,-32
 	pushq	%r13
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r13,-40
 	pushq	%r14
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r14,-48
 	pushq	%r15
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r15,-56
+	pushq	%rdi
+
 .Lblocks_avx2_body:
 
 	movq	%rdx,%r15
 
 	movq	0(%rdi),%r8
 	movq	8(%rdi),%r9
-	movl	16(%rdi),%ebp
+	movl	16(%rdi),%r10d
 
 	movq	24(%rdi),%r11
 	movq	32(%rdi),%r13
@@ -1354,21 +1229,21 @@ poly1305_blocks_avx2:
 	addq	%r12,%r14
 	adcq	%r9,%rbx
 
-	movq	%rbp,%r8
+	movq	%r10,%r8
 	shlq	$40,%r8
-	shrq	$24,%rbp
+	shrq	$24,%r10
 	addq	%r8,%rbx
-	adcq	$0,%rbp
+	adcq	$0,%r10
 
 	movq	$-4,%r9
-	movq	%rbp,%r8
-	andq	%rbp,%r9
+	movq	%r10,%r8
+	andq	%r10,%r9
 	shrq	$2,%r8
-	andq	$3,%rbp
+	andq	$3,%r10
 	addq	%r9,%r8
 	addq	%r8,%r14
 	adcq	$0,%rbx
-	adcq	$0,%rbp
+	adcq	$0,%r10
 
 	movq	%r13,%r12
 	movq	%r13,%rax
@@ -1379,10 +1254,12 @@ poly1305_blocks_avx2:
 	addq	0(%rsi),%r14
 	adcq	8(%rsi),%rbx
 	leaq	16(%rsi),%rsi
-	adcq	%rcx,%rbp
+	adcq	%rcx,%r10
 	subq	$16,%r15
 
-	call	__poly1305_block
+	movq	%rdi,0(%rsp)
+	__poly1305_block
+	movq	0(%rsp),%rdi
 	movq	%r12,%rax
 
 	testq	$63,%r15
@@ -1403,11 +1280,11 @@ poly1305_blocks_avx2:
 	andq	$0x3ffffff,%rdx
 	shrq	$14,%rbx
 	orq	%r11,%r14
-	shlq	$24,%rbp
+	shlq	$24,%r10
 	andq	$0x3ffffff,%r14
 	shrq	$40,%r12
 	andq	$0x3ffffff,%rbx
-	orq	%r12,%rbp
+	orq	%r12,%r10
 
 	testq	%r15,%r15
 	jz	.Lstore_base2_26_avx2
@@ -1416,14 +1293,14 @@ poly1305_blocks_avx2:
 	vmovd	%edx,%xmm1
 	vmovd	%r14d,%xmm2
 	vmovd	%ebx,%xmm3
-	vmovd	%ebp,%xmm4
+	vmovd	%r10d,%xmm4
 	jmp	.Lproceed_avx2
 
 .align	32
 .Lstore_base2_64_avx2:
 	movq	%r14,0(%rdi)
 	movq	%rbx,8(%rdi)
-	movq	%rbp,16(%rdi)
+	movq	%r10,16(%rdi)
 	jmp	.Ldone_avx2
 
 .align	16
@@ -1432,49 +1309,32 @@ poly1305_blocks_avx2:
 	movl	%edx,4(%rdi)
 	movl	%r14d,8(%rdi)
 	movl	%ebx,12(%rdi)
-	movl	%ebp,16(%rdi)
+	movl	%r10d,16(%rdi)
 .align	16
 .Ldone_avx2:
-	movq	0(%rsp),%r15
-.cfi_restore	%r15
-	movq	8(%rsp),%r14
-.cfi_restore	%r14
-	movq	16(%rsp),%r13
-.cfi_restore	%r13
-	movq	24(%rsp),%r12
-.cfi_restore	%r12
-	movq	32(%rsp),%rbp
-.cfi_restore	%rbp
+	movq	8(%rsp),%r15
+	movq	16(%rsp),%r14
+	movq	24(%rsp),%r13
+	movq	32(%rsp),%r12
 	movq	40(%rsp),%rbx
-.cfi_restore	%rbx
 	leaq	48(%rsp),%rsp
-.cfi_adjust_cfa_offset	-48
+
 .Lno_data_avx2:
 .Lblocks_avx2_epilogue:
-	.byte	0xf3,0xc3
-.cfi_endproc	
+	ret
+
 
 .align	32
 .Lbase2_64_avx2:
-.cfi_startproc	
+
+
 	pushq	%rbx
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%rbx,-16
-	pushq	%rbp
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%rbp,-24
 	pushq	%r12
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r12,-32
 	pushq	%r13
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r13,-40
 	pushq	%r14
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r14,-48
 	pushq	%r15
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r15,-56
+	pushq	%rdi
+
 .Lbase2_64_avx2_body:
 
 	movq	%rdx,%r15
@@ -1484,7 +1344,7 @@ poly1305_blocks_avx2:
 
 	movq	0(%rdi),%r14
 	movq	8(%rdi),%rbx
-	movl	16(%rdi),%ebp
+	movl	16(%rdi),%r10d
 
 	movq	%r13,%r12
 	movq	%r13,%rax
@@ -1498,10 +1358,12 @@ poly1305_blocks_avx2:
 	addq	0(%rsi),%r14
 	adcq	8(%rsi),%rbx
 	leaq	16(%rsi),%rsi
-	adcq	%rcx,%rbp
+	adcq	%rcx,%r10
 	subq	$16,%r15
 
-	call	__poly1305_block
+	movq	%rdi,0(%rsp)
+	__poly1305_block
+	movq	0(%rsp),%rdi
 	movq	%r12,%rax
 
 	testq	$63,%r15
@@ -1520,49 +1382,39 @@ poly1305_blocks_avx2:
 	andq	$0x3ffffff,%rdx
 	shrq	$14,%rbx
 	orq	%r8,%r14
-	shlq	$24,%rbp
+	shlq	$24,%r10
 	andq	$0x3ffffff,%r14
 	shrq	$40,%r9
 	andq	$0x3ffffff,%rbx
-	orq	%r9,%rbp
+	orq	%r9,%r10
 
 	vmovd	%eax,%xmm0
 	vmovd	%edx,%xmm1
 	vmovd	%r14d,%xmm2
 	vmovd	%ebx,%xmm3
-	vmovd	%ebp,%xmm4
+	vmovd	%r10d,%xmm4
 	movl	$1,20(%rdi)
 
-	call	__poly1305_init_avx
+	__poly1305_init_avx
 
 .Lproceed_avx2:
 	movq	%r15,%rdx
-	movl	OPENSSL_ia32cap_P+8(%rip),%r10d
-	movl	$3221291008,%r11d
-
-	movq	0(%rsp),%r15
-.cfi_restore	%r15
-	movq	8(%rsp),%r14
-.cfi_restore	%r14
-	movq	16(%rsp),%r13
-.cfi_restore	%r13
-	movq	24(%rsp),%r12
-.cfi_restore	%r12
-	movq	32(%rsp),%rbp
-.cfi_restore	%rbp
+
+	movq	8(%rsp),%r15
+	movq	16(%rsp),%r14
+	movq	24(%rsp),%r13
+	movq	32(%rsp),%r12
 	movq	40(%rsp),%rbx
-.cfi_restore	%rbx
 	leaq	48(%rsp),%rax
 	leaq	48(%rsp),%rsp
-.cfi_adjust_cfa_offset	-48
+
 .Lbase2_64_avx2_epilogue:
 	jmp	.Ldo_avx2
-.cfi_endproc	
+
 
 .align	32
 .Leven_avx2:
-.cfi_startproc	
-	movl	OPENSSL_ia32cap_P+8(%rip),%r10d
+
 	vmovd	0(%rdi),%xmm0
 	vmovd	4(%rdi),%xmm1
 	vmovd	8(%rdi),%xmm2
@@ -1570,14 +1422,7 @@ poly1305_blocks_avx2:
 	vmovd	16(%rdi),%xmm4
 
 .Ldo_avx2:
-	cmpq	$512,%rdx
-	jb	.Lskip_avx512
-	andl	%r11d,%r10d
-	testl	$65536,%r10d
-	jnz	.Lblocks_avx512
-.Lskip_avx512:
-	leaq	-8(%rsp),%r11
-.cfi_def_cfa	%r11,16
+	leaq	8(%rsp),%r10
 	subq	$0x128,%rsp
 	leaq	.Lconst(%rip),%rcx
 	leaq	48+64(%rdi),%rdi
@@ -1647,13 +1492,6 @@ poly1305_blocks_avx2:
 .align	32
 .Loop_avx2:
 
-
-
-
-
-
-
-
 	vpaddq	%ymm0,%ymm7,%ymm0
 	vmovdqa	0(%rsp),%ymm7
 	vpaddq	%ymm1,%ymm8,%ymm1
@@ -1664,21 +1502,6 @@ poly1305_blocks_avx2:
 	vmovdqa	48(%rax),%ymm10
 	vmovdqa	112(%rax),%ymm5
 
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
 	vpmuludq	%ymm2,%ymm7,%ymm13
 	vpmuludq	%ymm2,%ymm8,%ymm14
 	vpmuludq	%ymm2,%ymm9,%ymm15
@@ -1743,9 +1566,6 @@ poly1305_blocks_avx2:
 	vpaddq	%ymm4,%ymm15,%ymm4
 	vpaddq	%ymm0,%ymm11,%ymm0
 
-
-
-
 	vpsrlq	$26,%ymm3,%ymm14
 	vpand	%ymm5,%ymm3,%ymm3
 	vpaddq	%ymm14,%ymm4,%ymm4
@@ -1798,12 +1618,6 @@ poly1305_blocks_avx2:
 .byte	0x66,0x90
 .Ltail_avx2:
 
-
-
-
-
-
-
 	vpaddq	%ymm0,%ymm7,%ymm0
 	vmovdqu	4(%rsp),%ymm7
 	vpaddq	%ymm1,%ymm8,%ymm1
@@ -1868,9 +1682,6 @@ poly1305_blocks_avx2:
 	vpaddq	%ymm4,%ymm15,%ymm4
 	vpaddq	%ymm0,%ymm11,%ymm0
 
-
-
-
 	vpsrldq	$8,%ymm12,%ymm8
 	vpsrldq	$8,%ymm2,%ymm9
 	vpsrldq	$8,%ymm3,%ymm10
@@ -1893,9 +1704,6 @@ poly1305_blocks_avx2:
 	vpaddq	%ymm8,%ymm12,%ymm12
 	vpaddq	%ymm9,%ymm2,%ymm2
 
-
-
-
 	vpsrlq	$26,%ymm3,%ymm14
 	vpand	%ymm5,%ymm3,%ymm3
 	vpaddq	%ymm14,%ymm4,%ymm4
@@ -1932,110 +1740,673 @@ poly1305_blocks_avx2:
 	vmovd	%xmm2,-104(%rdi)
 	vmovd	%xmm3,-100(%rdi)
 	vmovd	%xmm4,-96(%rdi)
-	leaq	8(%r11),%rsp
-.cfi_def_cfa	%rsp,8
+	leaq	-8(%r10),%rsp
+
 	vzeroupper
-	.byte	0xf3,0xc3
-.cfi_endproc	
-.size	poly1305_blocks_avx2,.-poly1305_blocks_avx2
-.type	poly1305_blocks_avx512,@function
+	ret
+
+ENDPROC(poly1305_blocks_avx2)
+#endif /* CONFIG_AS_AVX2 */
+
+#ifdef CONFIG_AS_AVX512
 .align	32
-poly1305_blocks_avx512:
-.cfi_startproc	
-.Lblocks_avx512:
-	movl	$15,%eax
-	kmovw	%eax,%k2
-	leaq	-8(%rsp),%r11
-.cfi_def_cfa	%r11,16
-	subq	$0x128,%rsp
-	leaq	.Lconst(%rip),%rcx
-	leaq	48+64(%rdi),%rdi
-	vmovdqa	96(%rcx),%ymm9
+ENTRY(poly1305_blocks_avx512)
 
+	movl	20(%rdi),%r8d
+	cmpq	$128,%rdx
+	jae	.Lblocks_avx2_512
+	testl	%r8d,%r8d
+	jz	.Lblocks
 
-	vmovdqu	-64(%rdi),%xmm11
-	andq	$-512,%rsp
-	vmovdqu	-48(%rdi),%xmm12
-	movq	$0x20,%rax
-	vmovdqu	-32(%rdi),%xmm7
-	vmovdqu	-16(%rdi),%xmm13
-	vmovdqu	0(%rdi),%xmm8
-	vmovdqu	16(%rdi),%xmm14
-	vmovdqu	32(%rdi),%xmm10
-	vmovdqu	48(%rdi),%xmm15
-	vmovdqu	64(%rdi),%xmm6
-	vpermd	%zmm11,%zmm9,%zmm16
-	vpbroadcastq	64(%rcx),%zmm5
-	vpermd	%zmm12,%zmm9,%zmm17
-	vpermd	%zmm7,%zmm9,%zmm21
-	vpermd	%zmm13,%zmm9,%zmm18
-	vmovdqa64	%zmm16,0(%rsp){%k2}
-	vpsrlq	$32,%zmm16,%zmm7
-	vpermd	%zmm8,%zmm9,%zmm22
-	vmovdqu64	%zmm17,0(%rsp,%rax,1){%k2}
-	vpsrlq	$32,%zmm17,%zmm8
-	vpermd	%zmm14,%zmm9,%zmm19
-	vmovdqa64	%zmm21,64(%rsp){%k2}
-	vpermd	%zmm10,%zmm9,%zmm23
-	vpermd	%zmm15,%zmm9,%zmm20
-	vmovdqu64	%zmm18,64(%rsp,%rax,1){%k2}
-	vpermd	%zmm6,%zmm9,%zmm24
-	vmovdqa64	%zmm22,128(%rsp){%k2}
-	vmovdqu64	%zmm19,128(%rsp,%rax,1){%k2}
-	vmovdqa64	%zmm23,192(%rsp){%k2}
-	vmovdqu64	%zmm20,192(%rsp,%rax,1){%k2}
-	vmovdqa64	%zmm24,256(%rsp){%k2}
+.Lblocks_avx2_512:
+	andq	$-16,%rdx
+	jz	.Lno_data_avx2_512
 
+	vzeroupper
 
+	testl	%r8d,%r8d
+	jz	.Lbase2_64_avx2_512
 
+	testq	$63,%rdx
+	jz	.Leven_avx2_512
 
+	pushq	%rbx
+	pushq	%r12
+	pushq	%r13
+	pushq	%r14
+	pushq	%r15
+	pushq	%rdi
 
+.Lblocks_avx2_body_512:
 
+	movq	%rdx,%r15
 
+	movq	0(%rdi),%r8
+	movq	8(%rdi),%r9
+	movl	16(%rdi),%r10d
 
+	movq	24(%rdi),%r11
+	movq	32(%rdi),%r13
 
 
-	vpmuludq	%zmm7,%zmm16,%zmm11
-	vpmuludq	%zmm7,%zmm17,%zmm12
-	vpmuludq	%zmm7,%zmm18,%zmm13
-	vpmuludq	%zmm7,%zmm19,%zmm14
-	vpmuludq	%zmm7,%zmm20,%zmm15
-	vpsrlq	$32,%zmm18,%zmm9
+	movl	%r8d,%r14d
+	andq	$-2147483648,%r8
+	movq	%r9,%r12
+	movl	%r9d,%ebx
+	andq	$-2147483648,%r9
 
-	vpmuludq	%zmm8,%zmm24,%zmm25
-	vpmuludq	%zmm8,%zmm16,%zmm26
-	vpmuludq	%zmm8,%zmm17,%zmm27
-	vpmuludq	%zmm8,%zmm18,%zmm28
-	vpmuludq	%zmm8,%zmm19,%zmm29
-	vpsrlq	$32,%zmm19,%zmm10
-	vpaddq	%zmm25,%zmm11,%zmm11
-	vpaddq	%zmm26,%zmm12,%zmm12
-	vpaddq	%zmm27,%zmm13,%zmm13
-	vpaddq	%zmm28,%zmm14,%zmm14
-	vpaddq	%zmm29,%zmm15,%zmm15
+	shrq	$6,%r8
+	shlq	$52,%r12
+	addq	%r8,%r14
+	shrq	$12,%rbx
+	shrq	$18,%r9
+	addq	%r12,%r14
+	adcq	%r9,%rbx
 
-	vpmuludq	%zmm9,%zmm23,%zmm25
-	vpmuludq	%zmm9,%zmm24,%zmm26
-	vpmuludq	%zmm9,%zmm17,%zmm28
-	vpmuludq	%zmm9,%zmm18,%zmm29
-	vpmuludq	%zmm9,%zmm16,%zmm27
-	vpsrlq	$32,%zmm20,%zmm6
-	vpaddq	%zmm25,%zmm11,%zmm11
-	vpaddq	%zmm26,%zmm12,%zmm12
-	vpaddq	%zmm28,%zmm14,%zmm14
-	vpaddq	%zmm29,%zmm15,%zmm15
-	vpaddq	%zmm27,%zmm13,%zmm13
+	movq	%r10,%r8
+	shlq	$40,%r8
+	shrq	$24,%r10
+	addq	%r8,%rbx
+	adcq	$0,%r10
 
-	vpmuludq	%zmm10,%zmm22,%zmm25
-	vpmuludq	%zmm10,%zmm16,%zmm28
-	vpmuludq	%zmm10,%zmm17,%zmm29
-	vpmuludq	%zmm10,%zmm23,%zmm26
-	vpmuludq	%zmm10,%zmm24,%zmm27
-	vpaddq	%zmm25,%zmm11,%zmm11
-	vpaddq	%zmm28,%zmm14,%zmm14
-	vpaddq	%zmm29,%zmm15,%zmm15
-	vpaddq	%zmm26,%zmm12,%zmm12
-	vpaddq	%zmm27,%zmm13,%zmm13
+	movq	$-4,%r9
+	movq	%r10,%r8
+	andq	%r10,%r9
+	shrq	$2,%r8
+	andq	$3,%r10
+	addq	%r9,%r8
+	addq	%r8,%r14
+	adcq	$0,%rbx
+	adcq	$0,%r10
+
+	movq	%r13,%r12
+	movq	%r13,%rax
+	shrq	$2,%r13
+	addq	%r12,%r13
+
+.Lbase2_26_pre_avx2_512:
+	addq	0(%rsi),%r14
+	adcq	8(%rsi),%rbx
+	leaq	16(%rsi),%rsi
+	adcq	%rcx,%r10
+	subq	$16,%r15
+
+	movq	%rdi,0(%rsp)
+	__poly1305_block
+	movq	0(%rsp),%rdi
+	movq	%r12,%rax
+
+	testq	$63,%r15
+	jnz	.Lbase2_26_pre_avx2_512
+
+	testq	%rcx,%rcx
+	jz	.Lstore_base2_64_avx2_512
+
+
+	movq	%r14,%rax
+	movq	%r14,%rdx
+	shrq	$52,%r14
+	movq	%rbx,%r11
+	movq	%rbx,%r12
+	shrq	$26,%rdx
+	andq	$0x3ffffff,%rax
+	shlq	$12,%r11
+	andq	$0x3ffffff,%rdx
+	shrq	$14,%rbx
+	orq	%r11,%r14
+	shlq	$24,%r10
+	andq	$0x3ffffff,%r14
+	shrq	$40,%r12
+	andq	$0x3ffffff,%rbx
+	orq	%r12,%r10
+
+	testq	%r15,%r15
+	jz	.Lstore_base2_26_avx2_512
+
+	vmovd	%eax,%xmm0
+	vmovd	%edx,%xmm1
+	vmovd	%r14d,%xmm2
+	vmovd	%ebx,%xmm3
+	vmovd	%r10d,%xmm4
+	jmp	.Lproceed_avx2_512
+
+.align	32
+.Lstore_base2_64_avx2_512:
+	movq	%r14,0(%rdi)
+	movq	%rbx,8(%rdi)
+	movq	%r10,16(%rdi)
+	jmp	.Ldone_avx2_512
+
+.align	16
+.Lstore_base2_26_avx2_512:
+	movl	%eax,0(%rdi)
+	movl	%edx,4(%rdi)
+	movl	%r14d,8(%rdi)
+	movl	%ebx,12(%rdi)
+	movl	%r10d,16(%rdi)
+.align	16
+.Ldone_avx2_512:
+	movq	8(%rsp),%r15
+	movq	16(%rsp),%r14
+	movq	24(%rsp),%r13
+	movq	32(%rsp),%r12
+	movq	40(%rsp),%rbx
+	leaq	48(%rsp),%rsp
+
+.Lno_data_avx2_512:
+.Lblocks_avx2_epilogue_512:
+	ret
+
+
+.align	32
+.Lbase2_64_avx2_512:
+
+	pushq	%rbx
+	pushq	%r12
+	pushq	%r13
+	pushq	%r14
+	pushq	%r15
+	pushq	%rdi
+
+.Lbase2_64_avx2_body_512:
+
+	movq	%rdx,%r15
+
+	movq	24(%rdi),%r11
+	movq	32(%rdi),%r13
+
+	movq	0(%rdi),%r14
+	movq	8(%rdi),%rbx
+	movl	16(%rdi),%r10d
+
+	movq	%r13,%r12
+	movq	%r13,%rax
+	shrq	$2,%r13
+	addq	%r12,%r13
+
+	testq	$63,%rdx
+	jz	.Linit_avx2_512
+
+.Lbase2_64_pre_avx2_512:
+	addq	0(%rsi),%r14
+	adcq	8(%rsi),%rbx
+	leaq	16(%rsi),%rsi
+	adcq	%rcx,%r10
+	subq	$16,%r15
+
+	movq	%rdi,0(%rsp)
+	__poly1305_block
+	movq	0(%rsp),%rdi
+	movq	%r12,%rax
+
+	testq	$63,%r15
+	jnz	.Lbase2_64_pre_avx2_512
+
+.Linit_avx2_512:
+
+	movq	%r14,%rax
+	movq	%r14,%rdx
+	shrq	$52,%r14
+	movq	%rbx,%r8
+	movq	%rbx,%r9
+	shrq	$26,%rdx
+	andq	$0x3ffffff,%rax
+	shlq	$12,%r8
+	andq	$0x3ffffff,%rdx
+	shrq	$14,%rbx
+	orq	%r8,%r14
+	shlq	$24,%r10
+	andq	$0x3ffffff,%r14
+	shrq	$40,%r9
+	andq	$0x3ffffff,%rbx
+	orq	%r9,%r10
+
+	vmovd	%eax,%xmm0
+	vmovd	%edx,%xmm1
+	vmovd	%r14d,%xmm2
+	vmovd	%ebx,%xmm3
+	vmovd	%r10d,%xmm4
+	movl	$1,20(%rdi)
+
+	__poly1305_init_avx
+
+.Lproceed_avx2_512:
+	movq	%r15,%rdx
+
+	movq	8(%rsp),%r15
+	movq	16(%rsp),%r14
+	movq	24(%rsp),%r13
+	movq	32(%rsp),%r12
+	movq	40(%rsp),%rbx
+	leaq	48(%rsp),%rax
+	leaq	48(%rsp),%rsp
+
+.Lbase2_64_avx2_epilogue_512:
+	jmp	.Ldo_avx2_512
+
+
+.align	32
+.Leven_avx2_512:
+
+	vmovd	0(%rdi),%xmm0
+	vmovd	4(%rdi),%xmm1
+	vmovd	8(%rdi),%xmm2
+	vmovd	12(%rdi),%xmm3
+	vmovd	16(%rdi),%xmm4
+
+.Ldo_avx2_512:
+	cmpq	$512,%rdx
+	jae	.Lblocks_avx512
+.Lskip_avx512:
+	leaq	8(%rsp),%r10
+
+	subq	$0x128,%rsp
+	leaq	.Lconst(%rip),%rcx
+	leaq	48+64(%rdi),%rdi
+	vmovdqa	96(%rcx),%ymm7
+
+
+	vmovdqu	-64(%rdi),%xmm9
+	andq	$-512,%rsp
+	vmovdqu	-48(%rdi),%xmm10
+	vmovdqu	-32(%rdi),%xmm6
+	vmovdqu	-16(%rdi),%xmm11
+	vmovdqu	0(%rdi),%xmm12
+	vmovdqu	16(%rdi),%xmm13
+	leaq	144(%rsp),%rax
+	vmovdqu	32(%rdi),%xmm14
+	vpermd	%ymm9,%ymm7,%ymm9
+	vmovdqu	48(%rdi),%xmm15
+	vpermd	%ymm10,%ymm7,%ymm10
+	vmovdqu	64(%rdi),%xmm5
+	vpermd	%ymm6,%ymm7,%ymm6
+	vmovdqa	%ymm9,0(%rsp)
+	vpermd	%ymm11,%ymm7,%ymm11
+	vmovdqa	%ymm10,32-144(%rax)
+	vpermd	%ymm12,%ymm7,%ymm12
+	vmovdqa	%ymm6,64-144(%rax)
+	vpermd	%ymm13,%ymm7,%ymm13
+	vmovdqa	%ymm11,96-144(%rax)
+	vpermd	%ymm14,%ymm7,%ymm14
+	vmovdqa	%ymm12,128-144(%rax)
+	vpermd	%ymm15,%ymm7,%ymm15
+	vmovdqa	%ymm13,160-144(%rax)
+	vpermd	%ymm5,%ymm7,%ymm5
+	vmovdqa	%ymm14,192-144(%rax)
+	vmovdqa	%ymm15,224-144(%rax)
+	vmovdqa	%ymm5,256-144(%rax)
+	vmovdqa	64(%rcx),%ymm5
+
+
+
+	vmovdqu	0(%rsi),%xmm7
+	vmovdqu	16(%rsi),%xmm8
+	vinserti128	$1,32(%rsi),%ymm7,%ymm7
+	vinserti128	$1,48(%rsi),%ymm8,%ymm8
+	leaq	64(%rsi),%rsi
+
+	vpsrldq	$6,%ymm7,%ymm9
+	vpsrldq	$6,%ymm8,%ymm10
+	vpunpckhqdq	%ymm8,%ymm7,%ymm6
+	vpunpcklqdq	%ymm10,%ymm9,%ymm9
+	vpunpcklqdq	%ymm8,%ymm7,%ymm7
+
+	vpsrlq	$30,%ymm9,%ymm10
+	vpsrlq	$4,%ymm9,%ymm9
+	vpsrlq	$26,%ymm7,%ymm8
+	vpsrlq	$40,%ymm6,%ymm6
+	vpand	%ymm5,%ymm9,%ymm9
+	vpand	%ymm5,%ymm7,%ymm7
+	vpand	%ymm5,%ymm8,%ymm8
+	vpand	%ymm5,%ymm10,%ymm10
+	vpor	32(%rcx),%ymm6,%ymm6
+
+	vpaddq	%ymm2,%ymm9,%ymm2
+	subq	$64,%rdx
+	jz	.Ltail_avx2_512
+	jmp	.Loop_avx2_512
+
+.align	32
+.Loop_avx2_512:
+
+	vpaddq	%ymm0,%ymm7,%ymm0
+	vmovdqa	0(%rsp),%ymm7
+	vpaddq	%ymm1,%ymm8,%ymm1
+	vmovdqa	32(%rsp),%ymm8
+	vpaddq	%ymm3,%ymm10,%ymm3
+	vmovdqa	96(%rsp),%ymm9
+	vpaddq	%ymm4,%ymm6,%ymm4
+	vmovdqa	48(%rax),%ymm10
+	vmovdqa	112(%rax),%ymm5
+
+	vpmuludq	%ymm2,%ymm7,%ymm13
+	vpmuludq	%ymm2,%ymm8,%ymm14
+	vpmuludq	%ymm2,%ymm9,%ymm15
+	vpmuludq	%ymm2,%ymm10,%ymm11
+	vpmuludq	%ymm2,%ymm5,%ymm12
+
+	vpmuludq	%ymm0,%ymm8,%ymm6
+	vpmuludq	%ymm1,%ymm8,%ymm2
+	vpaddq	%ymm6,%ymm12,%ymm12
+	vpaddq	%ymm2,%ymm13,%ymm13
+	vpmuludq	%ymm3,%ymm8,%ymm6
+	vpmuludq	64(%rsp),%ymm4,%ymm2
+	vpaddq	%ymm6,%ymm15,%ymm15
+	vpaddq	%ymm2,%ymm11,%ymm11
+	vmovdqa	-16(%rax),%ymm8
+
+	vpmuludq	%ymm0,%ymm7,%ymm6
+	vpmuludq	%ymm1,%ymm7,%ymm2
+	vpaddq	%ymm6,%ymm11,%ymm11
+	vpaddq	%ymm2,%ymm12,%ymm12
+	vpmuludq	%ymm3,%ymm7,%ymm6
+	vpmuludq	%ymm4,%ymm7,%ymm2
+	vmovdqu	0(%rsi),%xmm7
+	vpaddq	%ymm6,%ymm14,%ymm14
+	vpaddq	%ymm2,%ymm15,%ymm15
+	vinserti128	$1,32(%rsi),%ymm7,%ymm7
+
+	vpmuludq	%ymm3,%ymm8,%ymm6
+	vpmuludq	%ymm4,%ymm8,%ymm2
+	vmovdqu	16(%rsi),%xmm8
+	vpaddq	%ymm6,%ymm11,%ymm11
+	vpaddq	%ymm2,%ymm12,%ymm12
+	vmovdqa	16(%rax),%ymm2
+	vpmuludq	%ymm1,%ymm9,%ymm6
+	vpmuludq	%ymm0,%ymm9,%ymm9
+	vpaddq	%ymm6,%ymm14,%ymm14
+	vpaddq	%ymm9,%ymm13,%ymm13
+	vinserti128	$1,48(%rsi),%ymm8,%ymm8
+	leaq	64(%rsi),%rsi
+
+	vpmuludq	%ymm1,%ymm2,%ymm6
+	vpmuludq	%ymm0,%ymm2,%ymm2
+	vpsrldq	$6,%ymm7,%ymm9
+	vpaddq	%ymm6,%ymm15,%ymm15
+	vpaddq	%ymm2,%ymm14,%ymm14
+	vpmuludq	%ymm3,%ymm10,%ymm6
+	vpmuludq	%ymm4,%ymm10,%ymm2
+	vpsrldq	$6,%ymm8,%ymm10
+	vpaddq	%ymm6,%ymm12,%ymm12
+	vpaddq	%ymm2,%ymm13,%ymm13
+	vpunpckhqdq	%ymm8,%ymm7,%ymm6
+
+	vpmuludq	%ymm3,%ymm5,%ymm3
+	vpmuludq	%ymm4,%ymm5,%ymm4
+	vpunpcklqdq	%ymm8,%ymm7,%ymm7
+	vpaddq	%ymm3,%ymm13,%ymm2
+	vpaddq	%ymm4,%ymm14,%ymm3
+	vpunpcklqdq	%ymm10,%ymm9,%ymm10
+	vpmuludq	80(%rax),%ymm0,%ymm4
+	vpmuludq	%ymm1,%ymm5,%ymm0
+	vmovdqa	64(%rcx),%ymm5
+	vpaddq	%ymm4,%ymm15,%ymm4
+	vpaddq	%ymm0,%ymm11,%ymm0
+
+	vpsrlq	$26,%ymm3,%ymm14
+	vpand	%ymm5,%ymm3,%ymm3
+	vpaddq	%ymm14,%ymm4,%ymm4
+
+	vpsrlq	$26,%ymm0,%ymm11
+	vpand	%ymm5,%ymm0,%ymm0
+	vpaddq	%ymm11,%ymm12,%ymm1
+
+	vpsrlq	$26,%ymm4,%ymm15
+	vpand	%ymm5,%ymm4,%ymm4
+
+	vpsrlq	$4,%ymm10,%ymm9
+
+	vpsrlq	$26,%ymm1,%ymm12
+	vpand	%ymm5,%ymm1,%ymm1
+	vpaddq	%ymm12,%ymm2,%ymm2
+
+	vpaddq	%ymm15,%ymm0,%ymm0
+	vpsllq	$2,%ymm15,%ymm15
+	vpaddq	%ymm15,%ymm0,%ymm0
+
+	vpand	%ymm5,%ymm9,%ymm9
+	vpsrlq	$26,%ymm7,%ymm8
+
+	vpsrlq	$26,%ymm2,%ymm13
+	vpand	%ymm5,%ymm2,%ymm2
+	vpaddq	%ymm13,%ymm3,%ymm3
+
+	vpaddq	%ymm9,%ymm2,%ymm2
+	vpsrlq	$30,%ymm10,%ymm10
+
+	vpsrlq	$26,%ymm0,%ymm11
+	vpand	%ymm5,%ymm0,%ymm0
+	vpaddq	%ymm11,%ymm1,%ymm1
+
+	vpsrlq	$40,%ymm6,%ymm6
+
+	vpsrlq	$26,%ymm3,%ymm14
+	vpand	%ymm5,%ymm3,%ymm3
+	vpaddq	%ymm14,%ymm4,%ymm4
+
+	vpand	%ymm5,%ymm7,%ymm7
+	vpand	%ymm5,%ymm8,%ymm8
+	vpand	%ymm5,%ymm10,%ymm10
+	vpor	32(%rcx),%ymm6,%ymm6
+
+	subq	$64,%rdx
+	jnz	.Loop_avx2_512
+
+.byte	0x66,0x90
+.Ltail_avx2_512:
+
+	vpaddq	%ymm0,%ymm7,%ymm0
+	vmovdqu	4(%rsp),%ymm7
+	vpaddq	%ymm1,%ymm8,%ymm1
+	vmovdqu	36(%rsp),%ymm8
+	vpaddq	%ymm3,%ymm10,%ymm3
+	vmovdqu	100(%rsp),%ymm9
+	vpaddq	%ymm4,%ymm6,%ymm4
+	vmovdqu	52(%rax),%ymm10
+	vmovdqu	116(%rax),%ymm5
+
+	vpmuludq	%ymm2,%ymm7,%ymm13
+	vpmuludq	%ymm2,%ymm8,%ymm14
+	vpmuludq	%ymm2,%ymm9,%ymm15
+	vpmuludq	%ymm2,%ymm10,%ymm11
+	vpmuludq	%ymm2,%ymm5,%ymm12
+
+	vpmuludq	%ymm0,%ymm8,%ymm6
+	vpmuludq	%ymm1,%ymm8,%ymm2
+	vpaddq	%ymm6,%ymm12,%ymm12
+	vpaddq	%ymm2,%ymm13,%ymm13
+	vpmuludq	%ymm3,%ymm8,%ymm6
+	vpmuludq	68(%rsp),%ymm4,%ymm2
+	vpaddq	%ymm6,%ymm15,%ymm15
+	vpaddq	%ymm2,%ymm11,%ymm11
+
+	vpmuludq	%ymm0,%ymm7,%ymm6
+	vpmuludq	%ymm1,%ymm7,%ymm2
+	vpaddq	%ymm6,%ymm11,%ymm11
+	vmovdqu	-12(%rax),%ymm8
+	vpaddq	%ymm2,%ymm12,%ymm12
+	vpmuludq	%ymm3,%ymm7,%ymm6
+	vpmuludq	%ymm4,%ymm7,%ymm2
+	vpaddq	%ymm6,%ymm14,%ymm14
+	vpaddq	%ymm2,%ymm15,%ymm15
+
+	vpmuludq	%ymm3,%ymm8,%ymm6
+	vpmuludq	%ymm4,%ymm8,%ymm2
+	vpaddq	%ymm6,%ymm11,%ymm11
+	vpaddq	%ymm2,%ymm12,%ymm12
+	vmovdqu	20(%rax),%ymm2
+	vpmuludq	%ymm1,%ymm9,%ymm6
+	vpmuludq	%ymm0,%ymm9,%ymm9
+	vpaddq	%ymm6,%ymm14,%ymm14
+	vpaddq	%ymm9,%ymm13,%ymm13
+
+	vpmuludq	%ymm1,%ymm2,%ymm6
+	vpmuludq	%ymm0,%ymm2,%ymm2
+	vpaddq	%ymm6,%ymm15,%ymm15
+	vpaddq	%ymm2,%ymm14,%ymm14
+	vpmuludq	%ymm3,%ymm10,%ymm6
+	vpmuludq	%ymm4,%ymm10,%ymm2
+	vpaddq	%ymm6,%ymm12,%ymm12
+	vpaddq	%ymm2,%ymm13,%ymm13
+
+	vpmuludq	%ymm3,%ymm5,%ymm3
+	vpmuludq	%ymm4,%ymm5,%ymm4
+	vpaddq	%ymm3,%ymm13,%ymm2
+	vpaddq	%ymm4,%ymm14,%ymm3
+	vpmuludq	84(%rax),%ymm0,%ymm4
+	vpmuludq	%ymm1,%ymm5,%ymm0
+	vmovdqa	64(%rcx),%ymm5
+	vpaddq	%ymm4,%ymm15,%ymm4
+	vpaddq	%ymm0,%ymm11,%ymm0
+
+	vpsrldq	$8,%ymm12,%ymm8
+	vpsrldq	$8,%ymm2,%ymm9
+	vpsrldq	$8,%ymm3,%ymm10
+	vpsrldq	$8,%ymm4,%ymm6
+	vpsrldq	$8,%ymm0,%ymm7
+	vpaddq	%ymm8,%ymm12,%ymm12
+	vpaddq	%ymm9,%ymm2,%ymm2
+	vpaddq	%ymm10,%ymm3,%ymm3
+	vpaddq	%ymm6,%ymm4,%ymm4
+	vpaddq	%ymm7,%ymm0,%ymm0
+
+	vpermq	$0x2,%ymm3,%ymm10
+	vpermq	$0x2,%ymm4,%ymm6
+	vpermq	$0x2,%ymm0,%ymm7
+	vpermq	$0x2,%ymm12,%ymm8
+	vpermq	$0x2,%ymm2,%ymm9
+	vpaddq	%ymm10,%ymm3,%ymm3
+	vpaddq	%ymm6,%ymm4,%ymm4
+	vpaddq	%ymm7,%ymm0,%ymm0
+	vpaddq	%ymm8,%ymm12,%ymm12
+	vpaddq	%ymm9,%ymm2,%ymm2
+
+	vpsrlq	$26,%ymm3,%ymm14
+	vpand	%ymm5,%ymm3,%ymm3
+	vpaddq	%ymm14,%ymm4,%ymm4
+
+	vpsrlq	$26,%ymm0,%ymm11
+	vpand	%ymm5,%ymm0,%ymm0
+	vpaddq	%ymm11,%ymm12,%ymm1
+
+	vpsrlq	$26,%ymm4,%ymm15
+	vpand	%ymm5,%ymm4,%ymm4
+
+	vpsrlq	$26,%ymm1,%ymm12
+	vpand	%ymm5,%ymm1,%ymm1
+	vpaddq	%ymm12,%ymm2,%ymm2
+
+	vpaddq	%ymm15,%ymm0,%ymm0
+	vpsllq	$2,%ymm15,%ymm15
+	vpaddq	%ymm15,%ymm0,%ymm0
+
+	vpsrlq	$26,%ymm2,%ymm13
+	vpand	%ymm5,%ymm2,%ymm2
+	vpaddq	%ymm13,%ymm3,%ymm3
+
+	vpsrlq	$26,%ymm0,%ymm11
+	vpand	%ymm5,%ymm0,%ymm0
+	vpaddq	%ymm11,%ymm1,%ymm1
+
+	vpsrlq	$26,%ymm3,%ymm14
+	vpand	%ymm5,%ymm3,%ymm3
+	vpaddq	%ymm14,%ymm4,%ymm4
+
+	vmovd	%xmm0,-112(%rdi)
+	vmovd	%xmm1,-108(%rdi)
+	vmovd	%xmm2,-104(%rdi)
+	vmovd	%xmm3,-100(%rdi)
+	vmovd	%xmm4,-96(%rdi)
+	leaq	-8(%r10),%rsp
+
+	vzeroupper
+	ret
+
+.Lblocks_avx512:
+
+	movl	$15,%eax
+	kmovw	%eax,%k2
+	leaq	8(%rsp),%r10
+
+	subq	$0x128,%rsp
+	leaq	.Lconst(%rip),%rcx
+	leaq	48+64(%rdi),%rdi
+	vmovdqa	96(%rcx),%ymm9
+
+	vmovdqu32	-64(%rdi),%zmm16{%k2}{z}
+	andq	$-512,%rsp
+	vmovdqu32	-48(%rdi),%zmm17{%k2}{z}
+	movq	$0x20,%rax
+	vmovdqu32	-32(%rdi),%zmm21{%k2}{z}
+	vmovdqu32	-16(%rdi),%zmm18{%k2}{z}
+	vmovdqu32	0(%rdi),%zmm22{%k2}{z}
+	vmovdqu32	16(%rdi),%zmm19{%k2}{z}
+	vmovdqu32	32(%rdi),%zmm23{%k2}{z}
+	vmovdqu32	48(%rdi),%zmm20{%k2}{z}
+	vmovdqu32	64(%rdi),%zmm24{%k2}{z}
+	vpermd	%zmm16,%zmm9,%zmm16
+	vpbroadcastq	64(%rcx),%zmm5
+	vpermd	%zmm17,%zmm9,%zmm17
+	vpermd	%zmm21,%zmm9,%zmm21
+	vpermd	%zmm18,%zmm9,%zmm18
+	vmovdqa64	%zmm16,0(%rsp){%k2}
+	vpsrlq	$32,%zmm16,%zmm7
+	vpermd	%zmm22,%zmm9,%zmm22
+	vmovdqu64	%zmm17,0(%rsp,%rax,1){%k2}
+	vpsrlq	$32,%zmm17,%zmm8
+	vpermd	%zmm19,%zmm9,%zmm19
+	vmovdqa64	%zmm21,64(%rsp){%k2}
+	vpermd	%zmm23,%zmm9,%zmm23
+	vpermd	%zmm20,%zmm9,%zmm20
+	vmovdqu64	%zmm18,64(%rsp,%rax,1){%k2}
+	vpermd	%zmm24,%zmm9,%zmm24
+	vmovdqa64	%zmm22,128(%rsp){%k2}
+	vmovdqu64	%zmm19,128(%rsp,%rax,1){%k2}
+	vmovdqa64	%zmm23,192(%rsp){%k2}
+	vmovdqu64	%zmm20,192(%rsp,%rax,1){%k2}
+	vmovdqa64	%zmm24,256(%rsp){%k2}
+
+	vpmuludq	%zmm7,%zmm16,%zmm11
+	vpmuludq	%zmm7,%zmm17,%zmm12
+	vpmuludq	%zmm7,%zmm18,%zmm13
+	vpmuludq	%zmm7,%zmm19,%zmm14
+	vpmuludq	%zmm7,%zmm20,%zmm15
+	vpsrlq	$32,%zmm18,%zmm9
+
+	vpmuludq	%zmm8,%zmm24,%zmm25
+	vpmuludq	%zmm8,%zmm16,%zmm26
+	vpmuludq	%zmm8,%zmm17,%zmm27
+	vpmuludq	%zmm8,%zmm18,%zmm28
+	vpmuludq	%zmm8,%zmm19,%zmm29
+	vpsrlq	$32,%zmm19,%zmm10
+	vpaddq	%zmm25,%zmm11,%zmm11
+	vpaddq	%zmm26,%zmm12,%zmm12
+	vpaddq	%zmm27,%zmm13,%zmm13
+	vpaddq	%zmm28,%zmm14,%zmm14
+	vpaddq	%zmm29,%zmm15,%zmm15
+
+	vpmuludq	%zmm9,%zmm23,%zmm25
+	vpmuludq	%zmm9,%zmm24,%zmm26
+	vpmuludq	%zmm9,%zmm17,%zmm28
+	vpmuludq	%zmm9,%zmm18,%zmm29
+	vpmuludq	%zmm9,%zmm16,%zmm27
+	vpsrlq	$32,%zmm20,%zmm6
+	vpaddq	%zmm25,%zmm11,%zmm11
+	vpaddq	%zmm26,%zmm12,%zmm12
+	vpaddq	%zmm28,%zmm14,%zmm14
+	vpaddq	%zmm29,%zmm15,%zmm15
+	vpaddq	%zmm27,%zmm13,%zmm13
+
+	vpmuludq	%zmm10,%zmm22,%zmm25
+	vpmuludq	%zmm10,%zmm16,%zmm28
+	vpmuludq	%zmm10,%zmm17,%zmm29
+	vpmuludq	%zmm10,%zmm23,%zmm26
+	vpmuludq	%zmm10,%zmm24,%zmm27
+	vpaddq	%zmm25,%zmm11,%zmm11
+	vpaddq	%zmm28,%zmm14,%zmm14
+	vpaddq	%zmm29,%zmm15,%zmm15
+	vpaddq	%zmm26,%zmm12,%zmm12
+	vpaddq	%zmm27,%zmm13,%zmm13
 
 	vpmuludq	%zmm6,%zmm24,%zmm28
 	vpmuludq	%zmm6,%zmm16,%zmm29
@@ -2048,15 +2419,10 @@ poly1305_blocks_avx512:
 	vpaddq	%zmm26,%zmm12,%zmm12
 	vpaddq	%zmm27,%zmm13,%zmm13
 
-
-
 	vmovdqu64	0(%rsi),%zmm10
 	vmovdqu64	64(%rsi),%zmm6
 	leaq	128(%rsi),%rsi
 
-
-
-
 	vpsrlq	$26,%zmm14,%zmm28
 	vpandq	%zmm5,%zmm14,%zmm14
 	vpaddq	%zmm28,%zmm15,%zmm15
@@ -2088,18 +2454,9 @@ poly1305_blocks_avx512:
 	vpandq	%zmm5,%zmm14,%zmm14
 	vpaddq	%zmm28,%zmm15,%zmm15
 
-
-
-
-
 	vpunpcklqdq	%zmm6,%zmm10,%zmm7
 	vpunpckhqdq	%zmm6,%zmm10,%zmm6
 
-
-
-
-
-
 	vmovdqa32	128(%rcx),%zmm25
 	movl	$0x7777,%eax
 	kmovw	%eax,%k1
@@ -2136,9 +2493,6 @@ poly1305_blocks_avx512:
 	vpandq	%zmm5,%zmm9,%zmm9
 	vpandq	%zmm5,%zmm7,%zmm7
 
-
-
-
 	vpaddq	%zmm2,%zmm9,%zmm2
 	subq	$192,%rdx
 	jbe	.Ltail_avx512
@@ -2147,33 +2501,6 @@ poly1305_blocks_avx512:
 .align	32
 .Loop_avx512:
 
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
 	vpmuludq	%zmm2,%zmm17,%zmm14
 	vpaddq	%zmm0,%zmm7,%zmm0
 	vpmuludq	%zmm2,%zmm18,%zmm15
@@ -2238,9 +2565,6 @@ poly1305_blocks_avx512:
 	vpaddq	%zmm26,%zmm12,%zmm1
 	vpaddq	%zmm27,%zmm13,%zmm2
 
-
-
-
 	vpsrlq	$52,%zmm7,%zmm9
 	vpsllq	$12,%zmm6,%zmm10
 
@@ -2288,18 +2612,11 @@ poly1305_blocks_avx512:
 
 	vpandq	%zmm5,%zmm7,%zmm7
 
-
-
-
 	subq	$128,%rdx
 	ja	.Loop_avx512
 
 .Ltail_avx512:
 
-
-
-
-
 	vpsrlq	$32,%zmm16,%zmm16
 	vpsrlq	$32,%zmm17,%zmm17
 	vpsrlq	$32,%zmm18,%zmm18
@@ -2310,11 +2627,8 @@ poly1305_blocks_avx512:
 	vpsrlq	$32,%zmm21,%zmm21
 	vpsrlq	$32,%zmm22,%zmm22
 
-
-
 	leaq	(%rsi,%rdx,1),%rsi
 
-
 	vpaddq	%zmm0,%zmm7,%zmm0
 
 	vpmuludq	%zmm2,%zmm17,%zmm14
@@ -2378,9 +2692,6 @@ poly1305_blocks_avx512:
 	vpaddq	%zmm26,%zmm12,%zmm1
 	vpaddq	%zmm27,%zmm13,%zmm2
 
-
-
-
 	movl	$1,%eax
 	vpermq	$0xb1,%zmm3,%zmm14
 	vpermq	$0xb1,%zmm15,%zmm4
@@ -2416,8 +2727,6 @@ poly1305_blocks_avx512:
 	vpaddq	%zmm12,%zmm1,%zmm1{%k3}{z}
 	vpaddq	%zmm13,%zmm2,%zmm2{%k3}{z}
 
-
-
 	vpsrlq	$26,%ymm3,%ymm14
 	vpand	%ymm5,%ymm3,%ymm3
 	vpsrldq	$6,%ymm7,%ymm9
@@ -2466,7 +2775,7 @@ poly1305_blocks_avx512:
 
 	leaq	144(%rsp),%rax
 	addq	$64,%rdx
-	jnz	.Ltail_avx2
+	jnz	.Ltail_avx2_512
 
 	vpsubq	%ymm9,%ymm2,%ymm2
 	vmovd	%xmm0,-112(%rdi)
@@ -2475,1091 +2784,9 @@ poly1305_blocks_avx512:
 	vmovd	%xmm3,-100(%rdi)
 	vmovd	%xmm4,-96(%rdi)
 	vzeroall
-	leaq	8(%r11),%rsp
-.cfi_def_cfa	%rsp,8
-	.byte	0xf3,0xc3
-.cfi_endproc	
-.size	poly1305_blocks_avx512,.-poly1305_blocks_avx512
-.type	poly1305_init_base2_44,@function
-.align	32
-poly1305_init_base2_44:
-	xorq	%rax,%rax
-	movq	%rax,0(%rdi)
-	movq	%rax,8(%rdi)
-	movq	%rax,16(%rdi)
-
-.Linit_base2_44:
-	leaq	poly1305_blocks_vpmadd52(%rip),%r10
-	leaq	poly1305_emit_base2_44(%rip),%r11
-
-	movq	$0x0ffffffc0fffffff,%rax
-	movq	$0x0ffffffc0ffffffc,%rcx
-	andq	0(%rsi),%rax
-	movq	$0x00000fffffffffff,%r8
-	andq	8(%rsi),%rcx
-	movq	$0x00000fffffffffff,%r9
-	andq	%rax,%r8
-	shrdq	$44,%rcx,%rax
-	movq	%r8,40(%rdi)
-	andq	%r9,%rax
-	shrq	$24,%rcx
-	movq	%rax,48(%rdi)
-	leaq	(%rax,%rax,4),%rax
-	movq	%rcx,56(%rdi)
-	shlq	$2,%rax
-	leaq	(%rcx,%rcx,4),%rcx
-	shlq	$2,%rcx
-	movq	%rax,24(%rdi)
-	movq	%rcx,32(%rdi)
-	movq	$-1,64(%rdi)
-	movq	%r10,0(%rdx)
-	movq	%r11,8(%rdx)
-	movl	$1,%eax
-	.byte	0xf3,0xc3
-.size	poly1305_init_base2_44,.-poly1305_init_base2_44
-.type	poly1305_blocks_vpmadd52,@function
-.align	32
-poly1305_blocks_vpmadd52:
-	shrq	$4,%rdx
-	jz	.Lno_data_vpmadd52
-
-	shlq	$40,%rcx
-	movq	64(%rdi),%r8
-
-
-
-
-
-
-	movq	$3,%rax
-	movq	$1,%r10
-	cmpq	$4,%rdx
-	cmovaeq	%r10,%rax
-	testq	%r8,%r8
-	cmovnsq	%r10,%rax
-
-	andq	%rdx,%rax
-	jz	.Lblocks_vpmadd52_4x
-
-	subq	%rax,%rdx
-	movl	$7,%r10d
-	movl	$1,%r11d
-	kmovw	%r10d,%k7
-	leaq	.L2_44_inp_permd(%rip),%r10
-	kmovw	%r11d,%k1
-
-	vmovq	%rcx,%xmm21
-	vmovdqa64	0(%r10),%ymm19
-	vmovdqa64	32(%r10),%ymm20
-	vpermq	$0xcf,%ymm21,%ymm21
-	vmovdqa64	64(%r10),%ymm22
-
-	vmovdqu64	0(%rdi),%ymm16{%k7}{z}
-	vmovdqu64	40(%rdi),%ymm3{%k7}{z}
-	vmovdqu64	32(%rdi),%ymm4{%k7}{z}
-	vmovdqu64	24(%rdi),%ymm5{%k7}{z}
-
-	vmovdqa64	96(%r10),%ymm23
-	vmovdqa64	128(%r10),%ymm24
-
-	jmp	.Loop_vpmadd52
-
-.align	32
-.Loop_vpmadd52:
-	vmovdqu32	0(%rsi),%xmm18
-	leaq	16(%rsi),%rsi
-
-	vpermd	%ymm18,%ymm19,%ymm18
-	vpsrlvq	%ymm20,%ymm18,%ymm18
-	vpandq	%ymm22,%ymm18,%ymm18
-	vporq	%ymm21,%ymm18,%ymm18
-
-	vpaddq	%ymm18,%ymm16,%ymm16
-
-	vpermq	$0,%ymm16,%ymm0{%k7}{z}
-	vpermq	$85,%ymm16,%ymm1{%k7}{z}
-	vpermq	$170,%ymm16,%ymm2{%k7}{z}
-
-	vpxord	%ymm16,%ymm16,%ymm16
-	vpxord	%ymm17,%ymm17,%ymm17
-
-	vpmadd52luq	%ymm3,%ymm0,%ymm16
-	vpmadd52huq	%ymm3,%ymm0,%ymm17
-
-	vpmadd52luq	%ymm4,%ymm1,%ymm16
-	vpmadd52huq	%ymm4,%ymm1,%ymm17
-
-	vpmadd52luq	%ymm5,%ymm2,%ymm16
-	vpmadd52huq	%ymm5,%ymm2,%ymm17
-
-	vpsrlvq	%ymm23,%ymm16,%ymm18
-	vpsllvq	%ymm24,%ymm17,%ymm17
-	vpandq	%ymm22,%ymm16,%ymm16
-
-	vpaddq	%ymm18,%ymm17,%ymm17
-
-	vpermq	$147,%ymm17,%ymm17
-
-	vpaddq	%ymm17,%ymm16,%ymm16
-
-	vpsrlvq	%ymm23,%ymm16,%ymm18
-	vpandq	%ymm22,%ymm16,%ymm16
-
-	vpermq	$147,%ymm18,%ymm18
-
-	vpaddq	%ymm18,%ymm16,%ymm16
-
-	vpermq	$147,%ymm16,%ymm18{%k1}{z}
-
-	vpaddq	%ymm18,%ymm16,%ymm16
-	vpsllq	$2,%ymm18,%ymm18
-
-	vpaddq	%ymm18,%ymm16,%ymm16
-
-	decq	%rax
-	jnz	.Loop_vpmadd52
-
-	vmovdqu64	%ymm16,0(%rdi){%k7}
-
-	testq	%rdx,%rdx
-	jnz	.Lblocks_vpmadd52_4x
-
-.Lno_data_vpmadd52:
-	.byte	0xf3,0xc3
-.size	poly1305_blocks_vpmadd52,.-poly1305_blocks_vpmadd52
-.type	poly1305_blocks_vpmadd52_4x,@function
-.align	32
-poly1305_blocks_vpmadd52_4x:
-	shrq	$4,%rdx
-	jz	.Lno_data_vpmadd52_4x
-
-	shlq	$40,%rcx
-	movq	64(%rdi),%r8
-
-.Lblocks_vpmadd52_4x:
-	vpbroadcastq	%rcx,%ymm31
-
-	vmovdqa64	.Lx_mask44(%rip),%ymm28
-	movl	$5,%eax
-	vmovdqa64	.Lx_mask42(%rip),%ymm29
-	kmovw	%eax,%k1
-
-	testq	%r8,%r8
-	js	.Linit_vpmadd52
-
-	vmovq	0(%rdi),%xmm0
-	vmovq	8(%rdi),%xmm1
-	vmovq	16(%rdi),%xmm2
-
-	testq	$3,%rdx
-	jnz	.Lblocks_vpmadd52_2x_do
-
-.Lblocks_vpmadd52_4x_do:
-	vpbroadcastq	64(%rdi),%ymm3
-	vpbroadcastq	96(%rdi),%ymm4
-	vpbroadcastq	128(%rdi),%ymm5
-	vpbroadcastq	160(%rdi),%ymm16
-
-.Lblocks_vpmadd52_4x_key_loaded:
-	vpsllq	$2,%ymm5,%ymm17
-	vpaddq	%ymm5,%ymm17,%ymm17
-	vpsllq	$2,%ymm17,%ymm17
-
-	testq	$7,%rdx
-	jz	.Lblocks_vpmadd52_8x
-
-	vmovdqu64	0(%rsi),%ymm26
-	vmovdqu64	32(%rsi),%ymm27
-	leaq	64(%rsi),%rsi
-
-	vpunpcklqdq	%ymm27,%ymm26,%ymm25
-	vpunpckhqdq	%ymm27,%ymm26,%ymm27
-
-
-
-	vpsrlq	$24,%ymm27,%ymm26
-	vporq	%ymm31,%ymm26,%ymm26
-	vpaddq	%ymm26,%ymm2,%ymm2
-	vpandq	%ymm28,%ymm25,%ymm24
-	vpsrlq	$44,%ymm25,%ymm25
-	vpsllq	$20,%ymm27,%ymm27
-	vporq	%ymm27,%ymm25,%ymm25
-	vpandq	%ymm28,%ymm25,%ymm25
-
-	subq	$4,%rdx
-	jz	.Ltail_vpmadd52_4x
-	jmp	.Loop_vpmadd52_4x
-	ud2
-
-.align	32
-.Linit_vpmadd52:
-	vmovq	24(%rdi),%xmm16
-	vmovq	56(%rdi),%xmm2
-	vmovq	32(%rdi),%xmm17
-	vmovq	40(%rdi),%xmm3
-	vmovq	48(%rdi),%xmm4
-
-	vmovdqa	%ymm3,%ymm0
-	vmovdqa	%ymm4,%ymm1
-	vmovdqa	%ymm2,%ymm5
-
-	movl	$2,%eax
-
-.Lmul_init_vpmadd52:
-	vpxorq	%ymm18,%ymm18,%ymm18
-	vpmadd52luq	%ymm2,%ymm16,%ymm18
-	vpxorq	%ymm19,%ymm19,%ymm19
-	vpmadd52huq	%ymm2,%ymm16,%ymm19
-	vpxorq	%ymm20,%ymm20,%ymm20
-	vpmadd52luq	%ymm2,%ymm17,%ymm20
-	vpxorq	%ymm21,%ymm21,%ymm21
-	vpmadd52huq	%ymm2,%ymm17,%ymm21
-	vpxorq	%ymm22,%ymm22,%ymm22
-	vpmadd52luq	%ymm2,%ymm3,%ymm22
-	vpxorq	%ymm23,%ymm23,%ymm23
-	vpmadd52huq	%ymm2,%ymm3,%ymm23
-
-	vpmadd52luq	%ymm0,%ymm3,%ymm18
-	vpmadd52huq	%ymm0,%ymm3,%ymm19
-	vpmadd52luq	%ymm0,%ymm4,%ymm20
-	vpmadd52huq	%ymm0,%ymm4,%ymm21
-	vpmadd52luq	%ymm0,%ymm5,%ymm22
-	vpmadd52huq	%ymm0,%ymm5,%ymm23
-
-	vpmadd52luq	%ymm1,%ymm17,%ymm18
-	vpmadd52huq	%ymm1,%ymm17,%ymm19
-	vpmadd52luq	%ymm1,%ymm3,%ymm20
-	vpmadd52huq	%ymm1,%ymm3,%ymm21
-	vpmadd52luq	%ymm1,%ymm4,%ymm22
-	vpmadd52huq	%ymm1,%ymm4,%ymm23
-
-
-
-	vpsrlq	$44,%ymm18,%ymm30
-	vpsllq	$8,%ymm19,%ymm19
-	vpandq	%ymm28,%ymm18,%ymm0
-	vpaddq	%ymm30,%ymm19,%ymm19
-
-	vpaddq	%ymm19,%ymm20,%ymm20
-
-	vpsrlq	$44,%ymm20,%ymm30
-	vpsllq	$8,%ymm21,%ymm21
-	vpandq	%ymm28,%ymm20,%ymm1
-	vpaddq	%ymm30,%ymm21,%ymm21
-
-	vpaddq	%ymm21,%ymm22,%ymm22
-
-	vpsrlq	$42,%ymm22,%ymm30
-	vpsllq	$10,%ymm23,%ymm23
-	vpandq	%ymm29,%ymm22,%ymm2
-	vpaddq	%ymm30,%ymm23,%ymm23
-
-	vpaddq	%ymm23,%ymm0,%ymm0
-	vpsllq	$2,%ymm23,%ymm23
-
-	vpaddq	%ymm23,%ymm0,%ymm0
-
-	vpsrlq	$44,%ymm0,%ymm30
-	vpandq	%ymm28,%ymm0,%ymm0
-
-	vpaddq	%ymm30,%ymm1,%ymm1
-
-	decl	%eax
-	jz	.Ldone_init_vpmadd52
-
-	vpunpcklqdq	%ymm4,%ymm1,%ymm4
-	vpbroadcastq	%xmm1,%xmm1
-	vpunpcklqdq	%ymm5,%ymm2,%ymm5
-	vpbroadcastq	%xmm2,%xmm2
-	vpunpcklqdq	%ymm3,%ymm0,%ymm3
-	vpbroadcastq	%xmm0,%xmm0
-
-	vpsllq	$2,%ymm4,%ymm16
-	vpsllq	$2,%ymm5,%ymm17
-	vpaddq	%ymm4,%ymm16,%ymm16
-	vpaddq	%ymm5,%ymm17,%ymm17
-	vpsllq	$2,%ymm16,%ymm16
-	vpsllq	$2,%ymm17,%ymm17
-
-	jmp	.Lmul_init_vpmadd52
-	ud2
-
-.align	32
-.Ldone_init_vpmadd52:
-	vinserti128	$1,%xmm4,%ymm1,%ymm4
-	vinserti128	$1,%xmm5,%ymm2,%ymm5
-	vinserti128	$1,%xmm3,%ymm0,%ymm3
-
-	vpermq	$216,%ymm4,%ymm4
-	vpermq	$216,%ymm5,%ymm5
-	vpermq	$216,%ymm3,%ymm3
-
-	vpsllq	$2,%ymm4,%ymm16
-	vpaddq	%ymm4,%ymm16,%ymm16
-	vpsllq	$2,%ymm16,%ymm16
-
-	vmovq	0(%rdi),%xmm0
-	vmovq	8(%rdi),%xmm1
-	vmovq	16(%rdi),%xmm2
-
-	testq	$3,%rdx
-	jnz	.Ldone_init_vpmadd52_2x
-
-	vmovdqu64	%ymm3,64(%rdi)
-	vpbroadcastq	%xmm3,%ymm3
-	vmovdqu64	%ymm4,96(%rdi)
-	vpbroadcastq	%xmm4,%ymm4
-	vmovdqu64	%ymm5,128(%rdi)
-	vpbroadcastq	%xmm5,%ymm5
-	vmovdqu64	%ymm16,160(%rdi)
-	vpbroadcastq	%xmm16,%ymm16
-
-	jmp	.Lblocks_vpmadd52_4x_key_loaded
-	ud2
-
-.align	32
-.Ldone_init_vpmadd52_2x:
-	vmovdqu64	%ymm3,64(%rdi)
-	vpsrldq	$8,%ymm3,%ymm3
-	vmovdqu64	%ymm4,96(%rdi)
-	vpsrldq	$8,%ymm4,%ymm4
-	vmovdqu64	%ymm5,128(%rdi)
-	vpsrldq	$8,%ymm5,%ymm5
-	vmovdqu64	%ymm16,160(%rdi)
-	vpsrldq	$8,%ymm16,%ymm16
-	jmp	.Lblocks_vpmadd52_2x_key_loaded
-	ud2
-
-.align	32
-.Lblocks_vpmadd52_2x_do:
-	vmovdqu64	128+8(%rdi),%ymm5{%k1}{z}
-	vmovdqu64	160+8(%rdi),%ymm16{%k1}{z}
-	vmovdqu64	64+8(%rdi),%ymm3{%k1}{z}
-	vmovdqu64	96+8(%rdi),%ymm4{%k1}{z}
-
-.Lblocks_vpmadd52_2x_key_loaded:
-	vmovdqu64	0(%rsi),%ymm26
-	vpxorq	%ymm27,%ymm27,%ymm27
-	leaq	32(%rsi),%rsi
-
-	vpunpcklqdq	%ymm27,%ymm26,%ymm25
-	vpunpckhqdq	%ymm27,%ymm26,%ymm27
-
-
-
-	vpsrlq	$24,%ymm27,%ymm26
-	vporq	%ymm31,%ymm26,%ymm26
-	vpaddq	%ymm26,%ymm2,%ymm2
-	vpandq	%ymm28,%ymm25,%ymm24
-	vpsrlq	$44,%ymm25,%ymm25
-	vpsllq	$20,%ymm27,%ymm27
-	vporq	%ymm27,%ymm25,%ymm25
-	vpandq	%ymm28,%ymm25,%ymm25
-
-	jmp	.Ltail_vpmadd52_2x
-	ud2
-
-.align	32
-.Loop_vpmadd52_4x:
-
-	vpaddq	%ymm24,%ymm0,%ymm0
-	vpaddq	%ymm25,%ymm1,%ymm1
-
-	vpxorq	%ymm18,%ymm18,%ymm18
-	vpmadd52luq	%ymm2,%ymm16,%ymm18
-	vpxorq	%ymm19,%ymm19,%ymm19
-	vpmadd52huq	%ymm2,%ymm16,%ymm19
-	vpxorq	%ymm20,%ymm20,%ymm20
-	vpmadd52luq	%ymm2,%ymm17,%ymm20
-	vpxorq	%ymm21,%ymm21,%ymm21
-	vpmadd52huq	%ymm2,%ymm17,%ymm21
-	vpxorq	%ymm22,%ymm22,%ymm22
-	vpmadd52luq	%ymm2,%ymm3,%ymm22
-	vpxorq	%ymm23,%ymm23,%ymm23
-	vpmadd52huq	%ymm2,%ymm3,%ymm23
-
-	vmovdqu64	0(%rsi),%ymm26
-	vmovdqu64	32(%rsi),%ymm27
-	leaq	64(%rsi),%rsi
-	vpmadd52luq	%ymm0,%ymm3,%ymm18
-	vpmadd52huq	%ymm0,%ymm3,%ymm19
-	vpmadd52luq	%ymm0,%ymm4,%ymm20
-	vpmadd52huq	%ymm0,%ymm4,%ymm21
-	vpmadd52luq	%ymm0,%ymm5,%ymm22
-	vpmadd52huq	%ymm0,%ymm5,%ymm23
-
-	vpunpcklqdq	%ymm27,%ymm26,%ymm25
-	vpunpckhqdq	%ymm27,%ymm26,%ymm27
-	vpmadd52luq	%ymm1,%ymm17,%ymm18
-	vpmadd52huq	%ymm1,%ymm17,%ymm19
-	vpmadd52luq	%ymm1,%ymm3,%ymm20
-	vpmadd52huq	%ymm1,%ymm3,%ymm21
-	vpmadd52luq	%ymm1,%ymm4,%ymm22
-	vpmadd52huq	%ymm1,%ymm4,%ymm23
-
-
-
-	vpsrlq	$44,%ymm18,%ymm30
-	vpsllq	$8,%ymm19,%ymm19
-	vpandq	%ymm28,%ymm18,%ymm0
-	vpaddq	%ymm30,%ymm19,%ymm19
-
-	vpsrlq	$24,%ymm27,%ymm26
-	vporq	%ymm31,%ymm26,%ymm26
-	vpaddq	%ymm19,%ymm20,%ymm20
-
-	vpsrlq	$44,%ymm20,%ymm30
-	vpsllq	$8,%ymm21,%ymm21
-	vpandq	%ymm28,%ymm20,%ymm1
-	vpaddq	%ymm30,%ymm21,%ymm21
-
-	vpandq	%ymm28,%ymm25,%ymm24
-	vpsrlq	$44,%ymm25,%ymm25
-	vpsllq	$20,%ymm27,%ymm27
-	vpaddq	%ymm21,%ymm22,%ymm22
-
-	vpsrlq	$42,%ymm22,%ymm30
-	vpsllq	$10,%ymm23,%ymm23
-	vpandq	%ymm29,%ymm22,%ymm2
-	vpaddq	%ymm30,%ymm23,%ymm23
-
-	vpaddq	%ymm26,%ymm2,%ymm2
-	vpaddq	%ymm23,%ymm0,%ymm0
-	vpsllq	$2,%ymm23,%ymm23
-
-	vpaddq	%ymm23,%ymm0,%ymm0
-	vporq	%ymm27,%ymm25,%ymm25
-	vpandq	%ymm28,%ymm25,%ymm25
-
-	vpsrlq	$44,%ymm0,%ymm30
-	vpandq	%ymm28,%ymm0,%ymm0
-
-	vpaddq	%ymm30,%ymm1,%ymm1
-
-	subq	$4,%rdx
-	jnz	.Loop_vpmadd52_4x
-
-.Ltail_vpmadd52_4x:
-	vmovdqu64	128(%rdi),%ymm5
-	vmovdqu64	160(%rdi),%ymm16
-	vmovdqu64	64(%rdi),%ymm3
-	vmovdqu64	96(%rdi),%ymm4
-
-.Ltail_vpmadd52_2x:
-	vpsllq	$2,%ymm5,%ymm17
-	vpaddq	%ymm5,%ymm17,%ymm17
-	vpsllq	$2,%ymm17,%ymm17
-
-
-	vpaddq	%ymm24,%ymm0,%ymm0
-	vpaddq	%ymm25,%ymm1,%ymm1
-
-	vpxorq	%ymm18,%ymm18,%ymm18
-	vpmadd52luq	%ymm2,%ymm16,%ymm18
-	vpxorq	%ymm19,%ymm19,%ymm19
-	vpmadd52huq	%ymm2,%ymm16,%ymm19
-	vpxorq	%ymm20,%ymm20,%ymm20
-	vpmadd52luq	%ymm2,%ymm17,%ymm20
-	vpxorq	%ymm21,%ymm21,%ymm21
-	vpmadd52huq	%ymm2,%ymm17,%ymm21
-	vpxorq	%ymm22,%ymm22,%ymm22
-	vpmadd52luq	%ymm2,%ymm3,%ymm22
-	vpxorq	%ymm23,%ymm23,%ymm23
-	vpmadd52huq	%ymm2,%ymm3,%ymm23
-
-	vpmadd52luq	%ymm0,%ymm3,%ymm18
-	vpmadd52huq	%ymm0,%ymm3,%ymm19
-	vpmadd52luq	%ymm0,%ymm4,%ymm20
-	vpmadd52huq	%ymm0,%ymm4,%ymm21
-	vpmadd52luq	%ymm0,%ymm5,%ymm22
-	vpmadd52huq	%ymm0,%ymm5,%ymm23
-
-	vpmadd52luq	%ymm1,%ymm17,%ymm18
-	vpmadd52huq	%ymm1,%ymm17,%ymm19
-	vpmadd52luq	%ymm1,%ymm3,%ymm20
-	vpmadd52huq	%ymm1,%ymm3,%ymm21
-	vpmadd52luq	%ymm1,%ymm4,%ymm22
-	vpmadd52huq	%ymm1,%ymm4,%ymm23
-
-
-
-
-	movl	$1,%eax
-	kmovw	%eax,%k1
-	vpsrldq	$8,%ymm18,%ymm24
-	vpsrldq	$8,%ymm19,%ymm0
-	vpsrldq	$8,%ymm20,%ymm25
-	vpsrldq	$8,%ymm21,%ymm1
-	vpaddq	%ymm24,%ymm18,%ymm18
-	vpaddq	%ymm0,%ymm19,%ymm19
-	vpsrldq	$8,%ymm22,%ymm26
-	vpsrldq	$8,%ymm23,%ymm2
-	vpaddq	%ymm25,%ymm20,%ymm20
-	vpaddq	%ymm1,%ymm21,%ymm21
-	vpermq	$0x2,%ymm18,%ymm24
-	vpermq	$0x2,%ymm19,%ymm0
-	vpaddq	%ymm26,%ymm22,%ymm22
-	vpaddq	%ymm2,%ymm23,%ymm23
-
-	vpermq	$0x2,%ymm20,%ymm25
-	vpermq	$0x2,%ymm21,%ymm1
-	vpaddq	%ymm24,%ymm18,%ymm18{%k1}{z}
-	vpaddq	%ymm0,%ymm19,%ymm19{%k1}{z}
-	vpermq	$0x2,%ymm22,%ymm26
-	vpermq	$0x2,%ymm23,%ymm2
-	vpaddq	%ymm25,%ymm20,%ymm20{%k1}{z}
-	vpaddq	%ymm1,%ymm21,%ymm21{%k1}{z}
-	vpaddq	%ymm26,%ymm22,%ymm22{%k1}{z}
-	vpaddq	%ymm2,%ymm23,%ymm23{%k1}{z}
-
-
-
-	vpsrlq	$44,%ymm18,%ymm30
-	vpsllq	$8,%ymm19,%ymm19
-	vpandq	%ymm28,%ymm18,%ymm0
-	vpaddq	%ymm30,%ymm19,%ymm19
-
-	vpaddq	%ymm19,%ymm20,%ymm20
-
-	vpsrlq	$44,%ymm20,%ymm30
-	vpsllq	$8,%ymm21,%ymm21
-	vpandq	%ymm28,%ymm20,%ymm1
-	vpaddq	%ymm30,%ymm21,%ymm21
-
-	vpaddq	%ymm21,%ymm22,%ymm22
-
-	vpsrlq	$42,%ymm22,%ymm30
-	vpsllq	$10,%ymm23,%ymm23
-	vpandq	%ymm29,%ymm22,%ymm2
-	vpaddq	%ymm30,%ymm23,%ymm23
-
-	vpaddq	%ymm23,%ymm0,%ymm0
-	vpsllq	$2,%ymm23,%ymm23
-
-	vpaddq	%ymm23,%ymm0,%ymm0
-
-	vpsrlq	$44,%ymm0,%ymm30
-	vpandq	%ymm28,%ymm0,%ymm0
-
-	vpaddq	%ymm30,%ymm1,%ymm1
-
-
-	subq	$2,%rdx
-	ja	.Lblocks_vpmadd52_4x_do
-
-	vmovq	%xmm0,0(%rdi)
-	vmovq	%xmm1,8(%rdi)
-	vmovq	%xmm2,16(%rdi)
-	vzeroall
-
-.Lno_data_vpmadd52_4x:
-	.byte	0xf3,0xc3
-.size	poly1305_blocks_vpmadd52_4x,.-poly1305_blocks_vpmadd52_4x
-.type	poly1305_blocks_vpmadd52_8x,@function
-.align	32
-poly1305_blocks_vpmadd52_8x:
-	shrq	$4,%rdx
-	jz	.Lno_data_vpmadd52_8x
-
-	shlq	$40,%rcx
-	movq	64(%rdi),%r8
-
-	vmovdqa64	.Lx_mask44(%rip),%ymm28
-	vmovdqa64	.Lx_mask42(%rip),%ymm29
-
-	testq	%r8,%r8
-	js	.Linit_vpmadd52
-
-	vmovq	0(%rdi),%xmm0
-	vmovq	8(%rdi),%xmm1
-	vmovq	16(%rdi),%xmm2
-
-.Lblocks_vpmadd52_8x:
-
-
-
-	vmovdqu64	128(%rdi),%ymm5
-	vmovdqu64	160(%rdi),%ymm16
-	vmovdqu64	64(%rdi),%ymm3
-	vmovdqu64	96(%rdi),%ymm4
-
-	vpsllq	$2,%ymm5,%ymm17
-	vpaddq	%ymm5,%ymm17,%ymm17
-	vpsllq	$2,%ymm17,%ymm17
-
-	vpbroadcastq	%xmm5,%ymm8
-	vpbroadcastq	%xmm3,%ymm6
-	vpbroadcastq	%xmm4,%ymm7
-
-	vpxorq	%ymm18,%ymm18,%ymm18
-	vpmadd52luq	%ymm8,%ymm16,%ymm18
-	vpxorq	%ymm19,%ymm19,%ymm19
-	vpmadd52huq	%ymm8,%ymm16,%ymm19
-	vpxorq	%ymm20,%ymm20,%ymm20
-	vpmadd52luq	%ymm8,%ymm17,%ymm20
-	vpxorq	%ymm21,%ymm21,%ymm21
-	vpmadd52huq	%ymm8,%ymm17,%ymm21
-	vpxorq	%ymm22,%ymm22,%ymm22
-	vpmadd52luq	%ymm8,%ymm3,%ymm22
-	vpxorq	%ymm23,%ymm23,%ymm23
-	vpmadd52huq	%ymm8,%ymm3,%ymm23
-
-	vpmadd52luq	%ymm6,%ymm3,%ymm18
-	vpmadd52huq	%ymm6,%ymm3,%ymm19
-	vpmadd52luq	%ymm6,%ymm4,%ymm20
-	vpmadd52huq	%ymm6,%ymm4,%ymm21
-	vpmadd52luq	%ymm6,%ymm5,%ymm22
-	vpmadd52huq	%ymm6,%ymm5,%ymm23
-
-	vpmadd52luq	%ymm7,%ymm17,%ymm18
-	vpmadd52huq	%ymm7,%ymm17,%ymm19
-	vpmadd52luq	%ymm7,%ymm3,%ymm20
-	vpmadd52huq	%ymm7,%ymm3,%ymm21
-	vpmadd52luq	%ymm7,%ymm4,%ymm22
-	vpmadd52huq	%ymm7,%ymm4,%ymm23
-
-
-
-	vpsrlq	$44,%ymm18,%ymm30
-	vpsllq	$8,%ymm19,%ymm19
-	vpandq	%ymm28,%ymm18,%ymm6
-	vpaddq	%ymm30,%ymm19,%ymm19
-
-	vpaddq	%ymm19,%ymm20,%ymm20
-
-	vpsrlq	$44,%ymm20,%ymm30
-	vpsllq	$8,%ymm21,%ymm21
-	vpandq	%ymm28,%ymm20,%ymm7
-	vpaddq	%ymm30,%ymm21,%ymm21
-
-	vpaddq	%ymm21,%ymm22,%ymm22
-
-	vpsrlq	$42,%ymm22,%ymm30
-	vpsllq	$10,%ymm23,%ymm23
-	vpandq	%ymm29,%ymm22,%ymm8
-	vpaddq	%ymm30,%ymm23,%ymm23
-
-	vpaddq	%ymm23,%ymm6,%ymm6
-	vpsllq	$2,%ymm23,%ymm23
-
-	vpaddq	%ymm23,%ymm6,%ymm6
-
-	vpsrlq	$44,%ymm6,%ymm30
-	vpandq	%ymm28,%ymm6,%ymm6
-
-	vpaddq	%ymm30,%ymm7,%ymm7
-
-
-
-
-
-	vpunpcklqdq	%ymm5,%ymm8,%ymm26
-	vpunpckhqdq	%ymm5,%ymm8,%ymm5
-	vpunpcklqdq	%ymm3,%ymm6,%ymm24
-	vpunpckhqdq	%ymm3,%ymm6,%ymm3
-	vpunpcklqdq	%ymm4,%ymm7,%ymm25
-	vpunpckhqdq	%ymm4,%ymm7,%ymm4
-	vshufi64x2	$0x44,%zmm5,%zmm26,%zmm8
-	vshufi64x2	$0x44,%zmm3,%zmm24,%zmm6
-	vshufi64x2	$0x44,%zmm4,%zmm25,%zmm7
-
-	vmovdqu64	0(%rsi),%zmm26
-	vmovdqu64	64(%rsi),%zmm27
-	leaq	128(%rsi),%rsi
-
-	vpsllq	$2,%zmm8,%zmm10
-	vpsllq	$2,%zmm7,%zmm9
-	vpaddq	%zmm8,%zmm10,%zmm10
-	vpaddq	%zmm7,%zmm9,%zmm9
-	vpsllq	$2,%zmm10,%zmm10
-	vpsllq	$2,%zmm9,%zmm9
-
-	vpbroadcastq	%rcx,%zmm31
-	vpbroadcastq	%xmm28,%zmm28
-	vpbroadcastq	%xmm29,%zmm29
-
-	vpbroadcastq	%xmm9,%zmm16
-	vpbroadcastq	%xmm10,%zmm17
-	vpbroadcastq	%xmm6,%zmm3
-	vpbroadcastq	%xmm7,%zmm4
-	vpbroadcastq	%xmm8,%zmm5
-
-	vpunpcklqdq	%zmm27,%zmm26,%zmm25
-	vpunpckhqdq	%zmm27,%zmm26,%zmm27
-
-
-
-	vpsrlq	$24,%zmm27,%zmm26
-	vporq	%zmm31,%zmm26,%zmm26
-	vpaddq	%zmm26,%zmm2,%zmm2
-	vpandq	%zmm28,%zmm25,%zmm24
-	vpsrlq	$44,%zmm25,%zmm25
-	vpsllq	$20,%zmm27,%zmm27
-	vporq	%zmm27,%zmm25,%zmm25
-	vpandq	%zmm28,%zmm25,%zmm25
-
-	subq	$8,%rdx
-	jz	.Ltail_vpmadd52_8x
-	jmp	.Loop_vpmadd52_8x
-
-.align	32
-.Loop_vpmadd52_8x:
-
-	vpaddq	%zmm24,%zmm0,%zmm0
-	vpaddq	%zmm25,%zmm1,%zmm1
-
-	vpxorq	%zmm18,%zmm18,%zmm18
-	vpmadd52luq	%zmm2,%zmm16,%zmm18
-	vpxorq	%zmm19,%zmm19,%zmm19
-	vpmadd52huq	%zmm2,%zmm16,%zmm19
-	vpxorq	%zmm20,%zmm20,%zmm20
-	vpmadd52luq	%zmm2,%zmm17,%zmm20
-	vpxorq	%zmm21,%zmm21,%zmm21
-	vpmadd52huq	%zmm2,%zmm17,%zmm21
-	vpxorq	%zmm22,%zmm22,%zmm22
-	vpmadd52luq	%zmm2,%zmm3,%zmm22
-	vpxorq	%zmm23,%zmm23,%zmm23
-	vpmadd52huq	%zmm2,%zmm3,%zmm23
-
-	vmovdqu64	0(%rsi),%zmm26
-	vmovdqu64	64(%rsi),%zmm27
-	leaq	128(%rsi),%rsi
-	vpmadd52luq	%zmm0,%zmm3,%zmm18
-	vpmadd52huq	%zmm0,%zmm3,%zmm19
-	vpmadd52luq	%zmm0,%zmm4,%zmm20
-	vpmadd52huq	%zmm0,%zmm4,%zmm21
-	vpmadd52luq	%zmm0,%zmm5,%zmm22
-	vpmadd52huq	%zmm0,%zmm5,%zmm23
-
-	vpunpcklqdq	%zmm27,%zmm26,%zmm25
-	vpunpckhqdq	%zmm27,%zmm26,%zmm27
-	vpmadd52luq	%zmm1,%zmm17,%zmm18
-	vpmadd52huq	%zmm1,%zmm17,%zmm19
-	vpmadd52luq	%zmm1,%zmm3,%zmm20
-	vpmadd52huq	%zmm1,%zmm3,%zmm21
-	vpmadd52luq	%zmm1,%zmm4,%zmm22
-	vpmadd52huq	%zmm1,%zmm4,%zmm23
-
-
-
-	vpsrlq	$44,%zmm18,%zmm30
-	vpsllq	$8,%zmm19,%zmm19
-	vpandq	%zmm28,%zmm18,%zmm0
-	vpaddq	%zmm30,%zmm19,%zmm19
-
-	vpsrlq	$24,%zmm27,%zmm26
-	vporq	%zmm31,%zmm26,%zmm26
-	vpaddq	%zmm19,%zmm20,%zmm20
-
-	vpsrlq	$44,%zmm20,%zmm30
-	vpsllq	$8,%zmm21,%zmm21
-	vpandq	%zmm28,%zmm20,%zmm1
-	vpaddq	%zmm30,%zmm21,%zmm21
-
-	vpandq	%zmm28,%zmm25,%zmm24
-	vpsrlq	$44,%zmm25,%zmm25
-	vpsllq	$20,%zmm27,%zmm27
-	vpaddq	%zmm21,%zmm22,%zmm22
-
-	vpsrlq	$42,%zmm22,%zmm30
-	vpsllq	$10,%zmm23,%zmm23
-	vpandq	%zmm29,%zmm22,%zmm2
-	vpaddq	%zmm30,%zmm23,%zmm23
-
-	vpaddq	%zmm26,%zmm2,%zmm2
-	vpaddq	%zmm23,%zmm0,%zmm0
-	vpsllq	$2,%zmm23,%zmm23
-
-	vpaddq	%zmm23,%zmm0,%zmm0
-	vporq	%zmm27,%zmm25,%zmm25
-	vpandq	%zmm28,%zmm25,%zmm25
-
-	vpsrlq	$44,%zmm0,%zmm30
-	vpandq	%zmm28,%zmm0,%zmm0
-
-	vpaddq	%zmm30,%zmm1,%zmm1
-
-	subq	$8,%rdx
-	jnz	.Loop_vpmadd52_8x
-
-.Ltail_vpmadd52_8x:
-
-	vpaddq	%zmm24,%zmm0,%zmm0
-	vpaddq	%zmm25,%zmm1,%zmm1
-
-	vpxorq	%zmm18,%zmm18,%zmm18
-	vpmadd52luq	%zmm2,%zmm9,%zmm18
-	vpxorq	%zmm19,%zmm19,%zmm19
-	vpmadd52huq	%zmm2,%zmm9,%zmm19
-	vpxorq	%zmm20,%zmm20,%zmm20
-	vpmadd52luq	%zmm2,%zmm10,%zmm20
-	vpxorq	%zmm21,%zmm21,%zmm21
-	vpmadd52huq	%zmm2,%zmm10,%zmm21
-	vpxorq	%zmm22,%zmm22,%zmm22
-	vpmadd52luq	%zmm2,%zmm6,%zmm22
-	vpxorq	%zmm23,%zmm23,%zmm23
-	vpmadd52huq	%zmm2,%zmm6,%zmm23
-
-	vpmadd52luq	%zmm0,%zmm6,%zmm18
-	vpmadd52huq	%zmm0,%zmm6,%zmm19
-	vpmadd52luq	%zmm0,%zmm7,%zmm20
-	vpmadd52huq	%zmm0,%zmm7,%zmm21
-	vpmadd52luq	%zmm0,%zmm8,%zmm22
-	vpmadd52huq	%zmm0,%zmm8,%zmm23
-
-	vpmadd52luq	%zmm1,%zmm10,%zmm18
-	vpmadd52huq	%zmm1,%zmm10,%zmm19
-	vpmadd52luq	%zmm1,%zmm6,%zmm20
-	vpmadd52huq	%zmm1,%zmm6,%zmm21
-	vpmadd52luq	%zmm1,%zmm7,%zmm22
-	vpmadd52huq	%zmm1,%zmm7,%zmm23
-
-
-
-
-	movl	$1,%eax
-	kmovw	%eax,%k1
-	vpsrldq	$8,%zmm18,%zmm24
-	vpsrldq	$8,%zmm19,%zmm0
-	vpsrldq	$8,%zmm20,%zmm25
-	vpsrldq	$8,%zmm21,%zmm1
-	vpaddq	%zmm24,%zmm18,%zmm18
-	vpaddq	%zmm0,%zmm19,%zmm19
-	vpsrldq	$8,%zmm22,%zmm26
-	vpsrldq	$8,%zmm23,%zmm2
-	vpaddq	%zmm25,%zmm20,%zmm20
-	vpaddq	%zmm1,%zmm21,%zmm21
-	vpermq	$0x2,%zmm18,%zmm24
-	vpermq	$0x2,%zmm19,%zmm0
-	vpaddq	%zmm26,%zmm22,%zmm22
-	vpaddq	%zmm2,%zmm23,%zmm23
-
-	vpermq	$0x2,%zmm20,%zmm25
-	vpermq	$0x2,%zmm21,%zmm1
-	vpaddq	%zmm24,%zmm18,%zmm18
-	vpaddq	%zmm0,%zmm19,%zmm19
-	vpermq	$0x2,%zmm22,%zmm26
-	vpermq	$0x2,%zmm23,%zmm2
-	vpaddq	%zmm25,%zmm20,%zmm20
-	vpaddq	%zmm1,%zmm21,%zmm21
-	vextracti64x4	$1,%zmm18,%ymm24
-	vextracti64x4	$1,%zmm19,%ymm0
-	vpaddq	%zmm26,%zmm22,%zmm22
-	vpaddq	%zmm2,%zmm23,%zmm23
-
-	vextracti64x4	$1,%zmm20,%ymm25
-	vextracti64x4	$1,%zmm21,%ymm1
-	vextracti64x4	$1,%zmm22,%ymm26
-	vextracti64x4	$1,%zmm23,%ymm2
-	vpaddq	%ymm24,%ymm18,%ymm18{%k1}{z}
-	vpaddq	%ymm0,%ymm19,%ymm19{%k1}{z}
-	vpaddq	%ymm25,%ymm20,%ymm20{%k1}{z}
-	vpaddq	%ymm1,%ymm21,%ymm21{%k1}{z}
-	vpaddq	%ymm26,%ymm22,%ymm22{%k1}{z}
-	vpaddq	%ymm2,%ymm23,%ymm23{%k1}{z}
-
-
-
-	vpsrlq	$44,%ymm18,%ymm30
-	vpsllq	$8,%ymm19,%ymm19
-	vpandq	%ymm28,%ymm18,%ymm0
-	vpaddq	%ymm30,%ymm19,%ymm19
-
-	vpaddq	%ymm19,%ymm20,%ymm20
-
-	vpsrlq	$44,%ymm20,%ymm30
-	vpsllq	$8,%ymm21,%ymm21
-	vpandq	%ymm28,%ymm20,%ymm1
-	vpaddq	%ymm30,%ymm21,%ymm21
-
-	vpaddq	%ymm21,%ymm22,%ymm22
-
-	vpsrlq	$42,%ymm22,%ymm30
-	vpsllq	$10,%ymm23,%ymm23
-	vpandq	%ymm29,%ymm22,%ymm2
-	vpaddq	%ymm30,%ymm23,%ymm23
-
-	vpaddq	%ymm23,%ymm0,%ymm0
-	vpsllq	$2,%ymm23,%ymm23
-
-	vpaddq	%ymm23,%ymm0,%ymm0
-
-	vpsrlq	$44,%ymm0,%ymm30
-	vpandq	%ymm28,%ymm0,%ymm0
-
-	vpaddq	%ymm30,%ymm1,%ymm1
-
-
-
-	vmovq	%xmm0,0(%rdi)
-	vmovq	%xmm1,8(%rdi)
-	vmovq	%xmm2,16(%rdi)
-	vzeroall
-
-.Lno_data_vpmadd52_8x:
-	.byte	0xf3,0xc3
-.size	poly1305_blocks_vpmadd52_8x,.-poly1305_blocks_vpmadd52_8x
-.type	poly1305_emit_base2_44,@function
-.align	32
-poly1305_emit_base2_44:
-	movq	0(%rdi),%r8
-	movq	8(%rdi),%r9
-	movq	16(%rdi),%r10
-
-	movq	%r9,%rax
-	shrq	$20,%r9
-	shlq	$44,%rax
-	movq	%r10,%rcx
-	shrq	$40,%r10
-	shlq	$24,%rcx
-
-	addq	%rax,%r8
-	adcq	%rcx,%r9
-	adcq	$0,%r10
-
-	movq	%r8,%rax
-	addq	$5,%r8
-	movq	%r9,%rcx
-	adcq	$0,%r9
-	adcq	$0,%r10
-	shrq	$2,%r10
-	cmovnzq	%r8,%rax
-	cmovnzq	%r9,%rcx
-
-	addq	0(%rdx),%rax
-	adcq	8(%rdx),%rcx
-	movq	%rax,0(%rsi)
-	movq	%rcx,8(%rsi)
-
-	.byte	0xf3,0xc3
-.size	poly1305_emit_base2_44,.-poly1305_emit_base2_44
-.align	64
-.Lconst:
-.Lmask24:
-.long	0x0ffffff,0,0x0ffffff,0,0x0ffffff,0,0x0ffffff,0
-.L129:
-.long	16777216,0,16777216,0,16777216,0,16777216,0
-.Lmask26:
-.long	0x3ffffff,0,0x3ffffff,0,0x3ffffff,0,0x3ffffff,0
-.Lpermd_avx2:
-.long	2,2,2,3,2,0,2,1
-.Lpermd_avx512:
-.long	0,0,0,1, 0,2,0,3, 0,4,0,5, 0,6,0,7
+	leaq	-8(%r10),%rsp
 
-.L2_44_inp_permd:
-.long	0,1,1,2,2,3,7,7
-.L2_44_inp_shift:
-.quad	0,12,24,64
-.L2_44_mask:
-.quad	0xfffffffffff,0xfffffffffff,0x3ffffffffff,0xffffffffffffffff
-.L2_44_shift_rgt:
-.quad	44,44,42,64
-.L2_44_shift_lft:
-.quad	8,8,10,64
+	ret
 
-.align	64
-.Lx_mask44:
-.quad	0xfffffffffff,0xfffffffffff,0xfffffffffff,0xfffffffffff
-.quad	0xfffffffffff,0xfffffffffff,0xfffffffffff,0xfffffffffff
-.Lx_mask42:
-.quad	0x3ffffffffff,0x3ffffffffff,0x3ffffffffff,0x3ffffffffff
-.quad	0x3ffffffffff,0x3ffffffffff,0x3ffffffffff,0x3ffffffffff
-.byte	80,111,108,121,49,51,48,53,32,102,111,114,32,120,56,54,95,54,52,44,32,67,82,89,80,84,79,71,65,77,83,32,98,121,32,60,97,112,112,114,111,64,111,112,101,110,115,115,108,46,111,114,103,62,0
-.align	16
-.globl	xor128_encrypt_n_pad
-.type	xor128_encrypt_n_pad,@function
-.align	16
-xor128_encrypt_n_pad:
-	subq	%rdx,%rsi
-	subq	%rdx,%rdi
-	movq	%rcx,%r10
-	shrq	$4,%rcx
-	jz	.Ltail_enc
-	nop
-.Loop_enc_xmm:
-	movdqu	(%rsi,%rdx,1),%xmm0
-	pxor	(%rdx),%xmm0
-	movdqu	%xmm0,(%rdi,%rdx,1)
-	movdqa	%xmm0,(%rdx)
-	leaq	16(%rdx),%rdx
-	decq	%rcx
-	jnz	.Loop_enc_xmm
-
-	andq	$15,%r10
-	jz	.Ldone_enc
-
-.Ltail_enc:
-	movq	$16,%rcx
-	subq	%r10,%rcx
-	xorl	%eax,%eax
-.Loop_enc_byte:
-	movb	(%rsi,%rdx,1),%al
-	xorb	(%rdx),%al
-	movb	%al,(%rdi,%rdx,1)
-	movb	%al,(%rdx)
-	leaq	1(%rdx),%rdx
-	decq	%r10
-	jnz	.Loop_enc_byte
-
-	xorl	%eax,%eax
-.Loop_enc_pad:
-	movb	%al,(%rdx)
-	leaq	1(%rdx),%rdx
-	decq	%rcx
-	jnz	.Loop_enc_pad
-
-.Ldone_enc:
-	movq	%rdx,%rax
-	.byte	0xf3,0xc3
-.size	xor128_encrypt_n_pad,.-xor128_encrypt_n_pad
-
-.globl	xor128_decrypt_n_pad
-.type	xor128_decrypt_n_pad,@function
-.align	16
-xor128_decrypt_n_pad:
-	subq	%rdx,%rsi
-	subq	%rdx,%rdi
-	movq	%rcx,%r10
-	shrq	$4,%rcx
-	jz	.Ltail_dec
-	nop
-.Loop_dec_xmm:
-	movdqu	(%rsi,%rdx,1),%xmm0
-	movdqa	(%rdx),%xmm1
-	pxor	%xmm0,%xmm1
-	movdqu	%xmm1,(%rdi,%rdx,1)
-	movdqa	%xmm0,(%rdx)
-	leaq	16(%rdx),%rdx
-	decq	%rcx
-	jnz	.Loop_dec_xmm
-
-	pxor	%xmm1,%xmm1
-	andq	$15,%r10
-	jz	.Ldone_dec
-
-.Ltail_dec:
-	movq	$16,%rcx
-	subq	%r10,%rcx
-	xorl	%eax,%eax
-	xorq	%r11,%r11
-.Loop_dec_byte:
-	movb	(%rsi,%rdx,1),%r11b
-	movb	(%rdx),%al
-	xorb	%r11b,%al
-	movb	%al,(%rdi,%rdx,1)
-	movb	%r11b,(%rdx)
-	leaq	1(%rdx),%rdx
-	decq	%r10
-	jnz	.Loop_dec_byte
-
-	xorl	%eax,%eax
-.Loop_dec_pad:
-	movb	%al,(%rdx)
-	leaq	1(%rdx),%rdx
-	decq	%rcx
-	jnz	.Loop_dec_pad
-
-.Ldone_dec:
-	movq	%rdx,%rax
-	.byte	0xf3,0xc3
-.size	xor128_decrypt_n_pad,.-xor128_decrypt_n_pad
+ENDPROC(poly1305_blocks_avx512)
+#endif /* CONFIG_AS_AVX512 */
diff --git a/lib/zinc/poly1305/poly1305.c b/lib/zinc/poly1305/poly1305.c
index d4922d230c4f..0a580f1328fc 100644
--- a/lib/zinc/poly1305/poly1305.c
+++ b/lib/zinc/poly1305/poly1305.c
@@ -16,6 +16,9 @@
 #include <linux/module.h>
 #include <linux/init.h>
 
+#if defined(CONFIG_ZINC_ARCH_X86_64)
+#include "poly1305-x86_64-glue.c"
+#else
 static inline bool poly1305_init_arch(void *ctx,
 				      const u8 key[POLY1305_KEY_SIZE])
 {
@@ -37,6 +40,7 @@ static bool *const poly1305_nobs[] __initconst = { };
 static void __init poly1305_fpu_init(void)
 {
 }
+#endif
 
 #if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
 #include "poly1305-donna64.c"
-- 
2.19.1
