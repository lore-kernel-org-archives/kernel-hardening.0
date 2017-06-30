From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 30 Jun 2017 18:03:59 +0200
Message-Id: <20170630160450.4093529-1-arnd@arndb.de>
Subject: [kernel-hardening] [PATCH v2] ARM: fix randomized task_struct
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

With the new task struct randomization, we can run into a build
failure for certain random seeds:

arch/arm/kernel/entry-armv.S: Assembler messages:
arch/arm/kernel/entry-armv.S:803: Error: bad immediate value for offset (4096)

Only two constants in asm-offset.h are affected, and I'm changing
both of them here to work correctly in all configurations.

One more macro has the problem, but is currently unused, so this
removes it instead of adding complexity.

Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Fixes: c33d8b12fbbd ("task_struct: Allow randomized layout")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: define a more appropriate macro instead of PAGE_MASK,
    fix always-true comparison to test the right thing
---
 arch/arm/include/asm/assembler.h |  2 ++
 arch/arm/kernel/entry-armv.S     |  5 ++++-
 arch/arm/mm/proc-macros.S        | 10 ++++------
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 68b06f9c65de..ad301f107dd2 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -87,6 +87,8 @@
 #define CALGN(code...)
 #endif
 
+#define IMM12_MASK 0xfff
+
 /*
  * Enable and disable interrupts
  */
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 9f157e7c51e7..c731f0d2b2af 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -797,7 +797,10 @@ ENTRY(__switch_to)
 #if defined(CONFIG_CC_STACKPROTECTOR) && !defined(CONFIG_SMP)
 	ldr	r7, [r2, #TI_TASK]
 	ldr	r8, =__stack_chk_guard
-	ldr	r7, [r7, #TSK_STACK_CANARY]
+	.if (TSK_STACK_CANARY > IMM12_MASK)
+	add	r7, r7, #TSK_STACK_CANARY & ~IMM12_MASK
+	.endif
+	ldr	r7, [r7, #TSK_STACK_CANARY & IMM12_MASK]
 #endif
 #ifdef CONFIG_CPU_USE_DOMAINS
 	mcr	p15, 0, r6, c3, c0, 0		@ Set domain register
diff --git a/arch/arm/mm/proc-macros.S b/arch/arm/mm/proc-macros.S
index 0d40c285bd86..f944836da8a2 100644
--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -25,11 +25,6 @@
 	ldr	\rd, [\rn, #VMA_VM_FLAGS]
 	.endm
 
-	.macro	tsk_mm, rd, rn
-	ldr	\rd, [\rn, #TI_TASK]
-	ldr	\rd, [\rd, #TSK_ACTIVE_MM]
-	.endm
-
 /*
  * act_mm - get current->active_mm
  */
@@ -37,7 +32,10 @@
 	bic	\rd, sp, #8128
 	bic	\rd, \rd, #63
 	ldr	\rd, [\rd, #TI_TASK]
-	ldr	\rd, [\rd, #TSK_ACTIVE_MM]
+	.if (TSK_ACTIVE_MM > IMM12_MASK)
+	add	\rd, \rd, #TSK_ACTIVE_MM & ~IMM12_MASK
+	.endif
+	ldr	\rd, [\rd, #TSK_ACTIVE_MM & IMM12_MASK]
 	.endm
 
 /*
-- 
2.9.0
