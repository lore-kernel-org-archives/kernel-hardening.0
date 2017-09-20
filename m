From: Eric Biggers <ebiggers3@gmail.com>
Date: Tue, 19 Sep 2017 17:44:34 -0700
Message-Id: <20170920004434.35308-4-ebiggers3@gmail.com>
In-Reply-To: <20170920004434.35308-1-ebiggers3@gmail.com>
References: <20170920004434.35308-1-ebiggers3@gmail.com>
Subject: [kernel-hardening] [PATCH v2 3/3] x86/fpu: reinitialize FPU registers if restoring FPU state fails
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dmitry Vyukov <dvyukov@google.com>, Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@kernel.org>, Kevin Hao <haokexin@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Wanpeng Li <wanpeng.li@hotmail.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Michael Halcrow <mhalcrow@google.com>, Eric Biggers <ebiggers@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Eric Biggers <ebiggers@google.com>

Userspace can change the FPU state of a task using the ptrace() or
rt_sigreturn() system calls.  Because reserved bits in the FPU state can
cause the XRSTOR instruction to fail, the kernel has to carefully
validate that no reserved bits or other invalid values are being set.

Unfortunately, there have been bugs in this validation code.  For
example, we were not checking that the 'xcomp_bv' field in the
xstate_header was 0.  As-is, such bugs are exploitable to read the FPU
registers of other processes on the system.  To do so, an attacker can
create a task, assign to it an invalid FPU state, then spin in a loop
and monitor the values of the FPU registers.  Because the task's FPU
registers are not being restored, sometimes the FPU registers will have
the values from another process.

This is likely to continue to be a problem in the future because the
validation done by the CPU instructions like XRSTOR is not immediately
visible to kernel developers.  Nor will invalid FPU states ever be
encountered during ordinary use --- they will only be seen during
fuzzing or exploits.  There can even be reserved bits outside the
xstate_header which are easy to forget about.  For example, the MXCSR
register contains reserved bits, which were not validated by the
KVM_SET_XSAVE ioctl until commit a575813bfe4b ("KVM: x86: Fix load
damaged SSEx MXCSR register").

Therefore, mitigate this class of vulnerability by restoring the FPU
registers from init_fpstate if restoring from the task's state fails.

We actually used to do this, but it was (perhaps unwisely) removed by
commit 9ccc27a5d297 ("x86/fpu: Remove error return values from
copy_kernel_to_*regs() functions").  This new patch is also a bit
different in that it only clears the registers, not also the bad
in-memory state.  This is simpler and makes it easier to make the
mitigation cover all callers of __copy_kernel_to_fpregs().

Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hao <haokexin@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Wanpeng Li <wanpeng.li@hotmail.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/include/asm/fpu/internal.h | 29 ++++++++++++++++++++---------
 arch/x86/kernel/fpu/core.c          | 16 ++++++++++++++++
 2 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 554cdb205d17..4efd483d2407 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -104,6 +104,8 @@ static inline void fpstate_init_fxstate(struct fxregs_state *fx)
 }
 extern void fpstate_sanitize_xstate(struct fpu *fpu);
 
+extern void __handle_bad_fpstate(union fpregs_state *fpstate, u64 mask);
+
 #define user_insn(insn, output, input...)				\
 ({									\
 	int err;							\
@@ -151,7 +153,7 @@ static inline int copy_fxregs_to_user(struct fxregs_state __user *fx)
 	return user_insn(rex64/fxsave (%[fx]), "=m" (*fx), [fx] "R" (fx));
 }
 
-static inline void copy_kernel_to_fxregs(struct fxregs_state *fx)
+static inline int copy_kernel_to_fxregs(struct fxregs_state *fx)
 {
 	int err;
 
@@ -165,8 +167,8 @@ static inline void copy_kernel_to_fxregs(struct fxregs_state *fx)
 			err = check_insn(rex64/fxrstor (%[fx]), "=m" (*fx), [fx] "R" (fx), "m" (*fx));
 		}
 	}
-	/* Copying from a kernel buffer to FPU registers should never fail: */
 	WARN_ON_FPU(err);
+	return err;
 }
 
 static inline int copy_user_to_fxregs(struct fxregs_state __user *fx)
@@ -181,11 +183,12 @@ static inline int copy_user_to_fxregs(struct fxregs_state __user *fx)
 			  "m" (*fx));
 }
 
-static inline void copy_kernel_to_fregs(struct fregs_state *fx)
+static inline int copy_kernel_to_fregs(struct fregs_state *fx)
 {
 	int err = check_insn(frstor %[fx], "=m" (*fx), [fx] "m" (*fx));
 
 	WARN_ON_FPU(err);
+	return err;
 }
 
 static inline int copy_user_to_fregs(struct fregs_state __user *fx)
@@ -361,7 +364,7 @@ static inline void copy_xregs_to_kernel(struct xregs_state *xstate)
 /*
  * Restore processor xstate from xsave area.
  */
-static inline void copy_kernel_to_xregs(struct xregs_state *xstate, u64 mask)
+static inline int copy_kernel_to_xregs(struct xregs_state *xstate, u64 mask)
 {
 	u32 lmask = mask;
 	u32 hmask = mask >> 32;
@@ -369,8 +372,8 @@ static inline void copy_kernel_to_xregs(struct xregs_state *xstate, u64 mask)
 
 	XSTATE_XRESTORE(xstate, lmask, hmask, err);
 
-	/* We should never fault when copying from a kernel buffer: */
 	WARN_ON_FPU(err);
+	return err;
 }
 
 /*
@@ -450,18 +453,26 @@ static inline int copy_fpregs_to_fpstate(struct fpu *fpu)
 	return 0;
 }
 
-static inline void __copy_kernel_to_fpregs(union fpregs_state *fpstate, u64 mask)
+static inline int ____copy_kernel_to_fpregs(union fpregs_state *fpstate, u64 mask)
 {
 	if (use_xsave()) {
-		copy_kernel_to_xregs(&fpstate->xsave, mask);
+		return copy_kernel_to_xregs(&fpstate->xsave, mask);
 	} else {
 		if (use_fxsr())
-			copy_kernel_to_fxregs(&fpstate->fxsave);
+			return copy_kernel_to_fxregs(&fpstate->fxsave);
 		else
-			copy_kernel_to_fregs(&fpstate->fsave);
+			return copy_kernel_to_fregs(&fpstate->fsave);
 	}
 }
 
+static inline void __copy_kernel_to_fpregs(union fpregs_state *fpstate, u64 mask)
+{
+	int err = ____copy_kernel_to_fpregs(fpstate, mask);
+
+	if (unlikely(err))
+		__handle_bad_fpstate(fpstate, mask);
+}
+
 static inline void copy_kernel_to_fpregs(union fpregs_state *fpstate)
 {
 	/*
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index e1114f070c2d..85567db482e2 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -536,3 +536,19 @@ int fpu__exception_code(struct fpu *fpu, int trap_nr)
 	 */
 	return 0;
 }
+
+/*
+ * We should never get here because the fpregs_state stored in 'struct fpu'
+ * should always be readable and contain a valid FPU state.  However, past bugs
+ * have allowed userspace to set reserved bits in the XSAVE area using
+ * PTRACE_SETREGSET or sys_rt_sigreturn().  These caused XRSTOR to fail when
+ * switching to the task, leaking the FPU registers of the task previously
+ * executing on the CPU.  Mitigate this class of vulnerability by restoring from
+ * the initial state (essentially, zeroing out all the FPU registers) if we
+ * can't restore from the task's FPU state.
+ */
+void __handle_bad_fpstate(union fpregs_state *fpstate, u64 mask)
+{
+	WARN_ONCE(1, "Bad FPU state detected, reinitializing FPU registers");
+	____copy_kernel_to_fpregs(&init_fpstate, mask);
+}
-- 
2.14.1.690.gbb1197296e-goog
