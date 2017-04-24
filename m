From: "PaX Team" <pageexec@freemail.hu>
Date: Mon, 24 Apr 2017 15:08:20 +0200
MIME-Version: 1.0
Message-ID: <58FDF8C4.5120.17D092B7@pageexec.freemail.hu>
In-reply-to: <20170424111553.p3kbyir4ztsldc56@hirez.programming.kicks-ass.net>
References: <20170421220939.GA65363@beast>, <58FDDAC2.11341.175B5A99@pageexec.freemail.hu>, <20170424111553.p3kbyir4ztsldc56@hirez.programming.kicks-ass.net>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH] x86/refcount: Implement fast refcount_t handling
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, x86@kernel.org, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jann@thejh.net>, davem@davemloft.net, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 24 Apr 2017 at 13:15, Peter Zijlstra wrote:

> On Mon, Apr 24, 2017 at 01:00:18PM +0200, PaX Team wrote:
> > On 24 Apr 2017 at 10:32, Peter Zijlstra wrote:
> 
> > > Also, you forgot nr_cpus in your bound. Afaict the worst case here is
> > > O(nr_tasks + 3*nr_cpus).
> > 
> > what does nr_cpus have to do with winning the race?
> 
> The CPUs could each run nested softirq/hardirq/nmi context poking at the
> refcount, irrespective of the (preempted) task context.

that's fine but are you also assuming that the code executed in each of
those contexts leaks the same refcount? otherwise whatever they do to the
refcount is no more relevant than a non-leaking preemptible path that runs
to completion in a bounded amount of time (i.e., you get temporary bumps
and thus need to win yet another set of races to get their effects at once).

> > > Because PaX does it, is not a correctness argument. And this really
> > > wants one.
> > 
> > heh, do you want to tell me about how checking for a 0 refcount prevents
> > exploiting a bug?
> 
> Not the point. All I said was that saying somebody else does it (anybody
> else, doesn't matter it was you) isn't an argument for correctness.

that was exactly my point: all this applies to you as well. so let me ask
the 3rd time: what is your "argument for correctness" for a 0 refcount
value check? how does it prevent exploitation?
