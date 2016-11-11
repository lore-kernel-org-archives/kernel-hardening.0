Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 11 Nov 2016 15:39:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20161111130034.GO3157@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.20.1611111532220.3501@nanos>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com> <20161110203749.GV3117@twins.programming.kicks-ass.net> <20161110204838.GE17134@arm.com> <20161110211310.GX3117@twins.programming.kicks-ass.net> <20161110222744.GD8086@kroah.com>
 <CAGXu5jJz_dHt-QNqPrYFnQNhj1oV_ux62SSi=PN=VEBm6oq0Mg@mail.gmail.com> <20161110235714.GR3568@worktop.programming.kicks-ass.net> <1478824161.7326.5.camel@cvidal.org> <20161111124126.GG11945@leverpostej> <20161111124755.GI3117@twins.programming.kicks-ass.net>
 <20161111130034.GO3157@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Greg KH <gregkh@linuxfoundation.org>, Will Deacon <will.deacon@arm.com>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 11 Nov 2016, Peter Zijlstra wrote:
> A wee bit like so...
> +
> +static inline bool refcount_sub_and_test(int i, refcount_t *r)

Why would we want to expose that at all? refcount_inc() and
refcount_dec_and_test() is what is required for refcounting.

I know there are a few users of kref_sub() in tree, but that's all
undocumented voodoo, which should not be proliferated.

Thanks,

	tglx
