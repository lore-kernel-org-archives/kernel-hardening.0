Return-Path: <SRS0=fFe1=5P=lists.openwall.com=kernel-hardening-return-18298-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B09DC43331
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 13:51:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 96670206CC
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 13:51:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="TVppmMOS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96670206CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18298-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11821 invoked by uid 550); 30 Mar 2020 13:51:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11789 invoked from network); 30 Mar 2020 13:51:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585576286;
	bh=shRxHPO6TNubPsJ8Kjm+VBtKtgZ9LoE0ypNOsjrhlXw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TVppmMOSXAOdk3sfXijAOW160toaPEfSbfuCM5nMPwj/I3zOVURZQDOSEZuSPsYYy
	 kqP/py9AFaPG8DnYkTKU1srHzS+4+sedlU3OhdM4pJaipPpH+n4oNZtKNI7ilOgM3T
	 9HiPi2kWUIqDGyNDy4oebEE3SwMtrpR/lsMZf0PE=
Date: Mon, 30 Mar 2020 14:51:21 +0100
From: Will Deacon <will@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	kernel-hardening@lists.openwall.com, catalin.marinas@arm.com,
	mark.rutland@arm.com
Subject: Re: [RFC PATCH] arm64: remove CONFIG_DEBUG_ALIGN_RODATA feature
Message-ID: <20200330135121.GD10633@willie-the-truck>
References: <20200329141258.31172-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200329141258.31172-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Sun, Mar 29, 2020 at 04:12:58PM +0200, Ard Biesheuvel wrote:
> When CONFIG_DEBUG_ALIGN_RODATA is enabled, kernel segments mapped with
> different permissions (r-x for .text, r-- for .rodata, rw- for .data,
> etc) are rounded up to 2 MiB so they can be mapped more efficiently.
> In particular, it permits the segments to be mapped using level 2
> block entries when using 4k pages, which is expected to result in less
> TLB pressure.
> 
> However, the mappings for the bulk of the kernel will use level 2
> entries anyway, and the misaligned fringes are organized such that they
> can take advantage of the contiguous bit, and use far fewer level 3
> entries than would be needed otherwise.
> 
> This makes the value of this feature dubious at best, and since it is not
> enabled in defconfig or in the distro configs, it does not appear to be
> in wide use either. So let's just remove it.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/Kconfig.debug                  | 13 -------------
>  arch/arm64/include/asm/memory.h           | 12 +-----------
>  drivers/firmware/efi/libstub/arm64-stub.c |  8 +++-----
>  3 files changed, 4 insertions(+), 29 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

But I would really like to go a step further and rip out the block mapping
support altogether so that we can fix non-coherent DMA aliases:

https://lore.kernel.org/lkml/20200224194446.690816-1-hch@lst.de

Will
