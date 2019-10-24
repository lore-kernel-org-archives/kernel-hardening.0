Return-Path: <SRS0=gbxL=YR=lists.openwall.com=kernel-hardening-return-17097-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2B5CA9EBB
	for <kernel-hardening@archiver.kernel.org>; Thu, 24 Oct 2019 01:48:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 934CD20650
	for <kernel-hardening@archiver.kernel.org>; Thu, 24 Oct 2019 01:48:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="ofNboEQU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 934CD20650
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=socionext.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17097-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3426 invoked by uid 550); 24 Oct 2019 01:48:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3405 invoked from network); 24 Oct 2019 01:48:29 -0000
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com x9O1m3ZL016515
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1571881684;
	bh=Pg0PBlnvPGzMa1Lyb7SgzTssmkI1SxEtJ6FEB1T4F30=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ofNboEQUqp9lsgicKTvUAhaI7rxygS4zx6c0oGCexmwGMPEnMQ2X2tFyof+S6L0J6
	 v0OmQrC6FYcrzKSBR3CwB375LfzIrrpjUdons4tKy3jNeXm/SD874D9IsRl4EWrzNp
	 AjNjFCpTMcSsJCfcmcotwgHuxmfSEPWVX5uHhVjI3yoONOKjO0dL6pnEoKFQdXWHLL
	 vpvhZaeulMcrd9JVnoaJWAOwCMbJzvw7ZD38JJ4c0m6AOkpSah3shwoWHWn0wGLBTf
	 X7yYyHqp8S9OjAFYIPhc3QrG0AUr7iQoh/FqYciJRtC/TCAFmaJckK+MB/dxA7Z62/
	 xXXczs18i3CRA==
X-Nifty-SrcIP: [209.85.222.53]
X-Gm-Message-State: APjAAAX2rLq8ds+SpBMLL9sW82v75Ob19bbfc9vc3AbYsFXvJ0ND0g2S
	fI4vV3WNRWXbGS/x1cT/EfwMkAm8XMdu26pno1c=
X-Google-Smtp-Source: APXvYqx1CqHmDEr3VPRqLGPoMM6fTlsUos2Z4E1CXGQPNl+XNURVhKBiM/jscveAYlAHmW9WHc6ytxEH92P8yvA+VtU=
X-Received: by 2002:a9f:3e81:: with SMTP id x1mr7475449uai.121.1571881682588;
 Wed, 23 Oct 2019 18:48:02 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-7-samitolvanen@google.com> <20191022162826.GC699@lakrids.cambridge.arm.com>
 <CABCJKudsD6jghk4i8Tp4aJg0d7skt6sU=gQ3JXqW8sjkUuX7vA@mail.gmail.com>
In-Reply-To: <CABCJKudsD6jghk4i8Tp4aJg0d7skt6sU=gQ3JXqW8sjkUuX7vA@mail.gmail.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Thu, 24 Oct 2019 10:47:26 +0900
X-Gmail-Original-Message-ID: <CAK7LNATrz4fTp1RWHfwq36M4Xs1CdkoZtnoYfZ4ouNKow5F0RQ@mail.gmail.com>
Message-ID: <CAK7LNATrz4fTp1RWHfwq36M4Xs1CdkoZtnoYfZ4ouNKow5F0RQ@mail.gmail.com>
Subject: Re: [PATCH 06/18] add support for Clang's Shadow Call Stack (SCS)
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>,
        Laura Abbott <labbott@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 24, 2019 at 1:59 AM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> On Tue, Oct 22, 2019 at 9:28 AM Mark Rutland <mark.rutland@arm.com> wrote:
> > I think it would be preferable to follow the example of CC_FLAGS_FTRACE
> > so that this can be filtered out, e.g.
> >
> > ifdef CONFIG_SHADOW_CALL_STACK
> > CFLAGS_SCS := -fsanitize=shadow-call-stack
> > KBUILD_CFLAGS += $(CFLAGS_SCS)
> > export CC_FLAGS_SCS
> > endif
> >
> > ... with removal being:
> >
> > CFLAGS_REMOVE := $(CC_FLAGS_SCS)
> >
> > ... or:
> >
> > CFLAGS_REMOVE_obj.o := $(CC_FLAGS_SCS)
> >
> > That way you only need to define the flags once, so the enable and
> > disable falgs remain in sync by construction.
>
> CFLAGS_REMOVE appears to be only implemented for objects, which means
> there's no convenient way to filter out flags for everything in
> arch/arm64/kvm/hyp, for example. I could add a CFLAGS_REMOVE
> separately for each object file, or we could add something like
> ccflags-remove-y to complement ccflags-y, which should be relatively
> simple. Masahiro, do you have any suggestions?


I am fine with 'ccflags-remove-y'.

Thanks.


-- 
Best Regards
Masahiro Yamada
