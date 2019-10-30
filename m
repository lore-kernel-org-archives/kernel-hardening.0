Return-Path: <SRS0=y1T7=YX=lists.openwall.com=kernel-hardening-return-17166-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D39EECA9EAF
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 08:58:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 27F2B2087E
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 08:58:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="udhf1le6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27F2B2087E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=c-s.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17166-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5124 invoked by uid 550); 30 Oct 2019 08:58:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 4065 invoked from network); 30 Oct 2019 08:58:31 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=udhf1le6; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1572425899; bh=jg/wc8QIbH4zECIjrC9M/cSkNiZPA4jlUbBw8WzlMmY=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=udhf1le6OFrzcC9F8/Jd3vUzk02Y1Uc46itrYCfThyMt1ggmkeWF4ZgPrhj67fHdX
	 MWVctyCNIzvPbzoxqS7wlL2gj+fCvpq1ZwdtAtwn+aUhfwFTztYcZfa+ABfpBC5CZq
	 qifNjLSPHtAZOT49of06gWob19bTDkYEhx45FIAI=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH v5 0/5] Implement STRICT_MODULE_RWX for powerpc
To: Russell Currey <ruscur@russell.cc>, linuxppc-dev@lists.ozlabs.org
Cc: joel@jms.id.au, mpe@ellerman.id.au, ajd@linux.ibm.com, dja@axtens.net,
 npiggin@gmail.com, kernel-hardening@lists.openwall.com
References: <20191030073111.140493-1-ruscur@russell.cc>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <53461d29-ec0c-4401-542e-6d575545da38@c-s.fr>
Date: Wed, 30 Oct 2019 09:58:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191030073111.140493-1-ruscur@russell.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 30/10/2019 à 08:31, Russell Currey a écrit :
> v4 cover letter: https://lists.ozlabs.org/pipermail/linuxppc-dev/2019-October/198268.html
> v3 cover letter: https://lists.ozlabs.org/pipermail/linuxppc-dev/2019-October/198023.html
> 
> Changes since v4:
> 	[1/5]: Addressed review comments from Michael Ellerman (thanks!)
> 	[4/5]: make ARCH_HAS_STRICT_MODULE_RWX depend on
> 	       ARCH_HAS_STRICT_KERNEL_RWX to simplify things and avoid
> 	       STRICT_MODULE_RWX being *on by default* in cases where
> 	       STRICT_KERNEL_RWX is *unavailable*
> 	[5/5]: split skiroot_defconfig changes out into its own patch
> 
> The whole Kconfig situation is really weird and confusing, I believe the
> correct resolution is to change arch/Kconfig but the consequences are so
> minor that I don't think it's worth it, especially given that I expect
> powerpc to have mandatory strict RWX Soon(tm).

I'm not such strict RWX can be made mandatory due to the impact it has 
on some subarches:
- On the 8xx, unless all areas are 8Mbytes aligned, there is a 
significant overhead on TLB misses. And Aligning everthing to 8M is a 
waste of RAM which is not acceptable on systems having very few RAM.
- On hash book3s32, we are able to map the kernel BATs. With a few 
alignment constraints, we are able to provide STRICT_KERNEL_RWX. But we 
are unable to provide exec protection on page granularity. Only on 
256Mbytes segments. So for modules, we have to have the vmspace X. It is 
also not possible to have a kernel area RO. Only user areas can be made RO.

Christophe

> 
> Russell Currey (5):
>    powerpc/mm: Implement set_memory() routines
>    powerpc/kprobes: Mark newly allocated probes as RO
>    powerpc/mm/ptdump: debugfs handler for W+X checks at runtime
>    powerpc: Set ARCH_HAS_STRICT_MODULE_RWX
>    powerpc/configs: Enable STRICT_MODULE_RWX in skiroot_defconfig
> 
>   arch/powerpc/Kconfig                   |  2 +
>   arch/powerpc/Kconfig.debug             |  6 +-
>   arch/powerpc/configs/skiroot_defconfig |  1 +
>   arch/powerpc/include/asm/set_memory.h  | 32 +++++++++++
>   arch/powerpc/kernel/kprobes.c          |  3 +
>   arch/powerpc/mm/Makefile               |  1 +
>   arch/powerpc/mm/pageattr.c             | 77 ++++++++++++++++++++++++++
>   arch/powerpc/mm/ptdump/ptdump.c        | 21 ++++++-
>   8 files changed, 140 insertions(+), 3 deletions(-)
>   create mode 100644 arch/powerpc/include/asm/set_memory.h
>   create mode 100644 arch/powerpc/mm/pageattr.c
> 
