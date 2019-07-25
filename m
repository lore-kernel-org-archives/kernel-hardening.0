Return-Path: <SRS0=ZM94=VW=lists.openwall.com=kernel-hardening-return-16587-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04355C76190
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jul 2019 19:58:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 546892190F
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jul 2019 19:58:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="kTg+uBtB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 546892190F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16587-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5215 invoked by uid 550); 25 Jul 2019 19:58:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5181 invoked from network); 25 Jul 2019 19:58:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q1zzi7FPBij/o2TB0V49FOYnUapYVtCOQBftk4jb7sM=;
        b=kTg+uBtB6pkMq/6M/tQANEdWidFy2aefELMOif8PvLwgECwcyrC2zXjcwjgLlAi8Fz
         s7pTNL5y8A2nYSHbXn/N8xMd6pyNrmK2VwGLW6cdqGMbpN2zbbLXlPV1LkaBp1LNk1dh
         O+h3f82uEi68q0ambxJr76CBOQDpdvSbTowFQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q1zzi7FPBij/o2TB0V49FOYnUapYVtCOQBftk4jb7sM=;
        b=NE6slChVln1SInueSGfrMQuh+/CysB0if5o8UtYTrKAQuH1ZPmoPpHLO2BpXDYv7g0
         l1wo6LpWbFj7k9H4HwUShwqJfxSfdZAwUx1AcXRy6Zm42o/FLe8eyLlGG9/yTdLLSi4P
         HB0YZA3hXlsoroCfxLD+FkizYeGX24AxwDZw97Xmro/7LaoYH+coWb0WzPZWAoqnKmPe
         PRvE7QLnvluhp21QH1b46nO+iGfWEMYmwgYDrtkHhQDCqTB6iAkxoc3ANzG48dwSP/xW
         Jkx8h40eWOxxWKZyr7Y2QBf6pUzClx7LfpK1+Wzr8SxV0kgIk17D7Ng4S+FRnr6immsA
         uIWA==
X-Gm-Message-State: APjAAAXSM6N8BfXRnNWi+vNJpl9G2i0lm2yck3UMIRmw8Djtc6xepyrf
	rUayWSn505iIZrjohxGAhTIQ1A==
X-Google-Smtp-Source: APXvYqwWG4tnTtE/YPrDLHwEnE9csORMu/zIiO8Sy+jOPLxKiii0cWDG8jMtv435J0IMQF5f3NraUQ==
X-Received: by 2002:a17:90a:270f:: with SMTP id o15mr94434828pje.56.1564084694036;
        Thu, 25 Jul 2019 12:58:14 -0700 (PDT)
Date: Thu, 25 Jul 2019 12:58:12 -0700
From: Kees Cook <keescook@chromium.org>
To: Jason Yan <yanaijie@huawei.com>
Cc: mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
	diana.craciun@nxp.com, christophe.leroy@c-s.fr,
	benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com,
	kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
	wangkefeng.wang@huawei.com, yebin10@huawei.com,
	thunder.leizhen@huawei.com, jingxiangfeng@huawei.com,
	fanchengyang@huawei.com
Subject: Re: [RFC PATCH 00/10] implement KASLR for powerpc/fsl_booke/32
Message-ID: <201907251252.0C58037@keescook>
References: <20190717080621.40424-1-yanaijie@huawei.com>
 <e6ad41bc-5d5a-cf3f-b308-e1863b4fef99@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6ad41bc-5d5a-cf3f-b308-e1863b4fef99@huawei.com>

On Thu, Jul 25, 2019 at 03:16:28PM +0800, Jason Yan wrote:
> Hi all, any comments?

I'm a fan of it, but I don't know ppc internals well enough to sanely
review the code. :) Some comments below on design...

> 
> 
> On 2019/7/17 16:06, Jason Yan wrote:
> > This series implements KASLR for powerpc/fsl_booke/32, as a security
> > feature that deters exploit attempts relying on knowledge of the location
> > of kernel internals.
> > 
> > Since CONFIG_RELOCATABLE has already supported, what we need to do is
> > map or copy kernel to a proper place and relocate. Freescale Book-E
> > parts expect lowmem to be mapped by fixed TLB entries(TLB1). The TLB1
> > entries are not suitable to map the kernel directly in a randomized
> > region, so we chose to copy the kernel to a proper place and restart to
> > relocate.
> > 
> > Entropy is derived from the banner and timer base, which will change every
> > build and boot. This not so much safe so additionally the bootloader may
> > pass entropy via the /chosen/kaslr-seed node in device tree.

Good: adding kaslr-seed is a good step here. Are there any x86-like
RDRAND or RDTSC to use? (Or maybe timer base here is similar to x86
RDTSC here?)

> > 
> > We will use the first 512M of the low memory to randomize the kernel
> > image. The memory will be split in 64M zones. We will use the lower 8
> > bit of the entropy to decide the index of the 64M zone. Then we chose a
> > 16K aligned offset inside the 64M zone to put the kernel in.

Does this 16K granularity have any page table performance impact? My
understanding was that x86 needed to have 2M granularity due to its page
table layouts.

Why the 64M zones instead of just 16K granularity across the entire low
512M?

> > 
> >      KERNELBASE
> > 
> >          |-->   64M   <--|
> >          |               |
> >          +---------------+    +----------------+---------------+
> >          |               |....|    |kernel|    |               |
> >          +---------------+    +----------------+---------------+
> >          |                         |
> >          |----->   offset    <-----|
> > 
> >                                kimage_vaddr
> > 
> > We also check if we will overlap with some areas like the dtb area, the
> > initrd area or the crashkernel area. If we cannot find a proper area,
> > kaslr will be disabled and boot from the original kernel.
> > 
> > Jason Yan (10):
> >    powerpc: unify definition of M_IF_NEEDED
> >    powerpc: move memstart_addr and kernstart_addr to init-common.c
> >    powerpc: introduce kimage_vaddr to store the kernel base
> >    powerpc/fsl_booke/32: introduce create_tlb_entry() helper
> >    powerpc/fsl_booke/32: introduce reloc_kernel_entry() helper
> >    powerpc/fsl_booke/32: implement KASLR infrastructure
> >    powerpc/fsl_booke/32: randomize the kernel image offset
> >    powerpc/fsl_booke/kaslr: clear the original kernel if randomized
> >    powerpc/fsl_booke/kaslr: support nokaslr cmdline parameter
> >    powerpc/fsl_booke/kaslr: dump out kernel offset information on panic

Is there anything planned for other fixed-location things, like x86's
CONFIG_RANDOMIZE_MEMORY?

-- 
Kees Cook
