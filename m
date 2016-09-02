Reply-To: kernel-hardening@lists.openwall.com
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri,  2 Sep 2016 16:02:08 +0100
Message-Id: <1472828533-28197-3-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1472828533-28197-1-git-send-email-catalin.marinas@arm.com>
References: <1472828533-28197-1-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] [PATCH v2 2/7] arm64: Factor out TTBR0_EL1 post-update workaround into a specific asm macro
To: linux-arm-kernel@lists.infradead.org
Cc: kernel-hardening@lists.openwall.com, AKASHI Takahiro <takahiro.akashi@linaro.org>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

This patch takes the errata workaround code out of cpu_do_switch_mm into
a dedicated post_ttbr0_update_workaround macro which will be reused in a
subsequent patch.

Cc: Will Deacon <will.deacon@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/assembler.h | 21 +++++++++++++++++++++
 arch/arm64/mm/proc.S               | 12 +-----------
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index d5025c69ca81..b16bbf1fb786 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -350,4 +350,25 @@ alternative_endif
 	movk	\reg, :abs_g0_nc:\val
 	.endm
 
+/*
+ * Errata workaround post TTBR0_EL1 update.
+ */
+	.macro	post_ttbr0_update_workaround, ret = 0
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
+	.endm
+
 #endif	/* __ASM_ASSEMBLER_H */
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 5bb61de23201..9359659f2559 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -125,17 +125,7 @@ ENTRY(cpu_do_switch_mm)
 	bfi	x0, x1, #48, #16		// set the ASID
 	msr	ttbr0_el1, x0			// set TTBR0
 	isb
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
+	post_ttbr0_update_workaround ret = 1
 ENDPROC(cpu_do_switch_mm)
 
 	.pushsection ".idmap.text", "ax"
