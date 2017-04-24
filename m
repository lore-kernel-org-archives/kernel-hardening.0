Date: Mon, 24 Apr 2017 11:20:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170424092051.ooww4tngcu5274qz@hirez.programming.kicks-ass.net>
References: <20170421220939.GA65363@beast>
 <20170424083250.h2wv2exbi4ytigac@hirez.programming.kicks-ass.net>
 <CAG48ez1z4F0sTBV3DCvkVJazQXxXGe=NyWKqYjKveEj-CQVy7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1z4F0sTBV3DCvkVJazQXxXGe=NyWKqYjKveEj-CQVy7w@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH] x86/refcount: Implement fast
 refcount_t handling
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, x86@kernel.org, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jann@thejh.net>, "David S. Miller" <davem@davemloft.net>, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 24, 2017 at 10:53:30AM +0200, Jann Horn wrote:
> On Mon, Apr 24, 2017 at 10:32 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, Apr 21, 2017 at 03:09:39PM -0700, Kees Cook wrote:
> >> This patch ports the x86-specific atomic overflow handling from PaX's
> >> PAX_REFCOUNT to the upstream refcount_t API. This is an updated version
> >> from PaX that eliminates the saturation race condition by resetting the
> >> atomic counter back to the INT_MAX saturation value on both overflow and
> >> underflow. To win a race, a system would have to have INT_MAX threads
> >> simultaneously overflow before the saturation handler runs.
> >
> > And is this impossible? Highly unlikely I'll grant you, but absolutely
> > impossible?
> >
> > Also, you forgot nr_cpus in your bound. Afaict the worst case here is
> > O(nr_tasks + 3*nr_cpus).
> >
> > Because PaX does it, is not a correctness argument. And this really
> > wants one.
> 
> From include/linux/threads.h:
> 
> /*
>  * A maximum of 4 million PIDs should be enough for a while.
>  * [NOTE: PID/TIDs are limited to 2^29 ~= 500+ million, see futex.h.]
>  */
> #define PID_MAX_LIMIT (CONFIG_BASE_SMALL ? PAGE_SIZE * 8 : \
> (sizeof(long) > 4 ? 4 * 1024 * 1024 : PID_MAX_DEFAULT))
> 
> AFAICS that means you can only have up to 2^22 running tasks at
> a time, since every running task requires a PID in the init pid namespace.

That's but an artificial limit and bound to be increased sooner rather
than later, given the trend in building ever larger machines.

If we go with the futex limit on the full tid space, we end up with 2^30
(the comment here about 29 is wrong, see FUTEX_TID_MASK).

We then still have to add a multiple of nr_cpus. Granted, that will
still be slightly short of 3^31, but not to any amount I'm really
comfortable with, we're _really_ close.

Point remains though; Changelog (and arguably the code itself) should
very much include such bits.
