Subject: Re: [PATCH] dmaengine: dmatest: Remove use of VLAs
References: <20180409210603.3575-1-labbott@redhat.com>
 <4491bde2-cf38-5103-0634-1986ecd32a7c@codeaurora.org>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <9bdd8bb4-b6d9-e170-b585-b2dc3b8f0d67@redhat.com>
Date: Mon, 9 Apr 2018 16:14:20 -0700
MIME-Version: 1.0
In-Reply-To: <4491bde2-cf38-5103-0634-1986ecd32a7c@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Sinan Kaya <okaya@codeaurora.org>, Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/09/2018 03:48 PM, Sinan Kaya wrote:
> On 4/9/2018 5:06 PM, Laura Abbott wrote:
>> +			/* dst_cnt can't be more than u8 */
>> +			dma_addr_t dma_pq[255];
> 
> This is 2k stack space on 64 bit architectures. Isn't that a lot?
> 

Depends on your definition of 'a lot'. My assumption was that
since this was a test module there would be some willingness
to be a bit more generous. The problem is the array size is
based off of the parameters passed in, although oddly enough
it's based off of the minimum of two variables. If you have
a suggestion for a tighter bound we can use that. Another
option is to just switch to allocating the array with kmalloc.
That might be reasonable here since there's other setup
that happens before the test starts.

Thanks,
Laura
