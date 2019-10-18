Return-Path: <SRS0=971l=YL=lists.openwall.com=kernel-hardening-return-17058-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01920CA9EA0
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 20:34:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4BC6921925
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 20:33:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KQhoMvQg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4BC6921925
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17058-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26374 invoked by uid 550); 18 Oct 2019 20:33:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26356 invoked from network); 18 Oct 2019 20:33:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s5h/GhSdlUicoMowUqjyBoWS/+duNMzdyCGodDdcTtc=;
        b=KQhoMvQgSY1S7JFuJAFTC9HRZeQ5mdpO9TvuIKoj0v5SvnSQNuvf8amINPFUPzI8nY
         7ZIM6uhg5mZL7guVvq0mSjr6gr+NtNERf4pjkYKL/atuXVKYh6ehfKZIXGRfpXFMwBUC
         ThYtEebG3W5YCny4jaBcl/Q0epyHh1RHZdFHsBm9kE9ybU6tBqxynDXHqthx+xaibjMa
         95n/a/SX8ULgLGxFbhmjkRP3CjI5ClIpGsJpW9IT2pdvvEpsvlxPiNChvpjefs0l29Vq
         fQGmX4cDpEBIZ/Jt5jFZrqKpbzygKQM8pdWXq7Ks30lBud8WR8HSBUqDptTm7GHM8fiq
         R4uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s5h/GhSdlUicoMowUqjyBoWS/+duNMzdyCGodDdcTtc=;
        b=EC3jjvcLnJQmfpPhiy7bcwCu4UqtB24vv6veC5wtaaLlrKiEVCyEzLSeJF4YTLI/ph
         j+8tWETqqGvAsn0nLGIcdylXX8UzKte+aXxSdhzh0vvbSUXbsILlp0oaTtr1krhZEQ7S
         ntglIB14eo2+6i8nsGefgQDIq2jdtuyv1joTBMowRNNkjwVzrGBYQLNFVkDND6sQ92W0
         l22JrqGn0x2MgjOMlb+PchKMEBTSlx0Cyglz3wYyHpHF7bS2jtJYncg1TwOlc0it1UNO
         TW9JXdi14HeDllfZL5/o4QJrsuMiECLu1DaLxSkQpwN3DOgORP4tVv1vfzCvQL1L0K40
         jmUQ==
X-Gm-Message-State: APjAAAXDYrlfq/44c14RznmFWkpWH+gVKYEHNdTWJ+EF8VDXuTt2RAUm
	SHXDSDjQcOX+f+wLotl7Q+WJ4flQ9u3QI6MwgNQZEQ==
X-Google-Smtp-Source: APXvYqyNa4FKOObSpxuU4QFrkn4kv2RtplqwVoFiBNyGX9dC4x3R93/WFE745QDJwjnJLdnYdKd+pE8O7U/JRiSJhZU=
X-Received: by 2002:a17:902:9b83:: with SMTP id y3mr11637082plp.179.1571430819228;
 Fri, 18 Oct 2019 13:33:39 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-7-samitolvanen@google.com> <CAKwvOd=z3RxvJeNV1sBE=Y1b6HgXdnT4M9bwMrUNZcvcSOqwTw@mail.gmail.com>
 <CABCJKud6+F=yhTo6xTXkHhtLWcSE99K=NcfKW_5E4swS4seKMw@mail.gmail.com> <CANiq72=PSzufQkW+2fikdDfZ5ZR1sw2epvxv--mytWZkTZQ9sg@mail.gmail.com>
In-Reply-To: <CANiq72=PSzufQkW+2fikdDfZ5ZR1sw2epvxv--mytWZkTZQ9sg@mail.gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Fri, 18 Oct 2019 13:33:27 -0700
Message-ID: <CAKwvOdkqfbXVQ8dwoT5RVza6bZw3cBQUEGcuRHu0-LhObkg--w@mail.gmail.com>
Subject: Re: [PATCH 06/18] add support for Clang's Shadow Call Stack (SCS)
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 18, 2019 at 11:33 AM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Fri, Oct 18, 2019 at 7:11 PM Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > On Fri, Oct 18, 2019 at 10:08 AM 'Nick Desaulniers' via Clang Built
> > Linux <clang-built-linux@googlegroups.com> wrote:
> > > > diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
> > > > index 333a6695a918..9af08391f205 100644
> > > > --- a/include/linux/compiler-clang.h
> > > > +++ b/include/linux/compiler-clang.h
> > > > @@ -42,3 +42,5 @@
> > > >   * compilers, like ICC.
> > > >   */
> > > >  #define barrier() __asm__ __volatile__("" : : : "memory")
> > > > +
> > > > +#define __noscs                __attribute__((no_sanitize("shadow-call-stack")))
> > >
> > > It looks like this attribute, (and thus a requirement to use this
> > > feature), didn't exist until Clang 7.0: https://godbolt.org/z/p9u1we
> > > (as noted above)
> > >
> > > I think it's better to put __noscs behind a __has_attribute guard in
> > > include/linux/compiler_attributes.h.  Otherwise, what will happen when
> > > Clang 6.0 sees __noscs, for example? (-Wunknown-sanitizers will
> > > happen).
> >
> > Good point, I'll fix this in v2. Thanks.
>
> +1, please CC whenever you send it!

Sami pointed out to me off thread that __has_attribute would only
check `no_sanitize`, not `shadow-call-stack`.  So maybe best to keep
the definition here (include/linux/compiler-clang.h), but wrapped in a
`__has_feature` check so that Clang 6.0 doesn't start complaining.
-- 
Thanks,
~Nick Desaulniers
