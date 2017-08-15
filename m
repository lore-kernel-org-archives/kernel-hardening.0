From: Mark Rutland <mark.rutland@arm.com>
Date: Tue, 15 Aug 2017 13:50:46 +0100
Message-Id: <1502801449-29246-12-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1502801449-29246-1-git-send-email-mark.rutland@arm.com>
References: <1502801449-29246-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCHv2 11/14] arm64: use an irq stack pointer
To: linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, labbott@redhat.com, linux-kernel@vger.kernel.org, luto@amacapital.net, mark.rutland@arm.com, matt@codeblueprint.co.uk, will.deacon@arm.com, kernel-hardening@lists.openwall.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

We allocate our IRQ stacks using a percpu array. This allows us to generate our
IRQ stack pointers with adr_this_cpu, but bloats the kernel Image with the boot
CPU's IRQ stack. Additionally, these are packed with other percpu variables,
and aren't guaranteed to have guard pages.

When we enable VMAP_STACK we'll want to vmap our IRQ stacks also, in order to
provide guard pages and to permit more stringent alignment requirements. Doing
so will require that we use a percpu pointer to each IRQ stack, rather than
allocating a percpu IRQ stack in the kernel image.

This patch updates our IRQ stack code to use a percpu pointer to the base of
each IRQ stack. This will allow us to change the way the stack is allocated
with minimal changes elsewhere. In some cases we may try to backtrace before
the IRQ stack pointers are initialised, so on_irq_stack() is updated to account
for this.

In testing with cyclictest, there was no measureable difference between using
adr_this_cpu (for irq_stack) and ldr_this_cpu (for irq_stack_ptr) in the IRQ
entry path.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/stacktrace.h |  7 +++++--
 arch/arm64/kernel/entry.S           |  2 +-
 arch/arm64/kernel/irq.c             | 10 ++++++++++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index 000e2418..4c68d8a 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -36,13 +36,16 @@ extern void walk_stackframe(struct task_struct *tsk, struct stackframe *frame,
 			    int (*fn)(struct stackframe *, void *), void *data);
 extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk);
 
-DECLARE_PER_CPU(unsigned long [IRQ_STACK_SIZE/sizeof(long)], irq_stack);
+DECLARE_PER_CPU(unsigned long *, irq_stack_ptr);
 
 static inline bool on_irq_stack(unsigned long sp)
 {
-	unsigned long low = (unsigned long)raw_cpu_ptr(irq_stack);
+	unsigned long low = (unsigned long)raw_cpu_read(irq_stack_ptr);
 	unsigned long high = low + IRQ_STACK_SIZE;
 
+	if (!low)
+		return false;
+
 	return (low <= sp && sp < high);
 }
 
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 58eba94..5234886 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -276,7 +276,7 @@ alternative_else_nop_endif
 	and	x25, x25, #~(THREAD_SIZE - 1)
 	cbnz	x25, 9998f
 
-	adr_this_cpu x25, irq_stack, x26
+	ldr_this_cpu x25, irq_stack_ptr, x26
 	mov	x26, #IRQ_STACK_SIZE
 	add	x26, x25, x26
 
diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
index 2386b26..5141282 100644
--- a/arch/arm64/kernel/irq.c
+++ b/arch/arm64/kernel/irq.c
@@ -32,6 +32,7 @@
 
 /* irq stack only needs to be 16 byte aligned - not IRQ_STACK_SIZE aligned. */
 DEFINE_PER_CPU(unsigned long [IRQ_STACK_SIZE/sizeof(long)], irq_stack) __aligned(16);
+DEFINE_PER_CPU(unsigned long *, irq_stack_ptr);
 
 int arch_show_interrupts(struct seq_file *p, int prec)
 {
@@ -50,8 +51,17 @@ void __init set_handle_irq(void (*handle_irq)(struct pt_regs *))
 	handle_arch_irq = handle_irq;
 }
 
+static void init_irq_stacks(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		per_cpu(irq_stack_ptr, cpu) = per_cpu(irq_stack, cpu);
+}
+
 void __init init_IRQ(void)
 {
+	init_irq_stacks();
 	irqchip_init();
 	if (!handle_arch_irq)
 		panic("No interrupt controller found.");
-- 
1.9.1
