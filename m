Reply-To: kernel-hardening@lists.openwall.com
From: Will Drewry <wad@chromium.org>
Date: Thu, 24 May 2012 11:08:01 -0500
Message-Id: <1337875681-20717-4-git-send-email-wad@chromium.org>
In-Reply-To: <1337875681-20717-1-git-send-email-wad@chromium.org>
References: <20120522173942.GJ11775@ZenIV.linux.org.uk>
 <1337875681-20717-1-git-send-email-wad@chromium.org>
Subject: [kernel-hardening] [RFC PATCH 3/3] arch/*: move secure_computing after trace
To: linux-kernel@vger.kernel.org
Cc: mcgrathr@google.com, hpa@zytor.com, indan@nul.nu, netdev@parisplace.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de, luto@mit.edu, serge.hallyn@canonical.com, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org, viro@zeniv.linux.org.uk, jmorris@namei.org, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

At present, any ptracer can bypass the seccomp system call
policy by changing the system call after secure_computing has
been called.  This change ensures that secure_computing
occurs after all other userspace applications may have changed the
system call value.

(Note, ARM was the most affected in this patch as the call was moved
 into the syscall_trace path and reordering after ptrace was
 non-trivial.)

This change is wildly untested.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 arch/arm/kernel/entry-common.S  |    7 +------
 arch/arm/kernel/ptrace.c        |   42 +++++++++++++++++++--------------------
 arch/microblaze/kernel/ptrace.c |    4 ++--
 arch/mips/kernel/ptrace.c       |   16 ++++++---------
 arch/powerpc/kernel/ptrace.c    |    5 +++--
 arch/s390/kernel/ptrace.c       |    6 +++---
 arch/sh/kernel/ptrace_32.c      |    5 +++--
 arch/sh/kernel/ptrace_64.c      |    5 +++--
 arch/sparc/kernel/ptrace_64.c   |    7 ++++---
 9 files changed, 46 insertions(+), 51 deletions(-)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 7bd2d3c..57a5bde 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -416,12 +416,7 @@ ENTRY(vector_swi)
 
 #ifdef CONFIG_SECCOMP
 	tst	r10, #_TIF_SECCOMP
-	beq	1f
-	mov	r0, scno
-	bl	__secure_computing	
-	add	r0, sp, #S_R0 + S_OFF		@ pointer to regs
-	ldmia	r0, {r0 - r3}			@ have to reload r0 - r3
-1:
+	bne	__sys_trace			@ are we in seccomp mode?
 #endif
 
 	tst	r10, #_TIF_SYSCALL_WORK		@ are we tracing syscalls?
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 14e3826..1654071 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -909,32 +909,32 @@ long arch_ptrace(struct task_struct *child, long request,
 
 asmlinkage int syscall_trace(int why, struct pt_regs *regs, int scno)
 {
-	unsigned long ip;
-
-	if (why)
-		audit_syscall_exit(regs);
-	else
-		audit_syscall_entry(AUDIT_ARCH_ARM, scno, regs->ARM_r0,
-				    regs->ARM_r1, regs->ARM_r2, regs->ARM_r3);
-
-	if (!test_thread_flag(TIF_SYSCALL_TRACE))
-		return scno;
-
-	current_thread_info()->syscall = scno;
-
 	/*
 	 * IP is used to denote syscall entry/exit:
 	 * IP = 0 -> entry, =1 -> exit
 	 */
-	ip = regs->ARM_ip;
-	regs->ARM_ip = why;
+	unsigned long ip = regs->ARM_ip;
 
-	if (why)
-		tracehook_report_syscall_exit(regs, 0);
-	else if (tracehook_report_syscall_entry(regs))
-		current_thread_info()->syscall = -1;
-
-	regs->ARM_ip = ip;
+	current_thread_info()->syscall = scno;
+	if (why) {	/* exit */
+		if (test_thread_flag(TIF_SYSCALL_TRACE)) {
+			regs->ARM_ip = why;
+			tracehook_report_syscall_exit(regs, 0);
+			regs->ARM_ip = ip;
+		}
+		audit_syscall_exit(regs);
+	} else {	/* entry */
+		if (test_thread_flag(TIF_SYSCALL_TRACE)) {
+			regs->ARM_ip = why;
+			if (tracehook_report_syscall_entry(regs))
+				current_thread_info()->syscall = -1;
+			regs->ARM_ip = ip;
+		}
+		/* Call secure_computing after any userspace changes are done */
+		secure_computing_strict(current_thread_info()->syscall);
+		audit_syscall_entry(AUDIT_ARCH_ARM, scno, regs->ARM_r0,
+				    regs->ARM_r1, regs->ARM_r2, regs->ARM_r3);
+	}
 
 	return current_thread_info()->syscall;
 }
diff --git a/arch/microblaze/kernel/ptrace.c b/arch/microblaze/kernel/ptrace.c
index ab1b9db..9a917a7 100644
--- a/arch/microblaze/kernel/ptrace.c
+++ b/arch/microblaze/kernel/ptrace.c
@@ -136,8 +136,6 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret = 0;
 
-	secure_computing_strict(regs->r12);
-
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
 	    tracehook_report_syscall_entry(regs))
 		/*
@@ -147,6 +145,8 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 		 */
 		ret = -1L;
 
+	secure_computing_strict(regs->r12);
+
 	audit_syscall_entry(EM_MICROBLAZE, regs->r12, regs->r5, regs->r6,
 			    regs->r7, regs->r8);
 
diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index 4812c6d..2b1f5f3 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -534,19 +534,16 @@ static inline int audit_arch(void)
  */
 asmlinkage void syscall_trace_enter(struct pt_regs *regs)
 {
-	/* do the secure computing check first */
-	secure_computing_strict(regs->regs[2]);
-
-	if (!(current->ptrace & PT_PTRACED))
-		goto out;
-
-	if (!test_thread_flag(TIF_SYSCALL_TRACE))
-		goto out;
-
+	if ((current->ptrace & PT_PTRACED) &&
+	    test_thread_flag(TIF_SYSCALL_TRACE)) {
 	/* The 0x80 provides a way for the tracing parent to distinguish
 	   between a syscall stop and SIGTRAP delivery */
 	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD) ?
 	                         0x80 : 0));
+	}
+
+	/* do the secure computing check after the system calls are final. */
+	secure_computing_strict(regs->regs[2]);
 
 	/*
 	 * this isn't the same as continuing with a signal, but it will do
@@ -558,7 +555,6 @@ asmlinkage void syscall_trace_enter(struct pt_regs *regs)
 		current->exit_code = 0;
 	}
 
-out:
 	audit_syscall_entry(audit_arch(), regs->regs[2],
 			    regs->regs[4], regs->regs[5],
 			    regs->regs[6], regs->regs[7]);
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index dd5e214..4b725ed 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -1710,8 +1710,6 @@ long do_syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret = 0;
 
-	secure_computing_strict(regs->gpr[0]);
-
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
 	    tracehook_report_syscall_entry(regs))
 		/*
@@ -1721,6 +1719,9 @@ long do_syscall_trace_enter(struct pt_regs *regs)
 		 */
 		ret = -1L;
 
+	if (!ret)
+		secure_computing_strict(regs->gpr[0]);
+
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_sys_enter(regs, regs->gpr[0]);
 
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 4993e68..b95c0ac 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -718,9 +718,6 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret = 0;
 
-	/* Do the secure computing check first. */
-	secure_computing_strict(regs->gprs[2]);
-
 	/*
 	 * The sysc_tracesys code in entry.S stored the system
 	 * call number to gprs[2].
@@ -737,6 +734,9 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 		ret = -1;
 	}
 
+	/* Do the secure computing check with a final syscall set. */
+	secure_computing_strict(regs->gprs[2]);
+
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_sys_enter(regs, regs->gprs[2]);
 
diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
index 81f999a..2500ce1 100644
--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -503,8 +503,6 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret = 0;
 
-	secure_computing_strict(regs->regs[0]);
-
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
 	    tracehook_report_syscall_entry(regs))
 		/*
@@ -514,6 +512,9 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 		 */
 		ret = -1L;
 
+	if (!ret)
+		secure_computing_strict(regs->regs[0]);
+
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_sys_enter(regs, regs->regs[0]);
 
diff --git a/arch/sh/kernel/ptrace_64.c b/arch/sh/kernel/ptrace_64.c
index af90339..cc030e0 100644
--- a/arch/sh/kernel/ptrace_64.c
+++ b/arch/sh/kernel/ptrace_64.c
@@ -522,8 +522,6 @@ asmlinkage long long do_syscall_trace_enter(struct pt_regs *regs)
 {
 	long long ret = 0;
 
-	secure_computing_strict(regs->regs[9]);
-
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
 	    tracehook_report_syscall_entry(regs))
 		/*
@@ -533,6 +531,9 @@ asmlinkage long long do_syscall_trace_enter(struct pt_regs *regs)
 		 */
 		ret = -1LL;
 
+	if (!ret)
+		secure_computing_strict(regs->regs[9]);
+
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_sys_enter(regs, regs->regs[9]);
 
diff --git a/arch/sparc/kernel/ptrace_64.c b/arch/sparc/kernel/ptrace_64.c
index 484daba..31fff51 100644
--- a/arch/sparc/kernel/ptrace_64.c
+++ b/arch/sparc/kernel/ptrace_64.c
@@ -1061,12 +1061,13 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs)
 {
 	int ret = 0;
 
-	/* do the secure computing check first */
-	secure_computing_strict(regs->u_regs[UREG_G1]);
-
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		ret = tracehook_report_syscall_entry(regs);
 
+	/* do the secure computing check with the final syscall */
+	if (!ret)
+		secure_computing_strict(regs->u_regs[UREG_G1]);
+
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_sys_enter(regs, regs->u_regs[UREG_G1]);
 
-- 
1.7.9.5
