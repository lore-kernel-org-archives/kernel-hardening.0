Date: Fri, 8 Sep 2017 00:53:47 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170908075347.GC4957@infradead.org>
References: <20170907173609.22696-1-tycho@docker.com>
 <20170907173609.22696-6-tycho@docker.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907173609.22696-6-tycho@docker.com>
Subject: [kernel-hardening] Re: [PATCH v6 05/11] arm64/mm: Add support for XPFO
To: Tycho Andersen <tycho@docker.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

> +/*
> + * Lookup the page table entry for a virtual address and return a pointer to
> + * the entry. Based on x86 tree.
> + */
> +static pte_t *lookup_address(unsigned long addr)

Seems like this should be moved to common arm64 mm code and used by
kernel_page_present.
