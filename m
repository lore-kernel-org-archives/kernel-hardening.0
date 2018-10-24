Subject: Re: [PATCH 08/17] prmem: struct page: track vmap_area
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-9-igor.stoppa@huawei.com>
 <20181024031200.GC25444@bombadil.infradead.org>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <ffb887e1-2029-42d5-3a97-54546e4d28d8@gmail.com>
Date: Thu, 25 Oct 2018 02:01:02 +0300
MIME-Version: 1.0
In-Reply-To: <20181024031200.GC25444@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Pavel Tatashin <pasha.tatashin@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>



On 24/10/2018 06:12, Matthew Wilcox wrote:
> On Wed, Oct 24, 2018 at 12:34:55AM +0300, Igor Stoppa wrote:
>> The connection between each page and its vmap_area avoids more expensive
>> searches through the btree of vmap_areas.
> 
> Typo -- it's an rbtree.

ack

>> +++ b/include/linux/mm_types.h
>> @@ -87,13 +87,24 @@ struct page {
>>   			/* See page-flags.h for PAGE_MAPPING_FLAGS */
>>   			struct address_space *mapping;
>>   			pgoff_t index;		/* Our offset within mapping. */
>> -			/**
>> -			 * @private: Mapping-private opaque data.
>> -			 * Usually used for buffer_heads if PagePrivate.
>> -			 * Used for swp_entry_t if PageSwapCache.
>> -			 * Indicates order in the buddy system if PageBuddy.
>> -			 */
>> -			unsigned long private;
>> +			union {
>> +				/**
>> +				 * @private: Mapping-private opaque data.
>> +				 * Usually used for buffer_heads if
>> +				 * PagePrivate.
>> +				 * Used for swp_entry_t if PageSwapCache.
>> +				 * Indicates order in the buddy system if
>> +				 * PageBuddy.
>> +				 */
>> +				unsigned long private;
>> +				/**
>> +				 * @area: reference to the containing area
>> +				 * For pages that are mapped into a virtually
>> +				 * contiguous area, avoids performing a more
>> +				 * expensive lookup.
>> +				 */
>> +				struct vmap_area *area;
>> +			};
> 
> Not like this.  Make it part of a different struct in the existing union,
> not a part of the pagecache struct.  And there's no need to use ->private
> explicitly.

Ok, I'll have a look at the googledoc you made

>> @@ -1747,6 +1750,10 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
>>   	if (!addr)
>>   		return NULL;
>>   
>> +	va = __find_vmap_area((unsigned long)addr);
>> +	for (i = 0; i < va->vm->nr_pages; i++)
>> +		va->vm->pages[i]->area = va;
> 
> I don't like it that you're calling this for _every_ vmalloc() caller
> when most of them will never use this.  Perhaps have page->va be initially
> NULL and then cache the lookup in it when it's accessed for the first time.
> 

If __find_vmap_area() was part of the API, this loop could be left out 
from __vmalloc_node_range() and the user of the allocation could 
initialize the field, if needed.

What is the reason for keeping __find_vmap_area() private?

--
igor
