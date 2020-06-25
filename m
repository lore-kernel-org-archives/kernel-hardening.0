Return-Path: <SRS0=Czr4=AG=lists.openwall.com=kernel-hardening-return-19162-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F55C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jun 2020 08:24:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4F785207E8
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jun 2020 08:24:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ibvgrw/6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F785207E8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19162-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20454 invoked by uid 550); 25 Jun 2020 08:24:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20416 invoked from network); 25 Jun 2020 08:24:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3AMdYg8fQNUtXAfj2fZZ8NPZ9U5EFgepOOFBuun2GQY=; b=ibvgrw/6VgAeXKGL/ZvFOV5Ile
	k/DG2hTUgCNpBFh0SVRZtiOzJ0tqIzRrnNRTZQdCWgPu3f3vKwwqumEO3VAaSPjMg/ls3R3fwVjKM
	Nhs12sSgDR+t8SDyMh/h3ITlxN3ZcgcTvbI7CAd5D8YCcq8qCphd0KnXhjA+ZVPLtaGvU/eak1k++
	6iVJ/9DrfMDdhwuZ5/zvsYALWHu77JxkNZKUQ+1riHrSFoU2dIT3hgk0fU4PGeIKpR0kVxQwAc5hC
	H0eBkD5up1mt7ynRtI/herLh3Yr5SxMM5rpkTFOeHKnOBtnv2OaV3fJ7KHA9qL8uVglbMrLJEM+Gs
	wUku04xw==;
Date: Thu, 25 Jun 2020 10:24:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 00/22] add support for Clang LTO
Message-ID: <20200625082433.GC117543@hirez.programming.kicks-ass.net>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624211540.GS4817@hirez.programming.kicks-ass.net>
 <CAKwvOdmxz91c-M8egR9GdR1uOjeZv7-qoTP=pQ55nU8TCpkK6g@mail.gmail.com>
 <20200625080313.GY4817@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625080313.GY4817@hirez.programming.kicks-ass.net>

On Thu, Jun 25, 2020 at 10:03:13AM +0200, Peter Zijlstra wrote:
> On Wed, Jun 24, 2020 at 02:31:36PM -0700, Nick Desaulniers wrote:
> > On Wed, Jun 24, 2020 at 2:15 PM Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > > On Wed, Jun 24, 2020 at 01:31:38PM -0700, Sami Tolvanen wrote:
> > > > This patch series adds support for building x86_64 and arm64 kernels
> > > > with Clang's Link Time Optimization (LTO).
> > > >
> > > > In addition to performance, the primary motivation for LTO is to allow
> > > > Clang's Control-Flow Integrity (CFI) to be used in the kernel. Google's
> > > > Pixel devices have shipped with LTO+CFI kernels since 2018.
> > > >
> > > > Most of the patches are build system changes for handling LLVM bitcode,
> > > > which Clang produces with LTO instead of ELF object files, postponing
> > > > ELF processing until a later stage, and ensuring initcall ordering.
> > > >
> > > > Note that first objtool patch in the series is already in linux-next,
> > > > but as it's needed with LTO, I'm including it also here to make testing
> > > > easier.
> > >
> > > I'm very sad that yet again, memory ordering isn't addressed. LTO vastly
> > > increases the range of the optimizer to wreck things.
> > 
> > Hi Peter, could you expand on the issue for the folks on the thread?
> > I'm happy to try to hack something up in LLVM if we check that X does
> > or does not happen; maybe we can even come up with some concrete test
> > cases that can be added to LLVM's codebase?
> 
> I'm sure Will will respond, but the basic issue is the trainwreck C11
> made of dependent loads.
> 
> Anyway, here's a link to the last time this came up:
> 
>   https://lore.kernel.org/linux-arm-kernel/20171116174830.GX3624@linux.vnet.ibm.com/

Another good read:

  https://lore.kernel.org/lkml/20150520005510.GA23559@linux.vnet.ibm.com/

and having (partially) re-read that, I now worry intensily about things
like latch_tree_find(), cyc2ns_read_begin, __ktime_get_fast_ns().

It looks like kernel/time/sched_clock.c uses raw_read_seqcount() which
deviates from the above patterns by, for some reason, using a primitive
that includes an extra smp_rmb().

And this is just the few things I could remember off the top of my head,
who knows what else is out there.
