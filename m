Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1453798109.17181.70.camel@tiscali.nl>
From: Paul Bolle <pebolle@tiscali.nl>
Date: Tue, 26 Jan 2016 09:48:29 +0100
In-Reply-To: <1453770913-32287-3-git-send-email-labbott@fedoraproject.org>
References: <1453770913-32287-1-git-send-email-labbott@fedoraproject.org>
	 <1453770913-32287-3-git-send-email-labbott@fedoraproject.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC][PATCH 2/3] slub: Don't limit debugging to slow paths
To: Laura Abbott <labbott@fedoraproject.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <js1304@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On ma, 2016-01-25 at 17:15 -0800, Laura Abbott wrote:
> --- a/init/Kconfig
> +++ b/init/Kconfig
 
> +config SLUB_DEBUG_FASTPATH
> +	bool "Allow SLUB debugging to utilize the fastpath"
> +	depends on SLUB_DEBUG
> +	help
> +	  SLUB_DEBUG forces all allocations to utilize the slow path which
> +	  is a performance penalty. Turning on this option lets the debugging
> +	  use the fast path. This helps the performance when debugging
> +	  features are turned on. If you aren't planning on utilizing any
> +	  of the SLUB_DEBUG features, you should say N here.
> +
> +	  If unsure, say N

> --- a/mm/slub.c
> +++ b/mm/slub.c

> +#ifdef SLUB_DEBUG_FASTPATH

I have no clue what your patch does, but I could spot this should
probably be
	#ifdef CONFIG_SLUB_DEBUG_FASTPATH

> +static noinline int alloc_debug_processing_fastpath(struct kmem_cache
> *s,
> +					struct kmem_cache_cpu *c,
> +					struct page *page,
> +					void *object, unsigned long
> tid,
> +					unsigned long addr)
> +{
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	preempt_disable();
> +	local_irq_save(flags);
> +
> +	/*
> +	 * We've now disabled preemption and IRQs but we still need
> +	 * to check that this is the right CPU
> +	 */
> +	if (!this_cpu_cmpxchg_double(s->cpu_slab->freelist, s
> ->cpu_slab->tid,
> +				c->freelist, tid,
> +				c->freelist, tid))
> +		goto out;
> +
> +	ret = alloc_debug_processing(s, page, object, addr);
> +
> +out:
> +	local_irq_restore(flags);
> +	preempt_enable();
> +	return ret;
> +}
> +#else
> +static noinline int alloc_debug_processing_fastpath(struct kmem_cache
> *s,
> +					struct kmem_cache_cpu *c,
> +					struct page *page,
> +					void *object, unsigned long
> tid,
> +					unsigned long addr)
> +{
> +	return 1;
> +}
> +#endif

Thanks,


Paul Bolle
