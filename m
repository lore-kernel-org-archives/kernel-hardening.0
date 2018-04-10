Date: Tue, 10 Apr 2018 21:08:55 +0530
From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH] dmaengine: dmatest: Remove use of VLAs
Message-ID: <20180410153854.GT6014@localhost>
References: <20180409210603.3575-1-labbott@redhat.com>
 <4491bde2-cf38-5103-0634-1986ecd32a7c@codeaurora.org>
 <9bdd8bb4-b6d9-e170-b585-b2dc3b8f0d67@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bdd8bb4-b6d9-e170-b585-b2dc3b8f0d67@redhat.com>
To: Laura Abbott <labbott@redhat.com>
Cc: Sinan Kaya <okaya@codeaurora.org>, Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 09, 2018 at 04:14:20PM -0700, Laura Abbott wrote:
> On 04/09/2018 03:48 PM, Sinan Kaya wrote:
> >On 4/9/2018 5:06 PM, Laura Abbott wrote:
> >>+			/* dst_cnt can't be more than u8 */
> >>+			dma_addr_t dma_pq[255];
> >
> >This is 2k stack space on 64 bit architectures. Isn't that a lot?
> >
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

Being a test module I don't think I would have too many qualms with current
approach :) said that kmalloc approach seems reasonable too..

Thanks
-- 
~Vinod
