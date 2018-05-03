Subject: Re: Correct way to access the physmap? - Was: Re: [PATCH 7/9] Pmalloc
 Rare Write: modify selected pools
References: <20180423125458.5338-1-igor.stoppa@huawei.com>
 <20180423125458.5338-8-igor.stoppa@huawei.com>
 <20180424115050.GD26636@bombadil.infradead.org>
 <035f2bba-ebb1-06a0-fb88-3d40f7e484a7@gmail.com>
 <ef116557-1fb1-780e-2480-3eef9052b609@intel.com>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <91ca0b5e-0719-7ebf-4e11-8b17f54251fe@gmail.com>
Date: Fri, 4 May 2018 02:52:22 +0400
MIME-Version: 1.0
In-Reply-To: <ef116557-1fb1-780e-2480-3eef9052b609@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Dave Hansen <dave.hansen@intel.com>, Matthew Wilcox <willy@infradead.org>
Cc: linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Igor Stoppa <igor.stoppa@huawei.com>
List-ID: <kernel-hardening.lists.openwall.com>



On 04/05/18 01:55, Dave Hansen wrote:
> On 05/03/2018 02:52 PM, Igor Stoppa wrote:
>> At the end of the summit, we agreed that I would go through the physmap.
> 
> Do you mean the kernel linear map? 

Apparently I did mean it. It was confusing, because I couldn't find a 
single place stating it explicitly, like you just did.

> That's just another name for the
> virtual address that you get back from page_to_virt():
> 
> 	int *j = page_to_virt(vmalloc_to_page(i));
> 

One reason why I was not sure is that also the linear mapping gets 
protected, when I protect hte corresponding page in the vmap_area:

if i do:

int *i = vmalloc(sizeof(int));
int *j = page_to_virt(vmalloc_to_page(i));
*i = 1;
set_memory_ro(i, 1);
*j = 2;

I get an error, because also *j has become read only.
I was expecting to have to do the protection of the linear mapping in a 
second phase.

It turns out that - at least on x86_64 - it's already in place.

But it invalidates what we agreed, which was based on the assumption 
that the linear mapping was writable all the time.

I see two options:

1) continue to go through the linear mapping, unprotecting it for the 
time it takes to make the write.

2) use the code I already wrote, which creates an additional, temporary 
mapping in R/W mode at a random address.


I'd prefer 2) because it is already designed to make life harder for 
someone trying to attack the data in the page: even if one manages to 
take over a core and busy loop on it, option 2) will use a random 
temporary address, that is harder to figure out.

Option 1) re-uses the linear mapping and therefore the attacker really 
only needs to get lucky and, depending on the target, write over some 
other data that was in the same page being unprotected, or overwrite the 
same data being updated, after the update has taken place.


Is there any objection if I continue with options 2?

--
igor
