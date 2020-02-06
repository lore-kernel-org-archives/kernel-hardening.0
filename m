Return-Path: <SRS0=ucE8=32=lists.openwall.com=kernel-hardening-return-17698-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 455F0C33CAC
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 11:53:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9472921775
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 11:53:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="R5Xlq0RI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9472921775
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17698-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 8032 invoked by uid 550); 6 Feb 2020 11:53:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8012 invoked from network); 6 Feb 2020 11:53:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QoBuf+g4Xxni6UvGzXiTkNzIActsAJcHEvJL0GRcYx8=;
        b=R5Xlq0RIQQTLqUa8qKTou4rSksjpBBz9TjP86XXO7E4Tuwiieo96zVVhZlH+93zGUD
         bzlD31tE81BY9v+0GAYnBV5v+V5sXbyvABDV4DA88MsG+3PLxSee4lU73cccmps87FQN
         cCxYxdTQRfEpxBAhyyx8hTq7URx4/raEeFZkM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QoBuf+g4Xxni6UvGzXiTkNzIActsAJcHEvJL0GRcYx8=;
        b=YYdV09uFPVFgnS3LDrzaFf+LT+vVlM1GyKjEwP9LLG3nQW1ue31B5a1lBXcegd0qxW
         vBzvXQpNYZZf6bjzSbewavaldBlUKrPbf9XxfCIjFVqZ/IiIT6DIccRgZiExGhPi4RKZ
         +3Oi8vIhTKVIB3C6H3p1oTx+fri9mEG6kGNMINM08MkBbv/a+uX4OnubkL4oAlRkMVJZ
         mtTpf3iPEdkG75W+lYfgjjKvWizMF/EXXkG2cKySCOKBrWOjxyNWFYgJg7xEJTj7QDx0
         2cnAGeq3RmkZEFbMcEpR/MGTAvUl6up0vWPKqHpjYN+CJL+LaeOzX0dLyI1KUuOZgi1o
         qvlA==
X-Gm-Message-State: APjAAAWNLaeZUBZ2RmhE48KAFfgiGoaA6YESmXKZ63Aa92zoPzFhgZ1w
	y5q/WK0qRJshViUVMmK6M+N9tA==
X-Google-Smtp-Source: APXvYqyvEG2esL/xfTcmuUFiEIXQPPyBLna4U/YdvgcHle0HS3e+pc6RLhK/cy8xnBBDz95dp3rg6Q==
X-Received: by 2002:a05:6808:b29:: with SMTP id t9mr6587780oij.69.1580989976311;
        Thu, 06 Feb 2020 03:52:56 -0800 (PST)
Date: Thu, 6 Feb 2020 03:52:54 -0800
From: Kees Cook <keescook@chromium.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 05/11] x86: Makefile: Add build and config option for
 CONFIG_FG_KASLR
Message-ID: <202002060348.7543F4D5@keescook>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-6-kristen@linux.intel.com>
 <20200206103055.GV14879@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206103055.GV14879@hirez.programming.kicks-ass.net>

On Thu, Feb 06, 2020 at 11:30:55AM +0100, Peter Zijlstra wrote:
> On Wed, Feb 05, 2020 at 02:39:44PM -0800, Kristen Carlson Accardi wrote:
> > Allow user to select CONFIG_FG_KASLR if dependencies are met. Change
> > the make file to build with -ffunction-sections if CONFIG_FG_KASLR
> > 
> > Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> > ---
> >  Makefile         |  4 ++++
> >  arch/x86/Kconfig | 13 +++++++++++++
> >  2 files changed, 17 insertions(+)
> > 
> > diff --git a/Makefile b/Makefile
> > index c50ef91f6136..41438a921666 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -846,6 +846,10 @@ ifdef CONFIG_LIVEPATCH
> >  KBUILD_CFLAGS += $(call cc-option, -flive-patching=inline-clone)
> >  endif
> >  
> > +ifdef CONFIG_FG_KASLR
> > +KBUILD_CFLAGS += -ffunction-sections
> > +endif
> [...]
> In particular:
> 
>   "They prevent optimizations by the compiler and assembler using
>   relative locations inside a translation unit since the locations are
>   unknown until link time."

I think this mainly a feature of this flag, since it's those relocations
that are used to do the post-shuffle fixups. But yes, I would imagine
this has some negative impact on code generation.

> I suppose in practise this only means tail-calls are affected and will
> no longer use JMP.d8. Or are more things affected?

It's worth looking at. I'm also curious to see how this will interact
with Link Time Optimization.

-- 
Kees Cook
