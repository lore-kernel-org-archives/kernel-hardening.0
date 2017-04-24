Date: Mon, 24 Apr 2017 10:32:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170424083250.h2wv2exbi4ytigac@hirez.programming.kicks-ass.net>
References: <20170421220939.GA65363@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170421220939.GA65363@beast>
Subject: [kernel-hardening] Re: [PATCH] x86/refcount: Implement fast refcount_t handling
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, x86@kernel.org, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jann@thejh.net>, davem@davemloft.net, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 21, 2017 at 03:09:39PM -0700, Kees Cook wrote:
> This patch ports the x86-specific atomic overflow handling from PaX's
> PAX_REFCOUNT to the upstream refcount_t API. This is an updated version
> from PaX that eliminates the saturation race condition by resetting the
> atomic counter back to the INT_MAX saturation value on both overflow and
> underflow. To win a race, a system would have to have INT_MAX threads
> simultaneously overflow before the saturation handler runs.

And is this impossible? Highly unlikely I'll grant you, but absolutely
impossible?

Also, you forgot nr_cpus in your bound. Afaict the worst case here is
O(nr_tasks + 3*nr_cpus).

Because PaX does it, is not a correctness argument. And this really
wants one.
