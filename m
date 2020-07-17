Return-Path: <SRS0=SDmD=A4=lists.openwall.com=kernel-hardening-return-19386-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38A3BC433E5
	for <kernel-hardening@archiver.kernel.org>; Fri, 17 Jul 2020 17:28:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 860502074B
	for <kernel-hardening@archiver.kernel.org>; Fri, 17 Jul 2020 17:28:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qkRGYkOM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 860502074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19386-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3953 invoked by uid 550); 17 Jul 2020 17:28:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3933 invoked from network); 17 Jul 2020 17:28:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7JTqB5slGWNqmPcHQg0gX2jPDhSmZshqLrbRwDwrvQQ=;
        b=qkRGYkOMW6VaoakdKRVaH5aUrXdmDg5t9er9/Vce66oxkl7UQqyWYOlRwXYeCpY3wW
         oGZLkqSMQcsYzJrQM1bl4jbPOH2ds+18vciyXIQPsIh7FHOEiWMHb+FbQPOAzmUtYx0d
         jAFb5ZBiJf1OgEZsVfnTqp9/tGZUXdX3DMpkRciQc7dzdFZjMmS+H+DJQfvlr/CrsaXE
         bH5rENTcwdmpjUlk5dB0JCsW5u+aaktYFW19sQYPYsWpe/3Pe/7RQhyb4jz0/LEW2lX3
         sL4OLuZO05Zi99C6TpMJZ+BigM//cBFejkcKoMvjeBR4jPKuIlKROtzMLgdkDvKya0hC
         pOsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7JTqB5slGWNqmPcHQg0gX2jPDhSmZshqLrbRwDwrvQQ=;
        b=A3A5VZd9fEcURyMdsIioG7ksV0s7pkKflujdZkRQy3Cael+HrTjTt3s5CkcE6fZkok
         AlPtLOEB/AcOtBhAGAWkOuIXHrC6EScwhskyiGpGaWVeROzGF3l0HSQBx07O1gecvAYA
         OTxqV/8GJSW0dhHMBgSBNCPIPvLjXDamLHKFi4M/Vk6jPnWlBjTscA0aqv6N4puIJ8RM
         +fS9QDdOEvVXt6/ERIHcaBrpiCFpVF1rt1+oxUqdeitKpvL5HNXQOMBmwoli7qURMclC
         EqXYtjDaCeFc6P25t68nBbB7WiubYs9pbg2HVdtrBLu1O+P8CJ9zcr4elZ4ZyvRA+0ml
         8KGA==
X-Gm-Message-State: AOAM533JY4RiK2vRpbtwX23Ta3W3Pl6RxWw81rT7ckIS/LsWvcjurErD
	+53y1G86wKcmwWl0Q/14JwJ2P7cAX+pAoSJlZw67fg==
X-Google-Smtp-Source: ABdhPJzlaBMxTWwrZe4YERy10lN7ECFDWF6Vu5QVaYVW+Htu2uWuMYN38XkknSqycX+o/PgPMS9zy6pkp2BhDOPkYdc=
X-Received: by 2002:a17:906:eb93:: with SMTP id mh19mr9298900ejb.552.1595006904583;
 Fri, 17 Jul 2020 10:28:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-5-samitolvanen@google.com> <20200624212737.GV4817@hirez.programming.kicks-ass.net>
 <20200624214530.GA120457@google.com> <20200625074530.GW4817@hirez.programming.kicks-ass.net>
 <20200625161503.GB173089@google.com> <20200625200235.GQ4781@hirez.programming.kicks-ass.net>
 <20200625224042.GA169781@google.com> <20200626112931.GF4817@hirez.programming.kicks-ass.net>
In-Reply-To: <20200626112931.GF4817@hirez.programming.kicks-ass.net>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 17 Jul 2020 10:28:13 -0700
Message-ID: <CABCJKucSM7gqWmUtiBPbr208wB0pc25afJXc6yBQzJDZf4LSWA@mail.gmail.com>
Subject: Re: [RFC][PATCH] objtool,x86_64: Replace recordmcount with objtool
To: Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Matt Helsley <mhelsley@vmware.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Jun 26, 2020 at 4:29 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Jun 25, 2020 at 03:40:42PM -0700, Sami Tolvanen wrote:
>
> > > Not boot tested, but it generates the required sections and they look
> > > more or less as expected, ymmv.
>
> > > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > > index a291823f3f26..189575c12434 100644
> > > --- a/arch/x86/Kconfig
> > > +++ b/arch/x86/Kconfig
> > > @@ -174,7 +174,6 @@ config X86
> > >     select HAVE_EXIT_THREAD
> > >     select HAVE_FAST_GUP
> > >     select HAVE_FENTRY                      if X86_64 || DYNAMIC_FTRACE
> > > -   select HAVE_FTRACE_MCOUNT_RECORD
> > >     select HAVE_FUNCTION_GRAPH_TRACER
> > >     select HAVE_FUNCTION_TRACER
> > >     select HAVE_GCC_PLUGINS
> >
> > This breaks DYNAMIC_FTRACE according to kernel/trace/ftrace.c:
> >
> >   #ifndef CONFIG_FTRACE_MCOUNT_RECORD
> >   # error Dynamic ftrace depends on MCOUNT_RECORD
> >   #endif
> >
> > And the build errors after that seem to confirm this. It looks like we might
> > need another flag to skip recordmcount.
>
> Hurm, Steve, how you want to do that?

Steven, did you have any thoughts about this? Moving recordmcount to
an objtool pass that knows about call sites feels like a much cleaner
solution than annotating kernel code to avoid unwanted relocations.

Sami
