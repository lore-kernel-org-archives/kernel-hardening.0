MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1704071048360.1716@nanos>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>
 <1490811363-93944-5-git-send-email-keescook@chromium.org> <CALCETrWkrpuJkcgiwMdc61Vv5U2u39FiWgzWfA_85nziK0pZsg@mail.gmail.com>
 <CAGXu5jKif5UUMBbQBpB7Ha7w0L+su8dSXDU3nbccO3EBnv7bTw@mail.gmail.com>
 <CALCETrW7nN8Ja=r9k4ANpekKovC_wsYrGrge1WNoGsAjZZvqHQ@mail.gmail.com>
 <CAGXu5jLENkemQiL6bcL5=qsesi-2M=1jYhS7SGBpBG64ER2CsA@mail.gmail.com>
 <CALCETrVErxE5P=V4LD=kFCBtnp2YYEGRsbxhTG0SXJjrw6Yk1A@mail.gmail.com>
 <CA+rthh95rW95woiWvyeCcoJT-qRM18KCDGHGtH=bDHZdExmVmg@mail.gmail.com> <alpine.DEB.2.20.1704071048360.1716@nanos>
From: Mathias Krause <minipli@googlemail.com>
Date: Fri, 7 Apr 2017 12:51:15 +0200
Message-ID: <CA+rthh9-EJBBO6nYYY6noP0ybcvk+xJ+S5h6BCNPtidjMCv8VQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [RFC v2][PATCH 04/11] x86: Implement __arch_rare_write_begin/unmap()
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 7 April 2017 at 11:46, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 7 Apr 2017, Mathias Krause wrote:
>> On 6 April 2017 at 17:59, Andy Lutomirski <luto@amacapital.net> wrote:
>> > On Wed, Apr 5, 2017 at 5:14 PM, Kees Cook <keescook@chromium.org> wrote:
>> >> static __always_inline rare_write_begin(void)
>> >> {
>> >>     preempt_disable();
>> >>     local_irq_disable();
>> >>     barrier();
>> >>     __arch_rare_write_begin();
>> >>     barrier();
>> >> }
>> >
>> > Looks good, except you don't need preempt_disable().
>> > local_irq_disable() also disables preemption.  You might need to use
>> > local_irq_save(), though, depending on whether any callers already
>> > have IRQs off.
>>
>> Well, doesn't look good to me. NMIs will still be able to interrupt
>> this code and will run with CR0.WP = 0.
>>
>> Shouldn't you instead question yourself why PaX can do it "just" with
>> preempt_disable() instead?!
>
> That's silly. Just because PaX does it, doesn't mean it's correct. To be
> honest, playing games with the CR0.WP bit is outright stupid to begin with.

Why that? It allows fast and CPU local modifications of r/o memory.
OTOH, an approach that needs to fiddle with page table entries
requires global synchronization to keep the individual TLB states in
sync. Hmm.. Not that fast, I'd say.

> Whether protected by preempt_disable or local_irq_disable, to make that
> work it needs CR0 handling in the exception entry/exit at the lowest
> level. And that's just a nightmare maintainence wise as it's prone to be
> broken over time.

It seems to be working fine for more than a decade now in PaX. So it
can't be such a big maintenance nightmare ;)

>                    Aside of that it's pointless overhead for the normal case.

>
> The proper solution is:
>
> write_rare(ptr, val)
> {
>         mp = map_shadow_rw(ptr);
>         *mp = val;
>         unmap_shadow_rw(mp);
> }
>
> map_shadow_rw() is essentially the same thing as we do in the highmem case
> where the kernel creates a shadow mapping of the user space pages via
> kmap_atomic().

The "proper solution" seems to be much slower compared to just
toggling CR0.WP (which is costly in itself, already) because of the
TLB invalidation / synchronisation involved.

> It's valid (at least on x86) to have a shadow map with the same page
> attributes but write enabled. That does not require any fixups of CR0 and
> just works.

"Just works", sure -- but it's not as tightly focused as the PaX
solution which is CPU local, while your proposed solution is globally
visible.


Cheers,
Mathias
