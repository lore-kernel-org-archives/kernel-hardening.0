Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Thu, 21 Jul 2011 17:03:29 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110721130329.GA7309@albatros>
References: <20110718194803.GA5337@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718194803.GA5337@albatros>
Subject: [kernel-hardening] Re: GNU_STACK policy problem
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 18, 2011 at 23:48 +0400, Vasiliy Kulikov wrote:
> I've written kernel part of PT_GNU_STACK NX enforcement for binaries and
> trampolines emulation (the latter is taken from PaX as-is).  It Just
> Works for both 32 and 64 bits.

If someone wants to test it, the patch is as follows (it doesn't handle
DSOs as I've written before):

(Some pr_err() should be removed.)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 2dbf6bf..c6ddb02 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -559,6 +559,152 @@ static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
 	return 0;
 }
 
+/*
+ * These hex patterns (both for 32 and 64 bits) for trampolines code are
+ * extracted directly from gcc sources, so the match shouldn't lead to
+ * false positive and false negative result.
+ */
+static bool handle_trampolines_32(struct pt_regs *regs)
+{
+	int err;
+
+#ifdef CONFIG_X86_64
+	/* If we overflow maximum x86-32 address space, something goes
+	 * really wrong */
+	if ((regs->ip + 11) >> 32)
+		return;
+#endif
+
+	do {
+		unsigned char mov1, mov2;
+		unsigned short jmp;
+		unsigned int addr1, addr2;
+
+		err = get_user(mov1, (unsigned char __user *)regs->ip);
+		err |= get_user(addr1, (unsigned int __user *)(regs->ip + 1));
+		err |= get_user(mov2, (unsigned char __user *)(regs->ip + 5));
+		err |= get_user(addr2, (unsigned int __user *)(regs->ip + 6));
+		err |= get_user(jmp, (unsigned short __user *)(regs->ip + 10));
+
+		if (err)
+			break;
+
+		if (mov1 == 0xB9 && mov2 == 0xB8 && jmp == 0xE0FF) {
+			regs->cx = addr1;
+			regs->ax = addr2;
+			regs->ip = addr2;
+			return true;
+		}
+	} while (0);
+
+	do {
+		unsigned char mov, jmp;
+		unsigned int addr1, addr2;
+
+		err = get_user(mov, (unsigned char __user *)regs->ip);
+		err |= get_user(addr1, (unsigned int __user *)(regs->ip + 1));
+		err |= get_user(jmp, (unsigned char __user *)(regs->ip + 5));
+		err |= get_user(addr2, (unsigned int __user *)(regs->ip + 6));
+
+		if (err)
+			break;
+
+		if (mov == 0xB9 && jmp == 0xE9) {
+			regs->cx = addr1;
+			regs->ip = (unsigned int)(regs->ip + addr2 + 10);
+			return true;
+		}
+	} while (0);
+
+	/* Not a trampoline, don't block SEGFAULT */
+	return false;
+}
+
+#ifdef CONFIG_X86_64
+static bool handle_trampolines_64(struct pt_regs *regs)
+{
+	int err;
+
+	do {
+		unsigned short mov1, mov2, jmp1;
+		unsigned char jmp2;
+		unsigned int addr1;
+		unsigned long addr2;
+
+		err = get_user(mov1, (unsigned short __user *)regs->ip);
+		err |= get_user(addr1, (unsigned int __user *)(regs->ip + 2));
+		err |= get_user(mov2, (unsigned short __user *)(regs->ip + 6));
+		err |= get_user(addr2, (unsigned long __user *)(regs->ip + 8));
+		err |= get_user(jmp1, (unsigned short __user *)(regs->ip + 16));
+		err |= get_user(jmp2, (unsigned char __user *)(regs->ip + 18));
+
+		if (err)
+			break;
+
+		if (mov1 == 0xBB41 && mov2 == 0xBA49 && jmp1 == 0xFF49 && jmp2 == 0xE3) {
+			regs->r11 = addr1;
+			regs->r10 = addr2;
+			regs->ip = addr1;
+			return true;
+		}
+	} while (0);
+
+	do {
+		unsigned short mov1, mov2, jmp1;
+		unsigned char jmp2;
+		unsigned long addr1, addr2;
+
+		err = get_user(mov1, (unsigned short __user *)regs->ip);
+		err |= get_user(addr1, (unsigned long __user *)(regs->ip + 2));
+		err |= get_user(mov2, (unsigned short __user *)(regs->ip + 10));
+		err |= get_user(addr2, (unsigned long __user *)(regs->ip + 12));
+		err |= get_user(jmp1, (unsigned short __user *)(regs->ip + 20));
+		err |= get_user(jmp2, (unsigned char __user *)(regs->ip + 22));
+
+		if (err)
+			break;
+
+		if (mov1 == 0xBB49 && mov2 == 0xBA49 && jmp1 == 0xFF49 && jmp2 == 0xE3) {
+			regs->r11 = addr1;
+			regs->r10 = addr2;
+			regs->ip = addr1;
+			return true;
+		}
+	} while (0);
+
+	/* Not a trampoline, don't block SEGFAULT */
+	return false;
+}
+#endif
+
+static bool handle_trampolines(struct pt_regs *regs, unsigned long error_code,
+				 unsigned long address)
+{
+	if ((current->flags & PF_EMULTRAMP) == 0) {
+		pr_err("tramp: no EMULTRAMP\n");
+		return false;
+	}
+
+	if (v8086_mode(regs)) {
+		pr_err("tramp: v8086\n");
+		return false;
+	}
+	if ((error_code & PF_INSTR) == 0) {
+		pr_err("tramp: not PF_INSTR\n");
+		return false;
+	}
+
+#ifdef CONFIG_X86_32
+	return handle_trampolines_32(regs);
+#else
+	if (regs->cs == __USER32_CS || (regs->cs & SEGMENT_LDT))
+		return handle_trampolines_32(regs);
+	else
+		return handle_trampolines_64(regs);
+#endif
+}
+EXPORT_SYMBOL_GPL(handle_trampolines);
+
 static const char nx_warning[] = KERN_CRIT
 "kernel tried to execute NX-protected page - exploit attempt? (uid: %d)\n";
 
@@ -720,6 +867,9 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
 		if (is_errata100(regs, address))
 			return;
 
+		if (handle_trampolines(regs, error_code, address))
+			return;
+
 		if (unlikely(show_unhandled_signals))
 			show_signal_msg(regs, error_code, address, tsk);
 
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 303983f..64330e5 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -32,6 +32,7 @@
 #include <linux/elf.h>
 #include <linux/utsname.h>
 #include <linux/coredump.h>
+#include <linux/pid_namespace.h>
 #include <asm/uaccess.h>
 #include <asm/param.h>
 #include <asm/page.h>
@@ -556,6 +557,53 @@ static unsigned long randomize_stack_top(unsigned long stack_top)
 #endif
 }
 
+static int get_execstack(bool gnu_stack_present, int p_flags)
+{
+	struct pid_namespace *ns;
+	int pf_x;
+
+	if (gnu_stack_present) {
+		pf_x = p_flags & PF_X;
+		/* GNU_STACK => NX */
+		if (!pf_x)
+			return EXSTACK_DISABLE_X;
+
+		/* GNU_STACK => X */
+		ns = current->nsproxy->pid_ns;
+		if (ns->execstack_mode & GNU_STACK_X_FORCE_NX)
+			return EXSTACK_DISABLE_X;
+
+		return EXSTACK_ENABLE_X;
+	} else {
+		/* GNU_STACK => ? */
+		if (ns->execstack_mode & NO_GNU_STACK_FORCE_NX)
+			return EXSTACK_DISABLE_X;
+
+		return EXSTACK_DEFAULT;
+	}
+}
+
+static bool need_emultramp(bool gnu_stack_present, int p_flags)
+{
+	struct pid_namespace *ns;
+	int pf_x;
+
+	if (gnu_stack_present) {
+		pf_x = p_flags & PF_X;
+		/* GNU_STACK => NX */
+		if (!pf_x)
+			return false;
+
+		/* GNU_STACK => X */
+		ns = current->nsproxy->pid_ns;
+		return ns->execstack_mode & GNU_STACK_X_EMULTRAMP;
+	} else {
+		/* GNU_STACK => ? */
+		return ns->execstack_mode & NO_GNU_STACK_EMULTRAMP;
+	}
+
+}
+
 static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 {
 	struct file *interpreter = NULL; /* to shut gcc up */
@@ -571,12 +619,14 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	unsigned long interp_load_addr = 0;
 	unsigned long start_code, end_code, start_data, end_data;
 	unsigned long reloc_func_desc __maybe_unused = 0;
-	int executable_stack = EXSTACK_DEFAULT;
+	int executable_stack;
 	unsigned long def_flags = 0;
 	struct {
 		struct elfhdr elf_ex;
 		struct elfhdr interp_elf_ex;
 	} *loc;
+	bool gnu_stack_present = false;
+	int gnu_stack_flags = 0; /* unused value */
 
 	loc = kmalloc(sizeof(*loc), GFP_KERNEL);
 	if (!loc) {
@@ -689,13 +739,16 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	elf_ppnt = elf_phdata;
 	for (i = 0; i < loc->elf_ex.e_phnum; i++, elf_ppnt++)
 		if (elf_ppnt->p_type == PT_GNU_STACK) {
-			if (elf_ppnt->p_flags & PF_X)
-				executable_stack = EXSTACK_ENABLE_X;
-			else
-				executable_stack = EXSTACK_DISABLE_X;
-			break;
+			gnu_stack_present = true;
+			gnu_stack_flags = elf_ppnt->p_flags;
 		}
 
+	executable_stack = get_execstack(gnu_stack_present, gnu_stack_flags);
+	if (need_emultramp(gnu_stack_present, gnu_stack_flags)) {
+		pr_err("need emultramp\n");
+		current->flags |= PF_EMULTRAMP;
+	}
+
 	/* Some simple consistency checks for the interpreter */
 	if (elf_interpreter) {
 		retval = -ELIBBAD;
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 38d1032..c54c43c 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -16,6 +16,13 @@ struct pidmap {
 
 struct bsd_acct_struct;
 
+enum execstack_mode {
+	GNU_STACK_X_FORCE_NX = 1,
+	GNU_STACK_X_EMULTRAMP = 2,
+	NO_GNU_STACK_FORCE_NX = 4,
+	NO_GNU_STACK_EMULTRAMP = 8
+};
+
 struct pid_namespace {
 	struct kref kref;
 	struct pidmap pidmap[PIDMAP_ENTRIES];
@@ -30,6 +37,7 @@ struct pid_namespace {
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	struct bsd_acct_struct *bacct;
 #endif
+	enum execstack_mode execstack_mode;
 };
 
 extern struct pid_namespace init_pid_ns;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 496770a..1b4a25e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1765,6 +1765,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define PF_FROZEN	0x00010000	/* frozen for system suspend */
 #define PF_FSTRANS	0x00020000	/* inside a filesystem transaction */
 #define PF_KSWAPD	0x00040000	/* I am kswapd */
+#define PF_EMULTRAMP	0x00080000	/* gcc tramplolines must be emulated */
 #define PF_LESS_THROTTLE 0x00100000	/* Throttle me less: I clean memory */
 #define PF_KTHREAD	0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE	0x00400000	/* randomize virtual address space */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f175d98..de049f9 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -175,6 +175,8 @@ static int proc_taint(struct ctl_table *table, int write,
 static int proc_dmesg_restrict(struct ctl_table *table, int write,
 				void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
+static int proc_execstack_mode(struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp, loff_t *ppos);
 
 #ifdef CONFIG_MAGIC_SYSRQ
 /* Note: sysrq code uses it's own private copy */
@@ -984,6 +986,12 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+	{
+		.procname	= "execstack_mode",
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_execstack_mode,
+	},
 	{ }
 };
 
@@ -2426,6 +2434,15 @@ static int proc_dmesg_restrict(struct ctl_table *table, int write,
 }
 #endif
 
+static int proc_execstack_mode(struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table tbl = *table;
+	tbl.data = &current->nsproxy->pid_ns->execstack_mode;
+
+	return proc_dointvec_minmax(&tbl, write, buffer, lenp, ppos);
+}
+
 struct do_proc_dointvec_minmax_conv_param {
 	int *min;
 	int *max;
