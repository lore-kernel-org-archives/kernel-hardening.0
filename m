Return-Path: <SRS0=ERh8=AL=lists.openwall.com=kernel-hardening-return-19190-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF932C433E0
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Jun 2020 19:19:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 26227206A1
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Jun 2020 19:19:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p1ZTo7sq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 26227206A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19190-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1194 invoked by uid 550); 30 Jun 2020 19:19:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1162 invoked from network); 30 Jun 2020 19:19:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+SWuClaaDOYjnOgTPZaQNynsf/0FUgaUl6LbycKFTXY=;
        b=p1ZTo7sqWt0hVOCPEQgh4KonD/ze3MFi/Yo01MsLgVJf5FMsIFlA6JW4xVwwRJLlvb
         2LGkFLB4TzM0dvjc8XtPJfVJhY8j+voxfHGY5wyBtTX1C+ZACZgqKm0vEVfpHx7NWev/
         lcBMgEAqWixQZY8F67ZRGbDhWdhv/yhtFew6T+y/MorkhkJgTBklhLRQcuC4gHDG6Oma
         5i9nqG9qYH/2KTAQvzLCjszZz0sf7Mhc082rZwllvHEn17zE65LAchhrPt5sAy6Dzzit
         PtTeeRPqNlzXbRW/+6N4LbmHjg3QifubG2x60lzfsOi+sgYvSO6qM++fCjJ07Ct2wEA1
         NugQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+SWuClaaDOYjnOgTPZaQNynsf/0FUgaUl6LbycKFTXY=;
        b=p36wK4Z1fQEQ6Oq7hCxsTW8zUanBGddcX8illMk7khnZZ3LHGl+g3iQNLlrJp8pXpU
         8au8Jm881lT/9M6IPjZmH1K94JCOhuJTRehsFdPfGoS0ajxPJ/O+Bej3fzXEP8Vufth1
         +oYzrFZhxtphS5q//547PFJWQsRyEHV96wFRGGdDszDEYJTcJ9rZdE8nIUUNfpSbhUbT
         hblFEiV2Kt3zEcDwUQDxQxIu2Op4COeyDqnGuLqj210y3pS5bSmheTzjNy1Ss5+tHIXu
         X9MH4MTtFMFHyZCoQPHRGxhnVeSyI7UpVNk3itKHMENddt9/2jAqffWF/WwhvW5hLy2C
         3/6Q==
X-Gm-Message-State: AOAM5335oXivUf45eiSfU3ld5jaf4H4Ya6oAhBfdDs8T7zj6OWQn+BsW
	2GEG7Bg+8+2yFTtkVcy7NPbxow==
X-Google-Smtp-Source: ABdhPJy/PenvvC1HqQRiXc5HwQSjowSzX2eTbOpk9cYcS6/u9DHLBqXXZHK4LjdBVn6FouYmSayxcQ==
X-Received: by 2002:a1c:3286:: with SMTP id y128mr21486460wmy.29.1593544778240;
        Tue, 30 Jun 2020 12:19:38 -0700 (PDT)
Date: Tue, 30 Jun 2020 21:19:31 +0200
From: Marco Elver <elver@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
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
Message-ID: <20200630191931.GA884155@elver.google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624211540.GS4817@hirez.programming.kicks-ass.net>
 <CAKwvOdmxz91c-M8egR9GdR1uOjeZv7-qoTP=pQ55nU8TCpkK6g@mail.gmail.com>
 <20200625080313.GY4817@hirez.programming.kicks-ass.net>
 <20200625082433.GC117543@hirez.programming.kicks-ass.net>
 <20200625085745.GD117543@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625085745.GD117543@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.13.2 (2019-12-18)

I was asked for input on this, and after a few days digging through some
history, thought I'd comment. Hope you don't mind.

On Thu, Jun 25, 2020 at 10:57AM +0200, Peter Zijlstra wrote:
> On Thu, Jun 25, 2020 at 10:24:33AM +0200, Peter Zijlstra wrote:
> > On Thu, Jun 25, 2020 at 10:03:13AM +0200, Peter Zijlstra wrote:
> > > I'm sure Will will respond, but the basic issue is the trainwreck C11
> > > made of dependent loads.
> > > 
> > > Anyway, here's a link to the last time this came up:
> > > 
> > >   https://lore.kernel.org/linux-arm-kernel/20171116174830.GX3624@linux.vnet.ibm.com/
> > 
> > Another good read:
> > 
> >   https://lore.kernel.org/lkml/20150520005510.GA23559@linux.vnet.ibm.com/
[...]
> Because now the machine can speculate and load now before seq, breaking
> the ordering.

First of all, I agree with the concerns, but not because of LTO.

To set the stage better, and summarize the fundamental problem again:
we're in the unfortunate situation that no compiler today has a way to
_efficiently_ deal with C11's memory_order_consume
[https://lwn.net/Articles/588300/]. If we did, we could just use that
and be done with it. But, sadly, that doesn't seem possible right now --
compilers just say consume==acquire. Will suggests doing the same in the
kernel: https://lkml.kernel.org/r/20200630173734.14057-19-will@kernel.org

What we're most worried about right now is the existence of compiler
transformations that could break data dependencies by e.g. turning them
into control dependencies.

If this is a real worry, I don't think LTO is the magical feature that
will uncover those optimizations. If these compiler transformations are
real, they also exist in a normal build! And if we are worried about
them, we need to stop relying on dependent load ordering across the
board; or switch to -O0 for everything. Clearly, we don't want either.

Why do we think LTO is special?

With LTO, Clang just emits LLVM bitcode instead of ELF objects, and
during the linker stage intermodular optimizations across translation
unit boundaries are done that might not be possible otherwise
[https://llvm.org/docs/LinkTimeOptimization.html]. From the memory model
side of things, if we could fully convey our intent to the compiler (the
imaginary consume), there would be no problem, because all optimization
stages from bitcode generation to the final machine code generation
after LTO know about the intended semantics. (Also, keep in mind that
LTO is _not_ doing post link optimization of machine code binaries!)

But as far as we can tell, there is no evidence of the dreaded "data
dependency to control dependency" conversion with LTO that isn't there
in non-LTO builds, if it's even there at all. Has the data to control
dependency conversion been encountered in the wild? If not, is the
resulting reaction an overreaction? If so, we need to be careful blaming
LTO for something that it isn't even guilty of.

So, we are probably better off untangling LTO from the story:

1. LTO or no LTO does not matter. The LTO series should not get tangled
   up with memory model issues.

2. The memory model question and problems need to be answered and
   addressed separately.

Thoughts?

Thanks,
-- Marco
