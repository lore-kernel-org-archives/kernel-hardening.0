Return-Path: <SRS0=kYkq=YP=lists.openwall.com=kernel-hardening-return-17085-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD332CA9EA0
	for <kernel-hardening@archiver.kernel.org>; Tue, 22 Oct 2019 13:57:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0477D2184C
	for <kernel-hardening@archiver.kernel.org>; Tue, 22 Oct 2019 13:57:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0477D2184C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17085-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16113 invoked by uid 550); 22 Oct 2019 13:57:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16074 invoked from network); 22 Oct 2019 13:57:25 -0000
Subject: Re: [PATCH V2] kernel: dma: contigous: Make CMA parameters
 __initdata/__initconst
To: Shyam Saini <mayhs11saini@gmail.com>, kernel-hardening@lists.openwall.com
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Matthew Wilcox <willy@infradead.org>, Christopher Lameter <cl@linux.com>,
 Kees Cook <keescook@chromium.org>
References: <20191020050322.2634-1-mayhs11saini@gmail.com>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <1a358862-0c0c-e4c6-9dd7-f626c0a904b0@arm.com>
Date: Tue, 22 Oct 2019 14:56:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20191020050322.2634-1-mayhs11saini@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit

On 20/10/2019 06:03, Shyam Saini wrote:
> These parameters are only referenced by __init routine calls during early
> boot so they should be marked as __initdata and __initconst accordingly.

Reviewed-by: Robin Murphy <robin.murphy@arm.com>

> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Christopher Lameter <cl@linux.com>
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
> ---
> V1->V2:
> 	mark cma parameters as __initdata/__initconst
> 	instead of __ro_after_init. As these parameters
> 	are only used by __init calls and never used afterwards
> 	which contrast the __ro_after_init usage.
> ---
>   kernel/dma/contiguous.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
> index 69cfb4345388..10bfc8c44c54 100644
> --- a/kernel/dma/contiguous.c
> +++ b/kernel/dma/contiguous.c
> @@ -42,10 +42,10 @@ struct cma *dma_contiguous_default_area;
>    * Users, who want to set the size of global CMA area for their system
>    * should use cma= kernel parameter.
>    */
> -static const phys_addr_t size_bytes = (phys_addr_t)CMA_SIZE_MBYTES * SZ_1M;
> -static phys_addr_t size_cmdline = -1;
> -static phys_addr_t base_cmdline;
> -static phys_addr_t limit_cmdline;
> +static const phys_addr_t size_bytes __initconst = (phys_addr_t)CMA_SIZE_MBYTES * SZ_1M;
> +static phys_addr_t  size_cmdline __initdata = -1;
> +static phys_addr_t base_cmdline __initdata;
> +static phys_addr_t limit_cmdline __initdata;
>   
>   static int __init early_cma(char *p)
>   {
> 
