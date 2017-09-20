References: <20170809200755.11234-1-tycho@docker.com>
 <20170809200755.11234-4-tycho@docker.com>
 <5877eed8-0e8e-0dec-fdc7-de01bdbdafa8@intel.com>
 <20170920224739.3kgzmntabmkedohw@smitten>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <370bb00d-8c1c-1a69-7c7f-f6135b16b4fa@intel.com>
Date: Wed, 20 Sep 2017 16:25:48 -0700
MIME-Version: 1.0
In-Reply-To: <20170920224739.3kgzmntabmkedohw@smitten>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v5 03/10] swiotlb: Map the buffer if it was unmapped by
 XPFO
To: Tycho Andersen <tycho@docker.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, Juerg Haefliger <juerg.haefliger@hpe.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 09/20/2017 03:47 PM, Tycho Andersen wrote:
> 
>>> static inline void *skcipher_map(struct scatter_walk *walk)
>>> {
>>>         struct page *page = scatterwalk_page(walk);
>>>
>>>         return (PageHighMem(page) ? kmap_atomic(page) : page_address(page)) +
>>>                offset_in_page(walk->offset);
>>> }
>> Is there any better way to catch these?  Like, can we add some debugging
>> to check for XPFO pages in __va()?
> Yes, and perhaps also a debugging check in PageHighMem?

I'm not sure what PageHighMem() would check.  It's OK to use as long as
you don't depend on the contents of the page.
		
> Would __va have caught either of the two cases you've pointed out?
Yes.  __va() is what is eventually called by lowmem_page_address(),
which is only OK to call on things that are actually mapped into the kernel.
