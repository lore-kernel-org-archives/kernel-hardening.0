Return-Path: <SRS0=9wdC=Y7=lists.openwall.com=kernel-hardening-return-17323-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56ED1C5DF61
	for <kernel-hardening@archiver.kernel.org>; Thu,  7 Nov 2019 10:52:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9B482214D8
	for <kernel-hardening@archiver.kernel.org>; Thu,  7 Nov 2019 10:52:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HKwEOayk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B482214D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17323-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29906 invoked by uid 550); 7 Nov 2019 10:52:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29884 invoked from network); 7 Nov 2019 10:52:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OvMY+y9t+JrwQeXlyarqTJXF9VkquzjWewr7iQbYsdg=;
        b=HKwEOaykRl1GaA5HUx+9TcTEGGb7oNvHt2Y9owJSyCUoyem7fwAkvwQBHkQI2FPvWP
         uD0rulX0IgiMsrRSKmb0gtmwI0JV854FA+6gSUC796H6UFIZXFzBZJ2xOUivRHTVQ7hz
         7wCtkr90dGCFRE9MIxHYuABRTVM2CaXJ2g8zZntLAHf9IB+LEKPFIzPuvH4ZT93oEQRw
         CkmsEypotk24LHmyt9u5PQ+ufkPLAAuWaKVGxSQQlNXe6maf3XOUhitNWnifjM/Y/KdZ
         9bZxWAB3xnwJN98FAhenJ2RmIObgbkD+CCxooE1AqOAT7pNw5Zsa/8pH6e9bXw4Thfeb
         Hl0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OvMY+y9t+JrwQeXlyarqTJXF9VkquzjWewr7iQbYsdg=;
        b=NMSGqON5gDjo6OsvVSKqe1NTSCS/WD9D/fPCEbYdmg4YtoHnatreezxvwuTHpTg3TC
         8ToakNtpmXgI6X3Bndu3Yd3N9c05KSZzjQDjjwj9zJRq4F4e5jm9ErALjhKivF0nHwrI
         01kSaz9xb3cOhfF2U+3u53v8K5xMJiGwiW3nt6m1kuoOFsvmfiWA2SVWIEDaEQ0aAD14
         Kz6NSTGe8dwVZImUGrn/njgfS+v+n3Nl7BWFrcs1Se40cxsS5UvGBomMvS24vOrUk/om
         Ssav5YpJd9p5JsGSEdJPxvEyM0qVn13rD0qZ+vOY+lKNs2G0ZFNodQrrNm8y1lu8lCy/
         ACpA==
X-Gm-Message-State: APjAAAU+7LXdQpE5Bt8TOTKOykGlb64cUYnTc8JPrf0icRmlJ2r20CTN
	QjTcWd/OCn6SFVpbirG3RfNTZne/BwQEmbVtxKV7Uw==
X-Google-Smtp-Source: APXvYqxZvEiiT90pDsnYPJdaxTdcxJka6vY+KKCUJ0OKpqIG88pZzG10bA4lVqLf/rqLW8X5UhbBGNpzEr6t7euuMFw=
X-Received: by 2002:a1c:b1c3:: with SMTP id a186mr2297717wmf.10.1573123909498;
 Thu, 07 Nov 2019 02:51:49 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191105235608.107702-1-samitolvanen@google.com> <20191105235608.107702-12-samitolvanen@google.com>
 <CANiq72mZC-G_R_RJjapZS+NvkQcrjdiri0NyHUgesFzUpe-MDg@mail.gmail.com>
In-Reply-To: <CANiq72mZC-G_R_RJjapZS+NvkQcrjdiri0NyHUgesFzUpe-MDg@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu, 7 Nov 2019 11:51:38 +0100
Message-ID: <CAKv+Gu9DD12BPV_jNv9Hjw4oSiZvtdiVVjB-B8WLXCoPL4CA9Q@mail.gmail.com>
Subject: Re: [PATCH v5 11/14] arm64: efi: restore x18 if it was corrupted
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 6 Nov 2019 at 05:46, Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Wed, Nov 6, 2019 at 12:56 AM Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > If we detect a corrupted x18 and SCS is enabled, restore the register
> > before jumping back to instrumented code. This is safe, because the
> > wrapper is called with preemption disabled and a separate shadow stack
> > is used for interrupt handling.
>
> In case you do v6: I think putting the explanation about why this is
> safe in the existing comment would be best given it is justifying a
> subtlety of the code rather than the change itself. Ard?
>

Agreed, but only if you have to respin for other reasons.
