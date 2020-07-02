Return-Path: <SRS0=AK1k=AN=lists.openwall.com=kernel-hardening-return-19205-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D513BC433DF
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Jul 2020 18:01:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 342B220870
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Jul 2020 18:01:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="QWmK8WMR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 342B220870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19205-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7457 invoked by uid 550); 2 Jul 2020 18:00:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7419 invoked from network); 2 Jul 2020 18:00:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593712842;
	bh=Hak91qzk3x/aeXBK1n/XMiTpR5KSRvENrzPRsP83yxM=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=QWmK8WMRCdHSwyVK000d5y6dbgLM+MjgvdkwYsTsrjr5LZBrjrxYWW1nMi6rZxccV
	 IiaPyrs2F2bjvlZIb4WjffkjC0aKcE/DRPRkmEy2Vz5+fS5gilxXEQzxwjlFv3ETvE
	 BcELqK8pbmTnqz6ggKuzaDwzCOlpTPOwyp2kT1xI=
Date: Thu, 2 Jul 2020 11:00:42 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: David Laight <David.Laight@ACULAB.COM>
Cc: 'Peter Zijlstra' <peterz@infradead.org>, Marco Elver <elver@google.com>,
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
	LKML <linux-kernel@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 00/22] add support for Clang LTO
Message-ID: <20200702180042.GW9247@paulmck-ThinkPad-P72>
References: <20200625080313.GY4817@hirez.programming.kicks-ass.net>
 <20200625082433.GC117543@hirez.programming.kicks-ass.net>
 <20200625085745.GD117543@hirez.programming.kicks-ass.net>
 <20200630191931.GA884155@elver.google.com>
 <20200630201243.GD4817@hirez.programming.kicks-ass.net>
 <20200630203016.GI9247@paulmck-ThinkPad-P72>
 <20200701091054.GW4781@hirez.programming.kicks-ass.net>
 <4427b0f825324da4b1640e32265b04bd@AcuMS.aculab.com>
 <20200701160624.GO9247@paulmck-ThinkPad-P72>
 <aeed740a4d86470d84ae7d5f1cf07951@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeed740a4d86470d84ae7d5f1cf07951@AcuMS.aculab.com>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Thu, Jul 02, 2020 at 09:37:26AM +0000, David Laight wrote:
> From: Paul E. McKenney
> > Sent: 01 July 2020 17:06
> ...
> > > Would an asm statement that uses the same 'register' for input and
> > > output but doesn't actually do anything help?
> > > It won't generate any code, but the compiler ought to assume that
> > > it might change the value - so can't do optimisations that track
> > > the value across the call.
> > 
> > It might replace the volatile load, but there are optimizations that
> > apply to the downstream code as well.
> > 
> > Or are you suggesting periodically pushing the dependent variable
> > through this asm?  That might work, but it would be easier and
> > more maintainable to just mark the variable.
> 
> Marking the variable requires compiler support.
> Although what 'volatile register int foo;' means might be interesting.
> 
> So I was thinking that in the case mentioned earlier you do:
> 	ptr += LAUNDER(offset & 1);
> to ensure the compiler didn't convert to:
> 	if (offset & 1) ptr++;
> (Which is probably a pessimisation - the reverse is likely better.)

Indeed, Akshat's prototype follows the "volatile" qualifier in many
ways.  https://github.com/AKG001/gcc/

							Thanx, Paul
