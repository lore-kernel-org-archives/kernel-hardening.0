Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 11 Nov 2016 18:47:44 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161111184744.GQ11945@leverpostej>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <20161110203749.GV3117@twins.programming.kicks-ass.net>
 <20161110204838.GE17134@arm.com>
 <20161110211310.GX3117@twins.programming.kicks-ass.net>
 <20161110222744.GD8086@kroah.com>
 <CAGXu5jJz_dHt-QNqPrYFnQNhj1oV_ux62SSi=PN=VEBm6oq0Mg@mail.gmail.com>
 <20161110233835.GA23164@kroah.com>
 <CAEXv5_j22xaH4cfVztp58XJxCo8UDut44ei_0Rhv_FUbfHDwsQ@mail.gmail.com>
 <CAGXu5jJ0h6+r7T1bcrzVW0gF3Jis1shDbxcpxXR9sniD0B+74A@mail.gmail.com>
 <20161111174630.GO3117@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161111174630.GO3117@twins.programming.kicks-ass.net>
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Will Deacon <will.deacon@arm.com>, Greg KH <gregkh@linuxfoundation.org>, David Windsor <dave@progbits.org>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 11, 2016 at 06:46:30PM +0100, Peter Zijlstra wrote:
> On Fri, Nov 11, 2016 at 09:43:00AM -0800, Kees Cook wrote:
> > > 1) kref: Used for honest-to-goodness reference counters that want
> > > overflow protection.  Uses a new type: atomic_nowrap_t that has
> > > HARDENED_ATOMIC protection.
> > 
> > Based on other feedback, it sounds like we're better off with
> > refcount_t (which kref could be implemented on top of). And refcount_t
> > would have a limited API: inc, dec_and_test (or whatever is determined
> > as sanely minimal).
> > 
> > > 2) statistical counters: Atomic in all cases, but wraps.
> > 
> > Yup. sequence_t seems to make the most sense on naming, I think. If we
> > want to get crazy, the type could be sequence_wrap_t.
> 
> Why? atomic_t is still perfectly fine here, right?

Having a name that clearly highlights the intended use-case makes it
much more obvious what the expected semantics are, and when it is being
abused. If atomic_t were rarely used directly, bad uses are less likely
to get cargo-culted into new code.

That said, a plethora of use-case specific aliases for the same
underlying implementation is also problematic.

Thanks,
Mark.
