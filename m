Return-Path: <SRS0=Jhob=AF=lists.openwall.com=kernel-hardening-return-19146-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEFB0C433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 21:49:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 36F93207E8
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 21:49:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U3zcce4R"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36F93207E8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19146-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11342 invoked by uid 550); 24 Jun 2020 21:49:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11310 invoked from network); 24 Jun 2020 21:49:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9J2CZUP48fiuDe+l15O7PqgQWB3mKCPT+APYGkolERE=;
        b=U3zcce4R0BFZQpBMXUia0L4rUmnNxJL6RRN0I2qT8KyRFHOUyab+3sv5FvK7Q+xQT6
         BfXPRGjflDr7UeiF3S5kP1XPOkiAWEVZZ/sDu+fq3VlegLJ+3XLrquIZWjn7ayWkYCzD
         DGlm9hqV04oeJ5pt1TWn2smpfobQHkJ+60DVMifOj5Dgwdf34GqiNbK4bIibj5IwSOzY
         okUcH/p5gUNVj1kjU2l3JaKAdYw5JsvwR8Hv2An0RNPw4VAHR44NH77iLSgJAsOZJFW9
         jBx989iScWXwNiWoAxg5iH7/axM+9HKVvfS/FqN1YlndNZjL6GijGhSrKxkAPsx47LD2
         ZwEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9J2CZUP48fiuDe+l15O7PqgQWB3mKCPT+APYGkolERE=;
        b=CJjxeVRYMimeHzaBLYIVH3fDEG6DTR8zRYICiYURRe9vGphYOIZ9L4olXAdxX9lo2m
         g/mXY6lB7bI0cMjffAQN6A/UgXU1Wt0OQd9NdZaKG+F5RYG2B5f0hNkVGGbM36KPAOpC
         iIjExyT8+ARLXwcKy1IX46tyXOHcJGVOosLewBdhO8ELlCS7b8wXwgCWMZ0Ca2jagDBk
         xzNNVL43nNEe5CmJXi9GNELcUd5Kgvq0QInbcdFzsqNfaf4gLw3hHj7H4TjYo3Et/DbY
         DKX+ReqfhGxIhOQNgtn8Z36uhC8sa9gLLgeIkM8ejJSi9yYMC3pofGmmDs8JVyKIJPYq
         N31w==
X-Gm-Message-State: AOAM530XnJ/0fkGqyTM+dbGY2YCDtvhGfUkNRTGid7lYvMEezICzl47G
	y065eD53ko3Dk8uAuH8piOACvw==
X-Google-Smtp-Source: ABdhPJxYBIdYkNbMX8PMFnJWZ0uuJrnuXagI0eh1U8IdCvJqB4VqKOTU2xlvfTQ3szE4BUL/AQHpug==
X-Received: by 2002:a17:90a:a406:: with SMTP id y6mr32616295pjp.216.1593035372032;
        Wed, 24 Jun 2020 14:49:32 -0700 (PDT)
Date: Wed, 24 Jun 2020 14:49:25 -0700
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
Message-ID: <20200624214925.GB120457@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-6-samitolvanen@google.com>
 <20200624211908.GT4817@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624211908.GT4817@hirez.programming.kicks-ass.net>

On Wed, Jun 24, 2020 at 11:19:08PM +0200, Peter Zijlstra wrote:
> On Wed, Jun 24, 2020 at 01:31:43PM -0700, Sami Tolvanen wrote:
> > diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> > index 30827f82ad62..12b115152532 100644
> > --- a/include/linux/compiler.h
> > +++ b/include/linux/compiler.h
> > @@ -120,7 +120,7 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
> >  /* Annotate a C jump table to allow objtool to follow the code flow */
> >  #define __annotate_jump_table __section(.rodata..c_jump_table)
> >  
> > -#ifdef CONFIG_DEBUG_ENTRY
> > +#if defined(CONFIG_DEBUG_ENTRY) || defined(CONFIG_LTO_CLANG)
> >  /* Begin/end of an instrumentation safe region */
> >  #define instrumentation_begin() ({					\
> >  	asm volatile("%c0:\n\t"						\
> 
> Why would you be doing noinstr validation for lto builds? That doesn't
> make sense.

This is just to avoid a ton of noinstr warnings when we run objtool on
vmlinux.o, but I'm also fine with skipping noinstr validation with LTO.

> > +ifdef CONFIG_STACK_VALIDATION
> > +ifneq ($(SKIP_STACK_VALIDATION),1)
> > +cmd_ld_ko_o +=								\
> > +	$(objtree)/tools/objtool/objtool				\
> > +		$(if $(CONFIG_UNWINDER_ORC),orc generate,check)		\
> > +		--module						\
> > +		$(if $(CONFIG_FRAME_POINTER),,--no-fp)			\
> > +		$(if $(CONFIG_GCOV_KERNEL),--no-unreachable,)		\
> > +		$(if $(CONFIG_RETPOLINE),--retpoline,)			\
> > +		$(if $(CONFIG_X86_SMAP),--uaccess,)			\
> > +		$(@:.ko=$(prelink-ext).o);
> > +
> > +endif # SKIP_STACK_VALIDATION
> > +endif # CONFIG_STACK_VALIDATION
> 
> What about the objtool invocation from link-vmlinux.sh ?

What about it? The existing objtool_link invocation in link-vmlinux.sh
works fine for our purposes as well.

Sami
