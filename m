Return-Path: <SRS0=0d7h=E2=lists.openwall.com=kernel-hardening-return-20439-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2500DC2D0E4
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 23:54:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1FE6C223B0
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 23:54:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mdmSYKuo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FE6C223B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20439-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21962 invoked by uid 550); 20 Nov 2020 23:54:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21942 invoked from network); 20 Nov 2020 23:54:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/9QmQzu0viMhe1+E2AuJjw4yABAqeWJl/tuV7zSeb+U=;
        b=mdmSYKuoJmPQiSSZKAXRHrhaYfKRSQA9hE/wfOsOCkhwS+3+67n+lejlrZY4HtZfn/
         a2ORoKHB2+RW61Vt9T9zrAHoM1RsQbsuWV47pPf93KFSlEHy1Tfio9hzAUE4BkPNXx+I
         YITKk0YEENSGCNohJ36jZOmfNM0ry/U9Rv8sczK8LJbtzspnCR2SDBjJ4zad2AR6UovQ
         Szo2WkElnVp3Pq1aFadmc5JzwZozrsYu/68ODALQuad6JmMLMpwoXKqfBusvVuclgTF+
         rSwKmAgZg2oXKzT79ocvKhy7QjjLbUii5XJDdT+bt/WFOVYQqnt9FCLWzuGSaXf0zzOP
         TH/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/9QmQzu0viMhe1+E2AuJjw4yABAqeWJl/tuV7zSeb+U=;
        b=f3TWkvruIPFG2C76UdLRc44BzkYDLt8ldPvETkz6f8eBKKjelKrzjJe4gPmC9tt92Q
         OaMVMnZgesymgE1fvA/Ra6gC8oTFvf9Ba6Gmt196VnbyrAml+XJLZpYpOM+PHM8RmrlB
         /JyIrqVnZGFzhN6bTs9pys6KTuBsxs1JIpSEwBDQP53ym2XxeDM7F5fbe6hLhrf3HnJn
         18+eDqwqa9GHKQF9z0wu/EwLKMrl8xfQK9c8q4/x4N+8lvytugkZnWmfNkV/an3/zvL9
         Jeb2G22DWeYG0IrOmWa1zG4risa0Xh6daV7m/rBHxHC3LMfRzvtrYQVzWOyI+RU5qj3z
         I4AQ==
X-Gm-Message-State: AOAM530aD47kfjPI6bcavtX4DapQpMc+mYq1L0pAw/Jh0H1pjOlR5cmH
	s51udwiFAb+BEU2E/QlEOVy+dnOpPPgZncxcfhDXrA==
X-Google-Smtp-Source: ABdhPJy2DGSHmfFcAh4bM/VKta4IGQmsyfxYSHlfpKnMfeL7FrQ+44E3UgsHXg0jgCwAXeN0PaduNYVMcO8diBSDC4k=
X-Received: by 2002:a17:90a:6b04:: with SMTP id v4mr13286585pjj.101.1605916438104;
 Fri, 20 Nov 2020 15:53:58 -0800 (PST)
MIME-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
 <CAKwvOd=5PhCTZ-yHr08gPYNEsGEjZa=rDY0-unhkhofjXhqwLQ@mail.gmail.com>
 <CAMj1kXEVzDi5=uteUAzG5E=j+aTCHEbMxwDfor-s=DthpREpyw@mail.gmail.com>
 <CAKwvOdmpBNx9iSguGXivjJ03FaN5rgv2oaXZUQxYPdRccQmdyQ@mail.gmail.com> <CAMj1kXEoPEd6GzjL1XuxTPwitbR03BiBEXpAGtUytMj-h=vCkg@mail.gmail.com>
In-Reply-To: <CAMj1kXEoPEd6GzjL1XuxTPwitbR03BiBEXpAGtUytMj-h=vCkg@mail.gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Fri, 20 Nov 2020 15:53:45 -0800
Message-ID: <CAKwvOdmk1D0dLDOHEWX=jHpUxUT2JbwgnF62Qv3Rv=coNPadHg@mail.gmail.com>
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

On Fri, Nov 20, 2020 at 3:30 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Fri, 20 Nov 2020 at 21:19, Nick Desaulniers <ndesaulniers@google.com> wrote:
> >
> > On Fri, Nov 20, 2020 at 2:30 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> > >
> > > On Thu, 19 Nov 2020 at 00:42, Nick Desaulniers <ndesaulniers@google.com> wrote:
> > > >
> > > > Thanks for continuing to drive this series Sami.  For the series,
> > > >
> > > > Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> > > >
> > > > I did virtualized boot tests with the series applied to aarch64
> > > > defconfig without CONFIG_LTO, with CONFIG_LTO_CLANG, and a third time
> > > > with CONFIG_THINLTO.  If you make changes to the series in follow ups,
> > > > please drop my tested by tag from the modified patches and I'll help
> > > > re-test.  Some minor feedback on the Kconfig change, but I'll post it
> > > > off of that patch.
> > > >
> > >
> > > When you say 'virtualized" do you mean QEMU on x86? Or actual
> > > virtualization on an AArch64 KVM host?
> >
> > aarch64 guest on x86_64 host.  If you have additional configurations
> > that are important to you, additional testing help would be
> > appreciated.
> >
>
> Could you run this on an actual phone? Or does Android already ship
> with this stuff?

By `this`, if you mean "the LTO series", it has been shipping on
Android phones for years now, I think it's even required in the latest
release.

If you mean "the LTO series + mainline" on a phone, well there's the
android-mainline of https://android.googlesource.com/kernel/common/,
in which this series was recently removed in order to facilitate
rebasing Android's patches on ToT-mainline until getting the series
landed upstream.  Bit of a chicken and the egg problem there.

If you mean "the LTO series + mainline + KVM" on a phone; I don't know
the precise state of aarch64 KVM and Android (Will or Marc would
know).  We did experiment recently with RockPI's for aach64 KVM, IIRC;
I think Android is tricky as it still requires A64+A32/T32 chipsets,
Alistair would know more.  Might be interesting to boot a virtualized
(or paravirtualized?) guest built with LTO in a host built with LTO
for sure, but I don't know if we have tried that yet (I think we did
try LTO guests of android kernels, but I think they were on the stock
RockPI host BSP image IIRC).

> > > The distinction is important here, given the potential impact of LTO
> > > on things that QEMU simply does not model when it runs in TCG mode on
> > > a foreign host architecture.

-- 
Thanks,
~Nick Desaulniers
