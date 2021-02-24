Return-Path: <SRS0=GvAe=H2=lists.openwall.com=kernel-hardening-return-20825-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC09C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Feb 2021 20:54:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7BC6E64E20
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Feb 2021 20:54:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BC6E64E20
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20825-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26312 invoked by uid 550); 24 Feb 2021 20:54:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26286 invoked from network); 24 Feb 2021 20:54:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LLIfyeFIub3muB/CP7Hm2VoepJyVW4tHjdnBCk4yhLg=;
        b=ollMcONV3bdQ14QYtVBWt6OyYXIP4whd8nwR5FrAAoQprgeHlmN1Lh632mEYtxVBSI
         G4+0oh8aEKmX6WHRxZ/cD3de2wT6ITxtYGBJRwApyx5JOWST1pJvimvC7kIIEcRmJIhX
         cxWpev8Q9LWPytWtDWk5kkB7hijixTdqVkP5KuyaHMKZiVa/Quydp+bZJyfzHOEo3S0y
         10d7fNSsZkyAahwGnT4i6pWEhNAUdZpnmNn9XiLqYORRONogk6w8ca+FtsbgpAxmHru+
         GjzVvfuqXIq5M68x+natPnOzaLGwVMOrCilUbMYcEktclLWM0NLBY34qeQmJ/lQ8dJzi
         lEAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LLIfyeFIub3muB/CP7Hm2VoepJyVW4tHjdnBCk4yhLg=;
        b=kTORcjjPMCHGyKAzeIWcJ2nQI0WMEZ/WNwY1KCfaQURwayMubBM078rV6NUNUR4nB+
         jfWYLKIwXisxCnUuh2KPnS7Jn77k815A+jhhXcnqzNJDCP20mXEtqxoKizRM/doY5Xfc
         1VDWdAsN21GxFtbz5cJYu5zgnT+YNElAKeMB6u6URf812ppUzqRm3RWzyr+yuFxPyu+e
         Ub74dO/qlfYCsn7bUdaSxU16w/IwFBWmfnykq2R1eMHYfZzrofAdkcGUdAM7LcztKlnj
         JYjnyBHkGuTg6PsTN7xR24CLECAuIj2MUublbmek/zkudlHPlkpetgKj8KoUJ8t3wVhA
         IlTA==
X-Gm-Message-State: AOAM531Hc2YvU7rKTIGhyzSGu5+GrGgAeDUqw0XiwW/vzZ8F/WPjKAe1
	ryrSjimx+KxHc36W2PU0ZTw1yYOFmhCygtVLKyTSwg==
X-Google-Smtp-Source: ABdhPJwDkAZHxqTqNM1na6tlHBSoIcFQFsNIy4TN5WNwBY+1hn1Ea0NqgKnjX2WoQcdN6Tf/Ph1uK9pKsYI+hEdPksc=
X-Received: by 2002:a9f:2021:: with SMTP id 30mr11157082uam.66.1614200066849;
 Wed, 24 Feb 2021 12:54:26 -0800 (PST)
MIME-Version: 1.0
References: <20201211184633.3213045-1-samitolvanen@google.com>
 <20201211184633.3213045-2-samitolvanen@google.com> <20210224201723.GA69309@roeck-us.net>
 <202102241238.93BC4DCF@keescook>
In-Reply-To: <202102241238.93BC4DCF@keescook>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Wed, 24 Feb 2021 12:54:15 -0800
Message-ID: <CABCJKufph4se58eiJNSJUd3ASBgbJGmL2e3wg4Jwo4Bi2UxP=Q@mail.gmail.com>
Subject: Re: [PATCH v9 01/16] tracing: move function tracer options to Kconfig
 (causing parisc build failures)
To: Kees Cook <keescook@chromium.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Masahiro Yamada <masahiroy@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	PCI <linux-pci@vger.kernel.org>, linux-parisc@vger.kernel.org, 
	Helge Deller <deller@gmx.de>
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 24, 2021 at 12:38 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Wed, Feb 24, 2021 at 12:17:23PM -0800, Guenter Roeck wrote:
> > On Fri, Dec 11, 2020 at 10:46:18AM -0800, Sami Tolvanen wrote:
> > > Move function tracer options to Kconfig to make it easier to add
> > > new methods for generating __mcount_loc, and to make the options
> > > available also when building kernel modules.
> > >
> > > Note that FTRACE_MCOUNT_USE_* options are updated on rebuild and
> > > therefore, work even if the .config was generated in a different
> > > environment.
> > >
> > > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > > Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> >
> > With this patch in place, parisc:allmodconfig no longer builds.
> >
> > Error log:
> > Arch parisc is not supported with CONFIG_FTRACE_MCOUNT_RECORD at scripts/recordmcount.pl line 405.
> > make[2]: *** [scripts/mod/empty.o] Error 2
> >
> > Due to this problem, CONFIG_FTRACE_MCOUNT_RECORD can no longer be
> > enabled in parisc builds. Since that is auto-selected by DYNAMIC_FTRACE,
> > DYNAMIC_FTRACE can no longer be enabled, and with it everything that
> > depends on it.
>
> Ew. Any idea why this didn't show up while it was in linux-next?

Does anyone build parisc allmodconfig from -next?

parisc seems to always use -fpatchable-function-entry with dynamic
ftrace, so we just need to select
FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY to stop it from defaulting
to recordmcount:

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index ecef9aff9d72..9ee806f68123 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -60,6 +60,7 @@ config PARISC
        select HAVE_KPROBES
        select HAVE_KRETPROBES
        select HAVE_DYNAMIC_FTRACE if
$(cc-option,-fpatchable-function-entry=1,1)
+       select FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY if HAVE_DYNAMIC_FTRACE
        select HAVE_FTRACE_MCOUNT_RECORD if HAVE_DYNAMIC_FTRACE
        select HAVE_KPROBES_ON_FTRACE
        select HAVE_DYNAMIC_FTRACE_WITH_REGS

I'll send a proper patch shortly.

Sami
