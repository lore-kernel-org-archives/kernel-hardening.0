Reply-To: kernel-hardening@lists.openwall.com
References: <20160902113909.32631-1-juerg.haefliger@hpe.com>
 <20160914071901.8127-1-juerg.haefliger@hpe.com>
 <20160914071901.8127-3-juerg.haefliger@hpe.com> <57D95FA3.3030103@intel.com>
 <7badeb6c-e343-4327-29ed-f9c9c0b6654b@hpe.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <57D9633A.2010702@intel.com>
Date: Wed, 14 Sep 2016 07:48:26 -0700
MIME-Version: 1.0
In-Reply-To: <7badeb6c-e343-4327-29ed-f9c9c0b6654b@hpe.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC PATCH v2 2/3] xpfo: Only put previous
 userspace pages into the hot cache
To: Juerg Haefliger <juerg.haefliger@hpe.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-x86_64@vger.kernel.org
Cc: vpk@cs.columbia.edu
List-ID: <kernel-hardening.lists.openwall.com>

> On 09/02/2016 10:39 PM, Dave Hansen wrote:
>> On 09/02/2016 04:39 AM, Juerg Haefliger wrote:
>> Does this
>> just mean that kernel allocations usually have to pay the penalty to
>> convert a page?
> 
> Only pages that are allocated for userspace (gfp & GFP_HIGHUSER == GFP_HIGHUSER) which were
> previously allocated for the kernel (gfp & GFP_HIGHUSER != GFP_HIGHUSER) have to pay the penalty.
> 
>> So, what's the logic here?  You're assuming that order-0 kernel
>> allocations are more rare than allocations for userspace?
> 
> The logic is to put reclaimed kernel pages into the cold cache to
> postpone their allocation as long as possible to minimize (potential)
> TLB flushes.

OK, but if we put them in the cold area but kernel allocations pull them
from the hot cache, aren't we virtually guaranteeing that kernel
allocations will have to to TLB shootdown to convert a page?

It seems like you also need to convert all kernel allocations to pull
from the cold area.
