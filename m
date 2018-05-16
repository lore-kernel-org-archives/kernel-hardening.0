From: Alexander Popov <alex.popov@linux.com>
Subject: [PATCH v12 2/6] x86/entry: Add STACKLEAK erasing the kernel stack at the end of syscalls
Date: Wed, 16 May 2018 19:28:13 +0300
Message-Id: <1526488097-20611-3-git-send-email-alex.popov@linux.com>
In-Reply-To: <1526488097-20611-1-git-send-email-alex.popov@linux.com>
References: <1526488097-20611-1-git-send-email-alex.popov@linux.com>
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, x86@kernel.org, linux-kernel@vger.kernel.org, alex.popov@linux.com
List-ID: <kernel-hardening.lists.openwall.com>

The STACKLEAK feature erases the kernel stack before returning from
syscalls. That reduces the information which kernel stack leak bugs can
reveal and blocks some uninitialized stack variable attacks. Moreover,
STACKLEAK blocks kernel stack depth overflow caused by alloca (aka
Stack Clash attack).

This commit introduces the architecture-specific code filling the used
part of the kernel stack with a poison value before returning to the
userspace. Full STACKLEAK feature also contains the gcc plugin which
comes in a separate commit.

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
---
 Documentation/x86/x86_64/mm.txt  |  2 ++
 arch/Kconfig                     | 27 +++++++++++++++
 arch/x86/Kconfig                 |  1 +
 arch/x86/entry/calling.h         | 14 ++++++++
 arch/x86/entry/entry_32.S        |  7 ++++
 arch/x86/entry/entry_64.S        |  3 ++
 arch/x86/entry/entry_64_compat.S |  5 +++
 arch/x86/include/asm/processor.h |  3 ++
 arch/x86/kernel/process_32.c     |  5 +++
 arch/x86/kernel/process_64.c     |  5 +++
 include/linux/stackleak.h        | 19 +++++++++++
 kernel/Makefile                  |  4 +++
 kernel/stackleak.c               | 72 ++++++++++++++++++++++++++++++++++++++++
 13 files changed, 167 insertions(+)
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
index 8e0d665..a4d7794 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -401,6 +401,13 @@ config SECCOMP_FILTER
 
 	  See Documentation/prctl/seccomp_filter.txt for details.
 
+config HAVE_ARCH_STACKLEAK
+	bool
+	help
+	  An architecture should select this if it has the code which
+	  fills the used part of the kernel stack with the STACKLEAK_POISON
+	  value before returning from system calls.
+
 config HAVE_GCC_PLUGINS
 	bool
 	help
@@ -531,6 +538,26 @@ config GCC_PLUGIN_RANDSTRUCT_PERFORMANCE
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
+	  stack variable attacks. This option also blocks kernel stack depth
+	  overflow caused by alloca (aka Stack Clash attack).
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
 config HAVE_CC_STACKPROTECTOR
 	bool
 	help
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c07f492..74b8f5c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -121,6 +121,7 @@ config X86
 	select HAVE_ARCH_COMPAT_MMAP_BASES	if MMU && COMPAT
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
+	select HAVE_ARCH_STACKLEAK
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if X86_64
diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index 352e70c..43c79e7 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -329,8 +329,22 @@ For 32-bit we have the following conventions - kernel is built with
 
 #endif
 
+.macro ERASE_KSTACK_NOCLOBBER
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	PUSH_AND_CLEAR_REGS
+	call erase_kstack
+	POP_REGS
+#endif
+.endm
+
 #endif /* CONFIG_X86_64 */
 
+.macro ERASE_KSTACK
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	call erase_kstack
+#endif
+.endm
+
 /*
  * This does 'call enter_from_user_mode' unless we can avoid it based on
  * kernel config or using the static jump infrastructure.
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index bef8e2b..bb4f540 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -46,6 +46,8 @@
 #include <asm/frame.h>
 #include <asm/nospec-branch.h>
 
+#include "calling.h"
+
 	.section .entry.text, "ax"
 
 /*
@@ -298,6 +300,7 @@ ENTRY(ret_from_fork)
 	/* When we fork, we trace the syscall return in the child, too. */
 	movl    %esp, %eax
 	call    syscall_return_slowpath
+	ERASE_KSTACK
 	jmp     restore_all
 
 	/* kernel thread */
@@ -458,6 +461,8 @@ ENTRY(entry_SYSENTER_32)
 	ALTERNATIVE "testl %eax, %eax; jz .Lsyscall_32_done", \
 		    "jmp .Lsyscall_32_done", X86_FEATURE_XENPV
 
+	ERASE_KSTACK
+
 /* Opportunistic SYSEXIT */
 	TRACE_IRQS_ON			/* User mode traces as IRQs on. */
 	movl	PT_EIP(%esp), %edx	/* pt_regs->ip */
@@ -544,6 +549,8 @@ ENTRY(entry_INT80_32)
 	call	do_int80_syscall_32
 .Lsyscall_32_done:
 
+	ERASE_KSTACK
+
 restore_all:
 	TRACE_IRQS_IRET
 .Lrestore_all_notrace:
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 3166b96..c9648b2 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -329,6 +329,8 @@ syscall_return_via_sysret:
 	 * We are on the trampoline stack.  All regs except RDI are live.
 	 * We can do future final exit work right here.
 	 */
+	ERASE_KSTACK_NOCLOBBER
+
 	SWITCH_TO_USER_CR3_STACK scratch_reg=%rdi
 
 	popq	%rdi
@@ -687,6 +689,7 @@ GLOBAL(swapgs_restore_regs_and_return_to_usermode)
 	 * We are on the trampoline stack.  All regs except RDI are live.
 	 * We can do future final exit work right here.
 	 */
+	ERASE_KSTACK_NOCLOBBER
 
 	SWITCH_TO_USER_CR3_STACK scratch_reg=%rdi
 
diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
index 9de7f1e..2d10f72 100644
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -261,6 +261,11 @@ GLOBAL(entry_SYSCALL_compat_after_hwframe)
 
 	/* Opportunistic SYSRET */
 sysret32_from_system_call:
+	/*
+	 * We are not going to return to the userspace from the trampoline
+	 * stack. So let's erase the thread stack right now.
+	 */
+	ERASE_KSTACK
 	TRACE_IRQS_ON			/* User mode traces as IRQs on. */
 	movq	RBX(%rsp), %rbx		/* pt_regs->rbx */
 	movq	RBP(%rsp), %rbp		/* pt_regs->rbp */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 21a1149..7729996 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -32,6 +32,7 @@ struct vm86;
 #include <linux/err.h>
 #include <linux/irqflags.h>
 #include <linux/mem_encrypt.h>
+#include <linux/stackleak.h>
 
 /*
  * We handle most unaligned accesses in hardware.  On the other hand
@@ -504,6 +505,8 @@ struct thread_struct {
 
 	mm_segment_t		addr_limit;
 
+	struct lowest_stack	lowest_stack;
+
 	unsigned int		sig_on_uaccess_err:1;
 	unsigned int		uaccess_err:1;	/* uaccess failed */
 
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 5224c60..a19ea44 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -136,6 +136,11 @@ int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
 	p->thread.sp0 = (unsigned long) (childregs+1);
 	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	p->thread.lowest_stack.val = (unsigned long)end_of_stack(p) +
+						sizeof(unsigned long);
+#endif
+
 	if (unlikely(p->flags & PF_KTHREAD)) {
 		/* kernel thread */
 		memset(childregs, 0, sizeof(struct pt_regs));
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 4b100fe..f7412c6 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -295,6 +295,11 @@ int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
 	p->thread.sp = (unsigned long) fork_frame;
 	p->thread.io_bitmap_ptr = NULL;
 
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	p->thread.lowest_stack.val = (unsigned long)end_of_stack(p) +
+						sizeof(unsigned long);
+#endif
+
 	savesegment(gs, p->thread.gsindex);
 	p->thread.gsbase = p->thread.gsindex ? 0 : me->thread.gsbase;
 	savesegment(fs, p->thread.fsindex);
diff --git a/include/linux/stackleak.h b/include/linux/stackleak.h
new file mode 100644
index 0000000..458c73b
--- /dev/null
+++ b/include/linux/stackleak.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_STACKLEAK_H
+#define _LINUX_STACKLEAK_H
+
+/*
+ * Check that the poison value points to the unused hole in the
+ * virtual memory map for your platform.
+ */
+#define STACKLEAK_POISON -0xBEEF
+
+#define STACKLEAK_POISON_CHECK_DEPTH 128
+
+struct lowest_stack {
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+	unsigned long		val;
+#endif
+};
+
+#endif
diff --git a/kernel/Makefile b/kernel/Makefile
index f85ae5d..a530f77 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -114,6 +114,10 @@ obj-$(CONFIG_TORTURE_TEST) += torture.o
 
 obj-$(CONFIG_HAS_IOMEM) += memremap.o
 
+obj-$(CONFIG_GCC_PLUGIN_STACKLEAK) += stackleak.o
+KASAN_SANITIZE_stackleak.o := n
+KCOV_INSTRUMENT_stackleak.o := n
+
 $(obj)/configs.o: $(obj)/config_data.h
 
 targets += config_data.gz
diff --git a/kernel/stackleak.c b/kernel/stackleak.c
new file mode 100644
index 0000000..2ebfbaa
--- /dev/null
+++ b/kernel/stackleak.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This code fills the used part of the kernel stack with a poison value
+ * before returning to the userspace. It's a part of the STACKLEAK feature
+ * ported from grsecurity/PaX.
+ *
+ * Author: Alexander Popov <alex.popov@linux.com>
+ *
+ * STACKLEAK reduces the information which kernel stack leak bugs can
+ * reveal and blocks some uninitialized stack variable attacks. Moreover,
+ * STACKLEAK blocks stack depth overflow caused by alloca (aka Stack Clash
+ * attack).
+ */
+
+#include <linux/bug.h>
+#include <linux/sched.h>
+#include <linux/stackleak.h>
+#include <asm/linkage.h>
+
+asmlinkage void erase_kstack(void)
+{
+	/*
+	 * It would be nice not to have p and boundary on the stack.
+	 * Setting the register specifier for them is the best we can do.
+	 */
+	register unsigned long p = current->thread.lowest_stack.val;
+	register unsigned long boundary = p & ~(THREAD_SIZE - 1);
+	unsigned long poison = 0;
+	const unsigned long check_depth = STACKLEAK_POISON_CHECK_DEPTH /
+							sizeof(unsigned long);
+
+	/*
+	 * Let's search for the poison value in the stack.
+	 * Start from the lowest_stack and go to the bottom.
+	 */
+	while (p > boundary && poison <= check_depth) {
+		if (*(unsigned long *)p == STACKLEAK_POISON)
+			poison++;
+		else
+			poison = 0;
+
+		p -= sizeof(unsigned long);
+	}
+
+	/*
+	 * One long int at the bottom of the thread stack is reserved and
+	 * should not be poisoned (see CONFIG_SCHED_STACK_END_CHECK).
+	 */
+	if (p == boundary)
+		p += sizeof(unsigned long);
+
+	/*
+	 * So let's write the poison value to the kernel stack.
+	 * Start from the address in p and move up till the new boundary.
+	 * We assume that the stack pointer doesn't change when we write poison.
+	 */
+	if (on_thread_stack())
+		boundary = current_stack_pointer;
+	else
+		boundary = current_top_of_stack();
+
+	BUG_ON(boundary - p >= THREAD_SIZE);
+
+	while (p < boundary) {
+		*(unsigned long *)p = STACKLEAK_POISON;
+		p += sizeof(unsigned long);
+	}
+
+	/* Reset the lowest_stack value for the next syscall */
+	current->thread.lowest_stack.val = current_top_of_stack() - 256;
+}
+
-- 
2.7.4
