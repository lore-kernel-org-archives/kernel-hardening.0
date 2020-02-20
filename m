Return-Path: <SRS0=gnU2=4I=lists.openwall.com=kernel-hardening-return-17855-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923B8C11D05
	for <kernel-hardening@archiver.kernel.org>; Thu, 20 Feb 2020 13:41:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E4FC4206EF
	for <kernel-hardening@archiver.kernel.org>; Thu, 20 Feb 2020 13:41:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="ZOSkCGU1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4FC4206EF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=c-s.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17855-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1412 invoked by uid 550); 20 Feb 2020 13:41:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1376 invoked from network); 20 Feb 2020 13:41:35 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=ZOSkCGU1; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1582206082; bh=PWM2VGeYn1puuYVao8kR+gKhli5A0TKj0zM2lK44Ojg=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=ZOSkCGU1Srry32+pfJZCoylAC9Zgb2Mf5iLtUbdraslH6edil/Z5vijqc6OA025Lp
	 nzx1saoBgW36o3ZnMfKImSy5boQBGQNGhtzNObDZuwZpOhe9hD2fI4xjldovLxkcUc
	 wfpzmLymqHpUV8+R3Aq7l/TQuVrPKWFwqD4SGXa0=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH v3 2/6] powerpc/fsl_booke/64: introduce
 reloc_kernel_entry() helper
To: Jason Yan <yanaijie@huawei.com>, mpe@ellerman.id.au,
 linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com,
 benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com,
 keescook@chromium.org, kernel-hardening@lists.openwall.com, oss@buserror.net
Cc: linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com
References: <20200206025825.22934-1-yanaijie@huawei.com>
 <20200206025825.22934-3-yanaijie@huawei.com>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <da8c9b88-1d21-ed70-c6f1-343117b4075d@c-s.fr>
Date: Thu, 20 Feb 2020 14:41:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200206025825.22934-3-yanaijie@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 06/02/2020 à 03:58, Jason Yan a écrit :
> Like the 32bit code, we introduce reloc_kernel_entry() helper to prepare
> for the KASLR 64bit version. And move the C declaration of this function
> out of CONFIG_PPC32 and use long instead of int for the parameter 'addr'.
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> Cc: Scott Wood <oss@buserror.net>
> Cc: Diana Craciun <diana.craciun@nxp.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Kees Cook <keescook@chromium.org>

Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>


> ---
>   arch/powerpc/kernel/exceptions-64e.S | 13 +++++++++++++
>   arch/powerpc/mm/mmu_decl.h           |  3 ++-
>   2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
> index e4076e3c072d..1b9b174bee86 100644
> --- a/arch/powerpc/kernel/exceptions-64e.S
> +++ b/arch/powerpc/kernel/exceptions-64e.S
> @@ -1679,3 +1679,16 @@ _GLOBAL(setup_ehv_ivors)
>   _GLOBAL(setup_lrat_ivor)
>   	SET_IVOR(42, 0x340) /* LRAT Error */
>   	blr
> +
> +/*
> + * Return to the start of the relocated kernel and run again
> + * r3 - virtual address of fdt
> + * r4 - entry of the kernel
> + */
> +_GLOBAL(reloc_kernel_entry)
> +	mfmsr	r7
> +	rlwinm	r7, r7, 0, ~(MSR_IS | MSR_DS)
> +
> +	mtspr	SPRN_SRR0,r4
> +	mtspr	SPRN_SRR1,r7
> +	rfi
> diff --git a/arch/powerpc/mm/mmu_decl.h b/arch/powerpc/mm/mmu_decl.h
> index 8e99649c24fc..3e1c85c7d10b 100644
> --- a/arch/powerpc/mm/mmu_decl.h
> +++ b/arch/powerpc/mm/mmu_decl.h
> @@ -140,9 +140,10 @@ extern void adjust_total_lowmem(void);
>   extern int switch_to_as1(void);
>   extern void restore_to_as0(int esel, int offset, void *dt_ptr, int bootcpu);
>   void create_kaslr_tlb_entry(int entry, unsigned long virt, phys_addr_t phys);
> -void reloc_kernel_entry(void *fdt, int addr);
>   extern int is_second_reloc;
>   #endif
> +
> +void reloc_kernel_entry(void *fdt, long addr);
>   extern void loadcam_entry(unsigned int index);
>   extern void loadcam_multi(int first_idx, int num, int tmp_idx);
>   
> 
