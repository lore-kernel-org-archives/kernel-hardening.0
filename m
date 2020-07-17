Return-Path: <SRS0=ruoH=A4=lists.openwall.com=kernel-hardening-return-19389-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD361C433E4
	for <kernel-hardening@archiver.kernel.org>; Fri, 17 Jul 2020 18:06:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2DD0D206F4
	for <kernel-hardening@archiver.kernel.org>; Fri, 17 Jul 2020 18:06:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DD0D206F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19389-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22185 invoked by uid 550); 17 Jul 2020 18:06:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22165 invoked from network); 17 Jul 2020 18:06:01 -0000
Date: Fri, 17 Jul 2020 14:05:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Masahiro Yamada
 <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, Kees
 Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>,
 clang-built-linux <clang-built-linux@googlegroups.com>, Kernel Hardening
 <kernel-hardening@lists.openwall.com>, linux-arch
 <linux-arch@vger.kernel.org>, linux-arm-kernel
 <linux-arm-kernel@lists.infradead.org>, linux-kbuild
 <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>, Josh Poimboeuf
 <jpoimboe@redhat.com>, Matt Helsley <mhelsley@vmware.com>
Subject: Re: [RFC][PATCH] objtool,x86_64: Replace recordmcount with objtool
Message-ID: <20200717140545.6f008208@oasis.local.home>
In-Reply-To: <CABCJKuda0AFCZ-1J2NTLc-M0xax007a9u-fzOoxmU2z60jvzbA@mail.gmail.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
	<20200624203200.78870-5-samitolvanen@google.com>
	<20200624212737.GV4817@hirez.programming.kicks-ass.net>
	<20200624214530.GA120457@google.com>
	<20200625074530.GW4817@hirez.programming.kicks-ass.net>
	<20200625161503.GB173089@google.com>
	<20200625200235.GQ4781@hirez.programming.kicks-ass.net>
	<20200625224042.GA169781@google.com>
	<20200626112931.GF4817@hirez.programming.kicks-ass.net>
	<CABCJKucSM7gqWmUtiBPbr208wB0pc25afJXc6yBQzJDZf4LSWA@mail.gmail.com>
	<20200717133645.7816c0b6@oasis.local.home>
	<CABCJKuda0AFCZ-1J2NTLc-M0xax007a9u-fzOoxmU2z60jvzbA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 17 Jul 2020 10:47:51 -0700
Sami Tolvanen <samitolvanen@google.com> wrote:

> > Someone just submitted a patch for arm64 for this:
> >
> > https://lore.kernel.org/r/20200717143338.19302-1-gregory.herrero@oracle.com
> >
> > Is that what you want?  
> 
> That looks like the same issue, but we need to fix this on x86 instead.

Does x86 have a way to differentiate between the two that record mcount
can check?

-- Steve
