From: "PaX Team" <pageexec@freemail.hu>
Date: Fri, 07 Apr 2017 21:58:40 +0200
MIME-Version: 1.0
Message-ID: <58E7EF70.30766.621C4F44@pageexec.freemail.hu>
In-reply-to: <CALCETrWuZPDjAuE1jnhJNKiZOOEdbus-O6GY8++0UO56Q84PZw@mail.gmail.com>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>, <CA+rthh8TbqU-4tY4Y8trnyMDBe6dRLhVrAnk-COJCZCOyHqSog@mail.gmail.com>, <CALCETrWuZPDjAuE1jnhJNKiZOOEdbus-O6GY8++0UO56Q84PZw@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: Re: [kernel-hardening] Re: [RFC v2][PATCH 04/11] x86: Implement __arch_rare_write_begin/unmap()
To: Mathias Krause <minipli@googlemail.com>, Andy Lutomirski <luto@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 7 Apr 2017 at 9:14, Andy Lutomirski wrote:

> On Fri, Apr 7, 2017 at 6:30 AM, Mathias Krause <minipli@googlemail.com> wrote:
> > On 7 April 2017 at 15:14, Thomas Gleixner <tglx@linutronix.de> wrote:
> >> On Fri, 7 Apr 2017, Mathias Krause wrote:
> > Fair enough. However, placing a BUG_ON(!(read_cr0() & X86_CR0_WP))
> > somewhere sensible should make those "leaks" visible fast -- and their
> > exploitation impossible, i.e. fail hard.
> 
> The leaks surely exist and now we'll just add an exploitable BUG.

can you please share those leaks that 'surely exist' and CC oss-security
while at it?

> I think we're approaching this all wrong, actually.  The fact that x86
> has this CR0.WP thing is arguably a historical accident, and the fact
> that PaX uses it doesn't mean that PaX is doing it the best way for
> upstream Linux.
> 
> Why don't we start at the other end and do a generic non-arch-specific
> implementation: set up an mm_struct that contains an RW alias of the
> relevant parts of rodata and use use_mm to access it.  (That is,
> get_fs() to back up the old fs, set_fs(USER_DS),
> use_mm(&rare_write_mm), do the write using copy_to_user, undo
> everything.)
> 
> Then someone who cares about performance can benchmark the CR0.WP
> approach against it and try to argue that it's a good idea.  This
> benchmark should wait until I'm done with my PCID work, because PCID
> is going to make use_mm() a whole heck of a lot faster.

in my measurements switching PCID is hovers around 230 cycles for snb-ivb
and 200-220 for hsw-skl whereas cr0 writes are around 230-240 cycles. there's
of course a whole lot more impact for switching address spaces so it'll never
be fast enough to beat cr0.wp.
