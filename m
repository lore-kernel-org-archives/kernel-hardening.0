Return-Path: <SRS0=PKF0=AM=lists.openwall.com=kernel-hardening-return-19195-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F4AC433E0
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Jul 2020 10:04:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8FD882073E
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Jul 2020 10:04:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ACTOMog6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FD882073E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19195-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21946 invoked by uid 550); 1 Jul 2020 10:04:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21908 invoked from network); 1 Jul 2020 10:04:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593597844;
	bh=TNs9dwunGLESHIUTn3WPSH+kJ4ymDC60LJKhDKcwQ+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ACTOMog6G7ls0ARoC7jAptS3bHf4H/M+sf80vr+5+gHs+a+qnec0OCDmenyBz9hA4
	 JvZrijIz9n77vFlikbI+f42x1lmidFrYxvr9l9eKKfMFWvHcDZD1Um+tcsybykZPp5
	 hmi3Id23gmOaZNr6xrgZarcWcGcX/fdtKQ8k6vy4=
Date: Wed, 1 Jul 2020 11:03:59 +0100
From: Will Deacon <will@kernel.org>
To: Marco Elver <elver@google.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
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
Message-ID: <20200701100358.GA14959@willie-the-truck>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624211540.GS4817@hirez.programming.kicks-ass.net>
 <CAKwvOdmxz91c-M8egR9GdR1uOjeZv7-qoTP=pQ55nU8TCpkK6g@mail.gmail.com>
 <20200625080313.GY4817@hirez.programming.kicks-ass.net>
 <20200625082433.GC117543@hirez.programming.kicks-ass.net>
 <20200625085745.GD117543@hirez.programming.kicks-ass.net>
 <20200630191931.GA884155@elver.google.com>
 <20200630201243.GD4817@hirez.programming.kicks-ass.net>
 <20200630203016.GI9247@paulmck-ThinkPad-P72>
 <CANpmjNP+7TtE0WPU=nX5zs3T2+4hPkkm08meUm2VDVY3RgsHDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNP+7TtE0WPU=nX5zs3T2+4hPkkm08meUm2VDVY3RgsHDw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Jul 01, 2020 at 11:41:17AM +0200, Marco Elver wrote:
> On Tue, 30 Jun 2020 at 22:30, Paul E. McKenney <paulmck@kernel.org> wrote:
> > On Tue, Jun 30, 2020 at 10:12:43PM +0200, Peter Zijlstra wrote:
> > > On Tue, Jun 30, 2020 at 09:19:31PM +0200, Marco Elver wrote:
> > > > So, we are probably better off untangling LTO from the story:
> > > >
> > > > 1. LTO or no LTO does not matter. The LTO series should not get tangled
> > > >    up with memory model issues.
> > > >
> > > > 2. The memory model question and problems need to be answered and
> > > >    addressed separately.
> > > >
> > > > Thoughts?
> > >
> > > How hard would it be to creates something that analyzes a build and
> > > looks for all 'dependent load -> control dependency' transformations
> > > headed by a volatile (and/or from asm) load and issues a warning for
> > > them?
> 
> I was thinking about this, but in the context of the "auto-promote to
> acquire" which you didn't like. Issuing a warning should certainly be
> simpler.
> 
> I think there is no one place where we know these transformations
> happen, but rather, need to analyze the IR before transformations,
> take note of all the dependent loads headed by volatile+asm, and then
> run an analysis after optimizations checking the dependencies are
> still there.
> 
> > > This would give us an indication of how valuable this transformation is
> > > for the kernel. I'm hoping/expecting it's vanishingly rare, but what do
> > > I know.
> >
> > This could be quite useful!
> 
> We might then even be able to say, "if you get this warning, turn on
> CONFIG_ACQUIRE_READ_DEPENDENCIES" (or however the option will be
> named). Or some other tricks, like automatically recompile the TU
> where this happens with the option. But again, this is not something
> that should specifically block LTO, because if we have this, we'll
> need to turn it on for everything.

I'm not especially keen on solving this with additional config options --
all it does it further fragment the number of kernels we have to care about
and distributions really won't be in a position to know whether this should
be enabled or not. I would prefer that the build fails, and we figure out
which compiler switch we need to stop the harmful optimisation taking place.
As Peter says, it _should_ be a rare thing to see (empirically, the kernel
seems to be getting away with it so far).

The problem, as I see it, is that the C language doesn't provide us with
a way to express dependency ordering and so we're at the mercy of the
compiler when we roll our own implementation. Paul continues to fight the
good fight at committee meetings to improve the situation, but in the
meantime we'd benefit from two things:

  1. A way to disable any compiler optimisations that break our dependency
     ordering in spite of READ_ONCE()

  2. A way to detect at build time if these harmful optimisations are taking
     place

Finally, while I agree that this problem isn't limited to LTO, my fear is
that LTO provides enough information for address dependencies headed by
a READ_ONCE() to be converted to control dependencies when some common
values of the pointer can be determined by the compiler. If we can rule
this sort of thing out, then great, but in the absence of (2) I think
throwing in an acquire is a sensible safety measure. Doesn't CFI rely
on LTO to do something similar for indirect branch targets, or have I
got that totally mixed up?

Will
