Return-Path: <SRS0=DKUt=E2=lists.openwall.com=kernel-hardening-return-20433-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38720C2D0E4
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 20:20:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2E88622D0A
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 20:20:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gyFkFQiG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E88622D0A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20433-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28188 invoked by uid 550); 20 Nov 2020 20:19:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28168 invoked from network); 20 Nov 2020 20:19:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7acuhIcf2aj+2HfwBkYRj3S/5vwbxxWC1CPfVW74VbQ=;
        b=gyFkFQiGUkXaUSAApDExFsLoGANoyNJrTgq+Uj6paRE46wRNgi6CKDFwmTfHlKvQPj
         Er7YyuPh/Vm7IE8fo7s0qFaQ+J1KSSTh2gKBxnB1wIcKxIDjY6KSardWaLK7oDrc8y2c
         4kdFdNabC+L2Mjs5rrPZnanoVf79hAu3cru/VeNYnxmuOucQz4Zphk15Gez73fSD2CqD
         AQbMyvtkwotDifRaGV6FeXKSexUu1NjZCba58CUErs2OOa74uTI7jGSLqvFrp+lsC6E+
         Ms7cuIiIpj16zzxU5/wxq9BhB8eXHmGgvUZLrwYiI37n7bXiBngkjjGfqQuKlN1BFLWq
         HIdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7acuhIcf2aj+2HfwBkYRj3S/5vwbxxWC1CPfVW74VbQ=;
        b=blbytp3C2AfxNubwNBeeUSSE7d/E6fLzzFZUPLJBXd1Ms3L8fjH/ZRIIF4GCB3sDVA
         o4Hu7xckkZzMx9r/W2cO1mImAYbq+5/u5r6jZq4fZXHJx6Y7/T/x1JbfzXHDVU4T8BSS
         sdOHEsAZ/4DGpwtfzy9MeKCXJ9MpmFhtZ2EWu8UcG0fnQQhglScQ/vHlzkvClDUWAqUH
         faK+qQb0UiqfmqhYN3bS9RIS6DfJ04EsiAlxi/oJlj8+sxzj1f132ZuqrJWNjjfxvNxj
         2aSKvntKoHCsHt9iqetoCa21+muzbvGckGxcWyqQt4gMbngQvpR8yT4KznKRg+skPxLL
         787Q==
X-Gm-Message-State: AOAM532+i/s5DsMgrUPQRO8spIe2YWfnmbeX9nXuWBdYeqJUzrFEyiyr
	QCSWe7xbgh+6kKXayn1v+2IUHyg2DRFpTjg9z2Pu4w==
X-Google-Smtp-Source: ABdhPJxFgydZX2L5XAnYwSfeznScyETG/9FyvzzmXojnDnWISYdoy1l6/FMv24FHnaLHqIodrvwFJpF/G3jjdZFT5xQ=
X-Received: by 2002:a67:7107:: with SMTP id m7mr15151234vsc.17.1605903582865;
 Fri, 20 Nov 2020 12:19:42 -0800 (PST)
MIME-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
 <CAKwvOd=5PhCTZ-yHr08gPYNEsGEjZa=rDY0-unhkhofjXhqwLQ@mail.gmail.com> <CAMj1kXEVzDi5=uteUAzG5E=j+aTCHEbMxwDfor-s=DthpREpyw@mail.gmail.com>
In-Reply-To: <CAMj1kXEVzDi5=uteUAzG5E=j+aTCHEbMxwDfor-s=DthpREpyw@mail.gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Fri, 20 Nov 2020 12:19:31 -0800
Message-ID: <CAKwvOdmpBNx9iSguGXivjJ03FaN5rgv2oaXZUQxYPdRccQmdyQ@mail.gmail.com>
Subject: Re: [PATCH v7 00/17] Add support for Clang LTO
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	PCI <linux-pci@vger.kernel.org>, Alistair Delva <adelva@google.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Nov 20, 2020 at 2:30 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Thu, 19 Nov 2020 at 00:42, Nick Desaulniers <ndesaulniers@google.com> wrote:
> >
> > Thanks for continuing to drive this series Sami.  For the series,
> >
> > Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> >
> > I did virtualized boot tests with the series applied to aarch64
> > defconfig without CONFIG_LTO, with CONFIG_LTO_CLANG, and a third time
> > with CONFIG_THINLTO.  If you make changes to the series in follow ups,
> > please drop my tested by tag from the modified patches and I'll help
> > re-test.  Some minor feedback on the Kconfig change, but I'll post it
> > off of that patch.
> >
>
> When you say 'virtualized" do you mean QEMU on x86? Or actual
> virtualization on an AArch64 KVM host?

aarch64 guest on x86_64 host.  If you have additional configurations
that are important to you, additional testing help would be
appreciated.

>
> The distinction is important here, given the potential impact of LTO
> on things that QEMU simply does not model when it runs in TCG mode on
> a foreign host architecture.

-- 
Thanks,
~Nick Desaulniers
