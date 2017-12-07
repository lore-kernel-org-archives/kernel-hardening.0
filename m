References: <1512516827-29797-1-git-send-email-alex.popov@linux.com>
 <1512516827-29797-6-git-send-email-alex.popov@linux.com>
 <f7c64050-bbb6-be37-ec09-cb757bad116a@redhat.com>
 <CAGXu5jKT2uCDxTCJLzoc6WhbSsT0xosnJBY9z+HAaJ_0-yRq6g@mail.gmail.com>
 <37807af6-1743-059c-614a-1328c0c880e4@redhat.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <0756b086-6ff8-b505-b638-4fd35d18250d@linux.com>
Date: Fri, 8 Dec 2017 01:58:24 +0300
MIME-Version: 1.0
In-Reply-To: <37807af6-1743-059c-614a-1328c0c880e4@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH RFC v6 5/6] fs/proc: Show STACKLEAK metrics in the /proc
 file system
To: Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 07.12.2017 02:06, Laura Abbott wrote:
> On 12/06/2017 12:40 PM, Kees Cook wrote:
>> On Wed, Dec 6, 2017 at 11:22 AM, Laura Abbott <labbott@redhat.com> wrote:
>>> On 12/05/2017 03:33 PM, Alexander Popov wrote:
>>>> diff --git a/fs/proc/base.c b/fs/proc/base.c
>>>> index 28fa852..3569446 100644
>>>> --- a/fs/proc/base.c
>>>> +++ b/fs/proc/base.c
>>>> @@ -2884,6 +2884,17 @@ static int proc_pid_patch_state(struct seq_file *m,
>>>> struct pid_namespace *ns,
>>>>    }
>>>>    #endif /* CONFIG_LIVEPATCH */
>>>>    +#ifdef CONFIG_STACKLEAK_METRICS
>>>> +static int proc_lowest_stack(struct seq_file *m, struct pid_namespace
>>>> *ns,
>>>> +                               struct pid *pid, struct task_struct *task)
>>>> +{
>>>> +       seq_printf(m, "prev_lowest_stack: %pK\nlowest_stack: %pK\n",
>>>> +                  (void *)task->thread.prev_lowest_stack,
>>>> +                  (void *)task->thread.lowest_stack);
>>>> +       return 0;
>>>> +}
>>>> +#endif /* CONFIG_STACKLEAK_METRICS */
>>>> +
>>>
>>> This just prints the hashed value with the new pointer leak work.
>>> I don't think we want to print the fprev_lowest_stackully exposed value via %px so
>>> it's not clear how valuable this proc file is now.
>>
>> Maybe print the size, not the location?

Yes, I think I can print: THREAD_SIZE - (addr & (THREAD_SIZE - 1)).
I can call it "stack_depth", do you like it?

N.B. this value is not a really precise stack depth, because:
 - we don't instrument all kernel functions, so a lot of them don't update the
lowest_stack value;
 - prev_lowest_stack is a final point of the poison search in erase_kstack(), it
is not an actual stack depth.

Or should I dwell on the current version and rely on non-zero kptr_restrict?

> Hmmmmm, that starts to overlap with CONFIG_DEBUG_STACK_USAGE.
> That's not a bad thing but it would be good to clarify what
> this is tracking vs. CONFIG_DEBUG_STACK_USAGE.

Thanks, Laura, I didn't know about CONFIG_DEBUG_STACK_USAGE. After testing it I
think that it should remain independent, because:
 - it works on sysrq;
 - it dumps information about all tasks in the system at once;
 - it provides precise information (in contrast to my metrics).

In addition, I guess, modifying sysrq output format might break the workflow of
users, who parse it (but I'm not sure).

Best regards,
Alexander
