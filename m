Message-ID: <1493082680.23190.1.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Mon, 24 Apr 2017 21:11:20 -0400
In-Reply-To: <CAGXu5j+tbPr04Jiv4yjJJO3h89fDxy-iWAeuoDZ2N+XDY58umw@mail.gmail.com>
References: <20170421220939.GA65363@beast>
	 <58FDF8C4.5120.17D092B7@pageexec.freemail.hu>
	 <20170424133323.cf3xyd3mmwp6ixaz@hirez.programming.kicks-ass.net>
	 <58FE1687.5511.1844D4FC@pageexec.freemail.hu>
	 <CAGXu5jK5s0KBAfwHPhobiSCn6b0QA4Wb=w=eJG4KyukwbdHTzg@mail.gmail.com>
	 <20170424220128.j7nnhuohqdqbiki7@hirez.programming.kicks-ass.net>
	 <CAGXu5j+tbPr04Jiv4yjJJO3h89fDxy-iWAeuoDZ2N+XDY58umw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH] x86/refcount: Implement fast
 refcount_t handling
To: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>
Cc: PaX Team <pageexec@freemail.hu>, LKML <linux-kernel@vger.kernel.org>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jann@thejh.net>, "David S. Miller" <davem@davemloft.net>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 2017-04-24 at 15:37 -0700, Kees Cook wrote:
> On Mon, Apr 24, 2017 at 3:01 PM, Peter Zijlstra <peterz@infradead.org
> > wrote:
> > On Mon, Apr 24, 2017 at 01:40:56PM -0700, Kees Cook wrote:
> > > I think we're way off in the weeds here. The "cannot inc from 0"
> > > check
> > > is about general sanity checks on refcounts.
> > 
> > I disagree, although sanity check are good too.
> > 
> > > It should never happen, and if it does, there's a bug.
> > 
> > The very same is true of the overflow thing.
> > 
> > > However, what the refcount hardening protection is trying to do
> > > is
> > > protect again the exploitable condition: overflow.
> > 
> > Sure..
> > 
> > > Inc-from-0 isn't an exploitable condition since in theory
> > > the memory suddenly becomes correctly managed again.
> > 
> > It does not. It just got free'ed. Nothing will stop the free from
> > happening (or already having happened).
> 
> Well, yes, but that's kind of my point. Detecting inc-from-0 is "too
> late" to offer a protection. It offers notification of a bug, rather
> than stopping an exploit from happening.

inc-from-0 could allow the attacker to gain access to
an object which gets allocated to a new user afterwards.

Certainly much less useful as an exploit, but still a
potential privilege escalation.
