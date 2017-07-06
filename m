Date: Thu, 6 Jul 2017 10:55:39 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
In-Reply-To: <CAGXu5jKHkKgF90LXbFvrc3fa2PAaaaYHvCbiBM-9aN16TrHL=g@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1707061052380.26079@east.gentwo.org>
References: <20170706002718.GA102852@beast> <alpine.DEB.2.20.1707060841170.23867@east.gentwo.org> <CAGXu5jKHkKgF90LXbFvrc3fa2PAaaaYHvCbiBM-9aN16TrHL=g@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v3] mm: Add SLUB free list pointer obfuscation
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>, Andy Lutomirski <luto@kernel.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Tejun Heo <tj@kernel.org>, Daniel Mack <daniel@zonque.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Linux-MM <linux-mm@kvack.org>, Tycho Andersen <tycho@docker.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 6 Jul 2017, Kees Cook wrote:

> On Thu, Jul 6, 2017 at 6:43 AM, Christoph Lameter <cl@linux.com> wrote:
> > On Wed, 5 Jul 2017, Kees Cook wrote:
> >
> >> @@ -3536,6 +3565,9 @@ static int kmem_cache_open(struct kmem_cache *s, unsigned long flags)
> >>  {
> >>       s->flags = kmem_cache_flags(s->size, flags, s->name, s->ctor);
> >>       s->reserved = 0;
> >> +#ifdef CONFIG_SLAB_FREELIST_HARDENED
> >> +     s->random = get_random_long();
> >> +#endif
> >>
> >>       if (need_reserve_slab_rcu && (s->flags & SLAB_TYPESAFE_BY_RCU))
> >>               s->reserved = sizeof(struct rcu_head);
> >>
> >
> > So if an attacker knows the internal structure of data then he can simply
> > dereference page->kmem_cache->random to decode the freepointer.
>
> That requires a series of arbitrary reads. This is protecting against
> attacks that use an adjacent slab object write overflow to write the
> freelist pointer. This internal structure is very reliable, and has
> been the basis of freelist attacks against the kernel for a decade.

These reads are not arbitrary. You can usually calculate the page struct
address easily from the address and then do a couple of loads to get
there.

Ok so you get rid of the old attacks because we did not have that
hardening in effect when they designed their approaches?

> It is a probabilistic defense, but then so is the stack protector.
> This is a similar defense; while not perfect it makes the class of
> attack much more difficult to mount.

Na I am not convinced of the "much more difficult". Maybe they will just
have to upgrade their approaches to fetch the proper values to decode.
