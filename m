Return-Path: <SRS0=+41F=YL=lists.openwall.com=kernel-hardening-return-17056-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1647FCA9EA9
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 18:33:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 62AE220869
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 18:33:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O7PltKw1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62AE220869
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17056-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30656 invoked by uid 550); 18 Oct 2019 18:33:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30629 invoked from network); 18 Oct 2019 18:33:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GbeDXmo9y5jCjWaekiMahqEUs5l1VadqHf+/T7BBGBs=;
        b=O7PltKw1VMi2RMM6PRtWFNe7pkAjXUVERibQ18qTBqg7hBcss0b4ODK8OPurRIOyua
         XPNO9lzWQL2sUCEhn5yIUWxen7VKw9wyTrwnHMKPZjCRfIiXPFfWEAVvv4QRuiFlh5t+
         pDRldcEsIeZnSgRVmFGygqa8PjlBtiqr3OTvL/LcpFDouIoV77L0apIZSU2+TZrDMUpN
         J+BIMIzJe4Gnl2MdVigjlwfITa9bcZsVYbInVJd7VmqoxFJ+R1oQWwmYYSQ+CRxNdp2b
         XI5aTFXOgs9ze9UHzbxQYe24jao6bo43OiCrhgGontQOfGlZavqZSXXnyWO9GEdwqm9A
         B7LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GbeDXmo9y5jCjWaekiMahqEUs5l1VadqHf+/T7BBGBs=;
        b=bWKZFnLmnoOl0Gj1Tqtbbo+4uLA69cpoZNNToK5O0xTd1RuzMIxi3VHqiKoh6pDuzl
         meXEYhXog3RqfWyXlqAhXbcKAzS4QY2oA1DRzPV+RpBNELDNoai0DJcqH+qz9peobjjE
         n6O9tEVWtuP2oZ/dKNOsH4IOnO7JqvE7fF96hfHLcS/zNqi0pbY8Fw7CVbWgL1A4Pfip
         WWXBMh6jW9JMr2b5nJasMV1CHwC+hcGdOwY1m7yZZvWqA7Pl77QWveGkLAEelWwCP5wZ
         ZhAIkSKQC2vvOJiODqa/exXVVMC93Ci+LuJztJYENSMp7hsg68/ChNhhySWpMMuFa0er
         PV5Q==
X-Gm-Message-State: APjAAAW+t2zo53zKClrgY7V2csiMV8AkStpPKj0cE0yUw2g9SiSoga0N
	FmR6C7NclFBhLluJmFSehWxMuSv/D0rXIzSetfs=
X-Google-Smtp-Source: APXvYqwxRkqeBTGe2ipFXhHWevOzmHfCv3O5pvZN9gCYzK7L+ln0quOJ8iSVEtAb24QIwyqCIFqfSWgnDz92fMJhPwc=
X-Received: by 2002:ac2:55b4:: with SMTP id y20mr6942077lfg.173.1571423584708;
 Fri, 18 Oct 2019 11:33:04 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-7-samitolvanen@google.com> <CAKwvOd=z3RxvJeNV1sBE=Y1b6HgXdnT4M9bwMrUNZcvcSOqwTw@mail.gmail.com>
 <CABCJKud6+F=yhTo6xTXkHhtLWcSE99K=NcfKW_5E4swS4seKMw@mail.gmail.com>
In-Reply-To: <CABCJKud6+F=yhTo6xTXkHhtLWcSE99K=NcfKW_5E4swS4seKMw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 18 Oct 2019 20:32:53 +0200
Message-ID: <CANiq72=PSzufQkW+2fikdDfZ5ZR1sw2epvxv--mytWZkTZQ9sg@mail.gmail.com>
Subject: Re: [PATCH 06/18] add support for Clang's Shadow Call Stack (SCS)
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 18, 2019 at 7:11 PM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> On Fri, Oct 18, 2019 at 10:08 AM 'Nick Desaulniers' via Clang Built
> Linux <clang-built-linux@googlegroups.com> wrote:
> > > diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
> > > index 333a6695a918..9af08391f205 100644
> > > --- a/include/linux/compiler-clang.h
> > > +++ b/include/linux/compiler-clang.h
> > > @@ -42,3 +42,5 @@
> > >   * compilers, like ICC.
> > >   */
> > >  #define barrier() __asm__ __volatile__("" : : : "memory")
> > > +
> > > +#define __noscs                __attribute__((no_sanitize("shadow-call-stack")))
> >
> > It looks like this attribute, (and thus a requirement to use this
> > feature), didn't exist until Clang 7.0: https://godbolt.org/z/p9u1we
> > (as noted above)
> >
> > I think it's better to put __noscs behind a __has_attribute guard in
> > include/linux/compiler_attributes.h.  Otherwise, what will happen when
> > Clang 6.0 sees __noscs, for example? (-Wunknown-sanitizers will
> > happen).
>
> Good point, I'll fix this in v2. Thanks.

+1, please CC whenever you send it!

Cheers,
Miguel
