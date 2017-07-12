From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 12 Jul 2017 15:44:20 +0100
Message-Id: <20170712144424.19528-8-ard.biesheuvel@linaro.org>
In-Reply-To: <20170712144424.19528-1-ard.biesheuvel@linaro.org>
References: <20170712144424.19528-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [RFC PATCH 07/10] arm64: kernel: switch to register x18 as a task struct pointer
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
Cc: mark.rutland@arm.com, labbott@fedoraproject.org, will.deacon@arm.com, dave.martin@arm.com, catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

In order to free up sp_el0, which we will need to deal with faulting
stack accesses when using virtually mapped stacks, switch to register
x18 as the task struct register. This is permitted by the AAPCS64 ABI,
and simplifies many references to 'current', given that they no longer
involve a MSR instruction to access SP_EL0.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/asm-uaccess.h |  3 +--
 arch/arm64/include/asm/assembler.h   |  8 +-------
 arch/arm64/include/asm/current.h     |  6 ++----
 arch/arm64/kernel/entry.S            | 14 ++------------
 arch/arm64/kernel/head.S             |  6 ++----
 arch/arm64/kernel/process.c          |  2 +-
 6 files changed, 9 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/include/asm/asm-uaccess.h b/arch/arm64/include/asm/asm-uaccess.h
index ecd9788cd298..db5af0dda311 100644
--- a/arch/arm64/include/asm/asm-uaccess.h
+++ b/arch/arm64/include/asm/asm-uaccess.h
@@ -18,8 +18,7 @@
 	.endm
 
 	.macro	__uaccess_ttbr0_enable, tmp1
-	get_thread_info \tmp1
-	ldr	\tmp1, [\tmp1, #TSK_TI_TTBR0]	// load saved TTBR0_EL1
+	ldr	\tmp1, [tsk, #TSK_TI_TTBR0]	// load saved TTBR0_EL1
 	msr	ttbr0_el1, \tmp1		// set the non-PAN TTBR0_EL1
 	isb
 	.endm
diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 1b67c3782d00..de3335c21632 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -123,6 +123,7 @@
  * Register aliases.
  */
 lr	.req	x30		// link register
+tsk	.req	x18		// current task_struct
 
 /*
  * Vector entry
@@ -435,13 +436,6 @@ alternative_endif
 	.endm
 
 /*
- * Return the current thread_info.
- */
-	.macro	get_thread_info, rd
-	mrs	\rd, sp_el0
-	.endm
-
-/*
  * Errata workaround prior to TTBR0_EL1 update
  *
  * 	val:	TTBR value with new BADDR, preserved
diff --git a/arch/arm64/include/asm/current.h b/arch/arm64/include/asm/current.h
index f6580d4afb0e..b4e3acff699c 100644
--- a/arch/arm64/include/asm/current.h
+++ b/arch/arm64/include/asm/current.h
@@ -13,11 +13,9 @@ struct task_struct;
  */
 static __always_inline struct task_struct *get_current(void)
 {
-	unsigned long sp_el0;
+	register unsigned long tsk asm ("x18");
 
-	asm ("mrs %0, sp_el0" : "=r" (sp_el0));
-
-	return (struct task_struct *)sp_el0;
+	return (struct task_struct *)tsk;
 }
 
 #define current get_current()
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index b738880350f9..2ba3185b1c78 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -99,7 +99,6 @@
 	mov	x29, xzr			// fp pointed to user-space
 	.else
 	add	x21, sp, #S_FRAME_SIZE
-	get_thread_info tsk
 	/* Save the task's original addr_limit and set USER_DS (TASK_SIZE_64) */
 	ldr	x20, [tsk, #TSK_TI_ADDR_LIMIT]
 	str	x20, [sp, #S_ORIG_ADDR_LIMIT]
@@ -147,13 +146,6 @@ alternative_else_nop_endif
 	.endif
 
 	/*
-	 * Set sp_el0 to current thread_info.
-	 */
-	.if	\el == 0
-	msr	sp_el0, tsk
-	.endif
-
-	/*
 	 * Registers that may be useful after this macro is invoked:
 	 *
 	 * x21 - aborted SP
@@ -293,7 +285,6 @@ alternative_else_nop_endif
 sc_nr	.req	x25		// number of system calls
 scno	.req	x26		// syscall number
 stbl	.req	x27		// syscall table pointer
-tsk	.req	x28		// current thread_info
 
 /*
  * Interrupt handling.
@@ -734,7 +725,7 @@ ENTRY(cpu_switch_to)
 	ldp	x29, x9, [x8], #16
 	ldr	lr, [x8]
 	mov	sp, x9
-	msr	sp_el0, x1
+	mov	tsk, x1
 	ret
 ENDPROC(cpu_switch_to)
 
@@ -788,8 +779,7 @@ ENTRY(ret_from_fork)
 	cbz	x19, 1f				// not a kernel thread
 	mov	x0, x20
 	blr	x19
-1:	get_thread_info tsk
-	b	ret_to_user
+1:	b	ret_to_user
 ENDPROC(ret_from_fork)
 
 /*
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 973df7de7bf8..9b2bb2b08b4f 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -323,8 +323,7 @@ ENDPROC(__create_page_tables)
 __primary_switched:
 	adrp	x4, init_thread_union
 	add	sp, x4, #THREAD_SIZE
-	adr_l	x5, init_task
-	msr	sp_el0, x5			// Save thread_info
+	adr_l	tsk, init_task			// Save thread_info
 
 	adr_l	x8, vectors			// load VBAR_EL1 with virtual
 	msr	vbar_el1, x8			// vector table address
@@ -614,8 +613,7 @@ __secondary_switched:
 	adr_l	x0, secondary_data
 	ldr	x1, [x0, #CPU_BOOT_STACK]	// get secondary_data.stack
 	mov	sp, x1
-	ldr	x2, [x0, #CPU_BOOT_TASK]
-	msr	sp_el0, x2
+	ldr	tsk, [x0, #CPU_BOOT_TASK]
 	mov	x29, #0
 	b	secondary_start_kernel
 ENDPROC(__secondary_switched)
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 659ae8094ed5..b0c9caa9da11 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -329,7 +329,7 @@ void uao_thread_switch(struct task_struct *next)
 }
 
 /*
- * We store our current task in sp_el0, which is clobbered by userspace. Keep a
+ * We store our current task in x18, which is clobbered by userspace. Keep a
  * shadow copy so that we can restore this upon entry from userspace.
  *
  * This is *only* for exception entry from EL0, and is not valid until we
-- 
2.9.3
