Return-Path: <SRS0=klF/=ZH=lists.openwall.com=kernel-hardening-return-17392-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 827BCC432C3
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 Nov 2019 18:34:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C4C592073B
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 Nov 2019 18:34:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DPVoi3lq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4C592073B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17392-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30308 invoked by uid 550); 15 Nov 2019 18:34:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30288 invoked from network); 15 Nov 2019 18:34:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z/RQj5FqYPBFFb/BHpJq3oq0/JIX3F5mcr3Ic1KDLoA=;
        b=DPVoi3lqXCZqeWh9romeMaws5hqXk7f+VlyR9XfhSR/9BdSIhcYmEux7SQ5St6jgAv
         Qy7JHhLn5W/E49pgWgOuvApN0oQk7kKUVdvzqM0GYzY6xGnHrcu3/C3H75y46ixSvuca
         LjPAO51k95incrTQsuJOy8ZRL6zlZ92V+cSt7WAY8zd/QGfPmISheb/46Q0qXikywE7H
         4Xh/pOiL99Mk+H/Q9TdrDS1OLq9XHIwJxh3HXyW7oVjDzKgHZwFJFMojZFKSuD9lUD8s
         TsrwyDeDC5tuRiLuIUH3CjrVYpkyH7ytqD6EnefisDfsVDoa6xNUGa6ZrfAwBeh0RQqM
         vZrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z/RQj5FqYPBFFb/BHpJq3oq0/JIX3F5mcr3Ic1KDLoA=;
        b=bsfUuMHs1xjYh153MvyaL049R9p39nHsA954ctnVQLHHOdgJoXA6f+wFHxo+oDOepx
         e/Gg5fNHTTiKuvNnuFKaN0APDXotGBFhXj6q+2GgJkaVYkkdmPtPNquJm8+6DadQJJKm
         RrnqT15kAvmc66G1rsTIJXlQDGPewnmI15+juJ4IeO8a6Mr5D5IO15RaaL0p1VxkkCKV
         PxLRjQir+q1VAXujXctHPdx/DvHAtM25B1YRMPuf7u2VepPQj2nrANqEokDhFpqVsEw/
         1+KtY8UsAhERBkO6Izbsoy2gthTrseYxxZjiMRyf1TiYUv86U0iXUrpvV8iLQ7sN6urx
         uhHg==
X-Gm-Message-State: APjAAAWQ7S4LD2lk6HDlD2xUCNKuVito7ns9blQ+FemHuXi31hkRJajT
	pHXIjhJi9cXVzZ213nMeukW1SbjlPluBXkCFmT5+VA==
X-Google-Smtp-Source: APXvYqy9ZihhNwSz15zAc2n9wuqx0KKCFEmVQyQmPiar9gQiv4PEvu699gEh+PcCmRyXpyUO7fCyzGA8P+JoII/zuY4=
X-Received: by 2002:a67:e951:: with SMTP id p17mr5243152vso.112.1573842878866;
 Fri, 15 Nov 2019 10:34:38 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191105235608.107702-1-samitolvanen@google.com> <20191105235608.107702-6-samitolvanen@google.com>
 <20191115153705.GJ41572@lakrids.cambridge.arm.com>
In-Reply-To: <20191115153705.GJ41572@lakrids.cambridge.arm.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 15 Nov 2019 10:34:25 -0800
Message-ID: <CABCJKucsJxXJ6tBYSify-2FS-P1rC=vEKTo+HdhN2e0K9fcBow@mail.gmail.com>
Subject: Re: [PATCH v5 05/14] add support for Clang's Shadow Call Stack (SCS)
To: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Nov 15, 2019 at 7:37 AM Mark Rutland <mark.rutland@arm.com> wrote:
> > +config SHADOW_CALL_STACK_VMAP
> > +     bool
> > +     depends on SHADOW_CALL_STACK
> > +     help
> > +       Use virtually mapped shadow call stacks. Selecting this option
> > +       provides better stack exhaustion protection, but increases per-thread
> > +       memory consumption as a full page is allocated for each shadow stack.
>
> The bool needs some display text to make it selectable.
>
> This should probably be below SHADOW_CALL_STACK so that when it shows up
> in menuconfig it's where you'd expect it to be.
>
> I locally hacked that in, but when building defconfig +
> SHADOW_CALL_STACK + SHADOW_CALL_STACK_VMAP, the build explodes as below:

Ugh, thanks for pointing this out. I'll fix this in v6.

Sami
