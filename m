Subject: Re: [PATCH 04/12] __wr_after_init: x86_64: __wr_op
References: <20181219213338.26619-1-igor.stoppa@huawei.com>
 <20181219213338.26619-5-igor.stoppa@huawei.com>
 <20181220184917.GY10600@bombadil.infradead.org>
 <d5e8523a-3afd-d992-1af3-b329985c5ed5@gmail.com>
 <CALCETrU8GZbF2oWYeKUVKBURuh1zeMqcHM5RMTchiDsdrSSVPA@mail.gmail.com>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <187b5db9-63e4-05c2-ddb4-004969edb4d2@gmail.com>
Date: Fri, 21 Dec 2018 19:42:26 +0200
MIME-Version: 1.0
In-Reply-To: <CALCETrU8GZbF2oWYeKUVKBURuh1zeMqcHM5RMTchiDsdrSSVPA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andy Lutomirski <luto@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Igor Stoppa <igor.stoppa@huawei.com>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, linux-integrity <linux-integrity@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>



On 21/12/2018 19:23, Andy Lutomirski wrote:
> On Thu, Dec 20, 2018 at 11:19 AM Igor Stoppa <igor.stoppa@gmail.com> wrote:
>>
>>
>>
>> On 20/12/2018 20:49, Matthew Wilcox wrote:
>>
>>> I think you're causing yourself more headaches by implementing this "op"
>>> function.
>>
>> I probably misinterpreted the initial criticism on my first patchset,
>> about duplication. Somehow, I'm still thinking to the endgame of having
>> higher-level functions, like list management.
>>
>>> Here's some generic code:
>>
>> thank you, I have one question, below
>>
>>> void *wr_memcpy(void *dst, void *src, unsigned int len)
>>> {
>>>        wr_state_t wr_state;
>>>        void *wr_poking_addr = __wr_addr(dst);
>>>
>>>        local_irq_disable();
>>>        wr_enable(&wr_state);
>>>        __wr_memcpy(wr_poking_addr, src, len);
>>
>> Is __wraddr() invoked inside wm_memcpy() instead of being invoked
>> privately within __wr_memcpy() because the code is generic, or is there
>> some other reason?
>>
>>>        wr_disable(&wr_state);
>>>        local_irq_enable();
>>>
>>>        return dst;
>>> }
>>>
>>> Now, x86 can define appropriate macros and functions to use the temporary_mm
>>> functionality, and other architectures can do what makes sense to them.

> I suspect that most architectures will want to do this exactly like
> x86, though, but sure, it could be restructured like this.

In spirit, I think yes, but already I couldn't find a clean ways to do 
multi-arch wr_enable(&wr_state), so I made that too become arch_dependent.

Maybe after implementing write rare for a few archs, it becomes more 
clear (to me, any advice is welcome) which parts can be considered common.

> On x86, I *think* that __wr_memcpy() will want to special-case len ==
> 1, 2, 4, and (on 64-bit) 8 byte writes to keep them atomic. i'm
> guessing this is the same on most or all architectures.

I switched to xxx_user() approach, as you suggested.
For x86_64 I'm using copy_user() and i added a memset_user(), based on 
copy_user().

It's already assembly code optimized for dealing with multiples of 
8-byte words or subsets. You can see this in the first patch of the 
patchset, even this one.

I'll send out the v3 patchset in a short while.

--
igor
