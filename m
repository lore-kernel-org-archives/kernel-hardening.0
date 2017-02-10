MIME-Version: 1.0
In-Reply-To: <20170210120524.GI10893@dhcp22.suse.cz>
References: <1486715554-12772-1-git-send-email-hoeun.ryu@gmail.com> <20170210120524.GI10893@dhcp22.suse.cz>
From: Hoeun Ryu <hoeun.ryu@gmail.com>
Date: Fri, 10 Feb 2017 23:31:41 +0900
Message-ID: <CABeRdtrqpmJtEnqawruAo-hW1yZG_wB6TGL95=knP0cBmDKZ+Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3] fork: free vmapped stacks in cache when cpus are offline
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 10, 2017 at 9:05 PM, Michal Hocko <mhocko@kernel.org> wrote:
> On Fri 10-02-17 17:32:07, Hoeun Ryu wrote:
> [...]
>> +static int free_vm_stack_cache(unsigned int cpu)
>> +{
>> +     struct vm_struct **cached_vm_stacks = per_cpu_ptr(cached_stacks, cpu);
>> +     int i;
>> +
>> +     for (i = 0; i < NR_CACHED_STACKS; i++) {
>> +             struct vm_struct **vm_stack = &cached_vm_stacks[i];
>> +
>> +             if (*vm_stack == NULL)
>> +                     continue;
>> +
>> +             vfree((*vm_stack)->addr);
>> +             *vm_stack = NULL;
>
> this seems more obscure than necessary. Probably a matter of taste but I
> would find the following easier to read
>                 struct vm_struct *vm_stack = cached_vm_stacks[i];
>
>                 if (!vm_stack)
>                         continue;
>
>                 vfree(vm_stack);
>                 cached_vm_stacks[i] = NULL;
>

OK, it's easier to read, I'll fix it.

>> +     }
>> +
>> +     return 0;
>> +}
>>  #endif
>>
>>  static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
>> @@ -456,6 +474,11 @@ void __init fork_init(void)
>>       for (i = 0; i < UCOUNT_COUNTS; i++) {
>>               init_user_ns.ucount_max[i] = max_threads/2;
>>       }
>> +
>> +#ifdef CONFIG_VMAP_STACK
>> +     cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "vm_stack_cache",
>> +                       NULL, free_vm_stack_cache);
>> +#endif
>
> I am not familiar the new hotplug infrastructure so I might be missing
> something. CPUHP_AP_ONLINE_DYN will allocate a state which is has only
> 30 slots available. The name also suggests this will be called on an
> online event. Why doesn't this have its own state like other users. The
> name should also reflect offline event CPUHP_STACK_CACHE_DEAD or
> something like that.

I'll define CPUHP_VMSTACK_CACHE_DEAD before CPUHP_BP_PREPARE_DYN in
cpuhotplug.h.
Do you think the change is made in a separate patch or not ?

Thank you for your review anyway.

>
> --
> Michal Hocko
> SUSE Labs
