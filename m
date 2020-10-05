Return-Path: <SRS0=SiQp=DM=lists.openwall.com=kernel-hardening-return-20090-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AE58C4727D
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Oct 2020 07:10:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A11492065D
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Oct 2020 07:10:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A11492065D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20090-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15531 invoked by uid 550); 5 Oct 2020 07:10:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15508 invoked from network); 5 Oct 2020 07:10:19 -0000
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Date: Mon, 5 Oct 2020 09:10:07 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>, 
    Sami Tolvanen <samitolvanen@google.com>, 
    Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
    Steven Rostedt <rostedt@goodmis.org>, 
    Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
    "Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
    Nick Desaulniers <ndesaulniers@google.com>, 
    clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
    linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
    linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-pci@vger.kernel.org, x86@kernel.org, jthierry@redhat.com
Subject: Re: [PATCH v4 04/29] objtool: Add a pass for generating
 __mcount_loc
In-Reply-To: <20201002141303.hyl72to37wudoi66@treble>
Message-ID: <alpine.LSU.2.21.2010050909510.12678@pobox.suse.cz>
References: <20200929214631.3516445-1-samitolvanen@google.com> <20200929214631.3516445-5-samitolvanen@google.com> <alpine.LSU.2.21.2010011504340.6689@pobox.suse.cz> <20201001133612.GQ2628@hirez.programming.kicks-ass.net>
 <20201002141303.hyl72to37wudoi66@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 2 Oct 2020, Josh Poimboeuf wrote:

> On Thu, Oct 01, 2020 at 03:36:12PM +0200, Peter Zijlstra wrote:
> > On Thu, Oct 01, 2020 at 03:17:07PM +0200, Miroslav Benes wrote:
> > 
> > > I also wonder about making 'mcount' command separate from 'check'. Similar 
> > > to what is 'orc' now. But that could be done later.
> > 
> > I'm not convinced more commands make sense. That only begets us the
> > problem of having to run multiple commands.
> 
> Agreed, it gets hairy when we need to combine things.  I think "orc" as
> a separate subcommand was a mistake.
> 
> We should change to something like
> 
>   objtool run [--check] [--orc] [--mcount]
>   objtool dump [--orc] [--mcount]

Yes, that makes sense.

Miroslav
