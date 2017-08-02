Date: Wed, 2 Aug 2017 13:08:48 -0400
From: Jerome Glisse <jglisse@redhat.com>
Message-ID: <20170802170848.GA3240@redhat.com>
References: <07063abd-2f5d-20d9-a182-8ae9ead26c3c@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <07063abd-2f5d-20d9-a182-8ae9ead26c3c@huawei.com>
Subject: [kernel-hardening] Re: [RFC] Tagging of vmalloc pages for supporting the pmalloc
 allocator
To: Igor Stoppa <igor.stoppa@huawei.com>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Michal Hocko <mhocko@kernel.org>, Kees Cook <keescook@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 02, 2017 at 06:14:28PM +0300, Igor Stoppa wrote:
> Hi,
> while I am working to another example of using pmalloc [1],
> it was pointed out to me that:
> 
> 1) I had introduced a bug when I switched to using a field of the page
> structure [2]
> 
> 2) I was also committing a layer violation in the way I was tagging the
> pages.
> 
> I am seeking help to understand what would be the correct way to do the
> tagging.
> 
> Here are snippets describing the problems:
> 
> 
> 1) from pmalloc.c:
> 
> ...
> 
> +static const unsigned long pmalloc_signature = (unsigned
> long)&pmalloc_mutex;
> 
> ...
> 
> +int __pmalloc_tag_pages(void *base, const size_t size, const bool set_tag)
> +{
> +	void *end = base + size - 1;
> +
> +	do {
> +		struct page *page;
> +
> +		if (!is_vmalloc_addr(base))
> +			return -EINVAL;
> +		page = vmalloc_to_page(base);
> +		if (set_tag) {
> +			BUG_ON(page_private(page) || page->private);
> +			set_page_private(page, 1);

Above line is pointless you overwrite value right below

> +			page->private = pmalloc_signature;
> +		} else {
> +			BUG_ON(!(page_private(page) &&
> +				 page->private == pmalloc_signature));
> +			set_page_private(page, 0);

Same as above

> +			page->private = 0;
> +		}
> +		base += PAGE_SIZE;
> +	} while ((PAGE_MASK & (unsigned long)base) <=
> +		 (PAGE_MASK & (unsigned long)end));
> +	return 0;
> +}
> 
> ...
> 
> +static const char msg[] = "Not a valid Pmalloc object.";
> +const char *pmalloc_check_range(const void *ptr, unsigned long n)
> +{
> +	unsigned long p;
> +
> +	p = (unsigned long)ptr;
> +	n = p + n - 1;
> +	for (; (PAGE_MASK & p) <= (PAGE_MASK & n); p += PAGE_SIZE) {
> +		struct page *page;
> +
> +		if (!is_vmalloc_addr((void *)p))
> +			return msg;
> +		page = vmalloc_to_page((void *)p);
> +		if (!(page && page_private(page) &&
> +		      page->private == pmalloc_signature))
> +			return msg;
> +	}
> +	return NULL;
> +}
> 
> 
> The problem here comes from the way I am using page->private:
> the fact that the page is marked as private means only that someone is
> using it, and the way it is used could create (spoiler: it happens) a
> collision with pmalloc_signature, which can generate false positives.

Is page->private use for vmalloc memory ? If so then pick another field.
Thought i doubt it is use i would need to check. What was the exact
objection made ?

> 
> A way to ensure that the address really belongs to pmalloc would be to
> pre-screen it, against either the signature or some magic number and,
> if such test is passed, then compare the address against those really
> available in the pmalloc pools.
> 
> This would be slower, but it would be limited only to those cases where
> the signature/magic number matches and the answer is likely to be true.
> 
> 2) However, both the current (incorrect) implementation and the one I am
> considering, are abusing something that should be used otherwise (see
> the following snippet):
> 
> from include/linux/mm_types.h:
> 
> struct page {
> ...
>   union {
>     unsigned long private;		/* Mapping-private opaque data:
> 				 	 * usually used for buffer_heads
> 					 * if PagePrivate set; used for
> 					 * swp_entry_t if PageSwapCache;
> 					 * indicates order in the buddy
> 					 * system if PG_buddy is set.
> 					 */
> #if USE_SPLIT_PTE_PTLOCKS
> #if ALLOC_SPLIT_PTLOCKS
> 		spinlock_t *ptl;
> #else
> 		spinlock_t ptl;
> #endif
> #endif
> 		struct kmem_cache *slab_cache;	/* SL[AU]B: Pointer to slab */
> 	};
> ...
> }
> 
> 
> The "private" field is meant for mapping-private opaque data, which is
> not how I am using it.

As you can see this is an union and thus the meaning of that field depends
on how the page is use. The private comment you see is only meaningfull for
page that are in the page cache and are coming from a file system ie when
a process does an mmap of a file. When page is use by sl[au]b the slab_cache
field is how it is interpreted ... Context in which a page is use do matter.

Here we are talking about memory that is allocated to back vmalloc area so
the private field is unuse AFAICR and it is safe to use it while the page
is use for vmalloc.

Note that i don't think anyone is doing vmap() of pages that are in the page
cache that would seem wrong from my point of view but maybe some one is.
Thought someone might be doing vmap() of pages in which the private field is
use for something (like a device driver private field) in which case you might
still have false positive. You might want to simply add something either to
vm_struct or vmap_area to know if a range of vmalloc area has been created
by pmalloc or not. Maybe you don't even need to tag page and storing flag
in vmap_area or vm_struct would be enough.

Jérôme
