Return-Path: <SRS0=3hKw=D6=lists.openwall.com=kernel-hardening-return-20257-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A5DBC388F9
	for <kernel-hardening@archiver.kernel.org>; Fri, 23 Oct 2020 17:48:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2C50D2168B
	for <kernel-hardening@archiver.kernel.org>; Fri, 23 Oct 2020 17:48:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h9H11cgb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C50D2168B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20257-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3594 invoked by uid 550); 23 Oct 2020 17:48:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3573 invoked from network); 23 Oct 2020 17:48:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uHs6b4ooy0rgFnXBjoHTZU/MFzwidZAAr9PXWq9UsVk=;
        b=h9H11cgbsiLIfnCVNg9C63PczJj6klub3nyQOP7k17qHXCkM3+IiRWUf+K8onV/M6f
         cq6hpYWY5tijhMZOqe4vpxWnGOmq8cRM3qeYtsvRKEgPmJNNtDrmOS532+baO+0nsP5H
         4oTZzToITDWX/+cRTyYkk0o02ppC4ZW2srP3cde+HPF1A0gWOS7McnJYg5AziS2A8+k5
         FA/pfx2HXxsJo1PFtx/M/61rAc4BlJZES29IbLZRpqOuPDxsS+IoEvzMCqD9jME5DLTE
         nrFqzJCCPwXyQB8C7frIf3mqYooXH89m8/kypUCqoZ0QyzM52bhO/vCOCMQcptgtC5Xq
         D7GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uHs6b4ooy0rgFnXBjoHTZU/MFzwidZAAr9PXWq9UsVk=;
        b=TgxbPeRNo6aio2fojF8CtZ+AQewT2ylvR5pjRqpiivvHOZTIecF2szjiJI3RuHO4Y0
         /MMu44jXUals2gHi3R4OQ/Ll3GUg/fWQ2EepDVSaMQRZlXJ8tAirr2pPAjNcrHdVh/ti
         xfLawokGpeLP/fw98KvVzMtsQld9aEpNqA4Ig3uSs1s1fR6x+0nWMt3YGPmFxtmBmNov
         bTJ0bzKT24nyNSluRqRXnBD4a/y6UFcwEYETtwX75bq1BMWkSUrE/Vjp8pMfDbZAlwnc
         9l3VSSgROID6vauhCzHVB3xP7F1Nme+60fjrKmfLozKT/s0PBkWlPvygS83GO/SN/Rf8
         Lz5g==
X-Gm-Message-State: AOAM532uEujrC14qz62QTRb24zd8dmQF1kJmEUvaG+Bwp25MIjauHj81
	rRddg3IAVISEFFjAEnKcGPkZWA==
X-Google-Smtp-Source: ABdhPJyvkbZhNi51MOK3wMCs4cSy44OvLHixOCI7o3MOo/m8861HBGG5Vdka871MDYa0ozQesghZuQ==
X-Received: by 2002:a17:90a:450d:: with SMTP id u13mr3848288pjg.148.1603475309279;
        Fri, 23 Oct 2020 10:48:29 -0700 (PDT)
Date: Fri, 23 Oct 2020 10:48:22 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jannh@google.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-pci@vger.kernel.org
Subject: Re: [PATCH v6 22/25] x86/asm: annotate indirect jumps
Message-ID: <20201023174822.GA2696347@google.com>
References: <CAG48ez2baAvKDA0wfYLKy-KnM_1CdOwjU873VJGDM=CErjsv_A@mail.gmail.com>
 <20201015102216.GB2611@hirez.programming.kicks-ass.net>
 <20201015203942.f3kwcohcwwa6lagd@treble>
 <CABCJKufDLmBCwmgGnfLcBw_B_4U8VY-R-dSNNp86TFfuMobPMw@mail.gmail.com>
 <20201020185217.ilg6w5l7ujau2246@treble>
 <CABCJKucVjFtrOsw58kn4OnW5kdkUh8G7Zs4s6QU9s6O7soRiAA@mail.gmail.com>
 <20201021085606.GZ2628@hirez.programming.kicks-ass.net>
 <20201021093213.GV2651@hirez.programming.kicks-ass.net>
 <20201021212747.ofk74lugt4hhjdzg@treble>
 <20201022072553.GN2628@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022072553.GN2628@hirez.programming.kicks-ass.net>

On Thu, Oct 22, 2020 at 09:25:53AM +0200, Peter Zijlstra wrote:
> On Wed, Oct 21, 2020 at 04:27:47PM -0500, Josh Poimboeuf wrote:
> > On Wed, Oct 21, 2020 at 11:32:13AM +0200, Peter Zijlstra wrote:
> > > On Wed, Oct 21, 2020 at 10:56:06AM +0200, Peter Zijlstra wrote:
> > > 
> > > > I do not see these in particular, although I do see a lot of:
> > > > 
> > > >   "sibling call from callable instruction with modified stack frame"
> > > 
> > > defconfig-build/vmlinux.o: warning: objtool: msr_write()+0x10a: sibling call from callable instruction with modified stack frame
> > > defconfig-build/vmlinux.o: warning: objtool:   msr_write()+0x99: (branch)
> > > defconfig-build/vmlinux.o: warning: objtool:   msr_write()+0x3e: (branch)
> > > defconfig-build/vmlinux.o: warning: objtool:   msr_write()+0x0: <=== (sym)
> > > 
> > > $ nm defconfig-build/vmlinux.o | grep msr_write
> > > 0000000000043250 t msr_write
> > > 00000000004289c0 T msr_write
> > > 0000000000003056 t msr_write.cold
> > > 
> > > Below 'fixes' it. So this is also caused by duplicate symbols.
> > 
> > There's a new linker flag for renaming duplicates:
> > 
> >   https://sourceware.org/bugzilla/show_bug.cgi?id=26391
> > 
> > But I guess that doesn't help us now.
> 
> Well, depends a bit if clang can do it; we only need this for LTO builds
> for now.

LLD doesn't seem to support -z unique-symbol.

Sami
