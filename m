From: Nadav Amit <namit@vmware.com>
Subject: [PATCH v5 04/23] x86/mm: Save debug registers when loading a temporary mm
Date: Thu, 25 Apr 2019 17:11:24 -0700
Message-ID: <20190426001143.4983-5-namit@vmware.com>
In-Reply-To: <20190426001143.4983-1-namit@vmware.com>
References: <20190426001143.4983-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
To: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com, Rick Edgecombe <rick.p.edgecombe@intel.com>, Nadav Amit <namit@vmware.com>
List-ID: <kernel-hardening.lists.openwall.com>

Prevent user watchpoints from mistakenly firing while the temporary mm
is being used. As the addresses of the temporary mm might overlap those
of the user-process, this is necessary to prevent wrong signals or worse
things from happening.

Cc: Andy Lutomirski <luto@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/mmu_context.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 24dc3b810970..93dff1963337 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -13,6 +13,7 @@
 #include <asm/tlbflush.h>
 #include <asm/paravirt.h>
 #include <asm/mpx.h>
+#include <asm/debugreg.h>
 
 extern atomic64_t last_mm_ctx_id;
 
@@ -380,6 +381,21 @@ static inline temp_mm_state_t use_temporary_mm(struct mm_struct *mm)
 	lockdep_assert_irqs_disabled();
 	temp_state.mm = this_cpu_read(cpu_tlbstate.loaded_mm);
 	switch_mm_irqs_off(NULL, mm, current);
+
+	/*
+	 * If breakpoints are enabled, disable them while the temporary mm is
+	 * used. Userspace might set up watchpoints on addresses that are used
+	 * in the temporary mm, which would lead to wrong signals being sent or
+	 * crashes.
+	 *
+	 * Note that breakpoints are not disabled selectively, which also causes
+	 * kernel breakpoints (e.g., perf's) to be disabled. This might be
+	 * undesirable, but still seems reasonable as the code that runs in the
+	 * temporary mm should be short.
+	 */
+	if (hw_breakpoint_active())
+		hw_breakpoint_disable();
+
 	return temp_state;
 }
 
@@ -387,6 +403,13 @@ static inline void unuse_temporary_mm(temp_mm_state_t prev_state)
 {
 	lockdep_assert_irqs_disabled();
 	switch_mm_irqs_off(NULL, prev_state.mm, current);
+
+	/*
+	 * Restore the breakpoints if they were disabled before the temporary mm
+	 * was loaded.
+	 */
+	if (hw_breakpoint_active())
+		hw_breakpoint_restore();
 }
 
 #endif /* _ASM_X86_MMU_CONTEXT_H */
-- 
2.17.1
