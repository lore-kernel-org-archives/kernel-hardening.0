Date: Mon, 16 Apr 2018 21:06:34 +0530
From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCHv2] dmaengine: dmatest: Remove use of VLAs
Message-ID: <20180416153634.GR6014@localhost>
References: <20180411010216.17702-1-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180411010216.17702-1-labbott@redhat.com>
To: Laura Abbott <labbott@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Sinan Kaya <okaya@codeaurora.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 10, 2018 at 06:02:16PM -0700, Laura Abbott wrote:
> There's an ongoing effort to remove VLAs from the kernel
> (https://lkml.org/lkml/2018/3/7/621) to eventually turn on -Wvla.
> The test already pre-allocates some buffers with kmalloc so turn
> the two VLAs in to pre-allocated kmalloc buffers.

Applied, thanks

-- 
~Vinod
