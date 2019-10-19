Return-Path: <SRS0=4B83=YM=lists.openwall.com=kernel-hardening-return-17061-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8922ECA9EAC
	for <kernel-hardening@archiver.kernel.org>; Sat, 19 Oct 2019 05:38:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D296821925
	for <kernel-hardening@archiver.kernel.org>; Sat, 19 Oct 2019 05:38:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I2ArurjZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D296821925
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17061-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5604 invoked by uid 550); 19 Oct 2019 05:38:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5572 invoked from network); 19 Oct 2019 05:38:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dZD1rhZmQDM/H+GbTbYnSSIXxS9iO4DRfvqaZaVLmHA=;
        b=I2ArurjZWxXb7+XpLicdsV0rlFMZFv7gBdh8euQxI0hZMDcpnlpIoJZu5ltMe9sWnb
         DMG+2YBnDafJ9umzHpMqXhkhj8pHS4XAOZ0TDHp/p4y+cMp1hx3IHzeWCuB39zcqgjfj
         msjJ1LArDkb6x6lsD8lb1dJ5GD204iI8auQKUnK539L4cpwBf/8UM1kNERPkdY+d/W66
         P3H41YvHbbcfSy2/P+MzhkN72fgSNkI1nzurPybrCZqAzztSOhcEaDbR09FqlasCoovs
         kXvovL0pU9ESneKb2ZJioZPYRBxw23HwTU2ZRSGD1TRQR7AgDrGP6LcPUVNL0U7swV7S
         YbaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dZD1rhZmQDM/H+GbTbYnSSIXxS9iO4DRfvqaZaVLmHA=;
        b=Gr9Cfp42JU4Byf23j6nc5h6/rAZhBlKqayHtbTcf3AzjyLzT7v8FeEaFLQlCgBYkUT
         A244ZDBTtp5KQRbT8FmeDTSq7l7PvOBnjlk9YIZMOY/Y+mxHwXFmzvPLp7CF1dEAxT5U
         nk6KiSwznrWWis8SgQvX8mK+3mrCbmJod5oK+VGSsVkikGxvmxUzXEBX4Snm+L7/nvwT
         aEj0qVY/F/gyiOOvMt09G39RVseBIBhnKdZilHz3SAzA3VMPCHA+yhBTeTpsZVlF4dxt
         2aZM/GIkAWawMmn56zQiyRWNTiHqADDnV3utP5cZ+pW2i8ukRoe6u3Xy8bZ4dsiwsABR
         j9OA==
X-Gm-Message-State: APjAAAVIRHG11705dloxYirMssiXZYWQT3tGMLj3ryYLA86XqQf0K33E
	ogq0deLKxxBxC4OypV8MFJTL6L++4bTQBihZ8kw=
X-Google-Smtp-Source: APXvYqxWRplW90eHZs/5G1y76NalbYYyDOet1jwKXgcM26aLqw7XHltBJMnUYIgx0qdZyyIcHCdpk3LqAa+mZJoGEFY=
X-Received: by 2002:a9d:6e1a:: with SMTP id e26mr10354403otr.307.1571463478507;
 Fri, 18 Oct 2019 22:37:58 -0700 (PDT)
MIME-Version: 1.0
References: <20191012122918.8066-1-mayhs11saini@gmail.com> <95842b81-c751-abed-dd3f-258b9fd70393@arm.com>
In-Reply-To: <95842b81-c751-abed-dd3f-258b9fd70393@arm.com>
From: Shyam Saini <mayhs11saini@gmail.com>
Date: Sat, 19 Oct 2019 11:07:47 +0530
Message-ID: <CAOfkYf7iEe8A0gFB6XG2RDfkHxQtdM_CUZFnsZADedsyMAm8+A@mail.gmail.com>
Subject: Re: [PATCH] kernel: dma: Make CMA boot parameters __ro_after_init
To: Robin Murphy <robin.murphy@arm.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	linux-mm <linux-mm@kvack.org>, iommu@lists.linux-foundation.org, 
	Christopher Lameter <cl@linux.com>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"

Hi Robin,

Sorry for the late reply.


> This parameters are not changed after early boot.
> > By making them __ro_after_init will reduce any attack surface in the
> > kernel.
>
> At a glance, it looks like these are only referenced by a couple of
> __init functions, so couldn't they just be __initdata/__initconst?

yes, You are right it is only used by __init calls and not used anywhere else.

I will resend the updated version.

Thanks a lot for the feedback.


> > Link: https://lwn.net/Articles/676145/
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > Cc: Robin Murphy <robin.murphy@arm.com>
> > Cc: Matthew Wilcox <willy@infradead.org>
> > Cc: Christopher Lameter <cl@linux.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
> > ---
> >   kernel/dma/contiguous.c | 8 ++++----
> >   1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
> > index 69cfb4345388..1b689b1303cd 100644
> > --- a/kernel/dma/contiguous.c
> > +++ b/kernel/dma/contiguous.c
> > @@ -42,10 +42,10 @@ struct cma *dma_contiguous_default_area;
> >    * Users, who want to set the size of global CMA area for their system
> >    * should use cma= kernel parameter.
> >    */
> > -static const phys_addr_t size_bytes = (phys_addr_t)CMA_SIZE_MBYTES * SZ_1M;
> > -static phys_addr_t size_cmdline = -1;
> > -static phys_addr_t base_cmdline;
> > -static phys_addr_t limit_cmdline;
> > +static const phys_addr_t __ro_after_init size_bytes = (phys_addr_t)CMA_SIZE_MBYTES * SZ_1M;
> > +static phys_addr_t __ro_after_init size_cmdline = -1;
> > +static phys_addr_t __ro_after_init base_cmdline;
> > +static phys_addr_t __ro_after_init limit_cmdline;
> >
> >   static int __init early_cma(char *p)
> >   {
> >
