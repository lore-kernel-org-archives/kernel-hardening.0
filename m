Return-Path: <SRS0=+cCu=6T=lists.openwall.com=kernel-hardening-return-18714-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76834C47254
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 May 2020 10:44:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C1919206A5
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 May 2020 10:44:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="umfSfVmA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C1919206A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18714-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3917 invoked by uid 550); 5 May 2020 10:44:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3877 invoked from network); 5 May 2020 10:44:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588675449;
	bh=GEhF2tEU4XkWefXPE5udcRA2Y0YzSMAJ2YekTBmZRN8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=umfSfVmAzQRn1jZ3bKYhL7bz38WXiQuVIirVZy0mTX6WcttQ58u31IvMAtuwooHlI
	 zAg67Rt+mmAcMu69MDpIYRff/zJipCTQzdMaBVWDy4jcVv2gFlg5jJGS3SGHf7E1rl
	 7ZzUXD/6ZKX4GNHL37htRHoduxFXkj5zNfDqSsKA=
Date: Tue, 5 May 2020 11:44:06 +0100
From: Will Deacon <will@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	kernel-hardening@lists.openwall.com,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RFC PATCH] arm64: remove CONFIG_DEBUG_ALIGN_RODATA feature
Message-ID: <20200505104404.GB19710@willie-the-truck>
References: <20200329141258.31172-1-ardb@kernel.org>
 <20200330135121.GD10633@willie-the-truck>
 <CAMj1kXEZARZ1FYZFt4CZ33b-A64zj1JswR0OAHw-eZdzkxiEOQ@mail.gmail.com>
 <20200330140441.GE10633@willie-the-truck>
 <CAMj1kXHJ5n-EZMgGSYm+ekO-e7XTp7fv-FZ2NJ1EttJ=-kc8fw@mail.gmail.com>
 <20200330142805.GA11312@willie-the-truck>
 <CAMj1kXFcvHcU2kzP=N4bHgSkw_eE7wvbPJ=7w1pNeCWHbcPvTQ@mail.gmail.com>
 <20200402113033.GD21087@mbp>
 <CAMj1kXGLMWqTHbWftoAq=WdVqyf+i=6SvsMogzWHh6SL3b=4sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGLMWqTHbWftoAq=WdVqyf+i=6SvsMogzWHh6SL3b=4sQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Apr 03, 2020 at 10:58:51AM +0200, Ard Biesheuvel wrote:
> On Thu, 2 Apr 2020 at 13:30, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Mon, Mar 30, 2020 at 04:32:31PM +0200, Ard Biesheuvel wrote:
> > > On Mon, 30 Mar 2020 at 16:28, Will Deacon <will@kernel.org> wrote:
> > > > Fair enough, but I'd still like to see some numbers. If they're compelling,
> > > > then we could explore something like CONFIG_OF_DMA_DEFAULT_COHERENT, but
> > > > that doesn't really help the kconfig maze :(
> >
> > I'd prefer not to have a config option, we could easily break single
> > Image at some point.
> >
> > > Could we make this a runtime thing? E.g., remap the entire linear
> > > region down to pages under stop_machine() the first time we probe a
> > > device that uses non-coherent DMA?
> >
> > That could be pretty expensive at run-time. With the ARMv8.4-TTRem
> > feature, I wonder whether we could do this lazily when allocating
> > non-coherent DMA buffers.
> >
> > (I still hope there isn't a problem at all with this mismatch ;)).
> >
> 
> Now that we have the pieces to easily remap the linear region down to
> pages, and [apparently] some generic infrastructure to manage the
> linear aliases, the only downside is the alleged performance hit
> resulting from increased TLB pressure. This is obviously highly
> micro-architecture dependent, but with Xgene1 and ThunderX1 out of the
> picture, I wonder if the tradeoffs are different now. Maybe by now, we
> should just suck it up (Note that we had no complaints afaik regarding
> the fact that we map the linear map down to pages by default now)

I'd be in favour of that fwiw.

Catalin -- did you get anything back from the architects about the cache
hit behaviour?

Will
