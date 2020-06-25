Return-Path: <SRS0=1rTs=AG=lists.openwall.com=kernel-hardening-return-19166-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC619C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jun 2020 16:15:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4758F2082F
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jun 2020 16:15:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QWdvdGQM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4758F2082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19166-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27935 invoked by uid 550); 25 Jun 2020 16:15:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27900 invoked from network); 25 Jun 2020 16:15:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=no7YVr00DbKKQ+yaF/NLUAHDlIF83IoT6Cfe6Ue8Rsk=;
        b=QWdvdGQMKWLXFCj/e3uSXu3nIed+fEpI9sixMesz0lmaFvY+vhrbPQCL2sfOwX5Xtz
         dJOd7qtWZudwGhWJ+gbv1sxQvZIkuGk6XpJScPP6djHS3Gjtpwa7FrqRlou+lHRJtZZZ
         E6lOy4qOE0EckdWmFhkcLT54pDwlj99vXre4+ksDWSXwsjNcFMNF4qwlEGG8e1VqTFDQ
         xJh5VQeFsuhh9JPP5l68M979tHfFPP91RJEzeejy+3inJ6Ch9ZslROLlJkFXrp0dB7vi
         CJdzxgSmmDz68iPXfh2R8CxQ1kMKTk1lzBLXZYMYpViAqBc0if/psRGS2Bx8e3vIkdLC
         XavA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=no7YVr00DbKKQ+yaF/NLUAHDlIF83IoT6Cfe6Ue8Rsk=;
        b=tK5Et6VU2FQUh+8jKtrhdcScpO6zl6ffhNg4mc0IXzsz7DmqP1dyOqmPTSgEIf2u1O
         cfcVC9PtGdmfN+fYmc4w2sDrDL+vvewHdnZoPanmfVJK3jUcer/1lfUWaPupdJ/8ycdq
         kXGHunvd99EZE2dgle0sWUzWCqCbNSqLZF6G33Yi7bc8XEB9O0JTJCRe8OVxW/m6H/rE
         NKqKEo0DBY7xQX161n+tbA1AJQfcwtfmOpdEAIUT2khPOFvo7aCcAKnDVSKJOiDnC3X6
         bbOX2Yj6BNrFv89cX35fYQ35r14z8dc+dfTMva5RTpQSnGtM4PHuXDTEtc6JGAIiz3It
         s0pA==
X-Gm-Message-State: AOAM533FgCfzhFIYURoRtyTZmNn1c/DNYWw60nZ535uEV3rfMCrGhWNS
	gqvoBPOrQU4khqKGUXwCppZzCw==
X-Google-Smtp-Source: ABdhPJwBA+f5YY24rFGe1FlZ0Pbcr47k53bKGlTrbuSqy24H60q+oFwTSxgIA7OapKwETcq0tJs/tw==
X-Received: by 2002:a63:395:: with SMTP id 143mr23203113pgd.57.1593101710493;
        Thu, 25 Jun 2020 09:15:10 -0700 (PDT)
Date: Thu, 25 Jun 2020 09:15:03 -0700
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
	x86@kernel.org
Subject: Re: [PATCH 04/22] kbuild: lto: fix recordmcount
Message-ID: <20200625161503.GB173089@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-5-samitolvanen@google.com>
 <20200624212737.GV4817@hirez.programming.kicks-ass.net>
 <20200624214530.GA120457@google.com>
 <20200625074530.GW4817@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625074530.GW4817@hirez.programming.kicks-ass.net>

On Thu, Jun 25, 2020 at 09:45:30AM +0200, Peter Zijlstra wrote:
> On Wed, Jun 24, 2020 at 02:45:30PM -0700, Sami Tolvanen wrote:
> > On Wed, Jun 24, 2020 at 11:27:37PM +0200, Peter Zijlstra wrote:
> > > On Wed, Jun 24, 2020 at 01:31:42PM -0700, Sami Tolvanen wrote:
> > > > With LTO, LLVM bitcode won't be compiled into native code until
> > > > modpost_link. This change postpones calls to recordmcount until after
> > > > this step.
> > > > 
> > > > In order to exclude specific functions from inspection, we add a new
> > > > code section .text..nomcount, which we tell recordmcount to ignore, and
> > > > a __nomcount attribute for moving functions to this section.
> > > 
> > > I'm confused, you only add this to functions in ftrace itself, which is
> > > compiled with:
> > > 
> > >  KBUILD_CFLAGS = $(subst $(CC_FLAGS_FTRACE),,$(ORIG_CFLAGS))
> > > 
> > > and so should not have mcount/fentry sites anyway. So what's the point
> > > of ignoring them further?
> > > 
> > > This Changelog does not explain.
> > 
> > Normally, recordmcount ignores each ftrace.o file, but since we are
> > running it on vmlinux.o, we need another way to stop it from looking
> > at references to mcount/fentry that are not calls. Here's a comment
> > from recordmcount.c:
> > 
> >   /*
> >    * The file kernel/trace/ftrace.o references the mcount
> >    * function but does not call it. Since ftrace.o should
> >    * not be traced anyway, we just skip it.
> >    */
> > 
> > But I agree, the commit message could use more defails. Also +Steven
> > for thoughts about this approach.
> 
> Ah, is thi because recordmcount isn't smart enough to know the
> difference between "CALL $mcount" and any other RELA that has mcount?

Yes.

> At least for x86_64 I can do a really quick take for a recordmcount pass
> in objtool, but I suppose you also need this for ARM64 ?

Sure, sounds good. arm64 uses -fpatchable-function-entry with clang, so we
don't need recordmcount there.

Sami
