Return-Path: <SRS0=SsPF=V3=lists.openwall.com=kernel-hardening-return-16639-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4BB1C433FF
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Jul 2019 09:49:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 305F82067D
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Jul 2019 09:49:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="gVISzoKt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 305F82067D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=c-s.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16639-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32033 invoked by uid 550); 30 Jul 2019 09:49:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31996 invoked from network); 30 Jul 2019 09:49:11 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=gVISzoKt; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1564480139; bh=tFSCyuXc6xQQsa1h4dVfNa0KvJuc0fYe9QTvxMXWUko=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=gVISzoKtekQbUyLsLuz/fiSuqHr8hTH9GVy3MNjsYonNwQXwqaDGF4JIojVzSpw6s
	 o+RcDtYDrqB1/6D3ZbKWuMfgQUgniAlw62L9NVMrAD+m3eLUpqcx8k1kdHQ8c9lyTM
	 MXL5wJJnNCIb4BDP8JNrMMuS+OCntHIg0vEgGics=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH v2 10/10] powerpc/fsl_booke/kaslr: dump out kernel offset
 information on panic
To: Jason Yan <yanaijie@huawei.com>, mpe@ellerman.id.au,
 linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com,
 benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com,
 keescook@chromium.org, kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com,
 yebin10@huawei.com, thunder.leizhen@huawei.com, jingxiangfeng@huawei.com,
 fanchengyang@huawei.com, zhaohongjiang@huawei.com
References: <20190730074225.39544-1-yanaijie@huawei.com>
 <20190730074225.39544-11-yanaijie@huawei.com>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <2a31b934-3658-c02e-4e86-c9ba03029bd6@c-s.fr>
Date: Tue, 30 Jul 2019 11:48:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190730074225.39544-11-yanaijie@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 30/07/2019 à 09:42, Jason Yan a écrit :
> When kaslr is enabled, the kernel offset is different for every boot.
> This brings some difficult to debug the kernel. Dump out the kernel
> offset when panic so that we can easily debug the kernel.
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
>   arch/powerpc/include/asm/page.h     |  5 +++++
>   arch/powerpc/kernel/machine_kexec.c |  1 +
>   arch/powerpc/kernel/setup-common.c  | 19 +++++++++++++++++++
>   3 files changed, 25 insertions(+)
> 
> diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
> index 60a68d3a54b1..cd3ac530e58d 100644
> --- a/arch/powerpc/include/asm/page.h
> +++ b/arch/powerpc/include/asm/page.h
> @@ -317,6 +317,11 @@ struct vm_area_struct;
>   
>   extern unsigned long kimage_vaddr;
>   
> +static inline unsigned long kaslr_offset(void)
> +{
> +	return kimage_vaddr - KERNELBASE;
> +}
> +
>   #include <asm-generic/memory_model.h>
>   #endif /* __ASSEMBLY__ */
>   #include <asm/slice.h>
> diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
> index c4ed328a7b96..078fe3d76feb 100644
> --- a/arch/powerpc/kernel/machine_kexec.c
> +++ b/arch/powerpc/kernel/machine_kexec.c
> @@ -86,6 +86,7 @@ void arch_crash_save_vmcoreinfo(void)
>   	VMCOREINFO_STRUCT_SIZE(mmu_psize_def);
>   	VMCOREINFO_OFFSET(mmu_psize_def, shift);
>   #endif
> +	vmcoreinfo_append_str("KERNELOFFSET=%lx\n", kaslr_offset());
>   }
>   
>   /*
> diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
> index 1f8db666468d..064075f02837 100644
> --- a/arch/powerpc/kernel/setup-common.c
> +++ b/arch/powerpc/kernel/setup-common.c
> @@ -715,12 +715,31 @@ static struct notifier_block ppc_panic_block = {
>   	.priority = INT_MIN /* may not return; must be done last */
>   };
>   
> +/*
> + * Dump out kernel offset information on panic.
> + */
> +static int dump_kernel_offset(struct notifier_block *self, unsigned long v,
> +			      void *p)
> +{
> +	pr_emerg("Kernel Offset: 0x%lx from 0x%lx\n",
> +		 kaslr_offset(), KERNELBASE);
> +
> +	return 0;
> +}
> +
> +static struct notifier_block kernel_offset_notifier = {
> +	.notifier_call = dump_kernel_offset
> +};
> +
>   void __init setup_panic(void)
>   {
>   	/* PPC64 always does a hard irq disable in its panic handler */
>   	if (!IS_ENABLED(CONFIG_PPC64) && !ppc_md.panic)
>   		return;
>   	atomic_notifier_chain_register(&panic_notifier_list, &ppc_panic_block);
> +	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && kaslr_offset() > 0)
> +		atomic_notifier_chain_register(&panic_notifier_list,
> +					       &kernel_offset_notifier);
>   }
>   
>   #ifdef CONFIG_CHECK_CACHE_COHERENCY
> 
