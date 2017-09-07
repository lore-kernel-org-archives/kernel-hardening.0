Date: Thu, 7 Sep 2017 11:10:15 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170907181015.GA9557@infradead.org>
References: <20170907173609.22696-1-tycho@docker.com>
 <20170907173609.22696-5-tycho@docker.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907173609.22696-5-tycho@docker.com>
Subject: [kernel-hardening] Re: [PATCH v6 04/11] swiotlb: Map the buffer if it was unmapped by
 XPFO
To: Tycho Andersen <tycho@docker.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
List-ID: <kernel-hardening.lists.openwall.com>

> -	if (PageHighMem(pfn_to_page(pfn))) {
> +	if (PageHighMem(page) || xpfo_page_is_unmapped(page)) {

Please don't sprinkle xpfo details over various bits of code.

Just add a helper with a descriptive name, e.g.

page_is_unmapped()

that also includes the highmem case, as that will easily document
what this check is doing.
