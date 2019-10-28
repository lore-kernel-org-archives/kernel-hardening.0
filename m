Return-Path: <SRS0=a97Y=YV=lists.openwall.com=kernel-hardening-return-17135-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB6C8CA9EC0
	for <kernel-hardening@archiver.kernel.org>; Mon, 28 Oct 2019 15:20:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 404D421721
	for <kernel-hardening@archiver.kernel.org>; Mon, 28 Oct 2019 15:20:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eSmzhzPZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 404D421721
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17135-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15972 invoked by uid 550); 28 Oct 2019 15:20:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15951 invoked from network); 28 Oct 2019 15:20:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZU5xUNm1kaCHgnGkxHeR/Mx1+L5fbEGEQysvhMTguc4=;
        b=eSmzhzPZfT7cUe+QHJCBCLOHsdk+EZDEV9fLq/VonLuESD+7AlLYYPrnI17uBv2SBg
         3TD4dUHaoFk8FpSe0MeKqGFrA0VaN0FxWa+wsTCO0XEBDSOfCQvENAl6OX1Rb3jrp+n3
         JPkuxbGtWe1J+gHHSaQORWLI7cXq3klsPNWOMsgNXu6Fg8nKxysP4iyA0VydqPQgY0JL
         N7EJLUpZITruMx0JSqETf+bX1nMYrqvrsSGAmoFxsqJMadIf4Q/uhe6KZosWwtiY9rRW
         8EGaI4kC5ExBIAoyg7rWysQrcycy0XTYf6yCBvrKZ1/2CBM7WNaipneRGQ1wmCRv9UKA
         damA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZU5xUNm1kaCHgnGkxHeR/Mx1+L5fbEGEQysvhMTguc4=;
        b=ZbAKrXjajb1UbdWFxXctqbFZiswNWWYo1XdGzM+4mOLpSbTDDuuMura2dY/URcD97e
         3y6RgARuYXkCdFKWdHuTc+fXynR8Dz5YoiE9DAgy8iX+DkruIyjqqoJfTkHkI0kP+lwj
         Kat7JMawHj889GXvZp5/bUqBcd8oRSjPVDItUHccz33HLffZ04LR7p4s55M7/+vA/Q0w
         /vxksvAKY+XKlXzxH2i6UP99Ae5m+x0GV9J4ZizrJ+OSqWIhSaDTdBgNd3feluNDzo16
         zUWgU0MPEpLdEE77NK+2x1oZ6o290cpIg/gDWG8ome0yy9M0LCMCYn62DtR11bkPBobm
         Za4A==
X-Gm-Message-State: APjAAAX1OnimiwaoSrZEe4jnF0a6NdPilY5iLNnNMNcK39cOkmopVms+
	k8V5JdKbU430AVuQryRLaHJgkGo6uFMtJAD1gTQm0g==
X-Google-Smtp-Source: APXvYqzRltIrku2LXVeEFCHJc2YFi4Md1SIaeyW4mfj+XUvo+qC8pGuc9cXtasR/G76UI8ICFDNLc3Y6k3eXZlTO+J8=
X-Received: by 2002:a67:ed8b:: with SMTP id d11mr8849195vsp.104.1572276001000;
 Mon, 28 Oct 2019 08:20:01 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191024225132.13410-1-samitolvanen@google.com> <20191024225132.13410-6-samitolvanen@google.com>
 <2c13c39acb55df5dbb0d40c806bb1d7dc4bde2ae.camel@perches.com>
In-Reply-To: <2c13c39acb55df5dbb0d40c806bb1d7dc4bde2ae.camel@perches.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 28 Oct 2019 08:19:49 -0700
Message-ID: <CABCJKucUR=reCaOh_n8XGSZixmsckNtFXoaq_NOdB+iw-5UxMA@mail.gmail.com>
Subject: Re: [PATCH v2 05/17] add support for Clang's Shadow Call Stack (SCS)
To: Joe Perches <joe@perches.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Jann Horn <jannh@google.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Joe,

On Sat, Oct 26, 2019 at 8:57 AM Joe Perches <joe@perches.com> wrote:
> > +#if __has_feature(shadow_call_stack)
> > +# define __noscs     __attribute__((no_sanitize("shadow-call-stack")))
>
> __no_sanitize__

Sorry, I missed your earlier message about this. I'm following Clang's
documentation for the attribute:

https://clang.llvm.org/docs/ShadowCallStack.html#attribute-no-sanitize-shadow-call-stack

Although __no_sanitize__ seems to work too. Is there a particular
reason to prefer that form over the one in the documentation?

Sami
