From: Eric Biggers <ebiggers3@gmail.com>
Date: Thu, 21 Sep 2017 11:52:38 -0700
Message-Id: <20170921185239.88398-3-ebiggers3@gmail.com>
In-Reply-To: <20170921185239.88398-1-ebiggers3@gmail.com>
References: <20170921185239.88398-1-ebiggers3@gmail.com>
Subject: [kernel-hardening] [PATCH v3 2/3] x86/fpu: tighten validation of user-supplied xstate_header
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dmitry Vyukov <dvyukov@google.com>, Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@kernel.org>, Kevin Hao <haokexin@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Wanpeng Li <wanpeng.li@hotmail.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Michael Halcrow <mhalcrow@google.com>, Eric Biggers <ebiggers@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Eric Biggers <ebiggers@google.com>

Move validation of user-supplied xstate_headers into a helper function
and call it from both the ptrace and sigreturn syscall paths.  The new
function also considers it to be an error if *any* reserved bits are
set, whereas before we were just clearing most of them.

This should reduce the chance of bugs that fail to correctly validate
user-supplied XSAVE areas.  It also will expose any broken userspace
programs that set the other reserved bits; this is desirable because
such programs will lose compatibility with future CPUs and kernels if
those bits are ever used for anything.  (There shouldn't be any such
programs, and in fact in the case where the compacted format is in use
we were already validating xfeatures.  But you never know...)

Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hao <haokexin@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Wanpeng Li <wanpeng.li@hotmail.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/include/asm/fpu/xstate.h | 25 +++++++++++++++++++++++++
 arch/x86/kernel/fpu/regset.c      | 21 +++++++--------------
 arch/x86/kernel/fpu/signal.c      | 19 +++++++++++--------
 arch/x86/kernel/fpu/xstate.c      | 27 ++++++++++-----------------
 4 files changed, 53 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index 1b2799e0699a..cf6542b76996 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -52,4 +52,29 @@ int copyout_from_xsaves(unsigned int pos, unsigned int count, void *kbuf,
 			void __user *ubuf, struct xregs_state *xsave);
 int copyin_to_xsaves(const void *kbuf, const void __user *ubuf,
 		     struct xregs_state *xsave);
+
+/* Validate an xstate header supplied by userspace (ptrace or sigreturn) */
+static inline int validate_xstate_header(const struct xstate_header *hdr)
+{
+	/* No unknown or supervisor features may be set */
+	if (hdr->xfeatures & (~xfeatures_mask | XFEATURE_MASK_SUPERVISOR))
+		return -EINVAL;
+
+	/* Userspace must use the uncompacted format */
+	if (hdr->xcomp_bv)
+		return -EINVAL;
+
+	/*
+	 * If 'reserved' is shrunken to add a new field, make sure to validate
+	 * that new field here!
+	 */
+	BUILD_BUG_ON(sizeof(hdr->reserved) != 48);
+
+	/* No reserved bits may be set */
+	if (memchr_inv(hdr->reserved, 0, sizeof(hdr->reserved)))
+		return -EINVAL;
+
+	return 0;
+}
+
 #endif
diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
index 8ab1a1f4d1c1..3fd3a2f4f591 100644
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -131,31 +131,24 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
 
 	fpu__activate_fpstate_write(fpu);
 
-	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
+	if (using_compacted_format()) {
 		ret = copyin_to_xsaves(kbuf, ubuf, xsave);
 	} else {
 		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, xsave, 0, -1);
-
-		/* xcomp_bv must be 0 when using uncompacted format */
-		if (!ret && xsave->header.xcomp_bv)
-			ret = -EINVAL;
+		if (!ret)
+			ret = validate_xstate_header(&xsave->header);
 	}
 
-	/*
-	 * In case of failure, mark all states as init:
-	 */
-	if (ret)
-		fpstate_init(&fpu->state);
-
 	/*
 	 * mxcsr reserved bits must be masked to zero for security reasons.
 	 */
 	xsave->i387.mxcsr &= mxcsr_feature_mask;
-	xsave->header.xfeatures &= xfeatures_mask;
+
 	/*
-	 * These bits must be zero.
+	 * In case of failure, mark all states as init:
 	 */
-	memset(&xsave->header.reserved, 0, 48);
+	if (ret)
+		fpstate_init(&fpu->state);
 
 	return ret;
 }
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 169d6e001d32..a325f0b25456 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -213,8 +213,11 @@ sanitize_restored_xstate(struct task_struct *tsk,
 	struct xstate_header *header = &xsave->header;
 
 	if (use_xsave()) {
-		/* These bits must be zero. */
-		memset(header->reserved, 0, 48);
+		/*
+		 * Note: we don't need to zero the reserved bits in the
+		 * xstate_header here because we either didn't copy them at all,
+		 * or we checked earlier that they aren't set.
+		 */
 
 		/*
 		 * Init the state that is not present in the memory
@@ -223,7 +226,7 @@ sanitize_restored_xstate(struct task_struct *tsk,
 		if (fx_only)
 			header->xfeatures = XFEATURE_MASK_FPSSE;
 		else
-			header->xfeatures &= (xfeatures_mask & xfeatures);
+			header->xfeatures &= xfeatures;
 	}
 
 	if (use_fxsr()) {
@@ -307,7 +310,7 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 		/*
 		 * For 32-bit frames with fxstate, copy the user state to the
 		 * thread's fpu state, reconstruct fxstate from the fsave
-		 * header. Sanitize the copied state etc.
+		 * header. Validate and sanitize the copied state.
 		 */
 		struct fpu *fpu = &tsk->thread.fpu;
 		struct user_i387_ia32_struct env;
@@ -329,10 +332,10 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 		} else {
 			err = __copy_from_user(&fpu->state.xsave,
 					       buf_fx, state_size);
-
-			/* xcomp_bv must be 0 when using uncompacted format */
-			if (!err && fpu->state.xsave.header.xcomp_bv)
-				err = -EINVAL;
+			if (!err) {
+				err = validate_xstate_header(
+						&fpu->state.xsave.header);
+			}
 		}
 
 		if (err || __copy_from_user(&env, buf, sizeof(env))) {
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index c24ac1efb12d..52018be79e27 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1018,41 +1018,34 @@ int copyout_from_xsaves(unsigned int pos, unsigned int count, void *kbuf,
 }
 
 /*
- * Convert from a ptrace standard-format buffer to kernel XSAVES format
- * and copy to the target thread. This is called from xstateregs_set() and
- * there we check the CPU has XSAVES and a whole standard-sized buffer
- * exists.
+ * Convert from a ptrace or sigreturn standard-format buffer to kernel XSAVES
+ * format and copy to the target thread.  This is called from xstateregs_set(),
+ * as well as potentially from the sigreturn() and rt_sigreturn() system calls.
  */
 int copyin_to_xsaves(const void *kbuf, const void __user *ubuf,
 		     struct xregs_state *xsave)
 {
 	unsigned int offset, size;
 	int i;
-	u64 xfeatures;
-	u64 allowed_features;
+	struct xstate_header hdr;
 
 	offset = offsetof(struct xregs_state, header);
-	size = sizeof(xfeatures);
+	size = sizeof(hdr);
 
 	if (kbuf) {
-		memcpy(&xfeatures, kbuf + offset, size);
+		memcpy(&hdr, kbuf + offset, size);
 	} else {
-		if (__copy_from_user(&xfeatures, ubuf + offset, size))
+		if (__copy_from_user(&hdr, ubuf + offset, size))
 			return -EFAULT;
 	}
 
-	/*
-	 * Reject if the user sets any disabled or supervisor features:
-	 */
-	allowed_features = xfeatures_mask & ~XFEATURE_MASK_SUPERVISOR;
-
-	if (xfeatures & ~allowed_features)
+	if (validate_xstate_header(&hdr) != 0)
 		return -EINVAL;
 
 	for (i = 0; i < XFEATURE_MAX; i++) {
 		u64 mask = ((u64)1 << i);
 
-		if (xfeatures & mask) {
+		if (hdr.xfeatures & mask) {
 			void *dst = __raw_xsave_addr(xsave, 1 << i);
 
 			offset = xstate_offsets[i];
@@ -1076,7 +1069,7 @@ int copyin_to_xsaves(const void *kbuf, const void __user *ubuf,
 	/*
 	 * Add back in the features that came in from userspace:
 	 */
-	xsave->header.xfeatures |= xfeatures;
+	xsave->header.xfeatures |= hdr.xfeatures;
 
 	return 0;
 }
-- 
2.14.1.821.g8fa685d3b7-goog
