Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 15 Nov 2016 09:01:33 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161115080133.GC3142@twins.programming.kicks-ass.net>
References: <20161110211310.GX3117@twins.programming.kicks-ass.net>
 <20161110222744.GD8086@kroah.com>
 <CAGXu5jJz_dHt-QNqPrYFnQNhj1oV_ux62SSi=PN=VEBm6oq0Mg@mail.gmail.com>
 <20161110233835.GA23164@kroah.com>
 <CAEXv5_j22xaH4cfVztp58XJxCo8UDut44ei_0Rhv_FUbfHDwsQ@mail.gmail.com>
 <CAGXu5jJ0h6+r7T1bcrzVW0gF3Jis1shDbxcpxXR9sniD0B+74A@mail.gmail.com>
 <20161111174630.GO3117@twins.programming.kicks-ass.net>
 <CAGXu5j+_wdv_vn=Us-i=bvCwCGk5Ks_gpoK9bHja4dDNUZi9eQ@mail.gmail.com>
 <20161111201704.GQ3117@twins.programming.kicks-ass.net>
 <CAGXu5jJG0LUxLPtqr79PG=RmWgV96sy2j7dQKr9yvjadzrc3Ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJG0LUxLPtqr79PG=RmWgV96sy2j7dQKr9yvjadzrc3Ag@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Kees Cook <keescook@chromium.org>
Cc: Will Deacon <will.deacon@arm.com>, Greg KH <gregkh@linuxfoundation.org>, David Windsor <dave@progbits.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 14, 2016 at 12:31:32PM -0800, Kees Cook wrote:
> On Fri, Nov 11, 2016 at 12:17 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, Nov 11, 2016 at 10:04:42AM -0800, Kees Cook wrote:
> >
> >> I'm totally open about how to get there, but things can't just be opt-in.
> >
> > There really is no alternative.
> 
> I realize you feel that way, but if we can find a way to squeeze
> mistakes down to impossible or very small, that has a strong effect on
> the future of avoiding exploitation of these kinds of things.

So new drivers and code in general need review anyway, right? There's
tons of other ways people can do root holes by accident. And this whole
refcount thing is something fairly trivial that even tools could spot.

So I really don't see this we must break the world over this argument.

> > refcount_t; should only have: inc, inc_not_zero, dec_and_test
> 
> Sounds good. Two questions remain:
> 
> - how to deal with existing refcounting atomic_t users that want _add and _sub?

The consensus seems to be to hit them over the head and not do this :-)

> - keeping this fast enough that it can be used even in very sensitive
> places (net, fs, etc).

There's really nothing you can do about it except better hardware. If
you want solid semantics you'll have to have this cmpxchg loop. As said,
the LL/SC archs can do slightly better and could provide an asm version
if they feel like it.

> > stats_t; should only have: add,sub
> 
> Seems right, though why not inc/dec? 

Sure, inc/dec are trivial versions of add/sub :-)

> And shouldn't it have a _read of some kind?

I would imagine _set and _read available for all, although currently
there is the discussion of taking even _read() away from refcount_t and
only providing a printk() format specifier.
