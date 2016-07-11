Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 11 Jul 2016 13:53:54 -0700
Message-Id: <905d951956bee9ae58a6312ad21aa7a52503d368.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v5 21/32] x86/asm: Move 'status' from struct thread_info to struct thread_struct
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Becuase sched.h and thread_info.h are a tangled mess, I turned
in_compat_syscall into a macro.  If we had current_thread_struct()
or similar and we could use it from thread_info.h, then this would
be a bit cleaner.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/entry/common.c            |  4 ++--
 arch/x86/include/asm/processor.h   | 12 ++++++++++++
 arch/x86/include/asm/syscall.h     | 23 +++++------------------
 arch/x86/include/asm/thread_info.h | 23 ++++-------------------
 arch/x86/kernel/asm-offsets.c      |  1 -
 arch/x86/kernel/fpu/init.c         |  1 -
 arch/x86/kernel/process_64.c       |  4 ++--
 arch/x86/kernel/ptrace.c           |  2 +-
 8 files changed, 26 insertions(+), 44 deletions(-)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index ec138e538c44..c4150bec7982 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -271,7 +271,7 @@ __visible inline void prepare_exit_to_usermode(struct pt_regs *regs)
 	 * syscalls.  The fixup is exercised by the ptrace_syscall_32
 	 * selftest.
 	 */
-	ti->status &= ~TS_COMPAT;
+	current->thread.status &= ~TS_COMPAT;
 #endif
 
 	user_enter();
@@ -369,7 +369,7 @@ static __always_inline void do_syscall_32_irqs_on(struct pt_regs *regs)
 	unsigned int nr = (unsigned int)regs->orig_ax;
 
 #ifdef CONFIG_IA32_EMULATION
-	ti->status |= TS_COMPAT;
+	current->thread.status |= TS_COMPAT;
 #endif
 
 	if (READ_ONCE(ti->flags) & _TIF_WORK_SYSCALL_ENTRY) {
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index a2e20d6d01fe..a75e720f6402 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -388,6 +388,9 @@ struct thread_struct {
 	unsigned short		fsindex;
 	unsigned short		gsindex;
 #endif
+
+	u32			status;		/* thread synchronous flags */
+
 #ifdef CONFIG_X86_32
 	unsigned long		ip;
 #endif
@@ -437,6 +440,15 @@ struct thread_struct {
 };
 
 /*
+ * Thread-synchronous status.
+ *
+ * This is different from the flags in that nobody else
+ * ever touches our thread-synchronous status, so we don't
+ * have to worry about atomic accesses.
+ */
+#define TS_COMPAT		0x0002	/* 32bit syscall active (64BIT)*/
+
+/*
  * Set IOPL bits in EFLAGS from given mask
  */
 static inline void native_set_iopl_mask(unsigned mask)
diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index 999b7cd2e78c..17229e7e2a1c 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -60,7 +60,7 @@ static inline long syscall_get_error(struct task_struct *task,
 	 * TS_COMPAT is set for 32-bit syscall entries and then
 	 * remains set until we return to user mode.
 	 */
-	if (task_thread_info(task)->status & TS_COMPAT)
+	if (task->thread.status & TS_COMPAT)
 		/*
 		 * Sign-extend the value so (int)-EFOO becomes (long)-EFOO
 		 * and will match correctly in comparisons.
@@ -116,7 +116,7 @@ static inline void syscall_get_arguments(struct task_struct *task,
 					 unsigned long *args)
 {
 # ifdef CONFIG_IA32_EMULATION
-	if (task_thread_info(task)->status & TS_COMPAT)
+	if (task->thread.status & TS_COMPAT)
 		switch (i) {
 		case 0:
 			if (!n--) break;
@@ -177,7 +177,7 @@ static inline void syscall_set_arguments(struct task_struct *task,
 					 const unsigned long *args)
 {
 # ifdef CONFIG_IA32_EMULATION
-	if (task_thread_info(task)->status & TS_COMPAT)
+	if (task->thread.status & TS_COMPAT)
 		switch (i) {
 		case 0:
 			if (!n--) break;
@@ -234,21 +234,8 @@ static inline void syscall_set_arguments(struct task_struct *task,
 
 static inline int syscall_get_arch(void)
 {
-#ifdef CONFIG_IA32_EMULATION
-	/*
-	 * TS_COMPAT is set for 32-bit syscall entry and then
-	 * remains set until we return to user mode.
-	 *
-	 * TIF_IA32 tasks should always have TS_COMPAT set at
-	 * system call time.
-	 *
-	 * x32 tasks should be considered AUDIT_ARCH_X86_64.
-	 */
-	if (task_thread_info(current)->status & TS_COMPAT)
-		return AUDIT_ARCH_I386;
-#endif
-	/* Both x32 and x86_64 are considered "64-bit". */
-	return AUDIT_ARCH_X86_64;
+	/* x32 tasks should be considered AUDIT_ARCH_X86_64. */
+	return in_ia32_syscall() ? AUDIT_ARCH_I386 : AUDIT_ARCH_X86_64;
 }
 #endif	/* CONFIG_X86_32 */
 
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index b45ffdda3549..7b42c1e462ac 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -55,7 +55,6 @@ struct task_struct;
 struct thread_info {
 	struct task_struct	*task;		/* main task structure */
 	__u32			flags;		/* low level flags */
-	__u32			status;		/* thread synchronous flags */
 	__u32			cpu;		/* current CPU */
 };
 
@@ -211,28 +210,14 @@ static inline unsigned long current_stack_pointer(void)
 
 #endif
 
-/*
- * Thread-synchronous status.
- *
- * This is different from the flags in that nobody else
- * ever touches our thread-synchronous status, so we don't
- * have to worry about atomic accesses.
- */
-#define TS_COMPAT		0x0002	/* 32bit syscall active (64BIT)*/
-
 #ifndef __ASSEMBLY__
 
-static inline bool in_ia32_syscall(void)
-{
 #ifdef CONFIG_X86_32
-	return true;
-#endif
-#ifdef CONFIG_IA32_EMULATION
-	if (current_thread_info()->status & TS_COMPAT)
-		return true;
+#define in_ia32_syscall() true
+#else
+#define in_ia32_syscall() (IS_ENABLED(CONFIG_IA32_EMULATION) && \
+			   current->thread.status & TS_COMPAT)
 #endif
-	return false;
-}
 
 /*
  * Force syscall return via IRET by making it look as if there was
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 2bd5c6ff7ee7..a91a6ead24a2 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -30,7 +30,6 @@
 void common(void) {
 	BLANK();
 	OFFSET(TI_flags, thread_info, flags);
-	OFFSET(TI_status, thread_info, status);
 
 	BLANK();
 	OFFSET(TASK_addr_limit, task_struct, thread.addr_limit);
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index aacfd7a82cec..4579c1544ed1 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -327,7 +327,6 @@ static void __init fpu__init_system_ctx_switch(void)
 	on_boot_cpu = 0;
 
 	WARN_ON_FPU(current->thread.fpu.fpstate_active);
-	current_thread_info()->status = 0;
 
 	if (boot_cpu_has(X86_FEATURE_XSAVEOPT) && eagerfpu != DISABLE)
 		eagerfpu = ENABLE;
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6e789ca1f841..e6d53b641ef0 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -511,7 +511,7 @@ void set_personality_ia32(bool x32)
 		current->personality &= ~READ_IMPLIES_EXEC;
 		/* in_compat_syscall() uses the presence of the x32
 		   syscall bit flag to determine compat status */
-		current_thread_info()->status &= ~TS_COMPAT;
+		current->thread.status &= ~TS_COMPAT;
 	} else {
 		set_thread_flag(TIF_IA32);
 		clear_thread_flag(TIF_X32);
@@ -519,7 +519,7 @@ void set_personality_ia32(bool x32)
 			current->mm->context.ia32_compat = TIF_IA32;
 		current->personality |= force_personality32;
 		/* Prepare the first "return" to user space */
-		current_thread_info()->status |= TS_COMPAT;
+		current->thread.status |= TS_COMPAT;
 	}
 }
 EXPORT_SYMBOL_GPL(set_personality_ia32);
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 600edd225e81..4f03301ecfbe 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -931,7 +931,7 @@ static int putreg32(struct task_struct *child, unsigned regno, u32 value)
 		 */
 		regs->orig_ax = value;
 		if (syscall_get_nr(child, regs) >= 0)
-			task_thread_info(child)->status |= TS_COMPAT;
+			child->thread.status |= TS_COMPAT;
 		break;
 
 	case offsetof(struct user32, regs.eflags):
-- 
2.7.4
