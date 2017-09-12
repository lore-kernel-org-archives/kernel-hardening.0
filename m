Date: Tue, 12 Sep 2017 07:36:36 -0700
From: Tycho Andersen <tycho@docker.com>
Message-ID: <20170912143636.avc3ponnervs43kj@docker>
References: <20170907173609.22696-1-tycho@docker.com>
 <20170907173609.22696-4-tycho@docker.com>
 <302be94d-7e44-001d-286c-2b0cd6098f7b@huawei.com>
 <20170911145020.fat456njvyagcomu@docker>
 <57e95ad2-81d8-bf83-3e78-1313daa1bb80@canonical.com>
 <431e2567-7600-3186-1489-93b855c395bd@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <431e2567-7600-3186-1489-93b855c395bd@huawei.com>
Subject: [kernel-hardening] Re: [PATCH v6 03/11] mm, x86: Add support for eXclusive Page Frame
 Ownership (XPFO)
To: Yisheng Xie <xieyisheng1@huawei.com>
Cc: Juerg Haefliger <juerg.haefliger@canonical.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Sep 12, 2017 at 04:05:22PM +0800, Yisheng Xie wrote:
> 
> 
> On 2017/9/12 0:03, Juerg Haefliger wrote:
> > 
> > 
> > On 09/11/2017 04:50 PM, Tycho Andersen wrote:
> >> Hi Yisheng,
> >>
> >> On Mon, Sep 11, 2017 at 03:24:09PM +0800, Yisheng Xie wrote:
> >>>> +void xpfo_alloc_pages(struct page *page, int order, gfp_t gfp)
> >>>> +{
> >>>> +	int i, flush_tlb = 0;
> >>>> +	struct xpfo *xpfo;
> >>>> +
> >>>> +	if (!static_branch_unlikely(&xpfo_inited))
> >>>> +		return;
> >>>> +
> >>>> +	for (i = 0; i < (1 << order); i++)  {
> >>>> +		xpfo = lookup_xpfo(page + i);
> >>>> +		if (!xpfo)
> >>>> +			continue;
> >>>> +
> >>>> +		WARN(test_bit(XPFO_PAGE_UNMAPPED, &xpfo->flags),
> >>>> +		     "xpfo: unmapped page being allocated\n");
> >>>> +
> >>>> +		/* Initialize the map lock and map counter */
> >>>> +		if (unlikely(!xpfo->inited)) {
> >>>> +			spin_lock_init(&xpfo->maplock);
> >>>> +			atomic_set(&xpfo->mapcount, 0);
> >>>> +			xpfo->inited = true;
> >>>> +		}
> >>>> +		WARN(atomic_read(&xpfo->mapcount),
> >>>> +		     "xpfo: already mapped page being allocated\n");
> >>>> +
> >>>> +		if ((gfp & GFP_HIGHUSER) == GFP_HIGHUSER) {
> >>>> +			/*
> >>>> +			 * Tag the page as a user page and flush the TLB if it
> >>>> +			 * was previously allocated to the kernel.
> >>>> +			 */
> >>>> +			if (!test_and_set_bit(XPFO_PAGE_USER, &xpfo->flags))
> >>>> +				flush_tlb = 1;
> >>>
> >>> I'm not sure whether I am miss anything, however, when the page was previously allocated
> >>> to kernel,  should we unmap the physmap (the kernel's page table) here? For we allocate
> >>> the page to user now
> >>>
> >> Yes, I think you're right. Oddly, the XPFO_READ_USER test works
> 
> Hi Tycho,
> Could you share this test? I'd like to know how it works.

See the last patch in the series.

> >> correctly for me, but I think (?) should not because of this bug...
> > 
> > IIRC, this is an optimization carried forward from the initial
> > implementation. 
> Hi Juerg,
> 
> hmm.. If below is the first version, then it seems this exist from the first version:
> https://patchwork.kernel.org/patch/8437451/
> 
> > The assumption is that the kernel will map the user
> > buffer so it's not unmapped on allocation but only on the first (and
> > subsequent) call of kunmap.
> 
> IMO, before a page is allocated, it is in buddy system, which means it is free
> and no other 'map' on the page except direct map. Then if the page is allocated
> to user, XPFO should unmap the direct map. otherwise the ret2dir may works at
> this window before it is freed. Or maybe I'm still missing anything.

I agree that it seems broken. I'm just not sure why the test doesn't
fail. It's certainly worth understanding.

Tycho
