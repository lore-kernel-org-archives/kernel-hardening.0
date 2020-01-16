Return-Path: <SRS0=44zS=3F=lists.openwall.com=kernel-hardening-return-17581-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62922C33CAF
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jan 2020 21:45:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AA0582072B
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jan 2020 21:45:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tYITaZrs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA0582072B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17581-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13540 invoked by uid 550); 16 Jan 2020 21:45:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13520 invoked from network); 16 Jan 2020 21:45:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tkSAt1Pw50rKdG/hn5morljVtZomrkNl/2z5xne6PRw=;
        b=tYITaZrsivqfC+GdC03l8Z8h3bZpMk/AxRJZ5m3Cq3lP1GhjDNlzuzFHH0Pn2+w9Bp
         7hq+CoXS8VEDdhnMjKVZPNodzvjOUAaKuYJ/ddFf8vOlsJnqSle+AlNiaLEcRnwKSGTP
         5gI69wlRAJP+9qKZcEhtfjYhon9km/BJzdEnZr70+1XtamA4m5kF7Ynuucv4V82zyCFO
         H2TlLCrfyCjDGPgKEI6sEsRnApccctQO8D2j+8EC7xolfZWg7J4pQivRrN9lRA6P8BUk
         bMbwCjGUJxwYv2NA596Hgs8T4QOpc3vlL/TpIEXN+OH+nuTnqjTX9Bzg6hCJI8tqaUMO
         EkDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tkSAt1Pw50rKdG/hn5morljVtZomrkNl/2z5xne6PRw=;
        b=cWYTIUE3FXKVt9E1UhsIUDjsv4EziUagsGpJx20VgSHVLGwqQ5x56XNFNXgA7EV5ph
         sbmHZCYbbvDsE9iSc/TGkhZ2AcnLlHIpFs4gMSDUgXGhWhlDf9lIpB2ow3cdoWWxASKE
         pNRDGZsbSUjScge+2pEVBl/17AretNOgxJETApA6OT1mimET8kHqqpWqQse1tK5RQuYZ
         kJBxIkgl8ABhkQlNs5ek1c91Vda0ooVqLQndJ7BFEoeeMOmCajmeWKMP5n/wI3vWcvc1
         VNQB2ah8ZMvScZrLReYsRjXZIvOB5uTheI6W4PFv7iwurzlebibQBzELoZuPecc5ymRL
         VQcw==
X-Gm-Message-State: APjAAAXknoux8uGfMl8CufEWtPxBgf+P+HqmTpTFgLS7gYeraQqru4FO
	+43etvEoYw79FMelE3yXhB+BEBxkTh/iZ1wAYSAqeQ==
X-Google-Smtp-Source: APXvYqx9xgh+f+ErpWs3BksSZ71jt7xPPMU4gWghLYUHcYc41EpoUSU/qL8aa7KJUXqJ40wX1Da/EhNZbQRobWoILhU=
X-Received: by 2002:ab0:618a:: with SMTP id h10mr19510791uan.53.1579211120670;
 Thu, 16 Jan 2020 13:45:20 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191206221351.38241-1-samitolvanen@google.com> <20191206221351.38241-9-samitolvanen@google.com>
 <20200116173950.GB21396@willie-the-truck>
In-Reply-To: <20200116173950.GB21396@willie-the-truck>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Thu, 16 Jan 2020 13:45:09 -0800
Message-ID: <CABCJKuduRyBBr1qZQj35nMCOLv3my22wRQXb4-i39n07qdL4Yg@mail.gmail.com>
Subject: Re: [PATCH v6 08/15] arm64: disable function graph tracing with SCS
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Mark Rutland <mark.rutland@arm.com>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 16, 2020 at 9:39 AM Will Deacon <will@kernel.org> wrote:
>
> On Fri, Dec 06, 2019 at 02:13:44PM -0800, Sami Tolvanen wrote:
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index b1b4476ddb83..49e5f94ff4af 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -149,7 +149,7 @@ config ARM64
> >       select HAVE_FTRACE_MCOUNT_RECORD
> >       select HAVE_FUNCTION_TRACER
> >       select HAVE_FUNCTION_ERROR_INJECTION
> > -     select HAVE_FUNCTION_GRAPH_TRACER
> > +     select HAVE_FUNCTION_GRAPH_TRACER if !SHADOW_CALL_STACK
> >       select HAVE_GCC_PLUGINS
> >       select HAVE_HW_BREAKPOINT if PERF_EVENTS
> >       select HAVE_IRQ_TIME_ACCOUNTING
>
> I think this is the wrong way around, as we support the graph tracer
> today and so I think SHADOW_CALL_STACK should depend on !GRAPH_TRACER
> and possibly even EXPERT until this is resolved.

Sure, sounds reasonable. I'll change this in the next version.

Sami
