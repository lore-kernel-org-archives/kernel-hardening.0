MIME-Version: 1.0
In-Reply-To: <A2A3D2E8-EAC9-441B-A2DF-C2500174E7BC@gmail.com>
References: <1486770080-25007-1-git-send-email-hoeun.ryu@gmail.com>
 <alpine.DEB.2.20.1702110928390.3734@nanos> <A2A3D2E8-EAC9-441B-A2DF-C2500174E7BC@gmail.com>
From: Hoeun Ryu <hoeun.ryu@gmail.com>
Date: Sat, 11 Feb 2017 21:34:16 +0900
Message-ID: <CABeRdtrX6HMspXbzGXpk10d_t5RHqKsrL2g+_YdkdA7BcQ2ZuA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4] fork: free vmapped stacks in cache when cpus are offline
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Feb 11, 2017 at 6:56 PM, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
>
>> On Feb 11, 2017, at 5:31 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>>> On Sat, 11 Feb 2017, Hoeun Ryu wrote:
>>> #define NR_CACHED_STACKS 2
>>> static DEFINE_PER_CPU(struct vm_struct *, cached_stacks[NR_CACHED_STACKS]);
>>> +
>>> +static int free_vm_stack_cache(unsigned int cpu)
>>> +{
>>> +    struct vm_struct **cached_vm_stacks = per_cpu_ptr(cached_stacks, cpu);
>>> +    int i;
>>> +
>>> +    for (i = 0; i < NR_CACHED_STACKS; i++) {
>>> +        struct vm_struct *vm_stack = cached_vm_stacks[i];
>>> +
>>> +        if (!vm_stack)
>>> +            continue;
>>> +
>>> +        vfree(vm_stack->addr);
>>> +        cached_vm_stacks[i] = NULL;
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> #endif
>>>
>>> static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
>>> @@ -456,6 +474,11 @@ void __init fork_init(void)
>>>    for (i = 0; i < UCOUNT_COUNTS; i++) {
>>>        init_user_ns.ucount_max[i] = max_threads/2;
>>>    }
>>> +
>>> +#ifdef CONFIG_VMAP_STACK
>>> +    cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "fork:vmstack_cache",
>>> +              NULL, free_vm_stack_cache);
>>> +#endif
>>
>> If you wrap that in vm_stack_cache_init() and have a stub for !VMAP_STACK
>> (add an #else to the #ifdef VMAP_STACK section above) then you spare the
>> ugly ifdef in fork_init()
>
> OK. I will.
>

I sent v5 patch having those stub, (Kbuild error anyway).
But, I didn't consider THREAD_SIZE >= PAGE_SIZE.
so the blank inlined version of vm_stack_cache_init() should be defined twice,
one for THREAD_SIZE < PAGE_SIZE && !CONFIG_VMAP_STACK, one for
!CONFIG_VMAP_STACK.
Do you really want this?

---

# if THREAD_SIZE >= PAGE_SIZE || defined(CONFIG_VMAP_STACK))
 # if CONFIG_VMAP_STACK
int free_vm_stack_cache()
{
    ...
}
int vm_stack_cache_init()
{
    cpuhp_setup_state(free_vm_stack_cache);
}
 #else // !CONFIG_VMAP_STACK
inline int vm_stack_cache_init() { return 0; }
 #endif
#else // THREAD_SIZE < PAGE_SIZE && !CONFIG_VMAP_STACK
...
...
inline int vm_stack_cache_init() { return 0; }
#endif

>> Thanks,
>>
>>    tglx
