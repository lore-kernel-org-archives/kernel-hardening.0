MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 09 Apr 2018 19:19:16 -0400
From: okaya@codeaurora.org
Subject: Re: [PATCH] dmaengine: dmatest: Remove use of VLAs
In-Reply-To: <9bdd8bb4-b6d9-e170-b585-b2dc3b8f0d67@redhat.com>
References: <20180409210603.3575-1-labbott@redhat.com>
 <4491bde2-cf38-5103-0634-1986ecd32a7c@codeaurora.org>
 <9bdd8bb4-b6d9-e170-b585-b2dc3b8f0d67@redhat.com>
Message-ID: <e2991519fb007653c35bf52210af36b9@codeaurora.org>
To: Laura Abbott <labbott@redhat.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, dmaengine-owner@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 2018-04-09 19:14, Laura Abbott wrote:
> On 04/09/2018 03:48 PM, Sinan Kaya wrote:
>> On 4/9/2018 5:06 PM, Laura Abbott wrote:
>>> +			/* dst_cnt can't be more than u8 */
>>> +			dma_addr_t dma_pq[255];
>> 
>> This is 2k stack space on 64 bit architectures. Isn't that a lot?
>> 
> 
> Depends on your definition of 'a lot'. My assumption was that
> since this was a test module there would be some willingness
> to be a bit more generous. The problem is the array size is
> based off of the parameters passed in, although oddly enough
> it's based off of the minimum of two variables. If you have
> a suggestion for a tighter bound we can use that. Another
> option is to just switch to allocating the array with kmalloc.
> That might be reasonable here since there's other setup
> that happens before the test starts.

I think allocation is a better choice.

> 
> Thanks,
> Laura
> 
> --
> To unsubscribe from this list: send the line "unsubscribe dmaengine" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
