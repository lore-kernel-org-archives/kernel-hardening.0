Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 11 Nov 2016 15:48:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161111144852.GL3117@twins.programming.kicks-ass.net>
References: <20161110204838.GE17134@arm.com>
 <20161110211310.GX3117@twins.programming.kicks-ass.net>
 <20161110222744.GD8086@kroah.com>
 <CAGXu5jJz_dHt-QNqPrYFnQNhj1oV_ux62SSi=PN=VEBm6oq0Mg@mail.gmail.com>
 <20161110235714.GR3568@worktop.programming.kicks-ass.net>
 <1478824161.7326.5.camel@cvidal.org>
 <20161111124126.GG11945@leverpostej>
 <20161111124755.GI3117@twins.programming.kicks-ass.net>
 <20161111130034.GO3157@twins.programming.kicks-ass.net>
 <alpine.DEB.2.20.1611111532220.3501@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1611111532220.3501@nanos>
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Rutland <mark.rutland@arm.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Greg KH <gregkh@linuxfoundation.org>, Will Deacon <will.deacon@arm.com>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 11, 2016 at 03:39:05PM +0100, Thomas Gleixner wrote:
> On Fri, 11 Nov 2016, Peter Zijlstra wrote:
> > A wee bit like so...
> > +
> > +static inline bool refcount_sub_and_test(int i, refcount_t *r)
> 
> Why would we want to expose that at all? refcount_inc() and
> refcount_dec_and_test() is what is required for refcounting.
> 
> I know there are a few users of kref_sub() in tree, but that's all
> undocumented voodoo, which should not be proliferated.

I tend to agree. There are a few other sites that do multiple get/put as
well using atomic_t.

So supporting them using refcount_t is trivial -- simply match the
atomic*() functions in semantics with added wrappery tests, but you're
right in that having these encourages 'creative' use which we would be
better off without.

Ideally the audit would include sanitizing this. Moreover, there really
is only a handfull of these creative user, so maybe we could just leave
them be.
