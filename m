Date: Wed, 20 Sep 2017 19:37:12 -0600
From: Tycho Andersen <tycho@docker.com>
Message-ID: <20170921013712.lznwkkmdmp64vaiq@docker>
References: <20170907173609.22696-1-tycho@docker.com>
 <20170907173609.22696-4-tycho@docker.com>
 <34454a32-72c2-c62e-546c-1837e05327e1@intel.com>
 <20170920223452.vam3egenc533rcta@smitten>
 <97475308-1f3d-ea91-5647-39231f3b40e5@intel.com>
 <20170921000901.v7zo4g5edhqqfabm@docker>
 <d1a35583-8225-2ab3-d9fa-273482615d09@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1a35583-8225-2ab3-d9fa-273482615d09@intel.com>
Subject: [kernel-hardening] Re: [PATCH v6 03/11] mm, x86: Add support for eXclusive Page Frame
 Ownership (XPFO)
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Sep 20, 2017 at 05:27:02PM -0700, Dave Hansen wrote:
> On 09/20/2017 05:09 PM, Tycho Andersen wrote:
> >> I think the only thing that will really help here is if you batch the
> >> allocations.  For instance, you could make sure that the per-cpu-pageset
> >> lists always contain either all kernel or all user data.  Then remap the
> >> entire list at once and do a single flush after the entire list is consumed.
> > Just so I understand, the idea would be that we only flush when the
> > type of allocation alternates, so:
> > 
> > kmalloc(..., GFP_KERNEL);
> > kmalloc(..., GFP_KERNEL);
> > /* remap+flush here */
> > kmalloc(..., GFP_HIGHUSER);
> > /* remap+flush here */
> > kmalloc(..., GFP_KERNEL);
> 
> Not really.  We keep a free list per migrate type, and a per_cpu_pages
> (pcp) list per migratetype:
> 
> > struct per_cpu_pages {
> >         int count;              /* number of pages in the list */
> >         int high;               /* high watermark, emptying needed */
> >         int batch;              /* chunk size for buddy add/remove */
> > 
> >         /* Lists of pages, one per migrate type stored on the pcp-lists */
> >         struct list_head lists[MIGRATE_PCPTYPES];
> > };
> 
> The migratetype is derived from the GFP flags in
> gfpflags_to_migratetype().  In general, GFP_HIGHUSER and GFP_KERNEL come
> from different migratetypes, so they come from different free lists.
> 
> In your case above, the GFP_HIGHUSER allocation come through the
> MIGRATE_MOVABLE pcp list while the GFP_KERNEL ones come from the
> MIGRATE_UNMOVABLE one.  Since we add a bunch of pages to those lists at
> once, you could do all the mapping/unmapping/flushing on a bunch of
> pages at once
> 
> Or, you could hook your code into the places where the migratetype of
> memory is changed (set_pageblock_migratetype(), plus where we fall
> back).  Those changes are much more rare than page allocation.

I see, thanks for all this discussion. It has been very helpful!

Tycho
