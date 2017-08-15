From: Mark Rutland <mark.rutland@arm.com>
Date: Tue, 15 Aug 2017 13:50:38 +0100
Message-Id: <1502801449-29246-4-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1502801449-29246-1-git-send-email-mark.rutland@arm.com>
References: <1502801449-29246-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCHv2 03/14] arm64: kernel: remove {THREAD,IRQ_STACK}_START_SP
To: linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, labbott@redhat.com, linux-kernel@vger.kernel.org, luto@amacapital.net, mark.rutland@arm.com, matt@codeblueprint.co.uk, will.deacon@arm.com, kernel-hardening@lists.openwall.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

For historical reasons, we leave the top 16 bytes of our task and IRQ
stacks unused, a practice used to ensure that the SP can always be
masked to find the base of the current stack (historically, where
thread_info could be found).

However, this is not necessary, as:

* When an exception is taken from a task stack, we decrement the SP by
  S_FRAME_SIZE and stash the exception registers before we compare the
  SP against the task stack. In such cases, the SP must be at least
  S_FRAME_SIZE below the limit, and can be safely masked to determine
  whether the task stack is in use.

* When transitioning to an IRQ stack, we'll place a dummy frame onto the
  IRQ stack before enabling asynchronous exceptions, or executing code
  we expect to trigger faults. Thus, if an exception is taken from the
  IRQ stack, the SP must be at least 16 bytes below the limit.

* We no longer mask the SP to find the thread_info, which is now found
  via sp_el0. Note that historically, the offset was critical to ensure
  that cpu_switch_to() found the correct stack for new threads that
  hadn't yet executed ret_from_fork().

Given that, this initial offset serves no purpose, and can be removed.
This brings us in-line with other architectures (e.g. x86) which do not
rely on this masking.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
[Mark: rebase, kill THREAD_START_SP, commit msg additions]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/irq.h         | 5 ++---
 arch/arm64/include/asm/processor.h   | 2 +-
 arch/arm64/include/asm/thread_info.h | 1 -
 arch/arm64/kernel/entry.S            | 2 +-
 arch/arm64/kernel/smp.c              | 2 +-
 5 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/irq.h b/arch/arm64/include/asm/irq.h
index 8ba89c4..1ebe202 100644
--- a/arch/arm64/include/asm/irq.h
+++ b/arch/arm64/include/asm/irq.h
@@ -2,7 +2,6 @@
 #define __ASM_IRQ_H
 
 #define IRQ_STACK_SIZE			THREAD_SIZE
-#define IRQ_STACK_START_SP		THREAD_START_SP
 
 #ifndef __ASSEMBLER__
 
@@ -26,9 +25,9 @@ static inline int nr_legacy_irqs(void)
 static inline bool on_irq_stack(unsigned long sp)
 {
 	unsigned long low = (unsigned long)raw_cpu_ptr(irq_stack);
-	unsigned long high = low + IRQ_STACK_START_SP;
+	unsigned long high = low + IRQ_STACK_SIZE;
 
-	return (low <= sp && sp <= high);
+	return (low <= sp && sp < high);
 }
 
 static inline bool on_task_stack(struct task_struct *tsk, unsigned long sp)
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 64c9e78..6687dd2 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -159,7 +159,7 @@ extern struct task_struct *cpu_switch_to(struct task_struct *prev,
 					 struct task_struct *next);
 
 #define task_pt_regs(p) \
-	((struct pt_regs *)(THREAD_START_SP + task_stack_page(p)) - 1)
+	((struct pt_regs *)(THREAD_SIZE + task_stack_page(p)) - 1)
 
 #define KSTK_EIP(tsk)	((unsigned long)task_pt_regs(tsk)->pc)
 #define KSTK_ESP(tsk)	user_stack_pointer(task_pt_regs(tsk))
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 46c3b93..b29ab0e 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -30,7 +30,6 @@
 #endif
 
 #define THREAD_SIZE		16384
-#define THREAD_START_SP		(THREAD_SIZE - 16)
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 612a077..f31c7b2 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -272,7 +272,7 @@ alternative_else_nop_endif
 	cbnz	x25, 9998f
 
 	adr_this_cpu x25, irq_stack, x26
-	mov	x26, #IRQ_STACK_START_SP
+	mov	x26, #IRQ_STACK_SIZE
 	add	x26, x25, x26
 
 	/* switch to the irq stack */
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index dc66e6e..f13ddb24 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -154,7 +154,7 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
 	 * page tables.
 	 */
 	secondary_data.task = idle;
-	secondary_data.stack = task_stack_page(idle) + THREAD_START_SP;
+	secondary_data.stack = task_stack_page(idle) + THREAD_SIZE;
 	update_cpu_boot_status(CPU_MMU_OFF);
 	__flush_dcache_area(&secondary_data, sizeof(secondary_data));
 
-- 
1.9.1
