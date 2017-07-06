Date: Thu, 6 Jul 2017 08:43:19 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
In-Reply-To: <20170706002718.GA102852@beast>
Message-ID: <alpine.DEB.2.20.1707060841170.23867@east.gentwo.org>
References: <20170706002718.GA102852@beast>
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v3] mm: Add SLUB free list pointer obfuscation
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>, Andy Lutomirski <luto@kernel.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Tejun Heo <tj@kernel.org>, Daniel Mack <daniel@zonque.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, linux-mm@kvack.org, Tycho Andersen <tycho@docker.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 5 Jul 2017, Kees Cook wrote:

> @@ -3536,6 +3565,9 @@ static int kmem_cache_open(struct kmem_cache *s, unsigned long flags)
>  {
>  	s->flags = kmem_cache_flags(s->size, flags, s->name, s->ctor);
>  	s->reserved = 0;
> +#ifdef CONFIG_SLAB_FREELIST_HARDENED
> +	s->random = get_random_long();
> +#endif
>
>  	if (need_reserve_slab_rcu && (s->flags & SLAB_TYPESAFE_BY_RCU))
>  		s->reserved = sizeof(struct rcu_head);
>

So if an attacker knows the internal structure of data then he can simply
dereference page->kmem_cache->random to decode the freepointer.

Assuming someone is already targeting a freelist pointer (which indicates
detailed knowledge of the internal structure) then I would think that
someone like that will also figure out how to follow the pointer links to
get to the random value.

Not seeing the point of all of this.
