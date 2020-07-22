Return-Path: <SRS0=e8zi=BB=lists.openwall.com=kernel-hardening-return-19418-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43AF5C433E2
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 19:10:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9AC4520781
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 19:10:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9AC4520781
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19418-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30641 invoked by uid 550); 22 Jul 2020 19:09:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30621 invoked from network); 22 Jul 2020 19:09:58 -0000
Date: Wed, 22 Jul 2020 15:09:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Masahiro Yamada
 <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, Kees
 Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>,
 clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com,
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-pci@vger.kernel.org, x86@kernel.org, Josh Poimboeuf
 <jpoimboe@redhat.com>
Subject: Re: [RFC][PATCH] objtool,x86_64: Replace recordmcount with objtool
Message-ID: <20200722150943.53046592@oasis.local.home>
In-Reply-To: <20200722184137.GP10769@hirez.programming.kicks-ass.net>
References: <20200624203200.78870-1-samitolvanen@google.com>
	<20200624203200.78870-5-samitolvanen@google.com>
	<20200624212737.GV4817@hirez.programming.kicks-ass.net>
	<20200624214530.GA120457@google.com>
	<20200625074530.GW4817@hirez.programming.kicks-ass.net>
	<20200625161503.GB173089@google.com>
	<20200625200235.GQ4781@hirez.programming.kicks-ass.net>
	<20200625224042.GA169781@google.com>
	<20200626112931.GF4817@hirez.programming.kicks-ass.net>
	<20200722135542.41127cc4@oasis.local.home>
	<20200722184137.GP10769@hirez.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 22 Jul 2020 20:41:37 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> > That said, Andi Kleen added an option to gcc called -mnop-mcount which
> > will have gcc do both create the mcount section and convert the calls
> > into nops. When doing so, it defines CC_USING_NOP_MCOUNT which will
> > tell ftrace to expect the calls to already be converted.  
> 
> That seems like the much easier solution, then we can forget about
> recordmcount / objtool entirely for this.

Of course that was only for some gcc compilers, and I'm not sure if
clang can do this.

Or do you just see all compilers doing this in the future, and not
worrying about record-mcount at all, and bothering with objtool?

-- Steve
