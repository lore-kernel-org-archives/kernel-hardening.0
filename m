Return-Path: <SRS0=nOj0=BB=lists.openwall.com=kernel-hardening-return-19416-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 026E3C433E4
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 18:42:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 58A5E20737
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 18:42:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="f2QZ2qti"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 58A5E20737
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19416-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20359 invoked by uid 550); 22 Jul 2020 18:42:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20339 invoked from network); 22 Jul 2020 18:42:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DqMZf+NKxev5DHoTyVPRSIfA19GkA4kV6jf4PNYb+Nw=; b=f2QZ2qtibGlJEp42Nw1cOpOp54
	xbjG6CyuAnifkHhoaLv3ELLYaPI+boJBEqUHwPU8IRo3DgqZB0dDkl95wHJ3Axyeoto9wfj7/AslF
	9aPPV/YLLSrMT4llswvO23XJiYK29HD1OetvJXWSZcPxxR+MdkO8QvG++Vlqc/nBAoJhsojJbIiHo
	SI/70lKuy3BslY5UiNJn0bADWU41eswtFmSrIoBoLcUK+SyrYfBMQ5U6RrsOJxJAMH0reIgx8ltdR
	3ypKp2jtlWDYKldYYGBc79YEfFgyCydN57+ohspjNE9DQ9wgkd6pv9IRLS98rE9bYGad90A2JdWZ2
	ZzlpB7wg==;
Date: Wed, 22 Jul 2020 20:41:37 +0200
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
	x86@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
	mhelsley@vmware.com
Subject: Re: [RFC][PATCH] objtool,x86_64: Replace recordmcount with objtool
Message-ID: <20200722184137.GP10769@hirez.programming.kicks-ass.net>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722135542.41127cc4@oasis.local.home>

On Wed, Jul 22, 2020 at 01:55:42PM -0400, Steven Rostedt wrote:

> > Ha! it is trying to convert the "CALL __fentry__" into a NOP and not
> > finding the CALL -- because objtool already made it a NOP...
> > 
> > Weird, I thought recordmcount would also write NOPs, it certainly has
> > code for that. I suppose we can use CC_USING_NOP_MCOUNT to avoid those,
> > but I'd rather Steve explain this before I wreck things further.
> 
> The reason for not having recordmcount insert all the nops, is because
> x86 has more than one optimal nop which is determined by the machine it
> runs on, and not at compile time. So we figured just updated it then.
> 
> We can change it to be a nop on boot, and just modify it if it's not
> the optimal nop already. 

Right, I throught that's what we'd be doing already, anyway:

> That said, Andi Kleen added an option to gcc called -mnop-mcount which
> will have gcc do both create the mcount section and convert the calls
> into nops. When doing so, it defines CC_USING_NOP_MCOUNT which will
> tell ftrace to expect the calls to already be converted.

That seems like the much easier solution, then we can forget about
recordmcount / objtool entirely for this.
