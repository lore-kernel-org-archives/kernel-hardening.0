Subject: Re: [PATCH] dmaengine: dmatest: Remove use of VLAs
References: <20180409210603.3575-1-labbott@redhat.com>
From: Sinan Kaya <okaya@codeaurora.org>
Message-ID: <4491bde2-cf38-5103-0634-1986ecd32a7c@codeaurora.org>
Date: Mon, 9 Apr 2018 18:48:14 -0400
MIME-Version: 1.0
In-Reply-To: <20180409210603.3575-1-labbott@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Laura Abbott <labbott@redhat.com>, Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 4/9/2018 5:06 PM, Laura Abbott wrote:
> +			/* dst_cnt can't be more than u8 */
> +			dma_addr_t dma_pq[255];

This is 2k stack space on 64 bit architectures. Isn't that a lot?

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
