Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 11 Nov 2016 21:17:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161111201704.GQ3117@twins.programming.kicks-ass.net>
References: <20161110203749.GV3117@twins.programming.kicks-ass.net>
 <20161110204838.GE17134@arm.com>
 <20161110211310.GX3117@twins.programming.kicks-ass.net>
 <20161110222744.GD8086@kroah.com>
 <CAGXu5jJz_dHt-QNqPrYFnQNhj1oV_ux62SSi=PN=VEBm6oq0Mg@mail.gmail.com>
 <20161110233835.GA23164@kroah.com>
 <CAEXv5_j22xaH4cfVztp58XJxCo8UDut44ei_0Rhv_FUbfHDwsQ@mail.gmail.com>
 <CAGXu5jJ0h6+r7T1bcrzVW0gF3Jis1shDbxcpxXR9sniD0B+74A@mail.gmail.com>
 <20161111174630.GO3117@twins.programming.kicks-ass.net>
 <CAGXu5j+_wdv_vn=Us-i=bvCwCGk5Ks_gpoK9bHja4dDNUZi9eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+_wdv_vn=Us-i=bvCwCGk5Ks_gpoK9bHja4dDNUZi9eQ@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Kees Cook <keescook@chromium.org>
Cc: Will Deacon <will.deacon@arm.com>, Greg KH <gregkh@linuxfoundation.org>, David Windsor <dave@progbits.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 11, 2016 at 10:04:42AM -0800, Kees Cook wrote:

> I'm totally open about how to get there, but things can't just be opt-in.

There really is no alternative.

refcount_t; should only have: inc, inc_not_zero, dec_and_test

stats_t; should only have: add,sub

atomic_t; has:

	{add,inc,sub,dec} + {and,or,xor,notand}

	{add,inc,sub,dec}_return * {,relaxed,release,acquire}

	(fetch_{add,inc,sub,dec} + {and,or,xor,notand}) * {,relaxed,release,acquire}

	{sub,add,inc,dec}_and_test

	{cmpxchg,xchg}

	add_unless,inc_not_zero,{inc,dec}_unless_negative,dec_if_positive

That is so much more than either refcount_t or stats_t should have, and
the whole wrap/nowrap thing only matters to part of the ops.

Like said, atomic_cmpxchg_wrap() is utter crap, that's a function name
that doesn't make sense, and you guys should have realized that the
moment you typed it.

Its fantasy to think you can 'implement' atomic_t with refcount_t or
anything else. You're chasing unicorns.
