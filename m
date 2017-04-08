MIME-Version: 1.0
In-Reply-To: <CALCETrUk7k3SFKiu2kykwPM=AQ9q2rczetL4j5XyoOxX_gjCGw@mail.gmail.com>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>
 <1490811363-93944-5-git-send-email-keescook@chromium.org> <CALCETrWkrpuJkcgiwMdc61Vv5U2u39FiWgzWfA_85nziK0pZsg@mail.gmail.com>
 <CAGXu5jKif5UUMBbQBpB7Ha7w0L+su8dSXDU3nbccO3EBnv7bTw@mail.gmail.com>
 <CALCETrW7nN8Ja=r9k4ANpekKovC_wsYrGrge1WNoGsAjZZvqHQ@mail.gmail.com>
 <CAGXu5jLENkemQiL6bcL5=qsesi-2M=1jYhS7SGBpBG64ER2CsA@mail.gmail.com>
 <CALCETrVErxE5P=V4LD=kFCBtnp2YYEGRsbxhTG0SXJjrw6Yk1A@mail.gmail.com>
 <CA+rthh95rW95woiWvyeCcoJT-qRM18KCDGHGtH=bDHZdExmVmg@mail.gmail.com>
 <alpine.DEB.2.20.1704071048360.1716@nanos> <CA+rthh9-EJBBO6nYYY6noP0ybcvk+xJ+S5h6BCNPtidjMCv8VQ@mail.gmail.com>
 <alpine.DEB.2.20.1704071426300.1716@nanos> <CA+rthh8TbqU-4tY4Y8trnyMDBe6dRLhVrAnk-COJCZCOyHqSog@mail.gmail.com>
 <CALCETrWuZPDjAuE1jnhJNKiZOOEdbus-O6GY8++0UO56Q84PZw@mail.gmail.com>
 <CA+DvKQKc8uq=1O5d41GRU6u=GkOvuCJzkbPPBcp2ohHLU7A25g@mail.gmail.com> <CALCETrUk7k3SFKiu2kykwPM=AQ9q2rczetL4j5XyoOxX_gjCGw@mail.gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Sat, 8 Apr 2017 03:33:27 -0400
Message-ID: <CA+DvKQKQzMk==8Z4sF1pCeDDwE4+m_2Kgtztamaf2BWYm5ENUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [RFC v2][PATCH 04/11] x86: Implement __arch_rare_write_begin/unmap()
To: Andy Lutomirski <luto@kernel.org>
Cc: Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

> grsecurity and PaX are great projects.  They have a lot of good ideas,
> and they're put together quite nicely.  The upstream kernel should
> *not* do things differently from they way they are in grsecurity/PaX
> just because it wants to be different.  Conversely, the upstream
> kernel should not do things the same way as PaX just to be more like
> PaX.
>
> Keep in mind that the upstream kernel and grsecurity/PaX operate under
> different constraints.  The upstream kernel tries to keep itself clean
> and to make tree-wide updates rather that keeping compatibility stuff
> around.  PaX and grsecurity presumably want to retain some degree of
> simplicity when porting to newer upstream versions.
>
> In the context of virtually mapped stacks / KSTACKOVERFLOW, this
> naturally leads to different solutions.  The upstream kernel had a
> bunch of buggy drivers that played badly with virtually mapped stacks.
> grsecurity sensibly went for the approach where the buggy drivers kept
> working.  The upstream kernel went for the approach of fixing the
> drivers rather than keeping a compatibility workaround.  Different
> constraints, different solutions.

Sure, but nothing is currently landed right now and the PaX
implementation is a known quantity with a lot of testing. The
submitted code is aimed at rare writes to globals, but this feature is
more than that and design decisions shouldn't be based on just the
short term. Kees is sensibly landing features by submitting them a
little bit at a time, but a negative side effect of that is too much
focus on just the initial proposed usage.

As a downstream that's going to be making heavy use of mainline
security features as a base due to PaX and grsecurity becoming
commercial only private patches (*because* of upstream and the
companies involved), I hope things go in the right direction i.e. not
weaker/slower implementations than PaX. For example, while USERCOPY
isn't entirely landed upstream (missing slab whitelisting and user
offset/size), it's the base for the full feature and is going to get
more testing. On the other hand, refcount_t and the slab/page
sanitization work is 100% useless if you're willing to incorporate the
changes to do it without needless performance loss and complexity. PAN
emulation on 64-bit ARM was fresh ground while on ARMv7 a weaker
implementation was used for no better reason than clashing egos. The
upstream virtual mapped stacks will probably be perfectly good, but I
just find it to be such a waste of time and effort to reinvent it and
retread the same ground in terms of finding the bugs.

I actually care a lot more about 64-bit ARM support than I do x86, but
using a portable API for pax_open_kernel (for the simple uses at
least) is separate from choosing the underlying implementation. There
might not be a great way to do it on the architectures I care about
but that doesn't need to hinder x86. It's really not that much code...
A weaker/slower implementation for x86 also encourages the same
elsewhere.

> In the case of rare writes or pax_open_kernel [1] or whatever we want
> to call it, CR3 would work without arch-specific code, and CR0 would
> not.  That's an argument for CR3 that would need to be countered by
> something.  (Sure, avoiding leaks either way might need arch changes.
> OTOH, a *randomized* CR3-based approach might not have as much of a
> leak issue to begin with.)

By randomized do you mean just ASLR? Even if the window of opportunity
to exploit it is small, it's really not the same and this has a lot
more use than just rare writes to small global variables.

I wouldn't consider stack ASLR to be a replacement for making them
readable/writable only by the current thread either (required for
race-free return CFI on x86, at least without not using actual
returns).

> [1] Contrary to popular belief, I don't sit around reading grsecurity
> code or config options, so I really don't know what this thing is
> called.

Lots of the features aren't actually named. Maybe this could be
considered part of KERNEXEC but I don't think it is.
