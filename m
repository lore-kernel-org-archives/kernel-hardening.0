Return-Path: <SRS0=78b9=5T=lists.openwall.com=kernel-hardening-return-18405-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A00C43331
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Apr 2020 07:07:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A2E31206A3
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Apr 2020 07:07:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="WuEckcFj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2E31206A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18405-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23594 invoked by uid 550); 3 Apr 2020 07:07:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23562 invoked from network); 3 Apr 2020 07:07:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585897648;
	bh=48ZncQum678f3DrW2C1lr3dFNQ1A9uAJJlABWTqboDc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WuEckcFjkFkaXQ6hxhM+4L05U6jKO2uJth28Fv3JAz6qWz7cB/a7sbf/LEU/swgMg
	 zb8d+UqP3PRT9mAHpjqEtLDnVi/33yjh3ja1svsYyeEdMfXU2s2XQg1e1pSY4xwviK
	 rfp5vu7SiM+nAk7Y/xLrnqKJIH8sLfCoNRIJSwOI=
Date: Fri, 3 Apr 2020 08:07:24 +0100
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	kernel-hardening@lists.openwall.com,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RFC PATCH] arm64: remove CONFIG_DEBUG_ALIGN_RODATA feature
Message-ID: <20200403070723.GB16361@willie-the-truck>
References: <20200329141258.31172-1-ardb@kernel.org>
 <20200330135121.GD10633@willie-the-truck>
 <CAMj1kXEZARZ1FYZFt4CZ33b-A64zj1JswR0OAHw-eZdzkxiEOQ@mail.gmail.com>
 <20200330140441.GE10633@willie-the-truck>
 <CAMj1kXHJ5n-EZMgGSYm+ekO-e7XTp7fv-FZ2NJ1EttJ=-kc8fw@mail.gmail.com>
 <20200330142805.GA11312@willie-the-truck>
 <CAMj1kXFcvHcU2kzP=N4bHgSkw_eE7wvbPJ=7w1pNeCWHbcPvTQ@mail.gmail.com>
 <20200402113033.GD21087@mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402113033.GD21087@mbp>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Apr 02, 2020 at 12:30:33PM +0100, Catalin Marinas wrote:
> On Mon, Mar 30, 2020 at 04:32:31PM +0200, Ard Biesheuvel wrote:
> > On Mon, 30 Mar 2020 at 16:28, Will Deacon <will@kernel.org> wrote:
> > > > On Mon, 30 Mar 2020 at 16:04, Will Deacon <will@kernel.org> wrote:
> > > > > On Mon, Mar 30, 2020 at 03:53:04PM +0200, Ard Biesheuvel wrote:
> > > > > > On Mon, 30 Mar 2020 at 15:51, Will Deacon <will@kernel.org> wrote:
> > > > > > > But I would really like to go a step further and rip out the block mapping
> > > > > > > support altogether so that we can fix non-coherent DMA aliases:
> > > > > > >
> > > > > > > https://lore.kernel.org/lkml/20200224194446.690816-1-hch@lst.de
> > > > > >
> > > > > > I'm not sure I follow - is this about mapping parts of the static
> > > > > > kernel Image for non-coherent DMA?
> > > > >
> > > > > Sorry, it's not directly related to your patch, just that if we're removing
> > > > > options relating to kernel mappings then I'd be quite keen on effectively
> > > > > forcing page-granularity on the linear map, as is currently done by default
> > > > > thanks to RODATA_FULL_DEFAULT_ENABLED, so that we can nobble cacheable
> > > > > aliases for non-coherent streaming DMA mappings by hooking into Christoph's
> > > > > series above.
> 
> Have we ever hit this issue in practice? At least from the CPU
> perspective, we've assumed that a non-cacheable access would not hit in
> the cache. Reading the ARM ARM rules, it doesn't seem to state this
> explicitly but we can ask for clarification (I dug out an email from
> 2015, left unanswered).
> 
> Assuming that the CPU is behaving as we'd expect, are there other issues
> with peripherals/SMMU?

Any clarification would need to be architectural, I think, and not specific
to the CPU. Worth asking again though.

Will
