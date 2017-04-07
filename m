MIME-Version: 1.0
In-Reply-To: <CALCETrVErxE5P=V4LD=kFCBtnp2YYEGRsbxhTG0SXJjrw6Yk1A@mail.gmail.com>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>
 <1490811363-93944-5-git-send-email-keescook@chromium.org> <CALCETrWkrpuJkcgiwMdc61Vv5U2u39FiWgzWfA_85nziK0pZsg@mail.gmail.com>
 <CAGXu5jKif5UUMBbQBpB7Ha7w0L+su8dSXDU3nbccO3EBnv7bTw@mail.gmail.com>
 <CALCETrW7nN8Ja=r9k4ANpekKovC_wsYrGrge1WNoGsAjZZvqHQ@mail.gmail.com>
 <CAGXu5jLENkemQiL6bcL5=qsesi-2M=1jYhS7SGBpBG64ER2CsA@mail.gmail.com> <CALCETrVErxE5P=V4LD=kFCBtnp2YYEGRsbxhTG0SXJjrw6Yk1A@mail.gmail.com>
From: Mathias Krause <minipli@googlemail.com>
Date: Fri, 7 Apr 2017 10:34:32 +0200
Message-ID: <CA+rthh95rW95woiWvyeCcoJT-qRM18KCDGHGtH=bDHZdExmVmg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [RFC v2][PATCH 04/11] x86: Implement __arch_rare_write_begin/unmap()
To: Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 6 April 2017 at 17:59, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, Apr 5, 2017 at 5:14 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Wed, Apr 5, 2017 at 4:57 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>> On Wed, Mar 29, 2017 at 6:41 PM, Kees Cook <keescook@chromium.org> wrote:
>>>> On Wed, Mar 29, 2017 at 3:38 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>>> On Wed, Mar 29, 2017 at 11:15 AM, Kees Cook <keescook@chromium.org> wrote:
>>>>>> Based on PaX's x86 pax_{open,close}_kernel() implementation, this
>>>>>> allows HAVE_ARCH_RARE_WRITE to work on x86.
>>>>>>
>>>>>> +
>>>>>> +static __always_inline unsigned long __arch_rare_write_begin(void)
>>>>>> +{
>>>>>> +       unsigned long cr0;
>>>>>> +
>>>>>> +       preempt_disable();
>>>>>
>>>>> This looks wrong.  DEBUG_LOCKS_WARN_ON(!irqs_disabled()) would work,
>>>>> as would local_irq_disable().  There's no way that just disabling
>>>>> preemption is enough.
>>>>>
>>>>> (Also, how does this interact with perf nmis?)
>>>>
>>>> Do you mean preempt_disable() isn't strong enough here? I'm open to
>>>> suggestions. The goal would be to make sure nothing between _begin and
>>>> _end would get executed without interruption...
>>>>
>>>
>>> Sorry for the very slow response.
>>>
>>> preempt_disable() isn't strong enough to prevent interrupts, and an
>>> interrupt here would run with WP off, causing unknown havoc.  I tend
>>> to think that the caller should be responsible for turning off
>>> interrupts.
>>
>> So, something like:
>>
>> Top-level functions:
>>
>> static __always_inline rare_write_begin(void)
>> {
>>     preempt_disable();
>>     local_irq_disable();
>>     barrier();
>>     __arch_rare_write_begin();
>>     barrier();
>> }
>
> Looks good, except you don't need preempt_disable().
> local_irq_disable() also disables preemption.  You might need to use
> local_irq_save(), though, depending on whether any callers already
> have IRQs off.

Well, doesn't look good to me. NMIs will still be able to interrupt
this code and will run with CR0.WP = 0.

Shouldn't you instead question yourself why PaX can do it "just" with
preempt_disable() instead?!

Cheers,
Mathias
