Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 12 Nov 2016 00:07:50 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161111230750.GP3157@twins.programming.kicks-ass.net>
References: <20161110203749.GV3117@twins.programming.kicks-ass.net>
 <20161110204838.GE17134@arm.com>
 <20161110211310.GX3117@twins.programming.kicks-ass.net>
 <20161110222744.GD8086@kroah.com>
 <CAGXu5jJz_dHt-QNqPrYFnQNhj1oV_ux62SSi=PN=VEBm6oq0Mg@mail.gmail.com>
 <20161110235714.GR3568@worktop.programming.kicks-ass.net>
 <1478824161.7326.5.camel@cvidal.org>
 <20161111124126.GG11945@leverpostej>
 <20161111124755.GI3117@twins.programming.kicks-ass.net>
 <20161111130034.GO3157@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161111130034.GO3157@twins.programming.kicks-ass.net>
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Mark Rutland <mark.rutland@arm.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Greg KH <gregkh@linuxfoundation.org>, Will Deacon <will.deacon@arm.com>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 11, 2016 at 02:00:34PM +0100, Peter Zijlstra wrote:
> +static inline bool refcount_sub_and_test(int i, refcount_t *r)
> +{
> +	unsigned int old, new, val = atomic_read(&r->refs);
> +
> +	for (;;) {

regardless of the sub_and_test vs inc_and_test issue, this should
probably also have:

		if (val == UINT_MAX)
			return false;

such that we stay saturated. If for some reason someone can trigger more
dec's than inc's, we'd be hosed.

> +		new = val - i;
> +		if (new > val)
> +			BUG(); /* underflow */
> +
> +		old = atomic_cmpxchg_release(&r->refs, val, new);
> +		if (old == val)
> +			break;
> +
> +		val = old;
> +	}
> +
> +	return !new;
> +}
