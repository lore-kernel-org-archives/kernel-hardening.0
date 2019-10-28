Return-Path: <SRS0=GCx3=YV=lists.openwall.com=kernel-hardening-return-17136-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62B63CA9EC0
	for <kernel-hardening@archiver.kernel.org>; Mon, 28 Oct 2019 15:31:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7BB7F218AC
	for <kernel-hardening@archiver.kernel.org>; Mon, 28 Oct 2019 15:31:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kb+fNmOy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BB7F218AC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17136-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21933 invoked by uid 550); 28 Oct 2019 15:31:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21912 invoked from network); 28 Oct 2019 15:31:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UJd/INtZ62ePu3Mr9spOryjxzJY7mlwm/OzzNOTYmY0=;
        b=Kb+fNmOyNixOiV0wlp2K5iyKOJVGUEX5vHhyFl6/1wlvdXz+AXSaMTJ0r0flh01Fz+
         GYXTdZPMQkG3l0bZHIzJ8bnnM7azmxOnsLRK9Cit4ZwDvPORUeusZzZ299mOyaiRdvIs
         PlbCcpM29OCPfLfCLYwRtv80FCHfptd9CYeTs/rZsaWivGV8kO9Z0oqUA89YKeltXlbP
         k9vFd38AlVC1GVowhHhxTBClETelLUk+3gDfaZZJANRbJ3DHm82EyLkIR0giUaGFabHu
         N6gFGboIyb/J+MykQxy+SG8ZjPxKT1iid87w3tw4BgtDKDVrGFQJD4+Vl4wD+0sQPyZd
         gLKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UJd/INtZ62ePu3Mr9spOryjxzJY7mlwm/OzzNOTYmY0=;
        b=VqCGhQnxJcNV2DSOGrKCs4f3kxEiyis1eEty9kYfKFjiN0ODpBAjyT3XIlxUSscAIH
         5SD3Fs1Pztd1Z/0kl9Qm2VktF7nCc1BLvGfaTxSBxHZD7/ao2mwF4sDuSnNapUydU9yx
         stIStR4JdTsuInVzjK3jwSqF8qy9Ao3a7Xk/U/0OCPQOCA0iPYfpliEzaRASSWl03jHd
         MHEIvcm9D2dZsSVoJMDJGdmIDMsgA940xeuvK0W/lfUVn53bXi5OgoTgRmFCWSzCutSN
         j6930lmiMHwiKTFJcwxv1mwXi9BhAot+sShgwXkFqybOQjaKdVdR3SNCof4d4oXmV41I
         drtw==
X-Gm-Message-State: APjAAAXAnYlS1+T/ZhbrPW++pkT06XhnxP3ohSyh3atSm1yA50OcViNi
	dG+d5y4hr+S8ZyHPm5GA/QSHd/UAfJ8Xn+MTEO0=
X-Google-Smtp-Source: APXvYqx/vjP3sX8fKAQbnnmHcly/74xUpqNj3IlvrKsR6VGTLr9o1eevGuzKwVdrTXrgtyec+3Q/dIDwuhDOOL27/rw=
X-Received: by 2002:ac2:55b4:: with SMTP id y20mr11775734lfg.173.1572276676498;
 Mon, 28 Oct 2019 08:31:16 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191024225132.13410-1-samitolvanen@google.com> <20191024225132.13410-6-samitolvanen@google.com>
 <2c13c39acb55df5dbb0d40c806bb1d7dc4bde2ae.camel@perches.com> <CABCJKucUR=reCaOh_n8XGSZixmsckNtFXoaq_NOdB+iw-5UxMA@mail.gmail.com>
In-Reply-To: <CABCJKucUR=reCaOh_n8XGSZixmsckNtFXoaq_NOdB+iw-5UxMA@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 28 Oct 2019 16:31:05 +0100
Message-ID: <CANiq72n4o16TB53s6nLLrLCw6v0Brn8GAhKvdzzN7v1tNontCQ@mail.gmail.com>
Subject: Re: [PATCH v2 05/17] add support for Clang's Shadow Call Stack (SCS)
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Dave Martin <Dave.Martin@arm.com>, Jann Horn <jannh@google.com>, Joe Perches <joe@perches.com>, 
	Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>, clang-built-linux <clang-built-linux@googlegroups.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: multipart/alternative; boundary="000000000000ca982d0595fa30e4"

--000000000000ca982d0595fa30e4
Content-Type: text/plain; charset="UTF-8"

Hi Sami,

On Mon, 28 Oct 2019 at 16:20 Sami Tolvanen <samitolvanen@google.com> wrote:

> Hi Joe,
>
> On Sat, Oct 26, 2019 at 8:57 AM Joe Perches <joe@perches.com> wrote:
> > > +#if __has_feature(shadow_call_stack)
> > > +# define __noscs     __attribute__((no_sanitize("shadow-call-stack")))
> >
> > __no_sanitize__
>
> Sorry, I missed your earlier message about this. I'm following Clang's
> documentation for the attribute:
>
>
> https://clang.llvm.org/docs/ShadowCallStack.html#attribute-no-sanitize-shadow-call-stack
>
> Although __no_sanitize__ seems to work too. Is there a particular
> reason to prefer that form over the one in the documentation?


We decided to do it like that when I introduced compiler_attributes.h.

Given it is hidden behind a definition, we don't care about which one we
use internally; therefore the idea was to avoid clashes as much as possible
with other names/definitions/etc.

The syntax is supported in the compilers we care about (for docs on
attributes, the best reference is GCC's by the way).

Cheers,
Miguel


-- 
Cheers,
Miguel

--000000000000ca982d0595fa30e4
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Hi Sami,</div><div dir=3D"auto"><br></div><div>On Mon, 28=
 Oct 2019 at 16:20 Sami Tolvanen &lt;<a href=3D"mailto:samitolvanen@google.=
com">samitolvanen@google.com</a>&gt; wrote:<br></div><div><div class=3D"gma=
il_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bord=
er-left:1px #ccc solid;padding-left:1ex">Hi Joe,<br>
<br>
On Sat, Oct 26, 2019 at 8:57 AM Joe Perches &lt;<a href=3D"mailto:joe@perch=
es.com" target=3D"_blank">joe@perches.com</a>&gt; wrote:<br>
&gt; &gt; +#if __has_feature(shadow_call_stack)<br>
&gt; &gt; +# define __noscs=C2=A0 =C2=A0 =C2=A0__attribute__((no_sanitize(&=
quot;shadow-call-stack&quot;)))<br>
&gt;<br>
&gt; __no_sanitize__<br>
<br>
Sorry, I missed your earlier message about this. I&#39;m following Clang&#3=
9;s<br>
documentation for the attribute:<br>
<br>
<a href=3D"https://clang.llvm.org/docs/ShadowCallStack.html#attribute-no-sa=
nitize-shadow-call-stack" rel=3D"noreferrer" target=3D"_blank">https://clan=
g.llvm.org/docs/ShadowCallStack.html#attribute-no-sanitize-shadow-call-stac=
k</a><br>
<br>
Although __no_sanitize__ seems to work too. Is there a particular<br>
reason to prefer that form over the one in the documentation?</blockquote><=
div dir=3D"auto"><br></div><div dir=3D"auto">We decided to do it like that =
when I introduced compiler_attributes.h.</div><div dir=3D"auto"><br></div><=
div dir=3D"auto">Given it is hidden behind a definition, we don&#39;t care =
about which one we use internally; therefore the idea was to avoid clashes =
as much as possible with other names/definitions/etc.</div><div dir=3D"auto=
"><br></div><div dir=3D"auto">The syntax is supported in the compilers we c=
are about (for docs on attributes, the best reference is GCC&#39;s by the w=
ay).</div><div dir=3D"auto"><br></div><div dir=3D"auto">Cheers,</div><div d=
ir=3D"auto">Miguel</div><div dir=3D"auto"><br></div><div dir=3D"auto"><br><=
/div></div></div>-- <br><div dir=3D"ltr" class=3D"gmail_signature" data-sma=
rtmail=3D"gmail_signature">Cheers,<br>Miguel</div>

--000000000000ca982d0595fa30e4--
