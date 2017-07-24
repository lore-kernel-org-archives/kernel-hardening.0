Date: Mon, 24 Jul 2017 14:23:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170724122327.z6p4w5yvirnbuvfd@hirez.programming.kicks-ass.net>
References: <1500422614-94821-1-git-send-email-keescook@chromium.org>
 <20170720091106.kigtr6zy7pjgk2s6@gmail.com>
 <20170721142255.586224f0db9cf0714e654859@linux-foundation.org>
 <CAGXu5j+QU7OXWA_oMaLUsDnS4yyfNx8-1f_ywHX=o88kqE7=JQ@mail.gmail.com>
 <87zibujq5t.fsf@concordia.ellerman.id.au>
 <20170724084455.o5asa55fckgyjri2@hirez.programming.kicks-ass.net>
 <87k22yjatf.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k22yjatf.fsf@concordia.ellerman.id.au>
Subject: [kernel-hardening] Re: [PATCH v6 0/2] x86: Implement fast refcount overflow protection
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Christoph Hellwig <hch@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 24, 2017 at 10:09:32PM +1000, Michael Ellerman wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> > anyway, and the fact that your LL/SC is horrendously slow in any case.
> 
> Boo :/

:-)

> Just kidding. I suspect you're right that we can probably pack a
> reasonable amount of tests in the body of the LL/SC and not notice.
> 
> > Also, I still haven't seen an actual benchmark where our cmpxchg loop
> > actually regresses anything, just a lot of yelling about potential
> > regressions :/
> 
> Heh yeah. Though I have looked at the code it generates on PPC and it's
> not sleek, though I guess that's not a benchmark is it :)

Oh for sure, GCC still can't sanely convert a cmpxchg loop (esp. if the
cmpxchg is implemented using asm) into a native LL/SC sequence, so the
generic code will end up looking pretty horrendous.

A native implementation of the same semantics should look loads better.


One thing that might help you is that refcount_dec_and_test() is weaker
than atomic_dec_and_test() wrt ordering, so that might help some
(RELEASE vs fully ordered).
