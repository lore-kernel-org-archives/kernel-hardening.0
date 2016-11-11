Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAEXv5_j22xaH4cfVztp58XJxCo8UDut44ei_0Rhv_FUbfHDwsQ@mail.gmail.com>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <20161110203749.GV3117@twins.programming.kicks-ass.net> <20161110204838.GE17134@arm.com>
 <20161110211310.GX3117@twins.programming.kicks-ass.net> <20161110222744.GD8086@kroah.com>
 <CAGXu5jJz_dHt-QNqPrYFnQNhj1oV_ux62SSi=PN=VEBm6oq0Mg@mail.gmail.com>
 <20161110233835.GA23164@kroah.com> <CAEXv5_j22xaH4cfVztp58XJxCo8UDut44ei_0Rhv_FUbfHDwsQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 11 Nov 2016 09:43:00 -0800
Message-ID: <CAGXu5jJ0h6+r7T1bcrzVW0gF3Jis1shDbxcpxXR9sniD0B+74A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Peter Zijlstra <peterz@infradead.org>, Will Deacon <will.deacon@arm.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: David Windsor <dave@progbits.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

(And now Greg went missing from the reply? Re-added...)

On Thu, Nov 10, 2016 at 11:50 PM, David Windsor <dave@progbits.org> wrote:
> On Thu, Nov 10, 2016 at 6:38 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Thu, Nov 10, 2016 at 03:15:44PM -0800, Kees Cook wrote:
> While I really, really don't want to go down the opt-in route, here
> are the three relevant types and their associated use cases:
>
> 1) kref: Used for honest-to-goodness reference counters that want
> overflow protection.  Uses a new type: atomic_nowrap_t that has
> HARDENED_ATOMIC protection.

Based on other feedback, it sounds like we're better off with
refcount_t (which kref could be implemented on top of). And refcount_t
would have a limited API: inc, dec_and_test (or whatever is determined
as sanely minimal).

> 2) statistical counters: Atomic in all cases, but wraps.

Yup. sequence_t seems to make the most sense on naming, I think. If we
want to get crazy, the type could be sequence_wrap_t.

> 3) atomic_t: All other users of atomics (locks, etc.).  Wrapping
> behavior depends on a CONFIG setting.

Correct: if CONFIG_PARANOID_ATOMIC (or something) is set, atomic_t is
implemented as refcount_t, otherwise as sequence_t.

As far as refcount_t is concerned, I worry using cmpxchg will be too
costly, but it's worth benchmarking.

I suspect the first pass at this style will be:

1) create refcount_t, API, and wrap detection
2) convert atomic_t-as-refcount users to refcount_t (coccinelle to
find "dec_and_test" followed by "free"?)
3) create sequence_t API
4) convert atomic_t-as-stat users to sequence_t
5) implement atomic_t as one-or-the-other based on CONFIG

1,2 and 3,4 can happen at the same time.

> We'd need to audit the kernel and identify all reference counter users
> of atomic_t and convert them to kref.  This isn't nearly as large a
> task as enumerating all statistical counter users of atomic_t.
>
> The third category, users of atomic_t that fit neither into the
> category of reference counters or stat counters, is the interesting
> case.  I'm drawing a blank as to which of these users would require
> overflow protection?  If none do, we could drastically reduce the size
> of this patchset: leave atomic_t alone and implement kref with
> atomic_nowrap_t.  Again, it's very late and I'm drawing a blank as to
> "misc" users of atomic_t (non-refcount and non-stat-counters).
>
>>> statistic counters (say, "statcount" implemented with new atomic_wrap_t)
>>
>> Lots of these are also "sequences", that drivers rely on.  Hopefully
>> they can wrap as that's what happens today.  So that might not be the
>> best name, but naming is hard...
>>
>>> everything else (named "atomic_t", implemented as either
>>> atomic_nowrap_t or atomic_wrap_t, depending on CONFIG)
>>
>
> I don't like rerfcount/refcount_t: kref should be used.  In the same
> spirit, kstatcount might be more consistent.
>
> Pure, unadulterated bikeshedding.  =)

I suspect the mechanical changes to using krefcount_t will be easier
that switching to kref. Large comments around krefcount_t can be added
to encourage people to just use kref, though.

Peter, Will, Greg, how does this 5-step approach (above) sound to you?
It gets us explicit marking in the kernel for what is expected to be a
reference counter or a sequence counter, and give us the ability to go
paranoid with the remaining atomic_t users.

-Kees

-- 
Kees Cook
Nexus Security
