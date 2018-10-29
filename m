Subject: Re: [PATCH 10/17] prmem: documentation
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-11-igor.stoppa@huawei.com>
 <20181026092609.GB3159@worktop.c.hoisthospitality.com>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <cb42d84d-082a-e1e5-7b71-95c2c4a44d0e@gmail.com>
Date: Mon, 29 Oct 2018 22:35:42 +0200
MIME-Version: 1.0
In-Reply-To: <20181026092609.GB3159@worktop.c.hoisthospitality.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 26/10/2018 10:26, Peter Zijlstra wrote:

>> +- Kernel code is protected at system level and, unlike data, it doesn't
>> +  require special attention.
> 
> What does this even mean?

I was trying to convey the notion that the pages containing kernel code 
do not require any special handling by the author of a generic kernel 
component, for example a kernel driver.

Pages containing either statically or dynamically allocated data, 
instead, are not automatically protected.

But yes, the sentence is far from being clear.

> 
>> +Protection mechanism
>> +--------------------
>> +
>> +- When available, the MMU can write protect memory pages that would be
>> +  otherwise writable.
> 
> Again; what does this really want to say?

That it is possible to use the MMU also for write-protecting pages 
containing data which was not declared as constant.
> 
>> +- The protection has page-level granularity.
> 
> I don't think Linux supports non-paging MMUs.

This probably came from a model I had in mind where a separate execution 
environment, such as an hypervisor, could trap and filter writes to a 
certain parts of a page, rejecting some and performing others, 
effectively emulating sub-page granularity.

> 
>> +- An attempt to overwrite a protected page will trigger an exception.
>> +- **Write protected data must go exclusively to write protected pages**
>> +- **Writable data must go exclusively to writable pages**
> 
> WTH is with all those ** ?

[...]

> Can we ditch all the ** nonsense and put whitespace in there? More paragraphs
> and whitespace are more good.

Yes

> Also, I really don't like how you differentiate between static and
> dynamic wr.

ok, but why? what would you suggest, instead?

[...]

> We already have RO, why do you need more RO?

I can explain, but I'm at loss of what is the best place: I was under 
the impression that this sort of document should focus mostly on the API 
and its use. I was even considering removing most of the explanation and 
instead put it in a separate document.

> 
>> +
>> +   **Remarks:**
>> +    - The "AUTO" modes perform automatic protection of the content, whenever
>> +       the current vmap_area is used up and a new one is allocated.
>> +        - At that point, the vmap_area being phased out is protected.
>> +        - The size of the vmap_area depends on various parameters.
>> +        - It might not be possible to know for sure *when* certain data will
>> +          be protected.
> 
> Surely that is a problem?
> 
>> +        - The functionality is provided as tradeoff between hardening and speed.
> 
> Which you fail to explain.
> 
>> +        - Its usefulness depends on the specific use case at hand
> 
> How about you write sensible text inside the option descriptions
> instead?
> 
> This is not a presentation; less bullets, more content.

I tried to say something, without saying too much, but it was clearly a 
bad choice.

Where should i put a thoroughly detailed explanation?
Here or in a separate document?

> 
>> +- Not only the pmalloc memory must be protected, but also any reference to
>> +  it that might become the target for an attack. The attack would replace
>> +  a reference to the protected memory with a reference to some other,
>> +  unprotected, memory.
> 
> I still don't really understand the whole write-rare thing; how does it
> really help? If we can write in kernel memory, we can write to
> page-tables too.

It has already been answered by Kees, but I'll provide also my answer:

the exploits used to write in kernel memory are specific to certain 
products and SW builds, so it's not possible to generalize too much, 
however there might be some limitation in the reach of a specific 
vulnerability. For example, if a memory location is referred to as 
offset from a base address, the maximum size of the offset limits the 
scope of the attack. Which might make it impossible to use that specific 
vulnerability for writing directly to the page table. But something 
else, say a statically allocated variable, might be within reach.

said this, there is also the almost orthogonal use case of providing 
increased robustness by trapping accidental modifications, caused by bugs.

> And I don't think this document even begins to explain _why_ you're
> doing any of this. How does it help?

ok, point taken

>> +- The users of rare write must take care of ensuring the atomicity of the
>> +  action, respect to the way they use the data being altered; for example,
>> +  take a lock before making a copy of the value to modify (if it's
>> +  relevant), then alter it, issue the call to rare write and finally
>> +  release the lock. Some special scenario might be exempt from the need
>> +  for locking, but in general rare-write must be treated as an operation
>> +  that can incur into races.
> 
> What?!

Probably something along the lines of:

"users of write-rare are responsible of using mechanisms that allow 
reading/writing data in a consistent way"

and if it seems obvious, I can just drop it.

One of the problems I have faced is to decide what level of knowledge or 
understanding I should expect from the reader of such document: what I 
can take for granted and what I should explain.

--
igor
