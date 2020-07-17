Return-Path: <SRS0=wnxR=A4=lists.openwall.com=kernel-hardening-return-19387-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC029C433E2
	for <kernel-hardening@archiver.kernel.org>; Fri, 17 Jul 2020 17:37:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5646C20737
	for <kernel-hardening@archiver.kernel.org>; Fri, 17 Jul 2020 17:37:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5646C20737
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19387-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 8024 invoked by uid 550); 17 Jul 2020 17:37:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8001 invoked from network); 17 Jul 2020 17:37:02 -0000
Date: Fri, 17 Jul 2020 13:36:45 -0400
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
Message-ID: <20200717133645.7816c0b6@oasis.local.home>
In-Reply-To: <CABCJKucSM7gqWmUtiBPbr208wB0pc25afJXc6yBQzJDZf4LSWA@mail.gmail.com>
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
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 17 Jul 2020 10:28:13 -0700
Sami Tolvanen <samitolvanen@google.com> wrote:

> On Fri, Jun 26, 2020 at 4:29 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Thu, Jun 25, 2020 at 03:40:42PM -0700, Sami Tolvanen wrote:
> >  
> > > > Not boot tested, but it generates the required sections and they look
> > > > more or less as expected, ymmv.  
> >  
> > > > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > > > index a291823f3f26..189575c12434 100644
> > > > --- a/arch/x86/Kconfig
> > > > +++ b/arch/x86/Kconfig
> > > > @@ -174,7 +174,6 @@ config X86
> > > >     select HAVE_EXIT_THREAD
> > > >     select HAVE_FAST_GUP
> > > >     select HAVE_FENTRY                      if X86_64 || DYNAMIC_FTRACE
> > > > -   select HAVE_FTRACE_MCOUNT_RECORD
> > > >     select HAVE_FUNCTION_GRAPH_TRACER
> > > >     select HAVE_FUNCTION_TRACER
> > > >     select HAVE_GCC_PLUGINS  
> > >
> > > This breaks DYNAMIC_FTRACE according to kernel/trace/ftrace.c:
> > >
> > >   #ifndef CONFIG_FTRACE_MCOUNT_RECORD
> > >   # error Dynamic ftrace depends on MCOUNT_RECORD
> > >   #endif
> > >
> > > And the build errors after that seem to confirm this. It looks like we might
> > > need another flag to skip recordmcount.  
> >
> > Hurm, Steve, how you want to do that?  
> 
> Steven, did you have any thoughts about this? Moving recordmcount to
> an objtool pass that knows about call sites feels like a much cleaner
> solution than annotating kernel code to avoid unwanted relocations.
> 

Bah, I started to reply to this then went to look for details, got
distracted, forgot about it, my laptop crashed (due to a zoom call),
and I lost the email I was writing (haven't looked in the drafts
folder, but my idea about this has changed since anyway).

So the problem is that we process mcount references in other areas and
that confuses the ftrace modification portion?

Someone just submitted a patch for arm64 for this:

https://lore.kernel.org/r/20200717143338.19302-1-gregory.herrero@oracle.com

Is that what you want?

-- Steve
