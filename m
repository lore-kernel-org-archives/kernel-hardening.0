Return-Path: <SRS0=ZsAF=BB=lists.openwall.com=kernel-hardening-return-19424-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C8AC43457
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 23:56:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EFA712080D
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 23:56:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AOTr95qz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EFA712080D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19424-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19892 invoked by uid 550); 22 Jul 2020 23:56:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19867 invoked from network); 22 Jul 2020 23:56:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+o+RK6ajhbuXa8t53WrOJ/qO/QqSI4MSwqISfWHz0Bo=; b=AOTr95qzy3NNS7ydya0oEhrj0x
	IXsE0BLHInLxK7LMENdQilIfh2cpaGkvHT95pCgdQwNllmzwOLo3+ojeCbEeS4ONogdi/FdZvcsKA
	vAAlb2nO3vfaHmXrCG9JS/bvR5nFxAh//2dmSV204vs1qw1GWAabgr/uWXOtCYgSy/mF0P8ZAPH1a
	0M834X7yscfS6C56SWvXovBm3e9oXECz2XoS4GyQhiQw3PA9SiSIXRP8eb+3AJdmfYbzvrwZxEpS7
	UoeZWuAa/x/uCWzeKIKFz1PRB4jr7Bgi4tjCA67T2axhMjY8cp+HgOR0/H1DXp/uKqGGDB/OHYF0s
	5GlHzNUw==;
Date: Thu, 23 Jul 2020 01:56:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [RFC][PATCH] objtool,x86_64: Replace recordmcount with objtool
Message-ID: <20200722235620.GR10769@hirez.programming.kicks-ass.net>
References: <20200624212737.GV4817@hirez.programming.kicks-ass.net>
 <20200624214530.GA120457@google.com>
 <20200625074530.GW4817@hirez.programming.kicks-ass.net>
 <20200625161503.GB173089@google.com>
 <20200625200235.GQ4781@hirez.programming.kicks-ass.net>
 <20200625224042.GA169781@google.com>
 <20200626112931.GF4817@hirez.programming.kicks-ass.net>
 <20200722135542.41127cc4@oasis.local.home>
 <20200722184137.GP10769@hirez.programming.kicks-ass.net>
 <20200722150943.53046592@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722150943.53046592@oasis.local.home>

On Wed, Jul 22, 2020 at 03:09:43PM -0400, Steven Rostedt wrote:
> On Wed, 22 Jul 2020 20:41:37 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > That said, Andi Kleen added an option to gcc called -mnop-mcount which
> > > will have gcc do both create the mcount section and convert the calls
> > > into nops. When doing so, it defines CC_USING_NOP_MCOUNT which will
> > > tell ftrace to expect the calls to already be converted.  
> > 
> > That seems like the much easier solution, then we can forget about
> > recordmcount / objtool entirely for this.
> 
> Of course that was only for some gcc compilers, and I'm not sure if
> clang can do this.
> 
> Or do you just see all compilers doing this in the future, and not
> worrying about record-mcount at all, and bothering with objtool?

I got the GCC version wrong :/ Both -mnop-mcount and -mrecord-mcount
landed in GCC-5, where our minimum GCC is now at 4.9.

Anyway, what do you prefer, I suppose I can make objtool whatever we
need, that patch is trivial. Simply recording the sites and not
rewriting them should be simple enough.
