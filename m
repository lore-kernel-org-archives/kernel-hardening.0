Return-Path: <SRS0=IOyf=H2=lists.openwall.com=kernel-hardening-return-20827-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 635E0C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Feb 2021 22:29:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 545BA64E05
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Feb 2021 22:29:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 545BA64E05
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20827-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7920 invoked by uid 550); 24 Feb 2021 22:29:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7894 invoked from network); 24 Feb 2021 22:29:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=u6XAvXUVnlDMggAEsXaHM4e8hEC4mF5s4JegHeSo1z4=;
        b=WXKmbDE438sr38D2CmGIsGEX4Geb9dTZqskZrMVRyU2zsH8cwKx74cPRXuOgXmiR8d
         8PGR0VhKEGeP/oyqgHyMTEWKqGvNumu5SrC6Fw81zm3356flV7AhLkrrSHLiR42VWsYQ
         SFf5x3AO6UodLZ+mOW0mT+fny5pAh3ixBP1ZAcRvq83wf64eqkR5BbVrSKcE6pUnVn1V
         zWJh+SRYExHV/t73tRL0SEr5xz9J7gykl8C+7fRWqXCYT4b1AUZ5UB61zE20WkowXWAb
         NY4DQOAnMKOMZdrrWgFgx5z7qMCuYi52PYv9ODoKdzsmDg8tgMDDSB6zqQ2B2bh7Dlnb
         G1VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=u6XAvXUVnlDMggAEsXaHM4e8hEC4mF5s4JegHeSo1z4=;
        b=ddw8PkHFJYXiUtpgihO+GbLeas9p89yEBzroHLBbnx7p3Q+q37dBy/1KRjI+RvldPp
         IhmRpxSTC+aviJS2i1JZDXplDtrstaAU0BY2YaNJZsH9MCQDoV766d2We/Y/SMq4RmzI
         jkIkRLtox4XsOBCQvY90f5XcGlUR+aZ0SJHYqw8Hqpb0q8gak9Irl8JFME6OkTk2rw4D
         MhfAprRHvAYQ4AG+HVQ3WB8+U7rxwOhFouh4Dr00Qg2y54gLrOi9j5BeLDjHzoiXthfX
         RcLsr1nePjZ5e723cM9E/wFaWYdazAd2xvBbt+K+eDGerpvxr15AVkgHFDNPO8tzUEsM
         jFbQ==
X-Gm-Message-State: AOAM532SEvTX74tKKefoRFPoz0Sl3CoRAsVt+cYN/FWHWS1bXYAjuzra
	QckMTSNPGjQl6HjHyAzevkQ=
X-Google-Smtp-Source: ABdhPJy2cu+9ylE3pPDrNFQsj91Ax/vfHdFQuwgZeHJv5TM9WPR2gNSYiHYnpOkegPtmu+HWGG5leg==
X-Received: by 2002:a05:6830:4c9:: with SMTP id s9mr14765343otd.133.1614205773544;
        Wed, 24 Feb 2021 14:29:33 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 24 Feb 2021 14:29:31 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Kees Cook <keescook@chromium.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	PCI <linux-pci@vger.kernel.org>, linux-parisc@vger.kernel.org,
	Helge Deller <deller@gmx.de>
Subject: Re: [PATCH v9 01/16] tracing: move function tracer options to
 Kconfig (causing parisc build failures)
Message-ID: <20210224222931.GB74404@roeck-us.net>
References: <20201211184633.3213045-1-samitolvanen@google.com>
 <20201211184633.3213045-2-samitolvanen@google.com>
 <20210224201723.GA69309@roeck-us.net>
 <202102241238.93BC4DCF@keescook>
 <CABCJKufph4se58eiJNSJUd3ASBgbJGmL2e3wg4Jwo4Bi2UxP=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKufph4se58eiJNSJUd3ASBgbJGmL2e3wg4Jwo4Bi2UxP=Q@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Wed, Feb 24, 2021 at 12:54:15PM -0800, Sami Tolvanen wrote:
> On Wed, Feb 24, 2021 at 12:38 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Wed, Feb 24, 2021 at 12:17:23PM -0800, Guenter Roeck wrote:
> > > On Fri, Dec 11, 2020 at 10:46:18AM -0800, Sami Tolvanen wrote:
> > > > Move function tracer options to Kconfig to make it easier to add
> > > > new methods for generating __mcount_loc, and to make the options
> > > > available also when building kernel modules.
> > > >
> > > > Note that FTRACE_MCOUNT_USE_* options are updated on rebuild and
> > > > therefore, work even if the .config was generated in a different
> > > > environment.
> > > >
> > > > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > > > Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > >
> > > With this patch in place, parisc:allmodconfig no longer builds.
> > >
> > > Error log:
> > > Arch parisc is not supported with CONFIG_FTRACE_MCOUNT_RECORD at scripts/recordmcount.pl line 405.
> > > make[2]: *** [scripts/mod/empty.o] Error 2
> > >
> > > Due to this problem, CONFIG_FTRACE_MCOUNT_RECORD can no longer be
> > > enabled in parisc builds. Since that is auto-selected by DYNAMIC_FTRACE,
> > > DYNAMIC_FTRACE can no longer be enabled, and with it everything that
> > > depends on it.
> >
> > Ew. Any idea why this didn't show up while it was in linux-next?
> 
> Does anyone build parisc allmodconfig from -next?
> 

https://kerneltests.org/builders/next-parisc-next

Guenter

> parisc seems to always use -fpatchable-function-entry with dynamic
> ftrace, so we just need to select
> FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY to stop it from defaulting
> to recordmcount:
> 
> diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
> index ecef9aff9d72..9ee806f68123 100644
> --- a/arch/parisc/Kconfig
> +++ b/arch/parisc/Kconfig
> @@ -60,6 +60,7 @@ config PARISC
>         select HAVE_KPROBES
>         select HAVE_KRETPROBES
>         select HAVE_DYNAMIC_FTRACE if
> $(cc-option,-fpatchable-function-entry=1,1)
> +       select FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY if HAVE_DYNAMIC_FTRACE
>         select HAVE_FTRACE_MCOUNT_RECORD if HAVE_DYNAMIC_FTRACE
>         select HAVE_KPROBES_ON_FTRACE
>         select HAVE_DYNAMIC_FTRACE_WITH_REGS
> 
> I'll send a proper patch shortly.
> 
> Sami
