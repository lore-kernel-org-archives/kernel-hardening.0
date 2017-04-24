Date: Mon, 24 Apr 2017 13:15:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170424111553.p3kbyir4ztsldc56@hirez.programming.kicks-ass.net>
References: <20170421220939.GA65363@beast>
 <20170424083250.h2wv2exbi4ytigac@hirez.programming.kicks-ass.net>
 <58FDDAC2.11341.175B5A99@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58FDDAC2.11341.175B5A99@pageexec.freemail.hu>
Subject: [kernel-hardening] Re: [PATCH] x86/refcount: Implement fast refcount_t handling
To: PaX Team <pageexec@freemail.hu>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, x86@kernel.org, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jann@thejh.net>, davem@davemloft.net, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 24, 2017 at 01:00:18PM +0200, PaX Team wrote:
> On 24 Apr 2017 at 10:32, Peter Zijlstra wrote:

> > Also, you forgot nr_cpus in your bound. Afaict the worst case here is
> > O(nr_tasks + 3*nr_cpus).
> 
> what does nr_cpus have to do with winning the race?

The CPUs could each run nested softirq/hardirq/nmi context poking at the
refcount, irrespective of the (preempted) task context.

> > Because PaX does it, is not a correctness argument. And this really
> > wants one.
> 
> heh, do you want to tell me about how checking for a 0 refcount prevents
> exploiting a bug?

Not the point. All I said was that saying somebody else does it (anybody
else, doesn't matter it was you) isn't an argument for correctness.
