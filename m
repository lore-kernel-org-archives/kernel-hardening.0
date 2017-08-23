Date: Wed, 23 Aug 2017 18:04:43 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170823170443.GD12567@leverpostej>
References: <20170809200755.11234-1-tycho@docker.com>
 <20170809200755.11234-5-tycho@docker.com>
 <20170812112603.GB16374@remoulade>
 <20170814163536.6njceqc3dip5lrlu@smitten>
 <20170814165047.GB23428@leverpostej>
 <20170823165842.k5lbxom45avvd7g2@smitten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170823165842.k5lbxom45avvd7g2@smitten>
Subject: Re: [kernel-hardening] [PATCH v5 04/10] arm64: Add __flush_tlb_one()
To: Tycho Andersen <tycho@docker.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 23, 2017 at 10:58:42AM -0600, Tycho Andersen wrote:
> Hi Mark,
> 
> On Mon, Aug 14, 2017 at 05:50:47PM +0100, Mark Rutland wrote:
> > That said, is there any reason not to use flush_tlb_kernel_range()
> > directly?
> 
> So it turns out that there is a difference between __flush_tlb_one() and
> flush_tlb_kernel_range() on x86: flush_tlb_kernel_range() flushes all the TLBs
> via on_each_cpu(), where as __flush_tlb_one() only flushes the local TLB (which
> I think is enough here).

That sounds suspicious; I don't think that __flush_tlb_one() is
sufficient.

If you only do local TLB maintenance, then the page is left accessible
to other CPUs via the (stale) kernel mappings. i.e. the page isn't
exclusively mapped by userspace.

Thanks,
Mark.
