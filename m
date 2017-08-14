From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 14 Aug 2017 13:54:01 +0100
Message-Id: <20170814125411.22604-21-ard.biesheuvel@linaro.org>
In-Reply-To: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 20/30] ARM: kernel: use PC relative symbol references in suspend/resume code
To: kernel-hardening@lists.openwall.com
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Replace some unnecessary absolute references with relative ones. Also,
to prepare for runtime relocation, which occurs with the caches on,
defer taking the absolute address of cpu_resume_after_mmu() until after
the MMU is enabled.

Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/kernel/sleep.S | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kernel/sleep.S b/arch/arm/kernel/sleep.S
index 3026b119d3ff..9efd1c7d3552 100644
--- a/arch/arm/kernel/sleep.S
+++ b/arch/arm/kernel/sleep.S
@@ -60,18 +60,17 @@
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
-	ALT_SMP(ldr r0, =mpidr_hash)
+	ALT_SMP(adr_l r0, mpidr_hash)
 	ALT_UP_B(1f)
 	/* This ldmia relies on the memory layout of the mpidr_hash struct */
 	ldmia	r0, {r1, r6-r8}	@ r1 = mpidr mask (r6,r7,r8) = l[0,1,2] shifts
@@ -100,13 +99,13 @@ ENDPROC(cpu_suspend_abort)
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
