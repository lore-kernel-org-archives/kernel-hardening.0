References: <1508631773-2502-1-git-send-email-alex.popov@linux.com>
 <1508631773-2502-2-git-send-email-alex.popov@linux.com>
 <20171023131730.2r5imit2hzpxq2vg@docker>
 <59b5e578-cf68-4cc2-ebb7-c2fdf873b79d@linux.com>
 <CAGXu5jL2TTUs_LbjzVoVfP3YXsgCYcSXveo2dS9H-FiSdPVqMw@mail.gmail.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <32f20d8a-3318-0be1-44c4-1153001e9ad8@linux.com>
Date: Fri, 10 Nov 2017 19:59:34 +0300
MIME-Version: 1.0
In-Reply-To: <CAGXu5jL2TTUs_LbjzVoVfP3YXsgCYcSXveo2dS9H-FiSdPVqMw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH RFC v5 1/5] x86/entry: Add STACKLEAK erasing the kernel
 stack at the end of syscalls
To: Kees Cook <keescook@chromium.org>
Cc: Tycho Andersen <tycho@docker.com>, Andy Lutomirski <luto@kernel.org>, kernel-hardening@lists.openwall.com, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hello Kees,

On 31.10.2017 18:20, Kees Cook wrote:
> On Tue, Oct 24, 2017 at 2:30 PM, Alexander Popov <alex.popov@linux.com> wrote:
>> On 23.10.2017 16:17, Tycho Andersen wrote:
>>> On Sun, Oct 22, 2017 at 03:22:49AM +0300, Alexander Popov wrote:
>>>> The STACKLEAK feature erases the kernel stack before returning from
>>>> syscalls. That reduces the information which kernel stack leak bugs can
>>>> reveal and blocks some uninitialized stack variable attacks. Moreover,
>>>> STACKLEAK provides runtime checks for kernel stack overflow detection.
>>>>
>>>> This commit introduces the architecture-specific code filling the used
>>>> part of the kernel stack with a poison value before returning to the
>>>> userspace. Full STACKLEAK feature also contains the gcc plugin which
>>>> comes in a separate commit.
>>>>
>>>> The STACKLEAK feature is ported from grsecurity/PaX. More information at:
>>>>   https://grsecurity.net/
>>>>   https://pax.grsecurity.net/
>>>>
>>>> This code is modified from Brad Spengler/PaX Team's code in the last
>>>> public patch of grsecurity/PaX based on our understanding of the code.
>>>> Changes or omissions from the original code are ours and don't reflect
>>>> the original grsecurity/PaX code.
>>>>
>>>> Signed-off-by: Alexander Popov <alex.popov@linux.com>
>>>> ---
>>
>> [...]
>>
>>>> @@ -81,8 +87,10 @@ static long syscall_trace_enter(struct pt_regs *regs)
>>>>              emulated = true;
>>>>
>>>>      if ((emulated || (work & _TIF_SYSCALL_TRACE)) &&
>>>> -        tracehook_report_syscall_entry(regs))
>>>> +        tracehook_report_syscall_entry(regs)) {
>>>> +            erase_kstack();
>>>>              return -1L;
>>>> +    }
>>>>
>>>>      if (emulated)
>>>>              return -1L;
>>>> @@ -116,9 +124,11 @@ static long syscall_trace_enter(struct pt_regs *regs)
>>>>                      sd.args[5] = regs->bp;
>>>>              }
>>>>
>>>> -            ret = __secure_computing(&sd);
>>>> -            if (ret == -1)
>>>> +            ret = secure_computing(&sd);
>>>
>>> Is there any reason to switch this from the __ version? This basically
>>> adds an additional check on the TIF_SECCOMP flag, but I'm not sure
>>> that's intentional with this patch.
>>
>> Hello Tycho, thanks for your remark!
>>
>> Initially I took this change from the grsecurity patch, because it looked
>> reasonable for me at that time. But now I doubt, thank you.
> 
> Yeah, I'd prefer this stay __secure_computing().

Ok.

>> Kees and Andy (Lutomirski), you are the authors of syscall_trace_enter(). Could
>> you please have a look at this change?
>>
>> By the way, it seems that one erase_kstack() call is missing in that function.
>> Could you please have a glance at the places where erase_kstack() is called?
> 
> Errr, wouldn't erase_kstack() get called outside of seccomp? (i.e. via
> syscall_return_slowpath() or something later in the return path?)

Yes, erase_kstack() is called later in entry_SYSCALL_64 just after do_syscall_64.

> Or is there some reason for erasing the stack after seccomp processing
> but before running the syscall?

Ah, it seems that PaX Team is doing that intentionally. I guess I've found the
proof in his slides for H2HC conference (slide 38):
https://pax.grsecurity.net/docs/PaXTeam-H2HC13-PaX-gcc-plugins.pdf

"- Special paths for ptrace/auditing
-- Low-level kernel entry/exit paths can diverge for ptrace/auditing and leave
interesting information on the stack for the actual syscall code"

Do you know which kind of interesting information is mentioned?

And again, erase_kstack() is not called before 1 of 4 return statements in
syscall_trace_enter(). IMHO it is a bug. Could you please verify that? Thanks!

Best regards,
Alexander
