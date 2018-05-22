Subject: Re: [PATCH v12 2/6] x86/entry: Add STACKLEAK erasing the kernel stack
 at the end of syscalls
References: <1526488097-20611-1-git-send-email-alex.popov@linux.com>
 <1526488097-20611-3-git-send-email-alex.popov@linux.com>
 <20180518065349.GA10080@gmail.com>
 <23369d86-ad31-e7c5-e42f-28e0e51ec128@linux.com>
 <CAGXu5jKcZope_h1Hr2iAwzOe16A=sT-UXJF2ugg2w8rV0_i7jA@mail.gmail.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <b7afe9c1-1112-1605-e0a1-2cfd5c6d88ca@linux.com>
Date: Wed, 23 May 2018 00:00:13 +0300
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKcZope_h1Hr2iAwzOe16A=sT-UXJF2ugg2w8rV0_i7jA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 22.05.2018 20:20, Kees Cook wrote:
> On Tue, May 22, 2018 at 3:58 AM, Alexander Popov <alex.popov@linux.com> wrote:
>> Hello Ingo and Kees,
>>
>> On 18.05.2018 09:53, Ingo Molnar wrote:
>>> * Alexander Popov <alex.popov@linux.com> wrote:
>>>> --- a/arch/x86/kernel/process_32.c
>>>> +++ b/arch/x86/kernel/process_32.c
>>>> @@ -136,6 +136,11 @@ int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
>>>>      p->thread.sp0 = (unsigned long) (childregs+1);
>>>>      memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
>>>>
>>>> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>>>> +    p->thread.lowest_stack.val = (unsigned long)end_of_stack(p) +
>>>> +                                            sizeof(unsigned long);
>>>> +#endif
>>>
>>> This should use an inline helper:
>>>
>>>       stackleak_task_init(p);
>>
>> Right now I can't define such a helper because 'lowest_stack' is a part of
>> 'thread_struct', but arch/x86/include/asm/processor.h and include/linux/sched.h
>> are independent.
>>
>> I think the best solution is to move 'lowest_stack' variable to 'task_struct'.
> 
> It might be possible work around this by using a macro in stackleak.h
> (pardon any whitespace damage):
> 
> #ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> # define stackleak_task_init(task)     do {                      \
>                       task->thread.stack_leak.lowest_stack = \
>                                    (unsigned long)end_of_stack(task) + \
>                                    sizeof(unsigned long);                  \
>                } while (0)
> #else
> # define stackleak_task_init(task)   do { } while (0)
> #endif
> 
>> Is there any reason to fold this variable into a 'stackleak_info' structure? I
>> see everybody happily uses #ifdef in 'task_struct'.
> 
> I'd rather it stay in threadinfo, but I could be convinced otherwise.

Currently 'lowest_stack' is a part of 'thread_struct', which is a "CPU-specific
state of this task". But in fact 'lowest_stack' is not CPU-specific. If I move
it to 'task_struct', Laura will avoid redefining it in 'thread_struct' in
arch/arm64/include/asm/processor.h. And that will also allow me to create a
stackleak_task_init() inline helper in stackleak.h.

Best regards,
Alexander
