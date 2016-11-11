Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 11 Nov 2016 21:05:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161111200500.GP3117@twins.programming.kicks-ass.net>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <20161110203749.GV3117@twins.programming.kicks-ass.net>
 <20161110204838.GE17134@arm.com>
 <20161110211310.GX3117@twins.programming.kicks-ass.net>
 <20161110222744.GD8086@kroah.com>
 <CAGXu5jJz_dHt-QNqPrYFnQNhj1oV_ux62SSi=PN=VEBm6oq0Mg@mail.gmail.com>
 <20161110233835.GA23164@kroah.com>
 <CAEXv5_j22xaH4cfVztp58XJxCo8UDut44ei_0Rhv_FUbfHDwsQ@mail.gmail.com>
 <CAGXu5jJ0h6+r7T1bcrzVW0gF3Jis1shDbxcpxXR9sniD0B+74A@mail.gmail.com>
 <20161111183118.GO11945@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161111183118.GO11945@leverpostej>
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Mark Rutland <mark.rutland@arm.com>
Cc: kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Greg KH <gregkh@linuxfoundation.org>, David Windsor <dave@progbits.org>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 11, 2016 at 06:31:18PM +0000, Mark Rutland wrote:
> On Fri, Nov 11, 2016 at 09:43:00AM -0800, Kees Cook wrote:
> > (And now Greg went missing from the reply? Re-added...)
> > 
> > On Thu, Nov 10, 2016 at 11:50 PM, David Windsor <dave@progbits.org> wrote:
> > > On Thu, Nov 10, 2016 at 6:38 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > >> On Thu, Nov 10, 2016 at 03:15:44PM -0800, Kees Cook wrote:
> 
> > As far as refcount_t is concerned, I worry using cmpxchg will be too
> > costly, but it's worth benchmarking.
> 
> If that does turn out to be a problem, we could allow architectures to
> provide their own implementations of the API, with a generic fallback
> otherwise, as we do for other features.

Note that only LL/SC archs can do somewhat better. x86/s390/sparc64 etc
al must use cmpxchg, there's just no other way to get an actual atomic
inc/dec with over/under-flow detection.

The proposed x86 implementation is non-atomic and therefore a complete
nonstarter.
