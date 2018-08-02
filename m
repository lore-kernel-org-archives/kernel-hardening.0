From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC/PoC PATCH 3/3] arm64: enable ROP protection by clearing SP bit #55 across function returns
Date: Thu,  2 Aug 2018 15:21:32 +0200
Message-Id: <20180802132133.23999-4-ard.biesheuvel@linaro.org>
In-Reply-To: <20180802132133.23999-1-ard.biesheuvel@linaro.org>
References: <20180802132133.23999-1-ard.biesheuvel@linaro.org>
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, christoffer.dall@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, labbott@fedoraproject.org, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

ROP attacks rely on a large supply of so-called 'gadgets', which are
(in this context) short sequences of instructions ending in a stack
pop and a return instruction. By exploiting a stack overflow to create
a specially crafted stack frame, each gadget jumps to the next by
popping off the next gadget's address as a fake return address,
allowing non-trivial 'programs' to be executed by piecing together
a large number of such gadgets.

This attack vector relies heavily on the ability to jump to arbitrary
places in the code. If we could limit where a function could return to,
it is much more difficult to obtain critical mass in terms of a gadget
collection that allows arbitrary attacks to be mounted.

So let's try and do so by clearing bit #55 in the stack pointer register
before returning from a function, and setting it again right after a
'bl' or 'blr' instruction. That way, jumping to arbitrary places in the
code and popping the next gadget's address becomes a lot more complicated,
since the stack pointer will not be valid after a function return until
the 'reset' sequence is executed (or after an exception is taken).

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Kconfig                 | 10 ++++++++++
 arch/arm64/include/asm/assembler.h |  9 +++++++++
 arch/arm64/kernel/entry.S          | 18 ++++++++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 42c090cf0292..4562af0250b9 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1011,6 +1011,16 @@ config ARM64_SW_TTBR0_PAN
 	  zeroed area and reserved ASID. The user access routines
 	  restore the valid TTBR0_EL1 temporarily.
 
+config ARM64_ROP_SHIELD
+	bool "Enable basic ROP protection through the stack pointer sign bit"
+	depends on GCC_PLUGINS && VMAP_STACK
+	select GCC_PLUGIN_ARM64_ROP_SHIELD
+	help
+	  Enable protection against ROP attacks by clearing bit #55 in the
+	  stack pointer register across a function return.
+
+	  If paranoid, say Y here. If unsure, say N.
+
 menu "ARMv8.1 architectural features"
 
 config ARM64_HW_AFDBM
diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 346ada4de48a..95d3ec98eb58 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -701,12 +701,21 @@ USER(\label, ic	ivau, \tmp2)			// invalidate I line PoU
 .Lyield_out_\@ :
 	.endm
 
+	.macro		unclobber_sp, tmp
+#ifdef CONFIG_ARM64_ROP_SHIELD
+	mov		\tmp, sp
+	orr		sp, \tmp, #(1 << 55)
+#endif
+	.endm
+
 	.macro		bl_c, target
 	bl		\target
+	unclobber_sp	x30
 	.endm
 
 	.macro		blr_c, reg
 	blr		\reg
+	unclobber_sp	x30
 	.endm
 
 #endif	/* __ASM_ASSEMBLER_H */
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index eba5b6b528ea..2adebca74f11 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -95,6 +95,9 @@ alternative_else_nop_endif
 	 */
 	add	sp, sp, x0			// sp' = sp + x0
 	sub	x0, sp, x0			// x0' = sp' - x0 = (sp + x0) - x0 = sp
+#ifdef CONFIG_ARM64_ROP_SHIELD
+	tbz	x0, #55, 1f
+#endif
 	tbnz	x0, #THREAD_SHIFT, 0f
 	sub	x0, sp, x0			// x0'' = sp' - x0' = (sp + x0) - sp = x0
 	sub	sp, sp, x0			// sp'' = sp' - x0 = (sp + x0) - x0 = sp
@@ -129,6 +132,21 @@ alternative_else_nop_endif
 	/* We were already on the overflow stack. Restore sp/x0 and carry on. */
 	sub	sp, sp, x0
 	mrs	x0, tpidrro_el0
+	b	el\()\el\()_\label
+
+#ifdef CONFIG_ARM64_ROP_SHIELD
+1:	/*
+	 * We have to do a little dance here to set bit 55 in the stack
+	 * pointer register without clobbering anything else.
+	 */
+	orr	x0, x0, #(1 << 55)
+	str	x1, [x0]
+	mov	x1, sp
+	mov	sp, x0
+	and	x0, x0, #~(1 << 55)
+	sub	x0, x1, x0
+	ldr	x1, [sp]
+#endif
 #endif
 	b	el\()\el\()_\label
 	.endm
-- 
2.18.0
