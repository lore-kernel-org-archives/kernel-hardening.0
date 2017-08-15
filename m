From: Mark Rutland <mark.rutland@arm.com>
Date: Tue, 15 Aug 2017 13:50:44 +0100
Message-Id: <1502801449-29246-10-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1502801449-29246-1-git-send-email-mark.rutland@arm.com>
References: <1502801449-29246-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCHv2 09/14] arm64: factor out entry stack manipulation
To: linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, labbott@redhat.com, linux-kernel@vger.kernel.org, luto@amacapital.net, mark.rutland@arm.com, matt@codeblueprint.co.uk, will.deacon@arm.com, kernel-hardening@lists.openwall.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

In subsequent patches, we will detect stack overflow in our exception
entry code, by verifying the SP after it has been decremented to make
space for the exception regs.

This verification code is small, and we can minimize its impact by
placing it directly in the vectors. To avoid redundant modification of
the SP, we also need to move the initial decrement of the SP into the
vectors.

As a preparatory step, this patch introduces kernel_ventry, which
performs this decrement, and updates the entry code accordingly.
Subsequent patches will fold SP verification into kernel_ventry.

There should be no functional change as a result of this patch.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
[Mark: turn into prep patch, expand commit msg]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/kernel/entry.S | 47 ++++++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index f31c7b2..58eba94 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -69,8 +69,13 @@
 #define BAD_FIQ		2
 #define BAD_ERROR	3
 
-	.macro	kernel_entry, el, regsize = 64
+	.macro kernel_ventry	label
+	.align 7
 	sub	sp, sp, #S_FRAME_SIZE
+	b	\label
+	.endm
+
+	.macro	kernel_entry, el, regsize = 64
 	.if	\regsize == 32
 	mov	w0, w0				// zero upper 32 bits of x0
 	.endif
@@ -319,31 +324,31 @@ tsk	.req	x28		// current thread_info
 
 	.align	11
 ENTRY(vectors)
-	ventry	el1_sync_invalid		// Synchronous EL1t
-	ventry	el1_irq_invalid			// IRQ EL1t
-	ventry	el1_fiq_invalid			// FIQ EL1t
-	ventry	el1_error_invalid		// Error EL1t
+	kernel_ventry	el1_sync_invalid		// Synchronous EL1t
+	kernel_ventry	el1_irq_invalid			// IRQ EL1t
+	kernel_ventry	el1_fiq_invalid			// FIQ EL1t
+	kernel_ventry	el1_error_invalid		// Error EL1t
 
-	ventry	el1_sync			// Synchronous EL1h
-	ventry	el1_irq				// IRQ EL1h
-	ventry	el1_fiq_invalid			// FIQ EL1h
-	ventry	el1_error_invalid		// Error EL1h
+	kernel_ventry	el1_sync			// Synchronous EL1h
+	kernel_ventry	el1_irq				// IRQ EL1h
+	kernel_ventry	el1_fiq_invalid			// FIQ EL1h
+	kernel_ventry	el1_error_invalid		// Error EL1h
 
-	ventry	el0_sync			// Synchronous 64-bit EL0
-	ventry	el0_irq				// IRQ 64-bit EL0
-	ventry	el0_fiq_invalid			// FIQ 64-bit EL0
-	ventry	el0_error_invalid		// Error 64-bit EL0
+	kernel_ventry	el0_sync			// Synchronous 64-bit EL0
+	kernel_ventry	el0_irq				// IRQ 64-bit EL0
+	kernel_ventry	el0_fiq_invalid			// FIQ 64-bit EL0
+	kernel_ventry	el0_error_invalid		// Error 64-bit EL0
 
 #ifdef CONFIG_COMPAT
-	ventry	el0_sync_compat			// Synchronous 32-bit EL0
-	ventry	el0_irq_compat			// IRQ 32-bit EL0
-	ventry	el0_fiq_invalid_compat		// FIQ 32-bit EL0
-	ventry	el0_error_invalid_compat	// Error 32-bit EL0
+	kernel_ventry	el0_sync_compat			// Synchronous 32-bit EL0
+	kernel_ventry	el0_irq_compat			// IRQ 32-bit EL0
+	kernel_ventry	el0_fiq_invalid_compat		// FIQ 32-bit EL0
+	kernel_ventry	el0_error_invalid_compat	// Error 32-bit EL0
 #else
-	ventry	el0_sync_invalid		// Synchronous 32-bit EL0
-	ventry	el0_irq_invalid			// IRQ 32-bit EL0
-	ventry	el0_fiq_invalid			// FIQ 32-bit EL0
-	ventry	el0_error_invalid		// Error 32-bit EL0
+	kernel_ventry	el0_sync_invalid		// Synchronous 32-bit EL0
+	kernel_ventry	el0_irq_invalid			// IRQ 32-bit EL0
+	kernel_ventry	el0_fiq_invalid			// FIQ 32-bit EL0
+	kernel_ventry	el0_error_invalid		// Error 32-bit EL0
 #endif
 END(vectors)
 
-- 
1.9.1
