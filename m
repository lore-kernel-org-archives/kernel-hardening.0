From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 12 Jul 2017 15:44:17 +0100
Message-Id: <20170712144424.19528-5-ard.biesheuvel@linaro.org>
In-Reply-To: <20170712144424.19528-1-ard.biesheuvel@linaro.org>
References: <20170712144424.19528-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [RFC PATCH 04/10] arm64: kvm: stop treating register x18 as caller save
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
Cc: mark.rutland@arm.com, labbott@fedoraproject.org, will.deacon@arm.com, dave.martin@arm.com, catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

In preparation of using x18 as a task struct pointer register when
running in the kernel, stop treating it as caller save in the KVM
guest entry/exit code. Currently, the code assumes there is no need
to preserve it for the host, given that it would have been assumed
clobbered anyway by the function call to __guest_enter(). Instead,
preserve its value and restore it upon return.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kvm/hyp/entry.S | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 12ee62d6d410..75d31a161d3e 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -32,6 +32,7 @@
 	.pushsection	.hyp.text, "ax"
 
 .macro save_callee_saved_regs ctxt
+	str	x18,      [\ctxt, #CPU_XREG_OFFSET(18)]
 	stp	x19, x20, [\ctxt, #CPU_XREG_OFFSET(19)]
 	stp	x21, x22, [\ctxt, #CPU_XREG_OFFSET(21)]
 	stp	x23, x24, [\ctxt, #CPU_XREG_OFFSET(23)]
@@ -47,6 +48,7 @@
 	ldp	x25, x26, [\ctxt, #CPU_XREG_OFFSET(25)]
 	ldp	x27, x28, [\ctxt, #CPU_XREG_OFFSET(27)]
 	ldp	x29, lr,  [\ctxt, #CPU_XREG_OFFSET(29)]
+	ldr	x18,      [\ctxt, #CPU_XREG_OFFSET(18)]
 .endm
 
 /*
@@ -78,12 +80,9 @@ ENTRY(__guest_enter)
 	ldp	x14, x15, [x18, #CPU_XREG_OFFSET(14)]
 	ldp	x16, x17, [x18, #CPU_XREG_OFFSET(16)]
 
-	// Restore guest regs x19-x29, lr
+	// Restore guest regs x18-x29, lr
 	restore_callee_saved_regs x18
 
-	// Restore guest reg x18
-	ldr	x18,      [x18, #CPU_XREG_OFFSET(18)]
-
 	// Do not touch any register after this!
 	eret
 ENDPROC(__guest_enter)
@@ -104,7 +103,7 @@ ENTRY(__guest_exit)
 	// Retrieve the guest regs x0-x1 from the stack
 	ldp	x2, x3, [sp], #16	// x0, x1
 
-	// Store the guest regs x0-x1 and x4-x18
+	// Store the guest regs x0-x1 and x4-x17
 	stp	x2, x3,   [x1, #CPU_XREG_OFFSET(0)]
 	stp	x4, x5,   [x1, #CPU_XREG_OFFSET(4)]
 	stp	x6, x7,   [x1, #CPU_XREG_OFFSET(6)]
@@ -113,9 +112,8 @@ ENTRY(__guest_exit)
 	stp	x12, x13, [x1, #CPU_XREG_OFFSET(12)]
 	stp	x14, x15, [x1, #CPU_XREG_OFFSET(14)]
 	stp	x16, x17, [x1, #CPU_XREG_OFFSET(16)]
-	str	x18,      [x1, #CPU_XREG_OFFSET(18)]
 
-	// Store the guest regs x19-x29, lr
+	// Store the guest regs x18-x29, lr
 	save_callee_saved_regs x1
 
 	// Restore the host_ctxt from the stack
-- 
2.9.3
