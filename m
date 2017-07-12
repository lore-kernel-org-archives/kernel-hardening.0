From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 12 Jul 2017 15:44:22 +0100
Message-Id: <20170712144424.19528-10-ard.biesheuvel@linaro.org>
In-Reply-To: <20170712144424.19528-1-ard.biesheuvel@linaro.org>
References: <20170712144424.19528-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [RFC PATCH 09/10] arm64: mm: add C level handling for stack overflows
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
Cc: mark.rutland@arm.com, labbott@fedoraproject.org, will.deacon@arm.com, dave.martin@arm.com, catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Add the code to __do_kernel_fault() to force a panic when the faulting
address of a data abort points into the guard page below the current
task's stack.

Currently, we won't be able to make it all the way here under such a
condition, but that will be addressed in a subsequent patch.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/mm/fault.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index c7861c9864e6..b3317e5ff5dd 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -229,6 +229,21 @@ static void __do_kernel_fault(unsigned long addr, unsigned int esr,
 		return;
 
 	/*
+	 * If we faulted on the guard page below this task's stack,
+	 * we evidently overflowed
+	 */
+	if (addr >= (u64)current->stack - PAGE_SIZE &&
+	    addr < (u64)current->stack) {
+		printk(KERN_EMERG "BUG: stack guard page was hit at %p (stack is %p..%p)\n",
+			 (void *)addr, current->stack,
+			 (char *)current->stack + THREAD_SIZE - 1);
+		die("Oops", regs, esr);
+
+		/* Be absolutely certain we don't return. */
+		panic("Kernel stack overflow");
+	}
+
+	/*
 	 * No handler, we'll have to terminate things with extreme prejudice.
 	 */
 	bust_spinlocks(1);
-- 
2.9.3
