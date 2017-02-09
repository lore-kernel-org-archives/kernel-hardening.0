MIME-Version: 1.0
In-Reply-To: <20170209083825.GB10257@dhcp22.suse.cz>
References: <1486613040-30555-1-git-send-email-hoeun.ryu@gmail.com> <20170209083825.GB10257@dhcp22.suse.cz>
From: Hoeun Ryu <hoeun.ryu@gmail.com>
Date: Thu, 9 Feb 2017 22:36:04 +0900
Message-ID: <CABeRdtp3zK_vnG2TxkrKfJfgy1dykAYO=bC4wOfkEDono9c0oQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 1/2] fork: free vmapped stacks in cache when cpus are offline
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 9, 2017 at 5:38 PM, Michal Hocko <mhocko@kernel.org> wrote:
> On Thu 09-02-17 13:03:46, Hoeun Ryu wrote:
>>  Using virtually mapped stack, kernel stacks are allocated via vmalloc.
>> In the current implementation, two stacks per cpu can be cached when
>> tasks are freed and the cached stacks are used again in task duplications.
>> but the cached stacks may remain unfreed even when cpu are offline.
>>  By adding a cpu hotplug callback to free the cached stacks when a cpu
>> goes offline, the pages of the cached stacks are not wasted.
>>
>> Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
>> ---
>> Changes in v2:
>>  remove cpuhp callback for `starup`, only `teardown` callback is installed.
>>
>>  kernel/fork.c | 21 +++++++++++++++++++++
>>  1 file changed, 21 insertions(+)
>>
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> index 61284d8..7911ed2 100644
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -170,6 +170,22 @@ void __weak arch_release_thread_stack(unsigned long *stack)
>>  static DEFINE_PER_CPU(struct vm_struct *, cached_stacks[NR_CACHED_STACKS]);
>>  #endif
>>
>> +static int free_vm_stack_cache(unsigned int cpu)
>> +{
>> +     int i;
>> +
>> +     for (i = 0; i < NR_CACHED_STACKS; i++) {
>> +             struct vm_struct *vm_stack = this_cpu_read(cached_stacks[i]);
>
> the callbak will run on the given cpu so this_cpu_read will be in fact
> per_cpu_ptr(cached_stacks[i], cpu). Using this_cpu_read is just too
> confusing. Also you do want to make this function defined only for
> CONFIG_VMAP_STACK.
>

Sorry, Thank you for your correction. I will fix this.

>> +             if (!vm_stack)
>> +                     continue;
>> +
>> +             vfree(vm_stack->addr);
>> +             this_cpu_write(cached_stacks[i], NULL);
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>
> --
> Michal Hocko
> SUSE Labs
