MIME-Version: 1.0
In-Reply-To: <20180123211508.GC5565@bombadil.infradead.org>
References: <20180123211508.GC5565@bombadil.infradead.org>
From: Kees Cook <keescook@google.com>
Date: Wed, 24 Jan 2018 11:01:45 +1100
Message-ID: <CAGXu5jJiE2yOvCpbU6U7WijNniitwW7fz3gUXZiZUbJb91auVQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: Write-once memory
To: Matthew Wilcox <willy@infradead.org>
Cc: kernel-hardening@lists.openwall.com, Dave Chinner <dchinner@redhat.com>, Christopher Lameter <cl@linux.com>, Igor Stoppa <igor.stoppa@huawei.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 24, 2018 at 8:15 AM, Matthew Wilcox <willy@infradead.org> wrote:
> At the kernel hardening BOF yesterday, we came up with the concept of
> write-once memory.

This is something Igor Stoppa has also been looking at too:
https://lkml.org/lkml/2017/7/10/400

> The problem it's intended to solve is that XFS allocates a large amount
> of memory at filesystem mount time which is conceptually read-only until
> it's destroyed.  Protecting this by making the pages read-only would be
> a nice hardening improvement (both for security and as a defense against
> stray writes).
>
> At the moment that data is mixed in with read-write data, so XFS will need
> modifying to use this new facility.
>
> We believe that the right way to support write-once memory is through
> slab APIs.  Something like:

I do like the idea of making this part of the slab API, instead of as
a separate allocator.

> void kmem_cache_init_once(struct kmem_cache *s, void (*init)(void *),
>                 void *data);
>
> used like this:
>
> const struct my_ro_data *alloc_my_ro_data(struct my_context *context, gfp_t gfp)
> {
>         const struct my_ro_data *p = kmem_cache_alloc(cache, gfp);
>         kmem_cache_init_once(p, my_init_once, context);
>         return p;
> }
>
> The implementation would change the page protection on that slab page
> from RO to RW temporarily while my_init_once() is running.  This would
> lead to a short window of vulnerability, but that doesn't feel like
> an unreasonable tradeoff for memory efficiency (being able to allocate
> multiple my_ro_data per page).

The memory permission lifetime of the allocation needs very careful
attention. Allowing the write permission to be visible to other CPUs
needs to be avoided. If this is part of the design, it's likely an
attacker can just race an allocation (which makes the page writable)
with a bug that allows a write to the page from another CPU.
Similarly, there shouldn't be a stand-alone "make this writable"
function, but rather only a "free" action which makes it writable and
returns it to the freelist. To me, it seems that dealing with
fragmentation, then, becomes the real problem.

-Kees

-- 
Kees Cook
Pixel Security
