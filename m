Date: Fri, 8 Sep 2017 08:58:11 -0600
From: Tycho Andersen <tycho@docker.com>
Message-ID: <20170908145811.updwpzx6fj7w2m4x@smitten>
References: <20170907173609.22696-1-tycho@docker.com>
 <20170907173609.22696-4-tycho@docker.com>
 <20170908075140.GB4957@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170908075140.GB4957@infradead.org>
Subject: [kernel-hardening] Re: [PATCH v6 03/11] mm, x86: Add support for eXclusive Page Frame
 Ownership (XPFO)
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Sep 08, 2017 at 12:51:40AM -0700, Christoph Hellwig wrote:
> > +#include <linux/xpfo.h>
> >  
> >  #include <asm/cacheflush.h>
> >  
> > @@ -55,24 +56,34 @@ static inline struct page *kmap_to_page(void *addr)
> >  #ifndef ARCH_HAS_KMAP
> >  static inline void *kmap(struct page *page)
> >  {
> > +	void *kaddr;
> > +
> >  	might_sleep();
> > -	return page_address(page);
> > +	kaddr = page_address(page);
> > +	xpfo_kmap(kaddr, page);
> > +	return kaddr;
> >  }
> >  
> >  static inline void kunmap(struct page *page)
> >  {
> > +	xpfo_kunmap(page_address(page), page);
> >  }
> >  
> >  static inline void *kmap_atomic(struct page *page)
> >  {
> > +	void *kaddr;
> > +
> >  	preempt_disable();
> >  	pagefault_disable();
> > -	return page_address(page);
> > +	kaddr = page_address(page);
> > +	xpfo_kmap(kaddr, page);
> > +	return kaddr;
> >  }
> 
> It seems to me like we should simply direct to pure xpfo
> implementations for the !HIGHMEM && XPFO case. - that is
> just have the prototypes for kmap, kunmap and co in
> linux/highmem.h and implement them in xpfo under those names.
> 
> Instead of sprinkling them around.

Ok, IIUC we'll still need a #ifdef CONFIG_XPFO in this file, but at
least the implementations here won't have a diff. I'll make this
change, and all the others you've suggested.

Thanks!

Tycho
