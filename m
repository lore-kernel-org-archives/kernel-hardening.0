From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon syscall
Date: Fri, 29 Mar 2019 10:13:58 +0200
Message-Id: <20190329081358.30497-1-elena.reshetova@intel.com>
To: luto@kernel.org
Cc: kernel-hardening@lists.openwall.com, luto@amacapital.net, jpoimboe@redhat.com, keescook@chromium.org, jannh@google.com, enrico.perla@intel.com, mingo@redhat.com, bp@alien8.de, tglx@linutronix.de, peterz@infradead.org, gregkh@linuxfoundation.org, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

If CONFIG_RANDOMIZE_KSTACK_OFFSET is selected,
the kernel stack offset is randomized upon each
entry to a system call after fixed location of pt_regs
struct.

This feature is based on the original idea from
the PaX's RANDKSTACK feature:
https://pax.grsecurity.net/docs/randkstack.txt
All the credits for the original idea goes to the PaX team.
However, the design and implementation of
RANDOMIZE_KSTACK_OFFSET differs greatly from the RANDKSTACK
feature (see below).

Reasoning for the feature:

This feature aims to make considerably harder various
stack-based attacks that rely on deterministic stack
structure.
We have had many of such attacks in past [1],[2],[3]
(just to name few), and as Linux kernel stack protections
have been constantly improving (vmap-based stack
allocation with guard pages, removal of thread_info,
STACKLEAK), attackers have to find new ways for their
exploits to work.

It is important to note that we currently cannot show
a concrete attack that would be stopped by this new
feature (given that other existing stack protections
are enabled), so this is an attempt to be on a proactive
side vs. catching up with existing successful exploits.

The main idea is that since the stack offset is
randomized upon each system call, it is very hard for
attacker to reliably land in any particular place on
the thread stack when attack is performed.
Also, since randomization is performed *after* pt_regs,
the ptrace-based approach to discover randomization
offset during a long-running syscall should not be
possible.

[1] jon.oberheide.org/files/infiltrate12-thestackisback.pdf
[2] jon.oberheide.org/files/stackjacking-infiltrate11.pdf
[3] googleprojectzero.blogspot.com/2016/06/exploiting-
recursion-in-linux-kernel_20.html

Design description:

During most of the kernel's execution, it runs on the "thread
stack", which is allocated at fork.c/dup_task_struct() and stored in
a per-task variable (tsk->stack). Since stack is growing downward,
the stack top can be always calculated using task_top_of_stack(tsk)
function, which essentially returns an address of tsk->stack + stack
size. When VMAP_STACK is enabled, the thread stack is allocated from
vmalloc space.

Thread stack is pretty deterministic on its structure - fixed in size,
and upon every entry from a userspace to kernel on a
syscall the thread stack is started to be constructed from an
address fetched from a per-cpu cpu_current_top_of_stack variable.
The first element to be pushed to the thread stack is the pt_regs struct
that stores all required CPU registers and sys call parameters.

The goal of RANDOMIZE_KSTACK_OFFSET feature is to add a random offset
after the pt_regs has been pushed to the stack and the rest of thread
stack (used during the syscall processing) every time a process issues
a syscall. The source of randomness can be taken either from prandom_u32()
pseudo random generator (not cryptographically secure). The offset is
added using alloca() call since it helps avoiding changes in assembly
syscall entry code and unwinder. I am not that greatly happy about the
generated assembly code (but I don't know if how to force gcc to produce
anything better):

...
	size_t offset = ((size_t)prandom_u32()) % 256;
	char * ptr = alloca(offset);
0xffffffff8100426d add    $0x16,%rax
0xffffffff81004271 and    $0x1f8,%eax
0xffffffff81004276 sub    %rax,%rsp
0xffffffff81004279 lea    0xf(%rsp),%rax
0xffffffff8100427e and    $0xfffffffffffffff0,%rax
	asm volatile("":"=m"(*ptr));
...

As a result of the above gcc-produce code this patch introduces 6 bits
of randomness (bits 3 - 8 are randomized, bits 0-2 are zero due to stack alignment)
after pt_regs location on the thread stack.
The amount of randomness can be adjusted based on how much of the
stack space we wish/can trade for security.

Performance:

1) lmbench: ./lat_syscall -N 1000000 null
    base:                                        Simple syscall: 0.1774 microseconds
    random_offset (prandom_u32() every syscall): Simple syscall: 0.1822 microseconds

2)  Andy's tests, misc-tests: ./timing_test_64 10M sys_enosys
    base:                                        10000000 loops in 1.62224s = 162.22 nsec / loop
    random_offset (prandom_u32() every syscall): 10000000 loops in 1.64660s = 166.26 nsec / loop

Comparison to grsecurity RANDKSTACK feature:

RANDKSTACK feature randomizes the location of the stack start
(cpu_current_top_of_stack), i.e. location of pt_regs structure
itself on the stack. Initially this patch followed the same approach,
but during the recent discussions [4], it has been determined
to be of a little value since, if ptrace functionality is available
for an attacker, he can use PTRACE_PEEKUSR/PTRACE_POKEUSR api to read/write
different offsets in the pt_regs struct, observe the cache
behavior of the pt_regs accesses, and figure out the random stack offset.

Another big difference is that randomization is done upon
syscall entry and not the exit, as with RANDKSTACK.

Also, as a result of the above two differences, the implementation
of RANDKSTACK and RANDOMIZE_KSTACK_OFFSET has nothing in common.

[4] https://www.openwall.com/lists/kernel-hardening/2019/02/08/6

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/Kconfig            | 15 +++++++++++++++
 arch/x86/Kconfig        |  1 +
 arch/x86/entry/common.c | 16 ++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 4cfb6de48f79..9a2557b0cfce 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -808,6 +808,21 @@ config VMAP_STACK
 	  the stack to map directly to the KASAN shadow map using a formula
 	  that is incorrect if the stack is in vmalloc space.
 
+config HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
+	def_bool n
+	help
+	  An arch should select this symbol if it can support kernel stack
+	  offset randomization.
+
+config RANDOMIZE_KSTACK_OFFSET
+	default n
+	bool "Randomize kernel stack offset on syscall entry"
+	depends on HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
+	help
+	  Enable this if you want the randomize kernel stack offset upon
+	  each syscall entry. This causes kernel stack (after pt_regs) to
+	  have a randomized offset upon executing each system call.
+
 config ARCH_OPTIONAL_KERNEL_RWX
 	def_bool n
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ade12ec4224b..5edcae945b73 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -131,6 +131,7 @@ config X86
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if X86_64
 	select HAVE_ARCH_VMAP_STACK		if X86_64
+	select HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET  if X86_64
 	select HAVE_ARCH_WITHIN_STACK_FRAMES
 	select HAVE_CMPXCHG_DOUBLE
 	select HAVE_CMPXCHG_LOCAL
diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 7bc105f47d21..28cb3687bf82 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -32,6 +32,10 @@
 #include <linux/uaccess.h>
 #include <asm/cpufeature.h>
 
+#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
+#include <linux/random.h>
+#endif
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/syscalls.h>
 
@@ -269,10 +273,22 @@ __visible inline void syscall_return_slowpath(struct pt_regs *regs)
 }
 
 #ifdef CONFIG_X86_64
+
+#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
+void *alloca(size_t size);
+#endif
+
 __visible void do_syscall_64(unsigned long nr, struct pt_regs *regs)
 {
 	struct thread_info *ti;
 
+#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
+	size_t offset = ((size_t)prandom_u32()) % 256;
+	char *ptr = alloca(offset);
+
+	asm volatile("":"=m"(*ptr));
+#endif
+
 	enter_from_user_mode();
 	local_irq_enable();
 	ti = current_thread_info();
-- 
2.17.1
