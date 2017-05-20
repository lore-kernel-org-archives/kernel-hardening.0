Date: Sat, 20 May 2017 10:51:47 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170520085147.GA4619@kroah.com>
References: <20170519103811.2183-1-igor.stoppa@huawei.com>
 <20170519103811.2183-2-igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170519103811.2183-2-igor.stoppa@huawei.com>
Subject: Re: [kernel-hardening] [PATCH 1/1] Sealable memory support
To: Igor Stoppa <igor.stoppa@huawei.com>
Cc: mhocko@kernel.org, dave.hansen@intel.com, labbott@redhat.com, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 19, 2017 at 01:38:11PM +0300, Igor Stoppa wrote:
> Dynamically allocated variables can be made read only,
> after they have been initialized, provided that they reside in memory
> pages devoid of any RW data.
> 
> The implementation supplies means to create independent pools of memory,
> which can be individually created, sealed/unsealed and destroyed.
> 
> A global pool is made available for those kernel modules that do not
> need to manage an independent pool.
> 
> Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
> ---
>  mm/Makefile  |   2 +-
>  mm/smalloc.c | 200 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  mm/smalloc.h |  61 ++++++++++++++++++
>  3 files changed, 262 insertions(+), 1 deletion(-)
>  create mode 100644 mm/smalloc.c
>  create mode 100644 mm/smalloc.h

This is really nice, do you have a follow-on patch showing how any of
the kernel can be changed to use this new subsystem?  Without that, it
might be hard to get this approved (we don't like adding new apis
without users.)

thanks,

greg k-h
