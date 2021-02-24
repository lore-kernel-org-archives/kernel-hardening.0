Return-Path: <SRS0=ji+I=H2=lists.openwall.com=kernel-hardening-return-20826-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E2D7C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Feb 2021 22:28:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3672964E05
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Feb 2021 22:28:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3672964E05
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20826-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5294 invoked by uid 550); 24 Feb 2021 22:28:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5264 invoked from network); 24 Feb 2021 22:28:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ml1ODi0kbhU+05qftW0EgSQZXlvbak4aIvECP0XMcr8=;
        b=ohs7z461rdqHw8Oi3RZE/9WV1ZMBLPT3vLMCXgoNS8EmuP0zSGScn+MzJAW+zvP8oh
         c1e27DB/qNX255+Hfq/0aAa1AVAWEGIH1P1CFlUPosGMvkj1+amoqZJpTiqVcoVY2pOf
         mW28RZJjH9hkv5kauVt+eLaGq5e1NlnngdWVSTidlou5xN7onkFlX7ERwzo28Gj0Wr7c
         zwLP4z4E68BJaTzPr0uHLIWXs/6Y2wiHHDv+EutoNdsYgzY4Q5QQYNtUxJA+v0fA8fZX
         gjA37SeedzGgK75GqKTxPShJUMeu7QiL2Pf8XYDy4ixHIEDCsGpc7ahP36alKnfr7OHl
         HGPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ml1ODi0kbhU+05qftW0EgSQZXlvbak4aIvECP0XMcr8=;
        b=Az7C+UaVkzRatURfOTGmjt4651T2/7E0h+C1Pycp+lGDAOUiiUjGc96ZHkkT9T1zln
         T+slQsxbWSQODUUCf5TwL8eRIXpZynQpPFB4Gi659k/bfNXG+yLm010zrWyebNJdjzf1
         NZGtSFUi+ZcduOK3H2ZxNp8wSzR7+0bDAkvVRqrj2zD8qGOXq1mOdXyBX9C8iMrMiwmH
         SAWsu6YuAfx00r7UZe+xTIscS9mP6aPZFXiOXbFayGiXGCHfxjNgwK2xwnq8pJcs+7Ej
         j7bF4+usGJo7wIOIA1d1g3F2gnCGTKFzN6n/Jf76Mdi7GsTpKVbouR7P3wCRizGDEDyN
         f5DA==
X-Gm-Message-State: AOAM530GZmxpx6g63ScYCHyoHs20eucqimKI0evn2No52MTg3LH9490E
	Lvv8uyfw2meZCv4+edXlORg=
X-Google-Smtp-Source: ABdhPJw5khRVoPOKf4Clkys33gUDj/xuRsVY2C8UyDiecRo0VXwWrOcHycZmchRPbxDhZkQD9ya4Kw==
X-Received: by 2002:a05:6808:1290:: with SMTP id a16mr4146086oiw.161.1614205689974;
        Wed, 24 Feb 2021 14:28:09 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 24 Feb 2021 14:28:07 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Kees Cook <keescook@chromium.org>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-parisc@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: Re: [PATCH v9 01/16] tracing: move function tracer options to
 Kconfig (causing parisc build failures)
Message-ID: <20210224222807.GA74404@roeck-us.net>
References: <20201211184633.3213045-1-samitolvanen@google.com>
 <20201211184633.3213045-2-samitolvanen@google.com>
 <20210224201723.GA69309@roeck-us.net>
 <202102241238.93BC4DCF@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202102241238.93BC4DCF@keescook>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Wed, Feb 24, 2021 at 12:38:54PM -0800, Kees Cook wrote:
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
> 

It did, I just wasn't able to bisect it there.

Guenter
