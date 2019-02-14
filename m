Date: Thu, 14 Feb 2019 18:44:51 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH v8 04/14] swiotlb: Map the buffer if it was
 unmapped by XPFO
Message-ID: <20190214174451.GA3338@lst.de>
References: <cover.1550088114.git.khalid.aziz@oracle.com> <b595ffb3231dfef3c6b6c896a8e1cba0e838978c.1550088114.git.khalid.aziz@oracle.com> <20190214074747.GA10666@lst.de> <3c75c46c-2a5a-cd75-83d4-f77d96d22f7d@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c75c46c-2a5a-cd75-83d4-f77d96d22f7d@oracle.com>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, juergh@gmail.com, tycho@tycho.ws, jsteckli@amazon.de, ak@linux.intel.com, torvalds@linux-foundation.org, liran.alon@oracle.com, keescook@google.com, akpm@linux-foundation.org, mhocko@suse.com, catalin.marinas@arm.com, will.deacon@arm.com, jmorris@namei.org, konrad.wilk@oracle.com, Juerg Haefliger <juerg.haefliger@canonical.com>, deepa.srinivasan@oracle.com, chris.hyser@oracle.com, tyhicks@canonical.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com, jcm@redhat.com, boris.ostrovsky@oracle.com, kanth.ghatraju@oracle.com, oao.m.martins@oracle.com, jmattson@google.com, pradeep.vincent@oracle.com, john.haxby@oracle.com, tglx@linutronix.de, kirill.shutemov@linux.intel.com, steven.sistare@oracle.com, labbott@redhat.com, luto@kernel.org, dave.hansen@intel.com, peterz@infradead.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Tycho Andersen <tycho@docker.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 14, 2019 at 09:56:24AM -0700, Khalid Aziz wrote:
> On 2/14/19 12:47 AM, Christoph Hellwig wrote:
> > On Wed, Feb 13, 2019 at 05:01:27PM -0700, Khalid Aziz wrote:
> >> +++ b/kernel/dma/swiotlb.c
> >> @@ -396,8 +396,9 @@ static void swiotlb_bounce(phys_addr_t orig_addr, phys_addr_t tlb_addr,
> >>  {
> >>  	unsigned long pfn = PFN_DOWN(orig_addr);
> >>  	unsigned char *vaddr = phys_to_virt(tlb_addr);
> >> +	struct page *page = pfn_to_page(pfn);
> >>  
> >> -	if (PageHighMem(pfn_to_page(pfn))) {
> >> +	if (PageHighMem(page) || xpfo_page_is_unmapped(page)) {
> > 
> > I think this just wants a page_unmapped or similar helper instead of
> > needing the xpfo_page_is_unmapped check.  We actually have quite
> > a few similar construct in the arch dma mapping code for architectures
> > that require cache flushing.
> 
> As I am not the original author of this patch, I am interpreting the
> original intent. I think xpfo_page_is_unmapped() was added to account
> for kernel build without CONFIG_XPFO. xpfo_page_is_unmapped() has an
> alternate definition to return false if CONFIG_XPFO is not defined.
> xpfo_is_unmapped() is cleaned up further in patch 11 ("xpfo, mm: remove
> dependency on CONFIG_PAGE_EXTENSION") to a one-liner "return
> PageXpfoUnmapped(page);". xpfo_is_unmapped() can be eliminated entirely
> by adding an else clause to the following code added by that patch:

The point I'm making it that just about every PageHighMem() check
before code that does a kmap* later needs to account for xpfo as well.

So instead of opencoding the above, be that using xpfo_page_is_unmapped
or PageXpfoUnmapped, we really need one self-describing helper that
checks if a page is unmapped for any reason and needs a kmap to access
it.
