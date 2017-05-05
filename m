Sender: Tejun Heo <htejun@gmail.com>
Date: Fri, 5 May 2017 12:16:11 -0400
From: Tejun Heo <tj@kernel.org>
Message-ID: <20170505161611.GB14137@wtj.duckdns.org>
References: <20170504221551.6458-1-tycho@docker.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170504221551.6458-1-tycho@docker.com>
Subject: [kernel-hardening] Re: [PATCH v2] ata-sff: always map page before data transfer
To: Tycho Andersen <tycho@docker.com>
Cc: Juerg Haefliger <juerg.haefliger@hpe.com>, Christoph Hellwig <hch@infradead.org>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 04, 2017 at 04:15:51PM -0600, Tycho Andersen wrote:
> The XPFO [1] patchset may unmap pages from physmap if they happened to be
> destined for userspace. If such a page is unmapped, it needs to be
> remapped. Rather than test if a page is in the highmem/xpfo unmapped state,
> Christoph suggested [2] that we simply always map the page.
> 
> v2: * drop comment about bounce buffer
>     * don't save IRQs before kmap/unmap
>     * formatting
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Tycho Andersen <tycho@docker.com>
> CC: Juerg Haefliger <juerg.haefliger@hpe.com>
> CC: Tejun Heo <tj@kernel.org>
> 
> [1]: https://lkml.org/lkml/2016/11/4/245
> [2]: https://lkml.org/lkml/2016/11/4/253

Yeah, it's a nice cleanup.

Applied to libata/for-4.13.

Thanks.

-- 
tejun
