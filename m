From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 14 Aug 2017 13:53:47 +0100
Message-Id: <20170814125411.22604-7-ard.biesheuvel@linaro.org>
In-Reply-To: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 06/30] ARM: kernel: use relative references for UP/SMP alternatives
To: kernel-hardening@lists.openwall.com
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

To avoid absolute references that are subject to runtime relocation
when running a kernel built with CONFIG_RELOCATABLE=y, use relative
references in the smp.alt entries.

Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/include/asm/assembler.h |  4 ++--
 arch/arm/include/asm/processor.h |  2 +-
 arch/arm/kernel/head.S           | 10 +++++-----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 516ebaf4ff38..3176bf7dcbd9 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -260,7 +260,7 @@
  */
 #define ALT_UP(instr...)					\
 	.pushsection ".alt.smp.init", "a"			;\
-	.long	9998b						;\
+	.long	9998b - .					;\
 9997:	instr							;\
 	.if . - 9997b == 2					;\
 		nop						;\
@@ -272,7 +272,7 @@
 #define ALT_UP_B(label)					\
 	.equ	up_b_offset, label - 9998b			;\
 	.pushsection ".alt.smp.init", "a"			;\
-	.long	9998b						;\
+	.long	9998b - .					;\
 	W(b)	. + up_b_offset					;\
 	.popsection
 #else
diff --git a/arch/arm/include/asm/processor.h b/arch/arm/include/asm/processor.h
index c3d5fc124a05..3667b395bb17 100644
--- a/arch/arm/include/asm/processor.h
+++ b/arch/arm/include/asm/processor.h
@@ -92,7 +92,7 @@ unsigned long get_wchan(struct task_struct *p);
 #define __ALT_SMP_ASM(smp, up)						\
 	"9998:	" smp "\n"						\
 	"	.pushsection \".alt.smp.init\", \"a\"\n"		\
-	"	.long	9998b\n"					\
+	"	.long	9998b - .\n"					\
 	"	" up "\n"						\
 	"	.popsection\n"
 #else
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 6e9df3663a57..ec22f42fd8bb 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -548,14 +548,15 @@ smp_on_up:
 __do_fixup_smp_on_up:
 	cmp	r4, r5
 	reths	lr
-	ldmia	r4!, {r0, r6}
- ARM(	str	r6, [r0, r3]	)
- THUMB(	add	r0, r0, r3	)
+	ldmia	r4, {r0, r6}
+ ARM(	str	r6, [r0, r4]	)
+ THUMB(	add	r0, r0, r4	)
+	add	r4, r4, #8
 #ifdef __ARMEB__
  THUMB(	mov	r6, r6, ror #16	)	@ Convert word order for big-endian.
 #endif
  THUMB(	strh	r6, [r0], #2	)	@ For Thumb-2, store as two halfwords
- THUMB(	mov	r6, r6, lsr #16	)	@ to be robust against misaligned r3.
+ THUMB(	mov	r6, r6, lsr #16	)	@ to be robust against misaligned r0.
  THUMB(	strh	r6, [r0]	)
 	b	__do_fixup_smp_on_up
 ENDPROC(__do_fixup_smp_on_up)
@@ -564,7 +565,6 @@ ENTRY(fixup_smp)
 	stmfd	sp!, {r4 - r6, lr}
 	mov	r4, r0
 	add	r5, r0, r1
-	mov	r3, #0
 	bl	__do_fixup_smp_on_up
 	ldmfd	sp!, {r4 - r6, pc}
 ENDPROC(fixup_smp)
-- 
2.11.0
