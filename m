Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 11 Nov 2016 18:46:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161111174630.GO3117@twins.programming.kicks-ass.net>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <20161110203749.GV3117@twins.programming.kicks-ass.net>
 <20161110204838.GE17134@arm.com>
 <20161110211310.GX3117@twins.programming.kicks-ass.net>
 <20161110222744.GD8086@kroah.com>
 <CAGXu5jJz_dHt-QNqPrYFnQNhj1oV_ux62SSi=PN=VEBm6oq0Mg@mail.gmail.com>
 <20161110233835.GA23164@kroah.com>
 <CAEXv5_j22xaH4cfVztp58XJxCo8UDut44ei_0Rhv_FUbfHDwsQ@mail.gmail.com>
 <CAGXu5jJ0h6+r7T1bcrzVW0gF3Jis1shDbxcpxXR9sniD0B+74A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ0h6+r7T1bcrzVW0gF3Jis1shDbxcpxXR9sniD0B+74A@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Kees Cook <keescook@chromium.org>
Cc: Will Deacon <will.deacon@arm.com>, Greg KH <gregkh@linuxfoundation.org>, David Windsor <dave@progbits.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 11, 2016 at 09:43:00AM -0800, Kees Cook wrote:
> > 1) kref: Used for honest-to-goodness reference counters that want
> > overflow protection.  Uses a new type: atomic_nowrap_t that has
> > HARDENED_ATOMIC protection.
> 
> Based on other feedback, it sounds like we're better off with
> refcount_t (which kref could be implemented on top of). And refcount_t
> would have a limited API: inc, dec_and_test (or whatever is determined
> as sanely minimal).
> 
> > 2) statistical counters: Atomic in all cases, but wraps.
> 
> Yup. sequence_t seems to make the most sense on naming, I think. If we
> want to get crazy, the type could be sequence_wrap_t.

Why? atomic_t is still perfectly fine here, right?

> > 3) atomic_t: All other users of atomics (locks, etc.).  Wrapping
> > behavior depends on a CONFIG setting.
> 
> Correct: if CONFIG_PARANOID_ATOMIC (or something) is set, atomic_t is
> implemented as refcount_t, otherwise as sequence_t.

Can't happen. There is far more atomic_t usage than reference and/or
statistics counters.
