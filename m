Reply-To: kernel-hardening@lists.openwall.com
From: Scott Bauer <sbauer@eng.utah.edu>
Date: Tue,  8 Mar 2016 13:47:54 -0700
Message-Id: <1457470075-4586-2-git-send-email-sbauer@eng.utah.edu>
In-Reply-To: <1457470075-4586-1-git-send-email-sbauer@eng.utah.edu>
References: <1457470075-4586-1-git-send-email-sbauer@eng.utah.edu>
Subject: [kernel-hardening] [PATCH v3 2/3] x86: SROP mitigation: implement signal cookies
To: sbauer@eng.utah.edu, linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, x86@kernel.org, wmealing@redhat.com, ak@linux.intel.com, luto@amacapital.net, Abhiram Balasubramanian <abhiram@cs.utah.edu>
List-ID: <kernel-hardening.lists.openwall.com>

This patch adds SROP mitigation logic to the x86 signal delivery
and sigreturn code. The cookie is placed in the unused alignment
space above the saved FP state, if it exists. If there is no FP
state to save then the cookie is placed in the alignment space above
the sigframe.

Cc: Abhiram Balasubramanian <abhiram@cs.utah.edu>
Signed-off-by: Scott Bauer <sbauer@eng.utah.edu>
---
 arch/x86/ia32/ia32_signal.c        | 63 +++++++++++++++++++++++++---
 arch/x86/include/asm/fpu/signal.h  |  1 +
 arch/x86/include/asm/sighandling.h |  5 ++-
 arch/x86/kernel/fpu/signal.c       | 10 +++++
 arch/x86/kernel/signal.c           | 86 +++++++++++++++++++++++++++++++++-----
 5 files changed, 146 insertions(+), 19 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 0552884..77ee2dd 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -68,7 +68,8 @@
 }
 
 static int ia32_restore_sigcontext(struct pt_regs *regs,
-				   struct sigcontext_32 __user *sc)
+				   struct sigcontext_32 __user *sc,
+				   void __user **user_cookie)
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
+		*user_cookie = compat_ptr(tmp + fpu__getsize(1));
+	else
+		*user_cookie = NULL;
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
@@ -129,8 +141,15 @@ asmlinkage long sys32_sigreturn(void)
 
 	set_current_blocked(&set);
 
-	if (ia32_restore_sigcontext(regs, &frame->sc))
+	if (ia32_restore_sigcontext(regs, &frame->sc, &user_cookie))
+		goto badframe;
+
+	if (user_cookie == NULL)
+		user_cookie = compat_ptr(((unsigned long) frame) + sizeof(*frame));
+
+	if (verify_clear_sigcookie(user_cookie))
 		goto badframe;
+
 	return regs->ax;
 
 badframe:
@@ -142,6 +161,7 @@ asmlinkage long sys32_rt_sigreturn(void)
 {
 	struct pt_regs *regs = current_pt_regs();
 	struct rt_sigframe_ia32 __user *frame;
+	void __user *user_cookie;
 	sigset_t set;
 
 	frame = (struct rt_sigframe_ia32 __user *)(regs->sp - 4);
@@ -153,7 +173,13 @@ asmlinkage long sys32_rt_sigreturn(void)
 
 	set_current_blocked(&set);
 
-	if (ia32_restore_sigcontext(regs, &frame->uc.uc_mcontext))
+	if (ia32_restore_sigcontext(regs, &frame->uc.uc_mcontext, &user_cookie))
+		goto badframe;
+
+	if (user_cookie == NULL)
+		user_cookie = (void __user *)(((unsigned long) frame) + sizeof(*frame));
+
+	if (verify_clear_sigcookie(user_cookie))
 		goto badframe;
 
 	if (compat_restore_altstack(&frame->uc.uc_stack))
@@ -213,7 +239,8 @@ static int ia32_setup_sigcontext(struct sigcontext_32 __user *sc,
  */
 static void __user *get_sigframe(struct ksignal *ksig, struct pt_regs *regs,
 				 size_t frame_size,
-				 void __user **fpstate)
+				 void __user **fpstate,
+				 void __user **cookie)
 {
 	struct fpu *fpu = &current->thread.fpu;
 	unsigned long sp;
@@ -230,11 +257,21 @@ static void __user *get_sigframe(struct ksignal *ksig, struct pt_regs *regs,
 		 ksig->ka.sa.sa_restorer)
 		sp = (unsigned long) ksig->ka.sa.sa_restorer;
 
+	/*
+	 * Allocate space for cookie above FP/Frame. It will sit in
+	 * the padding of the saved FP state, or if there is no FP
+	 * state it will sit in the padding of the sig frame.
+	 */
+	sp -= sizeof(unsigned long);
+
+
 	if (fpu->fpstate_active) {
 		unsigned long fx_aligned, math_size;
 
 		sp = fpu__alloc_mathframe(sp, 1, &fx_aligned, &math_size);
 		*fpstate = (struct _fpstate_32 __user *) sp;
+		*cookie = (void __user *)sp + math_size;
+
 		if (copy_fpstate_to_sigframe(*fpstate, (void __user *)fx_aligned,
 				    math_size) < 0)
 			return (void __user *) -1L;
@@ -244,6 +281,10 @@ static void __user *get_sigframe(struct ksignal *ksig, struct pt_regs *regs,
 	/* Align the stack pointer according to the i386 ABI,
 	 * i.e. so that on function entry ((sp + 4) & 15) == 0. */
 	sp = ((sp + 4) & -16ul) - 4;
+
+	if (!fpu->fpstate_active)
+		*cookie = (void __user *) (sp + frame_size);
+
 	return (void __user *) sp;
 }
 
@@ -254,6 +295,7 @@ int ia32_setup_frame(int sig, struct ksignal *ksig,
 	void __user *restorer;
 	int err = 0;
 	void __user *fpstate = NULL;
+	void __user *cookie_location;
 
 	/* copy_to_user optimizes that into a single 8 byte store */
 	static const struct {
@@ -266,7 +308,8 @@ int ia32_setup_frame(int sig, struct ksignal *ksig,
 		0x80cd,		/* int $0x80 */
 	};
 
-	frame = get_sigframe(ksig, regs, sizeof(*frame), &fpstate);
+	frame = get_sigframe(ksig, regs, sizeof(*frame),
+			     &fpstate, &cookie_location);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
@@ -274,6 +317,9 @@ int ia32_setup_frame(int sig, struct ksignal *ksig,
 	if (__put_user(sig, &frame->sig))
 		return -EFAULT;
 
+	if (set_sigcookie(cookie_location))
+		return -EFAULT;
+
 	if (ia32_setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]))
 		return -EFAULT;
 
@@ -332,6 +378,7 @@ int ia32_setup_rt_frame(int sig, struct ksignal *ksig,
 	void __user *restorer;
 	int err = 0;
 	void __user *fpstate = NULL;
+	void __user *cookie_location;
 
 	/* __copy_to_user optimizes that into a single 8 byte store */
 	static const struct {
@@ -346,11 +393,15 @@ int ia32_setup_rt_frame(int sig, struct ksignal *ksig,
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
index 0e970d0..a720b95 100644
--- a/arch/x86/include/asm/fpu/signal.h
+++ b/arch/x86/include/asm/fpu/signal.h
@@ -27,6 +27,7 @@ extern void convert_to_fxsr(struct task_struct *tsk,
 unsigned long
 fpu__alloc_mathframe(unsigned long sp, int ia32_frame,
 		     unsigned long *buf_fx, unsigned long *size);
+unsigned long fpu__getsize(int ia32_frame);
 
 extern void fpu__init_prepare_fx_sw_frame(void);
 
diff --git a/arch/x86/include/asm/sighandling.h b/arch/x86/include/asm/sighandling.h
index 89db467..971c8b2 100644
--- a/arch/x86/include/asm/sighandling.h
+++ b/arch/x86/include/asm/sighandling.h
@@ -12,8 +12,9 @@
 			 X86_EFLAGS_ZF | X86_EFLAGS_AF | X86_EFLAGS_PF | \
 			 X86_EFLAGS_CF | X86_EFLAGS_RF)
 
-void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
-int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc);
+void signal_fault(struct pt_regs *regs, void __user *frame, const char *where);
+int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
+		       void __user **user_cookie);
 int setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 		     struct pt_regs *regs, unsigned long mask);
 
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
index cb6282c..b756def 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -23,6 +23,7 @@
 #include <linux/user-return-notifier.h>
 #include <linux/uprobes.h>
 #include <linux/context_tracking.h>
+#include <linux/hash.h>
 
 #include <asm/processor.h>
 #include <asm/ucontext.h>
@@ -61,7 +62,9 @@
 	regs->seg = GET_SEG(seg) | 3;			\
 } while (0)
 
-int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
+
+int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
+	               void __user **user_cookie)
 {
 	unsigned long buf_val;
 	void __user *buf;
@@ -112,8 +115,14 @@ int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
 		buf = (void __user *)buf_val;
 	} get_user_catch(err);
 
-	err |= fpu__restore_sig(buf, config_enabled(CONFIG_X86_32));
 
+	if (buf_val != 0)
+		*user_cookie = (void __user *)
+			(buf_val + fpu__getsize(config_enabled(CONFIG_X86_32)));
+	else
+		*user_cookie = NULL;
+
+	err |= fpu__restore_sig(buf, config_enabled(CONFIG_X86_32));
 	force_iret();
 
 	return err;
@@ -200,7 +209,7 @@ static unsigned long align_sigframe(unsigned long sp)
 
 static void __user *
 get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
-	     void __user **fpstate)
+	     void __user **fpstate, void __user **cookie)
 {
 	/* Default to using normal stack */
 	unsigned long math_size = 0;
@@ -227,14 +236,27 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 		}
 	}
 
+
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
+		*cookie = (void __user *)sp + math_size;
 	}
 
 	sp = align_sigframe(sp - frame_size);
 
+	if (!fpu->fpstate_active)
+		*cookie = (void __user *) (sp + frame_size);
+
+
 	/*
 	 * If we are on the alternate signal stack and would overflow it, don't.
 	 * Return an always-bogus address instead so we will die with SIGSEGV.
@@ -281,8 +303,10 @@ __setup_frame(int sig, struct ksignal *ksig, sigset_t *set,
 	void __user *restorer;
 	int err = 0;
 	void __user *fpstate = NULL;
+	void __user *cookie_location;
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame), &fpstate);
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame),
+			     &fpstate, &cookie_location);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
@@ -290,6 +314,9 @@ __setup_frame(int sig, struct ksignal *ksig, sigset_t *set,
 	if (__put_user(sig, &frame->sig))
 		return -EFAULT;
 
+	if (set_sigcookie(cookie_location))
+		return -EFAULT;
+
 	if (setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]))
 		return -EFAULT;
 
@@ -344,12 +371,17 @@ static int __setup_rt_frame(int sig, struct ksignal *ksig,
 	void __user *restorer;
 	int err = 0;
 	void __user *fpstate = NULL;
+	void __user *cookie_location;
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame), &fpstate);
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame),
+			&fpstate, &cookie_location);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
 
+	if (set_sigcookie(cookie_location))
+		return -EFAULT;
+
 	put_user_try {
 		put_user_ex(sig, &frame->sig);
 		put_user_ex(&frame->info, &frame->pinfo);
@@ -408,9 +440,11 @@ static int __setup_rt_frame(int sig, struct ksignal *ksig,
 {
 	struct rt_sigframe __user *frame;
 	void __user *fp = NULL;
+	void __user *cookie_location;
 	int err = 0;
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(struct rt_sigframe), &fp);
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame),
+			     &fp, &cookie_location);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
@@ -420,6 +454,9 @@ static int __setup_rt_frame(int sig, struct ksignal *ksig,
 			return -EFAULT;
 	}
 
+	if (set_sigcookie(cookie_location))
+		return -EFAULT;
+
 	put_user_try {
 		/* Create the ucontext.  */
 		if (cpu_has_xsave)
@@ -476,8 +513,10 @@ static int x32_setup_rt_frame(struct ksignal *ksig,
 	void __user *restorer;
 	int err = 0;
 	void __user *fpstate = NULL;
+	void __user *cookie_location;
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame), &fpstate);
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame),
+			     &fpstate, &cookie_location);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
@@ -487,6 +526,9 @@ static int x32_setup_rt_frame(struct ksignal *ksig,
 			return -EFAULT;
 	}
 
+	if (set_sigcookie(cookie_location))
+		return -EFAULT;
+
 	put_user_try {
 		/* Create the ucontext.  */
 		if (cpu_has_xsave)
@@ -541,6 +583,7 @@ asmlinkage unsigned long sys_sigreturn(void)
 {
 	struct pt_regs *regs = current_pt_regs();
 	struct sigframe __user *frame;
+	void __user *user_cookie;
 	sigset_t set;
 
 	frame = (struct sigframe __user *)(regs->sp - 8);
@@ -554,8 +597,15 @@ asmlinkage unsigned long sys_sigreturn(void)
 
 	set_current_blocked(&set);
 
-	if (restore_sigcontext(regs, &frame->sc))
+	if (restore_sigcontext(regs, &frame->sc, &user_cookie))
+		goto badframe;
+
+	if (user_cookie == NULL)
+		user_cookie = (void __user *) (((unsigned long) frame) + sizeof(*frame));
+
+	if (verify_clear_sigcookie(user_cookie))
 		goto badframe;
+
 	return regs->ax;
 
 badframe:
@@ -569,6 +619,7 @@ asmlinkage long sys_rt_sigreturn(void)
 {
 	struct pt_regs *regs = current_pt_regs();
 	struct rt_sigframe __user *frame;
+	void __user *user_cookie;
 	sigset_t set;
 
 	frame = (struct rt_sigframe __user *)(regs->sp - sizeof(long));
@@ -579,7 +630,13 @@ asmlinkage long sys_rt_sigreturn(void)
 
 	set_current_blocked(&set);
 
-	if (restore_sigcontext(regs, &frame->uc.uc_mcontext))
+	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &user_cookie))
+		goto badframe;
+
+	if (user_cookie == NULL)
+		user_cookie = (void __user *) (((unsigned long) frame) + sizeof(*frame));
+
+	if (verify_clear_sigcookie(user_cookie))
 		goto badframe;
 
 	if (restore_altstack(&frame->uc.uc_stack))
@@ -740,7 +797,7 @@ void do_signal(struct pt_regs *regs)
 	restore_saved_sigmask();
 }
 
-void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
+void signal_fault(struct pt_regs *regs, void __user *frame, const char *where)
 {
 	struct task_struct *me = current;
 
@@ -762,6 +819,7 @@ asmlinkage long sys32_x32_rt_sigreturn(void)
 {
 	struct pt_regs *regs = current_pt_regs();
 	struct rt_sigframe_x32 __user *frame;
+	void __user *user_cookie;
 	sigset_t set;
 
 	frame = (struct rt_sigframe_x32 __user *)(regs->sp - 8);
@@ -773,7 +831,13 @@ asmlinkage long sys32_x32_rt_sigreturn(void)
 
 	set_current_blocked(&set);
 
-	if (restore_sigcontext(regs, &frame->uc.uc_mcontext))
+	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &user_cookie))
+		goto badframe;
+
+	if (user_cookie == NULL)
+		user_cookie = (void __user *) (((unsigned long) frame) + sizeof(*frame));
+
+	if (verify_clear_sigcookie(user_cookie))
 		goto badframe;
 
 	if (compat_restore_altstack(&frame->uc.uc_stack))
-- 
1.9.1
