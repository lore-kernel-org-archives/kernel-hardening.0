Return-Path: <SRS0=5HMx=AG=lists.openwall.com=kernel-hardening-return-19173-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D911CC433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jun 2020 22:41:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 378E020679
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jun 2020 22:41:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vjDkS1ct"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 378E020679
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19173-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14173 invoked by uid 550); 25 Jun 2020 22:41:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14153 invoked from network); 25 Jun 2020 22:41:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jrKbnig9QFRhNV6K+9Xoewg6ga8WAeyx+cHHuuAPHlw=;
        b=vjDkS1ct1augvE723FB1+5WPfwzfajqrtAMZRYo0dTgN5aCXnRVc3P9qUPioCfxE8z
         zC7awdkoztnyQMH6KrmbAZB+gM3wWozXAHd+5NlrM3zI27aeWEvQfCn5USOdaH1puVqn
         n+mQi5qyO3ediG9Fy54lBVH83MmSL8Q2+fhkZaaYmruol7QRBk3j2qUtL3wKRM4CV0O8
         azUuw9K3+1ptvV6oCv9rk3Jq7Xiiwx3xcCAujAANMFcNjec9DVvR2cW5QPifyHeO10Cg
         wZRh3A465gRs3JRICOc49N6SHyq0l8hzKjlz8ZyjwxNNSR3yFRHh1hd8rpoRIRuIIfw5
         Pg0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jrKbnig9QFRhNV6K+9Xoewg6ga8WAeyx+cHHuuAPHlw=;
        b=LdazpH80eLdVEd+OEkhcunWSN4Y5py6GnLK72LseS4WPZ78FyjpWJpB/gkFDol9LXv
         h0NiAglps7NzokJJ1I/GuRdH0HVEYUY8M1rZkXKdB9TEK/7+t4mMVA8MiRP8z7wVN+O3
         KCcVozbqa8mvKXf0P4+ruaiGUh9hSePM88DeavVSxvGzGngkWdR6NEnEU8A5gF30WQaR
         9GBC+ELF7MioRKGmeN6cZiNpeUBEHicwvU8dMqaZiFmqnyjLjkKPBImfrqZwtjHEz/01
         IOosDwt+3Z9uHIEOLD/yOkInWwGaPPf7tvq+mhAgRxbM0VmYe+Kp8iaiVyfA5q1GK9+D
         htCA==
X-Gm-Message-State: AOAM5331rqZJwqBmgreq4q8d4qWgXL+7Y0X9rYfzfipsBqPIA4szeK+k
	uxM+rtsDlgWQgeQJj7F6SVDFmw==
X-Google-Smtp-Source: ABdhPJx7TfSqe9+zt9NPoQSooOWfE2e9/T8a5met4FrI5ZnaAeXh7ahhb/KuD0I40m4aCdLgLVgkpw==
X-Received: by 2002:a17:90a:7c4e:: with SMTP id e14mr256081pjl.52.1593124850158;
        Thu, 25 Jun 2020 15:40:50 -0700 (PDT)
Date: Thu, 25 Jun 2020 15:40:42 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <20200625224042.GA169781@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-5-samitolvanen@google.com>
 <20200624212737.GV4817@hirez.programming.kicks-ass.net>
 <20200624214530.GA120457@google.com>
 <20200625074530.GW4817@hirez.programming.kicks-ass.net>
 <20200625161503.GB173089@google.com>
 <20200625200235.GQ4781@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625200235.GQ4781@hirez.programming.kicks-ass.net>

On Thu, Jun 25, 2020 at 10:02:35PM +0200, Peter Zijlstra wrote:
> On Thu, Jun 25, 2020 at 09:15:03AM -0700, Sami Tolvanen wrote:
> > On Thu, Jun 25, 2020 at 09:45:30AM +0200, Peter Zijlstra wrote:
> 
> > > At least for x86_64 I can do a really quick take for a recordmcount pass
> > > in objtool, but I suppose you also need this for ARM64 ?
> > 
> > Sure, sounds good. arm64 uses -fpatchable-function-entry with clang, so we
> > don't need recordmcount there.
> 
> This is on top of my local pile:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git master
> 
> which notably includes the static_call series.
> 
> Not boot tested, but it generates the required sections and they look
> more or less as expected, ymmv.
> 
> ---
>  arch/x86/Kconfig              |  1 -
>  scripts/Makefile.build        |  3 ++
>  scripts/link-vmlinux.sh       |  2 +-
>  tools/objtool/builtin-check.c |  9 ++---
>  tools/objtool/builtin.h       |  2 +-
>  tools/objtool/check.c         | 81 +++++++++++++++++++++++++++++++++++++++++++
>  tools/objtool/check.h         |  1 +
>  tools/objtool/objtool.h       |  1 +
>  8 files changed, 91 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index a291823f3f26..189575c12434 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -174,7 +174,6 @@ config X86
>  	select HAVE_EXIT_THREAD
>  	select HAVE_FAST_GUP
>  	select HAVE_FENTRY			if X86_64 || DYNAMIC_FTRACE
> -	select HAVE_FTRACE_MCOUNT_RECORD
>  	select HAVE_FUNCTION_GRAPH_TRACER
>  	select HAVE_FUNCTION_TRACER
>  	select HAVE_GCC_PLUGINS

This breaks DYNAMIC_FTRACE according to kernel/trace/ftrace.c:

  #ifndef CONFIG_FTRACE_MCOUNT_RECORD
  # error Dynamic ftrace depends on MCOUNT_RECORD
  #endif

And the build errors after that seem to confirm this. It looks like we might
need another flag to skip recordmcount.

Anyway, since objtool is run before recordmcount, I just left this unchanged
for testing and ignored the recordmcount warnings about __mcount_loc already
existing. Something is a bit off still though, I see this at boot:

  ------------[ ftrace bug ]------------
  ftrace failed to modify
  [<ffffffff81000660>] __tracepoint_iter_initcall_level+0x0/0x40
   actual:   0f:1f:44:00:00
  Initializing ftrace call sites
  ftrace record flags: 0
   (0)
   expected tramp: ffffffff81056500
  ------------[ cut here ]------------

Otherwise, this looks pretty good.

Sami
