Reply-To: kernel-hardening@lists.openwall.com
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 12 Aug 2016 16:27:41 +0100
Message-Id: <1471015666-23125-3-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
References: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] [PATCH 2/7] arm64: Factor out TTBR0_EL1 setting into a specific asm macro
To: linux-arm-kernel@lists.infradead.org
Cc: kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

This patch takes the TTBR0_EL1 setting code out of cpu_do_switch_mm into
a dedicated cpu_set_ttbr0 macro which will be reused in a subsequent
patch.

Cc: Will Deacon <will.deacon@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/assembler.h | 25 +++++++++++++++++++++++++
 arch/arm64/mm/proc.S               | 16 +---------------
 2 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index bbed373f4ab7..039db634a693 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -352,6 +352,31 @@ alternative_endif
 	.endm
 
 /*
+ * TTBR0_EL1 update macro.
+ */
+	.macro	cpu_set_ttbr0, ttbr0, errata = 0, ret = 0
+	msr	ttbr0_el1, \ttbr0
+	isb
+	.if	\errata
+alternative_if_not ARM64_WORKAROUND_CAVIUM_27456
+	.if	\ret
+	ret
+	.endif
+	nop
+	nop
+	nop
+alternative_else
+	ic	iallu
+	dsb	nsh
+	isb
+	.if	\ret
+	ret
+	.endif
+alternative_endif
+	.endif
+	.endm
+
+/*
  * User access enabling/disabling macros.
  */
 	.macro	uaccess_disable, tmp1
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 5bb61de23201..442ade0f44eb 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -25,8 +25,6 @@
 #include <asm/hwcap.h>
 #include <asm/pgtable.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/cpufeature.h>
-#include <asm/alternative.h>
 
 #ifdef CONFIG_ARM64_64K_PAGES
 #define TCR_TG_FLAGS	TCR_TG0_64K | TCR_TG1_64K
@@ -123,19 +121,7 @@ ENDPROC(cpu_do_resume)
 ENTRY(cpu_do_switch_mm)
 	mmid	x1, x1				// get mm->context.id
 	bfi	x0, x1, #48, #16		// set the ASID
-	msr	ttbr0_el1, x0			// set TTBR0
-	isb
-alternative_if_not ARM64_WORKAROUND_CAVIUM_27456
-	ret
-	nop
-	nop
-	nop
-alternative_else
-	ic	iallu
-	dsb	nsh
-	isb
-	ret
-alternative_endif
+	cpu_set_ttbr0 x0, errata = 1, ret = 1
 ENDPROC(cpu_do_switch_mm)
 
 	.pushsection ".idmap.text", "ax"
