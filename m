Date: Fri, 8 Sep 2017 00:42:16 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170908074216.GA4957@infradead.org>
References: <20170907173609.22696-1-tycho@docker.com>
 <20170907173609.22696-2-tycho@docker.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907173609.22696-2-tycho@docker.com>
Subject: [kernel-hardening] Re: [PATCH v6 01/11] mm: add MAP_HUGETLB support to vm_mmap
To: Tycho Andersen <tycho@docker.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Sep 07, 2017 at 11:35:59AM -0600, Tycho Andersen wrote:
> vm_mmap is exported, which means kernel modules can use it. In particular,
> for testing XPFO support, we want to use it with the MAP_HUGETLB flag, so
> let's support it via vm_mmap.

>  	} else if (flags & MAP_HUGETLB) {
> +		file = map_hugetlb_setup(&len, flags);
>  		if (IS_ERR(file))
>  			return PTR_ERR(file);
>  	}

It seems like you should remove this hunk entirely and make all
MAP_HUGETLB calls go through vm_mmap.
