Return-Path: <SRS0=g/ls=V2=lists.openwall.com=kernel-hardening-return-16615-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC5C8C7618B
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Jul 2019 14:09:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 16128216C8
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Jul 2019 14:08:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16128216C8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16615-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11714 invoked by uid 550); 29 Jul 2019 14:08:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11678 invoked from network); 29 Jul 2019 14:08:53 -0000
Subject: Re: [RFC PATCH 10/10] powerpc/fsl_booke/kaslr: dump out kernel offset
 information on panic
To: Christophe Leroy <christophe.leroy@c-s.fr>, <mpe@ellerman.id.au>,
	<linuxppc-dev@lists.ozlabs.org>, <diana.craciun@nxp.com>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<yebin10@huawei.com>, <thunder.leizhen@huawei.com>,
	<jingxiangfeng@huawei.com>, <fanchengyang@huawei.com>
References: <20190717080621.40424-1-yanaijie@huawei.com>
 <20190717080621.40424-11-yanaijie@huawei.com>
 <d10db1e3-6bc4-eaa4-d68e-b7343e35b55f@c-s.fr>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <599f9ff9-9799-b57e-4c88-cf9c60b94a46@huawei.com>
Date: Mon, 29 Jul 2019 22:08:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <d10db1e3-6bc4-eaa4-d68e-b7343e35b55f@c-s.fr>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.96.203]
X-CFilter-Loop: Reflected


On 2019/7/29 19:43, Christophe Leroy wrote:
> 
> 
> Le 17/07/2019 à 10:06, Jason Yan a écrit :
>> When kaslr is enabled, the kernel offset is different for every boot.
>> This brings some difficult to debug the kernel. Dump out the kernel
>> offset when panic so that we can easily debug the kernel.
>>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> Cc: Diana Craciun <diana.craciun@nxp.com>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Nicholas Piggin <npiggin@gmail.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> ---
>>   arch/powerpc/include/asm/page.h     |  5 +++++
>>   arch/powerpc/kernel/machine_kexec.c |  1 +
>>   arch/powerpc/kernel/setup-common.c  | 23 +++++++++++++++++++++++
>>   3 files changed, 29 insertions(+)
>>
>> diff --git a/arch/powerpc/include/asm/page.h 
>> b/arch/powerpc/include/asm/page.h
>> index 60a68d3a54b1..cd3ac530e58d 100644
>> --- a/arch/powerpc/include/asm/page.h
>> +++ b/arch/powerpc/include/asm/page.h
>> @@ -317,6 +317,11 @@ struct vm_area_struct;
>>   extern unsigned long kimage_vaddr;
>> +static inline unsigned long kaslr_offset(void)
>> +{
>> +    return kimage_vaddr - KERNELBASE;
>> +}
>> +
>>   #include <asm-generic/memory_model.h>
>>   #endif /* __ASSEMBLY__ */
>>   #include <asm/slice.h>
>> diff --git a/arch/powerpc/kernel/machine_kexec.c 
>> b/arch/powerpc/kernel/machine_kexec.c
>> index c4ed328a7b96..078fe3d76feb 100644
>> --- a/arch/powerpc/kernel/machine_kexec.c
>> +++ b/arch/powerpc/kernel/machine_kexec.c
>> @@ -86,6 +86,7 @@ void arch_crash_save_vmcoreinfo(void)
>>       VMCOREINFO_STRUCT_SIZE(mmu_psize_def);
>>       VMCOREINFO_OFFSET(mmu_psize_def, shift);
>>   #endif
>> +    vmcoreinfo_append_str("KERNELOFFSET=%lx\n", kaslr_offset());
>>   }
>>   /*
>> diff --git a/arch/powerpc/kernel/setup-common.c 
>> b/arch/powerpc/kernel/setup-common.c
>> index 1f8db666468d..49e540c0adeb 100644
>> --- a/arch/powerpc/kernel/setup-common.c
>> +++ b/arch/powerpc/kernel/setup-common.c
>> @@ -715,12 +715,35 @@ static struct notifier_block ppc_panic_block = {
>>       .priority = INT_MIN /* may not return; must be done last */
>>   };
>> +/*
>> + * Dump out kernel offset information on panic.
>> + */
>> +static int dump_kernel_offset(struct notifier_block *self, unsigned 
>> long v,
>> +                  void *p)
>> +{
>> +    const unsigned long offset = kaslr_offset();
>> +
>> +    if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && offset > 0)
>> +        pr_emerg("Kernel Offset: 0x%lx from 0x%lx\n",
>> +             offset, KERNELBASE);
>> +    else
>> +        pr_emerg("Kernel Offset: disabled\n");
> 
> Do we really need that else branch ?
> 
> Why not just make the below atomic_notifier_chain_register() 
> conditionnal to IS_ENABLED(CONFIG_RANDOMIZE_BASE) && offset > 0
> and not print anything otherwise ?
> 

I'm trying to keep the same fashion as x86/arm64 do. But I agree
with you that it's simpler to not print anything else if not randomized.

> Christophe
> 
>> +
>> +    return 0;
>> +}
>> +
>> +static struct notifier_block kernel_offset_notifier = {
>> +    .notifier_call = dump_kernel_offset
>> +};
>> +
>>   void __init setup_panic(void)
>>   {
>>       /* PPC64 always does a hard irq disable in its panic handler */
>>       if (!IS_ENABLED(CONFIG_PPC64) && !ppc_md.panic)
>>           return;
>>       atomic_notifier_chain_register(&panic_notifier_list, 
>> &ppc_panic_block);
>> +    atomic_notifier_chain_register(&panic_notifier_list,
>> +                       &kernel_offset_notifier);
>>   }
>>   #ifdef CONFIG_CHECK_CACHE_COHERENCY
>>
> 
> .
> 

