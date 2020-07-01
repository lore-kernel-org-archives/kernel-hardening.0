Return-Path: <SRS0=pHSZ=AM=lists.openwall.com=kernel-hardening-return-19200-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B934C433E2
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Jul 2020 16:03:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D7871206C3
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Jul 2020 16:03:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZHXG8ON1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7871206C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19200-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1282 invoked by uid 550); 1 Jul 2020 16:03:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1249 invoked from network); 1 Jul 2020 16:03:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593619418;
	bh=lsVbSj/ss2har/B90Io45Cd2wBUKELeZ+wmjiYF4Efg=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=ZHXG8ON1MQAVd0WWgmGngqjNTqPZiPz9LyxrPLzmg1Y9mxBRyPhX4Zk5/ivtnj4n3
	 eptU/PsHOZLsOUUXwHFNa+8Zr9742CVsM7nWCzeGKTuFDM4VzgjHe4h0BXahzgELZw
	 AFEbkSo/wshrekgHPJScGghJKuijNH54TSiSEgIg=
Date: Wed, 1 Jul 2020 09:03:38 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Marco Elver <elver@google.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kees Cook <keescook@chromium.org>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 00/22] add support for Clang LTO
Message-ID: <20200701160338.GN9247@paulmck-ThinkPad-P72>
References: <20200625080313.GY4817@hirez.programming.kicks-ass.net>
 <20200625082433.GC117543@hirez.programming.kicks-ass.net>
 <20200625085745.GD117543@hirez.programming.kicks-ass.net>
 <20200630191931.GA884155@elver.google.com>
 <20200630201243.GD4817@hirez.programming.kicks-ass.net>
 <20200630203016.GI9247@paulmck-ThinkPad-P72>
 <CANpmjNP+7TtE0WPU=nX5zs3T2+4hPkkm08meUm2VDVY3RgsHDw@mail.gmail.com>
 <20200701114027.GO4800@hirez.programming.kicks-ass.net>
 <20200701140654.GL9247@paulmck-ThinkPad-P72>
 <20200701150512.GH4817@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701150512.GH4817@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Wed, Jul 01, 2020 at 05:05:12PM +0200, Peter Zijlstra wrote:
> On Wed, Jul 01, 2020 at 07:06:54AM -0700, Paul E. McKenney wrote:
> 
> > The current state in the C++ committee is that marking variables
> > carrying dependencies is the way forward.  This is of course not what
> > the Linux kernel community does, but it should not be hard to have a
> > -fall-variables-dependent or some such that causes all variables to be
> > treated as if they were marked.  Though I was hoping for only pointers.
> > Are they -sure- that they -absolutely- need to carry dependencies
> > through integers???
> 
> What's 'need'? :-)

Turning off all dependency-killing optimizations on all pointers is
likely a non-event.  Turning off all dependency-killing optimizations
on all integers is not the road to happiness.

So whatever "need" might be, it would need to be rather earthshaking.  ;-)
It is probably not -that- hard to convert to pointers, even if they
are indexing multiple arrays.

> I'm thinking __ktime_get_fast_ns() is better off with a dependent load
> than it is with an extra smp_rmb().
> 
> Yes we can stick an smp_rmb() in there, but I don't like it. Like I
> wrote earlier, if I wanted a control dependency, I'd have written one.

No argument here.

But it looks like we are going to have to tell the compiler.

							Thanx, Paul
