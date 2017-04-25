From: "PaX Team" <pageexec@freemail.hu>
Date: Tue, 25 Apr 2017 13:26:43 +0200
MIME-Version: 1.0
Message-ID: <58FF3273.2718.1C99E5A3@pageexec.freemail.hu>
In-reply-to: <20170424220128.j7nnhuohqdqbiki7@hirez.programming.kicks-ass.net>
References: <20170421220939.GA65363@beast>, <CAGXu5jK5s0KBAfwHPhobiSCn6b0QA4Wb=w=eJG4KyukwbdHTzg@mail.gmail.com>, <20170424220128.j7nnhuohqdqbiki7@hirez.programming.kicks-ass.net>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH] x86/refcount: Implement fast refcount_t handling
To: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jann@thejh.net>, "David S. Miller" <davem@davemloft.net>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 25 Apr 2017 at 0:01, Peter Zijlstra wrote:

> On Mon, Apr 24, 2017 at 01:40:56PM -0700, Kees Cook wrote:
> > I think we're way off in the weeds here. The "cannot inc from 0" check
> > is about general sanity checks on refcounts.
> 
> I disagree, although sanity check are good too.

exactly, an attacker doesn't care how a premature free occurs due
to reaching a 0 refcount, afterwards it's memory corruption time for
both old and new references regardless.

> > However, what the refcount hardening protection is trying to do is
> > protect again the exploitable condition: overflow.
> 
> Sure..

underflow is also exploitable, it's just much harder to defend against
(there're no known practical solutions).

> > Inc-from-0 isn't an exploitable condition since in theory
> > the memory suddenly becomes correctly managed again.
> 
> It does not. It just got free'ed. Nothing will stop the free from
> happening (or already having happened).

now hold this thought...

> How is the below not useful fodder for an exploit? It might be a less
> common bug, and perhaps a bit more fiddly to make work, but afaict its
> still a full use-after-free and therefore useful.
> 
> ---
> 
> Thread-A                                        Thread-B
> 
> if(dec_and_test(&obj->ref)) { // true, ref==0
> 
>                                                 inc(&obj->ref) // ref: 0->1
> 
>         kfree(obj);
> }

... and tell me why an attacker would let Thread-B do that increment
(that you're trying to detect) *before* the underlying memory gets
reused and thus the 0 changed to something else? hint: he'll do everything
in his power to prevent that, either by winning the race or if there's
no race (no refcount users outside his control), he'll win every time.
IOW, checking for 0 is pointless and you kinda proved it yourself now.
