Return-Path: <SRS0=i4tZ=AM=lists.openwall.com=kernel-hardening-return-19194-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 701DAC433E0
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Jul 2020 09:41:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9D80C206BE
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Jul 2020 09:41:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H7o1FK36"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D80C206BE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19194-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3611 invoked by uid 550); 1 Jul 2020 09:41:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3559 invoked from network); 1 Jul 2020 09:41:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K9iKD+F/OF6s9Kp12TelhQnccbvpriP6YsVg5s2kKxg=;
        b=H7o1FK36Av5Vjv+Q3VkC/N8On4/MMdCVKO2CwlE8Cx6b2I7fZlqPQUeJkhuXoCnBcE
         RKtEoHPsTQnU5CltTzf2qp2o0u0H99FzVIzmLQyVhmVpgSuR0u7SLkB7OAetkKiszJu0
         n4d+cH2Iyl2SRwFYqzYar9P4raCt6l5BcuAjiTpV6HT3pChjDlrgCAADLesH+W8Efgrb
         OFNjbvENj3ZlgFxHXExiJ09YptWgV2nm7U59ox5YHDdXP+36RvgBe2acSzsZRH3nblsy
         fwWbtDlUUB+2hvXDmM55xw7Pk16aflcrGeROoPjApELAmr/SMMx6XjD07uL4W08UemvE
         8enQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K9iKD+F/OF6s9Kp12TelhQnccbvpriP6YsVg5s2kKxg=;
        b=lr2mMhHuFRNDKD/oB3dwXGqIEZKfixterH/W2BkXOGNh4Qp75XJKrl1+9NaglVJO2V
         KD3drlVpYDIf95sqCcnm8Yv+g0hmYPQTU5TmhOjK+2emE0OVAZWTAs2Bi79wfAtzWogt
         xQIIg/MY5Q6H5zgKyKRypNIkDnSsFp+6WXA6YdeKdw0BftH8ajd3oY7TnEZgzIXnfdyl
         Z8B3OfyTYsEYR5sduV3zuKpzVIhOsRnAmgbcN+EZqT2RXwh6k4lnftFd9FZX1XXnYVMY
         jeoQUXre94eZFbW1HsIZil0X0uSPJqjfyOjGVYshvJUFjoLzDCPjrXHVsHqud6Aur90+
         Aw5g==
X-Gm-Message-State: AOAM530xcm3cGqLonEv3oNKFRckPNhjR718FQDVgH9p78cpV071M4A54
	TNG9GzHfoZax5z1kRKGMFuYXLZUEW7HQSBQOaEoqbA==
X-Google-Smtp-Source: ABdhPJzl4bnGERYZKaXiuXUrz769e/ajPazLQIYj61l3IfMpQkbUUQHtlVLThJxvWT7H9VFLW/8bm8OOg0CkDZYkJRQ=
X-Received: by 2002:a4a:2d54:: with SMTP id s20mr22003435oof.14.1593596488545;
 Wed, 01 Jul 2020 02:41:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624211540.GS4817@hirez.programming.kicks-ass.net> <CAKwvOdmxz91c-M8egR9GdR1uOjeZv7-qoTP=pQ55nU8TCpkK6g@mail.gmail.com>
 <20200625080313.GY4817@hirez.programming.kicks-ass.net> <20200625082433.GC117543@hirez.programming.kicks-ass.net>
 <20200625085745.GD117543@hirez.programming.kicks-ass.net> <20200630191931.GA884155@elver.google.com>
 <20200630201243.GD4817@hirez.programming.kicks-ass.net> <20200630203016.GI9247@paulmck-ThinkPad-P72>
In-Reply-To: <20200630203016.GI9247@paulmck-ThinkPad-P72>
From: Marco Elver <elver@google.com>
Date: Wed, 1 Jul 2020 11:41:17 +0200
Message-ID: <CANpmjNP+7TtE0WPU=nX5zs3T2+4hPkkm08meUm2VDVY3RgsHDw@mail.gmail.com>
Subject: Re: [PATCH 00/22] add support for Clang LTO
To: "Paul E. McKenney" <paulmck@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Sami Tolvanen <samitolvanen@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 30 Jun 2020 at 22:30, Paul E. McKenney <paulmck@kernel.org> wrote:
> On Tue, Jun 30, 2020 at 10:12:43PM +0200, Peter Zijlstra wrote:
> > On Tue, Jun 30, 2020 at 09:19:31PM +0200, Marco Elver wrote:

> > > First of all, I agree with the concerns, but not because of LTO.
> > >
> > > To set the stage better, and summarize the fundamental problem again:
> > > we're in the unfortunate situation that no compiler today has a way to
> > > _efficiently_ deal with C11's memory_order_consume
> > > [https://lwn.net/Articles/588300/]. If we did, we could just use that
> > > and be done with it. But, sadly, that doesn't seem possible right now --
> > > compilers just say consume==acquire.
> >
> > I'm not convinced C11 memory_order_consume would actually work for us,
> > even if it would work. That is, given:
> >
> >   https://lore.kernel.org/lkml/20150520005510.GA23559@linux.vnet.ibm.com/
> >
> > only pointers can have consume, but like I pointed out, we have code
> > that relies on dependent loads from integers.
>
> I agree that C11 memory_order_consume is not normally what we want,
> given that it is universally promoted to memory_order_acquire.
>
> However, dependent loads from integers are, if anything, more difficult
> to defend from the compiler than are control dependencies.  This applies
> doubly to integers that are used to index two-element arrays, in which
> case you are just asking the compiler to destroy your dependent loads
> by converting them into control dependencies.
>
> > > Will suggests doing the same in the
> > > kernel: https://lkml.kernel.org/r/20200630173734.14057-19-will@kernel.org
> >
> > PowerPC would need a similar thing, it too will not preserve causality
> > for control dependecies.
> >
> > > What we're most worried about right now is the existence of compiler
> > > transformations that could break data dependencies by e.g. turning them
> > > into control dependencies.
> >
> > Correct.
> >
> > > If this is a real worry, I don't think LTO is the magical feature that
> > > will uncover those optimizations. If these compiler transformations are
> > > real, they also exist in a normal build!
> >
> > Agreed, _however_ with the caveat that LTO could make them more common.
> >
> > After all, with whole program analysis, the compiler might be able to
> > more easily determine that our pointer @ptr is only ever assigned the
> > values of &A, &B or &C, while without that visibility it would not be
> > able to determine this.
> >
> > Once it knows @ptr has a limited number of determined values, the
> > conversion into control dependencies becomes much more likely.
>
> Which would of course break dependent loads.
>
> > > And if we are worried about them, we need to stop relying on dependent
> > > load ordering across the board; or switch to -O0 for everything.
> > > Clearly, we don't want either.
> >
> > Agreed.
> >
> > > Why do we think LTO is special?
> >
> > As argued above, whole-program analysis would make it more likely. But I
> > agree the fundamental problem exists independent from LTO.
> >
> > > But as far as we can tell, there is no evidence of the dreaded "data
> > > dependency to control dependency" conversion with LTO that isn't there
> > > in non-LTO builds, if it's even there at all. Has the data to control
> > > dependency conversion been encountered in the wild? If not, is the
> > > resulting reaction an overreaction? If so, we need to be careful blaming
> > > LTO for something that it isn't even guilty of.
> >
> > It is mostly paranoia; in a large part driven by the fact that even if
> > such a conversion were to be done, it could go a very long time without
> > actually causing problems, and longer still for such problems to be
> > traced back to such an 'optimization'.
> >
> > That is, the collective hurt from debugging too many ordering issues.
> >
> > > So, we are probably better off untangling LTO from the story:
> > >
> > > 1. LTO or no LTO does not matter. The LTO series should not get tangled
> > >    up with memory model issues.
> > >
> > > 2. The memory model question and problems need to be answered and
> > >    addressed separately.
> > >
> > > Thoughts?
> >
> > How hard would it be to creates something that analyzes a build and
> > looks for all 'dependent load -> control dependency' transformations
> > headed by a volatile (and/or from asm) load and issues a warning for
> > them?

I was thinking about this, but in the context of the "auto-promote to
acquire" which you didn't like. Issuing a warning should certainly be
simpler.

I think there is no one place where we know these transformations
happen, but rather, need to analyze the IR before transformations,
take note of all the dependent loads headed by volatile+asm, and then
run an analysis after optimizations checking the dependencies are
still there.

> > This would give us an indication of how valuable this transformation is
> > for the kernel. I'm hoping/expecting it's vanishingly rare, but what do
> > I know.
>
> This could be quite useful!

We might then even be able to say, "if you get this warning, turn on
CONFIG_ACQUIRE_READ_DEPENDENCIES" (or however the option will be
named). Or some other tricks, like automatically recompile the TU
where this happens with the option. But again, this is not something
that should specifically block LTO, because if we have this, we'll
need to turn it on for everything.

Thanks,
-- Marco
