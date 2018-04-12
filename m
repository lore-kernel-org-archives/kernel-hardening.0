Subject: Re: [PATCHv2] dmaengine: dmatest: Remove use of VLAs
References: <20180411010216.17702-1-labbott@redhat.com>
From: Sinan Kaya <okaya@codeaurora.org>
Message-ID: <70092ca4-1b42-d438-83d5-068a22618baf@codeaurora.org>
Date: Wed, 11 Apr 2018 22:26:45 -0400
MIME-Version: 1.0
In-Reply-To: <20180411010216.17702-1-labbott@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Laura Abbott <labbott@redhat.com>, Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 4/10/2018 9:02 PM, Laura Abbott wrote:
> There's an ongoing effort to remove VLAs from the kernel
> (https://lkml.org/lkml/2018/3/7/621) to eventually turn on -Wvla.
> The test already pre-allocates some buffers with kmalloc so turn
> the two VLAs in to pre-allocated kmalloc buffers.
> 
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> v2: Switch to using kmalloc buffers instead of putting a large array on
> the stack.
> ---
>  drivers/dma/dmatest.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 

Reviewed-by: Sinan Kaya <okaya@codeaurora.org>


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
