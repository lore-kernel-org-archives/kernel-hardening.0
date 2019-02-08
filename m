From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon system call
Date: Fri,  8 Feb 2019 14:15:49 +0200
Message-Id: <1549628149-11881-2-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com>
References: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com>
To: kernel-hardening@lists.openwall.com
Cc: luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, peterz@infradead.org, keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

If CONFIG_RANDOMIZE_KSTACK_OFFSET is selected,
the kernel stack offset is randomized upon each
exit from a system call via the trampoline stack.

This feature is based on the original idea from
the PaX's RANDKSTACK feature:
https://pax.grsecurity.net/docs/randkstack.txt
All the credits for the original idea goes to the PaX team.
However, the implementation of RANDOMIZE_KSTACK_OFFSET
differs greatly from the RANDKSTACK feature (see below).

Reasoning for the feature:

This feature should make considerably harder various
stack-based attacks that are based upon overflowing
a kernel stack into adjusted kernel stack with a
possibility to jump over a guard page.
Since the stack offset is randomized upon each
system call, it is very hard for attacker to reliably
land in any particular place on the adjusted stack.

Design description:

During most of the kernel's execution, it runs on the "thread
stack", which is allocated at fork.c/dup_task_struct() and stored in
a per-task variable (tsk->stack). Since stack is growing downwards,
the stack top can be always calculated using task_top_of_stack(tsk)
function, which essentially returns an address of tsk->stack + stack
size. When VMAP_STACK is enabled, the thread stack is allocated from
vmalloc space.

Thread stack is pretty deterministic on its structure - fixed in size,
and upon every enter from a userspace to kernel on a
syscall the thread stack is started to be constructed from an
address fetched from a per-cpu cpu_current_top_of_stack variable.
This variable is required since there is no way to reference "current"
from the kernel entry/exit code, so the value of task_top_of_stack(tsk)
is "shadowed" in a per-cpu variable each time the kernel context
switches to a new task.

The RANDOMIZE_KSTACK_OFFSET feature works by randomizing the value of
task_top_of_stack(tsk) every time a process exits from a syscall. As
a result the thread stack for that process will be constructed from a
random offset from a fixed tsk->stack + stack size value upon subsequent
syscall.

Since the kernel is always exited (IRET / SYSRET) from a per-cpu
"trampoline stack", it provides a safe place for modifying the value
of cpu_current_top_of_stack, because the thread stack is not in
use anymore at that point.

There is only one small issue: currently thread stack top is never
stored in a per-task variable, but always calculated as needed
via task_top_of_stack(tsk) and existing tsk->stack value (essentially
relying on its fixed size and structure). So we need to create a new
per-task variable, tsk->stack_start, that stores newly calculated
random value for the thread stack top. Together with the value of
cpu_current_top_of_stack, tsk->stack_start is also updated when
leaving the kernel space from a trampoline stack, so that it can be
used by scheduler to correctly "shadow" the cpu_current_top_of_stack
upon the task switch.

Impact on the kernel thread stack size:

Since the current version does not allocate any additional pages
for the thread stack, it shifts cpu_current_top_of_stack value
randomly between 000 .. FF0 (or 00 .. F0 if only 4 bits are randomized).
So, in the worst case (random offsets FF0/F0), the actual usable stack
size is 12304/16144 bytes.

Performance impact:

All measurements are done on Intel Kaby Lake i7-8550U, 16GB RAM

1) hackbench -s 4096 -l 2000 -g 15 -f 25 -P
    base:           Time: 12.243
    random_offset:  Time: 13.411

2) kernel build time (as one example of real-world load):
    base:           user  299m20,348s;  sys   21m39,047s
    random_offset:  user  300m19,759s;  sys   20m48,173s

3) perf on fopen/flose loop 1000000000 times:
(the perf values below still manage to differ somewhat between
different runs, so I don't consider them to be very
representative apart that they obviously show big
impact on using get_random_u64())

    base:
     8.46%  time     [kernel.kallsyms]  [k] crc32c_pcl_intel_update
     4.77%  time     [kernel.kallsyms]  [k] ext4_mark_iloc_dirty
     4.14%  time     [kernel.kallsyms]  [k] fsnotify
     3.94%  time     [kernel.kallsyms]  [k] _raw_spin_lock
     2.48%  time     [kernel.kallsyms]  [k] syscall_return_via_sysret
     2.42%  time     [kernel.kallsyms]  [k] entry_SYSCALL_64
     2.28%  time     [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
     2.07%  time     [kernel.kallsyms]  [k] inotify_handle_event

    random_offset:
     8.35%  time     [kernel.kallsyms]  [k] crc32c_pcl_intel_update
     5.61%  time     [kernel.kallsyms]  [k] get_random_u64
     4.88%  time     [kernel.kallsyms]  [k] ext4_mark_iloc_dirty
     3.08%  time     [kernel.kallsyms]  [k] _raw_spin_lock
     2.98%  time     [kernel.kallsyms]  [k] fsnotify
     2.73%  time     [kernel.kallsyms]  [k] syscall_return_via_sysret
     2.45%  time     [kernel.kallsyms]  [k] entry_SYSCALL_64
     1.87%  time     [kernel.kallsyms]  [k] __ext4_get_inode_loc
     1.65%  time     [kernel.kallsyms]  [k] _raw_spin_lock_irqsave

Comparison to grsecurity RANDKSTACK feature:

The basic idea is taken from RANDKSTACK: randomization of the
cpu_current_top_of_stack is performed within the existing 4
pages of memory allocated for the thread stack.
No additional pages are allocated.

This patch introduces 8 bits of randomness (bits 4 - 11 are
randomized, bits 0-3 must be zero due to stack alignment)
to the kernel stack top.
The very old grsecurity patch I checked has only 4 bits
of randomization for x86-64. This patch works with this
little randomness also, we only have to decide how much
stack space we wish/can trade for security.

  Notable differences from RANDKSTACK:

  - x86_64 only, since this does not make sense
    without vmap-based stack allocation that provides
    guard pages, and latter is only implemented for x86-64.
  - randomization is performed on trampoline stack upon
    system call exit.
  - random bits are taken from get_random_long() instead of
    rdtsc() for a better randomness. This however has a big
    performance impact (see above the numbers) and additionally
    if we happen to hit a point when a generator needs to be
    reseeded, we might have an issue. Alternatives can be to
    make this feature dependent on CONFIG_RANDOM_TRUST_CPU,
    which can solve some issues, but I doubt that all of them.
    Of course rdtsc() can be a fallback if there is no way to
    make calls for a proper randomness from the trampoline stack.
  - instead of storing the actual top of the stack in
    task->thread.sp0 (does not exist on x86-64), a
    new unsigned long variable stack_start is created in
    the task struct and key stack functions, like task_pt_regs,
    are updated to use it when available.
  - Instead of preserving a set of registers that are
    used within the randomization function, the current
    version uses PUSH_AND_CLEAR_REGS/POP_REGS combination
    similar to STACKLEAK. It would seem that we can
    go away with only preserving rax,rdx,rbx,rsi and rdi,
    but I am not sure how stable this is in the long run.

Future work possibilities:

  - One can do a version where we allocate an
    additional page for each kernel stack and then employ
    proper randomization. Can be a stricter config option,
    for example.
  - Alternatively, one can allocate normally 4 pages of
    stack only and allocate an additional page, if stack
    + randomized offset grows beyond 4 pages (only happens
    for big call chains).

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/Kconfig                     | 15 +++++++++++++++
 arch/x86/Kconfig                 |  1 +
 arch/x86/entry/calling.h         |  8 ++++++++
 arch/x86/entry/common.c          | 21 +++++++++++++++++++++
 arch/x86/entry/entry_64.S        |  4 ++++
 arch/x86/include/asm/processor.h | 15 ++++++++++++---
 arch/x86/kernel/dumpstack.c      |  2 +-
 arch/x86/kernel/irq_64.c         |  2 +-
 arch/x86/kernel/process.c        |  2 +-
 include/linux/sched.h            |  3 +++
 include/linux/sched/task_stack.h | 18 +++++++++++++++++-
 kernel/fork.c                    | 10 ++++++++++
 mm/kmemleak.c                    |  2 +-
 mm/usercopy.c                    |  2 +-
 14 files changed, 96 insertions(+), 9 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index e1e540f..577186e 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -802,6 +802,21 @@ config VMAP_STACK
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
+	bool "Randomize kernel stack offset on syscall exit"
+	depends on HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET && VMAP_STACK
+	help
+	  Enable this if you want the randomize kernel stack offset upon
+	  each syscall exit. This causes kernel stack to have a randomized
+	  offset upon executing each system call.
+
 config ARCH_OPTIONAL_KERNEL_RWX
 	def_bool n
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8689e79..85d3849 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -134,6 +134,7 @@ config X86
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if X86_64
 	select HAVE_ARCH_VMAP_STACK		if X86_64
+	select HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET  if X86_64
 	select HAVE_ARCH_WITHIN_STACK_FRAMES
 	select HAVE_CMPXCHG_DOUBLE
 	select HAVE_CMPXCHG_LOCAL
diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index 25e5a6b..d644f72 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -337,6 +337,14 @@ For 32-bit we have the following conventions - kernel is built with
 #endif
 .endm
 
+.macro RANDOMIZE_KSTACK_NOCLOBBER
+#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
+	PUSH_AND_CLEAR_REGS
+	call randomize_kstack
+	POP_REGS
+#endif
+.endm
+
 #endif /* CONFIG_X86_64 */
 
 .macro STACKLEAK_ERASE
diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 3b2490b..0031887 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -23,6 +23,7 @@
 #include <linux/user-return-notifier.h>
 #include <linux/nospec.h>
 #include <linux/uprobes.h>
+#include <linux/random.h>
 #include <linux/livepatch.h>
 #include <linux/syscalls.h>
 
@@ -294,6 +295,26 @@ __visible void do_syscall_64(unsigned long nr, struct pt_regs *regs)
 }
 #endif
 
+#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
+__visible void randomize_kstack(void)
+{
+	unsigned long r_offset, new_top, stack_bottom;
+
+	if (current->stack_start != 0) {
+
+		r_offset = get_random_long();
+		r_offset &= 0xFFUL;
+		r_offset <<= 4;
+		stack_bottom = (unsigned long)task_stack_page(current);
+
+		new_top = stack_bottom + THREAD_SIZE - 0xFF0UL;
+		new_top += r_offset;
+		this_cpu_write(cpu_current_top_of_stack, new_top);
+		current->stack_start = new_top;
+	}
+}
+#endif
+
 #if defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION)
 /*
  * Does a 32-bit syscall.  Called with IRQs on in CONTEXT_KERNEL.  Does
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 1f0efdb..ae9d370 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -268,6 +268,8 @@ syscall_return_via_sysret:
 	 */
 	STACKLEAK_ERASE_NOCLOBBER
 
+	RANDOMIZE_KSTACK_NOCLOBBER
+
 	SWITCH_TO_USER_CR3_STACK scratch_reg=%rdi
 
 	popq	%rdi
@@ -630,6 +632,8 @@ GLOBAL(swapgs_restore_regs_and_return_to_usermode)
 	 */
 	STACKLEAK_ERASE_NOCLOBBER
 
+	RANDOMIZE_KSTACK_NOCLOBBER
+
 	SWITCH_TO_USER_CR3_STACK scratch_reg=%rdi
 
 	/* Restore RDI. */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 071b2a6..dad09f2 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -569,10 +569,15 @@ static inline unsigned long current_top_of_stack(void)
 
 static inline bool on_thread_stack(void)
 {
+	/* this might need adjustment to a more fine-grained comparison
+	 * we want a condition like
+	 * "< current_top_of_stack() - task_stack_page(current)"
+	 */
 	return (unsigned long)(current_top_of_stack() -
 			       current_stack_pointer) < THREAD_SIZE;
 }
 
+
 #ifdef CONFIG_PARAVIRT_XXL
 #include <asm/paravirt.h>
 #else
@@ -829,12 +834,16 @@ static inline void spin_lock_prefetch(const void *x)
 
 #define task_top_of_stack(task) ((unsigned long)(task_pt_regs(task) + 1))
 
+#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
+#define task_pt_regs(task) ((struct pt_regs *)(task_ptregs(task)))
+#else
 #define task_pt_regs(task) \
-({									\
+({                                 \
 	unsigned long __ptr = (unsigned long)task_stack_page(task);	\
-	__ptr += THREAD_SIZE - TOP_OF_KERNEL_STACK_PADDING;		\
-	((struct pt_regs *)__ptr) - 1;					\
+	__ptr += THREAD_SIZE - TOP_OF_KERNEL_STACK_PADDING;         \
+	((struct pt_regs *)__ptr) - 1;                              \
 })
+#endif
 
 #ifdef CONFIG_X86_32
 /*
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 2b58864..030ee15 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -33,7 +33,7 @@ bool in_task_stack(unsigned long *stack, struct task_struct *task,
 		   struct stack_info *info)
 {
 	unsigned long *begin = task_stack_page(task);
-	unsigned long *end   = task_stack_page(task) + THREAD_SIZE;
+	unsigned long *end   = (unsigned long *)task_top_of_stack(task);
 
 	if (stack < begin || stack >= end)
 		return false;
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 0469cd0..3f03b79 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -43,7 +43,7 @@ static inline void stack_overflow_check(struct pt_regs *regs)
 		return;
 
 	if (regs->sp >= curbase + sizeof(struct pt_regs) + STACK_TOP_MARGIN &&
-	    regs->sp <= curbase + THREAD_SIZE)
+	    regs->sp <= task_top_of_stack(current))
 		return;
 
 	irq_stack_top = (u64)this_cpu_ptr(irq_stack_union.irq_stack) +
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 7d31192..f30485a 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -819,7 +819,7 @@ unsigned long get_wchan(struct task_struct *p)
 	 * We need to read FP and IP, so we need to adjust the upper
 	 * bound by another unsigned long.
 	 */
-	top = start + THREAD_SIZE - TOP_OF_KERNEL_STACK_PADDING;
+	top = task_top_of_stack(p);
 	top -= 2 * sizeof(unsigned long);
 	bottom = start;
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 291a9bd..8e748e4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -605,6 +605,9 @@ struct task_struct {
 	randomized_struct_fields_start
 
 	void				*stack;
+#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
+	unsigned long		stack_start;
+#endif
 	atomic_t			usage;
 	/* Per task flags (PF_*), defined further below: */
 	unsigned int			flags;
diff --git a/include/linux/sched/task_stack.h b/include/linux/sched/task_stack.h
index 6a84192..229c434 100644
--- a/include/linux/sched/task_stack.h
+++ b/include/linux/sched/task_stack.h
@@ -21,6 +21,22 @@ static inline void *task_stack_page(const struct task_struct *task)
 	return task->stack;
 }
 
+#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
+static inline void *task_ptregs(const struct task_struct *task)
+{
+	unsigned long __ptr;
+
+	if (task->stack_start == 0) {
+		__ptr = (unsigned long)task_stack_page(task);
+		__ptr += THREAD_SIZE - TOP_OF_KERNEL_STACK_PADDING;
+		return ((struct pt_regs *)__ptr) - 1;
+	}
+
+	__ptr = task->stack_start;
+	return ((struct pt_regs *)__ptr) - 1;
+}
+#endif
+
 #define setup_thread_stack(new,old)	do { } while(0)
 
 static inline unsigned long *end_of_stack(const struct task_struct *task)
@@ -82,7 +98,7 @@ static inline int object_is_on_stack(const void *obj)
 {
 	void *stack = task_stack_page(current);
 
-	return (obj >= stack) && (obj < (stack + THREAD_SIZE));
+	return (obj >= stack) && (obj < ((void *)task_top_of_stack(current)));
 }
 
 extern void thread_stack_cache_init(void);
diff --git a/kernel/fork.c b/kernel/fork.c
index 07cddff..8eccf94 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -422,6 +422,9 @@ static void release_task_stack(struct task_struct *tsk)
 	tsk->stack = NULL;
 #ifdef CONFIG_VMAP_STACK
 	tsk->stack_vm_area = NULL;
+#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
+	tsk->stack_start = 0;
+#endif
 #endif
 }
 
@@ -863,6 +866,10 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 	tsk->stack = stack;
 #ifdef CONFIG_VMAP_STACK
 	tsk->stack_vm_area = stack_vm_area;
+#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
+	tsk->stack_start = 0;
+	tsk->stack_start = (unsigned long)task_top_of_stack(tsk);
+#endif
 #endif
 #ifdef CONFIG_THREAD_INFO_IN_TASK
 	atomic_set(&tsk->stack_refcount, 1);
@@ -922,6 +929,9 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 
 free_stack:
 	free_thread_stack(tsk);
+#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
+	tsk->stack_start = 0;
+#endif
 free_tsk:
 	free_task_struct(tsk);
 	return NULL;
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 877de4f..e52c76f 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1572,7 +1572,7 @@ static void kmemleak_scan(void)
 		do_each_thread(g, p) {
 			void *stack = try_get_task_stack(p);
 			if (stack) {
-				scan_block(stack, stack + THREAD_SIZE, NULL);
+				scan_block(stack, task_top_of_stack(p), NULL);
 				put_task_stack(p);
 			}
 		} while_each_thread(g, p);
diff --git a/mm/usercopy.c b/mm/usercopy.c
index 852eb4e..4b07542 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -37,7 +37,7 @@
 static noinline int check_stack_object(const void *obj, unsigned long len)
 {
 	const void * const stack = task_stack_page(current);
-	const void * const stackend = stack + THREAD_SIZE;
+	const void * const stackend = (void *)task_top_of_stack(current);
 	int ret;
 
 	/* Object is not on the stack at all. */
-- 
2.7.4
