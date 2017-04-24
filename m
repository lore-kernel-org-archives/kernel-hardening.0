MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170424220128.j7nnhuohqdqbiki7@hirez.programming.kicks-ass.net>
References: <20170421220939.GA65363@beast> <58FDF8C4.5120.17D092B7@pageexec.freemail.hu>
 <20170424133323.cf3xyd3mmwp6ixaz@hirez.programming.kicks-ass.net>
 <58FE1687.5511.1844D4FC@pageexec.freemail.hu> <CAGXu5jK5s0KBAfwHPhobiSCn6b0QA4Wb=w=eJG4KyukwbdHTzg@mail.gmail.com>
 <20170424220128.j7nnhuohqdqbiki7@hirez.programming.kicks-ass.net>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 24 Apr 2017 15:37:32 -0700
Message-ID: <CAGXu5j+tbPr04Jiv4yjJJO3h89fDxy-iWAeuoDZ2N+XDY58umw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] x86/refcount: Implement fast refcount_t handling
To: Peter Zijlstra <peterz@infradead.org>
Cc: PaX Team <pageexec@freemail.hu>, LKML <linux-kernel@vger.kernel.org>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jann@thejh.net>, "David S. Miller" <davem@davemloft.net>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 24, 2017 at 3:01 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Apr 24, 2017 at 01:40:56PM -0700, Kees Cook wrote:
>> I think we're way off in the weeds here. The "cannot inc from 0" check
>> is about general sanity checks on refcounts.
>
> I disagree, although sanity check are good too.
>
>> It should never happen, and if it does, there's a bug.
>
> The very same is true of the overflow thing.
>
>> However, what the refcount hardening protection is trying to do is
>> protect again the exploitable condition: overflow.
>
> Sure..
>
>> Inc-from-0 isn't an exploitable condition since in theory
>> the memory suddenly becomes correctly managed again.
>
> It does not. It just got free'ed. Nothing will stop the free from
> happening (or already having happened).

Well, yes, but that's kind of my point. Detecting inc-from-0 is "too
late" to offer a protection. It offers notification of a bug, rather
than stopping an exploit from happening.

>> We're just discussing different things.
>
> No, both are bugs, neither overflow not inc-from-zero _should_ happen.
> The whole point is that code is buggy. If it weren't for that, we'd not
> be doing this.
>
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
>
>
>
>         ~~~/ Thread-C /~~~
>
>         obj = kmalloc(); // is obj from Thread-A
>
>         obj->ref = 1;
>         obj->func = ....
>
>
>                                                 obj->func();
>
>                                                         -- OR --
>
>                                                 put(obj);
>                                                   if (dec_and_test(&obj->ref))
>                                                     kfree(obj); // which was of Thread-C

Right, both are bugs, but the exploitable condition is "refcount hit
zero and got freed while there were still things using it". Having too
many put()s that cause the refcount to reach zero early can't be
detected, but having too many get()s that wrap around, ultimately to
zero, can be (the overflow condition). With overflow protection, the
refcount can never (realistically) hit zero since the refcount will
get saturated at INT_MAX, so no exploit is possible -- no memory is
ever freed (it just leaks the allocation). The inc-from-zero case
performing a notification is certainly nice, but the exploit already
happened.

I want the overflow protection to work everywhere the kernel uses
refcounts, which means dealing with performance concerns from mm, net,
block, etc. Since this is a 1 instruction change (which branch
prediction should make almost no cost at all), this will easily
address any performance concerns from the other subsystems.

I'd rather have the overflow protection everywhere than only in some
areas, and I want to break the deadlock of this catch-22 of subsystems
not being able to say what benchmarks are important to them but
refusing to switch to refcount_t due to performance concerns.

-Kees

-- 
Kees Cook
Pixel Security
