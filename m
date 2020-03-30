Return-Path: <SRS0=ybJB=5P=lists.openwall.com=kernel-hardening-return-18302-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D259AC43331
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 14:31:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2C359206CC
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 14:31:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="RwDATGOo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C359206CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18302-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29841 invoked by uid 550); 30 Mar 2020 14:31:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13849 invoked from network); 30 Mar 2020 13:53:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585576395;
	bh=ONKwrHl7PRNYbGE3vDjqEA9ngR/ho+h+Qjs3WXBioJg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=RwDATGOo24Ug60FYKAe4BLJJhOZNp82vnf51zyUDWRwsgU/zwavJ7EflUnlS1H7bv
	 zICNNHGK9tp6ZvBfSF4OX0qjKGQsOlC/7iaq+L2vxLlwEgxavdKKIIqW0sQ5ndwE9m
	 jTokLeDbrvwLKDK+s1p4pjgvKdizW8smUWGRykRg=
X-Gm-Message-State: ANhLgQ2pUAdnB7ib/9uCkGpEpc/8SKTc4ISTYotilxWlPVl790tlowvd
	/skaQCuchwI5qopCcjPxRIfbh6nYBBdRw0G9NMU=
X-Google-Smtp-Source: ADFU+vud5/bwSP0P8Z4nRqYNPnqG7tW9neq7l6CbvUZRPDpQXWdEc4NhcV2Nge4yz56zQ52JEFc8FRA4SKpa8KSSZJA=
X-Received: by 2002:a6b:f413:: with SMTP id i19mr2031584iog.203.1585576395032;
 Mon, 30 Mar 2020 06:53:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200329141258.31172-1-ardb@kernel.org> <20200330135121.GD10633@willie-the-truck>
In-Reply-To: <20200330135121.GD10633@willie-the-truck>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 30 Mar 2020 15:53:04 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEZARZ1FYZFt4CZ33b-A64zj1JswR0OAHw-eZdzkxiEOQ@mail.gmail.com>
Message-ID: <CAMj1kXEZARZ1FYZFt4CZ33b-A64zj1JswR0OAHw-eZdzkxiEOQ@mail.gmail.com>
Subject: Re: [RFC PATCH] arm64: remove CONFIG_DEBUG_ALIGN_RODATA feature
To: Will Deacon <will@kernel.org>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	kernel-hardening@lists.openwall.com, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 30 Mar 2020 at 15:51, Will Deacon <will@kernel.org> wrote:
>
> On Sun, Mar 29, 2020 at 04:12:58PM +0200, Ard Biesheuvel wrote:
> > When CONFIG_DEBUG_ALIGN_RODATA is enabled, kernel segments mapped with
> > different permissions (r-x for .text, r-- for .rodata, rw- for .data,
> > etc) are rounded up to 2 MiB so they can be mapped more efficiently.
> > In particular, it permits the segments to be mapped using level 2
> > block entries when using 4k pages, which is expected to result in less
> > TLB pressure.
> >
> > However, the mappings for the bulk of the kernel will use level 2
> > entries anyway, and the misaligned fringes are organized such that they
> > can take advantage of the contiguous bit, and use far fewer level 3
> > entries than would be needed otherwise.
> >
> > This makes the value of this feature dubious at best, and since it is not
> > enabled in defconfig or in the distro configs, it does not appear to be
> > in wide use either. So let's just remove it.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  arch/arm64/Kconfig.debug                  | 13 -------------
> >  arch/arm64/include/asm/memory.h           | 12 +-----------
> >  drivers/firmware/efi/libstub/arm64-stub.c |  8 +++-----
> >  3 files changed, 4 insertions(+), 29 deletions(-)
>
> Acked-by: Will Deacon <will@kernel.org>
>
> But I would really like to go a step further and rip out the block mapping
> support altogether so that we can fix non-coherent DMA aliases:
>
> https://lore.kernel.org/lkml/20200224194446.690816-1-hch@lst.de
>

I'm not sure I follow - is this about mapping parts of the static
kernel Image for non-coherent DMA?
