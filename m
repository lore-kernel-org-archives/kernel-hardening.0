MIME-Version: 1.0
In-Reply-To: <20170209042229.GA4311@zzz>
References: <1486613040-30555-1-git-send-email-hoeun.ryu@gmail.com> <20170209042229.GA4311@zzz>
From: Hoeun Ryu <hoeun.ryu@gmail.com>
Date: Thu, 9 Feb 2017 22:35:20 +0900
Message-ID: <CABeRdto2WcqyDWGCSi=DO-oTWY-zGdk6V9=4XciwxoEbOO501g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH v2 1/2] fork: free vmapped stacks in
 cache when cpus are offline
To: Eric Biggers <ebiggers3@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 9, 2017 at 1:22 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
> Hi Hoeun,
>
> On Thu, Feb 09, 2017 at 01:03:46PM +0900, Hoeun Ryu wrote:
>> +static int free_vm_stack_cache(unsigned int cpu)
>> +{
>> +     int i;
>> +
>> +     for (i = 0; i < NR_CACHED_STACKS; i++) {
>> +             struct vm_struct *vm_stack = this_cpu_read(cached_stacks[i]);
>> +             if (!vm_stack)
>> +                     continue;
>> +
>> +             vfree(vm_stack->addr);
>> +             this_cpu_write(cached_stacks[i], NULL);
>> +     }
>> +
>> +     return 0;
>> +}
>
> Doesn't this need to free the stacks for the 'cpu' that's passed in, instead of
> "this" CPU?
>

Sorry, Thank you for your correction. I will fix this.

> - Eric
