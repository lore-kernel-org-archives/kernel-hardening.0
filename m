Date: Mon, 18 Sep 2017 15:29:09 -0600
From: Tycho Andersen <tycho@docker.com>
Message-ID: <20170918212909.3x7i7pmh76a4l24s@docker>
References: <20170907173609.22696-1-tycho@docker.com>
 <20170907173609.22696-8-tycho@docker.com>
 <20170914182555.GB1711@remoulade>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170914182555.GB1711@remoulade>
Subject: [kernel-hardening] Re: [PATCH v6 07/11] arm64/mm, xpfo: temporarily map dcache regions
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-kernel@vger.kernel.org, Marco Benatto <marco.antonio.780@gmail.com>, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, Juerg Haefliger <juerg.haefliger@canonical.com>, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Sep 14, 2017 at 07:25:56PM +0100, Mark Rutland wrote:
> On Thu, Sep 07, 2017 at 11:36:05AM -0600, Tycho Andersen wrote:
> > From: Juerg Haefliger <juerg.haefliger@canonical.com>
> > 
> > If the page is unmapped by XPFO, a data cache flush results in a fatal
> > page fault, so let's temporarily map the region, flush the cache, and then
> > unmap it.
> > 
> > v6: actually flush in the face of xpfo, and temporarily map the underlying
> >     memory so it can be flushed correctly
> > 
> > CC: linux-arm-kernel@lists.infradead.org
> > Signed-off-by: Juerg Haefliger <juerg.haefliger@canonical.com>
> > Signed-off-by: Tycho Andersen <tycho@docker.com>
> > ---
> >  arch/arm64/mm/flush.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/arch/arm64/mm/flush.c b/arch/arm64/mm/flush.c
> > index 21a8d828cbf4..e335e3fd4fca 100644
> > --- a/arch/arm64/mm/flush.c
> > +++ b/arch/arm64/mm/flush.c
> > @@ -20,6 +20,7 @@
> >  #include <linux/export.h>
> >  #include <linux/mm.h>
> >  #include <linux/pagemap.h>
> > +#include <linux/xpfo.h>
> >  
> >  #include <asm/cacheflush.h>
> >  #include <asm/cache.h>
> > @@ -28,9 +29,15 @@
> >  void sync_icache_aliases(void *kaddr, unsigned long len)
> >  {
> >  	unsigned long addr = (unsigned long)kaddr;
> > +	unsigned long num_pages = XPFO_NUM_PAGES(addr, len);
> > +	void *mapping[num_pages];
> >  
> >  	if (icache_is_aliasing()) {
> > +		xpfo_temp_map(kaddr, len, mapping,
> > +			      sizeof(mapping[0]) * num_pages);
> >  		__clean_dcache_area_pou(kaddr, len);
> > +		xpfo_temp_unmap(kaddr, len, mapping,
> > +			        sizeof(mapping[0]) * num_pages);
> 
> Does this create the mapping in-place?
> 
> Can we not just kmap_atomic() an alias? Or is there a problem with that?

I think what we really want is something like vmap(), looking at
xpfo_temp_map() it seems like the implementation is completely wrong.

I wonder if what you mentioned at LSS is possible though: doing cache
management with userspace primitives instead of mapping the region
just to flush it.

Cheers,

Tycho
