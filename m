Return-Path: <SRS0=3RSn=V2=lists.openwall.com=kernel-hardening-return-16600-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 871BBC7618B
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Jul 2019 10:59:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D4D392070D
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Jul 2019 10:59:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="Z7KOP+q9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4D392070D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=c-s.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16600-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27911 invoked by uid 550); 29 Jul 2019 10:59:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27877 invoked from network); 29 Jul 2019 10:59:12 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=Z7KOP+q9; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1564397935; bh=VxSKkHaFNdhmlWwNqqJwQwOE2mQ2WhfF8ueMIIf3F34=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=Z7KOP+q9C3qceGHfw6ZeieAEjypdB1+Dkd+P+cMakb/+BsuwphM7JqYj93yE4KHS0
	 ailFGX6Tzv1R5Yn1Wg1WclPtJ+xN54IxByFDadhndcGJ27eXhoj9At/rNwTvcaaw61
	 bvk5zCMdSO9rZUN03xgStmlD/qCIyPrZcFJ3yBRI=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [RFC PATCH 01/10] powerpc: unify definition of M_IF_NEEDED
To: Jason Yan <yanaijie@huawei.com>, mpe@ellerman.id.au,
 linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com,
 benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com,
 keescook@chromium.org, kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com,
 yebin10@huawei.com, thunder.leizhen@huawei.com, jingxiangfeng@huawei.com,
 fanchengyang@huawei.com
References: <20190717080621.40424-1-yanaijie@huawei.com>
 <20190717080621.40424-2-yanaijie@huawei.com>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <e9f2a7fc-ea70-e018-24b2-76cde6705780@c-s.fr>
Date: Mon, 29 Jul 2019 12:59:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190717080621.40424-2-yanaijie@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 17/07/2019 à 10:06, Jason Yan a écrit :
> M_IF_NEEDED is defined too many times. Move it to a common place.
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> Cc: Diana Craciun <diana.craciun@nxp.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Kees Cook <keescook@chromium.org>

Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>

> ---
>   arch/powerpc/include/asm/nohash/mmu-book3e.h  | 10 ++++++++++
>   arch/powerpc/kernel/exceptions-64e.S          | 10 ----------
>   arch/powerpc/kernel/fsl_booke_entry_mapping.S | 10 ----------
>   arch/powerpc/kernel/misc_64.S                 |  5 -----
>   4 files changed, 10 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/nohash/mmu-book3e.h b/arch/powerpc/include/asm/nohash/mmu-book3e.h
> index 4c9777d256fb..0877362e48fa 100644
> --- a/arch/powerpc/include/asm/nohash/mmu-book3e.h
> +++ b/arch/powerpc/include/asm/nohash/mmu-book3e.h
> @@ -221,6 +221,16 @@
>   #define TLBILX_T_CLASS2			6
>   #define TLBILX_T_CLASS3			7
>   
> +/*
> + * The mapping only needs to be cache-coherent on SMP, except on
> + * Freescale e500mc derivatives where it's also needed for coherent DMA.
> + */
> +#if defined(CONFIG_SMP) || defined(CONFIG_PPC_E500MC)
> +#define M_IF_NEEDED	MAS2_M
> +#else
> +#define M_IF_NEEDED	0
> +#endif
> +
>   #ifndef __ASSEMBLY__
>   #include <asm/bug.h>
>   
> diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
> index 1cfb3da4a84a..fd49ec07ce4a 100644
> --- a/arch/powerpc/kernel/exceptions-64e.S
> +++ b/arch/powerpc/kernel/exceptions-64e.S
> @@ -1342,16 +1342,6 @@ skpinv:	addi	r6,r6,1				/* Increment */
>   	sync
>   	isync
>   
> -/*
> - * The mapping only needs to be cache-coherent on SMP, except on
> - * Freescale e500mc derivatives where it's also needed for coherent DMA.
> - */
> -#if defined(CONFIG_SMP) || defined(CONFIG_PPC_E500MC)
> -#define M_IF_NEEDED	MAS2_M
> -#else
> -#define M_IF_NEEDED	0
> -#endif
> -
>   /* 6. Setup KERNELBASE mapping in TLB[0]
>    *
>    * r3 = MAS0 w/TLBSEL & ESEL for the entry we started in
> diff --git a/arch/powerpc/kernel/fsl_booke_entry_mapping.S b/arch/powerpc/kernel/fsl_booke_entry_mapping.S
> index ea065282b303..de0980945510 100644
> --- a/arch/powerpc/kernel/fsl_booke_entry_mapping.S
> +++ b/arch/powerpc/kernel/fsl_booke_entry_mapping.S
> @@ -153,16 +153,6 @@ skpinv:	addi	r6,r6,1				/* Increment */
>   	tlbivax 0,r9
>   	TLBSYNC
>   
> -/*
> - * The mapping only needs to be cache-coherent on SMP, except on
> - * Freescale e500mc derivatives where it's also needed for coherent DMA.
> - */
> -#if defined(CONFIG_SMP) || defined(CONFIG_PPC_E500MC)
> -#define M_IF_NEEDED	MAS2_M
> -#else
> -#define M_IF_NEEDED	0
> -#endif
> -
>   #if defined(ENTRY_MAPPING_BOOT_SETUP)
>   
>   /* 6. Setup KERNELBASE mapping in TLB1[0] */
> diff --git a/arch/powerpc/kernel/misc_64.S b/arch/powerpc/kernel/misc_64.S
> index b55a7b4cb543..26074f92d4bc 100644
> --- a/arch/powerpc/kernel/misc_64.S
> +++ b/arch/powerpc/kernel/misc_64.S
> @@ -432,11 +432,6 @@ kexec_create_tlb:
>   	rlwimi	r9,r10,16,4,15		/* Setup MAS0 = TLBSEL | ESEL(r9) */
>   
>   /* Set up a temp identity mapping v:0 to p:0 and return to it. */
> -#if defined(CONFIG_SMP) || defined(CONFIG_PPC_E500MC)
> -#define M_IF_NEEDED	MAS2_M
> -#else
> -#define M_IF_NEEDED	0
> -#endif
>   	mtspr	SPRN_MAS0,r9
>   
>   	lis	r9,(MAS1_VALID|MAS1_IPROT)@h
> 
