Reply-To: kernel-hardening@lists.openwall.com
From: Scott Bauer <sbauer@eng.utah.edu>
Date: Tue, 29 Mar 2016 13:53:25 -0600
Message-Id: <1459281207-24377-3-git-send-email-sbauer@eng.utah.edu>
In-Reply-To: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
References: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
Subject: [kernel-hardening] [PATCH v4 2/4] x86: SROP Mitigation: Implement Signal Cookies
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, x86@kernel.org, ak@linux.intel.com, luto@amacapital.net, mingo@redhat.com, tglx@linutronix.de, wmealing@redhat.com, torvalds@linux-foundation.org, Scott Bauer <sbauer@eng.utah.edu>, Abhiram Balasubramanian <abhiram@cs.utah.edu>, Scott Bauer <sbauer@plzdonthack.me>
List-ID: <kernel-hardening.lists.openwall.com>

This patch adds SROP mitigation logic to the x86 signal delivery
and sigreturn code. The cookie is placed in the unused alignment
space above the saved FP state, if it exists. If there is no FP
state to save then the cookie is placed in the alignment space above
the sigframe.

Cc: Abhiram Balasubramanian <abhiram@cs.utah.edu>
Signed-off-by: Scott Bauer <sbauer@plzdonthack.me>
Signed-off-by: Scott Bauer <sbauer@eng.utah.edu>
---
 arch/x86/ia32/ia32_signal.c       | 65 +++++++++++++++++++++++++++---
 arch/x86/include/asm/fpu/signal.h |  2 +
 arch/x86/kernel/fpu/signal.c      | 10 +++++
 arch/x86/kernel/signal.c          | 83 ++++++++++++++++++++++++++++++++++-----
 4 files changed, 145 insertions(+), 15 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 0552884..85ec799 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -68,7 +68,8 @@
 }
 
 static int ia32_restore_sigcontext(struct pt_regs *regs,
-				   struct sigcontext_32 __user *sc)
+				   struct sigcontext_32 __user *sc,
+				   void **user_cookie_ptr)
 {
 	unsigned int tmpflags, err = 0;
 	void __user *buf;
@@ -105,6 +106,16 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 		buf = compat_ptr(tmp);
 	} get_user_catch(err);
 
+	/*
+	 * If there is fp state get cookie from the top of the fp state,
+	 * else get it from the top of the sig frame.
+	 */
+
+	if (tmp != 0)
+		*user_cookie_ptr = compat_ptr(tmp + fpu__getsize(1));
+	else
+		*user_cookie_ptr = NULL;
+
 	err |= fpu__restore_sig(buf, 1);
 
 	force_iret();
@@ -117,6 +128,7 @@ asmlinkage long sys32_sigreturn(void)
 	struct pt_regs *regs = current_pt_regs();
 	struct sigframe_ia32 __user *frame = (struct sigframe_ia32 __user *)(regs->sp-8);
 	sigset_t set;
+	void __user *user_cookie;
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
@@ -129,8 +141,16 @@ asmlinkage long sys32_sigreturn(void)
 
 	set_current_blocked(&set);
 
-	if (ia32_restore_sigcontext(regs, &frame->sc))
+	if (ia32_restore_sigcontext(regs, &frame->sc, &user_cookie))
 		goto badframe;
+
+	if (user_cookie == NULL)
+		user_cookie = compat_ptr(((unsigned long) frame) +
+					 sizeof(frame));
+
+	if (verify_clear_sigcookie(user_cookie))
+ 		goto badframe;
+
 	return regs->ax;
 
 badframe:
@@ -143,6 +163,7 @@ asmlinkage long sys32_rt_sigreturn(void)
 	struct pt_regs *regs = current_pt_regs();
 	struct rt_sigframe_ia32 __user *frame;
 	sigset_t set;
+	void __user *user_cookie;
 
 	frame = (struct rt_sigframe_ia32 __user *)(regs->sp - 4);
 
@@ -153,9 +174,17 @@ asmlinkage long sys32_rt_sigreturn(void)
 
 	set_current_blocked(&set);
 
-	if (ia32_restore_sigcontext(regs, &frame->uc.uc_mcontext))
+	if (ia32_restore_sigcontext(regs, &frame->uc.uc_mcontext, &user_cookie))
 		goto badframe;
 
+	if (user_cookie == NULL)
+		user_cookie = compat_ptr(((unsigned long) frame) +
+					 sizeof(*frame));
+
+	if (verify_clear_sigcookie(user_cookie))
+ 		goto badframe;
+
+
 	if (compat_restore_altstack(&frame->uc.uc_stack))
 		goto badframe;
 
@@ -213,7 +242,8 @@ static int ia32_setup_sigcontext(struct sigcontext_32 __user *sc,
  */
 static void __user *get_sigframe(struct ksignal *ksig, struct pt_regs *regs,
 				 size_t frame_size,
-				 void __user **fpstate)
+				 void __user **fpstate,
+				 void __user **cookie_ptr)
 {
 	struct fpu *fpu = &current->thread.fpu;
 	unsigned long sp;
@@ -230,11 +260,20 @@ static void __user *get_sigframe(struct ksignal *ksig, struct pt_regs *regs,
 		 ksig->ka.sa.sa_restorer)
 		sp = (unsigned long) ksig->ka.sa.sa_restorer;
 
+	/*
+	 * Allocate space for cookie above FP/Frame. It will sit in
+	 * the padding of the saved FP state, or if there is no FP
+	 * state it will sit in the padding of the sig frame.
+	 */
+	sp -= sizeof(unsigned long);
+
 	if (fpu->fpstate_active) {
 		unsigned long fx_aligned, math_size;
 
 		sp = fpu__alloc_mathframe(sp, 1, &fx_aligned, &math_size);
 		*fpstate = (struct _fpstate_32 __user *) sp;
+		*cookie_ptr = (void __user *) sp + math_size;
+
 		if (copy_fpstate_to_sigframe(*fpstate, (void __user *)fx_aligned,
 				    math_size) < 0)
 			return (void __user *) -1L;
@@ -244,6 +283,10 @@ static void __user *get_sigframe(struct ksignal *ksig, struct pt_regs *regs,
 	/* Align the stack pointer according to the i386 ABI,
 	 * i.e. so that on function entry ((sp + 4) & 15) == 0. */
 	sp = ((sp + 4) & -16ul) - 4;
+
+	if (!fpu->fpstate_active)
+		*cookie_ptr = (void __user *) (sp + frame_size);
+
 	return (void __user *) sp;
 }
 
@@ -254,6 +297,7 @@ int ia32_setup_frame(int sig, struct ksignal *ksig,
 	void __user *restorer;
 	int err = 0;
 	void __user *fpstate = NULL;
+	void __user *cookie_location;
 
 	/* copy_to_user optimizes that into a single 8 byte store */
 	static const struct {
@@ -266,7 +310,8 @@ int ia32_setup_frame(int sig, struct ksignal *ksig,
 		0x80cd,		/* int $0x80 */
 	};
 
-	frame = get_sigframe(ksig, regs, sizeof(*frame), &fpstate);
+	frame = get_sigframe(ksig, regs, sizeof(*frame),
+			     &fpstate, &cookie_location);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
@@ -274,6 +319,9 @@ int ia32_setup_frame(int sig, struct ksignal *ksig,
 	if (__put_user(sig, &frame->sig))
 		return -EFAULT;
 
+	if (set_sigcookie(cookie_location))
+		return -EFAULT;
+
 	if (ia32_setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]))
 		return -EFAULT;
 
@@ -332,6 +380,7 @@ int ia32_setup_rt_frame(int sig, struct ksignal *ksig,
 	void __user *restorer;
 	int err = 0;
 	void __user *fpstate = NULL;
+	void __user *cookie_location;
 
 	/* __copy_to_user optimizes that into a single 8 byte store */
 	static const struct {
@@ -346,11 +395,15 @@ int ia32_setup_rt_frame(int sig, struct ksignal *ksig,
 		0,
 	};
 
-	frame = get_sigframe(ksig, regs, sizeof(*frame), &fpstate);
+	frame = get_sigframe(ksig, regs, sizeof(*frame),
+			     &fpstate, &cookie_location);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
 
+	if (set_sigcookie(cookie_location))
+		return -EFAULT;
+
 	put_user_try {
 		put_user_ex(sig, &frame->sig);
 		put_user_ex(ptr_to_compat(&frame->info), &frame->pinfo);
diff --git a/arch/x86/include/asm/fpu/signal.h b/arch/x86/include/asm/fpu/signal.h
index 0e970d0..0c279cd 100644
--- a/arch/x86/include/asm/fpu/signal.h
+++ b/arch/x86/include/asm/fpu/signal.h
@@ -28,6 +28,8 @@ unsigned long
 fpu__alloc_mathframe(unsigned long sp, int ia32_frame,
 		     unsigned long *buf_fx, unsigned long *size);
 
+unsigned long fpu__getsize(int ia32_frame);
+
 extern void fpu__init_prepare_fx_sw_frame(void);
 
 #endif /* _ASM_X86_FPU_SIGNAL_H */
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 31c6a60..50535d7 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -344,6 +344,16 @@ static inline int xstate_sigframe_size(void)
 	return use_xsave() ? xstate_size + FP_XSTATE_MAGIC2_SIZE : xstate_size;
 }
 
+unsigned long fpu__getsize(int ia32_frame)
+{
+	unsigned long frame_size = xstate_sigframe_size();
+
+	if (ia32_frame && use_fxsr())
+		frame_size += sizeof(struct fregs_state);
+
+	return frame_size;
+}
+
 /*
  * Restore FPU state from a sigframe:
  */
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 548ddf7..87aa6f3 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -23,6 +23,7 @@
 #include <linux/user-return-notifier.h>
 #include <linux/uprobes.h>
 #include <linux/context_tracking.h>
+#include <linux/hash.h>
 
 #include <asm/processor.h>
 #include <asm/ucontext.h>
@@ -92,7 +93,8 @@ static void force_valid_ss(struct pt_regs *regs)
 
 static int restore_sigcontext(struct pt_regs *regs,
 			      struct sigcontext __user *sc,
-			      unsigned long uc_flags)
+			      unsigned long uc_flags,
+			      void **user_cookie_ptr)
 {
 	unsigned long buf_val;
 	void __user *buf;
@@ -146,6 +148,12 @@ static int restore_sigcontext(struct pt_regs *regs,
 		buf = (void __user *)buf_val;
 	} get_user_catch(err);
 
+	if (buf_val != 0)
+		*user_cookie_ptr = (void __user *)
+			(buf_val + fpu__getsize(config_enabled(CONFIG_X86_32)));
+	else
+		*user_cookie_ptr = NULL;
+
 	err |= fpu__restore_sig(buf, config_enabled(CONFIG_X86_32));
 
 	force_iret();
@@ -235,7 +243,7 @@ static unsigned long align_sigframe(unsigned long sp)
 
 static void __user *
 get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
-	     void __user **fpstate)
+	     void __user **fpstate, void __user **cookie_ptr)
 {
 	/* Default to using normal stack */
 	unsigned long math_size = 0;
@@ -262,14 +270,25 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 		}
 	}
 
+	/*
+	 * Allocate space for cookie above FP/Frame. It will sit in
+	 * the padding of the saved FP state, or if there is no FP
+	 * state it will sit in the padding of the sig frame.
+	 */
+	sp -= sizeof(unsigned long);
+
 	if (fpu->fpstate_active) {
 		sp = fpu__alloc_mathframe(sp, config_enabled(CONFIG_X86_32),
 					  &buf_fx, &math_size);
 		*fpstate = (void __user *)sp;
+		*cookie_ptr = (void __user *)sp + math_size;
 	}
 
 	sp = align_sigframe(sp - frame_size);
 
+	if (!fpu->fpstate_active)
+		*cookie_ptr = (void __user *) (sp + frame_size);
+
 	/*
 	 * If we are on the alternate signal stack and would overflow it, don't.
 	 * Return an always-bogus address instead so we will die with SIGSEGV.
@@ -316,8 +335,10 @@ __setup_frame(int sig, struct ksignal *ksig, sigset_t *set,
 	void __user *restorer;
 	int err = 0;
 	void __user *fpstate = NULL;
+	void __user *cookie_location;
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame), &fpstate);
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame),
+			     &fpstate, &cookie_location);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
@@ -325,6 +346,9 @@ __setup_frame(int sig, struct ksignal *ksig, sigset_t *set,
 	if (__put_user(sig, &frame->sig))
 		return -EFAULT;
 
+	if (set_sigcookie(cookie_location))
+		return -EFAULT;
+
 	if (setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]))
 		return -EFAULT;
 
@@ -379,12 +403,17 @@ static int __setup_rt_frame(int sig, struct ksignal *ksig,
 	void __user *restorer;
 	int err = 0;
 	void __user *fpstate = NULL;
+	void __user *cookie_location;
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame), &fpstate);
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame),
+			     &fpstate, &cookie_location);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
 
+	if (set_sigcookie(cookie_location))
+		return -EFAULT;
+
 	put_user_try {
 		put_user_ex(sig, &frame->sig);
 		put_user_ex(&frame->info, &frame->pinfo);
@@ -458,9 +487,11 @@ static int __setup_rt_frame(int sig, struct ksignal *ksig,
 {
 	struct rt_sigframe __user *frame;
 	void __user *fp = NULL;
+	void __user *cookie_location;
 	int err = 0;
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(struct rt_sigframe), &fp);
+	frame = get_sigframe(&ksig->ka, regs, sizeof(struct rt_sigframe),
+			     &fp, &cookie_location);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
@@ -470,6 +501,9 @@ static int __setup_rt_frame(int sig, struct ksignal *ksig,
 			return -EFAULT;
 	}
 
+	if (set_sigcookie(cookie_location))
+		return -EFAULT;
+
 	put_user_try {
 		/* Create the ucontext.  */
 		put_user_ex(frame_uc_flags(regs), &frame->uc.uc_flags);
@@ -541,8 +575,10 @@ static int x32_setup_rt_frame(struct ksignal *ksig,
 	void __user *restorer;
 	int err = 0;
 	void __user *fpstate = NULL;
+	void __user *cookie_location;
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame), &fpstate);
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame),
+			     &fpstate, &cookie_location);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
@@ -552,6 +588,9 @@ static int x32_setup_rt_frame(struct ksignal *ksig,
 			return -EFAULT;
 	}
 
+	if (set_sigcookie(cookie_location))
+		return -EFAULT;
+
 	put_user_try {
 		/* Create the ucontext.  */
 		put_user_ex(frame_uc_flags(regs), &frame->uc.uc_flags);
@@ -603,6 +642,7 @@ asmlinkage unsigned long sys_sigreturn(void)
 {
 	struct pt_regs *regs = current_pt_regs();
 	struct sigframe __user *frame;
+	void __user *user_cookie;
 	sigset_t set;
 
 	frame = (struct sigframe __user *)(regs->sp - 8);
@@ -620,8 +660,16 @@ asmlinkage unsigned long sys_sigreturn(void)
 	 * x86_32 has no uc_flags bits relevant to restore_sigcontext.
 	 * Save a few cycles by skipping the __get_user.
 	 */
-	if (restore_sigcontext(regs, &frame->sc, 0))
+	if (restore_sigcontext(regs, &frame->sc, 0, &user_cookie))
+		goto badframe;
+
+	if (user_cookie == NULL)
+		user_cookie = (void __user *)
+			((unsigned long) frame) + sizeof(*frame);
+
+	if (verify_clear_sigcookie(user_cookie))
 		goto badframe;
+
 	return regs->ax;
 
 badframe:
@@ -635,6 +683,7 @@ asmlinkage long sys_rt_sigreturn(void)
 {
 	struct pt_regs *regs = current_pt_regs();
 	struct rt_sigframe __user *frame;
+	void __user *user_cookie;
 	sigset_t set;
 	unsigned long uc_flags;
 
@@ -648,7 +697,14 @@ asmlinkage long sys_rt_sigreturn(void)
 
 	set_current_blocked(&set);
 
-	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, uc_flags))
+	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, uc_flags, &user_cookie))
+		goto badframe;
+
+	if (user_cookie == NULL)
+		user_cookie = (void __user *)
+			((unsigned long) frame) + sizeof(*frame);
+
+	if (verify_clear_sigcookie(user_cookie))
 		goto badframe;
 
 	if (restore_altstack(&frame->uc.uc_stack))
@@ -834,6 +890,7 @@ asmlinkage long sys32_x32_rt_sigreturn(void)
 {
 	struct pt_regs *regs = current_pt_regs();
 	struct rt_sigframe_x32 __user *frame;
+	void __user *user_cookie;
 	sigset_t set;
 	unsigned long uc_flags;
 
@@ -848,7 +905,15 @@ asmlinkage long sys32_x32_rt_sigreturn(void)
 
 	set_current_blocked(&set);
 
-	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, uc_flags))
+	if (restore_sigcontext(regs, &frame->uc.uc_mcontext,
+			       uc_flags, &user_cookie))
+		goto badframe;
+
+	if (user_cookie == NULL)
+		user_cookie = (void __user *)
+			((unsigned long) frame) + sizeof(*frame);
+
+	if (verify_clear_sigcookie(user_cookie))
 		goto badframe;
 
 	if (compat_restore_altstack(&frame->uc.uc_stack))
-- 
1.9.1
