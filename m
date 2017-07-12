From: Mark Rutland <mark.rutland@arm.com>
Date: Wed, 12 Jul 2017 23:33:02 +0100
Message-Id: <1499898783-25732-6-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1499898783-25732-1-git-send-email-mark.rutland@arm.com>
References: <1499898783-25732-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [RFC PATCH 5/6] arm64: keep track of current stack
To: ard.biesheuvel@linaro.org, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: akashi.takahiro@linaro.org, catalin.marinas@arm.com, dave.martin@arm.com, james.morse@arm.com, labbott@fedoraproject.org, will.deacon@arm.com, keescook@chromium.org, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

To reliably check stack bounds, we'll need to know whether we're on a
task stack, or an IRQ stack.

Stash the base of the current stack in thread_info so that we have this
information.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/include/asm/thread_info.h | 3 +++
 arch/arm64/kernel/asm-offsets.c      | 3 +++
 arch/arm64/kernel/entry.S            | 7 +++++++
 arch/arm64/kernel/head.S             | 6 ++++++
 arch/arm64/kernel/process.c          | 4 ++++
 5 files changed, 23 insertions(+)

diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 3684f86..ae4f44b 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -62,6 +62,9 @@ struct thread_info {
 #endif
 	unsigned long		pcp_offset;
 	int			preempt_count;	/* 0 => preemptable, <0 => bug */
+#ifdef CONFIG_VMAP_STACK
+	unsigned long		current_stack;
+#endif
 };
 
 #define INIT_THREAD_INFO(tsk)						\
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 17001be..10c8ffa 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -40,6 +40,9 @@ int main(void)
   DEFINE(TSK_TI_PREEMPT,	offsetof(struct task_struct, thread_info.preempt_count));
   DEFINE(TSK_TI_PCP,		offsetof(struct task_struct, thread_info.pcp_offset));
   DEFINE(TSK_TI_ADDR_LIMIT,	offsetof(struct task_struct, thread_info.addr_limit));
+#ifdef CONFIG_VMAP_STACK
+  DEFINE(TSK_TI_CUR_STK,	offsetof(struct task_struct, thread_info.current_stack));
+#endif
 #ifdef CONFIG_ARM64_SW_TTBR0_PAN
   DEFINE(TSK_TI_TTBR0,		offsetof(struct task_struct, thread_info.ttbr0));
 #endif
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 773b3fea..7c8b164 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -258,6 +258,9 @@ alternative_else_nop_endif
 
 	/* switch to the irq stack */
 	mov	sp, x26
+#ifdef CONFIG_VMAP_STACK
+	str	x25, [tsk, #TSK_TI_CUR_STK]
+#endif
 
 	/*
 	 * Add a dummy stack frame, this non-standard format is fixed up
@@ -275,6 +278,10 @@ alternative_else_nop_endif
 	 */
 	.macro	irq_stack_exit
 	mov	sp, x19
+#ifdef CONFIG_VMAP_STACK
+	and	x19, x19, #~(THREAD_SIZE - 1)
+	str	x19, [tsk, #TSK_TI_CUR_STK]
+#endif
 	.endm
 
 /*
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index db77cac..3363846 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -325,6 +325,9 @@ __primary_switched:
 	add	sp, x4, #THREAD_SIZE
 	adr_l	x5, init_task
 	msr	tpidr_el1, x5			// Save thread_info
+#ifdef CONFIG_VMAP_STACK
+	str	x4, [x5, #TSK_TI_CUR_STK]
+#endif
 
 	adr_l	x8, vectors			// load VBAR_EL1 with virtual
 	msr	vbar_el1, x8			// vector table address
@@ -616,6 +619,9 @@ __secondary_switched:
 	mov	x3, #THREAD_START_SP
 	add	sp, x1, x3
 	ldr	x2, [x0, #CPU_BOOT_TASK]
+#ifdef CONFIG_VMAP_STACK
+	str	x1, [x2, #TSK_TI_CUR_STK]
+#endif
 	msr	tpidr_el1, x2
 	mov	x29, #0
 	b	secondary_start_kernel
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 4212da3..5dc5797 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -294,6 +294,10 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
 
 	ptrace_hw_copy_thread(p);
 
+#ifdef CONFIG_VMAP_STACK
+	p->thread_info.current_stack = (unsigned long)p->stack;
+#endif
+
 	return 0;
 }
 
-- 
1.9.1
