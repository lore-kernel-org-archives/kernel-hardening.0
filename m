Date: Fri, 8 Sep 2017 00:13:35 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170908071334.GA9869@infradead.org>
References: <20170907173609.22696-1-tycho@docker.com>
 <20170907173609.22696-5-tycho@docker.com>
 <20170907181015.GA9557@infradead.org>
 <20170907184414.ow7av6wt5vht6pnd@docker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907184414.ow7av6wt5vht6pnd@docker>
Subject: [kernel-hardening] Re: [PATCH v6 04/11] swiotlb: Map the buffer if it was unmapped by
 XPFO
To: Tycho Andersen <tycho@docker.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Sep 07, 2017 at 12:44:14PM -0600, Tycho Andersen wrote:
> On Thu, Sep 07, 2017 at 11:10:15AM -0700, Christoph Hellwig wrote:
> > > -	if (PageHighMem(pfn_to_page(pfn))) {
> > > +	if (PageHighMem(page) || xpfo_page_is_unmapped(page)) {
> > 
> > Please don't sprinkle xpfo details over various bits of code.
> > 
> > Just add a helper with a descriptive name, e.g.
> > 
> > page_is_unmapped()
> > 
> > that also includes the highmem case, as that will easily document
> > what this check is doing.
> 
> Will do, thanks.
> 
> Patch 7 has a similar feel to this one, I can add a wrapper around
> __clean_dcache_area_pou() if that makes sense?

That one is in low-level ARM code so I'm not that worried.
But in general it seems like we should simply have one interface
to check if a page has a kernel mapping or not, nad map/unmap it
if not instead of distinguishing between highmem and xpfo.
