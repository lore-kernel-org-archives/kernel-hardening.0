Date: Wed, 29 Mar 2017 13:39:08 -0700
From: Kees Cook <keescook@chromium.org>
Message-ID: <20170329203908.GA39222@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] x86/fpu: move FPU state into separate cache
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@redhat.com>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, Thomas Garnier <thgarnie@google.com>, Brian Gerst <brgerst@gmail.com>, He Chen <he.chen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Fenghua Yu <fenghua.yu@intel.com>, Piotr Luc <piotr.luc@intel.com>, Kyle Huey <me@kylehuey.com>, Len Brown <len.brown@intel.com>, kvm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This removes ARCH_WANTS_DYNAMIC_TASK_STRUCT from x86, leaving only s390
still defining this config.

In order to support future structure layout randomization of the
task_struct, none of the structure fields are allowed to have a specific
position or dynamic size. To enable randomization of task_struct on
x86, the FPU state must be moved to its own dynamically sized cache,
and dereferenced from the task_struct.

This change is nearly identical to what was done in grsecurity to support
structure layout randomization. Hopefully I found all the needed changes.
This passes allyesconfig, and boot tests.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/Kconfig                    |  1 -
 arch/x86/include/asm/fpu/internal.h | 16 ++++++------
 arch/x86/include/asm/fpu/types.h    |  6 +----
 arch/x86/include/asm/processor.h    | 10 +++-----
 arch/x86/include/asm/trace/fpu.h    |  4 +--
 arch/x86/kernel/fpu/core.c          | 31 +++++++++++------------
 arch/x86/kernel/fpu/init.c          | 50 ++-----------------------------------
 arch/x86/kernel/fpu/regset.c        | 24 +++++++++---------
 arch/x86/kernel/fpu/signal.c        | 12 ++++-----
 arch/x86/kernel/fpu/xstate.c        |  6 ++---
 arch/x86/kernel/process.c           | 24 ++++++++++++++++--
 arch/x86/kvm/x86.c                  | 36 ++++++++++++++++----------
 include/linux/sched.h               |  5 ++--
 13 files changed, 100 insertions(+), 125 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9a5af1e1cd61..13b54a5ddfde 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -71,7 +71,6 @@ config X86
 	select ARCH_USE_QUEUED_SPINLOCKS
 	select ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH if SMP
 	select ARCH_WANT_FRAME_POINTERS
-	select ARCH_WANTS_DYNAMIC_TASK_STRUCT
 	select BUILDTIME_EXTABLE_SORT
 	select CLKEVT_I8253
 	select CLOCKSOURCE_VALIDATE_LAST_CYCLE
diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 255645f60ca2..f564c29d5194 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -196,9 +196,9 @@ static inline int copy_user_to_fregs(struct fregs_state __user *fx)
 static inline void copy_fxregs_to_kernel(struct fpu *fpu)
 {
 	if (IS_ENABLED(CONFIG_X86_32))
-		asm volatile( "fxsave %[fx]" : [fx] "=m" (fpu->state.fxsave));
+		asm volatile( "fxsave %[fx]" : [fx] "=m" (fpu->state->fxsave));
 	else if (IS_ENABLED(CONFIG_AS_FXSAVEQ))
-		asm volatile("fxsaveq %[fx]" : [fx] "=m" (fpu->state.fxsave));
+		asm volatile("fxsaveq %[fx]" : [fx] "=m" (fpu->state->fxsave));
 	else {
 		/* Using "rex64; fxsave %0" is broken because, if the memory
 		 * operand uses any extended registers for addressing, a second
@@ -215,15 +215,15 @@ static inline void copy_fxregs_to_kernel(struct fpu *fpu)
 		 * an extended register is needed for addressing (fix submitted
 		 * to mainline 2005-11-21).
 		 *
-		 *  asm volatile("rex64/fxsave %0" : "=m" (fpu->state.fxsave));
+		 *  asm volatile("rex64/fxsave %0" : "=m" (fpu->state->fxsave));
 		 *
 		 * This, however, we can work around by forcing the compiler to
 		 * select an addressing mode that doesn't require extended
 		 * registers.
 		 */
 		asm volatile( "rex64/fxsave (%[fx])"
-			     : "=m" (fpu->state.fxsave)
-			     : [fx] "R" (&fpu->state.fxsave));
+			     : "=m" (fpu->state->fxsave)
+			     : [fx] "R" (&fpu->state->fxsave));
 	}
 }
 
@@ -432,7 +432,7 @@ static inline int copy_user_to_xregs(struct xregs_state __user *buf, u64 mask)
 static inline int copy_fpregs_to_fpstate(struct fpu *fpu)
 {
 	if (likely(use_xsave())) {
-		copy_xregs_to_kernel(&fpu->state.xsave);
+		copy_xregs_to_kernel(&fpu->state->xsave);
 		return 1;
 	}
 
@@ -445,7 +445,7 @@ static inline int copy_fpregs_to_fpstate(struct fpu *fpu)
 	 * Legacy FPU register saving, FNSAVE always clears FPU registers,
 	 * so we have to mark them inactive:
 	 */
-	asm volatile("fnsave %[fp]; fwait" : [fp] "=m" (fpu->state.fsave));
+	asm volatile("fnsave %[fp]; fwait" : [fp] "=m" (fpu->state->fsave));
 
 	return 0;
 }
@@ -599,7 +599,7 @@ static inline void switch_fpu_finish(struct fpu *new_fpu, int cpu)
 
 	if (preload) {
 		if (!fpregs_state_valid(new_fpu, cpu))
-			copy_kernel_to_fpregs(&new_fpu->state);
+			copy_kernel_to_fpregs(new_fpu->state);
 		fpregs_activate(new_fpu);
 	}
 }
diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index 3c80f5b9c09d..c828fefc2133 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -330,11 +330,7 @@ struct fpu {
 	 * copy. If the task context-switches away then they get
 	 * saved here and represent the FPU state.
 	 */
-	union fpregs_state		state;
-	/*
-	 * WARNING: 'state' is dynamically-sized.  Do not put
-	 * anything after it here.
-	 */
+	union fpregs_state		*state;
 };
 
 #endif /* _ASM_X86_FPU_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index e2335edb9fc5..fcf76cb0ae1c 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -440,6 +440,8 @@ struct thread_struct {
 	unsigned long gs;
 #endif
 
+	/* Floating point and extended processor state */
+	struct fpu		fpu;
 	/* Save middle states of ptrace breakpoints */
 	struct perf_event	*ptrace_bps[HBP_NUM];
 	/* Debug status used for traps, single steps, etc... */
@@ -464,13 +466,6 @@ struct thread_struct {
 
 	unsigned int		sig_on_uaccess_err:1;
 	unsigned int		uaccess_err:1;	/* uaccess failed */
-
-	/* Floating point and extended processor state */
-	struct fpu		fpu;
-	/*
-	 * WARNING: 'fpu' is dynamically-sized.  It *MUST* be at
-	 * the end.
-	 */
 };
 
 /*
@@ -803,6 +798,7 @@ static inline void spin_lock_prefetch(const void *x)
 	.sysenter_cs		= __KERNEL_CS,				  \
 	.io_bitmap_ptr		= NULL,					  \
 	.addr_limit		= KERNEL_DS,				  \
+	.fpu.state		= &init_fpregs_state,			  \
 }
 
 /*
diff --git a/arch/x86/include/asm/trace/fpu.h b/arch/x86/include/asm/trace/fpu.h
index 342e59789fcd..4c07f7b49773 100644
--- a/arch/x86/include/asm/trace/fpu.h
+++ b/arch/x86/include/asm/trace/fpu.h
@@ -23,8 +23,8 @@ DECLARE_EVENT_CLASS(x86_fpu,
 		__entry->fpregs_active	= fpu->fpregs_active;
 		__entry->fpstate_active	= fpu->fpstate_active;
 		if (boot_cpu_has(X86_FEATURE_OSXSAVE)) {
-			__entry->xfeatures = fpu->state.xsave.header.xfeatures;
-			__entry->xcomp_bv  = fpu->state.xsave.header.xcomp_bv;
+			__entry->xfeatures = fpu->state->xsave.header.xfeatures;
+			__entry->xcomp_bv  = fpu->state->xsave.header.xcomp_bv;
 		}
 	),
 	TP_printk("x86/fpu: %p fpregs_active: %d fpstate_active: %d xfeatures: %llx xcomp_bv: %llx",
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index e1114f070c2d..f935effa0b69 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -117,7 +117,7 @@ void __kernel_fpu_end(void)
 	struct fpu *fpu = &current->thread.fpu;
 
 	if (fpu->fpregs_active)
-		copy_kernel_to_fpregs(&fpu->state);
+		copy_kernel_to_fpregs(fpu->state);
 
 	kernel_fpu_enable();
 }
@@ -150,7 +150,7 @@ void fpu__save(struct fpu *fpu)
 	trace_x86_fpu_before_save(fpu);
 	if (fpu->fpregs_active) {
 		if (!copy_fpregs_to_fpstate(fpu)) {
-			copy_kernel_to_fpregs(&fpu->state);
+			copy_kernel_to_fpregs(fpu->state);
 		}
 	}
 	trace_x86_fpu_after_save(fpu);
@@ -201,7 +201,7 @@ int fpu__copy(struct fpu *dst_fpu, struct fpu *src_fpu)
 	 * Don't let 'init optimized' areas of the XSAVE area
 	 * leak into the child task:
 	 */
-	memset(&dst_fpu->state.xsave, 0, fpu_kernel_xstate_size);
+	memset(&dst_fpu->state->xsave, 0, fpu_kernel_xstate_size);
 
 	/*
 	 * Save current FPU registers directly into the child
@@ -220,10 +220,9 @@ int fpu__copy(struct fpu *dst_fpu, struct fpu *src_fpu)
 	 */
 	preempt_disable();
 	if (!copy_fpregs_to_fpstate(dst_fpu)) {
-		memcpy(&src_fpu->state, &dst_fpu->state,
-		       fpu_kernel_xstate_size);
+		memcpy(src_fpu->state, dst_fpu->state, fpu_kernel_xstate_size);
 
-		copy_kernel_to_fpregs(&src_fpu->state);
+		copy_kernel_to_fpregs(src_fpu->state);
 	}
 	preempt_enable();
 
@@ -242,7 +241,7 @@ void fpu__activate_curr(struct fpu *fpu)
 	WARN_ON_FPU(fpu != &current->thread.fpu);
 
 	if (!fpu->fpstate_active) {
-		fpstate_init(&fpu->state);
+		fpstate_init(fpu->state);
 		trace_x86_fpu_init_state(fpu);
 
 		trace_x86_fpu_activate_state(fpu);
@@ -270,7 +269,7 @@ void fpu__activate_fpstate_read(struct fpu *fpu)
 		fpu__save(fpu);
 	} else {
 		if (!fpu->fpstate_active) {
-			fpstate_init(&fpu->state);
+			fpstate_init(fpu->state);
 			trace_x86_fpu_init_state(fpu);
 
 			trace_x86_fpu_activate_state(fpu);
@@ -305,7 +304,7 @@ void fpu__activate_fpstate_write(struct fpu *fpu)
 		/* Invalidate any lazy state: */
 		__fpu_invalidate_fpregs_state(fpu);
 	} else {
-		fpstate_init(&fpu->state);
+		fpstate_init(fpu->state);
 		trace_x86_fpu_init_state(fpu);
 
 		trace_x86_fpu_activate_state(fpu);
@@ -368,7 +367,7 @@ void fpu__current_fpstate_write_end(void)
 	 * an XRSTOR if they are active.
 	 */
 	if (fpregs_active())
-		copy_kernel_to_fpregs(&fpu->state);
+		copy_kernel_to_fpregs(fpu->state);
 
 	/*
 	 * Our update is done and the fpregs/fpstate are in sync
@@ -395,7 +394,7 @@ void fpu__restore(struct fpu *fpu)
 	kernel_fpu_disable();
 	trace_x86_fpu_before_restore(fpu);
 	fpregs_activate(fpu);
-	copy_kernel_to_fpregs(&fpu->state);
+	copy_kernel_to_fpregs(fpu->state);
 	trace_x86_fpu_after_restore(fpu);
 	kernel_fpu_enable();
 }
@@ -489,11 +488,11 @@ int fpu__exception_code(struct fpu *fpu, int trap_nr)
 		 * fully reproduce the context of the exception.
 		 */
 		if (boot_cpu_has(X86_FEATURE_FXSR)) {
-			cwd = fpu->state.fxsave.cwd;
-			swd = fpu->state.fxsave.swd;
+			cwd = fpu->state->fxsave.cwd;
+			swd = fpu->state->fxsave.swd;
 		} else {
-			cwd = (unsigned short)fpu->state.fsave.cwd;
-			swd = (unsigned short)fpu->state.fsave.swd;
+			cwd = (unsigned short)fpu->state->fsave.cwd;
+			swd = (unsigned short)fpu->state->fsave.swd;
 		}
 
 		err = swd & ~cwd;
@@ -507,7 +506,7 @@ int fpu__exception_code(struct fpu *fpu, int trap_nr)
 		unsigned short mxcsr = MXCSR_DEFAULT;
 
 		if (boot_cpu_has(X86_FEATURE_XMM))
-			mxcsr = fpu->state.fxsave.mxcsr;
+			mxcsr = fpu->state->fxsave.mxcsr;
 
 		err = ~(mxcsr >> 7) & mxcsr;
 	}
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index c2f8dde3255c..74a0fb816351 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -34,7 +34,7 @@ static void fpu__init_cpu_generic(void)
 	/* Flush out any pending x87 state: */
 #ifdef CONFIG_MATH_EMULATION
 	if (!boot_cpu_has(X86_FEATURE_FPU))
-		fpstate_init_soft(&current->thread.fpu.state.soft);
+		fpstate_init_soft(&current->thread.fpu.state->soft);
 	else
 #endif
 		asm volatile ("fninit");
@@ -137,51 +137,7 @@ static void __init fpu__init_system_generic(void)
 unsigned int fpu_kernel_xstate_size;
 EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size);
 
-/* Get alignment of the TYPE. */
-#define TYPE_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, test)
-
-/*
- * Enforce that 'MEMBER' is the last field of 'TYPE'.
- *
- * Align the computed size with alignment of the TYPE,
- * because that's how C aligns structs.
- */
-#define CHECK_MEMBER_AT_END_OF(TYPE, MEMBER) \
-	BUILD_BUG_ON(sizeof(TYPE) != ALIGN(offsetofend(TYPE, MEMBER), \
-					   TYPE_ALIGN(TYPE)))
-
-/*
- * We append the 'struct fpu' to the task_struct:
- */
-static void __init fpu__init_task_struct_size(void)
-{
-	int task_size = sizeof(struct task_struct);
-
-	/*
-	 * Subtract off the static size of the register state.
-	 * It potentially has a bunch of padding.
-	 */
-	task_size -= sizeof(((struct task_struct *)0)->thread.fpu.state);
-
-	/*
-	 * Add back the dynamically-calculated register state
-	 * size.
-	 */
-	task_size += fpu_kernel_xstate_size;
-
-	/*
-	 * We dynamically size 'struct fpu', so we require that
-	 * it be at the end of 'thread_struct' and that
-	 * 'thread_struct' be at the end of 'task_struct'.  If
-	 * you hit a compile error here, check the structure to
-	 * see if something got added to the end.
-	 */
-	CHECK_MEMBER_AT_END_OF(struct fpu, state);
-	CHECK_MEMBER_AT_END_OF(struct thread_struct, fpu);
-	CHECK_MEMBER_AT_END_OF(struct task_struct, thread);
-
-	arch_task_struct_size = task_size;
-}
+union fpregs_state init_fpregs_state;
 
 /*
  * Set up the user and kernel xstate sizes based on the legacy FPU context size.
@@ -285,7 +241,5 @@ void __init fpu__init_system(struct cpuinfo_x86 *c)
 	fpu__init_system_generic();
 	fpu__init_system_xstate_size_legacy();
 	fpu__init_system_xstate();
-	fpu__init_task_struct_size();
-
 	fpu__init_system_ctx_switch();
 }
diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
index b188b16841e3..c75bed318070 100644
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -42,7 +42,7 @@ int xfpregs_get(struct task_struct *target, const struct user_regset *regset,
 	fpstate_sanitize_xstate(fpu);
 
 	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-				   &fpu->state.fxsave, 0, -1);
+				   &fpu->state->fxsave, 0, -1);
 }
 
 int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
@@ -59,19 +59,19 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 	fpstate_sanitize_xstate(fpu);
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-				 &fpu->state.fxsave, 0, -1);
+				 &fpu->state->fxsave, 0, -1);
 
 	/*
 	 * mxcsr reserved bits must be masked to zero for security reasons.
 	 */
-	fpu->state.fxsave.mxcsr &= mxcsr_feature_mask;
+	fpu->state->fxsave.mxcsr &= mxcsr_feature_mask;
 
 	/*
 	 * update the header bits in the xsave header, indicating the
 	 * presence of FP and SSE state.
 	 */
 	if (boot_cpu_has(X86_FEATURE_XSAVE))
-		fpu->state.xsave.header.xfeatures |= XFEATURE_MASK_FPSSE;
+		fpu->state->xsave.header.xfeatures |= XFEATURE_MASK_FPSSE;
 
 	return ret;
 }
@@ -87,7 +87,7 @@ int xstateregs_get(struct task_struct *target, const struct user_regset *regset,
 	if (!boot_cpu_has(X86_FEATURE_XSAVE))
 		return -ENODEV;
 
-	xsave = &fpu->state.xsave;
+	xsave = &fpu->state->xsave;
 
 	fpu__activate_fpstate_read(fpu);
 
@@ -127,7 +127,7 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
 	if ((pos != 0) || (count < fpu_user_xstate_size))
 		return -EFAULT;
 
-	xsave = &fpu->state.xsave;
+	xsave = &fpu->state->xsave;
 
 	fpu__activate_fpstate_write(fpu);
 
@@ -140,7 +140,7 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
 	 * In case of failure, mark all states as init:
 	 */
 	if (ret)
-		fpstate_init(&fpu->state);
+		fpstate_init(fpu->state);
 
 	/*
 	 * mxcsr reserved bits must be masked to zero for security reasons.
@@ -230,7 +230,7 @@ static inline u32 twd_fxsr_to_i387(struct fxregs_state *fxsave)
 void
 convert_from_fxsr(struct user_i387_ia32_struct *env, struct task_struct *tsk)
 {
-	struct fxregs_state *fxsave = &tsk->thread.fpu.state.fxsave;
+	struct fxregs_state *fxsave = &tsk->thread.fpu.state->fxsave;
 	struct _fpreg *to = (struct _fpreg *) &env->st_space[0];
 	struct _fpxreg *from = (struct _fpxreg *) &fxsave->st_space[0];
 	int i;
@@ -268,7 +268,7 @@ void convert_to_fxsr(struct task_struct *tsk,
 		     const struct user_i387_ia32_struct *env)
 
 {
-	struct fxregs_state *fxsave = &tsk->thread.fpu.state.fxsave;
+	struct fxregs_state *fxsave = &tsk->thread.fpu.state->fxsave;
 	struct _fpreg *from = (struct _fpreg *) &env->st_space[0];
 	struct _fpxreg *to = (struct _fpxreg *) &fxsave->st_space[0];
 	int i;
@@ -306,7 +306,7 @@ int fpregs_get(struct task_struct *target, const struct user_regset *regset,
 
 	if (!boot_cpu_has(X86_FEATURE_FXSR))
 		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-					   &fpu->state.fsave, 0,
+					   &fpu->state->fsave, 0,
 					   -1);
 
 	fpstate_sanitize_xstate(fpu);
@@ -337,7 +337,7 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 
 	if (!boot_cpu_has(X86_FEATURE_FXSR))
 		return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-					  &fpu->state.fsave, 0,
+					  &fpu->state->fsave, 0,
 					  -1);
 
 	if (pos > 0 || count < sizeof(env))
@@ -352,7 +352,7 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 	 * presence of FP.
 	 */
 	if (boot_cpu_has(X86_FEATURE_XSAVE))
-		fpu->state.xsave.header.xfeatures |= XFEATURE_MASK_FP;
+		fpu->state->xsave.header.xfeatures |= XFEATURE_MASK_FP;
 	return ret;
 }
 
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 83c23c230b4c..d943bfa48e83 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -56,7 +56,7 @@ static inline int check_for_xstate(struct fxregs_state __user *buf,
 static inline int save_fsave_header(struct task_struct *tsk, void __user *buf)
 {
 	if (use_fxsr()) {
-		struct xregs_state *xsave = &tsk->thread.fpu.state.xsave;
+		struct xregs_state *xsave = &tsk->thread.fpu.state->xsave;
 		struct user_i387_ia32_struct env;
 		struct _fpstate_32 __user *fp = buf;
 
@@ -155,7 +155,7 @@ static inline int copy_fpregs_to_sigframe(struct xregs_state __user *buf)
  */
 int copy_fpstate_to_sigframe(void __user *buf, void __user *buf_fx, int size)
 {
-	struct xregs_state *xsave = &current->thread.fpu.state.xsave;
+	struct xregs_state *xsave = &current->thread.fpu.state->xsave;
 	struct task_struct *tsk = current;
 	int ia32_fxstate = (buf != buf_fx);
 
@@ -209,7 +209,7 @@ sanitize_restored_xstate(struct task_struct *tsk,
 			 struct user_i387_ia32_struct *ia32_env,
 			 u64 xfeatures, int fx_only)
 {
-	struct xregs_state *xsave = &tsk->thread.fpu.state.xsave;
+	struct xregs_state *xsave = &tsk->thread.fpu.state->xsave;
 	struct xstate_header *header = &xsave->header;
 
 	if (use_xsave()) {
@@ -325,14 +325,14 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 
 		if (using_compacted_format()) {
 			err = copyin_to_xsaves(NULL, buf_fx,
-					       &fpu->state.xsave);
+					       &fpu->state->xsave);
 		} else {
-			err = __copy_from_user(&fpu->state.xsave,
+			err = __copy_from_user(&fpu->state->xsave,
 					       buf_fx, state_size);
 		}
 
 		if (err || __copy_from_user(&env, buf, sizeof(env))) {
-			fpstate_init(&fpu->state);
+			fpstate_init(fpu->state);
 			trace_x86_fpu_init_state(fpu);
 			err = -1;
 		} else {
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index c24ac1efb12d..2ba5e6f18775 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -157,14 +157,14 @@ static int xfeature_is_user(int xfeature_nr)
  */
 void fpstate_sanitize_xstate(struct fpu *fpu)
 {
-	struct fxregs_state *fx = &fpu->state.fxsave;
+	struct fxregs_state *fx = &fpu->state->fxsave;
 	int feature_bit;
 	u64 xfeatures;
 
 	if (!use_xsaveopt())
 		return;
 
-	xfeatures = fpu->state.xsave.header.xfeatures;
+	xfeatures = fpu->state->xsave.header.xfeatures;
 
 	/*
 	 * None of the feature bits are in init state. So nothing else
@@ -875,7 +875,7 @@ const void *get_xsave_field_ptr(int xsave_state)
 	 */
 	fpu__save(fpu);
 
-	return get_xsave_addr(&fpu->state.xsave, xsave_state);
+	return get_xsave_addr(&fpu->state->xsave, xsave_state);
 }
 
 #ifdef CONFIG_ARCH_HAS_PKEYS
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 0bb88428cbf2..60129943a064 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -20,8 +20,8 @@
 #include <linux/dmi.h>
 #include <linux/utsname.h>
 #include <linux/stackprotector.h>
-#include <linux/tick.h>
 #include <linux/cpuidle.h>
+#include <linux/kthread.h>
 #include <trace/events/power.h>
 #include <linux/hw_breakpoint.h>
 #include <asm/cpu.h>
@@ -73,20 +73,40 @@ EXPORT_PER_CPU_SYMBOL(cpu_tss);
 DEFINE_PER_CPU(bool, __tss_limit_invalid);
 EXPORT_PER_CPU_SYMBOL_GPL(__tss_limit_invalid);
 
+struct kmem_cache *fpregs_state_cachep;
+EXPORT_SYMBOL(fpregs_state_cachep);
+
+void __init arch_task_cache_init(void)
+{
+	/* create a slab on which fpregs_states can be allocated */
+	fpregs_state_cachep = kmem_cache_create("fpregs_state",
+				fpu_kernel_xstate_size,
+				ARCH_MIN_TASKALIGN, SLAB_PANIC | SLAB_NOTRACK,
+				NULL);
+}
+
 /*
  * this gets called so that we can store lazy state into memory and copy the
  * current task into the new thread.
  */
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
-	memcpy(dst, src, arch_task_struct_size);
+	*dst = *src;
 #ifdef CONFIG_VM86
 	dst->thread.vm86 = NULL;
 #endif
+	dst->thread.fpu.state = kmem_cache_alloc_node(fpregs_state_cachep,
+					GFP_KERNEL, tsk_fork_get_node(src));
 
 	return fpu__copy(&dst->thread.fpu, &src->thread.fpu);
 }
 
+void arch_release_task_struct(struct task_struct *tsk)
+{
+	kmem_cache_free(fpregs_state_cachep, tsk->thread.fpu.state);
+	tsk->thread.fpu.state = NULL;
+}
+
 /*
  * Free current thread data structures etc..
  */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ee22226e3807..17d2cbc838d6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3213,7 +3213,7 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 
 static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
 {
-	struct xregs_state *xsave = &vcpu->arch.guest_fpu.state.xsave;
+	struct xregs_state *xsave = &vcpu->arch.guest_fpu.state->xsave;
 	u64 xstate_bv = xsave->header.xfeatures;
 	u64 valid;
 
@@ -3250,7 +3250,7 @@ static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
 
 static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
 {
-	struct xregs_state *xsave = &vcpu->arch.guest_fpu.state.xsave;
+	struct xregs_state *xsave = &vcpu->arch.guest_fpu.state->xsave;
 	u64 xstate_bv = *(u64 *)(src + XSAVE_HDR_OFFSET);
 	u64 valid;
 
@@ -3294,7 +3294,7 @@ static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 		fill_xsave((u8 *) guest_xsave->region, vcpu);
 	} else {
 		memcpy(guest_xsave->region,
-			&vcpu->arch.guest_fpu.state.fxsave,
+			&vcpu->arch.guest_fpu.state->fxsave,
 			sizeof(struct fxregs_state));
 		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)] =
 			XFEATURE_MASK_FPSSE;
@@ -3319,7 +3319,7 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 	} else {
 		if (xstate_bv & ~XFEATURE_MASK_FPSSE)
 			return -EINVAL;
-		memcpy(&vcpu->arch.guest_fpu.state.fxsave,
+		memcpy(&vcpu->arch.guest_fpu.state->fxsave,
 			guest_xsave->region, sizeof(struct fxregs_state));
 	}
 	return 0;
@@ -7545,7 +7545,7 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	struct fxregs_state *fxsave =
-			&vcpu->arch.guest_fpu.state.fxsave;
+			&vcpu->arch.guest_fpu.state->fxsave;
 
 	memcpy(fpu->fpr, fxsave->st_space, 128);
 	fpu->fcw = fxsave->cwd;
@@ -7562,7 +7562,7 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	struct fxregs_state *fxsave =
-			&vcpu->arch.guest_fpu.state.fxsave;
+			&vcpu->arch.guest_fpu.state->fxsave;
 
 	memcpy(fxsave->st_space, fpu->fpr, 128);
 	fxsave->cwd = fpu->fcw;
@@ -7578,9 +7578,9 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 
 static void fx_init(struct kvm_vcpu *vcpu)
 {
-	fpstate_init(&vcpu->arch.guest_fpu.state);
+	fpstate_init(vcpu->arch.guest_fpu.state);
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		vcpu->arch.guest_fpu.state.xsave.header.xcomp_bv =
+		vcpu->arch.guest_fpu.state->xsave.header.xcomp_bv =
 			host_xcr0 | XSTATE_COMPACTION_ENABLED;
 
 	/*
@@ -7603,7 +7603,7 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 	 */
 	vcpu->guest_fpu_loaded = 1;
 	__kernel_fpu_begin();
-	__copy_kernel_to_fpregs(&vcpu->arch.guest_fpu.state);
+	__copy_kernel_to_fpregs(vcpu->arch.guest_fpu.state);
 	trace_kvm_fpu(1);
 }
 
@@ -7891,6 +7891,8 @@ bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 struct static_key kvm_no_apic_vcpu __read_mostly;
 EXPORT_SYMBOL_GPL(kvm_no_apic_vcpu);
 
+extern struct kmem_cache *fpregs_state_cachep;
+
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct page *page;
@@ -7908,11 +7910,15 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	else
 		vcpu->arch.mp_state = KVM_MP_STATE_UNINITIALIZED;
 
-	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-	if (!page) {
-		r = -ENOMEM;
+	r = -ENOMEM;
+	vcpu->arch.guest_fpu.state = kmem_cache_alloc(fpregs_state_cachep,
+						      GFP_KERNEL);
+	if (!vcpu->arch.guest_fpu.state)
 		goto fail;
-	}
+
+	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!page)
+		goto fail_free_fpregs;
 	vcpu->arch.pio_data = page_address(page);
 
 	kvm_set_tsc_khz(vcpu, max_tsc_khz);
@@ -7970,6 +7976,8 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	kvm_mmu_destroy(vcpu);
 fail_free_pio_data:
 	free_page((unsigned long)vcpu->arch.pio_data);
+fail_free_fpregs:
+	kmem_cache_free(fpregs_state_cachep, vcpu->arch.guest_fpu.state);
 fail:
 	return r;
 }
@@ -7988,6 +7996,8 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 	free_page((unsigned long)vcpu->arch.pio_data);
 	if (!lapic_in_kernel(vcpu))
 		static_key_slow_dec(&kvm_no_apic_vcpu);
+	kmem_cache_free(fpregs_state_cachep, vcpu->arch.guest_fpu.state);
+	vcpu->arch.guest_fpu.state = NULL;
 }
 
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d31a8095237b..a7b239a87160 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1053,8 +1053,9 @@ struct task_struct {
 	struct thread_struct		thread;
 
 	/*
-	 * WARNING: on x86, 'thread_struct' contains a variable-sized
-	 * structure.  It *MUST* be at the end of 'task_struct'.
+	 * WARNING: Under CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT,
+	 * 'thread_struct' contains a variable-sized structure.
+	 * It *MUST* be at the end of 'task_struct'.
 	 *
 	 * Do not put anything below here!
 	 */
-- 
2.7.4


-- 
Kees Cook
Pixel Security
