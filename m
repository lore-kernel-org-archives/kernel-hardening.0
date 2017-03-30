MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CALCETrWkrpuJkcgiwMdc61Vv5U2u39FiWgzWfA_85nziK0pZsg@mail.gmail.com>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>
 <1490811363-93944-5-git-send-email-keescook@chromium.org> <CALCETrWkrpuJkcgiwMdc61Vv5U2u39FiWgzWfA_85nziK0pZsg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 29 Mar 2017 18:41:56 -0700
Message-ID: <CAGXu5jKif5UUMBbQBpB7Ha7w0L+su8dSXDU3nbccO3EBnv7bTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC v2][PATCH 04/11] x86: Implement __arch_rare_write_begin/unmap()
To: Andy Lutomirski <luto@amacapital.net>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 29, 2017 at 3:38 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, Mar 29, 2017 at 11:15 AM, Kees Cook <keescook@chromium.org> wrote:
>> Based on PaX's x86 pax_{open,close}_kernel() implementation, this
>> allows HAVE_ARCH_RARE_WRITE to work on x86.
>>
>
>> +
>> +static __always_inline unsigned long __arch_rare_write_begin(void)
>> +{
>> +       unsigned long cr0;
>> +
>> +       preempt_disable();
>
> This looks wrong.  DEBUG_LOCKS_WARN_ON(!irqs_disabled()) would work,
> as would local_irq_disable().  There's no way that just disabling
> preemption is enough.
>
> (Also, how does this interact with perf nmis?)

Do you mean preempt_disable() isn't strong enough here? I'm open to
suggestions. The goal would be to make sure nothing between _begin and
_end would get executed without interruption...

-Kees

-- 
Kees Cook
Pixel Security
