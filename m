From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Sun,  3 Sep 2017 13:07:49 +0100
Message-Id: <20170903120757.14968-22-ard.biesheuvel@linaro.org>
In-Reply-To: <20170903120757.14968-1-ard.biesheuvel@linaro.org>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v2 21/29] ARM: kernel: use PC relative symbol references in suspend/resume code
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Replace some unnecessary absolute references with relative ones. Also,
to prepare for runtime relocation, which occurs with the caches on,
defer taking the absolute address of cpu_resume_after_mmu() until after
the MMU is enabled.

Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/kernel/sleep.S | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/sleep.S b/arch/arm/kernel/sleep.S
index f4920b5d0fc4..5b02744f2f12 100644
--- a/arch/arm/kernel/sleep.S
+++ b/arch/arm/kernel/sleep.S
@@ -60,15 +60,14 @@
 ENTRY(__cpu_suspend)
 	stmfd	sp!, {r4 - r11, lr}
 #ifdef MULTI_CPU
-	ldr	r10, =processor
-	ldr	r4, [r10, #CPU_SLEEP_SIZE] @ size of CPU sleep state
+	ldr_l	r4, processor + CPU_SLEEP_SIZE	@ size of CPU sleep state
 #else
-	ldr	r4, =cpu_suspend_size
+	adr_l	r4, cpu_suspend_size
 #endif
 	mov	r5, sp			@ current virtual SP
 	add	r4, r4, #12		@ Space for pgd, virt sp, phys resume fn
 	sub	sp, sp, r4		@ allocate CPU state on stack
-	ldr	r3, =sleep_save_sp
+	adr_l	r3, sleep_save_sp
 	stmfd	sp!, {r0, r1}		@ save suspend func arg and pointer
 	ldr	r3, [r3, #SLEEP_SAVE_SP_VIRT]
 	ALT_SMP(W(nop))			@ don't use adr_l inside ALT_SMP()
@@ -101,13 +100,13 @@ ENDPROC(cpu_suspend_abort)
 	.align	5
 	.pushsection	.idmap.text,"ax"
 ENTRY(cpu_resume_mmu)
-	ldr	r3, =cpu_resume_after_mmu
 	instr_sync
 	mcr	p15, 0, r0, c1, c0, 0	@ turn on MMU, I-cache, etc
 	mrc	p15, 0, r0, c0, c0, 0	@ read id reg
 	instr_sync
 	mov	r0, r0
 	mov	r0, r0
+	ldr	r3, =cpu_resume_after_mmu
 	ret	r3			@ jump to virtual address
 ENDPROC(cpu_resume_mmu)
 	.popsection
-- 
2.11.0
