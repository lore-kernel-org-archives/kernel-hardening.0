Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 11 Nov 2016 18:31:18 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161111183118.GO11945@leverpostej>
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
To: kernel-hardening@lists.openwall.com
Cc: Peter Zijlstra <peterz@infradead.org>, Will Deacon <will.deacon@arm.com>, Greg KH <gregkh@linuxfoundation.org>, David Windsor <dave@progbits.org>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 11, 2016 at 09:43:00AM -0800, Kees Cook wrote:
> (And now Greg went missing from the reply? Re-added...)
> 
> On Thu, Nov 10, 2016 at 11:50 PM, David Windsor <dave@progbits.org> wrote:
> > On Thu, Nov 10, 2016 at 6:38 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> On Thu, Nov 10, 2016 at 03:15:44PM -0800, Kees Cook wrote:

> As far as refcount_t is concerned, I worry using cmpxchg will be too
> costly, but it's worth benchmarking.

If that does turn out to be a problem, we could allow architectures to
provide their own implementations of the API, with a generic fallback
otherwise, as we do for other features.

> I suspect the first pass at this style will be:
> 
> 1) create refcount_t, API, and wrap detection
> 2) convert atomic_t-as-refcount users to refcount_t (coccinelle to
> find "dec_and_test" followed by "free"?)

This was problably already covered, but I take it that as part of 1 we'd
migrate kref to refcount_t? 

We should also add coccicheck / checkpatch stuff to detect suspicious
usage in new patches. That'll make fighting the tide less painful (or
teach people to obfuscate their patches, and make it harder, who
knows?).

> 3) create sequence_t API
> 4) convert atomic_t-as-stat users to sequence_t
> 5) implement atomic_t as one-or-the-other based on CONFIG

> 1,2 and 3,4 can happen at the same time.

If we manage 1 and 2, the remaining classes of atomic_t usage should be
far easier to distinguish (which would influence steps 3+).

Currently, it's not entirely clear to me what shapes the remaining
instances would have, and Peter mentioned that they don't fall into the
proposed sequence class.

Thanks,
Mark.
