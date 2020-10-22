Return-Path: <SRS0=AM4w=D5=lists.openwall.com=kernel-hardening-return-20248-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA784C388F7
	for <kernel-hardening@archiver.kernel.org>; Thu, 22 Oct 2020 07:26:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 94E05222E9
	for <kernel-hardening@archiver.kernel.org>; Thu, 22 Oct 2020 07:26:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aUN68Sfz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94E05222E9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20248-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13402 invoked by uid 550); 22 Oct 2020 07:26:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13379 invoked from network); 22 Oct 2020 07:26:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=h+rKHFkcR5k6QSt8CeK8lSdFFr+MaETwBr6Mxg4PDmU=; b=aUN68SfzWTPeVbTNit8fy/ZXb0
	rRAYaTV5InvSpscM+g5V5UNuxxMIOSNNjdTrr9zBJwTDnIr7HB4kAtF5eelSvpZSzfzi0XB65k49y
	fMhVyhLkrBDvMABUemD6zpOEa+Q8IzTJx4IZksVwvVIaYHLDJx476sb1mRX2HLMmaKAybchSbXO5G
	h2Y+yNlzpY2780AC98N7ePm2EJ79MCEo33CoAfryNdBPReXIr4iTyNLwA3Ag8rPF1QkdzEXKCnmAv
	01B8rB6S0TBGhXUXekjoFY4MHksCyJY7O4ahmGFdB9hvjhmJ+hNdIUNrUYqknMjnfiTaSOjgjEbDG
	qxHU9c4w==;
Date: Thu, 22 Oct 2020 09:25:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Jann Horn <jannh@google.com>,
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
Message-ID: <20201022072553.GN2628@hirez.programming.kicks-ass.net>
References: <20201013003203.4168817-23-samitolvanen@google.com>
 <CAG48ez2baAvKDA0wfYLKy-KnM_1CdOwjU873VJGDM=CErjsv_A@mail.gmail.com>
 <20201015102216.GB2611@hirez.programming.kicks-ass.net>
 <20201015203942.f3kwcohcwwa6lagd@treble>
 <CABCJKufDLmBCwmgGnfLcBw_B_4U8VY-R-dSNNp86TFfuMobPMw@mail.gmail.com>
 <20201020185217.ilg6w5l7ujau2246@treble>
 <CABCJKucVjFtrOsw58kn4OnW5kdkUh8G7Zs4s6QU9s6O7soRiAA@mail.gmail.com>
 <20201021085606.GZ2628@hirez.programming.kicks-ass.net>
 <20201021093213.GV2651@hirez.programming.kicks-ass.net>
 <20201021212747.ofk74lugt4hhjdzg@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021212747.ofk74lugt4hhjdzg@treble>

On Wed, Oct 21, 2020 at 04:27:47PM -0500, Josh Poimboeuf wrote:
> On Wed, Oct 21, 2020 at 11:32:13AM +0200, Peter Zijlstra wrote:
> > On Wed, Oct 21, 2020 at 10:56:06AM +0200, Peter Zijlstra wrote:
> > 
> > > I do not see these in particular, although I do see a lot of:
> > > 
> > >   "sibling call from callable instruction with modified stack frame"
> > 
> > defconfig-build/vmlinux.o: warning: objtool: msr_write()+0x10a: sibling call from callable instruction with modified stack frame
> > defconfig-build/vmlinux.o: warning: objtool:   msr_write()+0x99: (branch)
> > defconfig-build/vmlinux.o: warning: objtool:   msr_write()+0x3e: (branch)
> > defconfig-build/vmlinux.o: warning: objtool:   msr_write()+0x0: <=== (sym)
> > 
> > $ nm defconfig-build/vmlinux.o | grep msr_write
> > 0000000000043250 t msr_write
> > 00000000004289c0 T msr_write
> > 0000000000003056 t msr_write.cold
> > 
> > Below 'fixes' it. So this is also caused by duplicate symbols.
> 
> There's a new linker flag for renaming duplicates:
> 
>   https://sourceware.org/bugzilla/show_bug.cgi?id=26391
> 
> But I guess that doesn't help us now.

Well, depends a bit if clang can do it; we only need this for LTO builds
for now.

> I don't have access to GCC 10 at the moment so I can't recreate it.
> Does this fix it?

Doesn't seem to do the trick :/ I'll try and have a poke later.
