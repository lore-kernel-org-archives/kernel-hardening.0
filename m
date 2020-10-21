Return-Path: <SRS0=VmMz=D4=lists.openwall.com=kernel-hardening-return-20236-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FABEC56204
	for <kernel-hardening@archiver.kernel.org>; Wed, 21 Oct 2020 08:56:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 00D6221D6C
	for <kernel-hardening@archiver.kernel.org>; Wed, 21 Oct 2020 08:56:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IperxMxd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00D6221D6C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20236-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19974 invoked by uid 550); 21 Oct 2020 08:56:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19954 invoked from network); 21 Oct 2020 08:56:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=T1Nj/VgNWnCwEdvHUApSGaEXo57LUFa1cim9ekP5a3o=; b=IperxMxdTeX+UHkUFxSw1fMdlu
	rlbTj19FdMfMoz6UhXjdK2RVwZsCTVMWAqChFfg6+HksSPrab3vbiLxM3xJboJLwdKTRCwl+dV3yy
	FnFo08yjI3ShP0Rba4/XVo8zQs9Pvs1cVqm3gByp5GDlehXtegWETrwr3UuFg9ebpFM/HxNAQJZ+K
	Q68kD1WYDLVrH684E3zFsJk+840g1R1gh18JH0wVUpo+BepzK3sIFR7WI8HXsBSxdonfW/heQaspw
	uT/Xp8qTHxz3hGqlStk7V1XL+657bHp6vrpU9uivEael1tRQheorfv8cjTFEh98Pn9rwWTRZCbSMV
	3BqUoHLA==;
Date: Wed, 21 Oct 2020 10:56:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sami Tolvanen <samitolvanen@google.com>
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
Message-ID: <20201021085606.GZ2628@hirez.programming.kicks-ass.net>
References: <20201013003203.4168817-1-samitolvanen@google.com>
 <20201013003203.4168817-23-samitolvanen@google.com>
 <CAG48ez2baAvKDA0wfYLKy-KnM_1CdOwjU873VJGDM=CErjsv_A@mail.gmail.com>
 <20201015102216.GB2611@hirez.programming.kicks-ass.net>
 <20201015203942.f3kwcohcwwa6lagd@treble>
 <CABCJKufDLmBCwmgGnfLcBw_B_4U8VY-R-dSNNp86TFfuMobPMw@mail.gmail.com>
 <20201020185217.ilg6w5l7ujau2246@treble>
 <CABCJKucVjFtrOsw58kn4OnW5kdkUh8G7Zs4s6QU9s6O7soRiAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKucVjFtrOsw58kn4OnW5kdkUh8G7Zs4s6QU9s6O7soRiAA@mail.gmail.com>

On Tue, Oct 20, 2020 at 12:24:37PM -0700, Sami Tolvanen wrote:
> > > Building allyesconfig with this series and LTO enabled, I still see
> > > the following objtool warnings for vmlinux.o, grouped by source file:
> > >
> > > arch/x86/entry/entry_64.S:
> > > __switch_to_asm()+0x0: undefined stack state
> > > .entry.text+0xffd: sibling call from callable instruction with
> > > modified stack frame
> > > .entry.text+0x48: stack state mismatch: cfa1=7-8 cfa2=-1+0
> >
> > Not sure what this one's about, there's no OBJECT_FILES_NON_STANDARD?
> 
> Correct, because with LTO, we won't have an ELF binary to process
> until we compile everything into vmlinux.o, and at that point we can
> no longer skip individual object files.

I think what Josh was trying to say is; this file is subject to objtool
on a normal build and does not generate warnings. So why would it
generate warnings when subject to objtool as result of a vmlinux run
(due to LTO or otherwise).

In fact, when I build a x86_64-defconfig and then run:

  $ objtool check -barf defconfig-build/vmlinux.o

I do not see these in particular, although I do see a lot of:

  "sibling call from callable instruction with modified stack frame"
  "falls through to next function"

that did not show up in the individual objtool runs during the build.

The "falls through to next function" seems to be limited to things like:

  warning: objtool: setup_vq() falls through to next function setup_vq.cold()
  warning: objtool: e1000_xmit_frame() falls through to next function e1000_xmit_frame.cold()

So something's weird with the .cold thing on vmlinux.o runs.
