MIME-Version: 1.0
In-Reply-To: <CA+DvKQKc8uq=1O5d41GRU6u=GkOvuCJzkbPPBcp2ohHLU7A25g@mail.gmail.com>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>
 <1490811363-93944-5-git-send-email-keescook@chromium.org> <CALCETrWkrpuJkcgiwMdc61Vv5U2u39FiWgzWfA_85nziK0pZsg@mail.gmail.com>
 <CAGXu5jKif5UUMBbQBpB7Ha7w0L+su8dSXDU3nbccO3EBnv7bTw@mail.gmail.com>
 <CALCETrW7nN8Ja=r9k4ANpekKovC_wsYrGrge1WNoGsAjZZvqHQ@mail.gmail.com>
 <CAGXu5jLENkemQiL6bcL5=qsesi-2M=1jYhS7SGBpBG64ER2CsA@mail.gmail.com>
 <CALCETrVErxE5P=V4LD=kFCBtnp2YYEGRsbxhTG0SXJjrw6Yk1A@mail.gmail.com>
 <CA+rthh95rW95woiWvyeCcoJT-qRM18KCDGHGtH=bDHZdExmVmg@mail.gmail.com>
 <alpine.DEB.2.20.1704071048360.1716@nanos> <CA+rthh9-EJBBO6nYYY6noP0ybcvk+xJ+S5h6BCNPtidjMCv8VQ@mail.gmail.com>
 <alpine.DEB.2.20.1704071426300.1716@nanos> <CA+rthh8TbqU-4tY4Y8trnyMDBe6dRLhVrAnk-COJCZCOyHqSog@mail.gmail.com>
 <CALCETrWuZPDjAuE1jnhJNKiZOOEdbus-O6GY8++0UO56Q84PZw@mail.gmail.com> <CA+DvKQKc8uq=1O5d41GRU6u=GkOvuCJzkbPPBcp2ohHLU7A25g@mail.gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Fri, 7 Apr 2017 22:07:20 -0700
Message-ID: <CALCETrUk7k3SFKiu2kykwPM=AQ9q2rczetL4j5XyoOxX_gjCGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [RFC v2][PATCH 04/11] x86: Implement __arch_rare_write_begin/unmap()
To: Daniel Micay <danielmicay@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 7, 2017 at 9:21 PM, Daniel Micay <danielmicay@gmail.com> wrote:
>>> Fair enough. However, placing a BUG_ON(!(read_cr0() & X86_CR0_WP))
>>> somewhere sensible should make those "leaks" visible fast -- and their
>>> exploitation impossible, i.e. fail hard.
>>
>> The leaks surely exist and now we'll just add an exploitable BUG.
>
> That didn't seem to matter for landing a rewrite of KSTACKOVERFLOW
> with a bunch of *known* DoS bugs dealt with in grsecurity and those
> were known issues that were unfixed for no apparent reason other than
> keeping egos intact. It looks like there are still some left...
>
> In that case, there also wasn't a security/performance advantage.

This is wildly off topic, but I think it's worth answering anyway
because there's an important point here:

grsecurity and PaX are great projects.  They have a lot of good ideas,
and they're put together quite nicely.  The upstream kernel should
*not* do things differently from they way they are in grsecurity/PaX
just because it wants to be different.  Conversely, the upstream
kernel should not do things the same way as PaX just to be more like
PaX.

Keep in mind that the upstream kernel and grsecurity/PaX operate under
different constraints.  The upstream kernel tries to keep itself clean
and to make tree-wide updates rather that keeping compatibility stuff
around.  PaX and grsecurity presumably want to retain some degree of
simplicity when porting to newer upstream versions.

In the context of virtually mapped stacks / KSTACKOVERFLOW, this
naturally leads to different solutions.  The upstream kernel had a
bunch of buggy drivers that played badly with virtually mapped stacks.
grsecurity sensibly went for the approach where the buggy drivers kept
working.  The upstream kernel went for the approach of fixing the
drivers rather than keeping a compatibility workaround.  Different
constraints, different solutions.

The point being that, if someone sends a patch to the x86 entry code
that's justified by "be like PaX" or by "be different than PaX",
that's not okay.  It needs a real justification that stands on its
own.

In the case of rare writes or pax_open_kernel [1] or whatever we want
to call it, CR3 would work without arch-specific code, and CR0 would
not.  That's an argument for CR3 that would need to be countered by
something.  (Sure, avoiding leaks either way might need arch changes.
OTOH, a *randomized* CR3-based approach might not have as much of a
leak issue to begin with.)

[1] Contrary to popular belief, I don't sit around reading grsecurity
code or config options, so I really don't know what this thing is
called.
