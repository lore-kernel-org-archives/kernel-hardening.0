Date: Tue, 7 Feb 2017 13:36:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170207123630.GR6515@twins.programming.kicks-ass.net>
References: <1486164412-7338-1-git-send-email-keescook@chromium.org>
 <1486164412-7338-5-git-send-email-keescook@chromium.org>
 <20170205154046.GF6515@twins.programming.kicks-ass.net>
 <CAGXu5jLvpq6B80aN44JCOfHrov5LKX1_9r4aWb7LNM7pAW_SEQ@mail.gmail.com>
 <20170206085739.GH6515@twins.programming.kicks-ass.net>
 <CAGXu5j+VrKBrU7op8wD1Ry4nzR0cN7Vvke8W6_KOzp3wsoEF1g@mail.gmail.com>
 <20170207083405.GV6500@twins.programming.kicks-ass.net>
 <20170207111011.GB28790@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170207111011.GB28790@leverpostej>
Subject: Re: [kernel-hardening] Re: [PATCH 4/4] refcount: Report failures
 through CHECK_DATA_CORRUPTION
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <h.peter.anvin@intel.com>, Will Deacon <will.deacon@arm.com>, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 07, 2017 at 11:10:12AM +0000, Mark Rutland wrote:
> On Tue, Feb 07, 2017 at 09:34:05AM +0100, Peter Zijlstra wrote:
> > On Mon, Feb 06, 2017 at 08:54:38AM -0800, Kees Cook wrote:
> > > >
> > > > Like I wrote, ideally we'd end up using something like the x86 exception
> > > > table with a custom handler. Just no idea how to pull that off without
> > > > doing a full blown arch specific implementation, so I didn't go there
> > > > quite yet.
> > > 
> > > I haven't spent much time looking at the extable stuff. (Though
> > > coincidentally, I was poking at it for x86's test_nx stuff...) I
> > > thought there was a way to build arch-agnostic extables already?
> > > kernel/extable.c is unconditionally built-in, for example.
> > 
> > That doesn't seem to be of much use. It only contains section sort and
> > search functions.
> > 
> > Another problem for generic code would be to figure out what register
> > the relevant variable would live in at the time of exception. Here its
> > 'obviously' EAX because that's what cmpxchg requires, but in generic
> > you'd need a means of querying GCC's register allocator at the exception
> > point and somehow using that information for the generation of the
> > exception handler.
> 
> I think we only need two arch-specific primitives:
> (a) mangle a GCC assigned register into an idx stored in the extable
> (b) take said index, and grab the relevant register from pt_regs
> 
> Then you can have a BUG_VALUE(v, ...), where we use an input "r" (val),
> and mangle that into the idx in the extable. In the common case, I'd
> hope GCC would leave the register in-place from the cmpxchg.
> 
> ... or have I misundertood? :)

Right something along those lines. (a) will need GCC help, and (b) would
be kernel-arch specific. So this isn't something we can quickly do.
