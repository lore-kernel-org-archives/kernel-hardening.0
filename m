Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 11 Jul 2016 11:08:09 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160711100808.GB31221@leverpostej>
References: <cover.1466974736.git.luto@kernel.org>
 <aeea9c1c41e889065b2c9ecd6d0694e4dfb529c8.1466974736.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeea9c1c41e889065b2c9ecd6d0694e4dfb529c8.1466974736.git.luto@kernel.org>
Subject: Re: [kernel-hardening] [PATCH v4 26/29] sched: Allow putting
 thread_info into task_struct
To: kernel-hardening@lists.openwall.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Sun, Jun 26, 2016 at 02:55:48PM -0700, Andy Lutomirski wrote:
> If an arch opts in by setting CONFIG_THREAD_INFO_IN_TASK_STRUCT,
> then thread_info is defined as a single 'u32 flags' and is the first
> entry of task_struct.  thread_info::task is removed (it serves no
> purpose if thread_info is embedded in task_struct), and
> thread_info::cpu gets its own slot in task_struct.
> 
> This is heavily based on a patch written by Linus.

I've been considering how we'd implement this for arm64, and I suspect
that we'll also need to fold our preempt_count into task_struct
(following from the style of asm-generic/preempt.h).

As far as I can see, we can't make our preempt-count a percpu variable
as with x86, as our percpu ops themselves are based on disabling
preemption.

To that end, would it be possible to keep the thread_info definition per
arch, even with CONFIG_THREAD_INFO_IN_TASK?

Thanks,
Mark.

> 
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  include/linux/init_task.h   |  9 +++++++++
>  include/linux/sched.h       | 36 ++++++++++++++++++++++++++++++++++--
>  include/linux/thread_info.h | 15 +++++++++++++++
>  init/Kconfig                |  3 +++
>  init/init_task.c            |  7 +++++--
>  kernel/sched/sched.h        |  4 ++++
>  6 files changed, 70 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/init_task.h b/include/linux/init_task.h
> index f8834f820ec2..9c04d44eeb3c 100644
> --- a/include/linux/init_task.h
> +++ b/include/linux/init_task.h
> @@ -15,6 +15,8 @@
>  #include <net/net_namespace.h>
>  #include <linux/sched/rt.h>
>  
> +#include <asm/thread_info.h>
> +
>  #ifdef CONFIG_SMP
>  # define INIT_PUSHABLE_TASKS(tsk)					\
>  	.pushable_tasks = PLIST_NODE_INIT(tsk.pushable_tasks, MAX_PRIO),
> @@ -183,12 +185,19 @@ extern struct task_group root_task_group;
>  # define INIT_KASAN(tsk)
>  #endif
>  
> +#ifdef CONFIG_THREAD_INFO_IN_TASK
> +# define INIT_TASK_TI(tsk) .thread_info = INIT_THREAD_INFO(tsk),
> +#else
> +# define INIT_TASK_TI(tsk)
> +#endif
> +
>  /*
>   *  INIT_TASK is used to set up the first task table, touch at
>   * your own risk!. Base=0, limit=0x1fffff (=2MB)
>   */
>  #define INIT_TASK(tsk)	\
>  {									\
> +	INIT_TASK_TI(tsk)						\
>  	.state		= 0,						\
>  	.stack		= init_stack,					\
>  	.usage		= ATOMIC_INIT(2),				\
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 569df670407a..4108b4880b86 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1456,6 +1456,13 @@ struct tlbflush_unmap_batch {
>  };
>  
>  struct task_struct {
> +#ifdef CONFIG_THREAD_INFO_IN_TASK
> +	/*
> +	 * For reasons of header soup (see current_thread_info()), this
> +	 * must be the first element of task_struct.
> +	 */
> +	struct thread_info thread_info;
> +#endif
>  	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
>  	void *stack;
>  	atomic_t usage;
> @@ -1465,6 +1472,9 @@ struct task_struct {
>  #ifdef CONFIG_SMP
>  	struct llist_node wake_entry;
>  	int on_cpu;
> +#ifdef CONFIG_THREAD_INFO_IN_TASK
> +	unsigned int cpu;	/* current CPU */
> +#endif
>  	unsigned int wakee_flips;
>  	unsigned long wakee_flip_decay_ts;
>  	struct task_struct *last_wakee;
> @@ -2557,7 +2567,9 @@ extern void set_curr_task(int cpu, struct task_struct *p);
>  void yield(void);
>  
>  union thread_union {
> +#ifndef CONFIG_THREAD_INFO_IN_TASK
>  	struct thread_info thread_info;
> +#endif
>  	unsigned long stack[THREAD_SIZE/sizeof(long)];
>  };
>  
> @@ -3045,10 +3057,26 @@ static inline void threadgroup_change_end(struct task_struct *tsk)
>  	cgroup_threadgroup_change_end(tsk);
>  }
>  
> -#ifndef __HAVE_THREAD_FUNCTIONS
> +#ifdef CONFIG_THREAD_INFO_IN_TASK
> +
> +static inline struct thread_info *task_thread_info(struct task_struct *task)
> +{
> +	return &task->thread_info;
> +}
> +static inline void *task_stack_page(const struct task_struct *task)
> +{
> +	return task->stack;
> +}
> +#define setup_thread_stack(new,old)	do { } while(0)
> +static inline unsigned long *end_of_stack(const struct task_struct *task)
> +{
> +	return task->stack;
> +}
> +
> +#elif !defined(__HAVE_THREAD_FUNCTIONS)
>  
>  #define task_thread_info(task)	((struct thread_info *)(task)->stack)
> -#define task_stack_page(task)	((task)->stack)
> +#define task_stack_page(task)	((void *)(task)->stack)
>  
>  static inline void setup_thread_stack(struct task_struct *p, struct task_struct *org)
>  {
> @@ -3348,7 +3376,11 @@ static inline void ptrace_signal_wake_up(struct task_struct *t, bool resume)
>  
>  static inline unsigned int task_cpu(const struct task_struct *p)
>  {
> +#ifdef CONFIG_THREAD_INFO_IN_TASK
> +	return p->cpu;
> +#else
>  	return task_thread_info(p)->cpu;
> +#endif
>  }
>  
>  static inline int task_node(const struct task_struct *p)
> diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
> index 352b1542f5cc..b2b32d63bc8e 100644
> --- a/include/linux/thread_info.h
> +++ b/include/linux/thread_info.h
> @@ -13,6 +13,21 @@
>  struct timespec;
>  struct compat_timespec;
>  
> +#ifdef CONFIG_THREAD_INFO_IN_TASK
> +struct thread_info {
> +	u32			flags;		/* low level flags */
> +};
> +
> +#define INIT_THREAD_INFO(tsk)			\
> +{						\
> +	.flags		= 0,			\
> +}
> +#endif
> +
> +#ifdef CONFIG_THREAD_INFO_IN_TASK
> +#define current_thread_info() ((struct thread_info *)current)
> +#endif
> +
>  /*
>   * System call restart block.
>   */
> diff --git a/init/Kconfig b/init/Kconfig
> index f755a602d4a1..0c83af6d3753 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -26,6 +26,9 @@ config IRQ_WORK
>  config BUILDTIME_EXTABLE_SORT
>  	bool
>  
> +config THREAD_INFO_IN_TASK
> +	bool
> +
>  menu "General setup"
>  
>  config BROKEN
> diff --git a/init/init_task.c b/init/init_task.c
> index ba0a7f362d9e..11f83be1fa79 100644
> --- a/init/init_task.c
> +++ b/init/init_task.c
> @@ -22,5 +22,8 @@ EXPORT_SYMBOL(init_task);
>   * Initial thread structure. Alignment of this is handled by a special
>   * linker map entry.
>   */
> -union thread_union init_thread_union __init_task_data =
> -	{ INIT_THREAD_INFO(init_task) };
> +union thread_union init_thread_union __init_task_data = {
> +#ifndef CONFIG_THREAD_INFO_IN_TASK
> +	INIT_THREAD_INFO(init_task)
> +#endif
> +};
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 7cbeb92a1cb9..a1cabcea4c54 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -999,7 +999,11 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
>  	 * per-task data have been completed by this moment.
>  	 */
>  	smp_wmb();
> +#ifdef CONFIG_THREAD_INFO_IN_TASK
> +	p->cpu = cpu;
> +#else
>  	task_thread_info(p)->cpu = cpu;
> +#endif
>  	p->wake_cpu = cpu;
>  #endif
>  }
> -- 
> 2.7.4
> 
