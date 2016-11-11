Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 11 Nov 2016 21:19:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161111201943.GR3117@twins.programming.kicks-ass.net>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <1478809488-18303-13-git-send-email-elena.reshetova@intel.com>
 <20161110204046.GW3117@twins.programming.kicks-ass.net>
 <20161110225031.GA26751@worktop>
 <CAGXu5j+yy8Y=_bDhsTgEugJnN5=u8_XMSOAnqJBab-1+9v8+CA@mail.gmail.com>
 <20161110233004.GQ3568@worktop.programming.kicks-ass.net>
 <CAGXu5j++ZZDmgYqzvx104Bs2iQK+7V_Xn2VgTR7eoCwS2JR0tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j++ZZDmgYqzvx104Bs2iQK+7V_Xn2VgTR7eoCwS2JR0tw@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC v4 PATCH 12/13] x86: implementation for HARDENED_ATOMIC
To: Kees Cook <keescook@chromium.org>
Cc: Elena Reshetova <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, Will Deacon <will.deacon@arm.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 11, 2016 at 10:00:27AM -0800, Kees Cook wrote:
> Agreed: the first thread will BUG and the second thread is still halfway to 0.
> 
> On systems that panic on BUG, things are protected. For the rest of
> the systems, an alternative to "dec" on overflow is to sub (more than)
> NR_CPUS, to keep the saturation below the overflow level. This means
> that it is still detected (BUG) by at least 1 thread, and cannot reach
> 0 (to trigger the flaw) on all other threads, even if they all lose
> the race.

NR_CPUS has nothing to do with anything here. If this is a vcpu that got
scheduled out in between the inc and dec there can be an arbitrary
amount of other crap happening.

> To me, this seems better than taking the cmpxchg performance hit.

To me that shows you shouldn't be allowed near atomic_t. You cannot have
a non-atomic atomic op. That just doesn't happen.
