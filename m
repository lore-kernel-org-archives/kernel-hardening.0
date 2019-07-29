Return-Path: <SRS0=qdjz=V2=lists.openwall.com=kernel-hardening-return-16605-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B88C7618B
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Jul 2019 11:16:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5632620C01
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Jul 2019 11:16:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="dackvKxk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5632620C01
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=c-s.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16605-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13441 invoked by uid 550); 29 Jul 2019 11:16:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13406 invoked from network); 29 Jul 2019 11:16:33 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=dackvKxk; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1564398976; bh=SvoINWsTiNi6bfxTR73f4dRC0KxOWKSN84566TKBHYI=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=dackvKxkvIHUyKwgAU0n33t5nYi73VfZUUKvQBwa4KSCZnI4ttugm01gn6+YRS42o
	 GsD1zE3PRynbJOYj3GmEmZLew6BaSC4opjIdv6yl0JtDOtCBRYOA9D31XHQaGyDct3
	 CNObLoanBrtDdSjIfZuHFHJG+K3ieSoS7mkta/o0=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [RFC PATCH 06/10] powerpc/fsl_booke/32: implement KASLR
 infrastructure
To: Jason Yan <yanaijie@huawei.com>, mpe@ellerman.id.au,
 linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com,
 benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com,
 keescook@chromium.org, kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com,
 yebin10@huawei.com, thunder.leizhen@huawei.com, jingxiangfeng@huawei.com,
 fanchengyang@huawei.com
References: <20190717080621.40424-1-yanaijie@huawei.com>
 <20190717080621.40424-7-yanaijie@huawei.com>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <e3f287fc-c4d8-e0c2-90ba-ddfa3cb57e29@c-s.fr>
Date: Mon, 29 Jul 2019 13:16:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190717080621.40424-7-yanaijie@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 17/07/2019 à 10:06, Jason Yan a écrit :
> This patch add support to boot kernel from places other than KERNELBASE.
> Since CONFIG_RELOCATABLE has already supported, what we need to do is
> map or copy kernel to a proper place and relocate. Freescale Book-E
> parts expect lowmem to be mapped by fixed TLB entries(TLB1). The TLB1
> entries are not suitable to map the kernel directly in a randomized
> region, so we chose to copy the kernel to a proper place and restart to
> relocate.
> 
> The offset of the kernel was not randomized yet(a fixed 64M is set). We
> will randomize it in the next patch.
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> Cc: Diana Craciun <diana.craciun@nxp.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Kees Cook <keescook@chromium.org>
> ---
>   arch/powerpc/Kconfig                          | 11 +++
>   arch/powerpc/kernel/Makefile                  |  1 +
>   arch/powerpc/kernel/early_32.c                |  2 +-
>   arch/powerpc/kernel/fsl_booke_entry_mapping.S | 13 ++-
>   arch/powerpc/kernel/head_fsl_booke.S          | 15 +++-
>   arch/powerpc/kernel/kaslr_booke.c             | 83 +++++++++++++++++++
>   arch/powerpc/mm/mmu_decl.h                    |  6 ++
>   arch/powerpc/mm/nohash/fsl_booke.c            |  7 +-
>   8 files changed, 125 insertions(+), 13 deletions(-)
>   create mode 100644 arch/powerpc/kernel/kaslr_booke.c
> 

[...]

> diff --git a/arch/powerpc/mm/mmu_decl.h b/arch/powerpc/mm/mmu_decl.h
> index dae8e9177574..754ae1e69f92 100644
> --- a/arch/powerpc/mm/mmu_decl.h
> +++ b/arch/powerpc/mm/mmu_decl.h
> @@ -148,6 +148,12 @@ extern void reloc_kernel_entry(void *fdt, int addr);
>   extern void loadcam_entry(unsigned int index);
>   extern void loadcam_multi(int first_idx, int num, int tmp_idx);
>   
> +#ifdef CONFIG_RANDOMIZE_BASE
> +extern void kaslr_early_init(void *dt_ptr, phys_addr_t size);

No superflous 'extern' keyword.

Christophe

> +#else
> +static inline void kaslr_early_init(void *dt_ptr, phys_addr_t size) {}
> +#endif
> +
>   struct tlbcam {
>   	u32	MAS0;
>   	u32	MAS1;
