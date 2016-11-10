Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 10 Nov 2016 23:50:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161110225031.GA26751@worktop>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <1478809488-18303-13-git-send-email-elena.reshetova@intel.com>
 <20161110204046.GW3117@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161110204046.GW3117@twins.programming.kicks-ass.net>
Subject: [kernel-hardening] Re: [RFC v4 PATCH 12/13] x86: implementation for HARDENED_ATOMIC
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, will.deacon@arm.com, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 10, 2016 at 09:40:46PM +0100, Peter Zijlstra wrote:
> On Thu, Nov 10, 2016 at 10:24:47PM +0200, Elena Reshetova wrote:
> >  static __always_inline void atomic_add(int i, atomic_t *v)
> >  {
> > +	asm volatile(LOCK_PREFIX "addl %1,%0\n"
> > +
> > +#ifdef CONFIG_HARDENED_ATOMIC
> > +		     "jno 0f\n"
> > +		     LOCK_PREFIX "subl %1,%0\n"
> > +		     "int $4\n0:\n"
> > +		     _ASM_EXTABLE(0b, 0b)
> 
> 
> This is unreadable gunk.

Worse, this is fundamentally racy and therefore not a proper atomic at
all.

The only way to do this is a cmpxchg loop and not issue the result on
overflow. Of course, that would completely suck performance wise, but
having a non atomic atomic blows more.

> > +#endif
> > +
> >  		     : "+m" (v->counter)
> >  		     : "ir" (i));
> >  }
