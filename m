Reply-To: kernel-hardening@lists.openwall.com
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 12 Aug 2016 16:27:44 +0100
Message-Id: <1471015666-23125-6-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
References: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] [PATCH 5/7] arm64: Handle faults caused by inadvertent user access with PAN enabled
To: linux-arm-kernel@lists.infradead.org
Cc: kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

When TTBR0_EL1 is set to the reserved page, an erroneous kernel access
to user space would generate a translation fault. This patch adds the
checks for the software-set PSR_PAN_BIT to emulate a permission fault
and report it accordingly.

This patch also updates the description of the synchronous external
aborts on translation table walks.

Cc: Will Deacon <will.deacon@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/mm/fault.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index c8beaa0da7df..a3b2f9b63c55 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -262,12 +262,19 @@ out:
 	return fault;
 }
 
-static inline bool is_permission_fault(unsigned int esr)
+static inline bool is_permission_fault(unsigned int esr, struct pt_regs *regs)
 {
 	unsigned int ec       = ESR_ELx_EC(esr);
 	unsigned int fsc_type = esr & ESR_ELx_FSC_TYPE;
 
-	return (ec == ESR_ELx_EC_DABT_CUR && fsc_type == ESR_ELx_FSC_PERM);
+	if (ec != ESR_ELx_EC_DABT_CUR)
+		return false;
+
+	if (system_supports_ttbr0_pan())
+		return fsc_type == ESR_ELx_FSC_FAULT &&
+			(regs->pstate & PSR_PAN_BIT);
+	else
+		return fsc_type == ESR_ELx_FSC_PERM;
 }
 
 static bool is_el0_instruction_abort(unsigned int esr)
@@ -307,7 +314,7 @@ static int __kprobes do_page_fault(unsigned long addr, unsigned int esr,
 		mm_flags |= FAULT_FLAG_WRITE;
 	}
 
-	if (is_permission_fault(esr) && (addr < USER_DS)) {
+	if (addr < USER_DS && is_permission_fault(esr, regs)) {
 		/* regs->orig_addr_limit may be 0 if we entered from EL0 */
 		if (regs->orig_addr_limit == KERNEL_DS)
 			die("Accessing user space memory with fs=KERNEL_DS", regs, esr);
@@ -496,10 +503,10 @@ static const struct fault_info {
 	{ do_bad,		SIGBUS,  0,		"unknown 17"			},
 	{ do_bad,		SIGBUS,  0,		"unknown 18"			},
 	{ do_bad,		SIGBUS,  0,		"unknown 19"			},
-	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
-	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
-	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
-	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
+	{ do_bad,		SIGBUS,  0,		"synchronous external abort (translation table walk)" },
+	{ do_bad,		SIGBUS,  0,		"synchronous external abort (translation table walk)" },
+	{ do_bad,		SIGBUS,  0,		"synchronous external abort (translation table walk)" },
+	{ do_bad,		SIGBUS,  0,		"synchronous external abort (translation table walk)" },
 	{ do_bad,		SIGBUS,  0,		"synchronous parity error"	},
 	{ do_bad,		SIGBUS,  0,		"unknown 25"			},
 	{ do_bad,		SIGBUS,  0,		"unknown 26"			},
