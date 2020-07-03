Return-Path: <SRS0=2v01=AO=lists.openwall.com=kernel-hardening-return-19206-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC8B0C433E0
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Jul 2020 13:13:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 17286208E4
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Jul 2020 13:13:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ItGZjDRI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17286208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19206-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15905 invoked by uid 550); 3 Jul 2020 13:13:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15871 invoked from network); 3 Jul 2020 13:13:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uqsQimSA3ZVIJmzJ+g3hxvE+rQFiKwkEojhvCeRdahw=; b=ItGZjDRIImf27YsAGtOG8yy/um
	tHTSFrVgQyOISf1u9ovbSydWGKTsYFOu1QdZqaIrPrVC+BQULRRFgfurUr+UHbhbVAjFYXc0yCGNH
	NRV6Ty0xvDowLbPzhWsEfUHzZqw0FT874nx/34bvhnQsXXmIDYEOYRNqxPNQYH8rAHKE2/8AwTRk8
	wHLizFfF5+qhuvmcj3dz1f5NSP8/5ZJsGkhy1O/RcYnmb5zr+RExexvUuyCwYq8Luedw4dSOP2EUv
	Sin4pSha9/RbjtlWc8OZlJovtZ17d+oq5poGsjxjQDDenUnzl1rkiSj26lYRo48qjQPCyZuX1TsWH
	IDaagGpA==;
Date: Fri, 3 Jul 2020 15:13:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
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
Message-ID: <20200703131330.GX4800@hirez.programming.kicks-ass.net>
References: <20200630191931.GA884155@elver.google.com>
 <20200630201243.GD4817@hirez.programming.kicks-ass.net>
 <20200630203016.GI9247@paulmck-ThinkPad-P72>
 <CANpmjNP+7TtE0WPU=nX5zs3T2+4hPkkm08meUm2VDVY3RgsHDw@mail.gmail.com>
 <20200701114027.GO4800@hirez.programming.kicks-ass.net>
 <20200701140654.GL9247@paulmck-ThinkPad-P72>
 <20200701150512.GH4817@hirez.programming.kicks-ass.net>
 <20200701160338.GN9247@paulmck-ThinkPad-P72>
 <20200702082040.GB4781@hirez.programming.kicks-ass.net>
 <20200702175948.GV9247@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702175948.GV9247@paulmck-ThinkPad-P72>

On Thu, Jul 02, 2020 at 10:59:48AM -0700, Paul E. McKenney wrote:
> On Thu, Jul 02, 2020 at 10:20:40AM +0200, Peter Zijlstra wrote:
> > On Wed, Jul 01, 2020 at 09:03:38AM -0700, Paul E. McKenney wrote:
> > 
> > > But it looks like we are going to have to tell the compiler.
> > 
> > What does the current proposal look like? I can certainly annotate the
> > seqcount latch users, but who knows what other code is out there....
> 
> For pointers, yes, within the Linux kernel it is hopeless, thus the
> thought of a -fall-dependent-ptr or some such that makes the compiler
> pretend that each and every pointer is marked with the _Dependent_ptr
> qualifier.
> 
> New non-Linux-kernel code might want to use his qualifier explicitly,
> perhaps something like the following:
> 
> 	_Dependent_ptr struct foo *p;  // Or maybe after the "*"?

After, as you've written it, it's a pointer to a '_Dependent struct
foo'.

> 
> 	rcu_read_lock();
> 	p = rcu_dereference(gp);
> 	// And so on...
> 
> If a function is to take a dependent pointer as a function argument,
> then the corresponding parameter need the _Dependent_ptr marking.
> Ditto for return values.
> 
> The proposal did not cover integers due to concerns about the number of
> optimization passes that would need to be reviewed to make that work.
> Nevertheless, using a marked integer would be safer than using an unmarked
> one, and if the review can be carried out, why not?  Maybe something
> like this:
> 
> 	_Dependent_ptr int idx;
> 
> 	rcu_read_lock();
> 	idx = READ_ONCE(gidx);
> 	d = rcuarray[idx];
> 	rcu_read_unlock();
> 	do_something_with(d);
> 
> So use of this qualifier is quite reasonable.

The above usage might warrant a rename of the qualifier though, since
clearly there isn't anything ptr around.

> The prototype for GCC is here: https://github.com/AKG001/gcc/

Thanks! Those test cases are somewhat over qualified though:

       static volatile _Atomic (TYPE) * _Dependent_ptr a;     		\

Also, if C goes and specifies load dependencies, in any form, is then
not the corrolary that they need to specify control dependencies? How
else can they exclude the transformation.

And of course, once we're there, can we get explicit support for control
dependencies too? :-) :-)
