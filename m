Return-Path: <SRS0=3BTg=D4=lists.openwall.com=kernel-hardening-return-20242-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B0BFC4363A
	for <kernel-hardening@archiver.kernel.org>; Wed, 21 Oct 2020 09:52:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 613F8222C8
	for <kernel-hardening@archiver.kernel.org>; Wed, 21 Oct 2020 09:52:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="th0SHZXY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 613F8222C8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20242-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22522 invoked by uid 550); 21 Oct 2020 09:51:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22493 invoked from network); 21 Oct 2020 09:51:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TTonoSMC9Qr/U6/6E+qiLczLqU7QnBRx2AW/ar8m2XI=; b=th0SHZXYoGIMeeNQk+cXXn3ZRf
	4eqHsJyAUeQKe0z/FZOgQg3ZKafZO/IAdXuUjcIsQI8/EwkTubleigyQhAvFkH6ILAyudw/+ETGLV
	SwMchF/jLJeFRNuNJQT/hJXEogvS6OyuEE65LokfdM2FJXRIpXQP4HwCDwqnt85mQHh+Aj/8SZs9x
	QdDJ9xPOSco262ZobeHTh85BDuNYKoZ35/lPHthqt9nJ4G5zuO+YXBqmgzGyyudm59MOtmHyP1/TO
	DJ0+eaqlHK1IGczOA12VYkWgY/8r/3psr144sr2lv6QAgtPP5mpwF9GWLwdmfjUcNz63fCjQIBaIf
	OLe/XMig==;
Date: Wed, 21 Oct 2020 11:51:33 +0200
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
Message-ID: <20201021095133.GA2628@hirez.programming.kicks-ass.net>
References: <20201013003203.4168817-1-samitolvanen@google.com>
 <20201013003203.4168817-23-samitolvanen@google.com>
 <CAG48ez2baAvKDA0wfYLKy-KnM_1CdOwjU873VJGDM=CErjsv_A@mail.gmail.com>
 <20201015102216.GB2611@hirez.programming.kicks-ass.net>
 <20201015203942.f3kwcohcwwa6lagd@treble>
 <CABCJKufDLmBCwmgGnfLcBw_B_4U8VY-R-dSNNp86TFfuMobPMw@mail.gmail.com>
 <20201020185217.ilg6w5l7ujau2246@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020185217.ilg6w5l7ujau2246@treble>

On Tue, Oct 20, 2020 at 01:52:17PM -0500, Josh Poimboeuf wrote:
> > arch/x86/lib/retpoline.S:
> > __x86_retpoline_rdi()+0x10: return with modified stack frame
> > __x86_retpoline_rdi()+0x0: stack state mismatch: cfa1=7+32 cfa2=7+8
> > __x86_retpoline_rdi()+0x0: stack state mismatch: cfa1=7+32 cfa2=-1+0
> 
> Is this with upstream?  I thought we fixed that with
> UNWIND_HINT_RET_OFFSET.

I can't reproduce this one either; but I do get different warnings:

gcc (Debian 10.2.0-13) 10.2.0, x86_64-defconfig:

defconfig-build/vmlinux.o: warning: objtool: __x86_indirect_thunk_rax() falls through to next function __x86_retpoline_rax()
defconfig-build/vmlinux.o: warning: objtool:   .altinstr_replacement+0x1063: (branch)
defconfig-build/vmlinux.o: warning: objtool:   __x86_indirect_thunk_rax()+0x0: (alt)
defconfig-build/vmlinux.o: warning: objtool:   __x86_indirect_thunk_rax()+0x0: <=== (sym)

(for every single register, not just rax)

Which is daft as well, because the retpoline.o run is clean. It also
doesn't make sense because __x86_retpoline_rax isn't in fact STT_FUNC,
so WTH ?!
