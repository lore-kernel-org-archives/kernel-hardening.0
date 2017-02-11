Date: Sat, 11 Feb 2017 07:34:45 +0100
From: Michal Hocko <mhocko@kernel.org>
Message-ID: <20170211063445.GB30713@dhcp22.suse.cz>
References: <1486770080-25007-1-git-send-email-hoeun.ryu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486770080-25007-1-git-send-email-hoeun.ryu@gmail.com>
Subject: [kernel-hardening] Re: [PATCH v4] fork: free vmapped stacks in cache when cpus are
 offline
To: Hoeun Ryu <hoeun.ryu@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat 11-02-17 08:40:38, Hoeun Ryu wrote:
>  Using virtually mapped stack, kernel stacks are allocated via vmalloc.
> In the current implementation, two stacks per cpu can be cached when
> tasks are freed and the cached stacks are used again in task duplications.
> but the cached stacks may remain unfreed even when cpu are offline.
>  By adding a cpu hotplug callback to free the cached stacks when a cpu
> goes offline, the pages of the cached stacks are not wasted.
> 
> Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
> v4:
>  use CPUHP_BP_PREPARE_DYN state for cpuhp setup
>  fix minor coding style
> v3:
>  fix misuse of per-cpu api
>  fix location of function definition within CONFIG_VMAP_STACK
> v2:
>  remove cpuhp callback for `startup`, only `teardown` callback is installed.
> 
>  kernel/fork.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 937ba59..61634d7 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -168,6 +168,24 @@ void __weak arch_release_thread_stack(unsigned long *stack)
>   */
>  #define NR_CACHED_STACKS 2
>  static DEFINE_PER_CPU(struct vm_struct *, cached_stacks[NR_CACHED_STACKS]);
> +
> +static int free_vm_stack_cache(unsigned int cpu)
> +{
> +	struct vm_struct **cached_vm_stacks = per_cpu_ptr(cached_stacks, cpu);
> +	int i;
> +
> +	for (i = 0; i < NR_CACHED_STACKS; i++) {
> +		struct vm_struct *vm_stack = cached_vm_stacks[i];
> +
> +		if (!vm_stack)
> +			continue;
> +
> +		vfree(vm_stack->addr);
> +		cached_vm_stacks[i] = NULL;
> +	}
> +
> +	return 0;
> +}
>  #endif
>  
>  static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
> @@ -456,6 +474,11 @@ void __init fork_init(void)
>  	for (i = 0; i < UCOUNT_COUNTS; i++) {
>  		init_user_ns.ucount_max[i] = max_threads/2;
>  	}
> +
> +#ifdef CONFIG_VMAP_STACK
> +	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "fork:vmstack_cache",
> +			  NULL, free_vm_stack_cache);
> +#endif
>  }
>  
>  int __weak arch_dup_task_struct(struct task_struct *dst,
> -- 
> 2.7.4
> 

-- 
Michal Hocko
SUSE Labs
