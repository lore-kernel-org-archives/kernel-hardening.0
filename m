Return-Path: <SRS0=BIu8=AO=lists.openwall.com=kernel-hardening-return-19209-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F1FCC433E0
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Jul 2020 14:52:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B20D5206BE
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Jul 2020 14:52:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="P08qXOSK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B20D5206BE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19209-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3607 invoked by uid 550); 3 Jul 2020 14:52:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3575 invoked from network); 3 Jul 2020 14:52:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593787911;
	bh=OfQ9QrrhTEkwVc9D/6kQ4OLMbBVifUwGjpIqyu/to+g=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=P08qXOSK/SsmY8VAxSWxJZlh9y2mElMtAZzYp/JpETdbeuKyxfeNiEOPVeAjMtgmm
	 cVQ6zWd/th8wPaVLaFElx/6ZkEKB/7VSwS0fonaGWl2nOftDG+g5Bf9ZqxlWOJSJrJ
	 eDszUhoHxsOqHSNzzZyn6clVtx/aI8MGpxWzyq84=
Date: Fri, 3 Jul 2020 07:51:51 -0700
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
Message-ID: <20200703145151.GG9247@paulmck-ThinkPad-P72>
References: <20200630203016.GI9247@paulmck-ThinkPad-P72>
 <CANpmjNP+7TtE0WPU=nX5zs3T2+4hPkkm08meUm2VDVY3RgsHDw@mail.gmail.com>
 <20200701114027.GO4800@hirez.programming.kicks-ass.net>
 <20200701140654.GL9247@paulmck-ThinkPad-P72>
 <20200701150512.GH4817@hirez.programming.kicks-ass.net>
 <20200701160338.GN9247@paulmck-ThinkPad-P72>
 <20200702082040.GB4781@hirez.programming.kicks-ass.net>
 <20200702175948.GV9247@paulmck-ThinkPad-P72>
 <20200703131330.GX4800@hirez.programming.kicks-ass.net>
 <20200703132523.GM117543@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200703132523.GM117543@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Fri, Jul 03, 2020 at 03:25:23PM +0200, Peter Zijlstra wrote:
> On Fri, Jul 03, 2020 at 03:13:30PM +0200, Peter Zijlstra wrote:
> > > The prototype for GCC is here: https://github.com/AKG001/gcc/
> > 
> > Thanks! Those test cases are somewhat over qualified though:
> > 
> >        static volatile _Atomic (TYPE) * _Dependent_ptr a;     		\
> 
> One question though; since its a qualifier, and we've recently spend a
> whole lot of effort to strip qualifiers in say READ_ONCE(), how does,
> and how do we want, this qualifier to behave.

Dereferencing a _Dependent_ptr pointer gives you something that is not
_Dependent_ptr, unless the declaration was like this:

	_Dependent_ptr _Atomic (TYPE) * _Dependent_ptr a;

And if I recall correctly, the current state is that assigning a
_Dependent_ptr variable to a non-_Dependent_ptr variable strips this
marking (though the thought was to be able to ask for a warning).

So, yes, it would be nice to be able to explicitly strip the
_Dependent_ptr, perhaps the kill_dependency() macro, which is already
in the C standard.

> C++ has very convenient means of manipulating qualifiers, so it's not
> much of a problem there, but for C it is, as we've found, really quite
> cumbersome. Even with _Generic() we can't manipulate individual
> qualifiers afaict.

Fair point, and in C++ this is a templated class, at least in the same
sense that std::atomic<> is a templated class.

But in this case, would kill_dependency do what you want?

							Thanx, Paul
