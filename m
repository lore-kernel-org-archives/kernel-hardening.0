Return-Path: <SRS0=SOfO=5P=lists.openwall.com=kernel-hardening-return-18300-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A92C43331
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 14:05:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 96FEB2073B
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 14:05:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="SWh1Rtob"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96FEB2073B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18300-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18186 invoked by uid 550); 30 Mar 2020 14:04:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18154 invoked from network); 30 Mar 2020 14:04:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585577086;
	bh=ZBU9no1Ggmqz4YW86NljyWCx4OIRHRPn4AkqkcfH7go=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SWh1RtobgLh4KvnlmrGP5NqIVPX2604R2XfmRS85UwpQt75JSvlASScc+I4u8XnMm
	 ipWln6hdfaY7ERXdLEKleD4Zl5wP5GnV37rP0W4NO9Job6fyNfzf7GntXUxDqWLoE1
	 Isq+L0P6YhGQoivoIWWGMVVwO1EnVsUg95gtHxqQ=
Date: Mon, 30 Mar 2020 15:04:42 +0100
From: Will Deacon <will@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
	kernel-hardening@lists.openwall.com,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RFC PATCH] arm64: remove CONFIG_DEBUG_ALIGN_RODATA feature
Message-ID: <20200330140441.GE10633@willie-the-truck>
References: <20200329141258.31172-1-ardb@kernel.org>
 <20200330135121.GD10633@willie-the-truck>
 <CAMj1kXEZARZ1FYZFt4CZ33b-A64zj1JswR0OAHw-eZdzkxiEOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEZARZ1FYZFt4CZ33b-A64zj1JswR0OAHw-eZdzkxiEOQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Mar 30, 2020 at 03:53:04PM +0200, Ard Biesheuvel wrote:
> On Mon, 30 Mar 2020 at 15:51, Will Deacon <will@kernel.org> wrote:
> >
> > On Sun, Mar 29, 2020 at 04:12:58PM +0200, Ard Biesheuvel wrote:
> > > When CONFIG_DEBUG_ALIGN_RODATA is enabled, kernel segments mapped with
> > > different permissions (r-x for .text, r-- for .rodata, rw- for .data,
> > > etc) are rounded up to 2 MiB so they can be mapped more efficiently.
> > > In particular, it permits the segments to be mapped using level 2
> > > block entries when using 4k pages, which is expected to result in less
> > > TLB pressure.
> > >
> > > However, the mappings for the bulk of the kernel will use level 2
> > > entries anyway, and the misaligned fringes are organized such that they
> > > can take advantage of the contiguous bit, and use far fewer level 3
> > > entries than would be needed otherwise.
> > >
> > > This makes the value of this feature dubious at best, and since it is not
> > > enabled in defconfig or in the distro configs, it does not appear to be
> > > in wide use either. So let's just remove it.
> > >
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > ---
> > >  arch/arm64/Kconfig.debug                  | 13 -------------
> > >  arch/arm64/include/asm/memory.h           | 12 +-----------
> > >  drivers/firmware/efi/libstub/arm64-stub.c |  8 +++-----
> > >  3 files changed, 4 insertions(+), 29 deletions(-)
> >
> > Acked-by: Will Deacon <will@kernel.org>
> >
> > But I would really like to go a step further and rip out the block mapping
> > support altogether so that we can fix non-coherent DMA aliases:
> >
> > https://lore.kernel.org/lkml/20200224194446.690816-1-hch@lst.de
> >
> 
> I'm not sure I follow - is this about mapping parts of the static
> kernel Image for non-coherent DMA?

Sorry, it's not directly related to your patch, just that if we're removing
options relating to kernel mappings then I'd be quite keen on effectively
forcing page-granularity on the linear map, as is currently done by default
thanks to RODATA_FULL_DEFAULT_ENABLED, so that we can nobble cacheable
aliases for non-coherent streaming DMA mappings by hooking into Christoph's
series above.

This series just reminded me of it because it's another
"off-by-default-behaviour-for-block-mappings-probably-because-of-performance-
but-never-actually-measured" type of thing which really just gets in the
way.

Will
