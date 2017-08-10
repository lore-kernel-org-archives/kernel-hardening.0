Date: Thu, 10 Aug 2017 10:22:56 -0600
From: Tycho Andersen <tycho@docker.com>
Message-ID: <20170810162256.ah4yre6xjbfd5oi3@smitten>
References: <20170809200755.11234-1-tycho@docker.com>
 <20170809200755.11234-4-tycho@docker.com>
 <20170810130104.GB2413@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170810130104.GB2413@localhost.localdomain>
Subject: [kernel-hardening] Re: [PATCH v5 03/10] swiotlb: Map the buffer if it was unmapped by
 XPFO
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, Juerg Haefliger <juerg.haefliger@hpe.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 10, 2017 at 09:01:06AM -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, Aug 09, 2017 at 02:07:48PM -0600, Tycho Andersen wrote:
> > +inline bool xpfo_page_is_unmapped(struct page *page)
> > +{
> > +	if (!static_branch_unlikely(&xpfo_inited))
> > +		return false;
> > +
> > +	return test_bit(XPFO_PAGE_UNMAPPED, &lookup_xpfo(page)->flags);
> > +}
> > +EXPORT_SYMBOL(xpfo_page_is_unmapped);
> 
> How can it be inline and 'EXPORT_SYMBOL' ? And why make it inline? It
> surely does not need to be access that often?

Good point. I'll drop inline from the next version, thanks!

Tycho
