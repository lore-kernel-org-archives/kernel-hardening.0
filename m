From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 14 Aug 2017 13:53:53 +0100
Message-Id: <20170814125411.22604-13-ard.biesheuvel@linaro.org>
In-Reply-To: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 12/30] arm-soc: exynos: replace open coded VA->PA conversions
To: kernel-hardening@lists.openwall.com
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

This replaces a couple of open coded calculations to obtain the
physical address of a far symbol with calls to the new adr_l etc
macros.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/mach-exynos/headsmp.S |  9 +------
 arch/arm/mach-exynos/sleep.S   | 26 ++++----------------
 2 files changed, 6 insertions(+), 29 deletions(-)

diff --git a/arch/arm/mach-exynos/headsmp.S b/arch/arm/mach-exynos/headsmp.S
index d3d24ab351ae..25de5aff1c41 100644
--- a/arch/arm/mach-exynos/headsmp.S
+++ b/arch/arm/mach-exynos/headsmp.S
@@ -23,10 +23,7 @@ ENTRY(exynos4_secondary_startup)
 ARM_BE8(setend	be)
 	mrc	p15, 0, r0, c0, c0, 5
 	and	r0, r0, #15
-	adr	r4, 1f
-	ldmia	r4, {r5, r6}
-	sub	r4, r4, r5
-	add	r6, r6, r4
+	adr_l	r6, pen_release
 pen:	ldr	r7, [r6]
 	cmp	r7, r0
 	bne	pen
@@ -37,7 +34,3 @@ pen:	ldr	r7, [r6]
 	 */
 	b	secondary_startup
 ENDPROC(exynos4_secondary_startup)
-
-	.align 2
-1:	.long	.
-	.long	pen_release
diff --git a/arch/arm/mach-exynos/sleep.S b/arch/arm/mach-exynos/sleep.S
index cf950790fbdc..003465699263 100644
--- a/arch/arm/mach-exynos/sleep.S
+++ b/arch/arm/mach-exynos/sleep.S
@@ -17,6 +17,7 @@
 
 #include <linux/linkage.h>
 #include <asm/asm-offsets.h>
+#include <asm/assembler.h>
 #include <asm/hardware/cache-l2x0.h>
 #include "smc.h"
 
@@ -62,19 +63,13 @@ ENTRY(exynos_cpu_resume_ns)
 	cmp	r0, r1
 	bne	skip_cp15
 
-	adr	r0, _cp15_save_power
-	ldr	r1, [r0]
-	ldr	r1, [r0, r1]
-	adr	r0, _cp15_save_diag
-	ldr	r2, [r0]
-	ldr	r2, [r0, r2]
+	ldr_l	r1, cp15_save_power
+	ldr_l	r2, cp15_save_diag
 	mov	r0, #SMC_CMD_C15RESUME
 	dsb
 	smc	#0
 #ifdef CONFIG_CACHE_L2X0
-	adr	r0, 1f
-	ldr	r2, [r0]
-	add	r0, r2, r0
+	adr_l	r0, l2x0_saved_regs
 
 	/* Check that the address has been initialised. */
 	ldr	r1, [r0, #L2X0_R_PHY_BASE]
@@ -93,9 +88,7 @@ ENTRY(exynos_cpu_resume_ns)
 	smc	#0
 
 	/* Reload saved regs pointer because smc corrupts registers. */
-	adr	r0, 1f
-	ldr	r2, [r0]
-	add	r0, r2, r0
+	adr_l	r0, l2x0_saved_regs
 
 	ldr	r1, [r0, #L2X0_R_PWR_CTRL]
 	ldr	r2, [r0, #L2X0_R_AUX_CTRL]
@@ -114,15 +107,6 @@ skip_cp15:
 	b	cpu_resume
 ENDPROC(exynos_cpu_resume_ns)
 
-	.align
-_cp15_save_power:
-	.long	cp15_save_power - .
-_cp15_save_diag:
-	.long	cp15_save_diag - .
-#ifdef CONFIG_CACHE_L2X0
-1:	.long	l2x0_saved_regs - .
-#endif /* CONFIG_CACHE_L2X0 */
-
 	.data
 	.globl cp15_save_diag
 cp15_save_diag:
-- 
2.11.0
