From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 14 Aug 2017 13:53:58 +0100
Message-Id: <20170814125411.22604-18-ard.biesheuvel@linaro.org>
In-Reply-To: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 17/30] arm-soc: tegra: make sleep asm code runtime relocatable
To: kernel-hardening@lists.openwall.com
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

The PIE kernel build does not allow absolute references encoded in
movw/movt instruction pairs, so use our mov_l macro instead (which
will still use such a pair unless CONFIG_RELOCATABLE is defined)

Also, avoid 32-bit absolute literals to refer to absolute symbols.
Instead, use a 16 bit reference so that PIE linker cannot get
confused whether the symbol reference is subject to relocation at
runtime.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/mach-tegra/sleep-tegra20.S | 22 ++++++++++++--------
 arch/arm/mach-tegra/sleep-tegra30.S |  6 +++---
 arch/arm/mach-tegra/sleep.S         |  4 ++--
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-tegra/sleep-tegra20.S b/arch/arm/mach-tegra/sleep-tegra20.S
index 5c8e638ee51a..cab95de5c8f1 100644
--- a/arch/arm/mach-tegra/sleep-tegra20.S
+++ b/arch/arm/mach-tegra/sleep-tegra20.S
@@ -99,7 +99,7 @@ ENTRY(tegra20_cpu_shutdown)
 	cmp	r0, #0
 	reteq	lr			@ must not be called for CPU 0
 	mov32	r1, TEGRA_IRAM_RESET_BASE_VIRT
-	ldr	r2, =__tegra20_cpu1_resettable_status_offset
+	ldrh	r2, 0f
 	mov	r12, #CPU_RESETTABLE
 	strb	r12, [r1, r2]
 
@@ -121,6 +121,7 @@ ENTRY(tegra20_cpu_shutdown)
 	beq	.
 	ret	lr
 ENDPROC(tegra20_cpu_shutdown)
+0:	.short	__tegra20_cpu1_resettable_status_offset
 #endif
 
 #ifdef CONFIG_PM_SLEEP
@@ -181,6 +182,9 @@ ENTRY(tegra_pen_unlock)
 	ret     lr
 ENDPROC(tegra_pen_unlock)
 
+.L__tegra20_cpu1_resettable_status_offset:
+	.short	__tegra20_cpu1_resettable_status_offset
+
 /*
  * tegra20_cpu_clear_resettable(void)
  *
@@ -189,7 +193,7 @@ ENDPROC(tegra_pen_unlock)
  */
 ENTRY(tegra20_cpu_clear_resettable)
 	mov32	r1, TEGRA_IRAM_RESET_BASE_VIRT
-	ldr	r2, =__tegra20_cpu1_resettable_status_offset
+	ldrh	r2, .L__tegra20_cpu1_resettable_status_offset
 	mov	r12, #CPU_NOT_RESETTABLE
 	strb	r12, [r1, r2]
 	ret	lr
@@ -203,7 +207,7 @@ ENDPROC(tegra20_cpu_clear_resettable)
  */
 ENTRY(tegra20_cpu_set_resettable_soon)
 	mov32	r1, TEGRA_IRAM_RESET_BASE_VIRT
-	ldr	r2, =__tegra20_cpu1_resettable_status_offset
+	ldrh	r2, .L__tegra20_cpu1_resettable_status_offset
 	mov	r12, #CPU_RESETTABLE_SOON
 	strb	r12, [r1, r2]
 	ret	lr
@@ -217,7 +221,7 @@ ENDPROC(tegra20_cpu_set_resettable_soon)
  */
 ENTRY(tegra20_cpu_is_resettable_soon)
 	mov32	r1, TEGRA_IRAM_RESET_BASE_VIRT
-	ldr	r2, =__tegra20_cpu1_resettable_status_offset
+	ldrh	r2, .L__tegra20_cpu1_resettable_status_offset
 	ldrb	r12, [r1, r2]
 	cmp	r12, #CPU_RESETTABLE_SOON
 	moveq	r0, #1
@@ -238,11 +242,11 @@ ENTRY(tegra20_sleep_core_finish)
 	bl	tegra_disable_clean_inv_dcache
 	mov     r0, r4
 
-	mov32	r3, tegra_shut_off_mmu
+	mov_l	r3, tegra_shut_off_mmu
 	add	r3, r3, r0
 
-	mov32	r0, tegra20_tear_down_core
-	mov32	r1, tegra20_iram_start
+	mov_l	r0, tegra20_tear_down_core
+	mov_l	r1, tegra20_iram_start
 	sub	r0, r0, r1
 	mov32	r1, TEGRA_IRAM_LPx_RESUME_AREA
 	add	r0, r0, r1
@@ -265,7 +269,7 @@ ENTRY(tegra20_sleep_cpu_secondary_finish)
 	bl	tegra_disable_clean_inv_dcache
 
 	mov32	r0, TEGRA_IRAM_RESET_BASE_VIRT
-	ldr	r4, =__tegra20_cpu1_resettable_status_offset
+	ldrh	r4, .L__tegra20_cpu1_resettable_status_offset
 	mov	r3, #CPU_RESETTABLE
 	strb	r3, [r0, r4]
 
@@ -284,7 +288,7 @@ ENTRY(tegra20_sleep_cpu_secondary_finish)
 	bl	tegra_pen_lock
 
 	mov32	r0, TEGRA_IRAM_RESET_BASE_VIRT
-	ldr	r4, =__tegra20_cpu1_resettable_status_offset
+	ldrh	r4, .L__tegra20_cpu1_resettable_status_offset
 	mov	r3, #CPU_NOT_RESETTABLE
 	strb	r3, [r0, r4]
 
diff --git a/arch/arm/mach-tegra/sleep-tegra30.S b/arch/arm/mach-tegra/sleep-tegra30.S
index dd4a67dabd91..478b2ca3ef6e 100644
--- a/arch/arm/mach-tegra/sleep-tegra30.S
+++ b/arch/arm/mach-tegra/sleep-tegra30.S
@@ -261,11 +261,11 @@ ENTRY(tegra30_sleep_core_finish)
 	mov32	r6, TEGRA_FLOW_CTRL_BASE
 	mov32	r7, TEGRA_TMRUS_BASE
 
-	mov32	r3, tegra_shut_off_mmu
+	mov_l	r3, tegra_shut_off_mmu
 	add	r3, r3, r0
 
-	mov32	r0, tegra30_tear_down_core
-	mov32	r1, tegra30_iram_start
+	mov_l	r0, tegra30_tear_down_core
+	mov_l	r1, tegra30_iram_start
 	sub	r0, r0, r1
 	mov32	r1, TEGRA_IRAM_LPx_RESUME_AREA
 	add	r0, r0, r1
diff --git a/arch/arm/mach-tegra/sleep.S b/arch/arm/mach-tegra/sleep.S
index 5e3496753df1..785df3edc767 100644
--- a/arch/arm/mach-tegra/sleep.S
+++ b/arch/arm/mach-tegra/sleep.S
@@ -101,11 +101,11 @@ ENTRY(tegra_sleep_cpu_finish)
 	bl	tegra_disable_clean_inv_dcache
 
 	mov	r0, r4
-	mov32	r6, tegra_tear_down_cpu
+	mov_l	r6, tegra_tear_down_cpu
 	ldr	r1, [r6]
 	add	r1, r1, r0
 
-	mov32	r3, tegra_shut_off_mmu
+	mov_l	r3, tegra_shut_off_mmu
 	add	r3, r3, r0
 	mov	r0, r1
 
-- 
2.11.0
