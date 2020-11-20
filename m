Return-Path: <SRS0=lFJw=E2=lists.openwall.com=kernel-hardening-return-20438-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF04C2D0E4
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 23:31:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 33F9D2240B
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 23:31:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZzdH79P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33F9D2240B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20438-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14313 invoked by uid 550); 20 Nov 2020 23:30:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14293 invoked from network); 20 Nov 2020 23:30:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1605915044;
	bh=pAOPOCc79X5vSW6IJcHVGfCdHUlnqpSzr+lv+zQxwCc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=RZzdH79P6J5urfJDjwQdKxx5LnTEOmSru+Pngr2whnPMGGF/5iys8b3oGoRp3fiC2
	 B9zPEK+hV1YvwzBAM2H5HZymjsteXPWwOamkRpmbJpb2YTeAXwp7dY7auSdWBrz/F2
	 /N80r04AHKKCoaM6D2sPwvKPyEcCtIgwahDH+KeA=
X-Gm-Message-State: AOAM531NgBvdjLO/regjjJygTyprv9hPsLKlIx39wUHqssIXtCm4GWRp
	AdpTpUficPcwePoWJ71/lkYKyITt86P16IZvbpI=
X-Google-Smtp-Source: ABdhPJydXVeIwFrz87ExsApybJ0EuK40nIe6165egNvLnhUN+I4Xd9fvkCEU5QPaIxetxiAiYULX8LNHUT5DTI1cr7A=
X-Received: by 2002:aca:5c82:: with SMTP id q124mr8196235oib.33.1605915043305;
 Fri, 20 Nov 2020 15:30:43 -0800 (PST)
MIME-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
 <CAKwvOd=5PhCTZ-yHr08gPYNEsGEjZa=rDY0-unhkhofjXhqwLQ@mail.gmail.com>
 <CAMj1kXEVzDi5=uteUAzG5E=j+aTCHEbMxwDfor-s=DthpREpyw@mail.gmail.com> <CAKwvOdmpBNx9iSguGXivjJ03FaN5rgv2oaXZUQxYPdRccQmdyQ@mail.gmail.com>
In-Reply-To: <CAKwvOdmpBNx9iSguGXivjJ03FaN5rgv2oaXZUQxYPdRccQmdyQ@mail.gmail.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sat, 21 Nov 2020 00:30:32 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEoPEd6GzjL1XuxTPwitbR03BiBEXpAGtUytMj-h=vCkg@mail.gmail.com>
Message-ID: <CAMj1kXEoPEd6GzjL1XuxTPwitbR03BiBEXpAGtUytMj-h=vCkg@mail.gmail.com>
Subject: Re: [PATCH v7 00/17] Add support for Clang LTO
To: Nick Desaulniers <ndesaulniers@google.com>
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

On Fri, 20 Nov 2020 at 21:19, Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> On Fri, Nov 20, 2020 at 2:30 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > On Thu, 19 Nov 2020 at 00:42, Nick Desaulniers <ndesaulniers@google.com> wrote:
> > >
> > > Thanks for continuing to drive this series Sami.  For the series,
> > >
> > > Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> > >
> > > I did virtualized boot tests with the series applied to aarch64
> > > defconfig without CONFIG_LTO, with CONFIG_LTO_CLANG, and a third time
> > > with CONFIG_THINLTO.  If you make changes to the series in follow ups,
> > > please drop my tested by tag from the modified patches and I'll help
> > > re-test.  Some minor feedback on the Kconfig change, but I'll post it
> > > off of that patch.
> > >
> >
> > When you say 'virtualized" do you mean QEMU on x86? Or actual
> > virtualization on an AArch64 KVM host?
>
> aarch64 guest on x86_64 host.  If you have additional configurations
> that are important to you, additional testing help would be
> appreciated.
>

Could you run this on an actual phone? Or does Android already ship
with this stuff?


> >
> > The distinction is important here, given the potential impact of LTO
> > on things that QEMU simply does not model when it runs in TCG mode on
> > a foreign host architecture.
>
> --
> Thanks,
> ~Nick Desaulniers
