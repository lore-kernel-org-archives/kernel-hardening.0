Return-Path: <SRS0=n1ra=5P=lists.openwall.com=kernel-hardening-return-18305-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 701C5C43331
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 14:33:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C06F920780
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 14:33:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="lBvPDliB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C06F920780
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18305-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1596 invoked by uid 550); 30 Mar 2020 14:33:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1387 invoked from network); 30 Mar 2020 14:32:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585578763;
	bh=B8jJcqViIsc/trUPGRxV3+Ui1u0gnPMnjlFNygJkFVM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lBvPDliBUdHWlSyozWigVopdhOwEDhj96MQoqxMEnYGYL8P9qAO05gH0mUMvH3DX4
	 vmTen87x2kD3kxtJbAAo9cbTJXXopsr2eGrFkWsdzpthDdJZeke3NkoQ90hcU6nQfe
	 hGeOj76lb5vDviSHNO0kvHxGVK2p8nWzY0BOQbck=
X-Gm-Message-State: ANhLgQ26LNLE0pdc6d4eR2Aja7IFpVAPIX6nugBL4rCEOpsNxo01RKdi
	GVWL4I8KBsN1EYnBgjFt7RfoRiyOKfiViU1s+2A=
X-Google-Smtp-Source: ADFU+vsqeGGvvYW5+i/KvbFu4pnjDV6EmfDq3jxugMuXMn64EbsdrhK/FSYFTj5oGLUx3MDTn/vyXuex/G2q1sjooyA=
X-Received: by 2002:a05:6e02:551:: with SMTP id i17mr10510373ils.218.1585578762598;
 Mon, 30 Mar 2020 07:32:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200329141258.31172-1-ardb@kernel.org> <20200330135121.GD10633@willie-the-truck>
 <CAMj1kXEZARZ1FYZFt4CZ33b-A64zj1JswR0OAHw-eZdzkxiEOQ@mail.gmail.com>
 <20200330140441.GE10633@willie-the-truck> <CAMj1kXHJ5n-EZMgGSYm+ekO-e7XTp7fv-FZ2NJ1EttJ=-kc8fw@mail.gmail.com>
 <20200330142805.GA11312@willie-the-truck>
In-Reply-To: <20200330142805.GA11312@willie-the-truck>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 30 Mar 2020 16:32:31 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFcvHcU2kzP=N4bHgSkw_eE7wvbPJ=7w1pNeCWHbcPvTQ@mail.gmail.com>
Message-ID: <CAMj1kXFcvHcU2kzP=N4bHgSkw_eE7wvbPJ=7w1pNeCWHbcPvTQ@mail.gmail.com>
Subject: Re: [RFC PATCH] arm64: remove CONFIG_DEBUG_ALIGN_RODATA feature
To: Will Deacon <will@kernel.org>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	kernel-hardening@lists.openwall.com, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 30 Mar 2020 at 16:28, Will Deacon <will@kernel.org> wrote:
>
> On Mon, Mar 30, 2020 at 04:22:24PM +0200, Ard Biesheuvel wrote:
> > On Mon, 30 Mar 2020 at 16:04, Will Deacon <will@kernel.org> wrote:
> > >
> > > On Mon, Mar 30, 2020 at 03:53:04PM +0200, Ard Biesheuvel wrote:
> > > > On Mon, 30 Mar 2020 at 15:51, Will Deacon <will@kernel.org> wrote:
> > > > >
> > > > > On Sun, Mar 29, 2020 at 04:12:58PM +0200, Ard Biesheuvel wrote:
> > > > > > When CONFIG_DEBUG_ALIGN_RODATA is enabled, kernel segments mapped with
> > > > > > different permissions (r-x for .text, r-- for .rodata, rw- for .data,
> > > > > > etc) are rounded up to 2 MiB so they can be mapped more efficiently.
> > > > > > In particular, it permits the segments to be mapped using level 2
> > > > > > block entries when using 4k pages, which is expected to result in less
> > > > > > TLB pressure.
> > > > > >
> > > > > > However, the mappings for the bulk of the kernel will use level 2
> > > > > > entries anyway, and the misaligned fringes are organized such that they
> > > > > > can take advantage of the contiguous bit, and use far fewer level 3
> > > > > > entries than would be needed otherwise.
> > > > > >
> > > > > > This makes the value of this feature dubious at best, and since it is not
> > > > > > enabled in defconfig or in the distro configs, it does not appear to be
> > > > > > in wide use either. So let's just remove it.
> > > > > >
> > > > > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > > > > ---
> > > > > >  arch/arm64/Kconfig.debug                  | 13 -------------
> > > > > >  arch/arm64/include/asm/memory.h           | 12 +-----------
> > > > > >  drivers/firmware/efi/libstub/arm64-stub.c |  8 +++-----
> > > > > >  3 files changed, 4 insertions(+), 29 deletions(-)
> > > > >
> > > > > Acked-by: Will Deacon <will@kernel.org>
> > > > >
> > > > > But I would really like to go a step further and rip out the block mapping
> > > > > support altogether so that we can fix non-coherent DMA aliases:
> > > > >
> > > > > https://lore.kernel.org/lkml/20200224194446.690816-1-hch@lst.de
> > > > >
> > > >
> > > > I'm not sure I follow - is this about mapping parts of the static
> > > > kernel Image for non-coherent DMA?
> > >
> > > Sorry, it's not directly related to your patch, just that if we're removing
> > > options relating to kernel mappings then I'd be quite keen on effectively
> > > forcing page-granularity on the linear map, as is currently done by default
> > > thanks to RODATA_FULL_DEFAULT_ENABLED, so that we can nobble cacheable
> > > aliases for non-coherent streaming DMA mappings by hooking into Christoph's
> > > series above.
> > >
> >
> > Right. I don't remember seeing any complaints about
> > RODATA_FULL_DEFAULT_ENABLED, but maybe it's too early for that.
> >
> > > This series just reminded me of it because it's another
> > > "off-by-default-behaviour-for-block-mappings-probably-because-of-performance-
> > > but-never-actually-measured" type of thing which really just gets in the
> > > way.
> > >
> >
> > Well, even though I agree that the lack of actual numbers is a bit
> > disturbing here, I'd hate to penalize all systems even more than they
> > already are (due to ARCH_KMALLOC_MINALIGN == ARCH_DMA_MINALIGN) by
> > adding another workaround that is only needed on devices that have
> > non-coherent masters.
>
> Fair enough, but I'd still like to see some numbers. If they're compelling,
> then we could explore something like CONFIG_OF_DMA_DEFAULT_COHERENT, but
> that doesn't really help the kconfig maze :(
>

Could we make this a runtime thing? E.g., remap the entire linear
region down to pages under stop_machine() the first time we probe a
device that uses non-coherent DMA?

(/me ducks)
