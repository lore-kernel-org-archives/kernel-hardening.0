From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 14 Aug 2017 13:53:57 +0100
Message-Id: <20170814125411.22604-17-ard.biesheuvel@linaro.org>
In-Reply-To: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 16/30] ARM: kernel: use relative phys-to-virt patch tables
To: kernel-hardening@lists.openwall.com
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Replace the contents of the __pv_table entries with relative references
so that we don't have to relocate them at runtime when running the KASLR
kernel. This ensures these quantities are invariant under runtime
relocation, which makes any cache maintenance after runtime relocation
unnecessary.

Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/include/asm/memory.h |  6 +++---
 arch/arm/kernel/head.S        | 21 ++++++++++----------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index 1f54e4e98c1e..47a984e3a244 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -195,7 +195,7 @@ extern const void *__pv_table_begin, *__pv_table_end;
 	__asm__("@ __pv_stub\n"				\
 	"1:	" instr "	%0, %1, %2\n"		\
 	"	.pushsection .pv_table,\"a\"\n"		\
-	"	.long	1b\n"				\
+	"	.long	1b - .\n"			\
 	"	.popsection\n"				\
 	: "=r" (to)					\
 	: "r" (from), "I" (type))
@@ -204,7 +204,7 @@ extern const void *__pv_table_begin, *__pv_table_end;
 	__asm__ volatile("@ __pv_stub_mov\n"		\
 	"1:	mov	%R0, %1\n"			\
 	"	.pushsection .pv_table,\"a\"\n"		\
-	"	.long	1b\n"				\
+	"	.long	1b - .\n"			\
 	"	.popsection\n"				\
 	: "=r" (t)					\
 	: "I" (__PV_BITS_7_0))
@@ -214,7 +214,7 @@ extern const void *__pv_table_begin, *__pv_table_end;
 	"1:	adds	%Q0, %1, %2\n"			\
 	"	adc	%R0, %R0, #0\n"			\
 	"	.pushsection .pv_table,\"a\"\n"		\
-	"	.long	1b\n"				\
+	"	.long	1b - .\n"			\
 	"	.popsection\n"				\
 	: "+r" (y)					\
 	: "r" (x), "I" (__PV_BITS_31_24)		\
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 62c961849035..5d685e86148c 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -593,8 +593,7 @@ ENDPROC(__fixup_pv_table)
 
 	.text
 __fixup_a_pv_table:
-	mov_l	r6, __pv_offset
-	add	r6, r6, r3
+	adr_l	r6, __pv_offset
 	ldr	r0, [r6, #HIGH_OFFSET]	@ pv_offset high word
 	ldr	r6, [r6, #LOW_OFFSET]	@ pv_offset low word
 	mov	r6, r6, lsr #24
@@ -612,22 +611,22 @@ __fixup_a_pv_table:
 	orr	r6, r6, r7, lsl #12
 	orr	r6, #0x4000
 	b	2f
-1:	add     r7, r3
-	ldrh	ip, [r7, #2]
+1:	add	r7, r4
+	ldrh	ip, [r7, #-2]
 ARM_BE8(rev16	ip, ip)
 	tst	ip, #0x4000
 	and	ip, #0x8f00
 	orrne	ip, r6	@ mask in offset bits 31-24
 	orreq	ip, r0	@ mask in offset bits 7-0
 ARM_BE8(rev16	ip, ip)
-	strh	ip, [r7, #2]
+	strh	ip, [r7, #-2]
 	bne	2f
-	ldrh	ip, [r7]
+	ldrh	ip, [r7, #-4]
 ARM_BE8(rev16	ip, ip)
 	bic	ip, #0x20
 	orr	ip, ip, r0, lsr #16
 ARM_BE8(rev16	ip, ip)
-	strh	ip, [r7]
+	strh	ip, [r7, #-4]
 2:	cmp	r4, r5
 	ldrcc	r7, [r4], #4	@ use branch for delay slot
 	bcc	1b
@@ -639,7 +638,8 @@ ARM_BE8(rev16	ip, ip)
 	moveq	r0, #0x400000	@ set bit 22, mov to mvn instruction
 #endif
 	b	2f
-1:	ldr	ip, [r7, r3]
+1:	ldr	ip, [r7, r4]!
+	add	r4, r4, #4
 #ifdef CONFIG_CPU_ENDIAN_BE8
 	@ in BE8, we load data in BE, but instructions still in LE
 	bic	ip, ip, #0xff000000
@@ -654,9 +654,9 @@ ARM_BE8(rev16	ip, ip)
 	biceq	ip, ip, #0x400000	@ clear bit 22
 	orreq	ip, ip, r0	@ mask in offset bits 7-0
 #endif
-	str	ip, [r7, r3]
+	str	ip, [r7]
 2:	cmp	r4, r5
-	ldrcc	r7, [r4], #4	@ use branch for delay slot
+	ldrcc	r7, [r4]	@ use branch for delay slot
 	bcc	1b
 	ret	lr
 #endif
@@ -664,7 +664,6 @@ ENDPROC(__fixup_a_pv_table)
 
 ENTRY(fixup_pv_table)
 	stmfd	sp!, {r4 - r7, lr}
-	mov	r3, #0			@ no offset
 	mov	r4, r0			@ r0 = table start
 	add	r5, r0, r1		@ r1 = table size
 	bl	__fixup_a_pv_table
-- 
2.11.0
