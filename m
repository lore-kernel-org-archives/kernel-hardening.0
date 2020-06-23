Return-Path: <SRS0=gqyX=AE=lists.openwall.com=kernel-hardening-return-19056-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC48C433DF
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 08:16:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0520F20716
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 08:16:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="W8C9BCxz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0520F20716
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19056-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16320 invoked by uid 550); 23 Jun 2020 08:16:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16285 invoked from network); 23 Jun 2020 08:16:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592900191;
	bh=aXsCXLsXUmWEyMJxdacaFR+V3cnV0sQZuQjfpfAYPCo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=W8C9BCxzMShk9ypxL7jBUsO0bpz97YjR0yqVB1lWG68/dPPdjhYDeQOONWWrcS2S6
	 hud637tepGFbgsOAK1v1RCfju8bEt7FuUjYDfywv0UnxiDdFwSifZx5VqNWAZ/T31e
	 A9DCydv8cB9fnxWNItObS7zPE2XfebFW+cHOGNqI=
X-Gm-Message-State: AOAM530WI8+iuY4Fpn8zBfPw9/rUqMVFsk2UWHsaTt8xAI0SUn0261MX
	QomJBBazyODFcUQbFP98B7mHjAGP21ckGQ+aywo=
X-Google-Smtp-Source: ABdhPJw+rmaojBMBU7eBhhOwcDhZDuXHLaBaD3nT7WXq4czKQbyUEfBBoRbviaQY8TUxPycNkfB8VPwfD60Pctvs638=
X-Received: by 2002:a9d:42e:: with SMTP id 43mr17213939otc.108.1592900190896;
 Tue, 23 Jun 2020 01:16:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200622092719.1380968-1-ardb@kernel.org> <20200623081303.GA3531@willie-the-truck>
In-Reply-To: <20200623081303.GA3531@willie-the-truck>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 23 Jun 2020 10:16:19 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFX5okSWZ8SgnOrbs7qVSS1A2kyL12UXQi8JcEWmcDb=w@mail.gmail.com>
Message-ID: <CAMj1kXFX5okSWZ8SgnOrbs7qVSS1A2kyL12UXQi8JcEWmcDb=w@mail.gmail.com>
Subject: Re: [RFC PATCH] arm64/acpi: disallow AML memory opregions to access
 kernel memory
To: Will Deacon <will@kernel.org>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Sudeep Holla <sudeep.holla@arm.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Jun 2020 at 10:13, Will Deacon <will@kernel.org> wrote:
>
> On Mon, Jun 22, 2020 at 11:27:19AM +0200, Ard Biesheuvel wrote:
> > ACPI provides support for SystemMemory opregions, to allow AML methods
> > to access MMIO registers of, e.g., GPIO controllers, or access reserved
> > regions of memory that are owned by the firmware.
> >
> > Currently, we also permit AML methods to access memory that is owned by
> > the kernel and mapped via the linear region, which does not seem to be
> > supported by a valid use case, and exposes the kernel's internal state
> > to AML methods that may be buggy and exploitable.
> >
> > So close the door on this, and simply reject AML remapping requests for
> > any memory that has a valid mapping in the linear region.
> >
> > Reported-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  arch/arm64/include/asm/acpi.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> > index a45366c3909b..18dcef4e6764 100644
> > --- a/arch/arm64/include/asm/acpi.h
> > +++ b/arch/arm64/include/asm/acpi.h
> > @@ -50,9 +50,9 @@ pgprot_t __acpi_get_mem_attribute(phys_addr_t addr);
> >  static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
> >                                           acpi_size size)
> >  {
> > -     /* For normal memory we already have a cacheable mapping. */
> > +     /* Don't allow access to kernel memory from AML code */
> >       if (memblock_is_map_memory(phys))
> > -             return (void __iomem *)__phys_to_virt(phys);
> > +             return NULL;
>
> I wonder if it would be better to poison this so that if we do see reports
> of AML crashes we'll know straight away that it tried to access memory
> mapped by the linear region, as opposed to some other NULL dereference.
>

We could just add a WARN_ONCE() here, no?

> Anyway, no objections to the idea. Be good for some of the usual ACPI
> suspects to check this doesn't blow up immediately, though.
>

Indeed, hence the RFC. Jason does have a point regarding the range
check, so I will try to do something about that and send a v2.
