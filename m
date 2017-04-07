Date: Fri, 7 Apr 2017 22:44:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <CALCETrWuZPDjAuE1jnhJNKiZOOEdbus-O6GY8++0UO56Q84PZw@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1704072125460.1958@nanos>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org> <1490811363-93944-5-git-send-email-keescook@chromium.org> <CALCETrWkrpuJkcgiwMdc61Vv5U2u39FiWgzWfA_85nziK0pZsg@mail.gmail.com> <CAGXu5jKif5UUMBbQBpB7Ha7w0L+su8dSXDU3nbccO3EBnv7bTw@mail.gmail.com>
 <CALCETrW7nN8Ja=r9k4ANpekKovC_wsYrGrge1WNoGsAjZZvqHQ@mail.gmail.com> <CAGXu5jLENkemQiL6bcL5=qsesi-2M=1jYhS7SGBpBG64ER2CsA@mail.gmail.com> <CALCETrVErxE5P=V4LD=kFCBtnp2YYEGRsbxhTG0SXJjrw6Yk1A@mail.gmail.com> <CA+rthh95rW95woiWvyeCcoJT-qRM18KCDGHGtH=bDHZdExmVmg@mail.gmail.com>
 <alpine.DEB.2.20.1704071048360.1716@nanos> <CA+rthh9-EJBBO6nYYY6noP0ybcvk+xJ+S5h6BCNPtidjMCv8VQ@mail.gmail.com> <alpine.DEB.2.20.1704071426300.1716@nanos> <CA+rthh8TbqU-4tY4Y8trnyMDBe6dRLhVrAnk-COJCZCOyHqSog@mail.gmail.com>
 <CALCETrWuZPDjAuE1jnhJNKiZOOEdbus-O6GY8++0UO56Q84PZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: Re: [kernel-hardening] Re: [RFC v2][PATCH 04/11] x86: Implement
 __arch_rare_write_begin/unmap()
To: Andy Lutomirski <luto@kernel.org>
Cc: Mathias Krause <minipli@googlemail.com>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 7 Apr 2017, Andy Lutomirski wrote:
> On Fri, Apr 7, 2017 at 6:30 AM, Mathias Krause <minipli@googlemail.com> wrote:
> > On 7 April 2017 at 15:14, Thomas Gleixner <tglx@linutronix.de> wrote:
> >> I really do not care whether PaX wants to chase and verify that over and
> >> over. I certainly don't want to take the chance to leak CR0.WP ever and I
> >> very much care about extra stuff to check in the entry/exit path.
> >
> > Fair enough. However, placing a BUG_ON(!(read_cr0() & X86_CR0_WP))
> > somewhere sensible should make those "leaks" visible fast -- and their
> > exploitation impossible, i.e. fail hard.
> 
> The leaks surely exist and now we'll just add an exploitable BUG.

:)

> I think we're approaching this all wrong, actually.  The fact that x86
> has this CR0.WP thing is arguably a historical accident, and the fact
> that PaX uses it doesn't mean that PaX is doing it the best way for
> upstream Linux.

As I said before. It should be fused to 1.

> Why don't we start at the other end and do a generic non-arch-specific
> implementation: set up an mm_struct that contains an RW alias of the
> relevant parts of rodata and use use_mm to access it.  (That is,
> get_fs() to back up the old fs, set_fs(USER_DS),
> use_mm(&rare_write_mm), do the write using copy_to_user, undo
> everything.)

That works too, though I'm not sure that it's more efficient than
temporarily creating and undoing a single cpu local alias mapping similar
to the kmap_atomic mechanism in the highmem case.

Aside of that the alias mapping requires a full PGDIR entry unless you want
to get into the mess of keeping yet another identity mapping up to date.

Thanks,

	tglx
