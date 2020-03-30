Return-Path: <SRS0=TQqS=5P=lists.openwall.com=kernel-hardening-return-18297-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 565B9C43331
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 12:43:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A4D4C20675
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 12:43:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="kiRebQh6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4D4C20675
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18297-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24452 invoked by uid 550); 30 Mar 2020 12:43:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23650 invoked from network); 30 Mar 2020 12:36:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585571797;
	bh=2AXyU8ugSagURCiFbOUooLN6U3MB2Le88crw+QxGb3A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kiRebQh6/SNukeXGGn2kVD6aMiKE2/3WRKskk20FCu3wU6X+73j81DEKO1aYBp1P2
	 fp9euWyCVQlT8Fnl2Uo93mtGUrR4w2BILnZNa93/pfNXs+QrPNlrj/rhMc0z4eKumM
	 k02o3dwN7oA2JUt7g1LvsYD9LdQGYQxqO45BSUn4=
X-Gm-Message-State: ANhLgQ1l7i4IgDjXORe9V7+v1T13mEIiA2BnDTU3Hf88mTT2+xmgcuRA
	RMRKV2v92X3Bu38dVhr0MyLRDjYeFzfA8cpsyzQ=
X-Google-Smtp-Source: ADFU+vvy1OWSGhQQBJgVLP0RN+6n6610P4wShb1xm2SjioY07N2JppE8S+F+09WE5GZa9LNN8RMgYkDNI7Va6rJLKo8=
X-Received: by 2002:a05:6e02:551:: with SMTP id i17mr10003944ils.218.1585571796432;
 Mon, 30 Mar 2020 05:36:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200329141258.31172-1-ardb@kernel.org> <20200330093641.GA25920@C02TD0UTHF1T.local>
In-Reply-To: <20200330093641.GA25920@C02TD0UTHF1T.local>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 30 Mar 2020 14:36:25 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGYYGRMXAa+k+ysDmfbW2XsTF56yEr8=3Q__mw_Jt4j8Q@mail.gmail.com>
Message-ID: <CAMj1kXGYYGRMXAa+k+ysDmfbW2XsTF56yEr8=3Q__mw_Jt4j8Q@mail.gmail.com>
Subject: Re: [RFC PATCH] arm64: remove CONFIG_DEBUG_ALIGN_RODATA feature
To: Mark Rutland <mark.rutland@arm.com>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	kernel-hardening@lists.openwall.com, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 30 Mar 2020 at 13:29, Mark Rutland <mark.rutland@arm.com> wrote:
>
> On Sun, Mar 29, 2020 at 04:12:58PM +0200, Ard Biesheuvel wrote:
> > When CONFIG_DEBUG_ALIGN_RODATA is enabled, kernel segments mapped with
> > different permissions (r-x for .text, r-- for .rodata, rw- for .data,
> > etc) are rounded up to 2 MiB so they can be mapped more efficiently.
> > In particular, it permits the segments to be mapped using level 2
> > block entries when using 4k pages, which is expected to result in less
> > TLB pressure.
> >
> > However, the mappings for the bulk of the kernel will use level 2
> > entries anyway, and the misaligned fringes are organized such that they
> > can take advantage of the contiguous bit, and use far fewer level 3
> > entries than would be needed otherwise.
> >
> > This makes the value of this feature dubious at best, and since it is not
> > enabled in defconfig or in the distro configs, it does not appear to be
> > in wide use either. So let's just remove it.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>
> No strong feelings either way, but getting rid of code is usually good,
> so:
>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
>

Thanks Mark.

This is related to [0], which increases the PE/COFF section alignment
to 64k so that a KASLR enabled kernel always lands at an address at
which it can execute without being moved around first. This is an
improvement in itself, but also provides 5 bits (log2(2M / 64k)) of
wiggle room for the virtual as well as the physical placement of the
kernel. CONFIG_DEBUG_ALIGN_RODATA kind of interferes with that, so I'd
like to get rid of it.

Catalin, Will: if you have no objections, I can include this in my
series for v5.8 and take it via the EFI tree.

Thanks,
Ard.

[0] https://lore.kernel.org/linux-efi/20200326165905.2240-1-ardb@kernel.org/
