Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Thu, 18 Aug 2011 18:40:47 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110818144047.GA20514@albatros>
References: <20110812150304.GC16880@albatros>
 <4E45884B.8030303@zytor.com>
 <20110813062246.GC3851@albatros>
 <36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com>
 <20110813163252.GA18458@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110813163252.GA18458@albatros>
Subject: [kernel-hardening] [RFC v2] x86: restrict pid namespaces to 32 or 64 bit syscalls
To: kernel-hardening@lists.openwall.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, James Morris <jmorris@namei.org>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

In case someone is still interested in the patch - here it is.
The slowdown issue is solved in this version.  Given that it
significantly correlates with seccomp patch, I don't expect it to be
applied.  However, if anybody want to discuss it - I don't mind :)

================================
Subject: [RFC v2] x86: restrict pid namespaces to 32 or 64 bit syscalls
From: Vasiliy Kulikov <segoon@openwall.com>

This patch allows x86-64 systems with 32 bit syscalls support to lock a
task to 32 or 64 bitness syscalls/tasks.  By denying rarely used
compatibility syscalls it reduces an attack surface for untrusted 
containers.

Two new prctl() commands are introduced: PR_BITNESS_LOCK_ON_EXEC and
PR_BITNESS_LOCK.  PR_BITNESS_LOCK immediately locks the current task to
the current bitness.  The restriction is inherited via fork() and cannot
be removed.  PR_BITNESS_LOCK_ON_EXEC locks the task on the next
execve() call.  It's possible to limit the next execve() to the bitness
of the executed binary or to the specific bitness.  If the specified
bitness differs from the binary bitness, execve() fails.  The flag is
cleared if execve() fails.

After the task is locked to some bitness (1) all syscalls of other bitness
cause sending SIGKILL and (2) loading ELF binaries of another bitness
(or non-ELF binfmt, except scripts) is prohibited (as if the
corresponding CONFIG_BINFMT_*=N).

v2 - Changed interface from sysctl locking a pid namespace to prctl()
     locking current task.
   - Used _TIF_WORK_SYSCALL_ENTRY macros to remove a slowdown of not
     locked tasks.

--
 arch/x86/ia32/ia32entry.S          |   10 +-
 arch/x86/include/asm/elf.h         |    6 +
 arch/x86/include/asm/ptrace.h      |    6 +
 arch/x86/include/asm/thread_info.h |   36 ++++++-
 arch/x86/kernel/Makefile           |    1 +
 arch/x86/kernel/entry_64.S         |    4 +-
 arch/x86/kernel/ptrace.c           |   11 ++-
 arch/x86/kernel/syscall_restrict.c |  200 ++++++++++++++++++++++++++++++++++++
 fs/binfmt_elf.c                    |    7 +-
 fs/binfmt_script.c                 |    2 +-
 fs/exec.c                          |   13 +++
 include/linux/prctl.h              |    3 +
 include/linux/sched.h              |    5 +
 kernel/sys.c                       |    6 +-
 14 files changed, 295 insertions(+), 15 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index a0e866d..c7960f3 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -152,7 +152,7 @@ ENTRY(ia32_sysenter_target)
  	.previous	
 	GET_THREAD_INFO(%r10)
 	orl    $TS_COMPAT,TI_status(%r10)
-	testl  $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
+	testl  $_TIF_WORK_SYSCALL_ENTRY_32,TI_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz  sysenter_tracesys
 	cmpq	$(IA32_NR_syscalls-1),%rax
@@ -238,7 +238,7 @@ sysexit_audit:
 
 sysenter_tracesys:
 #ifdef CONFIG_AUDITSYSCALL
-	testl	$(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
+	testl	$(_TIF_WORK_SYSCALL_ENTRY_32 & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
 	jz	sysenter_auditsys
 #endif
 	SAVE_REST
@@ -311,7 +311,7 @@ ENTRY(ia32_cstar_target)
 	.previous	
 	GET_THREAD_INFO(%r10)
 	orl   $TS_COMPAT,TI_status(%r10)
-	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
+	testl $_TIF_WORK_SYSCALL_ENTRY_32,TI_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz   cstar_tracesys
 	cmpq $IA32_NR_syscalls-1,%rax
@@ -355,7 +355,7 @@ sysretl_audit:
 
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
@@ -320,4 +320,10 @@ extern int syscall32_setup_pages(struct linux_binprm *, int exstack);
 extern unsigned long arch_randomize_brk(struct mm_struct *mm);
 #define arch_randomize_brk arch_randomize_brk
 
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
@@ -281,6 +281,12 @@ extern int do_get_thread_area(struct task_struct *p, int idx,
 extern int do_set_thread_area(struct task_struct *p, int idx,
 			      struct user_desc __user *info, int can_allocate);
 
+extern int syscall_bitness_check(void);
+
+extern long arch_prctl(int option, unsigned long arg2, unsigned long arg3,
+		unsigned long arg4, unsigned long arg5);
+#define arch_prctl arch_prctl
+
 #endif /* __KERNEL__ */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index a1fe5c1..69e8f68 100644
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
@@ -117,11 +119,20 @@ struct thread_info {
 #define _TIF_BLOCKSTEP		(1 << TIF_BLOCKSTEP)
 #define _TIF_LAZY_MMU_UPDATES	(1 << TIF_LAZY_MMU_UPDATES)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
+#define _TIF_SYSCALL32_DENIED	(1 << TIF_SYSCALL32_DENIED)
+#define _TIF_SYSCALL64_DENIED	(1 << TIF_SYSCALL64_DENIED)
 
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
 
 /* work to do in syscall_trace_leave() */
 #define _TIF_WORK_SYSCALL_EXIT	\
@@ -259,12 +270,29 @@ static inline void set_restore_sigmask(void)
 	ti->status |= TS_RESTORE_SIGMASK;
 	set_bit(TIF_SIGPENDING, (unsigned long *)&ti->flags);
 }
-#endif	/* !__ASSEMBLY__ */
 
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
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
 #define arch_task_cache_init arch_task_cache_init
+
+struct linux_binfmt;
+extern bool arch_check_interpreter(struct linux_binfmt *fmt);
+#define arch_check_interpreter arch_check_interpreter
 #endif
 #endif /* _ASM_X86_THREAD_INFO_H */
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
 		regs->flags |= X86_EFLAGS_TF;
 
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
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_EMU)))
diff --git a/arch/x86/kernel/syscall_restrict.c b/arch/x86/kernel/syscall_restrict.c
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
+		flag = TIF_SYSCALL32_DENIED;
+	else
+		flag = TIF_SYSCALL64_DENIED;
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
+	int clear_bit_nr = bits_to_flags(bits);
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
+		mask = BITNESS_LOCK_32;
+		break;
+	case 64:
+		mask = BITNESS_LOCK_64;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	current->bitness_lock_on_exec.lock &= ~mask;
+	if (val)
+		current->bitness_lock_on_exec.lock |= mask;
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
+	if (current->bitness_lock_on_exec.lock == 0 ||
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
+	if (current->bitness_lock_on_exec.lock == 0 ||
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
+	if (fmt == &compat_elf_format)
+		return compat_elf_may_exec();
+
+	if (fmt == &elf_format)
+		return elf_may_exec();
+
+	/* We're ok with loading script, which interpreter is legitimate ELF */
+	if (fmt == &script_format)
+		return true;
+
+	if (current->bitness_lock_on_exec.lock == 0)
+		return true;
+
+	return false;
+}
+
+/*
+ * We cannot do it in arch_post_exec_elf() as it can be called from
+ * binfmt_script's handler, which may fail. If the call sequence is
+ *
+ *  binfmt_script -> binfmt_elf => FAIL
+ *  binfmt_elf => OK
+ *
+ * We should be locked.  To keep code simple, we just clear ->.bitness.lock
+ * on each execve() regardless of return code.
+ */
+void arch_post_execve(void)
+{
+	current->bitness_lock_on_exec.lock = 0;
+}
+
+void arch_post_exec_elf(int retval, int elf_class)
+{
+	if (retval == 0 && current->bitness_lock_on_exec.lock) {
+		int bits = (elf_class == ELFCLASS32) ? 32 : 64;
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
+	if (bits == 64)
+		return 0;
+	else
+		return -EINVAL;
+}
+
+static int __bitness_lock(int bits)
+{
+	if (bits == 64)
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
index dd0fdfc..41a86fb 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -65,7 +65,7 @@ static int elf_core_dump(struct coredump_params *cprm);
 #define ELF_PAGEOFFSET(_v) ((_v) & (ELF_MIN_ALIGN-1))
 #define ELF_PAGEALIGN(_v) (((_v) + ELF_MIN_ALIGN - 1) & ~(ELF_MIN_ALIGN - 1))
 
-static struct linux_binfmt elf_format = {
+struct linux_binfmt elf_format = {
 	.module		= THIS_MODULE,
 	.load_binary	= load_elf_binary,
 	.load_shlib	= load_elf_library,
@@ -556,6 +556,10 @@ static unsigned long randomize_stack_top(unsigned long stack_top)
 #endif
 }
 
+#ifndef arch_post_exec_elf
+#define arch_post_exec_elf(rc, class)
+#endif
+
 static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 {
 	struct file *interpreter = NULL; /* to shut gcc up */
@@ -979,6 +983,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 out:
 	kfree(loc);
 out_ret:
+	arch_post_exec_elf(retval, ELF_CLASS);
 	return retval;
 
 	/* error cleanup */
diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index 396a988..be0e4c5 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -98,7 +98,7 @@ static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
 	return search_binary_handler(bprm,regs);
 }
 
-static struct linux_binfmt script_format = {
+struct linux_binfmt script_format = {
 	.module		= THIS_MODULE,
 	.load_binary	= load_script,
 };
diff --git a/fs/exec.c b/fs/exec.c
index da80612..784c48a 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1390,6 +1390,8 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 			int (*fn)(struct linux_binprm *, struct pt_regs *) = fmt->load_binary;
 			if (!fn)
 				continue;
+			if (!arch_check_interpreter(fmt))
+				continue;
 			if (!try_module_get(fmt->module))
 				continue;
 			read_unlock(&binfmt_lock);
@@ -1441,11 +1443,20 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 		break;
 #endif
 	}
+
 	return retval;
 }
 
 EXPORT_SYMBOL(search_binary_handler);
 
+#ifndef arch_post_execve
+#define arch_post_execve()
+#endif
+
+#ifndef arch_check_interpreter
+#define arch_check_interpreter(x) true
+#endif
+
 /*
  * sys_execve() executes a new program.
  */
@@ -1527,6 +1538,7 @@ static int do_execve_common(const char *filename,
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
 	acct_update_integrals(current);
+	arch_post_execve();
 	free_bprm(bprm);
 	if (displaced)
 		put_files_struct(displaced);
@@ -1556,6 +1568,7 @@ out_files:
 	if (displaced)
 		reset_files_struct(displaced);
 out_ret:
+	arch_post_execve();
 	return retval;
 }
 
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index a3baeb2..91edb9c 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -102,4 +102,7 @@
 
 #define PR_MCE_KILL_GET 34
 
+#define PR_BITNESS_LOCK_ON_EXEC	35
+#define PR_BITNESS_LOCK		36
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 20b03bf..ee5ba82 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1046,6 +1046,10 @@ partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 }
 #endif	/* !CONFIG_SMP */
 
+#ifndef bitness_lock_on_exec
+struct bitness_lock_on_exec {};
+#define bitness_lock_on_exec bitness_lock_on_exec
+#endif /* bitness_lock_t */
 
 struct io_context;			/* See blkdev.h */
 
@@ -1405,6 +1409,7 @@ struct task_struct {
 	unsigned int sessionid;
 #endif
 	seccomp_t seccomp;
+	struct bitness_lock_on_exec bitness_lock_on_exec;
 
 /* Thread group tracking */
    	u32 parent_exec_id;
diff --git a/kernel/sys.c b/kernel/sys.c
index a101ba3..e7faa8b 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1644,6 +1644,10 @@ SYSCALL_DEFINE1(umask, int, mask)
 	return mask;
 }
 
+#ifndef arch_prctl
+#define arch_prctl(o, a2, a3, a4, a5) (-EINVAL)
+#endif
+
 SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
@@ -1793,7 +1797,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 				error = PR_MCE_KILL_DEFAULT;
 			break;
 		default:
-			error = -EINVAL;
+			error = arch_prctl(option, arg2, arg3, arg4, arg5);
 			break;
 	}
 	return error;

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
