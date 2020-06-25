Return-Path: <SRS0=mzfB=AG=lists.openwall.com=kernel-hardening-return-19168-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D13C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jun 2020 16:22:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 190E820857
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jun 2020 16:22:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XvqTcKvU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 190E820857
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19168-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1712 invoked by uid 550); 25 Jun 2020 16:22:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1678 invoked from network); 25 Jun 2020 16:22:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cYEaM8fKpZG71PCkfHkApRmPtCwvXrrY+JocHC3nIv8=;
        b=XvqTcKvUnBqjH+Xq2/BDnD76lMTzDE39N73VPsal3e7jDR5L9CqPzEwi/HtJXxg5pZ
         sSViKozmxlxfRjR5junnpvtTtyW6G2rRQEW8ZFvCQk6aCeqvQ+zuO9yimSN9sFS7QooW
         PvXgArAb+SfCZcIY+Pqu9KdLFcAqo8UvqBCXGiy9t48Z69ZF5FReGe2odlppsG/6UARl
         Mdd0bQaWJWxZe0j9OL67jRPrRKjRhuCt16S32a8eOmCrvrHTXERopZ1dh0M2Ua2NwCSI
         Ek6M040jALm4P02V4qkx9xuhsfQb+UTvzenYTCIy4JIByKPSb7KkGeYN6II1dO0BKO5s
         5Xmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cYEaM8fKpZG71PCkfHkApRmPtCwvXrrY+JocHC3nIv8=;
        b=cMdtheuOq+j06cPDsVcjh7S5h/H8xo61SHpV5J8XwqUDXAY8olt8nrDSVAbNbdGw1k
         37pOK6vrqwnDZ15EWxGTp7oIUPWZ/kILc2xm+WahzbRgrBFCwh/Z2geUo5kdqABzAvne
         boz/EgQj/agylK4zThuc6PwTjDJofwWU6IDUAjIgp4YcLyh9ebfa06o5/9YQuy3z1G/x
         /cinBHYO8KAu0JHk2xWfKFBEWdcl9tJ01TQmPUl9znzfTNKa3BcCsysoJaMvHeqGGVhE
         RndJ3EwJVHw3ZDkiC3HInHILFyKkoF4Wp4UgUkA9L+lxYtWgWq2bRa6ZadFMAtei1ozK
         tlLg==
X-Gm-Message-State: AOAM531DZrHsoQWpNGHheFFkA4YlFsZG/ZxO+/6xmPhceGPhJPzgz5E6
	05XOIynlKofqRAXobjy2XFQjxoZdoYZprA==
X-Google-Smtp-Source: ABdhPJyBu5UBNmD93hBhA1nGG7iT9G95iHuvLnDzS07QCS69km8HMKCSBSO/u5bBKV8BF6Gd+7YLGw==
X-Received: by 2002:a63:7313:: with SMTP id o19mr27664372pgc.307.1593102153849;
        Thu, 25 Jun 2020 09:22:33 -0700 (PDT)
Date: Thu, 25 Jun 2020 09:22:26 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH 05/22] kbuild: lto: postpone objtool
Message-ID: <20200625162226.GC173089@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-6-samitolvanen@google.com>
 <20200624211908.GT4817@hirez.programming.kicks-ass.net>
 <20200624214925.GB120457@google.com>
 <20200625074716.GX4817@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625074716.GX4817@hirez.programming.kicks-ass.net>

On Thu, Jun 25, 2020 at 09:47:16AM +0200, Peter Zijlstra wrote:
> On Wed, Jun 24, 2020 at 02:49:25PM -0700, Sami Tolvanen wrote:
> > On Wed, Jun 24, 2020 at 11:19:08PM +0200, Peter Zijlstra wrote:
> > > On Wed, Jun 24, 2020 at 01:31:43PM -0700, Sami Tolvanen wrote:
> > > > diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> > > > index 30827f82ad62..12b115152532 100644
> > > > --- a/include/linux/compiler.h
> > > > +++ b/include/linux/compiler.h
> > > > @@ -120,7 +120,7 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
> > > >  /* Annotate a C jump table to allow objtool to follow the code flow */
> > > >  #define __annotate_jump_table __section(.rodata..c_jump_table)
> > > >  
> > > > -#ifdef CONFIG_DEBUG_ENTRY
> > > > +#if defined(CONFIG_DEBUG_ENTRY) || defined(CONFIG_LTO_CLANG)
> > > >  /* Begin/end of an instrumentation safe region */
> > > >  #define instrumentation_begin() ({					\
> > > >  	asm volatile("%c0:\n\t"						\
> > > 
> > > Why would you be doing noinstr validation for lto builds? That doesn't
> > > make sense.
> > 
> > This is just to avoid a ton of noinstr warnings when we run objtool on
> > vmlinux.o, but I'm also fine with skipping noinstr validation with LTO.
> 
> Right, then we need to make --no-vmlinux work properly when
> !DEBUG_ENTRY, which I think might be buggered due to us overriding the
> argument when the objname ends with "vmlinux.o".

Right. Can we just remove that and  pass --vmlinux to objtool in
link-vmlinux.sh, or is the override necessary somewhere else?

> > > > +ifdef CONFIG_STACK_VALIDATION
> > > > +ifneq ($(SKIP_STACK_VALIDATION),1)
> > > > +cmd_ld_ko_o +=								\
> > > > +	$(objtree)/tools/objtool/objtool				\
> > > > +		$(if $(CONFIG_UNWINDER_ORC),orc generate,check)		\
> > > > +		--module						\
> > > > +		$(if $(CONFIG_FRAME_POINTER),,--no-fp)			\
> > > > +		$(if $(CONFIG_GCOV_KERNEL),--no-unreachable,)		\
> > > > +		$(if $(CONFIG_RETPOLINE),--retpoline,)			\
> > > > +		$(if $(CONFIG_X86_SMAP),--uaccess,)			\
> > > > +		$(@:.ko=$(prelink-ext).o);
> > > > +
> > > > +endif # SKIP_STACK_VALIDATION
> > > > +endif # CONFIG_STACK_VALIDATION
> > > 
> > > What about the objtool invocation from link-vmlinux.sh ?
> > 
> > What about it? The existing objtool_link invocation in link-vmlinux.sh
> > works fine for our purposes as well.
> 
> Well, I was wondering why you're adding yet another objtool invocation
> while we already have one.

Because we can't run objtool until we have compiled bitcode to native
code, so for modules, we're need another invocation after everything has
been compiled.

Sami
