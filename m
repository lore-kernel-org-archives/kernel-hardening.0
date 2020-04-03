Return-Path: <SRS0=Inzs=5T=lists.openwall.com=kernel-hardening-return-18407-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 342B7C2BA15
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Apr 2020 08:59:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 89567206F5
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Apr 2020 08:59:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="MDQXCbIf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89567206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18407-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1459 invoked by uid 550); 3 Apr 2020 08:59:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1424 invoked from network); 3 Apr 2020 08:59:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585904343;
	bh=kw8a4FktnFz4oTw1Esyzp1wV1xha1xRoe0FkNkJtf88=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MDQXCbIfbu742riJo/kUNAH7JNGYXmNsZ5E/t3s4OP7cd+N2inCHrNWMw4jMIYzMk
	 hhow0pZlm0skVFt5U8MaAOBp+Gf+4tVye43kxyGssoh3rGD+lzXhXvbfFtv5F69r40
	 65b3/iTE1eo15VXCN6nL+sPIeQ7ym3XwEO+xmh60=
X-Gm-Message-State: AGi0Pua8fhPd9WeQXw7E2ZD/orwyVo/y0KlTLuWu20pgoX2yDB9IaiIk
	rZJ5G9dH4Ba6mR3L3riD5kbhcFWtx/YDMXsF6sQ=
X-Google-Smtp-Source: APiQypL6LDByoMGOHzbLBsN9qknqnWp7ntm1vw0lrMbPcQn5Kq8mPbPbxxp0PS+jeVV+YJdMxPs1ozZ3hnrD3ONG7so=
X-Received: by 2002:a05:6638:a22:: with SMTP id 2mr7657847jao.74.1585904343067;
 Fri, 03 Apr 2020 01:59:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200329141258.31172-1-ardb@kernel.org> <20200330135121.GD10633@willie-the-truck>
 <CAMj1kXEZARZ1FYZFt4CZ33b-A64zj1JswR0OAHw-eZdzkxiEOQ@mail.gmail.com>
 <20200330140441.GE10633@willie-the-truck> <CAMj1kXHJ5n-EZMgGSYm+ekO-e7XTp7fv-FZ2NJ1EttJ=-kc8fw@mail.gmail.com>
 <20200330142805.GA11312@willie-the-truck> <CAMj1kXFcvHcU2kzP=N4bHgSkw_eE7wvbPJ=7w1pNeCWHbcPvTQ@mail.gmail.com>
 <20200402113033.GD21087@mbp>
In-Reply-To: <20200402113033.GD21087@mbp>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 3 Apr 2020 10:58:51 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGLMWqTHbWftoAq=WdVqyf+i=6SvsMogzWHh6SL3b=4sQ@mail.gmail.com>
Message-ID: <CAMj1kXGLMWqTHbWftoAq=WdVqyf+i=6SvsMogzWHh6SL3b=4sQ@mail.gmail.com>
Subject: Re: [RFC PATCH] arm64: remove CONFIG_DEBUG_ALIGN_RODATA feature
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	kernel-hardening@lists.openwall.com, Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 2 Apr 2020 at 13:30, Catalin Marinas <catalin.marinas@arm.com> wrote:
>
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

There is some wording in D4.4.5 (Behavior of caches at reset) that
suggests that implementations may permit cache hits in regions that
are mapped Non-cacheable (although the paragraph in question talks
about global controls and not page table attributes)

> Assuming that the CPU is behaving as we'd expect, are there other issues
> with peripherals/SMMU?
>

There is the NoSnoop PCIe issue as well: PCIe masters that are DMA
coherent in general can generate transactions with non-cacheable
attributes. I guess this is mostly orthogonal, but I'm sure it would
be much easier to reason about correctness if it is guaranteed that no
mappings with mismatched attributes exist anywhere.

> > > Fair enough, but I'd still like to see some numbers. If they're compelling,
> > > then we could explore something like CONFIG_OF_DMA_DEFAULT_COHERENT, but
> > > that doesn't really help the kconfig maze :(
>
> I'd prefer not to have a config option, we could easily break single
> Image at some point.
>
> > Could we make this a runtime thing? E.g., remap the entire linear
> > region down to pages under stop_machine() the first time we probe a
> > device that uses non-coherent DMA?
>
> That could be pretty expensive at run-time. With the ARMv8.4-TTRem
> feature, I wonder whether we could do this lazily when allocating
> non-coherent DMA buffers.
>
> (I still hope there isn't a problem at all with this mismatch ;)).
>

Now that we have the pieces to easily remap the linear region down to
pages, and [apparently] some generic infrastructure to manage the
linear aliases, the only downside is the alleged performance hit
resulting from increased TLB pressure. This is obviously highly
micro-architecture dependent, but with Xgene1 and ThunderX1 out of the
picture, I wonder if the tradeoffs are different now. Maybe by now, we
should just suck it up (Note that we had no complaints afaik regarding
the fact that we map the linear map down to pages by default now)
