Date: Thu, 14 Feb 2019 08:47:47 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH v8 04/14] swiotlb: Map the buffer if it was
 unmapped by XPFO
Message-ID: <20190214074747.GA10666@lst.de>
References: <cover.1550088114.git.khalid.aziz@oracle.com> <b595ffb3231dfef3c6b6c896a8e1cba0e838978c.1550088114.git.khalid.aziz@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b595ffb3231dfef3c6b6c896a8e1cba0e838978c.1550088114.git.khalid.aziz@oracle.com>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: juergh@gmail.com, tycho@tycho.ws, jsteckli@amazon.de, ak@linux.intel.com, torvalds@linux-foundation.org, liran.alon@oracle.com, keescook@google.com, akpm@linux-foundation.org, mhocko@suse.com, catalin.marinas@arm.com, will.deacon@arm.com, jmorris@namei.org, konrad.wilk@oracle.com, Juerg Haefliger <juerg.haefliger@canonical.com>, deepa.srinivasan@oracle.com, chris.hyser@oracle.com, tyhicks@canonical.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com, jcm@redhat.com, boris.ostrovsky@oracle.com, kanth.ghatraju@oracle.com, oao.m.martins@oracle.com, jmattson@google.com, pradeep.vincent@oracle.com, john.haxby@oracle.com, tglx@linutronix.de, kirill.shutemov@linux.intel.com, hch@lst.de, steven.sistare@oracle.com, labbott@redhat.com, luto@kernel.org, dave.hansen@intel.com, peterz@infradead.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Tycho Andersen <tycho@docker.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 13, 2019 at 05:01:27PM -0700, Khalid Aziz wrote:
> +++ b/kernel/dma/swiotlb.c
> @@ -396,8 +396,9 @@ static void swiotlb_bounce(phys_addr_t orig_addr, phys_addr_t tlb_addr,
>  {
>  	unsigned long pfn = PFN_DOWN(orig_addr);
>  	unsigned char *vaddr = phys_to_virt(tlb_addr);
> +	struct page *page = pfn_to_page(pfn);
>  
> -	if (PageHighMem(pfn_to_page(pfn))) {
> +	if (PageHighMem(page) || xpfo_page_is_unmapped(page)) {

I think this just wants a page_unmapped or similar helper instead of
needing the xpfo_page_is_unmapped check.  We actually have quite
a few similar construct in the arch dma mapping code for architectures
that require cache flushing.

> +bool xpfo_page_is_unmapped(struct page *page)
> +{
> +	struct xpfo *xpfo;
> +
> +	if (!static_branch_unlikely(&xpfo_inited))
> +		return false;
> +
> +	xpfo = lookup_xpfo(page);
> +	if (unlikely(!xpfo) && !xpfo->inited)
> +		return false;
> +
> +	return test_bit(XPFO_PAGE_UNMAPPED, &xpfo->flags);
> +}
> +EXPORT_SYMBOL(xpfo_page_is_unmapped);

And at least for swiotlb there is no need to export this helper,
as it is always built in.
