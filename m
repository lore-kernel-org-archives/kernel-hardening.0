MIME-Version: 1.0
In-Reply-To: <20170209084005.GC10257@dhcp22.suse.cz>
References: <1486613040-30555-1-git-send-email-hoeun.ryu@gmail.com>
 <1486613040-30555-2-git-send-email-hoeun.ryu@gmail.com> <20170209084005.GC10257@dhcp22.suse.cz>
From: Hoeun Ryu <hoeun.ryu@gmail.com>
Date: Thu, 9 Feb 2017 22:36:56 +0900
Message-ID: <CABeRdto3viSm7EZbWOCXkxdsjpp-ahpAaL3G3ZRaEVBN5hXc8A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 2/2] fork: make number of cached stacks (vmapped)
 configurable using Kbuild
To: Michal Hocko <mhocko@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Michal Marek <mmarek@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Emese Revfy <re.emese@gmail.com>, Ingo Molnar <mingo@kernel.org>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, Nicholas Piggin <npiggin@gmail.com>, Andy Lutomirski <luto@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 9, 2017 at 5:40 PM, Michal Hocko <mhocko@kernel.org> wrote:
> On Thu 09-02-17 13:03:47, Hoeun Ryu wrote:
>> Introducing NR_VMAP_STACK_CACHE, the number of cached stacks for virtually
>> mapped kernel stack can be configurable using Kbuild system.
>> default value is 2.
>
> This should really explain _why_ we want/need this. The config space is
> really large already and there should better be a good reason to make it
> even larger. Which workload will benefit from a different than default
> cache size and why?
>
> Without a really good reasons NACK from me.
>

OK, I understand your NACK. Thank you.

>> Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
>> ---
>>  arch/Kconfig  | 8 ++++++++
>>  kernel/fork.c | 2 +-
>>  2 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/Kconfig b/arch/Kconfig
>> index d49a8e6..066d111 100644
>> --- a/arch/Kconfig
>> +++ b/arch/Kconfig
>> @@ -849,6 +849,14 @@ config VMAP_STACK
>>         the stack to map directly to the KASAN shadow map using a formula
>>         that is incorrect if the stack is in vmalloc space.
>>
>> +config NR_VMAP_STACK_CACHE
>> +     int "Number of cached stacks"
>> +     default "2"
>> +     depends on VMAP_STACK
>> +     help
>> +       This determines how many stacks can be cached for virtually
>> +       mapped kernel stacks.
>> +
>>  config ARCH_WANT_RELAX_ORDER
>>       bool
>>
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> index 7911ed2..73ba1da 100644
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -166,7 +166,7 @@ void __weak arch_release_thread_stack(unsigned long *stack)
>>   * vmalloc() is a bit slow, and calling vfree() enough times will force a TLB
>>   * flush.  Try to minimize the number of calls by caching stacks.
>>   */
>> -#define NR_CACHED_STACKS 2
>> +#define NR_CACHED_STACKS CONFIG_NR_VMAP_STACK_CACHE
>>  static DEFINE_PER_CPU(struct vm_struct *, cached_stacks[NR_CACHED_STACKS]);
>>  #endif
>>
>> --
>> 2.7.4
>>
>
> --
> Michal Hocko
> SUSE Labs
