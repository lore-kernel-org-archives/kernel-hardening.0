Return-Path: <SRS0=8X0b=YZ=lists.openwall.com=kernel-hardening-return-17229-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66049CA9ECF
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 19:02:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AE3042086D
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 19:02:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="FdSEwR9X"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE3042086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17229-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 2009 invoked by uid 550); 1 Nov 2019 19:02:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1989 invoked from network); 1 Nov 2019 19:02:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2fG4DzCLulQ+v7huA1kdMQ2RtRpH3xT6PP3dcQOR3YM=;
        b=FdSEwR9X5l9Wqc+/eshiHPMlZ+qbVGkM0VrADZRZNoPKl47i8lf6Ah2ogK43O9mLBz
         C38lxuGZvsa0tFqnuBBHY2YWJOfGOTokdGNGz6+UQ9XWtZ1Qp16zcUsqtprBYXlv+ny5
         fD8DNC5oZHJ6AV27OHsxTC/ul2AuGnuvtGGk4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2fG4DzCLulQ+v7huA1kdMQ2RtRpH3xT6PP3dcQOR3YM=;
        b=aWCb9l3sS1E5zu2Y5e/eeEri9DqiFa4js+YTNNwzHO8V5N1GwXgrCgyRrowpp2g+Pq
         ZHi9KvW7I3pchnrh1LyT3ozpxJErmUgWfJUL4/xdr6a8ovAmnZgukdo4ZK0JPB8nS0XA
         Rh7jSJn/V8xx+PwHA2yi69y+y8TfM31ULW/mRiOru8qfJVnUEtKgC0f9WDMgd2g1hFnQ
         ucrUS8yUaETLT32Djbphgkx0Pdv+Hun+I8h+qKgE7bvbzR9wWYLCxY9IMCbTCNIdTS0H
         7XhMMfzj5QsQlTxPgRGjuEeeUYYtz2BzRTh75sLM+GClXSdRxoM/AIFwANw1bGRcEGKI
         oaYQ==
X-Gm-Message-State: APjAAAWc0KF5OJltvcsfDvFZCOOJZgATS3n9l4hIZmsaOWWFz0d20RJh
	+ZQzvCjFZaJ15FmDUOifIYKdLg==
X-Google-Smtp-Source: APXvYqzEjD8mlyAQagoCql+H8OD47PXOJ5YDq8BZhhrYFD67Vj1PkcdsuEn3Dl9QXx9NFWLOxoUDbw==
X-Received: by 2002:a65:5a06:: with SMTP id y6mr15317180pgs.9.1572634935932;
        Fri, 01 Nov 2019 12:02:15 -0700 (PDT)
Date: Fri, 1 Nov 2019 12:02:13 -0700
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Laura Abbott <labbott@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 07/17] scs: add support for stack usage debugging
Message-ID: <201911011201.A070D143D@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191031164637.48901-1-samitolvanen@google.com>
 <20191031164637.48901-8-samitolvanen@google.com>
 <201910312054.3064999E@keescook>
 <CABCJKueAf3f-rHw8AXJKKi=kfnh+nBMpJP2Vb2DVqLUWZVmFqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKueAf3f-rHw8AXJKKi=kfnh+nBMpJP2Vb2DVqLUWZVmFqQ@mail.gmail.com>

On Fri, Nov 01, 2019 at 09:32:54AM -0700, Sami Tolvanen wrote:
> On Thu, Oct 31, 2019 at 8:55 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Thu, Oct 31, 2019 at 09:46:27AM -0700, samitolvanen@google.com wrote:
> > > Implements CONFIG_DEBUG_STACK_USAGE for shadow stacks.
> >
> > Did I miss it, or is there no Kconfig section for this? I just realized
> > I can't find it. I was going to say "this commit log should explain
> > why/when this option is used", but then figured it might be explained in
> > the Kconfig ... but I couldn't find it. ;)
> 
> It's in lib/Kconfig.debug. But yes, I will add a commit message in v4.

Oh duh -- it's an existing option. Cool; I'm all good. :)

-- 
Kees Cook
