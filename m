Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161111201704.GQ3117@twins.programming.kicks-ass.net>
References: <20161110203749.GV3117@twins.programming.kicks-ass.net>
 <20161110204838.GE17134@arm.com> <20161110211310.GX3117@twins.programming.kicks-ass.net>
 <20161110222744.GD8086@kroah.com> <CAGXu5jJz_dHt-QNqPrYFnQNhj1oV_ux62SSi=PN=VEBm6oq0Mg@mail.gmail.com>
 <20161110233835.GA23164@kroah.com> <CAEXv5_j22xaH4cfVztp58XJxCo8UDut44ei_0Rhv_FUbfHDwsQ@mail.gmail.com>
 <CAGXu5jJ0h6+r7T1bcrzVW0gF3Jis1shDbxcpxXR9sniD0B+74A@mail.gmail.com>
 <20161111174630.GO3117@twins.programming.kicks-ass.net> <CAGXu5j+_wdv_vn=Us-i=bvCwCGk5Ks_gpoK9bHja4dDNUZi9eQ@mail.gmail.com>
 <20161111201704.GQ3117@twins.programming.kicks-ass.net>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 14 Nov 2016 12:31:32 -0800
Message-ID: <CAGXu5jJG0LUxLPtqr79PG=RmWgV96sy2j7dQKr9yvjadzrc3Ag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>, Greg KH <gregkh@linuxfoundation.org>, David Windsor <dave@progbits.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 11, 2016 at 12:17 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Nov 11, 2016 at 10:04:42AM -0800, Kees Cook wrote:
>
>> I'm totally open about how to get there, but things can't just be opt-in.
>
> There really is no alternative.

I realize you feel that way, but if we can find a way to squeeze
mistakes down to impossible or very small, that has a strong effect on
the future of avoiding exploitation of these kinds of things.

> refcount_t; should only have: inc, inc_not_zero, dec_and_test

Sounds good. Two questions remain:

- how to deal with existing refcounting atomic_t users that want _add and _sub?
- keeping this fast enough that it can be used even in very sensitive
places (net, fs, etc).

> stats_t; should only have: add,sub

Seems right, though why not inc/dec? And shouldn't it have a _read of some kind?

Keeping the implementation details of refcount_t and stats_t opaque to
the users should discourage misuse...

> atomic_t; has:
>
>         {add,inc,sub,dec} + {and,or,xor,notand}
>
>         {add,inc,sub,dec}_return * {,relaxed,release,acquire}
>
>         (fetch_{add,inc,sub,dec} + {and,or,xor,notand}) * {,relaxed,release,acquire}
>
>         {sub,add,inc,dec}_and_test
>
>         {cmpxchg,xchg}
>
>         add_unless,inc_not_zero,{inc,dec}_unless_negative,dec_if_positive
>
> That is so much more than either refcount_t or stats_t should have, and
> the whole wrap/nowrap thing only matters to part of the ops.
>
> Like said, atomic_cmpxchg_wrap() is utter crap, that's a function name
> that doesn't make sense, and you guys should have realized that the
> moment you typed it.
>
> Its fantasy to think you can 'implement' atomic_t with refcount_t or
> anything else. You're chasing unicorns.

So, here's another suggestion on how to avoid this being opt-in: we
change atomic_t's name along with adding refcount_t and stats_t. We
need some way to distinguish "true" atomic users from the refcount_t
and stats_t, without needing to hope we can educate future driver
writers. Then, after transition to refcount_t, stats_t, and
bikeshed_atomic_t, we can catch misuse by having a CONFIG that forces
new/remaining atomic_t into refcount_t (which will blow up the build
if a driver uses anything besides inc, inc_not_zero, dec_and_test,
etc).

Regardless, adding refcount_t and stats_t will already make the audit
work of finding misused atomic_t SO much better, so since this is a
precondition to any other crazier ideas, it looks like we can all
agree on doing those pieces first.

-Kees

-- 
Kees Cook
Nexus Security
