Date: Mon, 13 Mar 2017 14:14:22 -0700
From: Tycho Andersen <tycho@docker.com>
Message-ID: <20170313211422.cxtmes35ozkwaisu@docker>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ty2472gdypsdn7ze"
Content-Disposition: inline
Subject: [kernel-hardening] stackleak plugin port to upstream kernel
To: PaX Team <pageexec@freemail.hu>, Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--ty2472gdypsdn7ze
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

I have an initial version of a port of the stackleak plugin ported to the
mainline kernel (attached), but naturally it doesn't quite work, killing init
with:

[    0.684209] Kernel BUG at ffffffff819893e2 [verbose debug info unavailable]
[    0.686467] invalid opcode: 0000 [#2] SMP
[    0.688337] Modules linked in:
[    0.691232] CPU: 3 PID: 1 Comm: init Tainted: G      D         4.11.0-rc1+ #5
[    0.693076] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu2 04/01/2014
[    0.695461] task: ffff880134af0000 task.stack: ffffc90000630000
[    0.696736] RIP: 0010:erase_kstack+0x52/0x80
[    0.697854] RSP: 0000:ffffc90000633f28 EFLAGS: 00010006
[    0.699025] RAX: ffffffffffff4111 RBX: ffffffff81982a20 RCX: 0000000000633f18
[    0.700430] RDX: 000000000000028b RSI: 0000000000000002 RDI: 0000000000000010
[    0.701989] RBP: ffffc90000633f50 R08: 000000000001cc00 R09: 0000000000000000
[    0.703693] R10: ffffea0004d1b780 R11: ffff880134af0000 R12: 0000000000000000
[    0.705069] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    0.706393] FS:  0000000000000000(0000) GS:ffff880139d80000(0000) knlGS:0000000000000000
[    0.707958] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.708917] CR2: 00007ffe49fb2a29 CR3: 000000013476d000 CR4: 00000000000006e0
[    0.709946] Call Trace:
[    0.710565]  ? ret_from_fork+0x20/0x40
[    0.711285] Code: 03 f2 48 af 67 e3 12 83 f9 10 72 0d b9 10 00 00 00 f3 48 af 67 e3 02 75 dd fc 48 83 cf 10 89 e1 29 f9 48 81 f9 00 40 00 00 72 02 <0f> 0b c1 e9 03 f3 48 ab 49 8b bb d8 08 00 00 48 81 ef 00 01 00 
[    0.713935] RIP: erase_kstack+0x52/0x80 RSP: ffffc90000633f28

The problem seems to be in the erase_kstack routine in
arch/x86/entry/entry_64.S, it seems to be looking for a series of 0xBEEFs,
which aren't found. I'm struggling to figure out where these 0xBEEFs come from:
are they part of the mainline kernel stack initialization and something has
gone totally haywire, or is this some PaX thing that I've overlooked?

Thanks!

Tycho

--ty2472gdypsdn7ze
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-gcc-plugins-add-stackleak-plugin-to-zero-kernel-stac.patch"

>From 27d444303e541c741d37ec9691c00f8b0e53d4d4 Mon Sep 17 00:00:00 2001
From: Tycho Andersen <tycho@docker.com>
Date: Thu, 9 Mar 2017 17:47:46 -0800
Subject: [PATCH] gcc-plugins: add stackleak plugin to zero kernel stack

This plugin adds an option to zero the kernel stack after a syscall return
so that no information is leaked on the kernel stack.

Ported from grsecurity/PaX. Minor changes to macro names to be more
upstream-esque.

Signed-off-by: Tycho Andersen <tycho@docker.com>
---
 arch/Kconfig                           |  15 ++
 arch/x86/Kconfig                       |   1 +
 arch/x86/entry/common.c                |  15 +-
 arch/x86/entry/entry_32.S              |  68 +++++++
 arch/x86/entry/entry_64.S              |  69 +++++++
 arch/x86/entry/entry_64_compat.S       |  12 ++
 arch/x86/include/asm/processor.h       |   4 +
 arch/x86/kernel/asm-offsets.c          |   9 +
 arch/x86/kernel/dumpstack_64.c         |  33 ++++
 fs/exec.c                              |  13 ++
 scripts/Makefile.gcc-plugins           |   3 +
 scripts/gcc-plugins/stackleak_plugin.c | 342 +++++++++++++++++++++++++++++++++
 12 files changed, 582 insertions(+), 2 deletions(-)
 create mode 100644 scripts/gcc-plugins/stackleak_plugin.c

diff --git a/arch/Kconfig b/arch/Kconfig
index cd211a1..48af925 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -436,6 +436,21 @@ config GCC_PLUGIN_STRUCTLEAK_VERBOSE
 	  initialized. Since not all existing initializers are detected
 	  by the plugin, this can produce false positive warnings.
 
+config ARCH_HAS_STACKLEAK
+	def_bool n
+
+config GCC_PLUGIN_STACKLEAK
+	bool "Zero the kernel stack after syscalls"
+	depends on GCC_PLUGINS
+	depends on ARCH_HAS_STACKLEAK
+	help
+	  This plugin zero-initializes the kernel stack after every system call. This
+	  can prevent some classes of information exposures.
+
+	  This plugin was ported from grsecurity/PaX. More information at:
+	   * https://grsecurity.net/
+	   * https://pax.grsecurity.net/
+
 config HAVE_CC_STACKPROTECTOR
 	bool
 	help
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cc98d5a..5988a5f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -56,6 +56,7 @@ config X86
 	select ARCH_HAS_PMEM_API		if X86_64
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_SG_CHAIN
+	select ARCH_HAS_STACKLEAK
 	select ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_HAS_STRICT_MODULE_RWX
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 370c42c..39cb5fd 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -43,6 +43,12 @@ __visible inline void enter_from_user_mode(void)
 static inline void enter_from_user_mode(void) {}
 #endif
 
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+asmlinkage void erase_kstack(void);
+#else
+static void erase_kstack(void) {}
+#endif
+
 static void do_audit_syscall_entry(struct pt_regs *regs, u32 arch)
 {
 #ifdef CONFIG_X86_64
@@ -79,8 +85,10 @@ static long syscall_trace_enter(struct pt_regs *regs)
 		emulated = true;
 
 	if ((emulated || (work & _TIF_SYSCALL_TRACE)) &&
-	    tracehook_report_syscall_entry(regs))
+	    tracehook_report_syscall_entry(regs)) {
+		erase_kstack();
 		return -1L;
+	}
 
 	if (emulated)
 		return -1L;
@@ -115,8 +123,10 @@ static long syscall_trace_enter(struct pt_regs *regs)
 		}
 
 		ret = __secure_computing(&sd);
-		if (ret == -1)
+		if (ret == -1) {
+			erase_kstack();
 			return ret;
+		}
 	}
 #endif
 
@@ -125,6 +135,7 @@ static long syscall_trace_enter(struct pt_regs *regs)
 
 	do_audit_syscall_entry(regs, arch);
 
+	erase_kstack();
 	return ret ?: regs->orig_ax;
 }
 
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 57f7ec3..325db99 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -78,6 +78,66 @@
 #endif
 .endm
 
+
+.macro erase_kstack
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	call erase_kstack
+#endif
+.endm
+
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+/*
+ * ebp: thread_info
+ */
+ENTRY(erase_kstack)
+	pushl %edi
+	pushl %ecx
+	pushl %eax
+	pushl %ebp
+
+	movl	PER_CPU_VAR(current_task), %ebp
+	mov TASK_lowest_stack(%ebp), %edi
+	mov $-0xBEEF, %eax
+	std
+
+1:	mov %edi, %ecx
+	and $THREAD_SIZE_asm - 1, %ecx
+	shr $2, %ecx
+	repne scasl
+	jecxz 2f
+
+	cmp $2*16, %ecx
+	jc 2f
+
+	mov $2*16, %ecx
+	repe scasl
+	jecxz 2f
+	jne 1b
+
+2:	cld
+	or $2*4, %edi
+	mov %esp, %ecx
+	sub %edi, %ecx
+
+	cmp $THREAD_SIZE_asm, %ecx
+	jb 3f
+	ud2
+3:
+
+	shr $2, %ecx
+	rep stosl
+
+	mov TASK_thread_sp0(%ebp), %edi
+	sub $128, %edi
+	mov %edi, TASK_lowest_stack(%ebp)
+
+	popl %ebp
+	popl %eax
+	popl %ecx
+	popl %edi
+ENDPROC(erase_kstack)
+#endif
+
 /*
  * User gs save/restore
  *
@@ -440,6 +500,10 @@ ENTRY(entry_SYSENTER_32)
 	ALTERNATIVE "testl %eax, %eax; jz .Lsyscall_32_done", \
 		    "jmp .Lsyscall_32_done", X86_FEATURE_XENPV
 
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	erase_kstack
+#endif
+
 /* Opportunistic SYSEXIT */
 	TRACE_IRQS_ON			/* User mode traces as IRQs on. */
 	movl	PT_EIP(%esp), %edx	/* pt_regs->ip */
@@ -526,6 +590,10 @@ ENTRY(entry_INT80_32)
 	call	do_int80_syscall_32
 .Lsyscall_32_done:
 
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	erase_kstack
+#endif
+
 restore_all:
 	TRACE_IRQS_IRET
 .Lrestore_all_notrace:
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 044d18e..024615e 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -58,6 +58,62 @@ ENDPROC(native_usergs_sysret64)
 #endif
 .endm
 
+.macro erase_kstack
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	call erase_kstack
+#endif
+.endm
+
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+ENTRY(erase_kstack)
+	pushq	%rdi
+	pushq	%rcx
+	pushq	%rax
+	pushq	%r11
+
+	movq PER_CPU_VAR(current_task), %r11
+	mov	TASK_lowest_stack(%r11), %rdi
+	mov	$-0xBEEF, %rax
+	std
+
+1:	mov	%edi, %ecx
+	and	$THREAD_SIZE_asm - 1, %ecx
+	shr	$3, %ecx
+	repne	scasq
+	jecxz	2f
+
+	cmp	$2*8, %ecx
+	jc	2f
+
+	mov	$2*8, %ecx
+	repe	scasq
+	jecxz	2f
+	jne	1b
+
+2:	cld
+	or	$2*8, %rdi
+	mov	%esp, %ecx
+	sub	%edi, %ecx
+
+	cmp	$THREAD_SIZE_asm, %rcx
+	jb	3f
+	ud2
+3:
+
+	shr	$3, %ecx
+	rep	stosq
+
+	mov	TASK_thread_sp0(%r11), %rdi
+	sub	$256, %rdi
+	mov	%rdi, TASK_lowest_stack(%r11)
+
+	popq	%r11
+	popq	%rax
+	popq	%rcx
+	popq	%rdi
+ENDPROC(erase_kstack)
+#endif
+
 /*
  * When dynamic function tracer is enabled it will add a breakpoint
  * to all locations that it is about to modify, sync CPUs, update
@@ -218,6 +274,10 @@ entry_SYSCALL_64_fastpath:
 	testl	$_TIF_ALLWORK_MASK, TASK_TI_flags(%r11)
 	jnz	1f
 
+#ifdef CONFIG_GCC_PLUGIN_STACKLEACK
+	erase_kstack
+#endif
+
 	LOCKDEP_SYS_EXIT
 	TRACE_IRQS_ON		/* user mode is traced as IRQs on */
 	movq	RIP(%rsp), %rcx
@@ -246,6 +306,10 @@ entry_SYSCALL64_slow_path:
 	call	do_syscall_64		/* returns with IRQs disabled */
 
 return_from_SYSCALL_64:
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	erase_kstack
+#endif
+
 	RESTORE_EXTRA_REGS
 	TRACE_IRQS_IRETQ		/* we're about to change IF */
 
@@ -419,6 +483,9 @@ ENTRY(ret_from_fork)
 2:
 	leaq	FRAME_OFFSET(%rsp),%rdi	/* pt_regs pointer */
 	call	syscall_return_slowpath	/* returns with IRQs disabled */
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	erase_kstack
+#endif
 	TRACE_IRQS_ON			/* user mode is traced as IRQS on */
 	SWAPGS
 	FRAME_END
@@ -532,6 +599,8 @@ ret_from_intr:
 GLOBAL(retint_user)
 	mov	%rsp,%rdi
 	call	prepare_exit_to_usermode
+# PaX has this here but commented out. Why?
+#	pax_erase_kstack
 	TRACE_IRQS_IRETQ
 	SWAPGS
 	jmp	restore_regs_and_iret
diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
index e1721da..63af1d5 100644
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -18,6 +18,12 @@
 
 	.section .entry.text, "ax"
 
+	.macro erase_kstack
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	call erase_kstack
+#endif
+	.endm
+
 /*
  * 32-bit SYSENTER entry.
  *
@@ -229,6 +235,9 @@ ENTRY(entry_SYSCALL_compat)
 
 	/* Opportunistic SYSRET */
 sysret32_from_system_call:
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	erase_kstack
+#endif
 	TRACE_IRQS_ON			/* User mode traces as IRQs on. */
 	movq	RBX(%rsp), %rbx		/* pt_regs->rbx */
 	movq	RBP(%rsp), %rbp		/* pt_regs->rbp */
@@ -337,6 +346,9 @@ ENTRY(entry_INT80_compat)
 .Lsyscall_32_done:
 
 	/* Go back to user mode. */
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	erase_kstack
+#endif
 	TRACE_IRQS_ON
 	SWAPGS
 	jmp	restore_regs_and_iret
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index f385eca..e47c9bd 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -469,6 +469,10 @@ struct thread_struct {
 
 	mm_segment_t		addr_limit;
 
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	unsigned long		lowest_stack;
+#endif
+
 	unsigned int		sig_on_uaccess_err:1;
 	unsigned int		uaccess_err:1;	/* uaccess failed */
 
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index de827d6..4ed7451 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -37,6 +37,10 @@ void common(void) {
 	BLANK();
 	OFFSET(TASK_TI_flags, task_struct, thread_info.flags);
 	OFFSET(TASK_addr_limit, task_struct, thread.addr_limit);
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	OFFSET(TASK_lowest_stack, task_struct, thread.lowest_stack);
+	OFFSET(TASK_thread_sp0, task_struct, thread.sp0);
+#endif
 
 	BLANK();
 	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
@@ -73,6 +77,11 @@ void common(void) {
 	OFFSET(PV_MMU_read_cr2, pv_mmu_ops, read_cr2);
 #endif
 
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	BLANK();
+	DEFINE(THREAD_SIZE_asm, THREAD_SIZE);
+#endif
+
 #ifdef CONFIG_XEN
 	BLANK();
 	OFFSET(XEN_vcpu_info_mask, vcpu_info, evtchn_upcall_mask);
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index a8b117e..dc29be8 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -188,3 +188,36 @@ int is_valid_bugaddr(unsigned long ip)
 
 	return ud2 == 0x0b0f;
 }
+
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+void __used check_alloca(unsigned long size)
+{
+	struct stack_info stack_info = {0};
+	unsigned long visit_mask = 0;
+	unsigned long sp = (unsigned long)&sp;
+	unsigned long stack_left;
+
+	BUG_ON(get_stack_info(&sp, current, &stack_info, &visit_mask));
+
+	switch (stack_info.type) {
+	case STACK_TYPE_TASK:
+		stack_left = sp & (THREAD_SIZE - 1);
+		break;
+
+	case STACK_TYPE_IRQ:
+		stack_left = sp & (IRQ_STACK_SIZE - 1);
+		break;
+
+	case STACK_TYPE_EXCEPTION ... STACK_TYPE_EXCEPTION_LAST:
+		stack_left = sp & (EXCEPTION_STKSZ - 1);
+		break;
+
+	case STACK_TYPE_SOFTIRQ:
+	default:
+		BUG();
+	}
+
+	BUG_ON(stack_left < 256 || size >= stack_left - 256);
+}
+EXPORT_SYMBOL(check_alloca);
+#endif
diff --git a/fs/exec.c b/fs/exec.c
index 65145a3..a116bd20 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1927,3 +1927,16 @@ COMPAT_SYSCALL_DEFINE5(execveat, int, fd,
 				  argv, envp, flags);
 }
 #endif
+
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+void __used track_stack(void)
+{
+	unsigned long sp = (unsigned long)&sp;
+	if (sp < current->thread.lowest_stack &&
+	    sp >= (unsigned long)task_stack_page(current) + 2 * sizeof(unsigned long))
+		current->thread.lowest_stack = sp;
+	if (unlikely((sp & ~(THREAD_SIZE - 1)) < (THREAD_SIZE/16)))
+		BUG();
+}
+EXPORT_SYMBOL(track_stack);
+#endif
diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index 8233553..c998092 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -29,6 +29,9 @@ ifdef CONFIG_GCC_PLUGINS
   gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_VERBOSE)	+= -fplugin-arg-structleak_plugin-verbose
   gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK)	+= -DSTRUCTLEAK_PLUGIN
 
+  gcc-plugin-$(CONFIG_PAX_MEMORY_STACKLEAK)		+= stackleak_plugin.so$
+  gcc-plugin-cflags-$(CONFIG_PAX_MEMORY_STACKLEAK)	+= -DSTACKLEAK_PLUGIN -fplugin-arg-stackleak_plugin-track-lowest-sp=100$
+
   GCC_PLUGINS_CFLAGS := $(strip $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
 
   export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGIN GCC_PLUGIN_SUBDIR
diff --git a/scripts/gcc-plugins/stackleak_plugin.c b/scripts/gcc-plugins/stackleak_plugin.c
new file mode 100644
index 0000000..5694585
--- /dev/null
+++ b/scripts/gcc-plugins/stackleak_plugin.c
@@ -0,0 +1,342 @@
+/*
+ * Copyright 2011-2017 by the PaX Team <pageexec@freemail.hu>
+ * Licensed under the GPL v2
+ *
+ * Note: the choice of the license means that the compilation process is
+ *       NOT 'eligible' as defined by gcc's library exception to the GPL v3,
+ *       but for the kernel it doesn't matter since it doesn't link against
+ *       any of the gcc libraries
+ *
+ * gcc plugin to help implement various PaX features
+ *
+ * - track lowest stack pointer
+ *
+ * TODO:
+ * - initialize all local variables
+ *
+ * BUGS:
+ * - none known
+ */
+
+#include "gcc-common.h"
+
+__visible int plugin_is_GPL_compatible;
+
+static int track_frame_size = -1;
+static const char track_function[] = "track_stack";
+static const char check_function[] = "check_alloca";
+static GTY(()) tree track_function_decl;
+static GTY(()) tree check_function_decl;
+static bool init_locals;
+
+static struct plugin_info stackleak_plugin_info = {
+	.version	= "201602181345",
+	.help		= "track-lowest-sp=nn\ttrack sp in functions whose frame size is at least nn bytes\n"
+//			  "initialize-locals\t\tforcibly initialize all stack frames\n"
+};
+
+static void stackleak_check_alloca(gimple_stmt_iterator *gsi)
+{
+	gimple stmt;
+	gcall *check_alloca;
+	tree alloca_size;
+	cgraph_node_ptr node;
+	int frequency;
+	basic_block bb;
+
+	// insert call to void pax_check_alloca(unsigned long size)
+	alloca_size = gimple_call_arg(gsi_stmt(*gsi), 0);
+	stmt = gimple_build_call(check_function_decl, 1, alloca_size);
+	check_alloca = as_a_gcall(stmt);
+	gsi_insert_before(gsi, check_alloca, GSI_SAME_STMT);
+
+	// update the cgraph
+	bb = gimple_bb(check_alloca);
+	node = cgraph_get_create_node(check_function_decl);
+	gcc_assert(node);
+	frequency = compute_call_stmt_bb_frequency(current_function_decl, bb);
+	cgraph_create_edge(cgraph_get_node(current_function_decl), node, check_alloca, bb->count, frequency, bb->loop_depth);
+}
+
+static void stackleak_add_instrumentation(gimple_stmt_iterator *gsi, bool after)
+{
+	gimple stmt;
+	gcall *track_stack;
+	cgraph_node_ptr node;
+	int frequency;
+	basic_block bb;
+
+	// insert call to void pax_track_stack(void)
+	stmt = gimple_build_call(track_function_decl, 0);
+	track_stack = as_a_gcall(stmt);
+	if (after)
+		gsi_insert_after(gsi, track_stack, GSI_CONTINUE_LINKING);
+	else
+		gsi_insert_before(gsi, track_stack, GSI_SAME_STMT);
+
+	// update the cgraph
+	bb = gimple_bb(track_stack);
+	node = cgraph_get_create_node(track_function_decl);
+	gcc_assert(node);
+	frequency = compute_call_stmt_bb_frequency(current_function_decl, bb);
+	cgraph_create_edge(cgraph_get_node(current_function_decl), node, track_stack, bb->count, frequency, bb->loop_depth);
+}
+
+static bool is_alloca(gimple stmt)
+{
+	if (gimple_call_builtin_p(stmt, BUILT_IN_ALLOCA))
+		return true;
+
+#if BUILDING_GCC_VERSION >= 4007
+	if (gimple_call_builtin_p(stmt, BUILT_IN_ALLOCA_WITH_ALIGN))
+		return true;
+#endif
+
+	return false;
+}
+
+static unsigned int stackleak_tree_instrument_execute(void)
+{
+	basic_block bb, entry_bb;
+	bool prologue_instrumented = false, is_leaf = true;
+
+	entry_bb = ENTRY_BLOCK_PTR_FOR_FN(cfun)->next_bb;
+
+	// 1. loop through BBs and GIMPLE statements
+	FOR_EACH_BB_FN(bb, cfun) {
+		gimple_stmt_iterator gsi;
+
+		for (gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi)) {
+			gimple stmt;
+
+			stmt = gsi_stmt(gsi);
+
+			if (is_gimple_call(stmt))
+				is_leaf = false;
+
+			// gimple match: align 8 built-in BUILT_IN_NORMAL:BUILT_IN_ALLOCA attributes <tree_list 0xb7576450>
+			if (!is_alloca(stmt))
+				continue;
+
+			// 2. insert stack overflow check before each __builtin_alloca call
+			stackleak_check_alloca(&gsi);
+
+			// 3. insert track call after each __builtin_alloca call
+			stackleak_add_instrumentation(&gsi, true);
+			if (bb == entry_bb)
+				prologue_instrumented = true;
+		}
+	}
+
+	// special cases for some bad linux code: taking the address of static inline functions will materialize them
+	// but we mustn't instrument some of them as the resulting stack alignment required by the function call ABI
+	// will break other assumptions regarding the expected (but not otherwise enforced) register clobbering  ABI.
+	// case in point: native_save_fl on amd64 when optimized for size clobbers rdx if it were instrumented here.
+	if (is_leaf && !TREE_PUBLIC(current_function_decl) && DECL_DECLARED_INLINE_P(current_function_decl))
+		return 0;
+	if (is_leaf && !strncmp(IDENTIFIER_POINTER(DECL_NAME(current_function_decl)), "_paravirt_", 10))
+		return 0;
+
+	// 4. insert track call at the beginning
+	if (!prologue_instrumented) {
+		gimple_stmt_iterator gsi;
+
+		gcc_assert(single_succ_p(ENTRY_BLOCK_PTR_FOR_FN(cfun)));
+		bb = single_succ(ENTRY_BLOCK_PTR_FOR_FN(cfun));
+		if (!single_pred_p(bb)) {
+//			gcc_assert(bb_loop_depth(bb) || (bb->flags & BB_IRREDUCIBLE_LOOP));
+			split_edge(single_succ_edge(ENTRY_BLOCK_PTR_FOR_FN(cfun)));
+			gcc_assert(single_succ_p(ENTRY_BLOCK_PTR_FOR_FN(cfun)));
+			bb = single_succ(ENTRY_BLOCK_PTR_FOR_FN(cfun));
+		}
+		gsi = gsi_after_labels(bb);
+		stackleak_add_instrumentation(&gsi, false);
+	}
+
+	return 0;
+}
+
+static unsigned int stackleak_final_execute(void)
+{
+	rtx_insn *insn, *next;
+
+	if (cfun->calls_alloca)
+		return 0;
+
+	// keep calls only if function frame is big enough
+	if (get_frame_size() >= track_frame_size)
+		return 0;
+
+	// 1. find pax_track_stack calls
+	for (insn = get_insns(); insn; insn = next) {
+		// rtl match: (call_insn 8 7 9 3 (call (mem (symbol_ref ("pax_track_stack") [flags 0x41] <function_decl 0xb7470e80 pax_track_stack>) [0 S1 A8]) (4)) -1 (nil) (nil))
+		rtx body;
+
+		next = NEXT_INSN(insn);
+		if (!CALL_P(insn))
+			continue;
+		body = PATTERN(insn);
+		if (GET_CODE(body) != CALL)
+			continue;
+		body = XEXP(body, 0);
+		if (GET_CODE(body) != MEM)
+			continue;
+		body = XEXP(body, 0);
+		if (GET_CODE(body) != SYMBOL_REF)
+			continue;
+//		if (strcmp(XSTR(body, 0), track_function))
+		if (SYMBOL_REF_DECL(body) != track_function_decl)
+			continue;
+//		warning(0, "track_frame_size: %d %ld %d", cfun->calls_alloca, get_frame_size(), track_frame_size);
+		// 2. delete call
+		delete_insn_and_edges(insn);
+#if BUILDING_GCC_VERSION >= 4007
+		if (GET_CODE(next) == NOTE && NOTE_KIND(next) == NOTE_INSN_CALL_ARG_LOCATION) {
+			insn = next;
+			next = NEXT_INSN(insn);
+			delete_insn_and_edges(insn);
+		}
+#endif
+	}
+
+//	print_simple_rtl(stderr, get_insns());
+//	print_rtl(stderr, get_insns());
+//	warning(0, "track_frame_size: %d %ld %d", cfun->calls_alloca, get_frame_size(), track_frame_size);
+
+	return 0;
+}
+
+static bool stackleak_track_stack_gate(void)
+{
+	tree section;
+
+	if (ix86_cmodel != CM_KERNEL)
+		return false;
+
+	section = lookup_attribute("section", DECL_ATTRIBUTES(current_function_decl));
+	if (section && TREE_VALUE(section)) {
+		section = TREE_VALUE(TREE_VALUE(section));
+
+		if (!strncmp(TREE_STRING_POINTER(section), ".init.text", 10))
+			return false;
+		if (!strncmp(TREE_STRING_POINTER(section), ".devinit.text", 13))
+			return false;
+		if (!strncmp(TREE_STRING_POINTER(section), ".cpuinit.text", 13))
+			return false;
+		if (!strncmp(TREE_STRING_POINTER(section), ".meminit.text", 13))
+			return false;
+	}
+
+	return track_frame_size >= 0;
+}
+
+static void stackleak_start_unit(void *gcc_data __unused, void *user_data __unused)
+{
+	tree fntype;
+
+	// void pax_track_stack(void)
+	fntype = build_function_type_list(void_type_node, NULL_TREE);
+	track_function_decl = build_fn_decl(track_function, fntype);
+	DECL_ASSEMBLER_NAME(track_function_decl); // for LTO
+	TREE_PUBLIC(track_function_decl) = 1;
+	TREE_USED(track_function_decl) = 1;
+	DECL_EXTERNAL(track_function_decl) = 1;
+	DECL_ARTIFICIAL(track_function_decl) = 1;
+	DECL_PRESERVE_P(track_function_decl) = 1;
+
+	// void pax_check_alloca(unsigned long)
+	fntype = build_function_type_list(void_type_node, long_unsigned_type_node, NULL_TREE);
+	check_function_decl = build_fn_decl(check_function, fntype);
+	DECL_ASSEMBLER_NAME(check_function_decl); // for LTO
+	TREE_PUBLIC(check_function_decl) = 1;
+	TREE_USED(check_function_decl) = 1;
+	DECL_EXTERNAL(check_function_decl) = 1;
+	DECL_ARTIFICIAL(check_function_decl) = 1;
+	DECL_PRESERVE_P(check_function_decl) = 1;
+}
+
+static bool stackleak_tree_instrument_gate(void)
+{
+	return stackleak_track_stack_gate();
+}
+
+#define PASS_NAME stackleak_tree_instrument
+#define PROPERTIES_REQUIRED PROP_gimple_leh | PROP_cfg
+#define TODO_FLAGS_START TODO_verify_ssa | TODO_verify_flow | TODO_verify_stmts
+#define TODO_FLAGS_FINISH TODO_verify_ssa | TODO_verify_stmts | TODO_dump_func | TODO_update_ssa | TODO_rebuild_cgraph_edges
+#include "gcc-generate-gimple-pass.h"
+
+static bool stackleak_final_gate(void)
+{
+	return stackleak_track_stack_gate();
+}
+
+#define PASS_NAME stackleak_final
+#define TODO_FLAGS_FINISH TODO_dump_func
+#include "gcc-generate-rtl-pass.h"
+
+__visible int plugin_init(struct plugin_name_args *plugin_info, struct plugin_gcc_version *version)
+{
+	const char * const plugin_name = plugin_info->base_name;
+	const int argc = plugin_info->argc;
+	const struct plugin_argument * const argv = plugin_info->argv;
+	int i;
+
+	static const struct ggc_root_tab gt_ggc_r_gt_stackleak[] = {
+		{
+			.base = &track_function_decl,
+			.nelt = 1,
+			.stride = sizeof(track_function_decl),
+			.cb = &gt_ggc_mx_tree_node,
+			.pchw = &gt_pch_nx_tree_node
+		},
+		{
+			.base = &check_function_decl,
+			.nelt = 1,
+			.stride = sizeof(check_function_decl),
+			.cb = &gt_ggc_mx_tree_node,
+			.pchw = &gt_pch_nx_tree_node
+		},
+		LAST_GGC_ROOT_TAB
+	};
+
+//	PASS_INFO(stackleak_tree_instrument, "tree_profile", 1, PASS_POS_INSERT_BEFORE);
+	PASS_INFO(stackleak_tree_instrument, "optimized", 1, PASS_POS_INSERT_BEFORE);
+	PASS_INFO(stackleak_final, "final", 1, PASS_POS_INSERT_BEFORE);
+
+	if (!plugin_default_version_check(version, &gcc_version)) {
+		error_gcc_version(version);
+		return 1;
+	}
+
+	register_callback(plugin_name, PLUGIN_INFO, NULL, &stackleak_plugin_info);
+
+	for (i = 0; i < argc; ++i) {
+		if (!strcmp(argv[i].key, "track-lowest-sp")) {
+			if (!argv[i].value) {
+				error(G_("no value supplied for option '-fplugin-arg-%s-%s'"), plugin_name, argv[i].key);
+				continue;
+			}
+			track_frame_size = atoi(argv[i].value);
+			if (argv[i].value[0] < '0' || argv[i].value[0] > '9' || track_frame_size < 0)
+				error(G_("invalid option argument '-fplugin-arg-%s-%s=%s'"), plugin_name, argv[i].key, argv[i].value);
+			continue;
+		}
+		if (!strcmp(argv[i].key, "initialize-locals")) {
+			if (argv[i].value) {
+				error(G_("invalid option argument '-fplugin-arg-%s-%s=%s'"), plugin_name, argv[i].key, argv[i].value);
+				continue;
+			}
+			init_locals = true;
+			continue;
+		}
+		error(G_("unknown option '-fplugin-arg-%s-%s'"), plugin_name, argv[i].key);
+	}
+
+	register_callback(plugin_name, PLUGIN_START_UNIT, &stackleak_start_unit, NULL);
+	register_callback(plugin_name, PLUGIN_REGISTER_GGC_ROOTS, NULL, (void *)&gt_ggc_r_gt_stackleak);
+	register_callback(plugin_name, PLUGIN_PASS_MANAGER_SETUP, NULL, &stackleak_tree_instrument_pass_info);
+	register_callback(plugin_name, PLUGIN_PASS_MANAGER_SETUP, NULL, &stackleak_final_pass_info);
+
+	return 0;
+}
-- 
2.9.3


--ty2472gdypsdn7ze--
