Return-Path: <SRS0=fSnc=AH=lists.openwall.com=kernel-hardening-return-19174-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E049DC433E0
	for <kernel-hardening@archiver.kernel.org>; Fri, 26 Jun 2020 11:30:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3C3EB206A1
	for <kernel-hardening@archiver.kernel.org>; Fri, 26 Jun 2020 11:30:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EGCO0/B1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C3EB206A1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19174-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28448 invoked by uid 550); 26 Jun 2020 11:30:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28428 invoked from network); 26 Jun 2020 11:30:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0MTNUdpvCFV2C1ooAXJ6Vvth7dm0A8sUroqcq/z5uD0=; b=EGCO0/B1XB2kdspcyQ89ZQhoyg
	Ax/IQM8mmxqV7jkKXl/MWFP7prA5jfkO8HqSZPvnttIDjSFg1w/tKaO3j0k8KL6L+qlIY0Zn2j/hq
	W4+C8nlebWIF5ebBhJfftDfljzTAMl06M2aRxkineGdmpGu/LekSm6EbJ+h10mKkHi/ilcNQ8Z18F
	M2MJ7rPoVqwffWXd5EUII1zbwujF3rIpU9+e9qp3xDauW8aC4GU0RX4H1LjU/WFGQSrKETn9e32/P
	Ej5EZj5V0SHGNf+0tpEq14xmxvUc265pk15KyovRcTjXtIcLHzhrye5Vn/4QwrJSU3Wa82Pvq0XOG
	Bstzz1kg==;
Date: Fri, 26 Jun 2020 13:29:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
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
Message-ID: <20200626112931.GF4817@hirez.programming.kicks-ass.net>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-5-samitolvanen@google.com>
 <20200624212737.GV4817@hirez.programming.kicks-ass.net>
 <20200624214530.GA120457@google.com>
 <20200625074530.GW4817@hirez.programming.kicks-ass.net>
 <20200625161503.GB173089@google.com>
 <20200625200235.GQ4781@hirez.programming.kicks-ass.net>
 <20200625224042.GA169781@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625224042.GA169781@google.com>

On Thu, Jun 25, 2020 at 03:40:42PM -0700, Sami Tolvanen wrote:

> > Not boot tested, but it generates the required sections and they look
> > more or less as expected, ymmv.

> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index a291823f3f26..189575c12434 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -174,7 +174,6 @@ config X86
> >  	select HAVE_EXIT_THREAD
> >  	select HAVE_FAST_GUP
> >  	select HAVE_FENTRY			if X86_64 || DYNAMIC_FTRACE
> > -	select HAVE_FTRACE_MCOUNT_RECORD
> >  	select HAVE_FUNCTION_GRAPH_TRACER
> >  	select HAVE_FUNCTION_TRACER
> >  	select HAVE_GCC_PLUGINS
> 
> This breaks DYNAMIC_FTRACE according to kernel/trace/ftrace.c:
> 
>   #ifndef CONFIG_FTRACE_MCOUNT_RECORD
>   # error Dynamic ftrace depends on MCOUNT_RECORD
>   #endif
> 
> And the build errors after that seem to confirm this. It looks like we might
> need another flag to skip recordmcount.

Hurm, Steve, how you want to do that?

> Anyway, since objtool is run before recordmcount, I just left this unchanged
> for testing and ignored the recordmcount warnings about __mcount_loc already
> existing. Something is a bit off still though, I see this at boot:
> 
>   ------------[ ftrace bug ]------------
>   ftrace failed to modify
>   [<ffffffff81000660>] __tracepoint_iter_initcall_level+0x0/0x40
>    actual:   0f:1f:44:00:00
>   Initializing ftrace call sites
>   ftrace record flags: 0
>    (0)
>    expected tramp: ffffffff81056500
>   ------------[ cut here ]------------
> 
> Otherwise, this looks pretty good.

Ha! it is trying to convert the "CALL __fentry__" into a NOP and not
finding the CALL -- because objtool already made it a NOP...

Weird, I thought recordmcount would also write NOPs, it certainly has
code for that. I suppose we can use CC_USING_NOP_MCOUNT to avoid those,
but I'd rather Steve explain this before I wreck things further.
