Return-Path: <SRS0=hG8q=AG=lists.openwall.com=kernel-hardening-return-19164-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2170C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jun 2020 08:58:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0E2D32072E
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jun 2020 08:58:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dhVJmH7i"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E2D32072E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19164-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5733 invoked by uid 550); 25 Jun 2020 08:58:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5701 invoked from network); 25 Jun 2020 08:58:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oaHjYuJa/3zuClzIH+/g+fhPoe4mw4jvJXlUfLpBRwo=; b=dhVJmH7iCebSecH6ztLVh/a9AX
	q/FRl+8k3rSxsroM7W9JVbb4ruGWGY7b3ylToiN3VKMgxN8q00TRkiBpCp8haU8MShPGRK/s8jkgg
	w3YBszL7uKIGNLBTLhESs/x80y6d0palNb62gZGEGSMiegKRbb9GXJ9f1wHqqmzeO1jX7JiN9/HsX
	aTa1JqeZNh93t14b58sd/SSqgpOlSZ8pEHH5Qo6ELxJU7Vf2AGwoPRrjAW1izwzD6GTzOsKkAJ0LL
	Ve/bAcUlLidRSKJGMMkj+0+VwBHrbE7cgi6LsUKtOByycYPJrSQmUl57IXr4MTgW/JLH3ka/h2HLc
	xcYWPkgA==;
Date: Thu, 25 Jun 2020 10:57:45 +0200
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
Message-ID: <20200625085745.GD117543@hirez.programming.kicks-ass.net>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624211540.GS4817@hirez.programming.kicks-ass.net>
 <CAKwvOdmxz91c-M8egR9GdR1uOjeZv7-qoTP=pQ55nU8TCpkK6g@mail.gmail.com>
 <20200625080313.GY4817@hirez.programming.kicks-ass.net>
 <20200625082433.GC117543@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625082433.GC117543@hirez.programming.kicks-ass.net>

On Thu, Jun 25, 2020 at 10:24:33AM +0200, Peter Zijlstra wrote:
> On Thu, Jun 25, 2020 at 10:03:13AM +0200, Peter Zijlstra wrote:

> > I'm sure Will will respond, but the basic issue is the trainwreck C11
> > made of dependent loads.
> > 
> > Anyway, here's a link to the last time this came up:
> > 
> >   https://lore.kernel.org/linux-arm-kernel/20171116174830.GX3624@linux.vnet.ibm.com/
> 
> Another good read:
> 
>   https://lore.kernel.org/lkml/20150520005510.GA23559@linux.vnet.ibm.com/
> 
> and having (partially) re-read that, I now worry intensily about things
> like latch_tree_find(), cyc2ns_read_begin, __ktime_get_fast_ns().
> 
> It looks like kernel/time/sched_clock.c uses raw_read_seqcount() which
> deviates from the above patterns by, for some reason, using a primitive
> that includes an extra smp_rmb().
> 
> And this is just the few things I could remember off the top of my head,
> who knows what else is out there.

As an example, let us consider __ktime_get_fast_ns(), the critical bit
is:

		seq = raw_read_seqcount_latch(&tkf->seq);
		tkr = tkf->base + (seq & 0x01);
		now = tkr->base;

And we hard rely on that being a dependent load, so:

  LOAD	seq, (tkf->seq)
  LOAD  tkr, tkf->base
  AND   seq, 1
  MUL   seq, sizeof(tk_read_base)
  ADD	tkr, seq
  LOAD  now, (tkr->base)

Such that we obtain 'now' as a direct dependency on 'seq'. This ensures
the loads are ordered.

A compiler can wreck this by translating it into something like:

  LOAD	seq, (tkf->seq)
  LOAD  tkr, tkf->base
  AND   seq, 1
  CMP	seq, 0
  JE	1f
  ADD	tkr, sizeof(tk_read_base)
1:
  LOAD  now, (tkr->base)

Because now the machine can speculate and load now before seq, breaking
the ordering.
