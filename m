Date: Mon, 29 May 2017 14:23:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170529122316.giceifwjnuz6djr4@hirez.programming.kicks-ass.net>
References: <1487590189-18151-1-git-send-email-elena.reshetova@intel.com>
 <20170303162352.b6af1c0c3115b3f5f1e7aed3@linux-foundation.org>
 <CAGXu5jKNChaVdfbM171FYkvY1hUMXG6cp-=WAdXBP0eTOO5RAA@mail.gmail.com>
 <20170529083903.GA17735@infradead.org>
 <87h904xc26.fsf@xmission.com>
 <20170529102442.gerbzxzixllen46q@hirez.programming.kicks-ass.net>
 <87a85wvsxa.fsf@xmission.com>
 <87o9ubvr0t.fsf@xmission.com>
 <8760gjvqm7.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8760gjvqm7.fsf@xmission.com>
Subject: [kernel-hardening] Re: [PATCH 0/3] ipc subsystem refcounter conversions
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@infradead.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Elena Reshetova <elena.reshetova@intel.com>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 29, 2017 at 06:39:44AM -0500, Eric W. Biederman wrote:
> I failed to see that there is a refcount_inc.  Too much noise in
> the header file I suppose.
> 
> But implementing refcount_inc in terms of refcount_inc_not_zero is
> totally broken.  The two operations are not the same and the go to
> different assumptions the code is making.
> 
> That explains why you think refcount_inc_not_zero should lie because
> you are implementing refcount_inc with it.  They are semantically very
> different operations.  Please separate them.

There has been much debate about this. And the best I'll do is add a
comment and/or retain these exact semantics.

What is done is:

	refcount_inc() := WARN_ON(!refcount_inc_not_zero())

Because incrementing a zero reference count is a use-after-free and
something we should not do ever.

This is where the whole usage count vs reference count pain comes from.

Once there are no more _references_ to an object, a reference count
frees the object. Therefore a zero reference count means a dead object
and incrementing from that is fail.

The usage count model otoh counts how many (active) users there are of
an object, and no active users is a good and expected situation. But it
is very explicitly not a reference count. Because even in the no users
case do we have a reference to the object (we've not leaked it after
all, we just don't track all references).


Similarly, refcount_dec() is implemented using dec_and_test() and will
WARN when it hits 0, because this is a leak and we don't want those
either.

A usage count variant otoh would be fine with hitting 0.
