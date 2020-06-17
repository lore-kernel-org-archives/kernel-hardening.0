Return-Path: <SRS0=clbg=76=lists.openwall.com=kernel-hardening-return-19006-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A8EC433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 17 Jun 2020 21:30:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 61DA22080D
	for <kernel-hardening@archiver.kernel.org>; Wed, 17 Jun 2020 21:30:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zv03sXe7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61DA22080D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19006-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5917 invoked by uid 550); 17 Jun 2020 21:30:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5869 invoked from network); 17 Jun 2020 21:30:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iNW7nFhEI6LZ3FAxGyejnyXZOUx5LRT59wBgGEUa2pY=;
        b=Zv03sXe7v0sm71NEVWABUiuV4WyfDQu+Vs148YdDBnqH+4dqnrH44dgt+Q3K/yoy/P
         JM1bmY3MokvZ5hruRGoUqhtE5gF80UDRsSTfFtfGGU0KFl8PSmak0Eb+XxDITH7uBk5E
         CmPR+kDoIBaq0vFyY9U/4AM9piSYRzTOM2BdoFT/6WM0V2UuPBVuPdd76gMUAfhqU7wx
         uLhxQ+Ozk2LfJlnLgUwEKxcGpemsvojHAXWhEexBUuwz7R0XuAyHedvdkWrnWe38nrdy
         vTUfjMr8mLl0KpytbOoVfW94I3Wy1ZDSZENvD8WoJ7tCYsXx0oMQTbC6d0PB/5+MiGN2
         ANcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iNW7nFhEI6LZ3FAxGyejnyXZOUx5LRT59wBgGEUa2pY=;
        b=a6OMpQL4ygDypvTSxlZL9+8GavVI678/AqpUysc+7mr07yYDAbUCS0eC0YYm8Wchx1
         ybIVsdcmIxMjasr5lyyxxqUOksCqtbJRNOseCuIPVU/AH25nnnOHBhl2Bhn5MeTx2tso
         GQurTIEKx05vIWS4jsJkWSjp/FvdQj6oAfakm0RGHXrgXgo9+DOVsfmUwmxKwsOEchk3
         PewBpxMpmTgqoNvS3nvRBovrBV3RZgB8LgO5s1DjfFYxarZTvQ/H7lhnH28BO/FMgs4Y
         C6kHMBdZ4eSJlBohXOG5s1AuIpRfpwi9gaVSrY6DwSwQDOnZ50MH48mBTY9lk/tNkXfE
         Ap1w==
X-Gm-Message-State: AOAM530jOf5FX3dmu4S5xA35o9Y+UGDBIGELxHYdBPU3xLXwly6p2JFU
	Yz/FCXfaNTNxVwbnq+DEHxw8/cK/xrP7oz7U6rdKmw==
X-Google-Smtp-Source: ABdhPJzakSe2kPNs0RHEHuWLZIpA5pDXEDizg3WJ/E4xujDLcUowT4+GDEOfZ9+AA0b1YMzCv0voiQly6qgNG2yriEo=
X-Received: by 2002:a2e:7f02:: with SMTP id a2mr590399ljd.138.1592429434462;
 Wed, 17 Jun 2020 14:30:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200617165616.52241bde@oasis.local.home>
In-Reply-To: <20200617165616.52241bde@oasis.local.home>
From: Jann Horn <jannh@google.com>
Date: Wed, 17 Jun 2020 23:30:07 +0200
Message-ID: <CAG48ez2pOns4vF9M_4ubMJ+p9YFY29udMaH0wm8UuCwGQ4ZZAQ@mail.gmail.com>
Subject: Re: [PATCH] tracing: Use linker magic instead of recasting ftrace_ops_list_func()
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, 
	Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Oscar Carter <oscar.carter@gmx.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jun 17, 2020 at 10:56 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> In an effort to enable -Wcast-function-type in the top-level Makefile to
> support Control Flow Integrity builds, all function casts need to be
> removed.
>
> This means that ftrace_ops_list_func() can no longer be defined as
> ftrace_ops_no_ops(). The reason for ftrace_ops_no_ops() is to use that when
> an architecture calls ftrace_ops_list_func() with only two parameters
> (called from assembly). And to make sure there's no C side-effects, those
> archs call ftrace_ops_no_ops() which only has two parameters, as
> ftrace_ops_list_func() has four parameters.
>
> Instead of a typecast, use vmlinux.lds.h to define ftrace_ops_list_func() to
> arch_ftrace_ops_list_func() that will define the proper set of parameters.
>
> Link: https://lore.kernel.org/r/20200614070154.6039-1-oscar.carter@gmx.com
[...]
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
[...]
> +                       ftrace_ops_list_func = arch_ftrace_ops_list_func;
>  #else
>  # ifdef CONFIG_FUNCTION_TRACER
>  #  define MCOUNT_REC() ftrace_stub_graph = ftrace_stub;
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
[...]
> +/* Defined by vmlinux.lds.h see the commment above arch_ftrace_ops_list_func for details */
> +void ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
> +                         struct ftrace_ops *op, struct pt_regs *regs);
[...]
> +void arch_ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
>  {

Well, it's not like the function cast itself is the part that's
problematic for CFI; the problematic part is when you actually make a
C function call (in particular an indirect one) where the destination
is compiled with a prototype that is different from the prototype used
at the call site. Doing this linker hackery isn't really any better
than shutting up the compiler warning by piling on enough casts or
whatever. (There should be some combination of casts that'll shut up
this warning, right?)

IIUC the real issue here is that ftrace_func_t is defined as a fixed
type, but actually has different types depending on the architecture?
If so, it might be cleaner to define ftrace_func_t differently
depending on architecture, or something like that?

And if that's not feasible, I think it would be better to at least
replace this linker trickery with straightforward
shut-up-the-compiler-casts - it'd be much easier to understand what's
actually going on that way.
