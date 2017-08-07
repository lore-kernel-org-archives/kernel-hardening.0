From: Mark Rutland <mark.rutland@arm.com>
Date: Mon,  7 Aug 2017 19:36:05 +0100
Message-Id: <1502130965-18710-15-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1502130965-18710-1-git-send-email-mark.rutland@arm.com>
References: <1502130965-18710-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCH 14/14] arm64: add VMAP_STACK overflow detection
To: linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, labbott@redhat.com, linux-kernel@vger.kernel.org, luto@amacapital.net, mark.rutland@arm.com, matt@codeblueprint.co.uk, will.deacon@arm.com, kernel-hardening@lists.openwall.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

This patch adds stack overflow detection to arm64, usable when vmap'd stacks
are in use.

Overflow is detected in a small preamble executed for each exception entry,
which checks whether there is enough space on the current stack for the general
purpose registers to be saved. If there is not enough space, the overflow
handler is invoked on a per-cpu overflow stack. This approach preserves the
original exception information in ESR_EL1 (and where appropriate, FAR_EL1).

Task and IRQ stacks are aligned to double their size, enabling overflow to be
detected with a single bit test. For example, a 16K stack is aligned to 32K,
ensuring that bit 14 of the SP must be zero. On an overflow (or underflow),
this bit is flipped. Thus, overflow (of less than the size of the stack) can be
detected by testing whether this bit is set.

The overflow check is performed before any attempt is made to access the
stack, avoiding recursive faults (and the loss of exception information
these would entail). As logical operations cannot be performed on the SP
directly, the SP is temporarily swapped with a general purpose register
using arithmetic operations to enable the test to be performed.

This gives us a useful error message on stack overflow, as can be trigger with
the LKDTM overflow test:

root@ribbensteg:/sys/kernel/debug/provoke-crash# echo OVERFLOW > DIRECT
[  116.249161] lkdtm: Performing direct entry OVERFLOW
[  116.254048] Insufficient stack space to handle exception!
[  116.254059] CPU: 4 PID: 2269 Comm: bash Not tainted 4.13.0-rc3-00020-g307fec7 #197
[  116.266913] Hardware name: ARM Juno development board (r1) (DT)
[  116.272783] task: ffff800976bf0e00 task.stack: ffff00000d540000
[  116.278660] PC is at recursive_loop+0x10/0x50
[  116.282981] LR is at recursive_loop+0x34/0x50
[  116.287300] pc : [<ffff000008597778>] lr : [<ffff00000859779c>] pstate: 40000145
[  116.294633] sp : ffff00000d53ff30
[  116.297916] x29: ffff00000d540350 x28: ffff800976bf0e00
[  116.303188] x27: ffff000008981000 x26: ffff000008f701f8
[  116.308458] x25: ffff00000d543eb8 x24: ffff00000d543eb8
[  116.313729] x23: ffff000008f6ff30 x22: 0000000000000009
[  116.318999] x21: ffff800975c43000 x20: ffff000008f6ff80
[  116.324269] x19: 0000000000000013 x18: 0000000000000010
[  116.329539] x17: 0000ffffb24cf6a4 x16: ffff0000081fbc40
[  116.334820] x15: 0000000000000006 x14: ffff000088fc637f
[  116.340099] x13: ffff000008fc638d x12: ffff000008ec2460
[  116.345379] x11: ffff00000d543a30 x10: 0000000005f5e0ff
[  116.350659] x9 : 00000000ffffffd0 x8 : ffff00000d540770
[  116.355939] x7 : 1313131313131313 x6 : 000000000000019c
[  116.361218] x5 : 0000000000000000 x4 : 0000000000000000
[  116.366497] x3 : 0000000000000000 x2 : 0000000000000400
[  116.371777] x1 : 0000000000000013 x0 : 0000000000000012
[  116.377058] Task stack:     [0xffff00000d540000..0xffff00000d544000]
[  116.383366] IRQ stack:      [0xffff000008020000..0xffff000008024000]
[  116.389675] Overflow stack: [0xffff80097ffa54e0..0xffff80097ffa64e0]
[  116.395984] ESR: 0x96000047 -- DABT (current EL)
[  116.400569] FAR: 0xffff00000d53ff30
[  116.404036] Kernel panic - not syncing: kernel stack overflow
[  116.409744] CPU: 4 PID: 2269 Comm: bash Not tainted 4.13.0-rc3-00020-g307fec7 #197
[  116.417268] Hardware name: ARM Juno development board (r1) (DT)
[  116.423146] Call trace:
[  116.425587] [<ffff0000080883a0>] dump_backtrace+0x0/0x268
[  116.430955] [<ffff0000080886cc>] show_stack+0x14/0x20
[  116.435976] [<ffff00000894e138>] dump_stack+0x98/0xb8
[  116.440997] [<ffff0000080c1e44>] panic+0x118/0x28c
[  116.445758] [<ffff0000080c1a84>] nmi_panic+0x6c/0x70
[  116.450693] [<ffff000008088f88>] handle_bad_stack+0x118/0x128
[  116.456401] Exception stack(0xffff80097ffa63a0 to 0xffff80097ffa64e0)
[  116.462799] 63a0: 0000000000000012 0000000000000013 0000000000000400 0000000000000000
[  116.470585] 63c0: 0000000000000000 0000000000000000 000000000000019c 1313131313131313
[  116.478372] 63e0: ffff00000d540770 00000000ffffffd0 0000000005f5e0ff ffff00000d543a30
[  116.486157] 6400: ffff000008ec2460 ffff000008fc638d ffff000088fc637f 0000000000000006
[  116.493943] 6420: ffff0000081fbc40 0000ffffb24cf6a4 0000000000000010 0000000000000013
[  116.501730] 6440: ffff000008f6ff80 ffff800975c43000 0000000000000009 ffff000008f6ff30
[  116.509516] 6460: ffff00000d543eb8 ffff00000d543eb8 ffff000008f701f8 ffff000008981000
[  116.517302] 6480: ffff800976bf0e00 ffff00000d540350 ffff00000859779c ffff00000d53ff30
[  116.525087] 64a0: ffff000008597778 0000000040000145 0000000000000000 0000000000000000
[  116.532874] 64c0: 0001000000000000 0000000000000000 ffff00000d540350 ffff000008597778
[  116.540660] [<ffff00000808205c>] __bad_stack+0x88/0x8c
[  116.545767] [<ffff000008597778>] recursive_loop+0x10/0x50
[  116.551132] [<ffff00000859779c>] recursive_loop+0x34/0x50
[  116.556497] [<ffff00000859779c>] recursive_loop+0x34/0x50
[  116.561862] [<ffff00000859779c>] recursive_loop+0x34/0x50
[  116.567228] [<ffff00000859779c>] recursive_loop+0x34/0x50
[  116.572592] [<ffff00000859779c>] recursive_loop+0x34/0x50
[  116.577957] [<ffff00000859779c>] recursive_loop+0x34/0x50
[  116.583322] [<ffff00000859779c>] recursive_loop+0x34/0x50
[  116.588687] [<ffff00000859779c>] recursive_loop+0x34/0x50
[  116.594051] [<ffff00000859779c>] recursive_loop+0x34/0x50
[  116.599416] [<ffff00000859779c>] recursive_loop+0x34/0x50
[  116.604781] [<ffff00000859779c>] recursive_loop+0x34/0x50
[  116.610146] [<ffff00000859779c>] recursive_loop+0x34/0x50
[  116.615511] [<ffff00000859779c>] recursive_loop+0x34/0x50
[  116.620876] [<ffff00000859782c>] lkdtm_OVERFLOW+0x14/0x20
[  116.626241] [<ffff000008597760>] lkdtm_do_action+0x1c/0x24
[  116.631693] [<ffff0000085975d0>] direct_entry+0xe0/0x168
[  116.636974] [<ffff000008340f98>] full_proxy_write+0x60/0xa8
[  116.642511] [<ffff0000081f93dc>] __vfs_write+0x1c/0x118
[  116.647704] [<ffff0000081fa824>] vfs_write+0x9c/0x1a8
[  116.652723] [<ffff0000081fbc84>] SyS_write+0x44/0xa0
[  116.657655] Exception stack(0xffff00000d543ec0 to 0xffff00000d544000)
[  116.664053] 3ec0: 0000000000000001 000000001952d808 0000000000000009 0000000000000000
[  116.671838] 3ee0: 0000000000000000 0000000000000000 0000ffffb24d6c6c 0dfefefefeff07ff
[  116.679624] 3f00: 0000000000000040 fefefefefefefeff 0000000019555b28 0000000000000008
[  116.687411] 3f20: 0000000000000000 0000000000000018 ffffffffffffffff 00000ca9b8000000
[  116.695196] 3f40: 0000000000000000 0000ffffb24cf6a4 0000ffffd8d00e40 0000000000000009
[  116.702983] 3f60: 000000001952d808 0000ffffb25ad178 0000000000000009 0000000000000000
[  116.710768] 3f80: 0000000000000001 00000000004c9c98 00000000004ca628 00000000004ed000
[  116.718554] 3fa0: 00000000004ea8e0 0000ffffd8d00fe0 0000ffffb24d674c 0000ffffd8d00fe0
[  116.726340] 3fc0: 0000ffffb2524fec 0000000060000000 0000000000000001 0000000000000040
[  116.734125] 3fe0: 0000000000000000 0000000000000000 0000000000000000 0000ffffb2524fec
[  116.741912] [<ffff000008082fb0>] el0_svc_naked+0x24/0x28
[  116.747189] [<0000ffffb2524fec>] 0xffffb2524fec
[  116.751695] SMP: stopping secondary CPUs
[  116.755909] Kernel Offset: disabled
[  116.759375] CPU features: 0x002086
[  116.762753] Memory Limit: none
[  116.765795] ---[ end Kernel panic - not syncing: kernel stack overflow

This patch was co-authored by Ard Biesheuvel and Mark Rutland.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/memory.h     |  2 ++
 arch/arm64/include/asm/stacktrace.h | 18 +++++++++++
 arch/arm64/kernel/entry.S           | 59 +++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/traps.c           | 39 ++++++++++++++++++++++++
 4 files changed, 118 insertions(+)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index c5cd2c5..1a025b7 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -133,6 +133,8 @@
 
 #define IRQ_STACK_SIZE		THREAD_SIZE
 
+#define OVERFLOW_STACK_SIZE	SZ_4K
+
 /*
  * Alignment of kernel segments (e.g. .text, .data).
  */
diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index 92ddb6d..ee19563 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -57,6 +57,22 @@ static inline bool on_task_stack(struct task_struct *tsk, unsigned long sp)
 	return (low <= sp && sp < high);
 }
 
+#ifdef CONFIG_VMAP_STACK
+DECLARE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack);
+
+#define OVERFLOW_STACK_PTR() ((unsigned long)this_cpu_ptr(overflow_stack) + OVERFLOW_STACK_SIZE)
+
+static inline bool on_overflow_stack(unsigned long sp)
+{
+	unsigned long low = (unsigned long)this_cpu_ptr(overflow_stack);
+	unsigned long high = low + OVERFLOW_STACK_SIZE;
+
+	return (low <= sp && sp < high);
+}
+#else
+static inline bool on_overflow_stack(unsigned long sp) { return false; }
+#endif
+
 /*
  * We can only safely access per-cpu stacks from current in a non-preemptible
  * context.
@@ -69,6 +85,8 @@ static inline bool on_accessible_stack(struct task_struct *tsk, unsigned long sp
 		return false;
 	if (on_irq_stack(sp))
 		return true;
+	if (on_overflow_stack(sp))
+		return true;
 
 	return false;
 }
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index e5aa866..44a27c3 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -72,6 +72,37 @@
 	.macro kernel_ventry	label
 	.align 7
 	sub	sp, sp, #S_FRAME_SIZE
+#ifdef CONFIG_VMAP_STACK
+	add	sp, sp, x0			// sp' = sp + x0
+	sub	x0, sp, x0			// x0' = sp' - x0 = (sp + x0) - x0 = sp
+	tbnz	x0, #THREAD_SHIFT, 0f
+	sub	x0, sp, x0			// sp' - x0' = (sp + x0) - sp = x0
+	sub	sp, sp, x0			// sp' - x0 = (sp + x0) - x0 = sp
+	b	\label
+
+	/* Stash the original SP value in tpidr_el0 */
+0:	msr	tpidr_el0, x0
+
+	/* Recover the original x0 value and stash it in tpidrro_el0 */
+	sub	x0, sp, x0
+	msr	tpidrro_el0, x0
+
+	/* Switch to the overflow stack */
+	adr_this_cpu sp, overflow_stack + OVERFLOW_STACK_SIZE, x0
+
+	/*
+	 * Check whether we were already on the overflow stack. This may happen
+	 * after panic() re-enables interrupts.
+	 */
+	mrs	x0, tpidr_el0			// sp of interrupted context
+	sub	x0, sp, x0			// delta with top of overflow stack
+	tst	x0, #~(OVERFLOW_STACK_SIZE - 1)	// within range?
+	b.ne	__bad_stack			// no? -> bad stack pointer
+
+	/* We were already on the overflow stack. Restore sp/x0 and carry on. */
+	sub	sp, sp, x0
+	mrs	x0, tpidrro_el0
+#endif
 	b	\label
 	.endm
 
@@ -348,6 +379,34 @@ ENTRY(vectors)
 #endif
 END(vectors)
 
+#ifdef CONFIG_VMAP_STACK
+	/*
+	 * We detected an overflow in kernel_ventry, which switched to the
+	 * overflow stack. Stash the exception regs, and head to our overflow
+	 * handler.
+	 */
+__bad_stack:
+	/* Restore the original x0 value */
+	mrs	x0, tpidrro_el0
+
+	/*
+	 * Store the original GPRs to the new stack. The orginial SP (minus
+	 * S_FRAME_SIZE) was stashed in tpidr_el0 by kernel_ventry.
+	 */
+	sub	sp, sp, #S_FRAME_SIZE
+	kernel_entry 1
+	mrs	x0, tpidr_el0
+	add	x0, x0, #S_FRAME_SIZE
+	str	x0, [sp, #S_SP]
+
+	/* Stash the regs for handle_bad_stack */
+	mov	x0, sp
+
+	/* Time to die */
+	bl	handle_bad_stack
+	ASM_BUG()
+#endif /* CONFIG_VMAP_STACK */
+
 /*
  * Invalid mode handlers
  */
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index d01c598..2c80a11 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -32,6 +32,7 @@
 #include <linux/sched/signal.h>
 #include <linux/sched/debug.h>
 #include <linux/sched/task_stack.h>
+#include <linux/sizes.h>
 #include <linux/syscalls.h>
 #include <linux/mm_types.h>
 
@@ -41,6 +42,7 @@
 #include <asm/esr.h>
 #include <asm/insn.h>
 #include <asm/traps.h>
+#include <asm/smp.h>
 #include <asm/stack_pointer.h>
 #include <asm/stacktrace.h>
 #include <asm/exception.h>
@@ -666,6 +668,43 @@ asmlinkage void bad_el0_sync(struct pt_regs *regs, int reason, unsigned int esr)
 	force_sig_info(info.si_signo, &info, current);
 }
 
+#ifdef CONFIG_VMAP_STACK
+
+DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
+	__aligned(16);
+
+asmlinkage void handle_bad_stack(struct pt_regs *regs)
+{
+	unsigned long tsk_stk = (unsigned long)current->stack;
+	unsigned long irq_stk = (unsigned long)this_cpu_read(irq_stack_ptr);
+	unsigned long ovf_stk = (unsigned long)this_cpu_ptr(overflow_stack);
+	unsigned int esr = read_sysreg(esr_el1);
+	unsigned long far = read_sysreg(far_el1);
+
+	console_verbose();
+	pr_emerg("Insufficient stack space to handle exception!");
+
+	__show_regs(regs);
+
+	pr_emerg("Task stack:     [0x%016lx..0x%016lx]\n",
+		 tsk_stk, tsk_stk + THREAD_SIZE);
+	pr_emerg("IRQ stack:      [0x%016lx..0x%016lx]\n",
+		 irq_stk, irq_stk + THREAD_SIZE);
+	pr_emerg("Overflow stack: [0x%016lx..0x%016lx]\n",
+		 ovf_stk, ovf_stk + OVERFLOW_STACK_SIZE);
+
+	pr_emerg("ESR: 0x%08x -- %s\n", esr, esr_get_class_string(esr));
+	pr_emerg("FAR: 0x%016lx\n", far);
+
+	/*
+	 * We use nmi_panic to limit the potential for recusive overflows, and
+	 * to get a better stack trace.
+	 */
+	nmi_panic(NULL, "kernel stack overflow");
+	cpu_park_loop();
+}
+#endif
+
 void __pte_error(const char *file, int line, unsigned long val)
 {
 	pr_err("%s:%d: bad pte %016lx.\n", file, line, val);
-- 
1.9.1
