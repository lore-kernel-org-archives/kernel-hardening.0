Return-Path: <SRS0=Amb1=AM=lists.openwall.com=kernel-hardening-return-19199-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57898C433DF
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Jul 2020 15:05:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B06A620760
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Jul 2020 15:05:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i74sl3ZO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B06A620760
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19199-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7532 invoked by uid 550); 1 Jul 2020 15:05:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7497 invoked from network); 1 Jul 2020 15:05:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yjUbAZQQ9f4rcShW5GkixqYv9x2nD42GGzyjdsiFm50=; b=i74sl3ZOPr1xqJIhkMJglGWOkB
	U8dqkz+3Y5fKVBDLcgGRCYbTPQFBGPgHtaCMun69vkwL/Ry/Z+4Jsl8Mf+SEd1g2rFtmyvmpbWIYZ
	K0Ycyjqzo60JLazLm+uQfh7KsY8FqjTzInhLzUzA/uu1WwZ1uS4jmIhsjRK2swdHfjsLC2mBUqXmb
	tjLVkf7OGf4kz+DTg9+2SwJMjK14kVHRsmKF/8JUPsny87vwFakQlM7eTrs35Vus1k5vP28RmJNHc
	Yyq+PGlJEHTv7w05Krc9LSs+q+qVge1miTYAIcksAas9z16JswYUyikbLlMyiWZjWWnmMZFBaj5Bf
	7m/rqxmg==;
Date: Wed, 1 Jul 2020 17:05:12 +0200
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
Message-ID: <20200701150512.GH4817@hirez.programming.kicks-ass.net>
References: <CAKwvOdmxz91c-M8egR9GdR1uOjeZv7-qoTP=pQ55nU8TCpkK6g@mail.gmail.com>
 <20200625080313.GY4817@hirez.programming.kicks-ass.net>
 <20200625082433.GC117543@hirez.programming.kicks-ass.net>
 <20200625085745.GD117543@hirez.programming.kicks-ass.net>
 <20200630191931.GA884155@elver.google.com>
 <20200630201243.GD4817@hirez.programming.kicks-ass.net>
 <20200630203016.GI9247@paulmck-ThinkPad-P72>
 <CANpmjNP+7TtE0WPU=nX5zs3T2+4hPkkm08meUm2VDVY3RgsHDw@mail.gmail.com>
 <20200701114027.GO4800@hirez.programming.kicks-ass.net>
 <20200701140654.GL9247@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701140654.GL9247@paulmck-ThinkPad-P72>

On Wed, Jul 01, 2020 at 07:06:54AM -0700, Paul E. McKenney wrote:

> The current state in the C++ committee is that marking variables
> carrying dependencies is the way forward.  This is of course not what
> the Linux kernel community does, but it should not be hard to have a
> -fall-variables-dependent or some such that causes all variables to be
> treated as if they were marked.  Though I was hoping for only pointers.
> Are they -sure- that they -absolutely- need to carry dependencies
> through integers???

What's 'need'? :-)

I'm thinking __ktime_get_fast_ns() is better off with a dependent load
than it is with an extra smp_rmb().

Yes we can stick an smp_rmb() in there, but I don't like it. Like I
wrote earlier, if I wanted a control dependency, I'd have written one.
