Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 27 Apr 2016 10:39:29 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
In-Reply-To: <20160426161743.f831225a4efb3eb04debe402@linux-foundation.org>
Message-ID: <alpine.DEB.2.20.1604271027540.20042@east.gentwo.org>
References: <1461687670-47585-1-git-send-email-thgarnie@google.com> <20160426161743.f831225a4efb3eb04debe402@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v4] mm: SLAB freelist randomization
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Garnier <thgarnie@google.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Kees Cook <keescook@chromium.org>, gthelen@google.com, labbott@fedoraproject.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 26 Apr 2016, Andrew Morton wrote:

> : CONFIG_FREELIST_RANDOM bugs me a bit - "freelist" is so vague.
> : CONFIG_SLAB_FREELIST_RANDOM would be better.  I mean, what Kconfig
> : identifier could be used for implementing randomisation in
> : slub/slob/etc once CONFIG_FREELIST_RANDOM is used up?
>
> but this pearl appeared to pass unnoticed.

Ok. lets add SLAB here and then use this option for the other allocators
as well.

> > +	/* If it fails, we will just use the global lists */
> > +	cachep->random_seq = kcalloc(count, sizeof(freelist_idx_t), GFP_KERNEL);
> > +	if (!cachep->random_seq)
> > +		return -ENOMEM;
>
> OK, no BUG.  If this happens, kmem_cache_init_late() will go BUG
> instead ;)
>
> Questions for slab maintainers:
>
> What's going on with the gfp_flags in there?  kmem_cache_init_late()
> passes GFP_NOWAIT into enable_cpucache().
>
> a) why the heck does it do that?  It's __init code!

enable_cpucache() was called when a slab cache was reconfigured by writing to /proc/slabinfo.
That was changed awhile back when the memcg changes were made ot slab. So
now its ok to be made init code.

> Finally, all callers of enable_cpucache() (and hence of
> cache_random_seq_create()) are __init, so we're unnecessarily bloating
> up vmlinux.  Could someone please take a look at this as a separate
> thing?

Hmmm. Well if that is the case then lots of stuff could be straightened
out. Joonsoo?
