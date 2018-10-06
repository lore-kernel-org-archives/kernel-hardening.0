From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next v7 06/28] zinc: ChaCha20 x86_64 implementation
Date: Sat,  6 Oct 2018 04:56:47 +0200
Message-Id: <20181006025709.4019-7-Jason@zx2c4.com>
In-Reply-To: <20181006025709.4019-1-Jason@zx2c4.com>
References: <20181006025709.4019-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Samuel Neves <sneves@dei.uc.pt>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This ports SSSE3, AVX-2, AVX-512F, and AVX-512VL implementations for
ChaCha20. The AVX-512F implementation is disabled on Skylake, due to
throttling, and the VL ymm implementation is used instead. These come
from Andy Polyakov's implementation, with the following modifications
from Samuel Neves:

  - Some cosmetic changes, like renaming labels to .Lname, constants,
    and other Linux conventions.

  - CPU feature checking is done in C by the glue code, so that has been
    removed from the assembly.

  - Eliminate translating certain instructions, such as pshufb, palignr,
    vprotd, etc, to .byte directives. This is meant for compatibility
    with ancient toolchains, but presumably it is unnecessary here,
    since the build system already does checks on what GNU as can
    assemble.

  - When aligning the stack, the original code was saving %rsp to %r9.
    To keep objtool happy, we use instead the DRAP idiom to save %rsp
    to %r10:

      leaq    8(%rsp),%r10
      ... code here ...
      leaq    -8(%r10),%rsp

  - The original code assumes the stack comes aligned to 16 bytes. This
    is not necessarily the case, and to avoid crashes,
    `andq $-alignment, %rsp` was added in the prolog of a few functions.

  - The original hardcodes returns as .byte 0xf3,0xc3, aka "rep ret".
    We replace this by "ret". "rep ret" was meant to help with AMD K8
    chips, cf. http://repzret.org/p/repzret. It makes no sense to
    continue to use this kludge for code that won't even run on ancient
    AMD chips.

Cycle counts on a Core i7 6700HQ using the AVX-2 codepath, comparing
this implementation ("new") to the implementation in the current crypto
api ("old"):

size	old	new
----	----	----
0	62	52
16	414	376
32	410	400
48	414	422
64	362	356
80	714	666
96	714	700
112	712	718
128	692	646
144	1042	674
160	1042	694
176	1042	726
192	1018	650
208	1366	686
224	1366	696
240	1366	722
256	640	656
272	988	1246
288	988	1276
304	992	1296
320	972	1222
336	1318	1256
352	1318	1276
368	1316	1294
384	1294	1218
400	1642	1258
416	1642	1282
432	1642	1302
448	1628	1224
464	1970	1258
480	1970	1280
496	1970	1300
512	656	676
528	1010	1290
544	1010	1306
560	1010	1332
576	986	1254
592	1340	1284
608	1334	1310
624	1340	1334
640	1314	1254
656	1664	1282
672	1674	1306
688	1662	1336
704	1638	1250
720	1992	1292
736	1994	1308
752	1988	1334
768	1252	1254
784	1596	1290
800	1596	1314
816	1596	1330
832	1576	1256
848	1922	1286
864	1922	1314
880	1926	1338
896	1898	1258
912	2248	1288
928	2248	1320
944	2248	1338
960	2226	1268
976	2574	1288
992	2576	1312
1008	2574	1340

Cycle counts on a Xeon Gold 5120 using the AVX-512 codepath:

size	old	new
----	----	----
0	64	54
16	386	372
32	388	396
48	388	420
64	366	350
80	708	666
96	708	692
112	706	736
128	692	648
144	1036	682
160	1036	708
176	1036	730
192	1016	658
208	1360	684
224	1362	708
240	1360	732
256	644	500
272	990	526
288	988	556
304	988	576
320	972	500
336	1314	532
352	1316	558
368	1318	578
384	1308	506
400	1644	532
416	1644	556
432	1644	594
448	1624	508
464	1970	534
480	1970	556
496	1968	582
512	660	624
528	1016	682
544	1016	702
560	1018	728
576	998	654
592	1344	680
608	1344	708
624	1344	730
640	1326	654
656	1670	686
672	1670	708
688	1670	732
704	1652	658
720	1998	682
736	1998	710
752	1996	734
768	1256	662
784	1606	688
800	1606	714
816	1606	736
832	1584	660
848	1948	688
864	1950	714
880	1948	736
896	1912	688
912	2258	718
928	2258	744
944	2256	768
960	2238	692
976	2584	718
992	2584	744
1008	2584	770

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
 lib/zinc/chacha20/chacha20-x86_64-glue.c      |  103 ++
 ...-x86_64-cryptogams.S => chacha20-x86_64.S} | 1557 ++++-------------
 lib/zinc/chacha20/chacha20.c                  |    4 +
 4 files changed, 486 insertions(+), 1179 deletions(-)
 create mode 100644 lib/zinc/chacha20/chacha20-x86_64-glue.c
 rename lib/zinc/chacha20/{chacha20-x86_64-cryptogams.S => chacha20-x86_64.S} (71%)

diff --git a/lib/zinc/Makefile b/lib/zinc/Makefile
index 3d80144d55a6..223a0816c918 100644
--- a/lib/zinc/Makefile
+++ b/lib/zinc/Makefile
@@ -3,4 +3,5 @@ ccflags-y += -D'pr_fmt(fmt)="zinc: " fmt'
 ccflags-$(CONFIG_ZINC_DEBUG) += -DDEBUG
 
 zinc_chacha20-y := chacha20/chacha20.o
+zinc_chacha20-$(CONFIG_ZINC_ARCH_X86_64) += chacha20/chacha20-x86_64.o
 obj-$(CONFIG_ZINC_CHACHA20) += zinc_chacha20.o
diff --git a/lib/zinc/chacha20/chacha20-x86_64-glue.c b/lib/zinc/chacha20/chacha20-x86_64-glue.c
new file mode 100644
index 000000000000..8629d5d420e6
--- /dev/null
+++ b/lib/zinc/chacha20/chacha20-x86_64-glue.c
@@ -0,0 +1,103 @@
+// SPDX-License-Identifier: GPL-2.0 OR MIT
+/*
+ * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#include <asm/fpu/api.h>
+#include <asm/cpufeature.h>
+#include <asm/processor.h>
+#include <asm/intel-family.h>
+
+asmlinkage void hchacha20_ssse3(u32 *derived_key, const u8 *nonce,
+				const u8 *key);
+asmlinkage void chacha20_ssse3(u8 *out, const u8 *in, const size_t len,
+			       const u32 key[8], const u32 counter[4]);
+asmlinkage void chacha20_avx2(u8 *out, const u8 *in, const size_t len,
+			      const u32 key[8], const u32 counter[4]);
+asmlinkage void chacha20_avx512(u8 *out, const u8 *in, const size_t len,
+				const u32 key[8], const u32 counter[4]);
+asmlinkage void chacha20_avx512vl(u8 *out, const u8 *in, const size_t len,
+				  const u32 key[8], const u32 counter[4]);
+
+static bool chacha20_use_ssse3 __ro_after_init;
+static bool chacha20_use_avx2 __ro_after_init;
+static bool chacha20_use_avx512 __ro_after_init;
+static bool chacha20_use_avx512vl __ro_after_init;
+static bool *const chacha20_nobs[] __initconst = {
+	&chacha20_use_ssse3, &chacha20_use_avx2, &chacha20_use_avx512,
+	&chacha20_use_avx512vl };
+
+static void __init chacha20_fpu_init(void)
+{
+	chacha20_use_ssse3 = boot_cpu_has(X86_FEATURE_SSSE3);
+	chacha20_use_avx2 =
+		boot_cpu_has(X86_FEATURE_AVX) &&
+		boot_cpu_has(X86_FEATURE_AVX2) &&
+		cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL);
+	chacha20_use_avx512 =
+		boot_cpu_has(X86_FEATURE_AVX) &&
+		boot_cpu_has(X86_FEATURE_AVX2) &&
+		boot_cpu_has(X86_FEATURE_AVX512F) &&
+		cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM |
+				  XFEATURE_MASK_AVX512, NULL) &&
+		/* Skylake downclocks unacceptably much when using zmm. */
+		boot_cpu_data.x86_model != INTEL_FAM6_SKYLAKE_X;
+	chacha20_use_avx512vl =
+		boot_cpu_has(X86_FEATURE_AVX) &&
+		boot_cpu_has(X86_FEATURE_AVX2) &&
+		boot_cpu_has(X86_FEATURE_AVX512F) &&
+		boot_cpu_has(X86_FEATURE_AVX512VL) &&
+		cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM |
+				  XFEATURE_MASK_AVX512, NULL);
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
+	if (!IS_ENABLED(CONFIG_AS_SSSE3) || !chacha20_use_ssse3 ||
+	    len <= CHACHA20_BLOCK_SIZE || !simd_use(simd_context))
+		return false;
+
+	for (;;) {
+		const size_t bytes = min_t(size_t, len, PAGE_SIZE);
+
+		if (IS_ENABLED(CONFIG_AS_AVX512) && chacha20_use_avx512 &&
+		    len >= CHACHA20_BLOCK_SIZE * 8)
+			chacha20_avx512(dst, src, bytes, ctx->key, ctx->counter);
+		else if (IS_ENABLED(CONFIG_AS_AVX512) && chacha20_use_avx512vl &&
+			 len >= CHACHA20_BLOCK_SIZE * 4)
+			chacha20_avx512vl(dst, src, bytes, ctx->key, ctx->counter);
+		else if (IS_ENABLED(CONFIG_AS_AVX2) && chacha20_use_avx2 &&
+			 len >= CHACHA20_BLOCK_SIZE * 4)
+			chacha20_avx2(dst, src, bytes, ctx->key, ctx->counter);
+		else
+			chacha20_ssse3(dst, src, bytes, ctx->key, ctx->counter);
+		ctx->counter[0] += (bytes + 63) / 64;
+		len -= bytes;
+		if (!len)
+			break;
+		dst += bytes;
+		src += bytes;
+		simd_relax(simd_context);
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
+	if (IS_ENABLED(CONFIG_AS_SSSE3) && chacha20_use_ssse3 &&
+	    simd_use(simd_context)) {
+		hchacha20_ssse3(derived_key, nonce, key);
+		return true;
+	}
+	return false;
+}
diff --git a/lib/zinc/chacha20/chacha20-x86_64-cryptogams.S b/lib/zinc/chacha20/chacha20-x86_64.S
similarity index 71%
rename from lib/zinc/chacha20/chacha20-x86_64-cryptogams.S
rename to lib/zinc/chacha20/chacha20-x86_64.S
index 2bfc76f7e01f..3d10c7f21642 100644
--- a/lib/zinc/chacha20/chacha20-x86_64-cryptogams.S
+++ b/lib/zinc/chacha20/chacha20-x86_64.S
@@ -1,351 +1,148 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
+ * Copyright (C) 2017 Samuel Neves <sneves@dei.uc.pt>. All Rights Reserved.
+ * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  * Copyright (C) 2006-2017 CRYPTOGAMS by <appro@openssl.org>. All Rights Reserved.
+ *
+ * This is based in part on Andy Polyakov's implementation from CRYPTOGAMS.
  */
 
-.text	
+#include <linux/linkage.h>
 
-
-
-.align	64
+.section .rodata.cst16.Lzero, "aM", @progbits, 16
+.align	16
 .Lzero:
 .long	0,0,0,0
+.section .rodata.cst16.Lone, "aM", @progbits, 16
+.align	16
 .Lone:
 .long	1,0,0,0
+.section .rodata.cst16.Linc, "aM", @progbits, 16
+.align	16
 .Linc:
 .long	0,1,2,3
+.section .rodata.cst16.Lfour, "aM", @progbits, 16
+.align	16
 .Lfour:
 .long	4,4,4,4
+.section .rodata.cst32.Lincy, "aM", @progbits, 32
+.align	32
 .Lincy:
 .long	0,2,4,6,1,3,5,7
+.section .rodata.cst32.Leight, "aM", @progbits, 32
+.align	32
 .Leight:
 .long	8,8,8,8,8,8,8,8
+.section .rodata.cst16.Lrot16, "aM", @progbits, 16
+.align	16
 .Lrot16:
 .byte	0x2,0x3,0x0,0x1, 0x6,0x7,0x4,0x5, 0xa,0xb,0x8,0x9, 0xe,0xf,0xc,0xd
+.section .rodata.cst16.Lrot24, "aM", @progbits, 16
+.align	16
 .Lrot24:
 .byte	0x3,0x0,0x1,0x2, 0x7,0x4,0x5,0x6, 0xb,0x8,0x9,0xa, 0xf,0xc,0xd,0xe
-.Ltwoy:
-.long	2,0,0,0, 2,0,0,0
+.section .rodata.cst16.Lsigma, "aM", @progbits, 16
+.align	16
+.Lsigma:
+.byte	101,120,112,97,110,100,32,51,50,45,98,121,116,101,32,107,0
+.section .rodata.cst64.Lzeroz, "aM", @progbits, 64
 .align	64
 .Lzeroz:
 .long	0,0,0,0, 1,0,0,0, 2,0,0,0, 3,0,0,0
+.section .rodata.cst64.Lfourz, "aM", @progbits, 64
+.align	64
 .Lfourz:
 .long	4,0,0,0, 4,0,0,0, 4,0,0,0, 4,0,0,0
+.section .rodata.cst64.Lincz, "aM", @progbits, 64
+.align	64
 .Lincz:
 .long	0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+.section .rodata.cst64.Lsixteen, "aM", @progbits, 64
+.align	64
 .Lsixteen:
 .long	16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16
-.Lsigma:
-.byte	101,120,112,97,110,100,32,51,50,45,98,121,116,101,32,107,0
-.byte	67,104,97,67,104,97,50,48,32,102,111,114,32,120,56,54,95,54,52,44,32,67,82,89,80,84,79,71,65,77,83,32,98,121,32,60,97,112,112,114,111,64,111,112,101,110,115,115,108,46,111,114,103,62,0
-.globl	ChaCha20_ctr32
-.type	ChaCha20_ctr32,@function
+.section .rodata.cst32.Ltwoy, "aM", @progbits, 32
 .align	64
-ChaCha20_ctr32:
-.cfi_startproc	
-	cmpq	$0,%rdx
-	je	.Lno_data
-	movq	OPENSSL_ia32cap_P+4(%rip),%r10
-	btq	$48,%r10
-	jc	.LChaCha20_avx512
-	testq	%r10,%r10
-	js	.LChaCha20_avx512vl
-	testl	$512,%r10d
-	jnz	.LChaCha20_ssse3
-
-	pushq	%rbx
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%rbx,-16
-	pushq	%rbp
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%rbp,-24
-	pushq	%r12
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r12,-32
-	pushq	%r13
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r13,-40
-	pushq	%r14
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r14,-48
-	pushq	%r15
-.cfi_adjust_cfa_offset	8
-.cfi_offset	%r15,-56
-	subq	$64+24,%rsp
-.cfi_adjust_cfa_offset	64+24
-.Lctr32_body:
-
-
-	movdqu	(%rcx),%xmm1
-	movdqu	16(%rcx),%xmm2
-	movdqu	(%r8),%xmm3
-	movdqa	.Lone(%rip),%xmm4
-
+.Ltwoy:
+.long	2,0,0,0, 2,0,0,0
 
-	movdqa	%xmm1,16(%rsp)
-	movdqa	%xmm2,32(%rsp)
-	movdqa	%xmm3,48(%rsp)
-	movq	%rdx,%rbp
-	jmp	.Loop_outer
+.text
 
+#ifdef CONFIG_AS_SSSE3
 .align	32
-.Loop_outer:
-	movl	$0x61707865,%eax
-	movl	$0x3320646e,%ebx
-	movl	$0x79622d32,%ecx
-	movl	$0x6b206574,%edx
-	movl	16(%rsp),%r8d
-	movl	20(%rsp),%r9d
-	movl	24(%rsp),%r10d
-	movl	28(%rsp),%r11d
-	movd	%xmm3,%r12d
-	movl	52(%rsp),%r13d
-	movl	56(%rsp),%r14d
-	movl	60(%rsp),%r15d
-
-	movq	%rbp,64+0(%rsp)
-	movl	$10,%ebp
-	movq	%rsi,64+8(%rsp)
-.byte	102,72,15,126,214
-	movq	%rdi,64+16(%rsp)
-	movq	%rsi,%rdi
-	shrq	$32,%rdi
-	jmp	.Loop
+ENTRY(hchacha20_ssse3)
+	movdqa	.Lsigma(%rip),%xmm0
+	movdqu	(%rdx),%xmm1
+	movdqu	16(%rdx),%xmm2
+	movdqu	(%rsi),%xmm3
+	movdqa	.Lrot16(%rip),%xmm6
+	movdqa	.Lrot24(%rip),%xmm7
+	movq	$10,%r8
+	.align	32
+.Loop_hssse3:
+	paddd	%xmm1,%xmm0
+	pxor	%xmm0,%xmm3
+	pshufb	%xmm6,%xmm3
+	paddd	%xmm3,%xmm2
+	pxor	%xmm2,%xmm1
+	movdqa	%xmm1,%xmm4
+	psrld	$20,%xmm1
+	pslld	$12,%xmm4
+	por	%xmm4,%xmm1
+	paddd	%xmm1,%xmm0
+	pxor	%xmm0,%xmm3
+	pshufb	%xmm7,%xmm3
+	paddd	%xmm3,%xmm2
+	pxor	%xmm2,%xmm1
+	movdqa	%xmm1,%xmm4
+	psrld	$25,%xmm1
+	pslld	$7,%xmm4
+	por	%xmm4,%xmm1
+	pshufd	$78,%xmm2,%xmm2
+	pshufd	$57,%xmm1,%xmm1
+	pshufd	$147,%xmm3,%xmm3
+	nop
+	paddd	%xmm1,%xmm0
+	pxor	%xmm0,%xmm3
+	pshufb	%xmm6,%xmm3
+	paddd	%xmm3,%xmm2
+	pxor	%xmm2,%xmm1
+	movdqa	%xmm1,%xmm4
+	psrld	$20,%xmm1
+	pslld	$12,%xmm4
+	por	%xmm4,%xmm1
+	paddd	%xmm1,%xmm0
+	pxor	%xmm0,%xmm3
+	pshufb	%xmm7,%xmm3
+	paddd	%xmm3,%xmm2
+	pxor	%xmm2,%xmm1
+	movdqa	%xmm1,%xmm4
+	psrld	$25,%xmm1
+	pslld	$7,%xmm4
+	por	%xmm4,%xmm1
+	pshufd	$78,%xmm2,%xmm2
+	pshufd	$147,%xmm1,%xmm1
+	pshufd	$57,%xmm3,%xmm3
+	decq	%r8
+	jnz	.Loop_hssse3
+	movdqu	%xmm0,0(%rdi)
+	movdqu	%xmm3,16(%rdi)
+	ret
+ENDPROC(hchacha20_ssse3)
 
 .align	32
-.Loop:
-	addl	%r8d,%eax
-	xorl	%eax,%r12d
-	roll	$16,%r12d
-	addl	%r9d,%ebx
-	xorl	%ebx,%r13d
-	roll	$16,%r13d
-	addl	%r12d,%esi
-	xorl	%esi,%r8d
-	roll	$12,%r8d
-	addl	%r13d,%edi
-	xorl	%edi,%r9d
-	roll	$12,%r9d
-	addl	%r8d,%eax
-	xorl	%eax,%r12d
-	roll	$8,%r12d
-	addl	%r9d,%ebx
-	xorl	%ebx,%r13d
-	roll	$8,%r13d
-	addl	%r12d,%esi
-	xorl	%esi,%r8d
-	roll	$7,%r8d
-	addl	%r13d,%edi
-	xorl	%edi,%r9d
-	roll	$7,%r9d
-	movl	%esi,32(%rsp)
-	movl	%edi,36(%rsp)
-	movl	40(%rsp),%esi
-	movl	44(%rsp),%edi
-	addl	%r10d,%ecx
-	xorl	%ecx,%r14d
-	roll	$16,%r14d
-	addl	%r11d,%edx
-	xorl	%edx,%r15d
-	roll	$16,%r15d
-	addl	%r14d,%esi
-	xorl	%esi,%r10d
-	roll	$12,%r10d
-	addl	%r15d,%edi
-	xorl	%edi,%r11d
-	roll	$12,%r11d
-	addl	%r10d,%ecx
-	xorl	%ecx,%r14d
-	roll	$8,%r14d
-	addl	%r11d,%edx
-	xorl	%edx,%r15d
-	roll	$8,%r15d
-	addl	%r14d,%esi
-	xorl	%esi,%r10d
-	roll	$7,%r10d
-	addl	%r15d,%edi
-	xorl	%edi,%r11d
-	roll	$7,%r11d
-	addl	%r9d,%eax
-	xorl	%eax,%r15d
-	roll	$16,%r15d
-	addl	%r10d,%ebx
-	xorl	%ebx,%r12d
-	roll	$16,%r12d
-	addl	%r15d,%esi
-	xorl	%esi,%r9d
-	roll	$12,%r9d
-	addl	%r12d,%edi
-	xorl	%edi,%r10d
-	roll	$12,%r10d
-	addl	%r9d,%eax
-	xorl	%eax,%r15d
-	roll	$8,%r15d
-	addl	%r10d,%ebx
-	xorl	%ebx,%r12d
-	roll	$8,%r12d
-	addl	%r15d,%esi
-	xorl	%esi,%r9d
-	roll	$7,%r9d
-	addl	%r12d,%edi
-	xorl	%edi,%r10d
-	roll	$7,%r10d
-	movl	%esi,40(%rsp)
-	movl	%edi,44(%rsp)
-	movl	32(%rsp),%esi
-	movl	36(%rsp),%edi
-	addl	%r11d,%ecx
-	xorl	%ecx,%r13d
-	roll	$16,%r13d
-	addl	%r8d,%edx
-	xorl	%edx,%r14d
-	roll	$16,%r14d
-	addl	%r13d,%esi
-	xorl	%esi,%r11d
-	roll	$12,%r11d
-	addl	%r14d,%edi
-	xorl	%edi,%r8d
-	roll	$12,%r8d
-	addl	%r11d,%ecx
-	xorl	%ecx,%r13d
-	roll	$8,%r13d
-	addl	%r8d,%edx
-	xorl	%edx,%r14d
-	roll	$8,%r14d
-	addl	%r13d,%esi
-	xorl	%esi,%r11d
-	roll	$7,%r11d
-	addl	%r14d,%edi
-	xorl	%edi,%r8d
-	roll	$7,%r8d
-	decl	%ebp
-	jnz	.Loop
-	movl	%edi,36(%rsp)
-	movl	%esi,32(%rsp)
-	movq	64(%rsp),%rbp
-	movdqa	%xmm2,%xmm1
-	movq	64+8(%rsp),%rsi
-	paddd	%xmm4,%xmm3
-	movq	64+16(%rsp),%rdi
-
-	addl	$0x61707865,%eax
-	addl	$0x3320646e,%ebx
-	addl	$0x79622d32,%ecx
-	addl	$0x6b206574,%edx
-	addl	16(%rsp),%r8d
-	addl	20(%rsp),%r9d
-	addl	24(%rsp),%r10d
-	addl	28(%rsp),%r11d
-	addl	48(%rsp),%r12d
-	addl	52(%rsp),%r13d
-	addl	56(%rsp),%r14d
-	addl	60(%rsp),%r15d
-	paddd	32(%rsp),%xmm1
-
-	cmpq	$64,%rbp
-	jb	.Ltail
-
-	xorl	0(%rsi),%eax
-	xorl	4(%rsi),%ebx
-	xorl	8(%rsi),%ecx
-	xorl	12(%rsi),%edx
-	xorl	16(%rsi),%r8d
-	xorl	20(%rsi),%r9d
-	xorl	24(%rsi),%r10d
-	xorl	28(%rsi),%r11d
-	movdqu	32(%rsi),%xmm0
-	xorl	48(%rsi),%r12d
-	xorl	52(%rsi),%r13d
-	xorl	56(%rsi),%r14d
-	xorl	60(%rsi),%r15d
-	leaq	64(%rsi),%rsi
-	pxor	%xmm1,%xmm0
-
-	movdqa	%xmm2,32(%rsp)
-	movd	%xmm3,48(%rsp)
-
-	movl	%eax,0(%rdi)
-	movl	%ebx,4(%rdi)
-	movl	%ecx,8(%rdi)
-	movl	%edx,12(%rdi)
-	movl	%r8d,16(%rdi)
-	movl	%r9d,20(%rdi)
-	movl	%r10d,24(%rdi)
-	movl	%r11d,28(%rdi)
-	movdqu	%xmm0,32(%rdi)
-	movl	%r12d,48(%rdi)
-	movl	%r13d,52(%rdi)
-	movl	%r14d,56(%rdi)
-	movl	%r15d,60(%rdi)
-	leaq	64(%rdi),%rdi
-
-	subq	$64,%rbp
-	jnz	.Loop_outer
-
-	jmp	.Ldone
+ENTRY(chacha20_ssse3)
+.Lchacha20_ssse3:
+	cmpq	$0,%rdx
+	je	.Lssse3_epilogue
+	leaq	8(%rsp),%r10
 
-.align	16
-.Ltail:
-	movl	%eax,0(%rsp)
-	movl	%ebx,4(%rsp)
-	xorq	%rbx,%rbx
-	movl	%ecx,8(%rsp)
-	movl	%edx,12(%rsp)
-	movl	%r8d,16(%rsp)
-	movl	%r9d,20(%rsp)
-	movl	%r10d,24(%rsp)
-	movl	%r11d,28(%rsp)
-	movdqa	%xmm1,32(%rsp)
-	movl	%r12d,48(%rsp)
-	movl	%r13d,52(%rsp)
-	movl	%r14d,56(%rsp)
-	movl	%r15d,60(%rsp)
-
-.Loop_tail:
-	movzbl	(%rsi,%rbx,1),%eax
-	movzbl	(%rsp,%rbx,1),%edx
-	leaq	1(%rbx),%rbx
-	xorl	%edx,%eax
-	movb	%al,-1(%rdi,%rbx,1)
-	decq	%rbp
-	jnz	.Loop_tail
-
-.Ldone:
-	leaq	64+24+48(%rsp),%rsi
-.cfi_def_cfa	%rsi,8
-	movq	-48(%rsi),%r15
-.cfi_restore	%r15
-	movq	-40(%rsi),%r14
-.cfi_restore	%r14
-	movq	-32(%rsi),%r13
-.cfi_restore	%r13
-	movq	-24(%rsi),%r12
-.cfi_restore	%r12
-	movq	-16(%rsi),%rbp
-.cfi_restore	%rbp
-	movq	-8(%rsi),%rbx
-.cfi_restore	%rbx
-	leaq	(%rsi),%rsp
-.cfi_def_cfa_register	%rsp
-.Lno_data:
-	.byte	0xf3,0xc3
-.cfi_endproc	
-.size	ChaCha20_ctr32,.-ChaCha20_ctr32
-.type	ChaCha20_ssse3,@function
-.align	32
-ChaCha20_ssse3:
-.cfi_startproc	
-.LChaCha20_ssse3:
-	movq	%rsp,%r9
-.cfi_def_cfa_register	%r9
-	testl	$2048,%r10d
-	jnz	.LChaCha20_4xop
 	cmpq	$128,%rdx
-	je	.LChaCha20_128
-	ja	.LChaCha20_4x
+	ja	.Lchacha20_4x
 
 .Ldo_sse3_after_all:
 	subq	$64+8,%rsp
+	andq	$-32,%rsp
 	movdqa	.Lsigma(%rip),%xmm0
 	movdqu	(%rcx),%xmm1
 	movdqu	16(%rcx),%xmm2
@@ -375,7 +172,7 @@ ChaCha20_ssse3:
 .Loop_ssse3:
 	paddd	%xmm1,%xmm0
 	pxor	%xmm0,%xmm3
-.byte	102,15,56,0,222
+	pshufb	%xmm6,%xmm3
 	paddd	%xmm3,%xmm2
 	pxor	%xmm2,%xmm1
 	movdqa	%xmm1,%xmm4
@@ -384,7 +181,7 @@ ChaCha20_ssse3:
 	por	%xmm4,%xmm1
 	paddd	%xmm1,%xmm0
 	pxor	%xmm0,%xmm3
-.byte	102,15,56,0,223
+	pshufb	%xmm7,%xmm3
 	paddd	%xmm3,%xmm2
 	pxor	%xmm2,%xmm1
 	movdqa	%xmm1,%xmm4
@@ -397,7 +194,7 @@ ChaCha20_ssse3:
 	nop
 	paddd	%xmm1,%xmm0
 	pxor	%xmm0,%xmm3
-.byte	102,15,56,0,222
+	pshufb	%xmm6,%xmm3
 	paddd	%xmm3,%xmm2
 	pxor	%xmm2,%xmm1
 	movdqa	%xmm1,%xmm4
@@ -406,7 +203,7 @@ ChaCha20_ssse3:
 	por	%xmm4,%xmm1
 	paddd	%xmm1,%xmm0
 	pxor	%xmm0,%xmm3
-.byte	102,15,56,0,223
+	pshufb	%xmm7,%xmm3
 	paddd	%xmm3,%xmm2
 	pxor	%xmm2,%xmm1
 	movdqa	%xmm1,%xmm4
@@ -465,194 +262,24 @@ ChaCha20_ssse3:
 	jnz	.Loop_tail_ssse3
 
 .Ldone_ssse3:
-	leaq	(%r9),%rsp
-.cfi_def_cfa_register	%rsp
-.Lssse3_epilogue:
-	.byte	0xf3,0xc3
-.cfi_endproc	
-.size	ChaCha20_ssse3,.-ChaCha20_ssse3
-.type	ChaCha20_128,@function
-.align	32
-ChaCha20_128:
-.cfi_startproc	
-.LChaCha20_128:
-	movq	%rsp,%r9
-.cfi_def_cfa_register	%r9
-	subq	$64+8,%rsp
-	movdqa	.Lsigma(%rip),%xmm8
-	movdqu	(%rcx),%xmm9
-	movdqu	16(%rcx),%xmm2
-	movdqu	(%r8),%xmm3
-	movdqa	.Lone(%rip),%xmm1
-	movdqa	.Lrot16(%rip),%xmm6
-	movdqa	.Lrot24(%rip),%xmm7
+	leaq	-8(%r10),%rsp
 
-	movdqa	%xmm8,%xmm10
-	movdqa	%xmm8,0(%rsp)
-	movdqa	%xmm9,%xmm11
-	movdqa	%xmm9,16(%rsp)
-	movdqa	%xmm2,%xmm0
-	movdqa	%xmm2,32(%rsp)
-	paddd	%xmm3,%xmm1
-	movdqa	%xmm3,48(%rsp)
-	movq	$10,%r8
-	jmp	.Loop_128
-
-.align	32
-.Loop_128:
-	paddd	%xmm9,%xmm8
-	pxor	%xmm8,%xmm3
-	paddd	%xmm11,%xmm10
-	pxor	%xmm10,%xmm1
-.byte	102,15,56,0,222
-.byte	102,15,56,0,206
-	paddd	%xmm3,%xmm2
-	paddd	%xmm1,%xmm0
-	pxor	%xmm2,%xmm9
-	pxor	%xmm0,%xmm11
-	movdqa	%xmm9,%xmm4
-	psrld	$20,%xmm9
-	movdqa	%xmm11,%xmm5
-	pslld	$12,%xmm4
-	psrld	$20,%xmm11
-	por	%xmm4,%xmm9
-	pslld	$12,%xmm5
-	por	%xmm5,%xmm11
-	paddd	%xmm9,%xmm8
-	pxor	%xmm8,%xmm3
-	paddd	%xmm11,%xmm10
-	pxor	%xmm10,%xmm1
-.byte	102,15,56,0,223
-.byte	102,15,56,0,207
-	paddd	%xmm3,%xmm2
-	paddd	%xmm1,%xmm0
-	pxor	%xmm2,%xmm9
-	pxor	%xmm0,%xmm11
-	movdqa	%xmm9,%xmm4
-	psrld	$25,%xmm9
-	movdqa	%xmm11,%xmm5
-	pslld	$7,%xmm4
-	psrld	$25,%xmm11
-	por	%xmm4,%xmm9
-	pslld	$7,%xmm5
-	por	%xmm5,%xmm11
-	pshufd	$78,%xmm2,%xmm2
-	pshufd	$57,%xmm9,%xmm9
-	pshufd	$147,%xmm3,%xmm3
-	pshufd	$78,%xmm0,%xmm0
-	pshufd	$57,%xmm11,%xmm11
-	pshufd	$147,%xmm1,%xmm1
-	paddd	%xmm9,%xmm8
-	pxor	%xmm8,%xmm3
-	paddd	%xmm11,%xmm10
-	pxor	%xmm10,%xmm1
-.byte	102,15,56,0,222
-.byte	102,15,56,0,206
-	paddd	%xmm3,%xmm2
-	paddd	%xmm1,%xmm0
-	pxor	%xmm2,%xmm9
-	pxor	%xmm0,%xmm11
-	movdqa	%xmm9,%xmm4
-	psrld	$20,%xmm9
-	movdqa	%xmm11,%xmm5
-	pslld	$12,%xmm4
-	psrld	$20,%xmm11
-	por	%xmm4,%xmm9
-	pslld	$12,%xmm5
-	por	%xmm5,%xmm11
-	paddd	%xmm9,%xmm8
-	pxor	%xmm8,%xmm3
-	paddd	%xmm11,%xmm10
-	pxor	%xmm10,%xmm1
-.byte	102,15,56,0,223
-.byte	102,15,56,0,207
-	paddd	%xmm3,%xmm2
-	paddd	%xmm1,%xmm0
-	pxor	%xmm2,%xmm9
-	pxor	%xmm0,%xmm11
-	movdqa	%xmm9,%xmm4
-	psrld	$25,%xmm9
-	movdqa	%xmm11,%xmm5
-	pslld	$7,%xmm4
-	psrld	$25,%xmm11
-	por	%xmm4,%xmm9
-	pslld	$7,%xmm5
-	por	%xmm5,%xmm11
-	pshufd	$78,%xmm2,%xmm2
-	pshufd	$147,%xmm9,%xmm9
-	pshufd	$57,%xmm3,%xmm3
-	pshufd	$78,%xmm0,%xmm0
-	pshufd	$147,%xmm11,%xmm11
-	pshufd	$57,%xmm1,%xmm1
-	decq	%r8
-	jnz	.Loop_128
-	paddd	0(%rsp),%xmm8
-	paddd	16(%rsp),%xmm9
-	paddd	32(%rsp),%xmm2
-	paddd	48(%rsp),%xmm3
-	paddd	.Lone(%rip),%xmm1
-	paddd	0(%rsp),%xmm10
-	paddd	16(%rsp),%xmm11
-	paddd	32(%rsp),%xmm0
-	paddd	48(%rsp),%xmm1
-
-	movdqu	0(%rsi),%xmm4
-	movdqu	16(%rsi),%xmm5
-	pxor	%xmm4,%xmm8
-	movdqu	32(%rsi),%xmm4
-	pxor	%xmm5,%xmm9
-	movdqu	48(%rsi),%xmm5
-	pxor	%xmm4,%xmm2
-	movdqu	64(%rsi),%xmm4
-	pxor	%xmm5,%xmm3
-	movdqu	80(%rsi),%xmm5
-	pxor	%xmm4,%xmm10
-	movdqu	96(%rsi),%xmm4
-	pxor	%xmm5,%xmm11
-	movdqu	112(%rsi),%xmm5
-	pxor	%xmm4,%xmm0
-	pxor	%xmm5,%xmm1
+.Lssse3_epilogue:
+	ret
 
-	movdqu	%xmm8,0(%rdi)
-	movdqu	%xmm9,16(%rdi)
-	movdqu	%xmm2,32(%rdi)
-	movdqu	%xmm3,48(%rdi)
-	movdqu	%xmm10,64(%rdi)
-	movdqu	%xmm11,80(%rdi)
-	movdqu	%xmm0,96(%rdi)
-	movdqu	%xmm1,112(%rdi)
-	leaq	(%r9),%rsp
-.cfi_def_cfa_register	%rsp
-.L128_epilogue:
-	.byte	0xf3,0xc3
-.cfi_endproc	
-.size	ChaCha20_128,.-ChaCha20_128
-.type	ChaCha20_4x,@function
 .align	32
-ChaCha20_4x:
-.cfi_startproc	
-.LChaCha20_4x:
-	movq	%rsp,%r9
-.cfi_def_cfa_register	%r9
-	movq	%r10,%r11
-	shrq	$32,%r10
-	testq	$32,%r10
-	jnz	.LChaCha20_8x
-	cmpq	$192,%rdx
-	ja	.Lproceed4x
-
-	andq	$71303168,%r11
-	cmpq	$4194304,%r11
-	je	.Ldo_sse3_after_all
+.Lchacha20_4x:
+	leaq	8(%rsp),%r10
 
 .Lproceed4x:
 	subq	$0x140+8,%rsp
+	andq	$-32,%rsp
 	movdqa	.Lsigma(%rip),%xmm11
 	movdqu	(%rcx),%xmm15
 	movdqu	16(%rcx),%xmm7
 	movdqu	(%r8),%xmm3
 	leaq	256(%rsp),%rcx
-	leaq	.Lrot16(%rip),%r10
+	leaq	.Lrot16(%rip),%r9
 	leaq	.Lrot24(%rip),%r11
 
 	pshufd	$0x00,%xmm11,%xmm8
@@ -716,7 +343,7 @@ ChaCha20_4x:
 .Loop_enter4x:
 	movdqa	%xmm6,32(%rsp)
 	movdqa	%xmm7,48(%rsp)
-	movdqa	(%r10),%xmm7
+	movdqa	(%r9),%xmm7
 	movl	$10,%eax
 	movdqa	%xmm0,256-256(%rcx)
 	jmp	.Loop4x
@@ -727,8 +354,8 @@ ChaCha20_4x:
 	paddd	%xmm13,%xmm9
 	pxor	%xmm8,%xmm0
 	pxor	%xmm9,%xmm1
-.byte	102,15,56,0,199
-.byte	102,15,56,0,207
+	pshufb	%xmm7,%xmm0
+	pshufb	%xmm7,%xmm1
 	paddd	%xmm0,%xmm4
 	paddd	%xmm1,%xmm5
 	pxor	%xmm4,%xmm12
@@ -746,8 +373,8 @@ ChaCha20_4x:
 	paddd	%xmm13,%xmm9
 	pxor	%xmm8,%xmm0
 	pxor	%xmm9,%xmm1
-.byte	102,15,56,0,198
-.byte	102,15,56,0,206
+	pshufb	%xmm6,%xmm0
+	pshufb	%xmm6,%xmm1
 	paddd	%xmm0,%xmm4
 	paddd	%xmm1,%xmm5
 	pxor	%xmm4,%xmm12
@@ -759,7 +386,7 @@ ChaCha20_4x:
 	pslld	$7,%xmm13
 	por	%xmm7,%xmm12
 	psrld	$25,%xmm6
-	movdqa	(%r10),%xmm7
+	movdqa	(%r9),%xmm7
 	por	%xmm6,%xmm13
 	movdqa	%xmm4,0(%rsp)
 	movdqa	%xmm5,16(%rsp)
@@ -769,8 +396,8 @@ ChaCha20_4x:
 	paddd	%xmm15,%xmm11
 	pxor	%xmm10,%xmm2
 	pxor	%xmm11,%xmm3
-.byte	102,15,56,0,215
-.byte	102,15,56,0,223
+	pshufb	%xmm7,%xmm2
+	pshufb	%xmm7,%xmm3
 	paddd	%xmm2,%xmm4
 	paddd	%xmm3,%xmm5
 	pxor	%xmm4,%xmm14
@@ -788,8 +415,8 @@ ChaCha20_4x:
 	paddd	%xmm15,%xmm11
 	pxor	%xmm10,%xmm2
 	pxor	%xmm11,%xmm3
-.byte	102,15,56,0,214
-.byte	102,15,56,0,222
+	pshufb	%xmm6,%xmm2
+	pshufb	%xmm6,%xmm3
 	paddd	%xmm2,%xmm4
 	paddd	%xmm3,%xmm5
 	pxor	%xmm4,%xmm14
@@ -801,14 +428,14 @@ ChaCha20_4x:
 	pslld	$7,%xmm15
 	por	%xmm7,%xmm14
 	psrld	$25,%xmm6
-	movdqa	(%r10),%xmm7
+	movdqa	(%r9),%xmm7
 	por	%xmm6,%xmm15
 	paddd	%xmm13,%xmm8
 	paddd	%xmm14,%xmm9
 	pxor	%xmm8,%xmm3
 	pxor	%xmm9,%xmm0
-.byte	102,15,56,0,223
-.byte	102,15,56,0,199
+	pshufb	%xmm7,%xmm3
+	pshufb	%xmm7,%xmm0
 	paddd	%xmm3,%xmm4
 	paddd	%xmm0,%xmm5
 	pxor	%xmm4,%xmm13
@@ -826,8 +453,8 @@ ChaCha20_4x:
 	paddd	%xmm14,%xmm9
 	pxor	%xmm8,%xmm3
 	pxor	%xmm9,%xmm0
-.byte	102,15,56,0,222
-.byte	102,15,56,0,198
+	pshufb	%xmm6,%xmm3
+	pshufb	%xmm6,%xmm0
 	paddd	%xmm3,%xmm4
 	paddd	%xmm0,%xmm5
 	pxor	%xmm4,%xmm13
@@ -839,7 +466,7 @@ ChaCha20_4x:
 	pslld	$7,%xmm14
 	por	%xmm7,%xmm13
 	psrld	$25,%xmm6
-	movdqa	(%r10),%xmm7
+	movdqa	(%r9),%xmm7
 	por	%xmm6,%xmm14
 	movdqa	%xmm4,32(%rsp)
 	movdqa	%xmm5,48(%rsp)
@@ -849,8 +476,8 @@ ChaCha20_4x:
 	paddd	%xmm12,%xmm11
 	pxor	%xmm10,%xmm1
 	pxor	%xmm11,%xmm2
-.byte	102,15,56,0,207
-.byte	102,15,56,0,215
+	pshufb	%xmm7,%xmm1
+	pshufb	%xmm7,%xmm2
 	paddd	%xmm1,%xmm4
 	paddd	%xmm2,%xmm5
 	pxor	%xmm4,%xmm15
@@ -868,8 +495,8 @@ ChaCha20_4x:
 	paddd	%xmm12,%xmm11
 	pxor	%xmm10,%xmm1
 	pxor	%xmm11,%xmm2
-.byte	102,15,56,0,206
-.byte	102,15,56,0,214
+	pshufb	%xmm6,%xmm1
+	pshufb	%xmm6,%xmm2
 	paddd	%xmm1,%xmm4
 	paddd	%xmm2,%xmm5
 	pxor	%xmm4,%xmm15
@@ -881,7 +508,7 @@ ChaCha20_4x:
 	pslld	$7,%xmm12
 	por	%xmm7,%xmm15
 	psrld	$25,%xmm6
-	movdqa	(%r10),%xmm7
+	movdqa	(%r9),%xmm7
 	por	%xmm6,%xmm12
 	decl	%eax
 	jnz	.Loop4x
@@ -1035,7 +662,7 @@ ChaCha20_4x:
 	jae	.L64_or_more4x
 
 
-	xorq	%r10,%r10
+	xorq	%r9,%r9
 
 	movdqa	%xmm12,16(%rsp)
 	movdqa	%xmm4,32(%rsp)
@@ -1060,7 +687,7 @@ ChaCha20_4x:
 
 	movdqa	16(%rsp),%xmm6
 	leaq	64(%rsi),%rsi
-	xorq	%r10,%r10
+	xorq	%r9,%r9
 	movdqa	%xmm6,0(%rsp)
 	movdqa	%xmm13,16(%rsp)
 	leaq	64(%rdi),%rdi
@@ -1100,7 +727,7 @@ ChaCha20_4x:
 
 	movdqa	32(%rsp),%xmm6
 	leaq	128(%rsi),%rsi
-	xorq	%r10,%r10
+	xorq	%r9,%r9
 	movdqa	%xmm6,0(%rsp)
 	movdqa	%xmm10,16(%rsp)
 	leaq	128(%rdi),%rdi
@@ -1155,7 +782,7 @@ ChaCha20_4x:
 
 	movdqa	48(%rsp),%xmm6
 	leaq	64(%rsi),%rsi
-	xorq	%r10,%r10
+	xorq	%r9,%r9
 	movdqa	%xmm6,0(%rsp)
 	movdqa	%xmm15,16(%rsp)
 	leaq	64(%rdi),%rdi
@@ -1164,463 +791,41 @@ ChaCha20_4x:
 	movdqa	%xmm3,48(%rsp)
 
 .Loop_tail4x:
-	movzbl	(%rsi,%r10,1),%eax
-	movzbl	(%rsp,%r10,1),%ecx
-	leaq	1(%r10),%r10
+	movzbl	(%rsi,%r9,1),%eax
+	movzbl	(%rsp,%r9,1),%ecx
+	leaq	1(%r9),%r9
 	xorl	%ecx,%eax
-	movb	%al,-1(%rdi,%r10,1)
+	movb	%al,-1(%rdi,%r9,1)
 	decq	%rdx
 	jnz	.Loop_tail4x
 
 .Ldone4x:
-	leaq	(%r9),%rsp
-.cfi_def_cfa_register	%rsp
-.L4x_epilogue:
-	.byte	0xf3,0xc3
-.cfi_endproc	
-.size	ChaCha20_4x,.-ChaCha20_4x
-.type	ChaCha20_4xop,@function
-.align	32
-ChaCha20_4xop:
-.cfi_startproc	
-.LChaCha20_4xop:
-	movq	%rsp,%r9
-.cfi_def_cfa_register	%r9
-	subq	$0x140+8,%rsp
-	vzeroupper
+	leaq	-8(%r10),%rsp
 
-	vmovdqa	.Lsigma(%rip),%xmm11
-	vmovdqu	(%rcx),%xmm3
-	vmovdqu	16(%rcx),%xmm15
-	vmovdqu	(%r8),%xmm7
-	leaq	256(%rsp),%rcx
-
-	vpshufd	$0x00,%xmm11,%xmm8
-	vpshufd	$0x55,%xmm11,%xmm9
-	vmovdqa	%xmm8,64(%rsp)
-	vpshufd	$0xaa,%xmm11,%xmm10
-	vmovdqa	%xmm9,80(%rsp)
-	vpshufd	$0xff,%xmm11,%xmm11
-	vmovdqa	%xmm10,96(%rsp)
-	vmovdqa	%xmm11,112(%rsp)
-
-	vpshufd	$0x00,%xmm3,%xmm0
-	vpshufd	$0x55,%xmm3,%xmm1
-	vmovdqa	%xmm0,128-256(%rcx)
-	vpshufd	$0xaa,%xmm3,%xmm2
-	vmovdqa	%xmm1,144-256(%rcx)
-	vpshufd	$0xff,%xmm3,%xmm3
-	vmovdqa	%xmm2,160-256(%rcx)
-	vmovdqa	%xmm3,176-256(%rcx)
-
-	vpshufd	$0x00,%xmm15,%xmm12
-	vpshufd	$0x55,%xmm15,%xmm13
-	vmovdqa	%xmm12,192-256(%rcx)
-	vpshufd	$0xaa,%xmm15,%xmm14
-	vmovdqa	%xmm13,208-256(%rcx)
-	vpshufd	$0xff,%xmm15,%xmm15
-	vmovdqa	%xmm14,224-256(%rcx)
-	vmovdqa	%xmm15,240-256(%rcx)
-
-	vpshufd	$0x00,%xmm7,%xmm4
-	vpshufd	$0x55,%xmm7,%xmm5
-	vpaddd	.Linc(%rip),%xmm4,%xmm4
-	vpshufd	$0xaa,%xmm7,%xmm6
-	vmovdqa	%xmm5,272-256(%rcx)
-	vpshufd	$0xff,%xmm7,%xmm7
-	vmovdqa	%xmm6,288-256(%rcx)
-	vmovdqa	%xmm7,304-256(%rcx)
-
-	jmp	.Loop_enter4xop
-
-.align	32
-.Loop_outer4xop:
-	vmovdqa	64(%rsp),%xmm8
-	vmovdqa	80(%rsp),%xmm9
-	vmovdqa	96(%rsp),%xmm10
-	vmovdqa	112(%rsp),%xmm11
-	vmovdqa	128-256(%rcx),%xmm0
-	vmovdqa	144-256(%rcx),%xmm1
-	vmovdqa	160-256(%rcx),%xmm2
-	vmovdqa	176-256(%rcx),%xmm3
-	vmovdqa	192-256(%rcx),%xmm12
-	vmovdqa	208-256(%rcx),%xmm13
-	vmovdqa	224-256(%rcx),%xmm14
-	vmovdqa	240-256(%rcx),%xmm15
-	vmovdqa	256-256(%rcx),%xmm4
-	vmovdqa	272-256(%rcx),%xmm5
-	vmovdqa	288-256(%rcx),%xmm6
-	vmovdqa	304-256(%rcx),%xmm7
-	vpaddd	.Lfour(%rip),%xmm4,%xmm4
-
-.Loop_enter4xop:
-	movl	$10,%eax
-	vmovdqa	%xmm4,256-256(%rcx)
-	jmp	.Loop4xop
-
-.align	32
-.Loop4xop:
-	vpaddd	%xmm0,%xmm8,%xmm8
-	vpaddd	%xmm1,%xmm9,%xmm9
-	vpaddd	%xmm2,%xmm10,%xmm10
-	vpaddd	%xmm3,%xmm11,%xmm11
-	vpxor	%xmm4,%xmm8,%xmm4
-	vpxor	%xmm5,%xmm9,%xmm5
-	vpxor	%xmm6,%xmm10,%xmm6
-	vpxor	%xmm7,%xmm11,%xmm7
-.byte	143,232,120,194,228,16
-.byte	143,232,120,194,237,16
-.byte	143,232,120,194,246,16
-.byte	143,232,120,194,255,16
-	vpaddd	%xmm4,%xmm12,%xmm12
-	vpaddd	%xmm5,%xmm13,%xmm13
-	vpaddd	%xmm6,%xmm14,%xmm14
-	vpaddd	%xmm7,%xmm15,%xmm15
-	vpxor	%xmm0,%xmm12,%xmm0
-	vpxor	%xmm1,%xmm13,%xmm1
-	vpxor	%xmm14,%xmm2,%xmm2
-	vpxor	%xmm15,%xmm3,%xmm3
-.byte	143,232,120,194,192,12
-.byte	143,232,120,194,201,12
-.byte	143,232,120,194,210,12
-.byte	143,232,120,194,219,12
-	vpaddd	%xmm8,%xmm0,%xmm8
-	vpaddd	%xmm9,%xmm1,%xmm9
-	vpaddd	%xmm2,%xmm10,%xmm10
-	vpaddd	%xmm3,%xmm11,%xmm11
-	vpxor	%xmm4,%xmm8,%xmm4
-	vpxor	%xmm5,%xmm9,%xmm5
-	vpxor	%xmm6,%xmm10,%xmm6
-	vpxor	%xmm7,%xmm11,%xmm7
-.byte	143,232,120,194,228,8
-.byte	143,232,120,194,237,8
-.byte	143,232,120,194,246,8
-.byte	143,232,120,194,255,8
-	vpaddd	%xmm4,%xmm12,%xmm12
-	vpaddd	%xmm5,%xmm13,%xmm13
-	vpaddd	%xmm6,%xmm14,%xmm14
-	vpaddd	%xmm7,%xmm15,%xmm15
-	vpxor	%xmm0,%xmm12,%xmm0
-	vpxor	%xmm1,%xmm13,%xmm1
-	vpxor	%xmm14,%xmm2,%xmm2
-	vpxor	%xmm15,%xmm3,%xmm3
-.byte	143,232,120,194,192,7
-.byte	143,232,120,194,201,7
-.byte	143,232,120,194,210,7
-.byte	143,232,120,194,219,7
-	vpaddd	%xmm1,%xmm8,%xmm8
-	vpaddd	%xmm2,%xmm9,%xmm9
-	vpaddd	%xmm3,%xmm10,%xmm10
-	vpaddd	%xmm0,%xmm11,%xmm11
-	vpxor	%xmm7,%xmm8,%xmm7
-	vpxor	%xmm4,%xmm9,%xmm4
-	vpxor	%xmm5,%xmm10,%xmm5
-	vpxor	%xmm6,%xmm11,%xmm6
-.byte	143,232,120,194,255,16
-.byte	143,232,120,194,228,16
-.byte	143,232,120,194,237,16
-.byte	143,232,120,194,246,16
-	vpaddd	%xmm7,%xmm14,%xmm14
-	vpaddd	%xmm4,%xmm15,%xmm15
-	vpaddd	%xmm5,%xmm12,%xmm12
-	vpaddd	%xmm6,%xmm13,%xmm13
-	vpxor	%xmm1,%xmm14,%xmm1
-	vpxor	%xmm2,%xmm15,%xmm2
-	vpxor	%xmm12,%xmm3,%xmm3
-	vpxor	%xmm13,%xmm0,%xmm0
-.byte	143,232,120,194,201,12
-.byte	143,232,120,194,210,12
-.byte	143,232,120,194,219,12
-.byte	143,232,120,194,192,12
-	vpaddd	%xmm8,%xmm1,%xmm8
-	vpaddd	%xmm9,%xmm2,%xmm9
-	vpaddd	%xmm3,%xmm10,%xmm10
-	vpaddd	%xmm0,%xmm11,%xmm11
-	vpxor	%xmm7,%xmm8,%xmm7
-	vpxor	%xmm4,%xmm9,%xmm4
-	vpxor	%xmm5,%xmm10,%xmm5
-	vpxor	%xmm6,%xmm11,%xmm6
-.byte	143,232,120,194,255,8
-.byte	143,232,120,194,228,8
-.byte	143,232,120,194,237,8
-.byte	143,232,120,194,246,8
-	vpaddd	%xmm7,%xmm14,%xmm14
-	vpaddd	%xmm4,%xmm15,%xmm15
-	vpaddd	%xmm5,%xmm12,%xmm12
-	vpaddd	%xmm6,%xmm13,%xmm13
-	vpxor	%xmm1,%xmm14,%xmm1
-	vpxor	%xmm2,%xmm15,%xmm2
-	vpxor	%xmm12,%xmm3,%xmm3
-	vpxor	%xmm13,%xmm0,%xmm0
-.byte	143,232,120,194,201,7
-.byte	143,232,120,194,210,7
-.byte	143,232,120,194,219,7
-.byte	143,232,120,194,192,7
-	decl	%eax
-	jnz	.Loop4xop
-
-	vpaddd	64(%rsp),%xmm8,%xmm8
-	vpaddd	80(%rsp),%xmm9,%xmm9
-	vpaddd	96(%rsp),%xmm10,%xmm10
-	vpaddd	112(%rsp),%xmm11,%xmm11
-
-	vmovdqa	%xmm14,32(%rsp)
-	vmovdqa	%xmm15,48(%rsp)
-
-	vpunpckldq	%xmm9,%xmm8,%xmm14
-	vpunpckldq	%xmm11,%xmm10,%xmm15
-	vpunpckhdq	%xmm9,%xmm8,%xmm8
-	vpunpckhdq	%xmm11,%xmm10,%xmm10
-	vpunpcklqdq	%xmm15,%xmm14,%xmm9
-	vpunpckhqdq	%xmm15,%xmm14,%xmm14
-	vpunpcklqdq	%xmm10,%xmm8,%xmm11
-	vpunpckhqdq	%xmm10,%xmm8,%xmm8
-	vpaddd	128-256(%rcx),%xmm0,%xmm0
-	vpaddd	144-256(%rcx),%xmm1,%xmm1
-	vpaddd	160-256(%rcx),%xmm2,%xmm2
-	vpaddd	176-256(%rcx),%xmm3,%xmm3
-
-	vmovdqa	%xmm9,0(%rsp)
-	vmovdqa	%xmm14,16(%rsp)
-	vmovdqa	32(%rsp),%xmm9
-	vmovdqa	48(%rsp),%xmm14
-
-	vpunpckldq	%xmm1,%xmm0,%xmm10
-	vpunpckldq	%xmm3,%xmm2,%xmm15
-	vpunpckhdq	%xmm1,%xmm0,%xmm0
-	vpunpckhdq	%xmm3,%xmm2,%xmm2
-	vpunpcklqdq	%xmm15,%xmm10,%xmm1
-	vpunpckhqdq	%xmm15,%xmm10,%xmm10
-	vpunpcklqdq	%xmm2,%xmm0,%xmm3
-	vpunpckhqdq	%xmm2,%xmm0,%xmm0
-	vpaddd	192-256(%rcx),%xmm12,%xmm12
-	vpaddd	208-256(%rcx),%xmm13,%xmm13
-	vpaddd	224-256(%rcx),%xmm9,%xmm9
-	vpaddd	240-256(%rcx),%xmm14,%xmm14
-
-	vpunpckldq	%xmm13,%xmm12,%xmm2
-	vpunpckldq	%xmm14,%xmm9,%xmm15
-	vpunpckhdq	%xmm13,%xmm12,%xmm12
-	vpunpckhdq	%xmm14,%xmm9,%xmm9
-	vpunpcklqdq	%xmm15,%xmm2,%xmm13
-	vpunpckhqdq	%xmm15,%xmm2,%xmm2
-	vpunpcklqdq	%xmm9,%xmm12,%xmm14
-	vpunpckhqdq	%xmm9,%xmm12,%xmm12
-	vpaddd	256-256(%rcx),%xmm4,%xmm4
-	vpaddd	272-256(%rcx),%xmm5,%xmm5
-	vpaddd	288-256(%rcx),%xmm6,%xmm6
-	vpaddd	304-256(%rcx),%xmm7,%xmm7
-
-	vpunpckldq	%xmm5,%xmm4,%xmm9
-	vpunpckldq	%xmm7,%xmm6,%xmm15
-	vpunpckhdq	%xmm5,%xmm4,%xmm4
-	vpunpckhdq	%xmm7,%xmm6,%xmm6
-	vpunpcklqdq	%xmm15,%xmm9,%xmm5
-	vpunpckhqdq	%xmm15,%xmm9,%xmm9
-	vpunpcklqdq	%xmm6,%xmm4,%xmm7
-	vpunpckhqdq	%xmm6,%xmm4,%xmm4
-	vmovdqa	0(%rsp),%xmm6
-	vmovdqa	16(%rsp),%xmm15
-
-	cmpq	$256,%rdx
-	jb	.Ltail4xop
-
-	vpxor	0(%rsi),%xmm6,%xmm6
-	vpxor	16(%rsi),%xmm1,%xmm1
-	vpxor	32(%rsi),%xmm13,%xmm13
-	vpxor	48(%rsi),%xmm5,%xmm5
-	vpxor	64(%rsi),%xmm15,%xmm15
-	vpxor	80(%rsi),%xmm10,%xmm10
-	vpxor	96(%rsi),%xmm2,%xmm2
-	vpxor	112(%rsi),%xmm9,%xmm9
-	leaq	128(%rsi),%rsi
-	vpxor	0(%rsi),%xmm11,%xmm11
-	vpxor	16(%rsi),%xmm3,%xmm3
-	vpxor	32(%rsi),%xmm14,%xmm14
-	vpxor	48(%rsi),%xmm7,%xmm7
-	vpxor	64(%rsi),%xmm8,%xmm8
-	vpxor	80(%rsi),%xmm0,%xmm0
-	vpxor	96(%rsi),%xmm12,%xmm12
-	vpxor	112(%rsi),%xmm4,%xmm4
-	leaq	128(%rsi),%rsi
-
-	vmovdqu	%xmm6,0(%rdi)
-	vmovdqu	%xmm1,16(%rdi)
-	vmovdqu	%xmm13,32(%rdi)
-	vmovdqu	%xmm5,48(%rdi)
-	vmovdqu	%xmm15,64(%rdi)
-	vmovdqu	%xmm10,80(%rdi)
-	vmovdqu	%xmm2,96(%rdi)
-	vmovdqu	%xmm9,112(%rdi)
-	leaq	128(%rdi),%rdi
-	vmovdqu	%xmm11,0(%rdi)
-	vmovdqu	%xmm3,16(%rdi)
-	vmovdqu	%xmm14,32(%rdi)
-	vmovdqu	%xmm7,48(%rdi)
-	vmovdqu	%xmm8,64(%rdi)
-	vmovdqu	%xmm0,80(%rdi)
-	vmovdqu	%xmm12,96(%rdi)
-	vmovdqu	%xmm4,112(%rdi)
-	leaq	128(%rdi),%rdi
-
-	subq	$256,%rdx
-	jnz	.Loop_outer4xop
-
-	jmp	.Ldone4xop
-
-.align	32
-.Ltail4xop:
-	cmpq	$192,%rdx
-	jae	.L192_or_more4xop
-	cmpq	$128,%rdx
-	jae	.L128_or_more4xop
-	cmpq	$64,%rdx
-	jae	.L64_or_more4xop
-
-	xorq	%r10,%r10
-	vmovdqa	%xmm6,0(%rsp)
-	vmovdqa	%xmm1,16(%rsp)
-	vmovdqa	%xmm13,32(%rsp)
-	vmovdqa	%xmm5,48(%rsp)
-	jmp	.Loop_tail4xop
-
-.align	32
-.L64_or_more4xop:
-	vpxor	0(%rsi),%xmm6,%xmm6
-	vpxor	16(%rsi),%xmm1,%xmm1
-	vpxor	32(%rsi),%xmm13,%xmm13
-	vpxor	48(%rsi),%xmm5,%xmm5
-	vmovdqu	%xmm6,0(%rdi)
-	vmovdqu	%xmm1,16(%rdi)
-	vmovdqu	%xmm13,32(%rdi)
-	vmovdqu	%xmm5,48(%rdi)
-	je	.Ldone4xop
-
-	leaq	64(%rsi),%rsi
-	vmovdqa	%xmm15,0(%rsp)
-	xorq	%r10,%r10
-	vmovdqa	%xmm10,16(%rsp)
-	leaq	64(%rdi),%rdi
-	vmovdqa	%xmm2,32(%rsp)
-	subq	$64,%rdx
-	vmovdqa	%xmm9,48(%rsp)
-	jmp	.Loop_tail4xop
-
-.align	32
-.L128_or_more4xop:
-	vpxor	0(%rsi),%xmm6,%xmm6
-	vpxor	16(%rsi),%xmm1,%xmm1
-	vpxor	32(%rsi),%xmm13,%xmm13
-	vpxor	48(%rsi),%xmm5,%xmm5
-	vpxor	64(%rsi),%xmm15,%xmm15
-	vpxor	80(%rsi),%xmm10,%xmm10
-	vpxor	96(%rsi),%xmm2,%xmm2
-	vpxor	112(%rsi),%xmm9,%xmm9
-
-	vmovdqu	%xmm6,0(%rdi)
-	vmovdqu	%xmm1,16(%rdi)
-	vmovdqu	%xmm13,32(%rdi)
-	vmovdqu	%xmm5,48(%rdi)
-	vmovdqu	%xmm15,64(%rdi)
-	vmovdqu	%xmm10,80(%rdi)
-	vmovdqu	%xmm2,96(%rdi)
-	vmovdqu	%xmm9,112(%rdi)
-	je	.Ldone4xop
-
-	leaq	128(%rsi),%rsi
-	vmovdqa	%xmm11,0(%rsp)
-	xorq	%r10,%r10
-	vmovdqa	%xmm3,16(%rsp)
-	leaq	128(%rdi),%rdi
-	vmovdqa	%xmm14,32(%rsp)
-	subq	$128,%rdx
-	vmovdqa	%xmm7,48(%rsp)
-	jmp	.Loop_tail4xop
+.L4x_epilogue:
+	ret
+ENDPROC(chacha20_ssse3)
+#endif /* CONFIG_AS_SSSE3 */
 
+#ifdef CONFIG_AS_AVX2
 .align	32
-.L192_or_more4xop:
-	vpxor	0(%rsi),%xmm6,%xmm6
-	vpxor	16(%rsi),%xmm1,%xmm1
-	vpxor	32(%rsi),%xmm13,%xmm13
-	vpxor	48(%rsi),%xmm5,%xmm5
-	vpxor	64(%rsi),%xmm15,%xmm15
-	vpxor	80(%rsi),%xmm10,%xmm10
-	vpxor	96(%rsi),%xmm2,%xmm2
-	vpxor	112(%rsi),%xmm9,%xmm9
-	leaq	128(%rsi),%rsi
-	vpxor	0(%rsi),%xmm11,%xmm11
-	vpxor	16(%rsi),%xmm3,%xmm3
-	vpxor	32(%rsi),%xmm14,%xmm14
-	vpxor	48(%rsi),%xmm7,%xmm7
-
-	vmovdqu	%xmm6,0(%rdi)
-	vmovdqu	%xmm1,16(%rdi)
-	vmovdqu	%xmm13,32(%rdi)
-	vmovdqu	%xmm5,48(%rdi)
-	vmovdqu	%xmm15,64(%rdi)
-	vmovdqu	%xmm10,80(%rdi)
-	vmovdqu	%xmm2,96(%rdi)
-	vmovdqu	%xmm9,112(%rdi)
-	leaq	128(%rdi),%rdi
-	vmovdqu	%xmm11,0(%rdi)
-	vmovdqu	%xmm3,16(%rdi)
-	vmovdqu	%xmm14,32(%rdi)
-	vmovdqu	%xmm7,48(%rdi)
-	je	.Ldone4xop
-
-	leaq	64(%rsi),%rsi
-	vmovdqa	%xmm8,0(%rsp)
-	xorq	%r10,%r10
-	vmovdqa	%xmm0,16(%rsp)
-	leaq	64(%rdi),%rdi
-	vmovdqa	%xmm12,32(%rsp)
-	subq	$192,%rdx
-	vmovdqa	%xmm4,48(%rsp)
-
-.Loop_tail4xop:
-	movzbl	(%rsi,%r10,1),%eax
-	movzbl	(%rsp,%r10,1),%ecx
-	leaq	1(%r10),%r10
-	xorl	%ecx,%eax
-	movb	%al,-1(%rdi,%r10,1)
-	decq	%rdx
-	jnz	.Loop_tail4xop
+ENTRY(chacha20_avx2)
+.Lchacha20_avx2:
+	cmpq	$0,%rdx
+	je	.L8x_epilogue
+	leaq	8(%rsp),%r10
 
-.Ldone4xop:
-	vzeroupper
-	leaq	(%r9),%rsp
-.cfi_def_cfa_register	%rsp
-.L4xop_epilogue:
-	.byte	0xf3,0xc3
-.cfi_endproc	
-.size	ChaCha20_4xop,.-ChaCha20_4xop
-.type	ChaCha20_8x,@function
-.align	32
-ChaCha20_8x:
-.cfi_startproc	
-.LChaCha20_8x:
-	movq	%rsp,%r9
-.cfi_def_cfa_register	%r9
 	subq	$0x280+8,%rsp
 	andq	$-32,%rsp
 	vzeroupper
 
-
-
-
-
-
-
-
-
-
 	vbroadcasti128	.Lsigma(%rip),%ymm11
 	vbroadcasti128	(%rcx),%ymm3
 	vbroadcasti128	16(%rcx),%ymm15
 	vbroadcasti128	(%r8),%ymm7
 	leaq	256(%rsp),%rcx
 	leaq	512(%rsp),%rax
-	leaq	.Lrot16(%rip),%r10
+	leaq	.Lrot16(%rip),%r9
 	leaq	.Lrot24(%rip),%r11
 
 	vpshufd	$0x00,%ymm11,%ymm8
@@ -1684,7 +889,7 @@ ChaCha20_8x:
 .Loop_enter8x:
 	vmovdqa	%ymm14,64(%rsp)
 	vmovdqa	%ymm15,96(%rsp)
-	vbroadcasti128	(%r10),%ymm15
+	vbroadcasti128	(%r9),%ymm15
 	vmovdqa	%ymm4,512-512(%rax)
 	movl	$10,%eax
 	jmp	.Loop8x
@@ -1719,7 +924,7 @@ ChaCha20_8x:
 	vpslld	$7,%ymm0,%ymm15
 	vpsrld	$25,%ymm0,%ymm0
 	vpor	%ymm0,%ymm15,%ymm0
-	vbroadcasti128	(%r10),%ymm15
+	vbroadcasti128	(%r9),%ymm15
 	vpaddd	%ymm5,%ymm13,%ymm13
 	vpxor	%ymm1,%ymm13,%ymm1
 	vpslld	$7,%ymm1,%ymm14
@@ -1757,7 +962,7 @@ ChaCha20_8x:
 	vpslld	$7,%ymm2,%ymm15
 	vpsrld	$25,%ymm2,%ymm2
 	vpor	%ymm2,%ymm15,%ymm2
-	vbroadcasti128	(%r10),%ymm15
+	vbroadcasti128	(%r9),%ymm15
 	vpaddd	%ymm7,%ymm13,%ymm13
 	vpxor	%ymm3,%ymm13,%ymm3
 	vpslld	$7,%ymm3,%ymm14
@@ -1791,7 +996,7 @@ ChaCha20_8x:
 	vpslld	$7,%ymm1,%ymm15
 	vpsrld	$25,%ymm1,%ymm1
 	vpor	%ymm1,%ymm15,%ymm1
-	vbroadcasti128	(%r10),%ymm15
+	vbroadcasti128	(%r9),%ymm15
 	vpaddd	%ymm4,%ymm13,%ymm13
 	vpxor	%ymm2,%ymm13,%ymm2
 	vpslld	$7,%ymm2,%ymm14
@@ -1829,7 +1034,7 @@ ChaCha20_8x:
 	vpslld	$7,%ymm3,%ymm15
 	vpsrld	$25,%ymm3,%ymm3
 	vpor	%ymm3,%ymm15,%ymm3
-	vbroadcasti128	(%r10),%ymm15
+	vbroadcasti128	(%r9),%ymm15
 	vpaddd	%ymm6,%ymm13,%ymm13
 	vpxor	%ymm0,%ymm13,%ymm0
 	vpslld	$7,%ymm0,%ymm14
@@ -1983,7 +1188,7 @@ ChaCha20_8x:
 	cmpq	$64,%rdx
 	jae	.L64_or_more8x
 
-	xorq	%r10,%r10
+	xorq	%r9,%r9
 	vmovdqa	%ymm6,0(%rsp)
 	vmovdqa	%ymm8,32(%rsp)
 	jmp	.Loop_tail8x
@@ -1997,7 +1202,7 @@ ChaCha20_8x:
 	je	.Ldone8x
 
 	leaq	64(%rsi),%rsi
-	xorq	%r10,%r10
+	xorq	%r9,%r9
 	vmovdqa	%ymm1,0(%rsp)
 	leaq	64(%rdi),%rdi
 	subq	$64,%rdx
@@ -2017,7 +1222,7 @@ ChaCha20_8x:
 	je	.Ldone8x
 
 	leaq	128(%rsi),%rsi
-	xorq	%r10,%r10
+	xorq	%r9,%r9
 	vmovdqa	%ymm12,0(%rsp)
 	leaq	128(%rdi),%rdi
 	subq	$128,%rdx
@@ -2041,7 +1246,7 @@ ChaCha20_8x:
 	je	.Ldone8x
 
 	leaq	192(%rsi),%rsi
-	xorq	%r10,%r10
+	xorq	%r9,%r9
 	vmovdqa	%ymm10,0(%rsp)
 	leaq	192(%rdi),%rdi
 	subq	$192,%rdx
@@ -2069,7 +1274,7 @@ ChaCha20_8x:
 	je	.Ldone8x
 
 	leaq	256(%rsi),%rsi
-	xorq	%r10,%r10
+	xorq	%r9,%r9
 	vmovdqa	%ymm14,0(%rsp)
 	leaq	256(%rdi),%rdi
 	subq	$256,%rdx
@@ -2101,7 +1306,7 @@ ChaCha20_8x:
 	je	.Ldone8x
 
 	leaq	320(%rsi),%rsi
-	xorq	%r10,%r10
+	xorq	%r9,%r9
 	vmovdqa	%ymm3,0(%rsp)
 	leaq	320(%rdi),%rdi
 	subq	$320,%rdx
@@ -2137,7 +1342,7 @@ ChaCha20_8x:
 	je	.Ldone8x
 
 	leaq	384(%rsi),%rsi
-	xorq	%r10,%r10
+	xorq	%r9,%r9
 	vmovdqa	%ymm11,0(%rsp)
 	leaq	384(%rdi),%rdi
 	subq	$384,%rdx
@@ -2177,40 +1382,43 @@ ChaCha20_8x:
 	je	.Ldone8x
 
 	leaq	448(%rsi),%rsi
-	xorq	%r10,%r10
+	xorq	%r9,%r9
 	vmovdqa	%ymm0,0(%rsp)
 	leaq	448(%rdi),%rdi
 	subq	$448,%rdx
 	vmovdqa	%ymm4,32(%rsp)
 
 .Loop_tail8x:
-	movzbl	(%rsi,%r10,1),%eax
-	movzbl	(%rsp,%r10,1),%ecx
-	leaq	1(%r10),%r10
+	movzbl	(%rsi,%r9,1),%eax
+	movzbl	(%rsp,%r9,1),%ecx
+	leaq	1(%r9),%r9
 	xorl	%ecx,%eax
-	movb	%al,-1(%rdi,%r10,1)
+	movb	%al,-1(%rdi,%r9,1)
 	decq	%rdx
 	jnz	.Loop_tail8x
 
 .Ldone8x:
 	vzeroall
-	leaq	(%r9),%rsp
-.cfi_def_cfa_register	%rsp
+	leaq	-8(%r10),%rsp
+
 .L8x_epilogue:
-	.byte	0xf3,0xc3
-.cfi_endproc	
-.size	ChaCha20_8x,.-ChaCha20_8x
-.type	ChaCha20_avx512,@function
+	ret
+ENDPROC(chacha20_avx2)
+#endif /* CONFIG_AS_AVX2 */
+
+#ifdef CONFIG_AS_AVX512
 .align	32
-ChaCha20_avx512:
-.cfi_startproc	
-.LChaCha20_avx512:
-	movq	%rsp,%r9
-.cfi_def_cfa_register	%r9
+ENTRY(chacha20_avx512)
+.Lchacha20_avx512:
+	cmpq	$0,%rdx
+	je	.Lavx512_epilogue
+	leaq	8(%rsp),%r10
+
 	cmpq	$512,%rdx
-	ja	.LChaCha20_16x
+	ja	.Lchacha20_16x
 
 	subq	$64+8,%rsp
+	andq	$-64,%rsp
 	vbroadcasti32x4	.Lsigma(%rip),%zmm0
 	vbroadcasti32x4	(%rcx),%zmm1
 	vbroadcasti32x4	16(%rcx),%zmm2
@@ -2385,181 +1593,25 @@ ChaCha20_avx512:
 	decq	%rdx
 	jnz	.Loop_tail_avx512
 
-	vmovdqu32	%zmm16,0(%rsp)
+	vmovdqa32	%zmm16,0(%rsp)
 
 .Ldone_avx512:
 	vzeroall
-	leaq	(%r9),%rsp
-.cfi_def_cfa_register	%rsp
-.Lavx512_epilogue:
-	.byte	0xf3,0xc3
-.cfi_endproc	
-.size	ChaCha20_avx512,.-ChaCha20_avx512
-.type	ChaCha20_avx512vl,@function
-.align	32
-ChaCha20_avx512vl:
-.cfi_startproc	
-.LChaCha20_avx512vl:
-	movq	%rsp,%r9
-.cfi_def_cfa_register	%r9
-	cmpq	$128,%rdx
-	ja	.LChaCha20_8xvl
-
-	subq	$64+8,%rsp
-	vbroadcasti128	.Lsigma(%rip),%ymm0
-	vbroadcasti128	(%rcx),%ymm1
-	vbroadcasti128	16(%rcx),%ymm2
-	vbroadcasti128	(%r8),%ymm3
+	leaq	-8(%r10),%rsp
 
-	vmovdqa32	%ymm0,%ymm16
-	vmovdqa32	%ymm1,%ymm17
-	vmovdqa32	%ymm2,%ymm18
-	vpaddd	.Lzeroz(%rip),%ymm3,%ymm3
-	vmovdqa32	.Ltwoy(%rip),%ymm20
-	movq	$10,%r8
-	vmovdqa32	%ymm3,%ymm19
-	jmp	.Loop_avx512vl
-
-.align	16
-.Loop_outer_avx512vl:
-	vmovdqa32	%ymm18,%ymm2
-	vpaddd	%ymm20,%ymm19,%ymm3
-	movq	$10,%r8
-	vmovdqa32	%ymm3,%ymm19
-	jmp	.Loop_avx512vl
+.Lavx512_epilogue:
+	ret
 
 .align	32
-.Loop_avx512vl:
-	vpaddd	%ymm1,%ymm0,%ymm0
-	vpxor	%ymm0,%ymm3,%ymm3
-	vprold	$16,%ymm3,%ymm3
-	vpaddd	%ymm3,%ymm2,%ymm2
-	vpxor	%ymm2,%ymm1,%ymm1
-	vprold	$12,%ymm1,%ymm1
-	vpaddd	%ymm1,%ymm0,%ymm0
-	vpxor	%ymm0,%ymm3,%ymm3
-	vprold	$8,%ymm3,%ymm3
-	vpaddd	%ymm3,%ymm2,%ymm2
-	vpxor	%ymm2,%ymm1,%ymm1
-	vprold	$7,%ymm1,%ymm1
-	vpshufd	$78,%ymm2,%ymm2
-	vpshufd	$57,%ymm1,%ymm1
-	vpshufd	$147,%ymm3,%ymm3
-	vpaddd	%ymm1,%ymm0,%ymm0
-	vpxor	%ymm0,%ymm3,%ymm3
-	vprold	$16,%ymm3,%ymm3
-	vpaddd	%ymm3,%ymm2,%ymm2
-	vpxor	%ymm2,%ymm1,%ymm1
-	vprold	$12,%ymm1,%ymm1
-	vpaddd	%ymm1,%ymm0,%ymm0
-	vpxor	%ymm0,%ymm3,%ymm3
-	vprold	$8,%ymm3,%ymm3
-	vpaddd	%ymm3,%ymm2,%ymm2
-	vpxor	%ymm2,%ymm1,%ymm1
-	vprold	$7,%ymm1,%ymm1
-	vpshufd	$78,%ymm2,%ymm2
-	vpshufd	$147,%ymm1,%ymm1
-	vpshufd	$57,%ymm3,%ymm3
-	decq	%r8
-	jnz	.Loop_avx512vl
-	vpaddd	%ymm16,%ymm0,%ymm0
-	vpaddd	%ymm17,%ymm1,%ymm1
-	vpaddd	%ymm18,%ymm2,%ymm2
-	vpaddd	%ymm19,%ymm3,%ymm3
-
-	subq	$64,%rdx
-	jb	.Ltail64_avx512vl
-
-	vpxor	0(%rsi),%xmm0,%xmm4
-	vpxor	16(%rsi),%xmm1,%xmm5
-	vpxor	32(%rsi),%xmm2,%xmm6
-	vpxor	48(%rsi),%xmm3,%xmm7
-	leaq	64(%rsi),%rsi
-
-	vmovdqu	%xmm4,0(%rdi)
-	vmovdqu	%xmm5,16(%rdi)
-	vmovdqu	%xmm6,32(%rdi)
-	vmovdqu	%xmm7,48(%rdi)
-	leaq	64(%rdi),%rdi
-
-	jz	.Ldone_avx512vl
-
-	vextracti128	$1,%ymm0,%xmm4
-	vextracti128	$1,%ymm1,%xmm5
-	vextracti128	$1,%ymm2,%xmm6
-	vextracti128	$1,%ymm3,%xmm7
-
-	subq	$64,%rdx
-	jb	.Ltail_avx512vl
-
-	vpxor	0(%rsi),%xmm4,%xmm4
-	vpxor	16(%rsi),%xmm5,%xmm5
-	vpxor	32(%rsi),%xmm6,%xmm6
-	vpxor	48(%rsi),%xmm7,%xmm7
-	leaq	64(%rsi),%rsi
+.Lchacha20_16x:
+	leaq	8(%rsp),%r10
 
-	vmovdqu	%xmm4,0(%rdi)
-	vmovdqu	%xmm5,16(%rdi)
-	vmovdqu	%xmm6,32(%rdi)
-	vmovdqu	%xmm7,48(%rdi)
-	leaq	64(%rdi),%rdi
-
-	vmovdqa32	%ymm16,%ymm0
-	vmovdqa32	%ymm17,%ymm1
-	jnz	.Loop_outer_avx512vl
-
-	jmp	.Ldone_avx512vl
-
-.align	16
-.Ltail64_avx512vl:
-	vmovdqa	%xmm0,0(%rsp)
-	vmovdqa	%xmm1,16(%rsp)
-	vmovdqa	%xmm2,32(%rsp)
-	vmovdqa	%xmm3,48(%rsp)
-	addq	$64,%rdx
-	jmp	.Loop_tail_avx512vl
-
-.align	16
-.Ltail_avx512vl:
-	vmovdqa	%xmm4,0(%rsp)
-	vmovdqa	%xmm5,16(%rsp)
-	vmovdqa	%xmm6,32(%rsp)
-	vmovdqa	%xmm7,48(%rsp)
-	addq	$64,%rdx
-
-.Loop_tail_avx512vl:
-	movzbl	(%rsi,%r8,1),%eax
-	movzbl	(%rsp,%r8,1),%ecx
-	leaq	1(%r8),%r8
-	xorl	%ecx,%eax
-	movb	%al,-1(%rdi,%r8,1)
-	decq	%rdx
-	jnz	.Loop_tail_avx512vl
-
-	vmovdqu32	%ymm16,0(%rsp)
-	vmovdqu32	%ymm16,32(%rsp)
-
-.Ldone_avx512vl:
-	vzeroall
-	leaq	(%r9),%rsp
-.cfi_def_cfa_register	%rsp
-.Lavx512vl_epilogue:
-	.byte	0xf3,0xc3
-.cfi_endproc	
-.size	ChaCha20_avx512vl,.-ChaCha20_avx512vl
-.type	ChaCha20_16x,@function
-.align	32
-ChaCha20_16x:
-.cfi_startproc	
-.LChaCha20_16x:
-	movq	%rsp,%r9
-.cfi_def_cfa_register	%r9
 	subq	$64+8,%rsp
 	andq	$-64,%rsp
 	vzeroupper
 
-	leaq	.Lsigma(%rip),%r10
-	vbroadcasti32x4	(%r10),%zmm3
+	leaq	.Lsigma(%rip),%r9
+	vbroadcasti32x4	(%r9),%zmm3
 	vbroadcasti32x4	(%rcx),%zmm7
 	vbroadcasti32x4	16(%rcx),%zmm11
 	vbroadcasti32x4	(%r8),%zmm15
@@ -2606,10 +1658,10 @@ ChaCha20_16x:
 
 .align	32
 .Loop_outer16x:
-	vpbroadcastd	0(%r10),%zmm0
-	vpbroadcastd	4(%r10),%zmm1
-	vpbroadcastd	8(%r10),%zmm2
-	vpbroadcastd	12(%r10),%zmm3
+	vpbroadcastd	0(%r9),%zmm0
+	vpbroadcastd	4(%r9),%zmm1
+	vpbroadcastd	8(%r9),%zmm2
+	vpbroadcastd	12(%r9),%zmm3
 	vpaddd	.Lsixteen(%rip),%zmm28,%zmm28
 	vmovdqa64	%zmm20,%zmm4
 	vmovdqa64	%zmm21,%zmm5
@@ -2865,7 +1917,7 @@ ChaCha20_16x:
 
 .align	32
 .Ltail16x:
-	xorq	%r10,%r10
+	xorq	%r9,%r9
 	subq	%rsi,%rdi
 	cmpq	$64,%rdx
 	jb	.Less_than_64_16x
@@ -2993,11 +2045,11 @@ ChaCha20_16x:
 	andq	$63,%rdx
 
 .Loop_tail16x:
-	movzbl	(%rsi,%r10,1),%eax
-	movzbl	(%rsp,%r10,1),%ecx
-	leaq	1(%r10),%r10
+	movzbl	(%rsi,%r9,1),%eax
+	movzbl	(%rsp,%r9,1),%ecx
+	leaq	1(%r9),%r9
 	xorl	%ecx,%eax
-	movb	%al,-1(%rdi,%r10,1)
+	movb	%al,-1(%rdi,%r9,1)
 	decq	%rdx
 	jnz	.Loop_tail16x
 
@@ -3006,25 +2058,172 @@ ChaCha20_16x:
 
 .Ldone16x:
 	vzeroall
-	leaq	(%r9),%rsp
-.cfi_def_cfa_register	%rsp
+	leaq	-8(%r10),%rsp
+
 .L16x_epilogue:
-	.byte	0xf3,0xc3
-.cfi_endproc	
-.size	ChaCha20_16x,.-ChaCha20_16x
-.type	ChaCha20_8xvl,@function
+	ret
+ENDPROC(chacha20_avx512)
+
 .align	32
-ChaCha20_8xvl:
-.cfi_startproc	
-.LChaCha20_8xvl:
-	movq	%rsp,%r9
-.cfi_def_cfa_register	%r9
+ENTRY(chacha20_avx512vl)
+	cmpq	$0,%rdx
+	je	.Lavx512vl_epilogue
+
+	leaq	8(%rsp),%r10
+
+	cmpq	$128,%rdx
+	ja	.Lchacha20_8xvl
+
+	subq	$64+8,%rsp
+	andq	$-64,%rsp
+	vbroadcasti128	.Lsigma(%rip),%ymm0
+	vbroadcasti128	(%rcx),%ymm1
+	vbroadcasti128	16(%rcx),%ymm2
+	vbroadcasti128	(%r8),%ymm3
+
+	vmovdqa32	%ymm0,%ymm16
+	vmovdqa32	%ymm1,%ymm17
+	vmovdqa32	%ymm2,%ymm18
+	vpaddd	.Lzeroz(%rip),%ymm3,%ymm3
+	vmovdqa32	.Ltwoy(%rip),%ymm20
+	movq	$10,%r8
+	vmovdqa32	%ymm3,%ymm19
+	jmp	.Loop_avx512vl
+
+.align	16
+.Loop_outer_avx512vl:
+	vmovdqa32	%ymm18,%ymm2
+	vpaddd	%ymm20,%ymm19,%ymm3
+	movq	$10,%r8
+	vmovdqa32	%ymm3,%ymm19
+	jmp	.Loop_avx512vl
+
+.align	32
+.Loop_avx512vl:
+	vpaddd	%ymm1,%ymm0,%ymm0
+	vpxor	%ymm0,%ymm3,%ymm3
+	vprold	$16,%ymm3,%ymm3
+	vpaddd	%ymm3,%ymm2,%ymm2
+	vpxor	%ymm2,%ymm1,%ymm1
+	vprold	$12,%ymm1,%ymm1
+	vpaddd	%ymm1,%ymm0,%ymm0
+	vpxor	%ymm0,%ymm3,%ymm3
+	vprold	$8,%ymm3,%ymm3
+	vpaddd	%ymm3,%ymm2,%ymm2
+	vpxor	%ymm2,%ymm1,%ymm1
+	vprold	$7,%ymm1,%ymm1
+	vpshufd	$78,%ymm2,%ymm2
+	vpshufd	$57,%ymm1,%ymm1
+	vpshufd	$147,%ymm3,%ymm3
+	vpaddd	%ymm1,%ymm0,%ymm0
+	vpxor	%ymm0,%ymm3,%ymm3
+	vprold	$16,%ymm3,%ymm3
+	vpaddd	%ymm3,%ymm2,%ymm2
+	vpxor	%ymm2,%ymm1,%ymm1
+	vprold	$12,%ymm1,%ymm1
+	vpaddd	%ymm1,%ymm0,%ymm0
+	vpxor	%ymm0,%ymm3,%ymm3
+	vprold	$8,%ymm3,%ymm3
+	vpaddd	%ymm3,%ymm2,%ymm2
+	vpxor	%ymm2,%ymm1,%ymm1
+	vprold	$7,%ymm1,%ymm1
+	vpshufd	$78,%ymm2,%ymm2
+	vpshufd	$147,%ymm1,%ymm1
+	vpshufd	$57,%ymm3,%ymm3
+	decq	%r8
+	jnz	.Loop_avx512vl
+	vpaddd	%ymm16,%ymm0,%ymm0
+	vpaddd	%ymm17,%ymm1,%ymm1
+	vpaddd	%ymm18,%ymm2,%ymm2
+	vpaddd	%ymm19,%ymm3,%ymm3
+
+	subq	$64,%rdx
+	jb	.Ltail64_avx512vl
+
+	vpxor	0(%rsi),%xmm0,%xmm4
+	vpxor	16(%rsi),%xmm1,%xmm5
+	vpxor	32(%rsi),%xmm2,%xmm6
+	vpxor	48(%rsi),%xmm3,%xmm7
+	leaq	64(%rsi),%rsi
+
+	vmovdqu	%xmm4,0(%rdi)
+	vmovdqu	%xmm5,16(%rdi)
+	vmovdqu	%xmm6,32(%rdi)
+	vmovdqu	%xmm7,48(%rdi)
+	leaq	64(%rdi),%rdi
+
+	jz	.Ldone_avx512vl
+
+	vextracti128	$1,%ymm0,%xmm4
+	vextracti128	$1,%ymm1,%xmm5
+	vextracti128	$1,%ymm2,%xmm6
+	vextracti128	$1,%ymm3,%xmm7
+
+	subq	$64,%rdx
+	jb	.Ltail_avx512vl
+
+	vpxor	0(%rsi),%xmm4,%xmm4
+	vpxor	16(%rsi),%xmm5,%xmm5
+	vpxor	32(%rsi),%xmm6,%xmm6
+	vpxor	48(%rsi),%xmm7,%xmm7
+	leaq	64(%rsi),%rsi
+
+	vmovdqu	%xmm4,0(%rdi)
+	vmovdqu	%xmm5,16(%rdi)
+	vmovdqu	%xmm6,32(%rdi)
+	vmovdqu	%xmm7,48(%rdi)
+	leaq	64(%rdi),%rdi
+
+	vmovdqa32	%ymm16,%ymm0
+	vmovdqa32	%ymm17,%ymm1
+	jnz	.Loop_outer_avx512vl
+
+	jmp	.Ldone_avx512vl
+
+.align	16
+.Ltail64_avx512vl:
+	vmovdqa	%xmm0,0(%rsp)
+	vmovdqa	%xmm1,16(%rsp)
+	vmovdqa	%xmm2,32(%rsp)
+	vmovdqa	%xmm3,48(%rsp)
+	addq	$64,%rdx
+	jmp	.Loop_tail_avx512vl
+
+.align	16
+.Ltail_avx512vl:
+	vmovdqa	%xmm4,0(%rsp)
+	vmovdqa	%xmm5,16(%rsp)
+	vmovdqa	%xmm6,32(%rsp)
+	vmovdqa	%xmm7,48(%rsp)
+	addq	$64,%rdx
+
+.Loop_tail_avx512vl:
+	movzbl	(%rsi,%r8,1),%eax
+	movzbl	(%rsp,%r8,1),%ecx
+	leaq	1(%r8),%r8
+	xorl	%ecx,%eax
+	movb	%al,-1(%rdi,%r8,1)
+	decq	%rdx
+	jnz	.Loop_tail_avx512vl
+
+	vmovdqa32	%ymm16,0(%rsp)
+	vmovdqa32	%ymm16,32(%rsp)
+
+.Ldone_avx512vl:
+	vzeroall
+	leaq	-8(%r10),%rsp
+.Lavx512vl_epilogue:
+	ret
+
+.align	32
+.Lchacha20_8xvl:
+	leaq	8(%rsp),%r10
 	subq	$64+8,%rsp
 	andq	$-64,%rsp
 	vzeroupper
 
-	leaq	.Lsigma(%rip),%r10
-	vbroadcasti128	(%r10),%ymm3
+	leaq	.Lsigma(%rip),%r9
+	vbroadcasti128	(%r9),%ymm3
 	vbroadcasti128	(%rcx),%ymm7
 	vbroadcasti128	16(%rcx),%ymm11
 	vbroadcasti128	(%r8),%ymm15
@@ -3073,8 +2272,8 @@ ChaCha20_8xvl:
 .Loop_outer8xvl:
 
 
-	vpbroadcastd	8(%r10),%ymm2
-	vpbroadcastd	12(%r10),%ymm3
+	vpbroadcastd	8(%r9),%ymm2
+	vpbroadcastd	12(%r9),%ymm3
 	vpaddd	.Leight(%rip),%ymm28,%ymm28
 	vmovdqa64	%ymm20,%ymm4
 	vmovdqa64	%ymm21,%ymm5
@@ -3314,8 +2513,8 @@ ChaCha20_8xvl:
 	vmovdqu	%ymm12,96(%rdi)
 	leaq	(%rdi,%rax,1),%rdi
 
-	vpbroadcastd	0(%r10),%ymm0
-	vpbroadcastd	4(%r10),%ymm1
+	vpbroadcastd	0(%r9),%ymm0
+	vpbroadcastd	4(%r9),%ymm1
 
 	subq	$512,%rdx
 	jnz	.Loop_outer8xvl
@@ -3325,7 +2524,7 @@ ChaCha20_8xvl:
 .align	32
 .Ltail8xvl:
 	vmovdqa64	%ymm19,%ymm8
-	xorq	%r10,%r10
+	xorq	%r9,%r9
 	subq	%rsi,%rdi
 	cmpq	$64,%rdx
 	jb	.Less_than_64_8xvl
@@ -3411,11 +2610,11 @@ ChaCha20_8xvl:
 	andq	$63,%rdx
 
 .Loop_tail8xvl:
-	movzbl	(%rsi,%r10,1),%eax
-	movzbl	(%rsp,%r10,1),%ecx
-	leaq	1(%r10),%r10
+	movzbl	(%rsi,%r9,1),%eax
+	movzbl	(%rsp,%r9,1),%ecx
+	leaq	1(%r9),%r9
 	xorl	%ecx,%eax
-	movb	%al,-1(%rdi,%r10,1)
+	movb	%al,-1(%rdi,%r9,1)
 	decq	%rdx
 	jnz	.Loop_tail8xvl
 
@@ -3425,9 +2624,9 @@ ChaCha20_8xvl:
 
 .Ldone8xvl:
 	vzeroall
-	leaq	(%r9),%rsp
-.cfi_def_cfa_register	%rsp
+	leaq	-8(%r10),%rsp
 .L8xvl_epilogue:
-	.byte	0xf3,0xc3
-.cfi_endproc	
-.size	ChaCha20_8xvl,.-ChaCha20_8xvl
+	ret
+ENDPROC(chacha20_avx512vl)
+
+#endif /* CONFIG_AS_AVX512 */
diff --git a/lib/zinc/chacha20/chacha20.c b/lib/zinc/chacha20/chacha20.c
index 03209c15d1ca..22a21431c221 100644
--- a/lib/zinc/chacha20/chacha20.c
+++ b/lib/zinc/chacha20/chacha20.c
@@ -16,6 +16,9 @@
 #include <linux/vmalloc.h>
 #include <crypto/algapi.h> // For crypto_xor_cpy.
 
+#if defined(CONFIG_ZINC_ARCH_X86_64)
+#include "chacha20-x86_64-glue.c"
+#else
 static bool *const chacha20_nobs[] __initconst = { };
 static void __init chacha20_fpu_init(void)
 {
@@ -33,6 +36,7 @@ static inline bool hchacha20_arch(u32 derived_key[CHACHA20_KEY_WORDS],
 {
 	return false;
 }
+#endif
 
 #define QUARTER_ROUND(x, a, b, c, d) ( \
 	x[a] += x[b], \
-- 
2.19.0
