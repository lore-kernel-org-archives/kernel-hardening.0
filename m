Date: Thu, 31 Aug 2017 14:21:43 -0700
From: Tycho Andersen <tycho@docker.com>
Message-ID: <20170831212143.3rzgru3kmci6vnxd@docker>
References: <20170809200755.11234-5-tycho@docker.com>
 <20170812112603.GB16374@remoulade>
 <20170814163536.6njceqc3dip5lrlu@smitten>
 <20170814165047.GB23428@leverpostej>
 <20170823165842.k5lbxom45avvd7g2@smitten>
 <20170823170443.GD12567@leverpostej>
 <2428d66f-3c31-fa73-0d6a-c16fafa99455@canonical.com>
 <20170830164724.m6bbogd46ix4qp4o@docker>
 <b50951e4-0b80-6d0e-39ed-fd9d67a51db3@canonical.com>
 <20170831094726.GB15031@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170831094726.GB15031@leverpostej>
Subject: Re: [kernel-hardening] [PATCH v5 04/10] arm64: Add __flush_tlb_one()
To: Mark Rutland <mark.rutland@arm.com>
Cc: Juerg Haefliger <juerg.haefliger@canonical.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi all,

On Thu, Aug 31, 2017 at 10:47:27AM +0100, Mark Rutland wrote:
> On Thu, Aug 31, 2017 at 11:43:53AM +0200, Juerg Haefliger wrote:
> > On 08/30/2017 06:47 PM, Tycho Andersen wrote:
> > > On Wed, Aug 30, 2017 at 07:31:25AM +0200, Juerg Haefliger wrote:
> > >>
> > >>
> > >> On 08/23/2017 07:04 PM, Mark Rutland wrote:
> > >>> On Wed, Aug 23, 2017 at 10:58:42AM -0600, Tycho Andersen wrote:
> > >>>> Hi Mark,
> > >>>>
> > >>>> On Mon, Aug 14, 2017 at 05:50:47PM +0100, Mark Rutland wrote:
> > >>>>> That said, is there any reason not to use flush_tlb_kernel_range()
> > >>>>> directly?
> > >>>>
> > >>>> So it turns out that there is a difference between __flush_tlb_one() and
> > >>>> flush_tlb_kernel_range() on x86: flush_tlb_kernel_range() flushes all the TLBs
> > >>>> via on_each_cpu(), where as __flush_tlb_one() only flushes the local TLB (which
> > >>>> I think is enough here).
> > >>>
> > >>> That sounds suspicious; I don't think that __flush_tlb_one() is
> > >>> sufficient.
> > >>>
> > >>> If you only do local TLB maintenance, then the page is left accessible
> > >>> to other CPUs via the (stale) kernel mappings. i.e. the page isn't
> > >>> exclusively mapped by userspace.
> > >>
> > >> We flush all CPUs to get rid of stale entries when a new page is
> > >> allocated to userspace that was previously allocated to the kernel.
> > >> Is that the scenario you were thinking of?
> > > 
> > > I think there are two cases, the one you describe above, where the
> > > pages are first allocated, and a second one, where e.g. the pages are
> > > mapped into the kernel because of DMA or whatever. In the case you
> > > describe above, I think we're doing the right thing (which is why my
> > > test worked correctly, because it tested this case).
> > > 
> > > In the second case, when the pages are unmapped (i.e. the kernel is
> > > done doing DMA), do we need to flush the other CPUs TLBs? I think the
> > > current code is not quite correct, because if multiple tasks (CPUs)
> > > map the pages, only the TLB of the last one is flushed when the
> > > mapping is cleared, because the tlb is only flushed when ->mapcount
> > > drops to zero, leaving stale entries in the other TLBs. It's not clear
> > > to me what to do about this case.
> > 
> > For this to happen, multiple CPUs need to have the same userspace page
> > mapped at the same time. Is this a valid scenario?
> 
> I believe so. I think you could trigger that with a multi-threaded
> application running across several CPUs. All those threads would share
> the same page tables.

I played around with trying to track this per-cpu, and I'm not sure
there's a nice way to do it (see the patch below, and the comment
about correctness [never mind that this patch calls alloc_percpu from
a possibly atomic context]).

I think it may be best to just flush all the TLBs of the DMA range
when the last task unmaps it. This would leave a small exploitable
race where a task had mapped/unmapped the page, but some other page
still had it mapped.

If anyone has any better ideas please let me know, otherwise I'll just
flush all the TLBs when the use count drops to zero, and post the next
version Soon (TM).

Cheers,

Tycho



>From a3a8f9da00bed910e086805f3e71b9e5e1b898b4 Mon Sep 17 00:00:00 2001
From: Tycho Andersen <tycho@docker.com>
Date: Thu, 31 Aug 2017 15:03:06 -0600
Subject: [PATCH] draft of per-cpu flush flag

Signed-off-by: Tycho Andersen <tycho@docker.com>
---
 mm/xpfo.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 70 insertions(+), 8 deletions(-)

diff --git a/mm/xpfo.c b/mm/xpfo.c
index 0b178ad5a37e..5f9aeaaa40d2 100644
--- a/mm/xpfo.c
+++ b/mm/xpfo.c
@@ -31,6 +31,8 @@ struct xpfo {
 	bool inited;		/* Map counter and lock initialized */
 	atomic_t mapcount;	/* Counter for balancing map/unmap requests */
 	spinlock_t maplock;	/* Lock to serialize map/unmap requests */
+	void *mapped;           /* per-cpu variable to indicate whether this
+	                           CPU has mapped this page or not */
 };
 
 DEFINE_STATIC_KEY_FALSE(xpfo_inited);
@@ -78,6 +80,43 @@ static inline struct xpfo *lookup_xpfo(struct page *page)
 	return (void *)page_ext + page_xpfo_ops.offset;
 }
 
+/*
+ * Return the map status of this page. Note that the cpu needs to be pinned,
+ * either via get_cpu() or a spin lock.
+ */
+static bool xpfo_test_unmapped(struct xpfo *xpfo)
+{
+	if (!xpfo->mapped) {
+		return test_bit(XPFO_PAGE_UNMAPPED, &xpfo->flags);
+	} else {
+		return *(bool *)per_cpu_ptr(xpfo->mapped,
+					    smp_processor_id());
+	}
+}
+
+/*
+ * Set the unmapped status of this page. Returns the previous state. Note that
+ * the cpu needs to be pinnned, either via get_cpu() or a spin lock.
+ */
+static bool xpfo_test_set_unmapped(struct xpfo *xpfo, bool unmapped)
+{
+	if (!xpfo->mapped) {
+		if (unmapped)
+			return test_and_set_bit(XPFO_PAGE_UNMAPPED, &xpfo->flags);
+		else
+			return test_and_clear_bit(XPFO_PAGE_UNMAPPED, &xpfo->flags);
+	} else {
+		bool *p, prev;
+
+		p = per_cpu_ptr(xpfo->mapped, smp_processor_id());
+		prev = *p;
+		*p = unmapped;
+
+		return prev;
+	}
+}
+
+
 void xpfo_alloc_pages(struct page *page, int order, gfp_t gfp)
 {
 	int i, flush_tlb = 0;
@@ -91,7 +130,7 @@ void xpfo_alloc_pages(struct page *page, int order, gfp_t gfp)
 		if (!xpfo)
 			continue;
 
-		WARN(test_bit(XPFO_PAGE_UNMAPPED, &xpfo->flags),
+		WARN(xpfo_test_unmapped(xpfo),
 		     "xpfo: unmapped page being allocated\n");
 
 		/* Initialize the map lock and map counter */
@@ -99,7 +138,9 @@ void xpfo_alloc_pages(struct page *page, int order, gfp_t gfp)
 			spin_lock_init(&xpfo->maplock);
 			atomic_set(&xpfo->mapcount, 0);
 			xpfo->inited = true;
+			xpfo->mapped = NULL;
 		}
+
 		WARN(atomic_read(&xpfo->mapcount),
 		     "xpfo: already mapped page being allocated\n");
 
@@ -168,13 +209,19 @@ void xpfo_kmap(void *kaddr, struct page *page)
 		return;
 
 	spin_lock(&xpfo->maplock);
+	if (!xpfo->mapped) {
+		xpfo->mapped = alloc_percpu(bool);
+		if (!xpfo->mapped)
+			WARN_ON("xpfo: percpu flag allocation failed\n");
+	}
 
 	/*
 	 * The page was previously allocated to user space, so map it back
 	 * into the kernel. No TLB flush required.
 	 */
-	if ((atomic_inc_return(&xpfo->mapcount) == 1) &&
-	    test_and_clear_bit(XPFO_PAGE_UNMAPPED, &xpfo->flags))
+	xpfo_test_set_unmapped(xpfo, false);
+
+	if (atomic_inc_return(&xpfo->mapcount) == 1)
 		set_kpte(kaddr, page, PAGE_KERNEL);
 
 	spin_unlock(&xpfo->maplock);
@@ -205,10 +252,25 @@ void xpfo_kunmap(void *kaddr, struct page *page)
 	 * The page is to be allocated back to user space, so unmap it from the
 	 * kernel, flush the TLB and tag it as a user page.
 	 */
-	if (atomic_dec_return(&xpfo->mapcount) == 0) {
-		WARN(test_bit(XPFO_PAGE_UNMAPPED, &xpfo->flags),
-		     "xpfo: unmapping already unmapped page\n");
-		set_bit(XPFO_PAGE_UNMAPPED, &xpfo->flags);
+	if (xpfo->mapped) {
+		/*
+		 * We have a per-cpu map, and we know it is mapped on this
+		 * process, so let's flush our local TLB.
+		 */
+		xpfo_test_set_unmapped(xpfo, true);
+
+		/*
+		 * I think this is incorrect -- the page should still be mapped
+		 * by the other cpus, it's just the TLB entry here is a bit stale.
+		 */
+		set_kpte(kaddr, page, __pgprot(0));
+		__flush_tlb_one((unsigned long) kaddr);
+	} else if (atomic_dec_return(&xpfo->mapcount) == 0) {
+		/*
+		 * No per-cpu map, so let's just do a best effort and
+		 * unmap/flush all the TLBs when the count reaches 0.
+		 */
+		xpfo_test_set_unmapped(xpfo, true);
 		set_kpte(kaddr, page, __pgprot(0));
 		flush_tlb_kernel_range((unsigned long) kaddr,
 				       (unsigned long) kaddr + PAGE_SIZE);
@@ -229,7 +291,7 @@ bool xpfo_page_is_unmapped(struct page *page)
 	if (unlikely(!xpfo) && !xpfo->inited)
 		return false;
 
-	return test_bit(XPFO_PAGE_UNMAPPED, &xpfo->flags);
+	return xpfo_test_unmapped(xpfo);
 }
 EXPORT_SYMBOL(xpfo_page_is_unmapped);
 
-- 
2.11.0
