Return-Path: <SRS0=yChs=AD=lists.openwall.com=kernel-hardening-return-19041-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D8ABC433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 21:10:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EA8FB20732
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 21:09:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="kuoU3JKx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA8FB20732
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=zx2c4.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19041-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16280 invoked by uid 550); 22 Jun 2020 21:09:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16245 invoked from network); 22 Jun 2020 21:09:52 -0000
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
	:references:in-reply-to:from:date:message-id:subject:to:cc
	:content-type; s=mail; bh=WB+AA0+qznfgGp7h2dMI5DSl7Dw=; b=kuoU3J
	KxH+OfrjrRvGxIek0+fOsv+QSU9gdtszXNibIuukgHE29GJxu87CKEIfXUH/X8R0
	ttUAdr5KtnzScR2wjk/qZH4/R/9JoXRhyhpkLDYJyhen2iv5avmSDMm83iHjXwnZ
	c2bjNIffxtz4gYEiz/D/ejJtmBIK9fKSfxf7DVUq234GVifw3b5+Eg2u4qGh/zzk
	kKIXm3pO0W29rTp1dVVSqhTslEmGl+obUFu2etP22bvrcfMXMw2q+ZaRVzyISZhP
	mLD6VVWZ4MmIp6dRtk8irlS78hI/KPJqLrpJ0+7nbJRVDMNMcW/EQHDRDWVPbkGK
	CDRJNWmGs8YeFpSw==
X-Gm-Message-State: AOAM533jsB1QkOnJTeGVXbPwS+DY1/RW8aI7UkijHMG2xlxZuN6sQEtA
	qH7oCixhyvS2gsqLdUcTeS6NwivNePdg6t7lPlg=
X-Google-Smtp-Source: ABdhPJzWnao8S3eeG+rKEh98PlH/ZTKC81HRz2YXJrgE8GehXe0vIj6M/DRWvrlBlF61wQNWmKcKGm2gFEfOGwZYGJY=
X-Received: by 2002:a05:6638:1405:: with SMTP id k5mr19410981jad.108.1592860178846;
 Mon, 22 Jun 2020 14:09:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200622092719.1380968-1-ardb@kernel.org>
In-Reply-To: <20200622092719.1380968-1-ardb@kernel.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 22 Jun 2020 15:09:28 -0600
X-Gmail-Original-Message-ID: <CAHmME9oNwDra2Vi+jsy4YZ81HVygyyRXTJeni58CaJqOmfmepA@mail.gmail.com>
Message-ID: <CAHmME9oNwDra2Vi+jsy4YZ81HVygyyRXTJeni58CaJqOmfmepA@mail.gmail.com>
Subject: Re: [RFC PATCH] arm64/acpi: disallow AML memory opregions to access
 kernel memory
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, lorenzo.pieralisi@arm.com, sudeep.holla@arm.com, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 22, 2020 at 3:27 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> ACPI provides support for SystemMemory opregions, to allow AML methods
> to access MMIO registers of, e.g., GPIO controllers, or access reserved
> regions of memory that are owned by the firmware.
>
> Currently, we also permit AML methods to access memory that is owned by
> the kernel and mapped via the linear region, which does not seem to be
> supported by a valid use case, and exposes the kernel's internal state
> to AML methods that may be buggy and exploitable.
>
> So close the door on this, and simply reject AML remapping requests for
> any memory that has a valid mapping in the linear region.
>
> Reported-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/include/asm/acpi.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> index a45366c3909b..18dcef4e6764 100644
> --- a/arch/arm64/include/asm/acpi.h
> +++ b/arch/arm64/include/asm/acpi.h
> @@ -50,9 +50,9 @@ pgprot_t __acpi_get_mem_attribute(phys_addr_t addr);
>  static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
>                                             acpi_size size)
>  {
> -       /* For normal memory we already have a cacheable mapping. */
> +       /* Don't allow access to kernel memory from AML code */
>         if (memblock_is_map_memory(phys))
> -               return (void __iomem *)__phys_to_virt(phys);
> +               return NULL;

I'm happy to see that implementation-wise it's so easy. Take my
Acked-by, but I'd really prefer somebody with some ACPI experience and
has looked at tons of DSDTs over the years to say whether or not this
will break hardware.

[As an aside, the current implementation is actually "wrong", since
that will trap when an ASL tries to write to regions mapped as
read-only, which shouldn't happen when selecting physical addresses. I
learned this the ~hard way when writing those exploits last week. :-P]
