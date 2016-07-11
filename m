Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 11 Jul 2016 13:53:57 -0700
Message-Id: <0beec068e1d2a4a510087332f4442d8c3c23b85e.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v5 24/32] x86/entry: Get rid of pt_regs_to_thread_info()
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Linus Torvalds <torvalds@linux-foundation.org>

It was a nice optimization while it lasted, but thread_info is moving
and this optimization will no longer work.

Quoting Linus:

    Oh Gods, Andy. That pt_regs_to_thread_info() thing made me want
    to do unspeakable acts on a poor innocent wax figure that looked
    _exactly_ like you.

[changelog written by Andy]
Message-Id: <CA+55aFxvZhBu9U1cqpVm4frv0p5mqu=0TxsSqE-=95ft8HvCVA@mail.gmail.com>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/entry/common.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index c4150bec7982..804487f126cb 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -31,13 +31,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/syscalls.h>
 
-static struct thread_info *pt_regs_to_thread_info(struct pt_regs *regs)
-{
-	unsigned long top_of_stack =
-		(unsigned long)(regs + 1) + TOP_OF_KERNEL_STACK_PADDING;
-	return (struct thread_info *)(top_of_stack - THREAD_SIZE);
-}
-
 #ifdef CONFIG_CONTEXT_TRACKING
 /* Called on entry from user mode with IRQs off. */
 __visible void enter_from_user_mode(void)
@@ -78,7 +71,7 @@ static void do_audit_syscall_entry(struct pt_regs *regs, u32 arch)
  */
 unsigned long syscall_trace_enter_phase1(struct pt_regs *regs, u32 arch)
 {
-	struct thread_info *ti = pt_regs_to_thread_info(regs);
+	struct thread_info *ti = current_thread_info();
 	unsigned long ret = 0;
 	u32 work;
 
@@ -156,7 +149,7 @@ unsigned long syscall_trace_enter_phase1(struct pt_regs *regs, u32 arch)
 long syscall_trace_enter_phase2(struct pt_regs *regs, u32 arch,
 				unsigned long phase1_result)
 {
-	struct thread_info *ti = pt_regs_to_thread_info(regs);
+	struct thread_info *ti = current_thread_info();
 	long ret = 0;
 	u32 work = ACCESS_ONCE(ti->flags) & _TIF_WORK_SYSCALL_ENTRY;
 
@@ -239,7 +232,7 @@ static void exit_to_usermode_loop(struct pt_regs *regs, u32 cached_flags)
 		/* Disable IRQs and retry */
 		local_irq_disable();
 
-		cached_flags = READ_ONCE(pt_regs_to_thread_info(regs)->flags);
+		cached_flags = READ_ONCE(current_thread_info()->flags);
 
 		if (!(cached_flags & EXIT_TO_USERMODE_LOOP_FLAGS))
 			break;
@@ -250,7 +243,7 @@ static void exit_to_usermode_loop(struct pt_regs *regs, u32 cached_flags)
 /* Called with IRQs disabled. */
 __visible inline void prepare_exit_to_usermode(struct pt_regs *regs)
 {
-	struct thread_info *ti = pt_regs_to_thread_info(regs);
+	struct thread_info *ti = current_thread_info();
 	u32 cached_flags;
 
 	if (IS_ENABLED(CONFIG_PROVE_LOCKING) && WARN_ON(!irqs_disabled()))
@@ -309,7 +302,7 @@ static void syscall_slow_exit_work(struct pt_regs *regs, u32 cached_flags)
  */
 __visible inline void syscall_return_slowpath(struct pt_regs *regs)
 {
-	struct thread_info *ti = pt_regs_to_thread_info(regs);
+	struct thread_info *ti = current_thread_info();
 	u32 cached_flags = READ_ONCE(ti->flags);
 
 	CT_WARN_ON(ct_state() != CONTEXT_KERNEL);
@@ -332,7 +325,7 @@ __visible inline void syscall_return_slowpath(struct pt_regs *regs)
 #ifdef CONFIG_X86_64
 __visible void do_syscall_64(struct pt_regs *regs)
 {
-	struct thread_info *ti = pt_regs_to_thread_info(regs);
+	struct thread_info *ti = current_thread_info();
 	unsigned long nr = regs->orig_ax;
 
 	enter_from_user_mode();
@@ -365,7 +358,7 @@ __visible void do_syscall_64(struct pt_regs *regs)
  */
 static __always_inline void do_syscall_32_irqs_on(struct pt_regs *regs)
 {
-	struct thread_info *ti = pt_regs_to_thread_info(regs);
+	struct thread_info *ti = current_thread_info();
 	unsigned int nr = (unsigned int)regs->orig_ax;
 
 #ifdef CONFIG_IA32_EMULATION
-- 
2.7.4
