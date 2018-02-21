MIME-Version: 1.0
In-Reply-To: <20180220163142.15366a82a7bece715b997597@linux-foundation.org>
References: <20180117055015.GA15256@beast> <20180220163142.15366a82a7bece715b997597@linux-foundation.org>
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 21 Feb 2018 01:56:33 +0000
Message-ID: <CALCETrVNBAWPAyrKKaiasehxDXKku3GSjc0+mQrvc4RC4+jUGw@mail.gmail.com>
Subject: Re: [PATCH] fork: Allow stack to be wiped on fork
Content-Type: text/plain; charset="UTF-8"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@kernel.org>, Laura Abbott <labbott@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, Sahara <keun-o.park@darkmatter.ae>, "Levin, Alexander (Sasha Levin)" <alexander.levin@verizon.com>, Michal Hocko <mhocko@suse.com>, Andrea Arcangeli <aarcange@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 21, 2018 at 12:31 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 16 Jan 2018 21:50:15 -0800 Kees Cook <keescook@chromium.org> wrote:
>
>> One of the classes of kernel stack content leaks is exposing the contents
>> of prior heap or stack contents when a new process stack is allocated.
>> Normally, those stacks are not zeroed, and the old contents remain in
>> place. With some types of stack content exposure flaws, those contents
>> can leak to userspace. Kernels built with CONFIG_CLEAR_STACK_FORK will
>> no longer be vulnerable to this, as the stack will be wiped each time
>> a stack is assigned to a new process. There's not a meaningful change
>> in runtime performance; it almost looks like it provides a benefit.
>>
>> Performing back-to-back kernel builds before:
>>       Run times: 157.86 157.09 158.90 160.94 160.80
>>       Mean: 159.12
>>       Std Dev: 1.54
>>
>> With CONFIG_CLEAR_STACK_FORK=y:
>>       Run times: 159.31 157.34 156.71 158.15 160.81
>>       Mean: 158.46
>>       Std Dev: 1.46
>>
>> ...
>>
>> --- a/arch/Kconfig
>> +++ b/arch/Kconfig
>> @@ -904,6 +904,14 @@ config VMAP_STACK
>>         the stack to map directly to the KASAN shadow map using a formula
>>         that is incorrect if the stack is in vmalloc space.
>>
>> +config CLEAR_STACK_FORK
>> +     bool "Clear the kernel stack at each fork"
>> +     help
>> +       To resist stack content leak flaws, this clears newly allocated
>> +       kernel stacks to keep previously freed heap or stack contents
>> +       from being present in the new stack. This has almost no
>> +       measurable performance impact.
>> +
>
> It would be much nicer to be able to control this at runtime rather
> than compile-time.  Why not a /proc tunable?  We could always use more
> of those ;)

/proc/sys/kernel/hardening_features_that_cost_essentially_nothing?

Seriously, though, why don't we just enable it unconditionally?  It
wouldn't surprise me if it really is a speedup on more workloads than
it slows down -- it'll fill the kernel stack into the CPU cache with
exclusive ownership very quickly (streamily and without actually
reading from memory, I imagine, at least on new enough CPUs) rather
than grabbing each cache line one by one as they get used.
