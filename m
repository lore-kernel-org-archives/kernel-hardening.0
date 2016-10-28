Reply-To: kernel-hardening@lists.openwall.com
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 28 Oct 2016 18:27:14 +0100
Message-Id: <1477675636-3957-7-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1477675636-3957-1-git-send-email-catalin.marinas@arm.com>
References: <1477675636-3957-1-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] [PATCH v4 6/8] arm64: Handle faults caused by inadvertent user access with PAN enabled
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Sami Tolvanen <samitolvanen@google.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

When TTBR0_EL1 is set to the reserved page, an erroneous kernel access
to user space would generate a translation fault. This patch adds the
checks for the software-set PSR_PAN_BIT to emulate a permission fault
and report it accordingly.

Cc: Will Deacon <will.deacon@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/mm/fault.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index d035cc594445..a78a5c401806 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -269,13 +269,19 @@ static int __do_page_fault(struct mm_struct *mm, unsigned long addr,
 	return fault;
 }
 
-static inline bool is_permission_fault(unsigned int esr)
+static inline bool is_permission_fault(unsigned int esr, struct pt_regs *regs)
 {
 	unsigned int ec       = ESR_ELx_EC(esr);
 	unsigned int fsc_type = esr & ESR_ELx_FSC_TYPE;
 
-	return (ec == ESR_ELx_EC_DABT_CUR && fsc_type == ESR_ELx_FSC_PERM) ||
-	       (ec == ESR_ELx_EC_IABT_CUR && fsc_type == ESR_ELx_FSC_PERM);
+	if (ec != ESR_ELx_EC_DABT_CUR && ec != ESR_ELx_EC_IABT_CUR)
+		return false;
+
+	if (system_uses_ttbr0_pan())
+		return fsc_type == ESR_ELx_FSC_FAULT &&
+			(regs->pstate & PSR_PAN_BIT);
+	else
+		return fsc_type == ESR_ELx_FSC_PERM;
 }
 
 static bool is_el0_instruction_abort(unsigned int esr)
@@ -315,7 +321,7 @@ static int __kprobes do_page_fault(unsigned long addr, unsigned int esr,
 		mm_flags |= FAULT_FLAG_WRITE;
 	}
 
-	if (is_permission_fault(esr) && (addr < USER_DS)) {
+	if (addr < USER_DS && is_permission_fault(esr, regs)) {
 		/* regs->orig_addr_limit may be 0 if we entered from EL0 */
 		if (regs->orig_addr_limit == KERNEL_DS)
 			die("Accessing user space memory with fs=KERNEL_DS", regs, esr);
