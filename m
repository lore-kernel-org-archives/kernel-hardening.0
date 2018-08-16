From: Alexander Popov <alex.popov@linux.com>
Subject: [PATCH v15 1/7] x86/entry: Add STACKLEAK erasing the kernel stack at the end of syscalls
Date: Fri, 17 Aug 2018 01:16:58 +0300
Message-Id: <1534457824-7211-2-git-send-email-alex.popov@linux.com>
In-Reply-To: <1534457824-7211-1-git-send-email-alex.popov@linux.com>
References: <1534457824-7211-1-git-send-email-alex.popov@linux.com>
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, x86@kernel.org, linux-kernel@vger.kernel.org, alex.popov@linux.com
List-ID: <kernel-hardening.lists.openwall.com>

The STACKLEAK feature erases the kernel stack before returning from
syscalls. That reduces the information which kernel stack leak bugs can
reveal and blocks some uninitialized stack variable attacks.

This commit introduces the code filling the used part of the kernel
stack with a poison value before returning to userspace. Full
STACKLEAK feature also contains the gcc plugin which comes in a
separate commit.

The STACKLEAK feature is ported from grsecurity/PaX. More information at:
  https://grsecurity.net/
  https://pax.grsecurity.net/

This code is modified from Brad Spengler/PaX Team's code in the last
public patch of grsecurity/PaX based on our understanding of the code.
Changes or omissions from the original code are ours and don't reflect
the original grsecurity/PaX code.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/x86/x86_64/mm.txt  |  2 ++
 arch/Kconfig                     |  7 +++++
 arch/x86/Kconfig                 |  1 +
 arch/x86/entry/calling.h         | 14 +++++++++
 arch/x86/entry/entry_32.S        |  7 +++++
 arch/x86/entry/entry_64.S        |  3 ++
 arch/x86/entry/entry_64_compat.S |  5 ++++
 include/linux/sched.h            |  4 +++
 include/linux/stackleak.h        | 26 +++++++++++++++++
 kernel/Makefile                  |  4 +++
 kernel/fork.c                    |  3 ++
 kernel/stackleak.c               | 62 ++++++++++++++++++++++++++++++++++++++++
 scripts/gcc-plugins/Kconfig      | 19 ++++++++++++
 13 files changed, 157 insertions(+)
 create mode 100644 include/linux/stackleak.h
 create mode 100644 kernel/stackleak.c

diff --git a/Documentation/x86/x86_64/mm.txt b/Documentation/x86/x86_64/mm.txt
index 5432a96..600bc2a 100644
--- a/Documentation/x86/x86_64/mm.txt
+++ b/Documentation/x86/x86_64/mm.txt
@@ -24,6 +24,7 @@ ffffffffa0000000 - fffffffffeffffff (1520 MB) module mapping space
 [fixmap start]   - ffffffffff5fffff kernel-internal fixmap range
 ffffffffff600000 - ffffffffff600fff (=4 kB) legacy vsyscall ABI
 ffffffffffe00000 - ffffffffffffffff (=2 MB) unused hole
+STACKLEAK_POISON value in this last hole: ffffffffffff4111
 
 Virtual memory map with 5 level page tables:
 
@@ -50,6 +51,7 @@ ffffffffa0000000 - fffffffffeffffff (1520 MB) module mapping space
 [fixmap start]   - ffffffffff5fffff kernel-internal fixmap range
 ffffffffff600000 - ffffffffff600fff (=4 kB) legacy vsyscall ABI
 ffffffffffe00000 - ffffffffffffffff (=2 MB) unused hole
+STACKLEAK_POISON value in this last hole: ffffffffffff4111
 
 Architecture defines a 64-bit virtual address. Implementations can support
 less. Currently supported are 48- and 57-bit virtual addresses. Bits 63
diff --git a/arch/Kconfig b/arch/Kconfig
index c614816..c40293a 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -416,6 +416,13 @@ config SECCOMP_FILTER
 
 	  See Documentation/userspace-api/seccomp_filter.rst for details.
 
+config HAVE_ARCH_STACKLEAK
+	bool
+	help
+	  An architecture should select this if it has the code which
+	  fills the used part of the kernel stack with the STACKLEAK_POISON
+	  value before returning from system calls.
+
 config HAVE_STACKPROTECTOR
 	bool
 	help
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b0312f8..d033c0db 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -126,6 +126,7 @@ config X86
 	select HAVE_ARCH_COMPAT_MMAP_BASES	if MMU && COMPAT
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
+	select HAVE_ARCH_STACKLEAK
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if X86_64
diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index 352e70c..20d0885 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -329,8 +329,22 @@ For 32-bit we have the following conventions - kernel is built with
 
 #endif
 
+.macro STACKLEAK_ERASE_NOCLOBBER
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	PUSH_AND_CLEAR_REGS
+	call stackleak_erase
+	POP_REGS
+#endif
+.endm
+
 #endif /* CONFIG_X86_64 */
 
+.macro STACKLEAK_ERASE
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	call stackleak_erase
+#endif
+.endm
+
 /*
  * This does 'call enter_from_user_mode' unless we can avoid it based on
  * kernel config or using the static jump infrastructure.
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 2767c62..dfb975b 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -46,6 +46,8 @@
 #include <asm/frame.h>
 #include <asm/nospec-branch.h>
 
+#include "calling.h"
+
 	.section .entry.text, "ax"
 
 /*
@@ -711,6 +713,7 @@ ENTRY(ret_from_fork)
 	/* When we fork, we trace the syscall return in the child, too. */
 	movl    %esp, %eax
 	call    syscall_return_slowpath
+	STACKLEAK_ERASE
 	jmp     restore_all
 
 	/* kernel thread */
@@ -885,6 +888,8 @@ ENTRY(entry_SYSENTER_32)
 	ALTERNATIVE "testl %eax, %eax; jz .Lsyscall_32_done", \
 		    "jmp .Lsyscall_32_done", X86_FEATURE_XENPV
 
+	STACKLEAK_ERASE
+
 /* Opportunistic SYSEXIT */
 	TRACE_IRQS_ON			/* User mode traces as IRQs on. */
 
@@ -996,6 +1001,8 @@ ENTRY(entry_INT80_32)
 	call	do_int80_syscall_32
 .Lsyscall_32_done:
 
+	STACKLEAK_ERASE
+
 restore_all:
 	TRACE_IRQS_IRET
 	SWITCH_TO_ENTRY_STACK
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 957dfb6..a5dd280 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -329,6 +329,8 @@ syscall_return_via_sysret:
 	 * We are on the trampoline stack.  All regs except RDI are live.
 	 * We can do future final exit work right here.
 	 */
+	STACKLEAK_ERASE_NOCLOBBER
+
 	SWITCH_TO_USER_CR3_STACK scratch_reg=%rdi
 
 	popq	%rdi
@@ -688,6 +690,7 @@ GLOBAL(swapgs_restore_regs_and_return_to_usermode)
 	 * We are on the trampoline stack.  All regs except RDI are live.
 	 * We can do future final exit work right here.
 	 */
+	STACKLEAK_ERASE_NOCLOBBER
 
 	SWITCH_TO_USER_CR3_STACK scratch_reg=%rdi
 
diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
index 7d0df78..8eaf895 100644
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -261,6 +261,11 @@ GLOBAL(entry_SYSCALL_compat_after_hwframe)
 
 	/* Opportunistic SYSRET */
 sysret32_from_system_call:
+	/*
+	 * We are not going to return to userspace from the trampoline
+	 * stack. So let's erase the thread stack right now.
+	 */
+	STACKLEAK_ERASE
 	TRACE_IRQS_ON			/* User mode traces as IRQs on. */
 	movq	RBX(%rsp), %rbx		/* pt_regs->rbx */
 	movq	RBP(%rsp), %rbp		/* pt_regs->rbp */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 95a5018..bbf2f7a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1187,6 +1187,10 @@ struct task_struct {
 	void				*security;
 #endif
 
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	unsigned long			lowest_stack;
+#endif
+
 	/*
 	 * New fields for task_struct should be added above here, so that
 	 * they are included in the randomized portion of task_struct.
diff --git a/include/linux/stackleak.h b/include/linux/stackleak.h
new file mode 100644
index 0000000..628c2b9
--- /dev/null
+++ b/include/linux/stackleak.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_STACKLEAK_H
+#define _LINUX_STACKLEAK_H
+
+#include <linux/sched.h>
+#include <linux/sched/task_stack.h>
+
+/*
+ * Check that the poison value points to the unused hole in the
+ * virtual memory map for your platform.
+ */
+#define STACKLEAK_POISON -0xBEEF
+#define STACKLEAK_SEARCH_DEPTH 128
+
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+#include <asm/stacktrace.h>
+
+static inline void stackleak_task_init(struct task_struct *t)
+{
+	t->lowest_stack = (unsigned long)end_of_stack(t) + sizeof(unsigned long);
+}
+#else /* !CONFIG_GCC_PLUGIN_STACKLEAK */
+static inline void stackleak_task_init(struct task_struct *t) { }
+#endif
+
+#endif
diff --git a/kernel/Makefile b/kernel/Makefile
index 7a63d56..7343b3a 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -117,6 +117,10 @@ obj-$(CONFIG_HAS_IOMEM) += iomem.o
 obj-$(CONFIG_ZONE_DEVICE) += memremap.o
 obj-$(CONFIG_RSEQ) += rseq.o
 
+obj-$(CONFIG_GCC_PLUGIN_STACKLEAK) += stackleak.o
+KASAN_SANITIZE_stackleak.o := n
+KCOV_INSTRUMENT_stackleak.o := n
+
 $(obj)/configs.o: $(obj)/config_data.h
 
 targets += config_data.gz
diff --git a/kernel/fork.c b/kernel/fork.c
index 3311231..f54c495 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -91,6 +91,7 @@
 #include <linux/kcov.h>
 #include <linux/livepatch.h>
 #include <linux/thread_info.h>
+#include <linux/stackleak.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -1841,6 +1842,8 @@ static __latent_entropy struct task_struct *copy_process(
 	if (retval)
 		goto bad_fork_cleanup_io;
 
+	stackleak_task_init(p);
+
 	if (pid != &init_struct_pid) {
 		pid = alloc_pid(p->nsproxy->pid_ns_for_children);
 		if (IS_ERR(pid)) {
diff --git a/kernel/stackleak.c b/kernel/stackleak.c
new file mode 100644
index 0000000..deba0d8
--- /dev/null
+++ b/kernel/stackleak.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This code fills the used part of the kernel stack with a poison value
+ * before returning to userspace. It's part of the STACKLEAK feature
+ * ported from grsecurity/PaX.
+ *
+ * Author: Alexander Popov <alex.popov@linux.com>
+ *
+ * STACKLEAK reduces the information which kernel stack leak bugs can
+ * reveal and blocks some uninitialized stack variable attacks.
+ */
+
+#include <linux/stackleak.h>
+
+asmlinkage void stackleak_erase(void)
+{
+	/* It would be nice not to have 'kstack_ptr' and 'boundary' on stack */
+	unsigned long kstack_ptr = current->lowest_stack;
+	unsigned long boundary = (unsigned long)end_of_stack(current);
+	unsigned int poison_count = 0;
+	const unsigned int depth = STACKLEAK_SEARCH_DEPTH / sizeof(unsigned long);
+
+	/* Check that 'lowest_stack' value is sane */
+	if (unlikely(kstack_ptr - boundary >= THREAD_SIZE))
+		kstack_ptr = boundary;
+
+	/* Search for the poison value in the kernel stack */
+	while (kstack_ptr > boundary && poison_count <= depth) {
+		if (*(unsigned long *)kstack_ptr == STACKLEAK_POISON)
+			poison_count++;
+		else
+			poison_count = 0;
+
+		kstack_ptr -= sizeof(unsigned long);
+	}
+
+	/*
+	 * One 'long int' at the bottom of the thread stack is reserved and
+	 * should not be poisoned (see CONFIG_SCHED_STACK_END_CHECK=y).
+	 */
+	if (kstack_ptr == boundary)
+		kstack_ptr += sizeof(unsigned long);
+
+	/*
+	 * Now write the poison value to the kernel stack. Start from
+	 * 'kstack_ptr' and move up till the new 'boundary'. We assume that
+	 * the stack pointer doesn't change when we write poison.
+	 */
+	if (on_thread_stack())
+		boundary = current_stack_pointer;
+	else
+		boundary = current_top_of_stack();
+
+	while (kstack_ptr < boundary) {
+		*(unsigned long *)kstack_ptr = STACKLEAK_POISON;
+		kstack_ptr += sizeof(unsigned long);
+	}
+
+	/* Reset the 'lowest_stack' value for the next syscall */
+	current->lowest_stack = current_top_of_stack() - THREAD_SIZE/64;
+}
+
diff --git a/scripts/gcc-plugins/Kconfig b/scripts/gcc-plugins/Kconfig
index 7430a7c..0017d6d 100644
--- a/scripts/gcc-plugins/Kconfig
+++ b/scripts/gcc-plugins/Kconfig
@@ -139,4 +139,23 @@ config GCC_PLUGIN_RANDSTRUCT_PERFORMANCE
 	  in structures.  This reduces the performance hit of RANDSTRUCT
 	  at the cost of weakened randomization.
 
+config GCC_PLUGIN_STACKLEAK
+	bool "Erase the kernel stack before returning from syscalls"
+	depends on GCC_PLUGINS
+	depends on HAVE_ARCH_STACKLEAK
+	help
+	  This option makes the kernel erase the kernel stack before
+	  returning from system calls. That reduces the information which
+	  kernel stack leak bugs can reveal and blocks some uninitialized
+	  stack variable attacks.
+
+	  The tradeoff is the performance impact: on a single CPU system kernel
+	  compilation sees a 1% slowdown, other systems and workloads may vary
+	  and you are advised to test this feature on your expected workload
+	  before deploying it.
+
+	  This plugin was ported from grsecurity/PaX. More information at:
+	   * https://grsecurity.net/
+	   * https://pax.grsecurity.net/
+
 endif
-- 
2.7.4
