Date: Sat, 11 Feb 2017 09:31:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1486770080-25007-1-git-send-email-hoeun.ryu@gmail.com>
Message-ID: <alpine.DEB.2.20.1702110928390.3734@nanos>
References: <1486770080-25007-1-git-send-email-hoeun.ryu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v4] fork: free vmapped stacks in cache when cpus are
 offline
To: Hoeun Ryu <hoeun.ryu@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, 11 Feb 2017, Hoeun Ryu wrote:
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

If you wrap that in vm_stack_cache_init() and have a stub for !VMAP_STACK
(add an #else to the #ifdef VMAP_STACK section above) then you spare the
ugly ifdef in fork_init()

Thanks,

	tglx
