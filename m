Return-Path: <SRS0=QRrS=5S=lists.openwall.com=kernel-hardening-return-18379-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74148C43331
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 12:48:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CA8C5206F6
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 12:48:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA8C5206F6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18379-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29975 invoked by uid 550); 2 Apr 2020 12:48:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29943 invoked from network); 2 Apr 2020 12:48:32 -0000
Date: Thu, 2 Apr 2020 12:30:33 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	kernel-hardening@lists.openwall.com,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RFC PATCH] arm64: remove CONFIG_DEBUG_ALIGN_RODATA feature
Message-ID: <20200402113033.GD21087@mbp>
References: <20200329141258.31172-1-ardb@kernel.org>
 <20200330135121.GD10633@willie-the-truck>
 <CAMj1kXEZARZ1FYZFt4CZ33b-A64zj1JswR0OAHw-eZdzkxiEOQ@mail.gmail.com>
 <20200330140441.GE10633@willie-the-truck>
 <CAMj1kXHJ5n-EZMgGSYm+ekO-e7XTp7fv-FZ2NJ1EttJ=-kc8fw@mail.gmail.com>
 <20200330142805.GA11312@willie-the-truck>
 <CAMj1kXFcvHcU2kzP=N4bHgSkw_eE7wvbPJ=7w1pNeCWHbcPvTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFcvHcU2kzP=N4bHgSkw_eE7wvbPJ=7w1pNeCWHbcPvTQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Mar 30, 2020 at 04:32:31PM +0200, Ard Biesheuvel wrote:
> On Mon, 30 Mar 2020 at 16:28, Will Deacon <will@kernel.org> wrote:
> > > On Mon, 30 Mar 2020 at 16:04, Will Deacon <will@kernel.org> wrote:
> > > > On Mon, Mar 30, 2020 at 03:53:04PM +0200, Ard Biesheuvel wrote:
> > > > > On Mon, 30 Mar 2020 at 15:51, Will Deacon <will@kernel.org> wrote:
> > > > > > But I would really like to go a step further and rip out the block mapping
> > > > > > support altogether so that we can fix non-coherent DMA aliases:
> > > > > >
> > > > > > https://lore.kernel.org/lkml/20200224194446.690816-1-hch@lst.de
> > > > >
> > > > > I'm not sure I follow - is this about mapping parts of the static
> > > > > kernel Image for non-coherent DMA?
> > > >
> > > > Sorry, it's not directly related to your patch, just that if we're removing
> > > > options relating to kernel mappings then I'd be quite keen on effectively
> > > > forcing page-granularity on the linear map, as is currently done by default
> > > > thanks to RODATA_FULL_DEFAULT_ENABLED, so that we can nobble cacheable
> > > > aliases for non-coherent streaming DMA mappings by hooking into Christoph's
> > > > series above.

Have we ever hit this issue in practice? At least from the CPU
perspective, we've assumed that a non-cacheable access would not hit in
the cache. Reading the ARM ARM rules, it doesn't seem to state this
explicitly but we can ask for clarification (I dug out an email from
2015, left unanswered).

Assuming that the CPU is behaving as we'd expect, are there other issues
with peripherals/SMMU?

> > Fair enough, but I'd still like to see some numbers. If they're compelling,
> > then we could explore something like CONFIG_OF_DMA_DEFAULT_COHERENT, but
> > that doesn't really help the kconfig maze :(

I'd prefer not to have a config option, we could easily break single
Image at some point.

> Could we make this a runtime thing? E.g., remap the entire linear
> region down to pages under stop_machine() the first time we probe a
> device that uses non-coherent DMA?

That could be pretty expensive at run-time. With the ARMv8.4-TTRem
feature, I wonder whether we could do this lazily when allocating
non-coherent DMA buffers.

(I still hope there isn't a problem at all with this mismatch ;)).

-- 
Catalin
