MIME-Version: 1.0
In-Reply-To: <78a63405-6406-38d3-2a6c-3b7d6e2344cb@linux.com>
References: <20180717071223.GA29533@gmail.com> <1531999889-18343-1-git-send-email-alex.popov@linux.com>
 <CAGXu5jJxx-fGmHxZOc+qyKFNHH_hyCXkHfH=ECE+G3=tp8-9fQ@mail.gmail.com> <78a63405-6406-38d3-2a6c-3b7d6e2344cb@linux.com>
From: Kees Cook <keescook@google.com>
Date: Tue, 24 Jul 2018 16:59:32 -0700
Message-ID: <CAGXu5j+517NTGfwq42Y59UV0ZPLb+2p7uTyU3JDy7NEEeouW7g@mail.gmail.com>
Subject: Re: [PATCH v14 7/7] stackleak, sysctl: Allow runtime disabling of
 kernel stack erasing
Content-Type: text/plain; charset="UTF-8"
To: Alexander Popov <alex.popov@linux.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 24, 2018 at 4:41 PM, Alexander Popov <alex.popov@linux.com> wrote:
> On 25.07.2018 01:56, Kees Cook wrote:
>> On Thu, Jul 19, 2018 at 4:31 AM, Alexander Popov <alex.popov@linux.com> wrote:
>>> Introduce CONFIG_STACKLEAK_RUNTIME_DISABLE option, which provides
>>> 'stack_erasing_bypass' sysctl. It can be used in runtime to disable
>>> kernel stack erasing for kernels built with CONFIG_GCC_PLUGIN_STACKLEAK.
>>> Stack erasing will then remain disabled and STACKLEAK_METRICS will not
>>> be updated until the next boot.
>>>
>>> Signed-off-by: Alexander Popov <alex.popov@linux.com>
>>> [...]
>>> +That erasing reduces the information which kernel stack leak bugs
>>> +can reveal and blocks some uninitialized stack variable attacks.
>>> +The tradeoff is the performance impact: on a single CPU system kernel
>>> +compilation sees a 1% slowdown, other systems and workloads may vary.
>>
>> I continue to have a hard time measuring even the 1% impact. Clearly I
>> need some better workloads. :)
>>
>>> [...]
>>>  asmlinkage void stackleak_erase(void)
>>>  {
>>>         /* It would be nice not to have 'kstack_ptr' and 'boundary' on stack */
>>> @@ -22,6 +52,11 @@ asmlinkage void stackleak_erase(void)
>>>         unsigned int poison_count = 0;
>>>         const unsigned int depth = STACKLEAK_SEARCH_DEPTH / sizeof(unsigned long);
>>>
>>> +#ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
>>> +       if (static_branch_unlikely(&stack_erasing_bypass))
>>> +               return;
>>> +#endif
>>
>> I collapsed this into a macro (and took your other fix) and will push
>> this to my -next tree:
>>
>> +#define skip_erasing() static_branch_unlikely(&stack_erasing_bypass)
>> +#else
>> +#define skip_erasing() false
>> +#endif /* CONFIG_STACKLEAK_RUNTIME_DISABLE */
>> ...
>> +       if (skip_erasing())
>> +               return;
>> +
>
> That's nice! Thank you, I'll test it tomorrow.
>
>>> +
>>>         /* Search for the poison value in the kernel stack */
>>>         while (kstack_ptr > boundary && poison_count <= depth) {
>>>                 if (*(unsigned long *)kstack_ptr == STACKLEAK_POISON)
>>> @@ -78,6 +113,11 @@ void __used stackleak_track_stack(void)
>>>          */
>>>         unsigned long sp = (unsigned long)&sp;
>>>
>>> +#ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
>>> +       if (static_branch_unlikely(&stack_erasing_bypass))
>>> +               return;
>>> +#endif
>>
>> I would expect stackleak_erase() to be the expensive part, not the
>> tracking part? Shouldn't timings be unchanged by leaving this in
>> unconditionally, which would mean the sysctl could be re-enabled?
>
> Dropping the bypass in stackleak_track_stack() will not help against the
> troubles with re-enabling stack erasing (tracking and erasing depend on each

Isn't the tracking checking "sp < current->lowest_stack", so if
erasure was off, lowest_stack would only ever get further into the
stack? And when erasure was turned back on, it would start getting
reset correctly again. Or is the concern the poison searching could
break? It seems like it would still work right? I must be missing
something. :)

> other). Moreover, it will also make the STACKLEAK_METRICS show insane values. So
> I think we should have the bypass in both functions.

I left it as-is for now. It should appear in -next tomorrow.

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
