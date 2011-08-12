Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 12 Aug 2011 19:03:04 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110812150304.GC16880@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [RFC] x86: restrict pid namespaces to 32 or 64 bit syscalls
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com, x86@kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This patch allows x86-64 systems with 32 bit syscalls support to lock a
pid namespace to 32 or 64 bitness syscalls/tasks.  By denying rarely
used compatibility syscalls it reduces an attack surface for 32 bit
containers.

The new sysctl is introduced, abi.bitness_locked.  If set to 1, it locks
all tasks inside of current pid namespace to the bitness of init task
(pid_ns->child_reaper).  After that:

1) a task trying to do a syscall of other bitness would get a signal as
if the corresponding syscall is not enabled (IDT entry/MSR is not
initialized).

2) loading ELF binaries of another bitness is prohibited (as if the
corresponding CONFIG_BINFMT_*=N).

If there is any task which differs in bitness, the lockup fails.


In this patch version the lockup is handled by sysctl.  In the future I
plan to do it via prctl() to handle situations of container root
compromize.  For now, the lockup can be configured by init scripts,
which parse /etc/sysctl.conf and set the sysctl variable.  But if
/sbin/init is compromized, the malicious code would gain a possibility
to do arbitrary syscalls.  So, it should be possible to lockup the
container before the init execution.

( The asm stubs for denied syscalls might be buggy, if so - please
ignore them :) it is just a PoC. )

Qestions/thoughts:

The patch adds a check in syscalls code.  Is it a significant
slowdown for fast syscalls?  If so, probably it worth moving the check
into scheduler code and enabling/disabling corresponding interrupt/MSRs
on each task switch?


Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 arch/x86/ia32/ia32entry.S          |   33 +++++
 arch/x86/include/asm/elf.h         |    5 +-
 arch/x86/include/asm/thread_info.h |   13 ++-
 arch/x86/kernel/Makefile           |    1 +
 arch/x86/kernel/entry_64.S         |   12 ++-
 arch/x86/kernel/syscall_restrict.c |  229 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/traps.c            |    2 +-
 kernel/fork.c                      |    5 +
 8 files changed, 293 insertions(+), 7 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index a0e866d..5bc1882 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -151,6 +151,8 @@ ENTRY(ia32_sysenter_target)
  	.quad 1b,ia32_badarg
  	.previous	
 	GET_THREAD_INFO(%r10)
+	testl  $_TIF_SYSCALL32_DENIED,TI_flags(%r10)
+	jnz ia32_denied_sysenter
 	orl    $TS_COMPAT,TI_status(%r10)
 	testl  $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	CFI_REMEMBER_STATE
@@ -310,6 +312,8 @@ ENTRY(ia32_cstar_target)
 	.quad 1b,ia32_badarg
 	.previous	
 	GET_THREAD_INFO(%r10)
+	testl  $_TIF_SYSCALL32_DENIED,TI_flags(%r10)
+	jnz ia32_denied_syscall
 	orl   $TS_COMPAT,TI_status(%r10)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	CFI_REMEMBER_STATE
@@ -421,6 +425,8 @@ ENTRY(ia32_syscall)
 	   this could be a problem. */
 	SAVE_ARGS 0,1,0
 	GET_THREAD_INFO(%r10)
+	testl  $_TIF_SYSCALL32_DENIED,TI_flags(%r10)
+	jnz ia32_denied_int
 	orl   $TS_COMPAT,TI_status(%r10)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	jnz ia32_tracesys
@@ -453,6 +459,33 @@ ia32_badsys:
 	movq $-ENOSYS,%rax
 	jmp ia32_sysret
 
+ia32_denied_sysenter:
+	SAVE_REST
+	CLEAR_RREGS
+	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
+	call	do_ia32_denied_sysenter
+	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	RESTORE_REST
+	jmp	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
+
+ia32_denied_syscall:
+	SAVE_REST
+	CLEAR_RREGS
+	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
+	movq $-ENOSYS,%rax
+	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	RESTORE_REST
+	jmp	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
+
+ia32_denied_int:
+	SAVE_REST
+	CLEAR_RREGS
+	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
+	call	do_ia32_denied_int
+	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	RESTORE_REST
+	jmp	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
+
 quiet_ni_syscall:
 	movq $-ENOSYS,%rax
 	ret
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index f2ad216..fb054c7 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -153,9 +153,10 @@ do {						\
  * This is used to ensure we don't load something for the wrong architecture.
  */
 #define elf_check_arch(x)			\
-	((x)->e_machine == EM_X86_64)
+	((x)->e_machine == EM_X86_64 && !test_thread_flag(TIF_SYSCALL64_DENIED))
 
-#define compat_elf_check_arch(x)	elf_check_arch_ia32(x)
+#define compat_elf_check_arch(x)		\
+	(elf_check_arch_ia32(x) && !test_thread_flag(TIF_SYSCALL32_DENIED))
 
 static inline void elf_common_init(struct thread_struct *t,
 				   struct pt_regs *regs, const u16 ds)
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index a1fe5c1..1e93040 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -95,6 +95,8 @@ struct thread_info {
 #define TIF_BLOCKSTEP		25	/* set when we want DEBUGCTLMSR_BTF */
 #define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
 #define TIF_SYSCALL_TRACEPOINT	28	/* syscall tracepoint instrumentation */
+#define TIF_SYSCALL32_DENIED	29	/* 32 bit syscalls are denied */
+#define TIF_SYSCALL64_DENIED	30	/* 64 bit syscalls are denied */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -117,6 +119,8 @@ struct thread_info {
 #define _TIF_BLOCKSTEP		(1 << TIF_BLOCKSTEP)
 #define _TIF_LAZY_MMU_UPDATES	(1 << TIF_LAZY_MMU_UPDATES)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
+#define _TIF_SYSCALL32_DENIED	(1 << TIF_SYSCALL32_DENIED)
+#define _TIF_SYSCALL64_DENIED	(1 << TIF_SYSCALL64_DENIED)
 
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
@@ -259,9 +263,14 @@ static inline void set_restore_sigmask(void)
 	ti->status |= TS_RESTORE_SIGMASK;
 	set_bit(TIF_SIGPENDING, (unsigned long *)&ti->flags);
 }
-#endif	/* !__ASSEMBLY__ */
 
-#ifndef __ASSEMBLY__
+#ifdef CONFIG_IA32_EMULATION
+#define __HAVE_ARCH_POST_FORK
+
+extern void arch_post_fork(struct task_struct *task);
+
+#endif /* CONFIG_IA32_EMULATION */
+
 extern void arch_task_cache_init(void);
 extern void free_thread_info(struct thread_info *ti);
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0410557..a200ff3 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -86,6 +86,7 @@ obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_VM86)		+= vm86_32.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
+obj-$(CONFIG_SYSCTL)		+= syscall_restrict.o
 
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_APB_TIMER)		+= apb_timer.o
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e13329d..b184a45 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -474,6 +474,8 @@ ENTRY(system_call_after_swapgs)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
 	GET_THREAD_INFO(%rcx)
+	testl $_TIF_SYSCALL64_DENIED,TI_flags(%rcx)
+	jnz denied_sys
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%rcx)
 	jnz tracesys
 system_call_fastpath:
@@ -539,8 +541,14 @@ sysret_signal:
 	jmp int_check_syscall_exit_work
 
 badsys:
-	movq $-ENOSYS,RAX-ARGOFFSET(%rsp)
-	jmp ret_from_sys_call
+	SAVE_REST
+	movq $-ENOSYS,RAX(%rsp) /* ptrace can change this for a bad syscall */
+	FIXUP_TOP_OF_STACK %rdi
+	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
+	call do_denied_syscall
+	LOAD_ARGS ARGOFFSET, 1
+	RESTORE_REST
+	jmp	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
 
 #ifdef CONFIG_AUDITSYSCALL
 	/*
diff --git a/arch/x86/kernel/syscall_restrict.c b/arch/x86/kernel/syscall_restrict.c
new file mode 100644
index 0000000..a676f22
--- /dev/null
+++ b/arch/x86/kernel/syscall_restrict.c
@@ -0,0 +1,229 @@
+#include <linux/thread_info.h>
+#include <linux/pid_namespace.h>
+#include <linux/sysctl.h>
+#include <linux/kprobes.h>
+#include <asm/kdebug.h>
+#include <linux/kdebug.h>
+
+#ifdef CONFIG_IA32_EMULATION
+
+void __kprobes
+do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
+	long error_code, siginfo_t *info);
+
+asmlinkage
+void do_ia32_denied_sysenter(struct pt_regs *regs)
+{
+	current->thread.error_code = 0;
+	current->thread.trap_no = 13;
+
+	if (printk_ratelimit()) {
+		pr_err("%s[%d] attempt to use denied 32-bit sysenter, ip:%lx sp:%lx",
+			current->comm, task_pid_nr(current),
+			regs->ip, regs->sp);
+		print_vma_addr(" in ", regs->ip);
+		printk("\n");
+	}
+
+	force_sig(SIGSEGV, current);
+	return;
+
+}
+
+asmlinkage
+void do_ia32_denied_int(struct pt_regs *regs)
+{
+	if (printk_ratelimit()) {
+		pr_err("%s[%d] attempt to use denied 32-bit int80h, ip :%lx sp:%lx",
+			current->comm, task_pid_nr(current),
+			regs->ip, regs->sp);
+		print_vma_addr(" in ", regs->ip);
+		printk("\n");
+	}
+
+	do_trap(11, SIGBUS, "segment not present", regs, 0, NULL);
+}
+
+asmlinkage
+void do_denied_syscall(struct pt_regs *regs)
+{
+	siginfo_t info = {
+		.si_signo = SIGILL,
+		.si_errno = 0,
+		.si_code = ILL_ILLOPN,
+		.si_addr = (void __user *)regs->ip
+	};
+
+	if (printk_ratelimit()) {
+		pr_err("%s[%d] attempt to use denied 64-bit syscall, ip:%lx sp:%lx",
+			current->comm, task_pid_nr(current),
+			regs->ip, regs->sp);
+		print_vma_addr(" in ", regs->ip);
+		printk("\n");
+	}
+
+
+	do_trap(6, SIGILL, "invalid opcode", regs, 0, &info);
+}
+
+static int task_get_bitness(struct task_struct *task)
+{
+	if (test_ti_thread_flag(task_thread_info(task), TIF_IA32))
+		return 32;
+	else
+		return 64;
+}
+
+static bool pidns_locked(struct pid_namespace *pid_ns)
+{
+	struct thread_info *ti = task_thread_info(pid_ns->child_reaper);
+
+	return test_ti_thread_flag(ti, TIF_SYSCALL32_DENIED) ||
+	       test_ti_thread_flag(ti, TIF_SYSCALL64_DENIED);
+}
+
+static int bits_to_flags(int bits)
+{
+	if (bits == 32)
+		return TIF_SYSCALL64_DENIED;
+	else
+		return TIF_SYSCALL32_DENIED;
+}
+
+void arch_post_fork(struct task_struct *task)
+{
+	int clear_bit_nr;
+
+	if (!pidns_locked(current->nsproxy->pid_ns))
+		return;
+
+	clear_bit_nr = bits_to_flags(task_get_bitness(current));
+	set_tsk_thread_flag(task, clear_bit_nr);
+}
+
+/* Called under rcu_read_lock and write_lock_irq(tasklist) */
+static int __pidns_may_lock_bitness(struct pid_namespace *pid_ns, int bits)
+{
+	struct task_struct *task;
+	int old_bits;
+	int nr;
+
+	for (nr = next_pidmap(pid_ns, 0); nr > 0; nr = next_pidmap(pid_ns, nr)) {
+		task = pid_task(find_vpid(nr), PIDTYPE_PID);
+		if (!task)
+			continue;
+
+		old_bits = task_get_bitness(task);
+		if (old_bits != bits) {
+			pr_err("Inconsistent syscall restriction detected! "
+				"Parent ns tries to restrict syscalls to %d "
+				"bits while some task is %d bit.",
+				bits, old_bits);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+/* Called under rcu_read_lock and write_lock_irq(tasklist) */
+static void __bitness_lock(struct pid_namespace *pid_ns, int bits)
+{
+	u32 clear_bit_nr;
+	struct task_struct *task;
+	int nr;
+
+	clear_bit_nr = bits_to_flags(bits);
+
+	for (nr = next_pidmap(pid_ns, 0); nr > 0; nr = next_pidmap(pid_ns, nr)) {
+		task = pid_task(find_vpid(nr), PIDTYPE_PID);
+		if (task)
+			set_tsk_thread_flag(task, clear_bit_nr);
+	}
+}
+
+static int bitness_lock(struct pid_namespace *pid_ns)
+{
+	int rc, new_bits;
+
+	rcu_read_lock();
+	write_lock_irq(&tasklist_lock);
+
+	new_bits = task_get_bitness(pid_ns->child_reaper);
+	rc = __pidns_may_lock_bitness(pid_ns, new_bits);
+	if (!rc)
+		__bitness_lock(pid_ns, new_bits);
+
+	write_unlock_irq(&tasklist_lock);
+	rcu_read_unlock();
+	return rc;
+}
+
+static int bitness_locked_handler(struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp,
+				loff_t *ppos)
+{
+	int rc, new_bits, old_bits;
+	struct ctl_table tbl = {
+		.procname	= table->procname,
+		.data		= &new_bits,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+	};
+
+	old_bits = new_bits = pidns_locked(current->nsproxy->pid_ns);
+	rc = proc_dointvec(&tbl, write, buffer, lenp, ppos);
+	if (rc || !write)
+		return rc;
+
+	if (!capable(CAP_SYS_ADMIN) || (new_bits == 0 && old_bits))
+		return -EACCES;
+	if (new_bits && old_bits)
+		return 0;
+	return bitness_lock(current->nsproxy->pid_ns);
+}
+
+static struct ctl_table abi_syscall_restrict[] = {
+	{
+		.procname = "bitness_locked",
+		.mode = 0644,
+		.proc_handler = bitness_locked_handler
+	},
+	{}
+};
+
+#else /* CONFIG_IA32_EMULATION */
+
+static int one = 1;
+
+static struct ctl_table abi_syscall_restrict[] = {
+	{
+		.procname	= "bitness_locked",
+		.data		= &one,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
+		.extra2		= &one,
+	},
+	{}
+};
+
+#endif /* CONFIG_IA32_EMULATION */
+
+
+static struct ctl_table abi_root[] = {
+	{
+		.procname = "abi",
+		.mode = 0555,
+		.child = abi_syscall_restrict
+	},
+	{}
+};
+
+__init int syscall_restrict_init(void)
+{
+	register_sysctl_table(abi_root);
+	return 0;
+}
+device_initcall(syscall_restrict_init);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 9682ec5..a9bf9cf 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -116,7 +116,7 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
 	dec_preempt_count();
 }
 
-static void __kprobes
+void __kprobes
 do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 	long error_code, siginfo_t *info)
 {
diff --git a/kernel/fork.c b/kernel/fork.c
index e7ceaca..55e4455 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1039,6 +1039,10 @@ static void posix_cpu_timers_init(struct task_struct *tsk)
 	INIT_LIST_HEAD(&tsk->cpu_timers[2]);
 }
 
+#ifndef __HAVE_ARCH_POST_FORK
+#define arch_post_fork(p)
+#endif
+
 /*
  * This creates a new process as a copy of the old one,
  * but does not actually start it yet.
@@ -1374,6 +1378,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	total_forks++;
 	spin_unlock(&current->sighand->siglock);
 	write_unlock_irq(&tasklist_lock);
+	arch_post_fork(p);
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
 	if (clone_flags & CLONE_THREAD)
-- 
Vasiliy
