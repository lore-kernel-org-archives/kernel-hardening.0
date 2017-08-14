From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 14 Aug 2017 13:53:49 +0100
Message-Id: <20170814125411.22604-9-ard.biesheuvel@linaro.org>
In-Reply-To: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 08/30] ARM: sleep.S: use PC-relative insn sequence for sleep_save_sp/mpidr_hash
To: kernel-hardening@lists.openwall.com
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Replace the open coded PC relative offset calculations with adr_l and
ldr_l invocations.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/kernel/sleep.S | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/arm/kernel/sleep.S b/arch/arm/kernel/sleep.S
index 0f6c1000582c..3026b119d3ff 100644
--- a/arch/arm/kernel/sleep.S
+++ b/arch/arm/kernel/sleep.S
@@ -137,9 +137,8 @@ ARM_BE8(setend be)			@ ensure we are in BE mode
 	mov	r1, #0
 	ALT_SMP(mrc p15, 0, r0, c0, c0, 5)
 	ALT_UP_B(1f)
-	adr	r2, mpidr_hash_ptr
-	ldr	r3, [r2]
-	add	r2, r2, r3		@ r2 = struct mpidr_hash phys address
+	adr_l	r2, mpidr_hash		@ r2 = struct mpidr_hash phys address
+
 	/*
 	 * This ldmia relies on the memory layout of the mpidr_hash
 	 * struct mpidr_hash.
@@ -147,10 +146,7 @@ ARM_BE8(setend be)			@ ensure we are in BE mode
 	ldmia	r2, { r3-r6 }	@ r3 = mpidr mask (r4,r5,r6) = l[0,1,2] shifts
 	compute_mpidr_hash	r1, r4, r5, r6, r0, r3
 1:
-	adr	r0, _sleep_save_sp
-	ldr	r2, [r0]
-	add	r0, r0, r2
-	ldr	r0, [r0, #SLEEP_SAVE_SP_PHYS]
+	ldr_l	r0, sleep_save_sp + SLEEP_SAVE_SP_PHYS
 	ldr	r0, [r0, r1, lsl #2]
 
 	@ load phys pgd, stack, resume fn
@@ -164,12 +160,6 @@ ENDPROC(cpu_resume)
 ENDPROC(cpu_resume_arm)
 #endif
 
-	.align 2
-_sleep_save_sp:
-	.long	sleep_save_sp - .
-mpidr_hash_ptr:
-	.long	mpidr_hash - .			@ mpidr_hash struct offset
-
 	.data
 	.type	sleep_save_sp, #object
 ENTRY(sleep_save_sp)
-- 
2.11.0
