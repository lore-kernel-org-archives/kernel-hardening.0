Return-Path: <SRS0=TdrU=AO=lists.openwall.com=kernel-hardening-return-19207-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ABCCC433E0
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Jul 2020 13:25:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CB1C920760
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Jul 2020 13:25:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zDmqGVF3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB1C920760
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19207-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26539 invoked by uid 550); 3 Jul 2020 13:25:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26501 invoked from network); 3 Jul 2020 13:25:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mTUdInrl0UZ5/CAUTtR8K6FDHzAHWr9fq3pJX4MJ7Gs=; b=zDmqGVF3FOX7aSDK4H8sAB/UGf
	KrxUneT0wbec5AHPOWFWgsQ58J7O+x9kLSh6PJJns7NSEVQU5N9HLWo16vbkLGQakk7aa0dWh7QcL
	grhzH9Vhd13yLmAKDlzxBAGgMJUMhc2N63hyENk4ip1OBwF3lMnThKgxhGjHOf93UVGDhIJabxxdh
	PUNVs3yxqSKjZQoFoCbxqN8YldUcpszlAWVdmsX979wqXUgCBvBmOoPH/nHcee/NLh6hdRgtBFf9u
	OxuXx54Xhpa+MCreoZf20laWaE2S6iSRhTAi9+Q78S4yOV4Vk9Mo0GC1/n+tL0uvPfxff2DnoUFjs
	DrqF4xAQ==;
Date: Fri, 3 Jul 2020 15:25:23 +0200
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
Message-ID: <20200703132523.GM117543@hirez.programming.kicks-ass.net>
References: <20200630201243.GD4817@hirez.programming.kicks-ass.net>
 <20200630203016.GI9247@paulmck-ThinkPad-P72>
 <CANpmjNP+7TtE0WPU=nX5zs3T2+4hPkkm08meUm2VDVY3RgsHDw@mail.gmail.com>
 <20200701114027.GO4800@hirez.programming.kicks-ass.net>
 <20200701140654.GL9247@paulmck-ThinkPad-P72>
 <20200701150512.GH4817@hirez.programming.kicks-ass.net>
 <20200701160338.GN9247@paulmck-ThinkPad-P72>
 <20200702082040.GB4781@hirez.programming.kicks-ass.net>
 <20200702175948.GV9247@paulmck-ThinkPad-P72>
 <20200703131330.GX4800@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200703131330.GX4800@hirez.programming.kicks-ass.net>

On Fri, Jul 03, 2020 at 03:13:30PM +0200, Peter Zijlstra wrote:
> > The prototype for GCC is here: https://github.com/AKG001/gcc/
> 
> Thanks! Those test cases are somewhat over qualified though:
> 
>        static volatile _Atomic (TYPE) * _Dependent_ptr a;     		\

One question though; since its a qualifier, and we've recently spend a
whole lot of effort to strip qualifiers in say READ_ONCE(), how does,
and how do we want, this qualifier to behave.

C++ has very convenient means of manipulating qualifiers, so it's not
much of a problem there, but for C it is, as we've found, really quite
cumbersome. Even with _Generic() we can't manipulate individual
qualifiers afaict.
