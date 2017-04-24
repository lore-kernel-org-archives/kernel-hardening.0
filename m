Date: Mon, 24 Apr 2017 15:33:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170424133323.cf3xyd3mmwp6ixaz@hirez.programming.kicks-ass.net>
References: <20170421220939.GA65363@beast>
 <58FDDAC2.11341.175B5A99@pageexec.freemail.hu>
 <20170424111553.p3kbyir4ztsldc56@hirez.programming.kicks-ass.net>
 <58FDF8C4.5120.17D092B7@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58FDF8C4.5120.17D092B7@pageexec.freemail.hu>
Subject: [kernel-hardening] Re: [PATCH] x86/refcount: Implement fast refcount_t handling
To: PaX Team <pageexec@freemail.hu>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, x86@kernel.org, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jann@thejh.net>, davem@davemloft.net, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 24, 2017 at 03:08:20PM +0200, PaX Team wrote:
> On 24 Apr 2017 at 13:15, Peter Zijlstra wrote:
> 
> > On Mon, Apr 24, 2017 at 01:00:18PM +0200, PaX Team wrote:
> > > On 24 Apr 2017 at 10:32, Peter Zijlstra wrote:
> > 
> > > > Also, you forgot nr_cpus in your bound. Afaict the worst case here is
> > > > O(nr_tasks + 3*nr_cpus).
> > > 
> > > what does nr_cpus have to do with winning the race?
> > 
> > The CPUs could each run nested softirq/hardirq/nmi context poking at the
> > refcount, irrespective of the (preempted) task context.
> 
> that's fine but are you also assuming that the code executed in each of
> those contexts leaks the same refcount? otherwise whatever they do to the
> refcount is no more relevant than a non-leaking preemptible path that runs
> to completion in a bounded amount of time (i.e., you get temporary bumps
> and thus need to win yet another set of races to get their effects at once).

For worst case analysis we have to assume it does, unless we can proof
it doesn't. And that proof is very very hard, and would need to be
redone every time the kernel changes.

> that was exactly my point: all this applies to you as well. so let me ask
> the 3rd time: what is your "argument for correctness" for a 0 refcount
> value check? how does it prevent exploitation?

What 0 count check are you talking about, the one that triggers when we
want to increment 0 ?

I think I've explained that before; per reference count rules 0 means
freed (or about to be freed when we talk RCU).

The whole pattern:

	if (dec_and_test(&obj->ref))
		kfree(obj);

expresses this etc.. Other reference counts also do this. No references
means its getting freed.

Can you agree with this?


If so; any attempt to increase the reference count while its (being)
freed() is a use-after-free.

Therefore we disallow 0 increment.


Yes, this is an annoyance when you consider usage-counts, where 0 means
something else. But then, we were talking about reference counts, not
something else.
