Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 15 Aug 2011 19:38:36 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110815153836.GA6060@albatros>
References: <20110812120747.GA14598@albatros>
 <20110812122343.GA7859@openwall.com>
 <20110813151220.GA8388@albatros>
 <20110813151947.GA12495@openwall.com>
 <20110813165502.GA9328@albatros>
 <20110814095010.GA14443@openwall.com>
 <20110814101658.GA20509@albatros>
 <20110814112922.GA15012@openwall.com>
 <20110814115549.GA3423@albatros>
 <20110814120448.GA15372@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20110814120448.GA15372@openwall.com>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

Given the latest discussion on LKML we're unlikely to push the
restriction upstream.  So, I'm posting the patch here.

I've implemented immediate locking, lock on 32 exec, lock on 64 bit
exec.  A test program can be downloaded from this link:

ftp://ftp.ru.openwall.com/pvt/segoon/pub/bitness-lock-test/

The demonstration:

    + ./lock32
    My bitness is: 32
    Try to do 32 bit syscall...
    getpid() =3D 2355
    Try to do 64 bit syscall...
    getpid() =3D 2355
    + ./lock64
    My bitness is: 64
    Try to do 32 bit syscall...
    getpid() =3D 2356
    Try to do 64 bit syscall...
    getpid() =3D 2356
    + ./lock32 -l
    My bitness is: 32
    lock32: prctl(PR_BITNESS_LOCK): Permission denied
    + sudo ./lock32 -l
    My bitness is: 32
    Locked.
    Try to do 32 bit syscall...
    getpid() =3D 2358
    Try to do 64 bit syscall...
    ./test.sh: =D1=81=D1=82=D1=80=D0=BE=D0=BA=D0=B0 6:  2358 =D0=A3=D0=B1=
=D0=B8=D1=82=D0=BE              sudo ./lock32 -l
    + sudo ./lock64 -l
    My bitness is: 64
    Locked.
    Try to do 32 bit syscall...
    ./test.sh: =D1=81=D1=82=D1=80=D0=BE=D0=BA=D0=B0 7:  2359 =D0=A3=D0=B1=
=D0=B8=D1=82=D0=BE              sudo ./lock64 -l
    + sudo ./lock32 -e32 ./lock32
    My bitness is: 32
    Lock to 32 bits on exec.
    Try to do execvp()...
    My bitness is: 32
    Try to do 32 bit syscall...
    getpid() =3D 2360
    Try to do 64 bit syscall...
    ./test.sh: =D1=81=D1=82=D1=80=D0=BE=D0=BA=D0=B0 9:  2360 =D0=A3=D0=B1=
=D0=B8=D1=82=D0=BE              sudo ./lock32 -e32 ./lock32
    + sudo ./lock32 -e32 ./lock64
    My bitness is: 32
    Lock to 32 bits on exec.
    Try to do execvp()...
    ./lock64: 1: : not found
    ./lock64: 1: @: not found
    ./lock64: 1: : not found
    ./lock64: 1:ELF=02=02: not found
    ./lock64: 2: Syntax error: "(" unexpected
    + sudo ./lock32 -e64 ./lock32
    My bitness is: 32
    Lock to 64 bits on exec.
    Try to do execvp()...
    ./lock32: 1: Syntax error: "(" unexpected
    + sudo ./lock32 -e64 ./lock64
    My bitness is: 32
    Lock to 64 bits on exec.
    Try to do execvp()...
    My bitness is: 64
    Try to do 32 bit syscall...
    ./test.sh: =D1=81=D1=82=D1=80=D0=BE=D0=BA=D0=B0 12:  2370 =D0=A3=D0=B1=
=D0=B8=D1=82=D0=BE              sudo ./lock32 -e64 ./lock64
    + sudo ./lock64 -e32 ./lock32
    My bitness is: 64
    Lock to 32 bits on exec.
    Try to do execvp()...
    My bitness is: 32
    Try to do 32 bit syscall...
    getpid() =3D 2371
    Try to do 64 bit syscall...
    ./test.sh: =D1=81=D1=82=D1=80=D0=BE=D0=BA=D0=B0 14:  2371 =D0=A3=D0=B1=
=D0=B8=D1=82=D0=BE              sudo ./lock64 -e32 ./lock32
    + sudo ./lock64 -e32 ./lock64
    My bitness is: 64
    Lock to 32 bits on exec.
    Try to do execvp()...
    ./lock64: 1: : not found
    ./lock64: 1: @: not found
    ./lock64: 1: : not found
    ./lock64: 1:ELF=02=02: not found
    ./lock64: 2: Syntax error: "(" unexpected
    + sudo ./lock64 -e64 ./lock32
    My bitness is: 64
    Lock to 64 bits on exec.
    Try to do execvp()...
    ./lock32: 1: Syntax error: "(" unexpected
    + sudo ./lock64 -e64 ./lock64
    My bitness is: 64
    Lock to 64 bits on exec.
    Try to do execvp()...
    My bitness is: 64
    Try to do 32 bit syscall...
    ./test.sh: =D1=81=D1=82=D1=80=D0=BE=D0=BA=D0=B0 17:  2381 =D0=A3=D0=B1=
=D0=B8=D1=82=D0=BE              sudo ./lock64 -e64 ./lock64
    + sudo ./lock32 -e ./lock32
    My bitness is: 32
    Locked.
    Try to do execvp()...
    My bitness is: 32
    Try to do 32 bit syscall...
    getpid() =3D 2382
    Try to do 64 bit syscall...
    ./test.sh: =D1=81=D1=82=D1=80=D0=BE=D0=BA=D0=B0 19:  2382 =D0=A3=D0=B1=
=D0=B8=D1=82=D0=BE              sudo ./lock32 -e ./lock32
    + sudo ./lock32 -e ./lock64
    My bitness is: 32
    Locked.
    Try to do execvp()...
    lock32: execvp: Exec format error
    Second attempt ...
    lock32: execvp: Exec format error
    + sudo ./lock64 -e ./lock32
    My bitness is: 64
    Locked.
    Try to do execvp()...
    ./lock32: 1: Syntax error: "(" unexpected
    + sudo ./lock64 -e ./lock64
    My bitness is: 64
    Locked.
    Try to do execvp()...
    My bitness is: 64
    Try to do 32 bit syscall...
    ./test.sh: =D1=81=D1=82=D1=80=D0=BE=D0=BA=D0=B0 22:  2395 =D0=A3=D0=B1=
=D0=B8=D1=82=D0=BE              sudo ./lock64 -e ./lock64

Note the strage output of -e32 lock64, -e64 lock32, lock64 -e lock32.
There is a major problem with lock on exec (ptrace output):

    execve("./lock32", ["./lock32", "-e64", "./lock32"], [/* 17 vars */]) =
=3D 0
    ...
    prctl(0x23 /* PR_??? */, 0x1, 0x40, 0, 0) =3D 0
    execve("./lock32", ["./lock32"], [/* 28 vars */]) =3D -1 ENOEXEC (Exec =
format error)
    execve("/bin/sh", ["/bin/sh", "./lock32"], [/* 28 vars */]) =3D 0
    brk(0)                                  =3D 0x2447000
    ...

So, library function tries to run /bin/sh if no kernel interpreter is
found.  As the first execve(2) failed, the lock on exec is not forced
anymore, but from the application point of view it is the only execve().
For -e lock32 the expectation is not broken, but 32bit ELF is still tried to
be passed to 64bit /bin/sh.

My point is still that we should keep the only flag - lock current
process and implement simple re-exec of vzctl.  But other ways like
workaround of multiple execve() calls are welcome.

--
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index a0e866d..c7960f3 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -152,7 +152,7 @@ ENTRY(ia32_sysenter_target)
  	.previous=09
 	GET_THREAD_INFO(%r10)
 	orl    $TS_COMPAT,TI_status(%r10)
-	testl  $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
+	testl  $_TIF_WORK_SYSCALL_ENTRY_32,TI_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz  sysenter_tracesys
 	cmpq	$(IA32_NR_syscalls-1),%rax
@@ -238,7 +238,7 @@ sysexit_audit:
=20
 sysenter_tracesys:
 #ifdef CONFIG_AUDITSYSCALL
-	testl	$(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
+	testl	$(_TIF_WORK_SYSCALL_ENTRY_32 & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
 	jz	sysenter_auditsys
 #endif
 	SAVE_REST
@@ -311,7 +311,7 @@ ENTRY(ia32_cstar_target)
 	.previous=09
 	GET_THREAD_INFO(%r10)
 	orl   $TS_COMPAT,TI_status(%r10)
-	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
+	testl $_TIF_WORK_SYSCALL_ENTRY_32,TI_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz   cstar_tracesys
 	cmpq $IA32_NR_syscalls-1,%rax
@@ -355,7 +355,7 @@ sysretl_audit:
=20
 cstar_tracesys:
 #ifdef CONFIG_AUDITSYSCALL
-	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
+	testl $(_TIF_WORK_SYSCALL_ENTRY_32 & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
 	jz cstar_auditsys
 #endif
 	xchgl %r9d,%ebp
@@ -422,7 +422,7 @@ ENTRY(ia32_syscall)
 	SAVE_ARGS 0,1,0
 	GET_THREAD_INFO(%r10)
 	orl   $TS_COMPAT,TI_status(%r10)
-	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
+	testl $_TIF_WORK_SYSCALL_ENTRY_32,TI_flags(%r10)
 	jnz ia32_tracesys
 	cmpq $(IA32_NR_syscalls-1),%rax
 	ja ia32_badsys
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index f2ad216..b292580 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -320,4 +320,10 @@ extern int syscall32_setup_pages(struct linux_binprm *=
, int exstack);
 extern unsigned long arch_randomize_brk(struct mm_struct *mm);
 #define arch_randomize_brk arch_randomize_brk
=20
+extern void arch_post_exec_elf(int retval, int elf_class);
+#define arch_post_exec_elf arch_post_exec_elf
+
+extern void arch_post_execve(void);
+#define arch_post_execve arch_post_execve
+
 #endif /* _ASM_X86_ELF_H */
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 94e7618..e95986e 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -281,6 +281,12 @@ extern int do_get_thread_area(struct task_struct *p, i=
nt idx,
 extern int do_set_thread_area(struct task_struct *p, int idx,
 			      struct user_desc __user *info, int can_allocate);
=20
+extern int syscall_bitness_check(void);
+
+extern long arch_prctl(int option, unsigned long arg2, unsigned long arg3,
+		unsigned long arg4, unsigned long arg5);
+#define arch_prctl arch_prctl
+
 #endif /* __KERNEL__ */
=20
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thre=
ad_info.h
index a1fe5c1..c4b5464 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -95,6 +95,8 @@ struct thread_info {
 #define TIF_BLOCKSTEP		25	/* set when we want DEBUGCTLMSR_BTF */
 #define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
 #define TIF_SYSCALL_TRACEPOINT	28	/* syscall tracepoint instrumentation */
+#define TIF_SYSCALL32_DENIED	29	/* 32 bit syscalls are denied */
+#define TIF_SYSCALL64_DENIED	30	/* 64 bit syscalls are denied */
=20
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -117,11 +119,20 @@ struct thread_info {
 #define _TIF_BLOCKSTEP		(1 << TIF_BLOCKSTEP)
 #define _TIF_LAZY_MMU_UPDATES	(1 << TIF_LAZY_MMU_UPDATES)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
+#define _TIF_SYSCALL32_DENIED	(1 << TIF_SYSCALL32_DENIED)
+#define _TIF_SYSCALL64_DENIED	(1 << TIF_SYSCALL64_DENIED)
=20
 /* work to do in syscall_trace_enter() */
-#define _TIF_WORK_SYSCALL_ENTRY	\
+#define _TIF_WORK_SYSCALL_ENTRY_64	\
 	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | _TIF_SYSCALL_AUDIT |	\
-	 _TIF_SECCOMP | _TIF_SINGLESTEP | _TIF_SYSCALL_TRACEPOINT)
+	 _TIF_SECCOMP | _TIF_SINGLESTEP | _TIF_SYSCALL_TRACEPOINT |	\
+	 _TIF_SYSCALL64_DENIED)
+
+/* work to do in syscall_trace_enter() */
+#define _TIF_WORK_SYSCALL_ENTRY_32	\
+	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | _TIF_SYSCALL_AUDIT |	\
+	 _TIF_SECCOMP | _TIF_SINGLESTEP | _TIF_SYSCALL_TRACEPOINT |	\
+	 _TIF_SYSCALL32_DENIED)
=20
 /* work to do in syscall_trace_leave() */
 #define _TIF_WORK_SYSCALL_EXIT	\
@@ -259,9 +270,22 @@ static inline void set_restore_sigmask(void)
 	ti->status |=3D TS_RESTORE_SIGMASK;
 	set_bit(TIF_SIGPENDING, (unsigned long *)&ti->flags);
 }
-#endif	/* !__ASSEMBLY__ */
=20
-#ifndef __ASSEMBLY__
+#ifdef CONFIG_IA32_EMULATION
+
+extern void arch_post_fork(struct task_struct *task);
+#define arch_post_fork arch_post_fork
+
+#define BITNESS_LOCK_32 1
+#define BITNESS_LOCK_64 2
+
+struct bitness_lock_on_exec {
+	int lock;
+};
+#define bitness_lock_on_exec bitness_lock_on_exec
+
+#endif /* CONFIG_IA32_EMULATION */
+
 extern void arch_task_cache_init(void);
 extern void free_thread_info(struct thread_info *ti);
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struc=
t *src);
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0410557..a200ff3 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -86,6 +86,7 @@ obj-$(CONFIG_DOUBLEFAULT) 	+=3D doublefault_32.o
 obj-$(CONFIG_KGDB)		+=3D kgdb.o
 obj-$(CONFIG_VM86)		+=3D vm86_32.o
 obj-$(CONFIG_EARLY_PRINTK)	+=3D early_printk.o
+obj-$(CONFIG_SYSCTL)		+=3D syscall_restrict.o
=20
 obj-$(CONFIG_HPET_TIMER) 	+=3D hpet.o
 obj-$(CONFIG_APB_TIMER)		+=3D apb_timer.o
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e13329d..77534b7 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -474,7 +474,7 @@ ENTRY(system_call_after_swapgs)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
 	GET_THREAD_INFO(%rcx)
-	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%rcx)
+	testl $_TIF_WORK_SYSCALL_ENTRY_64,TI_flags(%rcx)
 	jnz tracesys
 system_call_fastpath:
 	cmpq $__NR_syscall_max,%rax
@@ -578,7 +578,7 @@ sysret_audit:
 	/* Do syscall tracing */
 tracesys:
 #ifdef CONFIG_AUDITSYSCALL
-	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%rcx)
+	testl $(_TIF_WORK_SYSCALL_ENTRY_64 & ~_TIF_SYSCALL_AUDIT),TI_flags(%rcx)
 	jz auditsys
 #endif
 	SAVE_REST
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 8252879..39d0a85 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1378,7 +1378,16 @@ long syscall_trace_enter(struct pt_regs *regs)
 	if (test_thread_flag(TIF_SINGLESTEP))
 		regs->flags |=3D X86_EFLAGS_TF;
=20
-	/* do the secure computing check first */
+	/*
+	 * Do the syscall bitness check first.
+	 *
+	 * If the bitness is denied, exit immediatelly to reduce
+	 * the size of executed code.
+	 */
+	if (syscall_bitness_check())
+		return -1L;
+
+	/* Then check the syscall number. */
 	secure_computing(regs->orig_ax);
=20
 	if (unlikely(test_thread_flag(TIF_SYSCALL_EMU)))
diff --git a/arch/x86/kernel/syscall_restrict.c b/arch/x86/kernel/syscall_r=
estrict.c
new file mode 100644
index 0000000..6001b3a
--- /dev/null
+++ b/arch/x86/kernel/syscall_restrict.c
@@ -0,0 +1,200 @@
+#include <linux/thread_info.h>
+#include <linux/pid_namespace.h>
+#include <linux/sysctl.h>
+#include <linux/kprobes.h>
+#include <linux/ratelimit.h>
+#include <linux/printk.h>
+#include <linux/kdebug.h>
+#include <linux/elf.h>
+#include <linux/prctl.h>
+#include <linux/binfmts.h>
+#include <asm/kdebug.h>
+#include <asm/compat.h>
+
+#ifdef CONFIG_IA32_EMULATION
+
+int syscall_bitness_check(void)
+{
+	int flag;
+
+	if (is_compat_task())
+		flag =3D TIF_SYSCALL32_DENIED;
+	else
+		flag =3D TIF_SYSCALL64_DENIED;
+
+	if (test_thread_flag(flag)) {
+		pr_err_ratelimited("%s[%d]: attempt to do a syscall of denied "
+			"bitness\n", current->comm, task_pid_nr(current));
+		force_sig(SIGKILL, current);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int bits_to_flags(int bits)
+{
+	switch (bits) {
+	case 32:
+		return TIF_SYSCALL64_DENIED;
+	case 64:
+		return TIF_SYSCALL32_DENIED;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int __bitness_lock(int bits)
+{
+	int clear_bit_nr =3D bits_to_flags(bits);
+
+	if (clear_bit_nr < 0)
+		return clear_bit_nr;
+
+	set_tsk_thread_flag(current, clear_bit_nr);
+	return 0;
+}
+
+static int bitness_set_lock_on_exec(int bits, int val)
+{
+	int mask;
+
+	switch (bits) {
+	case 32:
+		mask =3D BITNESS_LOCK_32;
+		break;
+	case 64:
+		mask =3D BITNESS_LOCK_64;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	current->bitness_lock_on_exec.lock &=3D ~mask;
+	if (val)
+		current->bitness_lock_on_exec.lock |=3D mask;
+
+	return 0;
+}
+
+static bool elf_may_exec(void)
+{
+	if (test_thread_flag(TIF_SYSCALL64_DENIED))
+		return false;
+
+	/* Either we're don't want to be locked or
+	 * we're ok to lock to the ELF's bitness */
+	if (current->bitness_lock_on_exec.lock =3D=3D 0 ||
+	    current->bitness_lock_on_exec.lock & BITNESS_LOCK_64)
+		return true;
+
+	return false;
+}
+
+bool compat_elf_may_exec(void)
+{
+	if (test_thread_flag(TIF_SYSCALL32_DENIED))
+		return false;
+
+	/* Either we're don't want to be locked or
+	 * we're ok to lock to the ELF's bitness */
+	if (current->bitness_lock_on_exec.lock =3D=3D 0 ||
+	    current->bitness_lock_on_exec.lock & BITNESS_LOCK_32)
+		return true;
+
+	return false;
+}
+
+extern struct linux_binfmt elf_format, compat_elf_format, script_format;
+
+bool arch_check_interpreter(struct linux_binfmt *fmt)
+{
+	if (fmt =3D=3D &compat_elf_format)
+		return compat_elf_may_exec();
+
+	if (fmt =3D=3D &elf_format)
+		return elf_may_exec();
+
+	/* We're ok with loading script, which interpreter is legitimate ELF */
+	if (fmt =3D=3D &script_format)
+		return true;
+
+	if (current->bitness_lock_on_exec.lock =3D=3D 0)
+		return true;
+
+	return false;
+}
+
+/*
+ * We cannot do it in arch_post_exec_elf() as it can be called from
+ * binfmt_script's handler, which may fail. If the call sequence is
+ *
+ *  binfmt_script -> binfmt_elf =3D> FAIL
+ *  binfmt_elf =3D> OK
+ *
+ * We should be locked.  To keep code simple, we just clear ->.bitness.lock
+ * on each execve() regardless of return code.
+ */
+void arch_post_execve(void)
+{
+	current->bitness_lock_on_exec.lock =3D 0;
+}
+
+void arch_post_exec_elf(int retval, int elf_class)
+{
+	if (retval =3D=3D 0 && current->bitness_lock_on_exec.lock) {
+		int bits =3D (elf_class =3D=3D ELFCLASS32) ? 32 : 64;
+		__bitness_lock(bits);
+	}
+}
+
+#else /* CONFIG_IA32_EMULATION */
+
+bool arch_check_interpreter(struct linux_binfmt *fmt) { return true; }
+void arch_post_execve(void) {}
+void arch_post_exec_elf(int retval, int elf_class) {}
+
+static int bitness_set_lock_on_exec(int bits, int val)
+{
+	if (bits =3D=3D 64)
+		return 0;
+	else
+		return -EINVAL;
+}
+
+static int __bitness_lock(int bits)
+{
+	if (bits =3D=3D 64)
+		return 0;
+	else
+		return -EINVAL;
+}
+
+#endif /* CONFIG_IA32_EMULATION */
+
+int current_bitness(void)
+{
+#ifdef CONFIG_IA32_EMULATION
+	if (test_thread_flag(TIF_IA32))
+		return 32;
+	else
+#endif
+		return 64;
+}
+
+long arch_prctl(int option, unsigned long arg2, unsigned long arg3,
+		unsigned long arg4, unsigned long arg5)
+{
+	switch (option) {
+	case PR_BITNESS_LOCK_ON_EXEC:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		return bitness_set_lock_on_exec(arg3, !!arg2);
+	case PR_BITNESS_LOCK:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		return __bitness_lock(current_bitness());
+	default:
+		return -EINVAL;
+	}
+}
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index dd0fdfc..d25cd50 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -65,7 +65,7 @@ static int elf_core_dump(struct coredump_params *cprm);
 #define ELF_PAGEOFFSET(_v) ((_v) & (ELF_MIN_ALIGN-1))
 #define ELF_PAGEALIGN(_v) (((_v) + ELF_MIN_ALIGN - 1) & ~(ELF_MIN_ALIGN - =
1))
=20
-static struct linux_binfmt elf_format =3D {
+struct linux_binfmt elf_format =3D {
 	.module		=3D THIS_MODULE,
 	.load_binary	=3D load_elf_binary,
 	.load_shlib	=3D load_elf_library,
@@ -556,6 +556,12 @@ static unsigned long randomize_stack_top(unsigned long=
 stack_top)
 #endif
 }
=20
+#if 0
+#ifndef arch_post_exec_elf
+#define arch_post_exec_elf(rc, class)
+#endif
+#endif
+
 static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 {
 	struct file *interpreter =3D NULL; /* to shut gcc up */
@@ -979,6 +985,7 @@ static int load_elf_binary(struct linux_binprm *bprm, s=
truct pt_regs *regs)
 out:
 	kfree(loc);
 out_ret:
+	arch_post_exec_elf(retval, ELF_CLASS);
 	return retval;
=20
 	/* error cleanup */
diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index 396a988..be0e4c5 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -98,7 +98,7 @@ static int load_script(struct linux_binprm *bprm,struct p=
t_regs *regs)
 	return search_binary_handler(bprm,regs);
 }
=20
-static struct linux_binfmt script_format =3D {
+struct linux_binfmt script_format =3D {
 	.module		=3D THIS_MODULE,
 	.load_binary	=3D load_script,
 };
diff --git a/fs/exec.c b/fs/exec.c
index da80612..93f062b 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1360,6 +1360,8 @@ out:
 }
 EXPORT_SYMBOL(remove_arg_zero);
=20
+extern bool arch_check_interpreter(struct linux_binfmt *fmt);
+
 /*
  * cycle the list of binary formats handler, until one recognizes the image
  */
@@ -1390,6 +1392,8 @@ int search_binary_handler(struct linux_binprm *bprm,s=
truct pt_regs *regs)
 			int (*fn)(struct linux_binprm *, struct pt_regs *) =3D fmt->load_binary;
 			if (!fn)
 				continue;
+			if (!arch_check_interpreter(fmt))
+				continue;
 			if (!try_module_get(fmt->module))
 				continue;
 			read_unlock(&binfmt_lock);
@@ -1441,11 +1445,19 @@ int search_binary_handler(struct linux_binprm *bprm=
,struct pt_regs *regs)
 		break;
 #endif
 	}
+
+	pr_err("search_binary_handler(%u) =3D %d\n", (int)current->pid, (int)retv=
al);
 	return retval;
 }
=20
 EXPORT_SYMBOL(search_binary_handler);
=20
+#if 0
+#ifndef arch_post_execve
+#define arch_post_execve()
+#endif
+#endif
+
 /*
  * sys_execve() executes a new program.
  */
@@ -1527,6 +1539,7 @@ static int do_execve_common(const char *filename,
 	current->fs->in_exec =3D 0;
 	current->in_execve =3D 0;
 	acct_update_integrals(current);
+	arch_post_execve();
 	free_bprm(bprm);
 	if (displaced)
 		put_files_struct(displaced);
@@ -1556,6 +1569,7 @@ out_files:
 	if (displaced)
 		reset_files_struct(displaced);
 out_ret:
+	arch_post_execve();
 	return retval;
 }
=20
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index a3baeb2..91edb9c 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -102,4 +102,7 @@
=20
 #define PR_MCE_KILL_GET 34
=20
+#define PR_BITNESS_LOCK_ON_EXEC	35
+#define PR_BITNESS_LOCK		36
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 20b03bf..ee5ba82 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1046,6 +1046,10 @@ partition_sched_domains(int ndoms_new, cpumask_var_t=
 doms_new[],
 }
 #endif	/* !CONFIG_SMP */
=20
+#ifndef bitness_lock_on_exec
+struct bitness_lock_on_exec {};
+#define bitness_lock_on_exec bitness_lock_on_exec
+#endif /* bitness_lock_t */
=20
 struct io_context;			/* See blkdev.h */
=20
@@ -1405,6 +1409,7 @@ struct task_struct {
 	unsigned int sessionid;
 #endif
 	seccomp_t seccomp;
+	struct bitness_lock_on_exec bitness_lock_on_exec;
=20
 /* Thread group tracking */
    	u32 parent_exec_id;
diff --git a/kernel/sys.c b/kernel/sys.c
index a101ba3..e7faa8b 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1644,6 +1644,10 @@ SYSCALL_DEFINE1(umask, int, mask)
 	return mask;
 }
=20
+#ifndef arch_prctl
+#define arch_prctl(o, a2, a3, a4, a5) (-EINVAL)
+#endif
+
 SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, ar=
g3,
 		unsigned long, arg4, unsigned long, arg5)
 {
@@ -1793,7 +1797,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, ar=
g2, unsigned long, arg3,
 				error =3D PR_MCE_KILL_DEFAULT;
 			break;
 		default:
-			error =3D -EINVAL;
+			error =3D arch_prctl(option, arg2, arg3, arg4, arg5);
 			break;
 	}
 	return error;

--=20
Vasiliy
