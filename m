Date: Tue, 23 Jan 2018 13:15:08 -0800
From: Matthew Wilcox <willy@infradead.org>
Message-ID: <20180123211508.GC5565@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] Write-once memory
To: kernel-hardening@lists.openwall.com, Dave Chinner <dchinner@redhat.com>, Christopher Lameter <cl@linux.com>, Kees Cook <keescook@google.com>
List-ID: <kernel-hardening.lists.openwall.com>


At the kernel hardening BOF yesterday, we came up with the concept of
write-once memory.

The problem it's intended to solve is that XFS allocates a large amount
of memory at filesystem mount time which is conceptually read-only until
it's destroyed.  Protecting this by making the pages read-only would be
a nice hardening improvement (both for security and as a defense against
stray writes).

At the moment that data is mixed in with read-write data, so XFS will need
modifying to use this new facility.

We believe that the right way to support write-once memory is through
slab APIs.  Something like:

void kmem_cache_init_once(struct kmem_cache *s, void (*init)(void *),
		void *data);

used like this:

const struct my_ro_data *alloc_my_ro_data(struct my_context *context, gfp_t gfp)
{
	const struct my_ro_data *p = kmem_cache_alloc(cache, gfp);
	kmem_cache_init_once(p, my_init_once, context);
	return p;
}

The implementation would change the page protection on that slab page
from RO to RW temporarily while my_init_once() is running.  This would
lead to a short window of vulnerability, but that doesn't feel like
an unreasonable tradeoff for memory efficiency (being able to allocate
multiple my_ro_data per page).

Feedback?
