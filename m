Return-Path: <SRS0=ROE5=WE=lists.openwall.com=kernel-hardening-return-16758-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28071C0650F
	for <kernel-hardening@archiver.kernel.org>; Thu,  8 Aug 2019 08:40:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3C993217F4
	for <kernel-hardening@archiver.kernel.org>; Thu,  8 Aug 2019 08:40:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C993217F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16758-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31933 invoked by uid 550); 8 Aug 2019 08:39:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31855 invoked from network); 8 Aug 2019 08:39:51 -0000
Subject: Re: [PATCH v5 10/10] powerpc/fsl_booke/kaslr: dump out kernel offset
 information on panic
To: Michael Ellerman <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<yebin10@huawei.com>, <thunder.leizhen@huawei.com>,
	<jingxiangfeng@huawei.com>, <fanchengyang@huawei.com>,
	<zhaohongjiang@huawei.com>
References: <20190807065706.11411-1-yanaijie@huawei.com>
 <20190807065706.11411-11-yanaijie@huawei.com>
 <87zhklt9eg.fsf@concordia.ellerman.id.au>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <9113cc5b-0e89-f423-712a-79220af82b92@huawei.com>
Date: Thu, 8 Aug 2019 16:39:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <87zhklt9eg.fsf@concordia.ellerman.id.au>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.203]
X-CFilter-Loop: Reflected



On 2019/8/7 21:03, Michael Ellerman wrote:
> Jason Yan <yanaijie@huawei.com> writes:
>> When kaslr is enabled, the kernel offset is different for every boot.
>> This brings some difficult to debug the kernel. Dump out the kernel
>> offset when panic so that we can easily debug the kernel.
> 
> Some of this is taken from the arm64 version right? Please say so when
> you copy other people's code.
> 

No problem. Architectures like x86 or arm64 or s390 both have this
similar code. I guess x86 is the first one.

>> diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
>> index c4ed328a7b96..078fe3d76feb 100644
>> --- a/arch/powerpc/kernel/machine_kexec.c
>> +++ b/arch/powerpc/kernel/machine_kexec.c
>> @@ -86,6 +86,7 @@ void arch_crash_save_vmcoreinfo(void)
>>   	VMCOREINFO_STRUCT_SIZE(mmu_psize_def);
>>   	VMCOREINFO_OFFSET(mmu_psize_def, shift);
>>   #endif
>> +	vmcoreinfo_append_str("KERNELOFFSET=%lx\n", kaslr_offset());
>>   }
> 
> There's no mention of that in the commit log.
> 
> Please split it into a separate patch and describe what you're doing and
> why.

OK

> 
>> diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
>> index 1f8db666468d..064075f02837 100644
>> --- a/arch/powerpc/kernel/setup-common.c
>> +++ b/arch/powerpc/kernel/setup-common.c
>> @@ -715,12 +715,31 @@ static struct notifier_block ppc_panic_block = {
>>   	.priority = INT_MIN /* may not return; must be done last */
>>   };
>>   
>> +/*
>> + * Dump out kernel offset information on panic.
>> + */
>> +static int dump_kernel_offset(struct notifier_block *self, unsigned long v,
>> +			      void *p)
>> +{
>> +	pr_emerg("Kernel Offset: 0x%lx from 0x%lx\n",
>> +		 kaslr_offset(), KERNELBASE);
>> +
>> +	return 0;
>> +}
>> +
>> +static struct notifier_block kernel_offset_notifier = {
>> +	.notifier_call = dump_kernel_offset
>> +};
>> +
>>   void __init setup_panic(void)
>>   {
>>   	/* PPC64 always does a hard irq disable in its panic handler */
>>   	if (!IS_ENABLED(CONFIG_PPC64) && !ppc_md.panic)
>>   		return;
>>   	atomic_notifier_chain_register(&panic_notifier_list, &ppc_panic_block);
> 
>> +	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && kaslr_offset() > 0)
>> +		atomic_notifier_chain_register(&panic_notifier_list,
>> +					       &kernel_offset_notifier);
> 
> Don't you want to do that before the return above?
> 

Eagle eye. This should not affected by the conditions above.

>>   }
> 
> cheers
> 
> .
> 

