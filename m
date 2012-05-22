Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 22 May 2012 23:20:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20120522222044.GL11775@ZenIV.linux.org.uk>
References: <CACLa4puRJLUd6hAHO6zFYiqa5dFVum8eLmNMk_ef+=r8OGhjRg@mail.gmail.com>
 <CAB=4xho2b5fZV_jC15XW3mhOD9Z0QUMnV_UHy-P5EmQWfX59dA@mail.gmail.com>
 <5d6179f59222155b72d9aa9f171e883c.squirrel@webmail.greenhost.nl>
 <CABqD9hbzatHerMA1Nq57Qn8SKSZzZf=5t6aLumG9ZpAafgX=UQ@mail.gmail.com>
 <20120522173942.GJ11775@ZenIV.linux.org.uk>
 <CABqD9hbwnp-Kob0-Uc9L=qgJfS88po=RHNPkhQFcSf4RTrFCmQ@mail.gmail.com>
 <4FBBF84A.4070308@zytor.com>
 <CABqD9haSh=Tof9n2m8PHBaoqac1kcUZq-f5BcjDBv++5APGTCg@mail.gmail.com>
 <20120522210704.GK11775@ZenIV.linux.org.uk>
 <CAB=4xhrEhX9BX2bsn1P=dFhmXTafVuEXDKJb87a6ftDkJqJs7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=4xhrEhX9BX2bsn1P=dFhmXTafVuEXDKJb87a6ftDkJqJs7A@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: [kernel-hardening] Re: seccomp and ptrace. what is the correct order?
To: Roland McGrath <mcgrathr@google.com>
Cc: Will Drewry <wad@chromium.org>, "H. Peter Anvin" <hpa@zytor.com>, Indan Zupancic <indan@nul.nu>, Eric Paris <netdev@parisplace.org>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 22, 2012 at 02:17:03PM -0700, Roland McGrath wrote:
> I always felt the same way about the audit code.  (As a bonus, if the audit
> folks ever decide they want all six syscall arguments instead of just four,
> they wouldn't have to touch every arch.)  But it will certainly produce
> drastically worse code for ia64.  (Not that anybody cares about ia64.)

FWIW, here's more or less what I had in mind; it's completely untested,
definitely breaks build on mips (no asm/syscall.h there) and I'm very
sceptical about ia32 compat syscall glue on x86 (I remember that there
had been some very evil games played with what's in which register at
which point, but I can't recall the details and I would rather leave that
to somebody whose eyes are not bleeding from staring at asm glue for more
than a month, TYVM...

diff --git a/arch/arm/include/asm/syscall.h b/arch/arm/include/asm/syscall.h
index c334a23..c31d82e 100644
--- a/arch/arm/include/asm/syscall.h
+++ b/arch/arm/include/asm/syscall.h
@@ -8,6 +8,8 @@
 #define _ASM_ARM_SYSCALL_H
 
 #include <linux/err.h>
+#include <asm/elf.h>
+#include <linux/audit.h>
 
 extern const unsigned long sys_call_table[];
 
@@ -90,4 +92,10 @@ static inline void syscall_set_arguments(struct task_struct *task,
 	memcpy(&regs->ARM_r0 + i, args, n * sizeof(args[0]));
 }
 
+static inline int syscall_get_arch(struct task_struct *task,
+				   struct pt_regs *regs)
+{
+	return AUDIT_ARCH_ARM;
+}
+
 #endif /* _ASM_ARM_SYSCALL_H */
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 14e3826..2e39596 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -911,17 +911,16 @@ asmlinkage int syscall_trace(int why, struct pt_regs *regs, int scno)
 {
 	unsigned long ip;
 
+	current_thread_info()->syscall = scno;
+
 	if (why)
 		audit_syscall_exit(regs);
 	else
-		audit_syscall_entry(AUDIT_ARCH_ARM, scno, regs->ARM_r0,
-				    regs->ARM_r1, regs->ARM_r2, regs->ARM_r3);
+		audit_syscall_entry(regs);
 
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
 		return scno;
 
-	current_thread_info()->syscall = scno;
-
 	/*
 	 * IP is used to denote syscall entry/exit:
 	 * IP = 0 -> entry, =1 -> exit
diff --git a/arch/ia64/include/asm/syscall.h b/arch/ia64/include/asm/syscall.h
index a7ff1c6..12f36fb 100644
--- a/arch/ia64/include/asm/syscall.h
+++ b/arch/ia64/include/asm/syscall.h
@@ -14,6 +14,7 @@
 #define _ASM_SYSCALL_H	1
 
 #include <linux/sched.h>
+#include <linux/audit.h>
 #include <linux/err.h>
 
 static inline long syscall_get_nr(struct task_struct *task,
@@ -79,4 +80,10 @@ static inline void syscall_set_arguments(struct task_struct *task,
 
 	ia64_syscall_get_set_arguments(task, regs, i, n, args, 1);
 }
+
+static inline int syscall_get_arch(struct task_struct *task,
+				   struct pt_regs *regs)
+{
+	return AUDIT_ARCH_IA64;
+}
 #endif	/* _ASM_SYSCALL_H */
diff --git a/arch/ia64/kernel/ptrace.c b/arch/ia64/kernel/ptrace.c
index 4265ff6..319d001 100644
--- a/arch/ia64/kernel/ptrace.c
+++ b/arch/ia64/kernel/ptrace.c
@@ -1246,7 +1246,7 @@ syscall_trace_enter (long arg0, long arg1, long arg2, long arg3,
 		ia64_sync_krbs();
 
 
-	audit_syscall_entry(AUDIT_ARCH_IA64, regs.r15, arg0, arg1, arg2, arg3);
+	audit_syscall_entry(&regs);
 
 	return 0;
 }
diff --git a/arch/microblaze/include/asm/syscall.h b/arch/microblaze/include/asm/syscall.h
index 9bc4317..d8d963b 100644
--- a/arch/microblaze/include/asm/syscall.h
+++ b/arch/microblaze/include/asm/syscall.h
@@ -3,6 +3,7 @@
 
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/audit.h>
 #include <asm/ptrace.h>
 
 /* The system call number is given by the user in R12 */
@@ -96,6 +97,12 @@ static inline void syscall_set_arguments(struct task_struct *task,
 		microblaze_set_syscall_arg(regs, i++, *args++);
 }
 
+static inline int syscall_get_arch(struct task_struct *task,
+				   struct pt_regs *regs)
+{
+	return EM_MICROBLAZE;
+}
+
 asmlinkage long do_syscall_trace_enter(struct pt_regs *regs);
 asmlinkage void do_syscall_trace_leave(struct pt_regs *regs);
 
diff --git a/arch/microblaze/kernel/ptrace.c b/arch/microblaze/kernel/ptrace.c
index ab1b9db..4953058 100644
--- a/arch/microblaze/kernel/ptrace.c
+++ b/arch/microblaze/kernel/ptrace.c
@@ -147,8 +147,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 		 */
 		ret = -1L;
 
-	audit_syscall_entry(EM_MICROBLAZE, regs->r12, regs->r5, regs->r6,
-			    regs->r7, regs->r8);
+	audit_syscall_entry(regs);
 
 	return ret ?: regs->r12;
 }
diff --git a/arch/powerpc/include/asm/syscall.h b/arch/powerpc/include/asm/syscall.h
index b54b2ad..3a6d01f 100644
--- a/arch/powerpc/include/asm/syscall.h
+++ b/arch/powerpc/include/asm/syscall.h
@@ -14,6 +14,7 @@
 #define _ASM_SYSCALL_H	1
 
 #include <linux/sched.h>
+#include <linux/audit.h>
 
 /* ftrace syscalls requires exporting the sys_call_table */
 #ifdef CONFIG_FTRACE_SYSCALLS
@@ -86,4 +87,12 @@ static inline void syscall_set_arguments(struct task_struct *task,
 	memcpy(&regs->gpr[3 + i], args, n * sizeof(args[0]));
 }
 
+static inline int syscall_get_arch(struct task_struct *task,
+				   struct pt_regs *regs)
+{
+	return test_tsk_thread_flag(task, TIF_32BIT) ? 
+					AUDIT_ARCH_PPC :
+					AUDIT_ARCH_PPC64;
+}
+
 #endif	/* _ASM_SYSCALL_H */
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index dd5e214..3f959f4 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -1724,20 +1724,7 @@ long do_syscall_trace_enter(struct pt_regs *regs)
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_sys_enter(regs, regs->gpr[0]);
 
-#ifdef CONFIG_PPC64
-	if (!is_32bit_task())
-		audit_syscall_entry(AUDIT_ARCH_PPC64,
-				    regs->gpr[0],
-				    regs->gpr[3], regs->gpr[4],
-				    regs->gpr[5], regs->gpr[6]);
-	else
-#endif
-		audit_syscall_entry(AUDIT_ARCH_PPC,
-				    regs->gpr[0],
-				    regs->gpr[3] & 0xffffffff,
-				    regs->gpr[4] & 0xffffffff,
-				    regs->gpr[5] & 0xffffffff,
-				    regs->gpr[6] & 0xffffffff);
+	audit_syscall_entry(regs);
 
 	return ret ?: regs->gpr[0];
 }
diff --git a/arch/s390/include/asm/syscall.h b/arch/s390/include/asm/syscall.h
index fb214dd..b481b11 100644
--- a/arch/s390/include/asm/syscall.h
+++ b/arch/s390/include/asm/syscall.h
@@ -14,6 +14,7 @@
 
 #include <linux/sched.h>
 #include <linux/err.h>
+#include <linux/audit.h>
 #include <asm/ptrace.h>
 
 /*
@@ -87,4 +88,12 @@ static inline void syscall_set_arguments(struct task_struct *task,
 		regs->orig_gpr2 = args[0];
 }
 
+static inline int syscall_get_arch(struct task_struct *task,
+				   struct pt_regs *regs)
+{
+	return test_tsk_thread_flag(task, TIF_31BIT) ? 
+					AUDIT_ARCH_S390 :
+					AUDIT_ARCH_S390X;
+}
+
 #endif	/* _ASM_SYSCALL_H */
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 4993e68..4222adb 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -740,11 +740,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_sys_enter(regs, regs->gprs[2]);
 
-	audit_syscall_entry(is_compat_task() ?
-				AUDIT_ARCH_S390 : AUDIT_ARCH_S390X,
-			    regs->gprs[2], regs->orig_gpr2,
-			    regs->gprs[3], regs->gprs[4],
-			    regs->gprs[5]);
+	audit_syscall_entry(regs);
 	return ret ?: regs->gprs[2];
 }
 
diff --git a/arch/sh/include/asm/syscall_32.h b/arch/sh/include/asm/syscall_32.h
index 7d80df4..db1eb5d 100644
--- a/arch/sh/include/asm/syscall_32.h
+++ b/arch/sh/include/asm/syscall_32.h
@@ -4,6 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/err.h>
+#include <linux/audit.h>
 #include <asm/ptrace.h>
 
 /* The system call number is given by the user in R3 */
@@ -93,4 +94,16 @@ static inline void syscall_set_arguments(struct task_struct *task,
 	}
 }
 
+static inline int syscall_get_arch(struct task_struct *task,
+				   struct pt_regs *regs)
+{
+	int arch = EM_SH;
+
+#ifdef CONFIG_CPU_LITTLE_ENDIAN
+	arch |= __AUDIT_ARCH_LE;
+#endif
+
+	return arch;
+}
+
 #endif /* __ASM_SH_SYSCALL_32_H */
diff --git a/arch/sh/include/asm/syscall_64.h b/arch/sh/include/asm/syscall_64.h
index c3561ca..f3a5913 100644
--- a/arch/sh/include/asm/syscall_64.h
+++ b/arch/sh/include/asm/syscall_64.h
@@ -3,6 +3,7 @@
 
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/audit.h>
 #include <asm/ptrace.h>
 
 /* The system call number is given by the user in R9 */
@@ -61,4 +62,19 @@ static inline void syscall_set_arguments(struct task_struct *task,
 	memcpy(&regs->regs[2 + i], args, n * sizeof(args[0]));
 }
 
+static inline int syscall_get_arch(struct task_struct *task,
+				   struct pt_regs *regs)
+{
+	int arch = EM_SH;
+
+#ifdef CONFIG_64BIT
+	arch |= __AUDIT_ARCH_64BIT;
+#endif
+#ifdef CONFIG_CPU_LITTLE_ENDIAN
+	arch |= __AUDIT_ARCH_LE;
+#endif
+
+	return arch;
+}
+
 #endif /* __ASM_SH_SYSCALL_64_H */
diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
index 81f999a..0173bfd 100644
--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -488,17 +488,6 @@ long arch_ptrace(struct task_struct *child, long request,
 	return ret;
 }
 
-static inline int audit_arch(void)
-{
-	int arch = EM_SH;
-
-#ifdef CONFIG_CPU_LITTLE_ENDIAN
-	arch |= __AUDIT_ARCH_LE;
-#endif
-
-	return arch;
-}
-
 asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret = 0;
@@ -517,9 +506,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_sys_enter(regs, regs->regs[0]);
 
-	audit_syscall_entry(audit_arch(), regs->regs[3],
-			    regs->regs[4], regs->regs[5],
-			    regs->regs[6], regs->regs[7]);
+	audit_syscall_entry(regs);
 
 	return ret ?: regs->regs[0];
 }
diff --git a/arch/sh/kernel/ptrace_64.c b/arch/sh/kernel/ptrace_64.c
index af90339..5e21c79 100644
--- a/arch/sh/kernel/ptrace_64.c
+++ b/arch/sh/kernel/ptrace_64.c
@@ -504,20 +504,6 @@ asmlinkage int sh64_ptrace(long request, long pid,
 	return sys_ptrace(request, pid, addr, data);
 }
 
-static inline int audit_arch(void)
-{
-	int arch = EM_SH;
-
-#ifdef CONFIG_64BIT
-	arch |= __AUDIT_ARCH_64BIT;
-#endif
-#ifdef CONFIG_CPU_LITTLE_ENDIAN
-	arch |= __AUDIT_ARCH_LE;
-#endif
-
-	return arch;
-}
-
 asmlinkage long long do_syscall_trace_enter(struct pt_regs *regs)
 {
 	long long ret = 0;
@@ -536,10 +522,7 @@ asmlinkage long long do_syscall_trace_enter(struct pt_regs *regs)
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_sys_enter(regs, regs->regs[9]);
 
-	audit_syscall_entry(audit_arch(), regs->regs[1],
-			    regs->regs[2], regs->regs[3],
-			    regs->regs[4], regs->regs[5]);
-
+	audit_syscall_entry(regs);
 	return ret ?: regs->regs[9];
 }
 
diff --git a/arch/sparc/include/asm/syscall.h b/arch/sparc/include/asm/syscall.h
index 025a02a..dc94ae8 100644
--- a/arch/sparc/include/asm/syscall.h
+++ b/arch/sparc/include/asm/syscall.h
@@ -3,6 +3,7 @@
 
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/audit.h>
 #include <asm/ptrace.h>
 
 /*
@@ -124,4 +125,12 @@ static inline void syscall_set_arguments(struct task_struct *task,
 		regs->u_regs[UREG_I0 + i + j] = args[j];
 }
 
+static inline int syscall_get_arch(struct task_struct *task,
+				   struct pt_regs *regs)
+{
+	return test_tsk_thread_flag(TIF_32BIT) ?
+			     AUDIT_ARCH_SPARC :
+			     AUDIT_ARCH_SPARC64;
+}
+
 #endif /* __ASM_SPARC_SYSCALL_H */
diff --git a/arch/sparc/kernel/ptrace_64.c b/arch/sparc/kernel/ptrace_64.c
index 484daba..7deee07 100644
--- a/arch/sparc/kernel/ptrace_64.c
+++ b/arch/sparc/kernel/ptrace_64.c
@@ -1070,15 +1070,7 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs)
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_sys_enter(regs, regs->u_regs[UREG_G1]);
 
-	audit_syscall_entry((test_thread_flag(TIF_32BIT) ?
-			     AUDIT_ARCH_SPARC :
-			     AUDIT_ARCH_SPARC64),
-			    regs->u_regs[UREG_G1],
-			    regs->u_regs[UREG_I0],
-			    regs->u_regs[UREG_I1],
-			    regs->u_regs[UREG_I2],
-			    regs->u_regs[UREG_I3]);
-
+	audit_syscall_entry(regs);
 	return ret;
 }
 
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index e3e7340..aa5d1ff 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -184,17 +184,11 @@ sysexit_from_sys_call:
 
 #ifdef CONFIG_AUDITSYSCALL
 	.macro auditsys_entry_common
-	movl %esi,%r9d			/* 6th arg: 4th syscall arg */
-	movl %edx,%r8d			/* 5th arg: 3rd syscall arg */
-	/* (already in %ecx)		   4th arg: 2nd syscall arg */
-	movl %ebx,%edx			/* 3rd arg: 1st syscall arg */
-	movl %eax,%esi			/* 2nd arg: syscall number */
-	movl $AUDIT_ARCH_I386,%edi	/* 1st arg: audit arch */
+	movq %rsp,%rdi
 	call __audit_syscall_entry
 	movl RAX-ARGOFFSET(%rsp),%eax	/* reload syscall number */
 	cmpq $(IA32_NR_syscalls-1),%rax
 	ja ia32_badsys
-	movl %ebx,%edi			/* reload 1st syscall arg */
 	movl RCX-ARGOFFSET(%rsp),%esi	/* reload 2nd syscall arg */
 	movl RDX-ARGOFFSET(%rsp),%edx	/* reload 3rd syscall arg */
 	movl RSI-ARGOFFSET(%rsp),%ecx	/* reload 4th syscall arg */
diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index 1ace47b..7d69c71 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -13,8 +13,8 @@
 #ifndef _ASM_X86_SYSCALL_H
 #define _ASM_X86_SYSCALL_H
 
-#include <linux/audit.h>
 #include <linux/sched.h>
+#include <linux/audit.h>
 #include <linux/err.h>
 #include <asm/asm-offsets.h>	/* For NR_syscalls */
 #include <asm/thread_info.h>	/* for TS_COMPAT */
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 7b784f4..42169b9 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -449,16 +449,8 @@ sysenter_exit:
 sysenter_audit:
 	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%ebp)
 	jnz syscall_trace_entry
-	addl $4,%esp
-	CFI_ADJUST_CFA_OFFSET -4
-	/* %esi already in 8(%esp)	   6th arg: 4th syscall arg */
-	/* %edx already in 4(%esp)	   5th arg: 3rd syscall arg */
-	/* %ecx already in 0(%esp)	   4th arg: 2nd syscall arg */
-	movl %ebx,%ecx			/* 3rd arg: 1st syscall arg */
-	movl %eax,%edx			/* 2nd arg: syscall number */
-	movl $AUDIT_ARCH_I386,%eax	/* 1st arg: audit arch */
+	movl %esp, %eax
 	call __audit_syscall_entry
-	pushl_cfi %ebx
 	movl PT_EAX(%esp),%eax		/* reload syscall number */
 	jmp sysenter_do_call
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index cdc79b5..38fc889 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -557,12 +557,7 @@ badsys:
 	 * jump back to the normal fast path.
 	 */
 auditsys:
-	movq %r10,%r9			/* 6th arg: 4th syscall arg */
-	movq %rdx,%r8			/* 5th arg: 3rd syscall arg */
-	movq %rsi,%rcx			/* 4th arg: 2nd syscall arg */
-	movq %rdi,%rdx			/* 3rd arg: 1st syscall arg */
-	movq %rax,%rsi			/* 2nd arg: syscall number */
-	movl $AUDIT_ARCH_X86_64,%edi	/* 1st arg: audit arch */
+	movq %rsp,%rdi
 	call __audit_syscall_entry
 	LOAD_ARGS 0		/* reload call-clobbered registers */
 	jmp system_call_fastpath
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 13b1990..916abfd 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1496,19 +1496,7 @@ long syscall_trace_enter(struct pt_regs *regs)
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_sys_enter(regs, regs->orig_ax);
 
-	if (IS_IA32)
-		audit_syscall_entry(AUDIT_ARCH_I386,
-				    regs->orig_ax,
-				    regs->bx, regs->cx,
-				    regs->dx, regs->si);
-#ifdef CONFIG_X86_64
-	else
-		audit_syscall_entry(AUDIT_ARCH_X86_64,
-				    regs->orig_ax,
-				    regs->di, regs->si,
-				    regs->dx, regs->r10);
-#endif
-
+	audit_syscall_entry(regs);
 out:
 	return ret ?: regs->orig_ax;
 }
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 22f292a..3d1f963 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -454,9 +454,7 @@ extern int audit_classify_arch(int arch);
 				/* Public API */
 extern int  audit_alloc(struct task_struct *task);
 extern void __audit_free(struct task_struct *task);
-extern void __audit_syscall_entry(int arch,
-				  int major, unsigned long a0, unsigned long a1,
-				  unsigned long a2, unsigned long a3);
+extern void __audit_syscall_entry(struct pt_regs *regs);
 extern void __audit_syscall_exit(int ret_success, long ret_value);
 extern void __audit_getname(const char *name);
 extern void audit_putname(const char *name);
@@ -476,14 +474,12 @@ static inline void audit_free(struct task_struct *task)
 	if (unlikely(task->audit_context))
 		__audit_free(task);
 }
-static inline void audit_syscall_entry(int arch, int major, unsigned long a0,
-				       unsigned long a1, unsigned long a2,
-				       unsigned long a3)
+static inline void audit_syscall_entry(struct pt_regs *regs)
 {
 	if (unlikely(!audit_dummy_context()))
-		__audit_syscall_entry(arch, major, a0, a1, a2, a3);
+		__audit_syscall_entry(regs);
 }
-static inline void audit_syscall_exit(void *pt_regs)
+static inline void audit_syscall_exit(struct pt_regs *pt_regs)
 {
 	if (unlikely(current->audit_context)) {
 		int success = is_syscall_success(pt_regs);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 4b96415..9075c27 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -68,6 +68,7 @@
 #include <linux/capability.h>
 #include <linux/fs_struct.h>
 #include <linux/compat.h>
+#include <asm/syscall.h>
 
 #include "audit.h"
 
@@ -1787,13 +1788,12 @@ void __audit_free(struct task_struct *tsk)
  * will only be written if another part of the kernel requests that it
  * be written).
  */
-void __audit_syscall_entry(int arch, int major,
-			 unsigned long a1, unsigned long a2,
-			 unsigned long a3, unsigned long a4)
+void __audit_syscall_entry(struct pt_regs *regs)
 {
 	struct task_struct *tsk = current;
 	struct audit_context *context = tsk->audit_context;
 	enum audit_state     state;
+	int major;
 
 	if (!context)
 		return;
@@ -1812,6 +1812,7 @@ void __audit_syscall_entry(int arch, int major,
 	 * This also happens with vm86 emulation in a non-nested manner
 	 * (entries without exits), so this case must be caught.
 	 */
+	major = syscall_get_nr(tsk, regs);
 	if (context->in_syscall) {
 		struct audit_context *newctx;
 
@@ -1839,12 +1840,9 @@ void __audit_syscall_entry(int arch, int major,
 	if (!audit_enabled)
 		return;
 
-	context->arch	    = arch;
+	context->arch	    = syscall_get_arch(tsk, regs);
 	context->major      = major;
-	context->argv[0]    = a1;
-	context->argv[1]    = a2;
-	context->argv[2]    = a3;
-	context->argv[3]    = a4;
+	syscall_get_arguments(tsk, regs, 0, 4, context->argv);
 
 	state = context->state;
 	context->dummy = !audit_n_rules;
