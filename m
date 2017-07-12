From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 12 Jul 2017 15:44:16 +0100
Message-Id: <20170712144424.19528-4-ard.biesheuvel@linaro.org>
In-Reply-To: <20170712144424.19528-1-ard.biesheuvel@linaro.org>
References: <20170712144424.19528-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [RFC PATCH 03/10] arm64: crypto: avoid register x18 in scalar AES code
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
Cc: mark.rutland@arm.com, labbott@fedoraproject.org, will.deacon@arm.com, dave.martin@arm.com, catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Register x18 is the platform register, and is not unconditionally
classified as a caller save register by the AAPCS64 ABI. So avoid
using it in our AES assembler code, to allow the kernel to use it
as a task_struct pointer.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-cipher-core.S | 55 ++++++++++----------
 1 file changed, 28 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/crypto/aes-cipher-core.S b/arch/arm64/crypto/aes-cipher-core.S
index f2f9cc519309..62c91b9fcd56 100644
--- a/arch/arm64/crypto/aes-cipher-core.S
+++ b/arch/arm64/crypto/aes-cipher-core.S
@@ -17,8 +17,7 @@
 	out		.req	x1
 	in		.req	x2
 	rounds		.req	x3
-	tt		.req	x4
-	lt		.req	x2
+	tt		.req	x2
 
 	.macro		__pair, enc, reg0, reg1, in0, in1e, in1d, shift
 	ubfx		\reg0, \in0, #\shift, #8
@@ -34,17 +33,17 @@
 	.macro		__hround, out0, out1, in0, in1, in2, in3, t0, t1, enc
 	ldp		\out0, \out1, [rk], #8
 
-	__pair		\enc, w13, w14, \in0, \in1, \in3, 0
-	__pair		\enc, w15, w16, \in1, \in2, \in0, 8
-	__pair		\enc, w17, w18, \in2, \in3, \in1, 16
+	__pair		\enc, w12, w13, \in0, \in1, \in3, 0
+	__pair		\enc, w14, w15, \in1, \in2, \in0, 8
+	__pair		\enc, w16, w17, \in2, \in3, \in1, 16
 	__pair		\enc, \t0, \t1, \in3, \in0, \in2, 24
 
-	eor		\out0, \out0, w13
-	eor		\out1, \out1, w14
-	eor		\out0, \out0, w15, ror #24
-	eor		\out1, \out1, w16, ror #24
-	eor		\out0, \out0, w17, ror #16
-	eor		\out1, \out1, w18, ror #16
+	eor		\out0, \out0, w12
+	eor		\out1, \out1, w13
+	eor		\out0, \out0, w14, ror #24
+	eor		\out1, \out1, w15, ror #24
+	eor		\out0, \out0, w16, ror #16
+	eor		\out1, \out1, w17, ror #16
 	eor		\out0, \out0, \t0, ror #8
 	eor		\out1, \out1, \t1, ror #8
 	.endm
@@ -60,42 +59,44 @@
 	.endm
 
 	.macro		do_crypt, round, ttab, ltab
-	ldp		w5, w6, [in]
-	ldp		w7, w8, [in, #8]
-	ldp		w9, w10, [rk], #16
-	ldp		w11, w12, [rk, #-8]
+	ldp		w4, w5, [in]
+	ldp		w6, w7, [in, #8]
+	ldp		w8, w9, [rk], #16
+	ldp		w10, w11, [rk, #-8]
 
+CPU_BE(	rev		w4, w4		)
 CPU_BE(	rev		w5, w5		)
 CPU_BE(	rev		w6, w6		)
 CPU_BE(	rev		w7, w7		)
-CPU_BE(	rev		w8, w8		)
 
+	eor		w4, w4, w8
 	eor		w5, w5, w9
 	eor		w6, w6, w10
 	eor		w7, w7, w11
-	eor		w8, w8, w12
 
 	adr_l		tt, \ttab
-	adr_l		lt, \ltab
 
 	tbnz		rounds, #1, 1f
 
-0:	\round		w9, w10, w11, w12, w5, w6, w7, w8
-	\round		w5, w6, w7, w8, w9, w10, w11, w12
+0:	\round		w8, w9, w10, w11, w4, w5, w6, w7
+	\round		w4, w5, w6, w7, w8, w9, w10, w11
 
 1:	subs		rounds, rounds, #4
-	\round		w9, w10, w11, w12, w5, w6, w7, w8
-	csel		tt, tt, lt, hi
-	\round		w5, w6, w7, w8, w9, w10, w11, w12
-	b.hi		0b
+	\round		w8, w9, w10, w11, w4, w5, w6, w7
+	b.ls		2f
+	\round		w4, w5, w6, w7, w8, w9, w10, w11
+	b		0b
 
+2:	adr_l		tt, \ltab
+	\round		w4, w5, w6, w7, w8, w9, w10, w11
+
+CPU_BE(	rev		w4, w4		)
 CPU_BE(	rev		w5, w5		)
 CPU_BE(	rev		w6, w6		)
 CPU_BE(	rev		w7, w7		)
-CPU_BE(	rev		w8, w8		)
 
-	stp		w5, w6, [out]
-	stp		w7, w8, [out, #8]
+	stp		w4, w5, [out]
+	stp		w6, w7, [out, #8]
 	ret
 	.endm
 
-- 
2.9.3
