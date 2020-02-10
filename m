Return-Path: <SRS0=Dg0m=36=lists.openwall.com=kernel-hardening-return-17757-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D65C35254
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 18:24:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C87EF2080C
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 18:24:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C87EF2080C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17757-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29992 invoked by uid 550); 10 Feb 2020 18:24:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29968 invoked from network); 10 Feb 2020 18:24:48 -0000
Date: Mon, 10 Feb 2020 18:24:32 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 09/11] arm64: disable SCS for hypervisor code
Message-ID: <20200210182431.GC20840@lakrids.cambridge.arm.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200128184934.77625-1-samitolvanen@google.com>
 <20200128184934.77625-10-samitolvanen@google.com>
 <6f62b3c0-e796-e91c-f53b-23bd80fcb065@arm.com>
 <20200210175214.GA23318@willie-the-truck>
 <20200210180327.GB20840@lakrids.cambridge.arm.com>
 <20200210180740.GA24354@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210180740.GA24354@willie-the-truck>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)

On Mon, Feb 10, 2020 at 06:07:41PM +0000, Will Deacon wrote:
> On Mon, Feb 10, 2020 at 06:03:28PM +0000, Mark Rutland wrote:
> > On Mon, Feb 10, 2020 at 05:52:15PM +0000, Will Deacon wrote:
> > > On Mon, Feb 10, 2020 at 05:18:58PM +0000, James Morse wrote:
> > > > On 28/01/2020 18:49, Sami Tolvanen wrote:
> > > > > Filter out CC_FLAGS_SCS and -ffixed-x18 for code that runs at a
> > > > > different exception level.
> > > > 
> > > > Hmmm, there are two things being disabled here.
> > > > 
> > > > Stashing the lr in memory pointed to by VA won't work transparently at EL2 ... but
> > > > shouldn't KVM's C code still treat x18 as a fixed register?
> > > 
> > > My review of v6 suggested dropping the -ffixed-x18 as well, since it's only
> > > introduced by SCS (in patch 5) and so isn't required by anything else. Why
> > > do you think it's needed?
> > 
> > When EL1 code calls up to hyp, it expects x18 to be preserved across the
> > call, so hyp needs to either preserve it explicitly across a transitions
> > from/to EL1 or always preserve it.
> 
> I thought we explicitly saved/restored it across the call after
> af12376814a5 ("arm64: kvm: stop treating register x18 as caller save"). Is
> that not sufficient?

That covers the hyp->guest->hyp round trip, but not the host->hyp->host
portion surrounding that.

Anywhere we use __call_hyp() expects x18 to be preserved across the
call, and that's not only used to enter the guest. If we don't want to
do that naturally at EL2, we'd probably have to add that to
do_el2_call in arch/arm64/kvm/hyp/hyp-entry.S.

Thanks,
Mark.
