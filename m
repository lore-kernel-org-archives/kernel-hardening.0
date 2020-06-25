Return-Path: <SRS0=w/ac=AG=lists.openwall.com=kernel-hardening-return-19159-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CE4C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jun 2020 07:46:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 47DC620675
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jun 2020 07:46:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MVs61XR8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47DC620675
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19159-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30024 invoked by uid 550); 25 Jun 2020 07:46:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29986 invoked from network); 25 Jun 2020 07:46:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2aQ/V3CRB+JTPOL3qC/HxsWm+wJhkXGBtq9FiN50dxw=; b=MVs61XR8PHT2An2kAHFoVGpNaN
	L4hxfCHN0na+bXYcmoGM6fWmmaLm7d3p6PumUpigGZx4NET8Y22MadCNhuDD2tjz4bsAx+YeRr8US
	rO5Ph/sbzdu4v7rVC1aVaiLtBk178mbNOCE6uWemg8h/W8LV+TH9FVvH8ZqN2vdqTAt5dRcG3NIfV
	szFdqm0VJ59PkYZYpIY6zdlwCdeWCvhK56AovRtjFjyPn0yqF3yhfbzwmorhqV4KQ1ma6vlIdDuje
	xB9TwF6459hMixZkCdI6jdbxggiKReKLnIA3sI0gv2cMZe/rxoUPK9GVPLyTKxrBYihPvtqUYvTp7
	UeOTNh3A==;
Date: Thu, 25 Jun 2020 09:45:30 +0200
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
	x86@kernel.org
Subject: Re: [PATCH 04/22] kbuild: lto: fix recordmcount
Message-ID: <20200625074530.GW4817@hirez.programming.kicks-ass.net>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-5-samitolvanen@google.com>
 <20200624212737.GV4817@hirez.programming.kicks-ass.net>
 <20200624214530.GA120457@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624214530.GA120457@google.com>

On Wed, Jun 24, 2020 at 02:45:30PM -0700, Sami Tolvanen wrote:
> On Wed, Jun 24, 2020 at 11:27:37PM +0200, Peter Zijlstra wrote:
> > On Wed, Jun 24, 2020 at 01:31:42PM -0700, Sami Tolvanen wrote:
> > > With LTO, LLVM bitcode won't be compiled into native code until
> > > modpost_link. This change postpones calls to recordmcount until after
> > > this step.
> > > 
> > > In order to exclude specific functions from inspection, we add a new
> > > code section .text..nomcount, which we tell recordmcount to ignore, and
> > > a __nomcount attribute for moving functions to this section.
> > 
> > I'm confused, you only add this to functions in ftrace itself, which is
> > compiled with:
> > 
> >  KBUILD_CFLAGS = $(subst $(CC_FLAGS_FTRACE),,$(ORIG_CFLAGS))
> > 
> > and so should not have mcount/fentry sites anyway. So what's the point
> > of ignoring them further?
> > 
> > This Changelog does not explain.
> 
> Normally, recordmcount ignores each ftrace.o file, but since we are
> running it on vmlinux.o, we need another way to stop it from looking
> at references to mcount/fentry that are not calls. Here's a comment
> from recordmcount.c:
> 
>   /*
>    * The file kernel/trace/ftrace.o references the mcount
>    * function but does not call it. Since ftrace.o should
>    * not be traced anyway, we just skip it.
>    */
> 
> But I agree, the commit message could use more defails. Also +Steven
> for thoughts about this approach.

Ah, is thi because recordmcount isn't smart enough to know the
difference between "CALL $mcount" and any other RELA that has mcount?

At least for x86_64 I can do a really quick take for a recordmcount pass
in objtool, but I suppose you also need this for ARM64 ?
