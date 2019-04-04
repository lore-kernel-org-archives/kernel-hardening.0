Date: Thu, 4 Apr 2019 09:56:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH v9 11/13] xpfo, mm: optimize spinlock usage in
 xpfo_kunmap
Message-ID: <20190404075648.GQ4038@hirez.programming.kicks-ass.net>
References: <cover.1554248001.git.khalid.aziz@oracle.com>
 <5bab13e12d4215112ad2180106cc6bb9b513754a.1554248002.git.khalid.aziz@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bab13e12d4215112ad2180106cc6bb9b513754a.1554248002.git.khalid.aziz@oracle.com>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: juergh@gmail.com, tycho@tycho.ws, jsteckli@amazon.de, ak@linux.intel.com, liran.alon@oracle.com, keescook@google.com, konrad.wilk@oracle.com, deepa.srinivasan@oracle.com, chris.hyser@oracle.com, tyhicks@canonical.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com, jcm@redhat.com, boris.ostrovsky@oracle.com, kanth.ghatraju@oracle.com, joao.m.martins@oracle.com, jmattson@google.com, pradeep.vincent@oracle.com, john.haxby@oracle.com, tglx@linutronix.de, kirill.shutemov@linux.intel.com, hch@lst.de, steven.sistare@oracle.com, labbott@redhat.com, luto@kernel.org, dave.hansen@intel.com, aaron.lu@intel.com, akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com, amir73il@gmail.com, andreyknvl@google.com, aneesh.kumar@linux.ibm.com, anthony.yznaga@oracle.com, ard.biesheuvel@linaro.org, arnd@arndb.de, arunks@codeaurora.org, ben@decadent.org.uk, bigeasy@linutronix.de, bp@alien8.de, brgl@bgdev.pl, catalin.marinas@arm.com, corbet@lwn.net, cpandya@codeaurora.org, daniel.vetter@ffwll.ch, dan.j.williams@intel.com, gregkh@linuxfoundation.org, guro@fb.com, hannes@cmpxchg.org, hpa@zytor.com, iamjoonsoo.kim@lge.com, james.morse@arm.com, jannh@google.com, jgross@suse.com, jkosina@suse.cz, jmorris@namei.org, joe@perches.com, jrdr.linux@gmail.com, jroedel@suse.de, keith.busch@intel.com, khlebnikov@yandex-team.ru, logang@deltatee.com, marco.antonio.780@gmail.com, mark.rutland@arm.com, mgorman@techsingularity.net, mhocko@suse.com, mhocko@suse.cz, mike.kravetz@oracle.com, mingo@redhat.com, mst@redhat.com, m.szyprowski@samsung.com, npiggin@gmail.com, osalvador@suse.de, paulmck@linux.vnet.ibm.com, pavel.tatashin@microsoft.com, rdunlap@infradead.org, richard.weiyang@gmail.com, riel@surriel.com, rientjes@google.com, robin.murphy@arm.com, rostedt@goodmis.org, rppt@linux.vnet.ibm.com, sai.praneeth.prakhya@intel.com, serge@hallyn.com, steve.capper@arm.com, thymovanbeers@gmail.com, vbabka@suse.cz, will.deacon@arm.com, willy@infradead.org, yang.shi@linux.alibaba.com, yaojun8558363@gmail.com, ying.huang@intel.com, zhangshaokun@hisilicon.com, iommu@lists.linux-foundation.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, Khalid Aziz <khalid@gonehiking.org>, kernel-hardening@lists.openwall.com, "Vasileios P . Kemerlis" <vpk@cs.columbia.edu>, Juerg Haefliger <juerg.haefliger@canonical.com>, David Woodhouse <dwmw2@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 03, 2019 at 11:34:12AM -0600, Khalid Aziz wrote:
> From: Julian Stecklina <jsteckli@amazon.de>
> 
> Only the xpfo_kunmap call that needs to actually unmap the page
> needs to be serialized. We need to be careful to handle the case,
> where after the atomic decrement of the mapcount, a xpfo_kmap
> increased the mapcount again. In this case, we can safely skip
> modifying the page table.
> 
> Model-checked with up to 4 concurrent callers with Spin.
> 
> Signed-off-by: Julian Stecklina <jsteckli@amazon.de>
> Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
> Cc: Khalid Aziz <khalid@gonehiking.org>
> Cc: x86@kernel.org
> Cc: kernel-hardening@lists.openwall.com
> Cc: Vasileios P. Kemerlis <vpk@cs.columbia.edu>
> Cc: Juerg Haefliger <juerg.haefliger@canonical.com>
> Cc: Tycho Andersen <tycho@tycho.ws>
> Cc: Marco Benatto <marco.antonio.780@gmail.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> ---
>  include/linux/xpfo.h | 24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/xpfo.h b/include/linux/xpfo.h
> index 2318c7eb5fb7..37e7f52fa6ce 100644
> --- a/include/linux/xpfo.h
> +++ b/include/linux/xpfo.h
> @@ -61,6 +61,7 @@ static inline void xpfo_kmap(void *kaddr, struct page *page)
>  static inline void xpfo_kunmap(void *kaddr, struct page *page)
>  {
>  	unsigned long flags;
> +	bool flush_tlb = false;
>  
>  	if (!static_branch_unlikely(&xpfo_inited))
>  		return;
> @@ -72,18 +73,23 @@ static inline void xpfo_kunmap(void *kaddr, struct page *page)
>  	 * The page is to be allocated back to user space, so unmap it from
>  	 * the kernel, flush the TLB and tag it as a user page.
>  	 */
> -	spin_lock_irqsave(&page->xpfo_lock, flags);
> -
>  	if (atomic_dec_return(&page->xpfo_mapcount) == 0) {
> -#ifdef CONFIG_XPFO_DEBUG
> -		WARN_ON(PageXpfoUnmapped(page));
> -#endif
> -		SetPageXpfoUnmapped(page);
> -		set_kpte(kaddr, page, __pgprot(0));
> -		xpfo_flush_kernel_tlb(page, 0);
> +		spin_lock_irqsave(&page->xpfo_lock, flags);
> +
> +		/*
> +		 * In the case, where we raced with kmap after the
> +		 * atomic_dec_return, we must not nuke the mapping.
> +		 */
> +		if (atomic_read(&page->xpfo_mapcount) == 0) {
> +			SetPageXpfoUnmapped(page);
> +			set_kpte(kaddr, page, __pgprot(0));
> +			flush_tlb = true;
> +		}
> +		spin_unlock_irqrestore(&page->xpfo_lock, flags);
>  	}
>  
> -	spin_unlock_irqrestore(&page->xpfo_lock, flags);
> +	if (flush_tlb)
> +		xpfo_flush_kernel_tlb(page, 0);
>  }

This doesn't help with the TLB invalidation issue, AFAICT this is still
completely buggered. kunmap_atomic() can be called from IRQ context.
