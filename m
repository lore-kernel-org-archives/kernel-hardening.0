References: <20170907173609.22696-1-tycho@docker.com>
 <20170907173609.22696-4-tycho@docker.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <55fa9707-a623-90bd-a0a1-e45920e94103@intel.com>
Date: Wed, 20 Sep 2017 17:03:28 -0700
MIME-Version: 1.0
In-Reply-To: <20170907173609.22696-4-tycho@docker.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v6 03/11] mm, x86: Add support for eXclusive Page Frame
 Ownership (XPFO)
To: Tycho Andersen <tycho@docker.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 09/07/2017 10:36 AM, Tycho Andersen wrote:
> +		/*
> +		 * Map the page back into the kernel if it was previously
> +		 * allocated to user space.
> +		 */
> +		if (test_and_clear_bit(XPFO_PAGE_USER, &xpfo->flags)) {
> +			clear_bit(XPFO_PAGE_UNMAPPED, &xpfo->flags);
> +			set_kpte(page_address(page + i), page + i,
> +				 PAGE_KERNEL);
> +		}
> +	}

It might also be a really good idea to clear the page here.  Otherwise,
the page still might have attack code in it and now it is mapped into
the kernel again, ready to be exploited.

Think of it this way: pages either trusted data and are mapped all the
time, or they have potentially bad data and are unmapped mostly.  If we
want to take a bad page and map it always, we have to make sure the
contents are not evil.  0's are not evil.

>  static inline void *kmap(struct page *page)
>  {
> +	void *kaddr;
> +
>  	might_sleep();
> -	return page_address(page);
> +	kaddr = page_address(page);
> +	xpfo_kmap(kaddr, page);
> +	return kaddr;
>  }

The time between kmap() and kunmap() is potentially a really long
operation.  I think we, for instance, keep some pages kmap()'d while we
do I/O to them, or wait for I/O elsewhere.

IOW, this will map predictable data at a predictable location and it
will do it for a long time.  While that's better than the current state
(mapped always), it still seems rather risky.

Could you, for instance, turn kmap(page) into vmap(&page, 1, ...)?  That
way, at least the address may be different each time.  Even if an
attacker knows the physical address, they don't know where it will be
mapped.
