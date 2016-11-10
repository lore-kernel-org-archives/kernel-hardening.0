Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 11 Nov 2016 00:30:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161110233004.GQ3568@worktop.programming.kicks-ass.net>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <1478809488-18303-13-git-send-email-elena.reshetova@intel.com>
 <20161110204046.GW3117@twins.programming.kicks-ass.net>
 <20161110225031.GA26751@worktop>
 <CAGXu5j+yy8Y=_bDhsTgEugJnN5=u8_XMSOAnqJBab-1+9v8+CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+yy8Y=_bDhsTgEugJnN5=u8_XMSOAnqJBab-1+9v8+CA@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC v4 PATCH 12/13] x86: implementation for HARDENED_ATOMIC
To: Kees Cook <keescook@chromium.org>
Cc: Elena Reshetova <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, Will Deacon <will.deacon@arm.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 10, 2016 at 03:07:37PM -0800, Kees Cook wrote:
> On Thu, Nov 10, 2016 at 2:50 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, Nov 10, 2016 at 09:40:46PM +0100, Peter Zijlstra wrote:
> >> On Thu, Nov 10, 2016 at 10:24:47PM +0200, Elena Reshetova wrote:
> >> >  static __always_inline void atomic_add(int i, atomic_t *v)
> >> >  {
> >> > +   asm volatile(LOCK_PREFIX "addl %1,%0\n"
> >> > +
> >> > +#ifdef CONFIG_HARDENED_ATOMIC
> >> > +                "jno 0f\n"
> >> > +                LOCK_PREFIX "subl %1,%0\n"
> >> > +                "int $4\n0:\n"
> >> > +                _ASM_EXTABLE(0b, 0b)
> >>
> >>
> >> This is unreadable gunk.
> >
> > Worse, this is fundamentally racy and therefore not a proper atomic at
> > all.
> 
> The race was discussed earlier as well 

Which is useless, since nobody was listening etc..

> (and some of that should
> already have been covered in the commit message)

it does not.

> , but basically this
> is a race in the overflow protection, so it's not operationally a
> problem. The process that caused the overflow still gets killed, and
> if the system isn't already set up to panic on oops, this becomes a
> resource leak instead of an exploitable condition.

Now is this harmless? If you have two increments racing like:

	  inc
	  jno 1 // overflow

			  inc
			  jno 1 // !overflow

	  dec
	1:		1:

The second thread will still affect your wrap and not BUG.

> 
> > The only way to do this is a cmpxchg loop and not issue the result on
> > overflow. Of course, that would completely suck performance wise, but
> > having a non atomic atomic blows more.
> 
> There was some work to examine this performance impact, and it didn't
> look terrible, but this race-on-overflow isn't viewed as a meaningful
> risk in the refcount situation.

I have a benchmark somewhere, I can run numbers tomorrow, but it really
shows once you get a bit of contention going. Once you hit 4 nodes
contending on a variable its completely out there IIRC.

The unconditional atomic ops really are loads faster than cmpxchg loops.
