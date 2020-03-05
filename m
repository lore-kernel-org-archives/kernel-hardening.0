Return-Path: <SRS0=12Rk=4W=lists.openwall.com=kernel-hardening-return-18067-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 114F9C3F2CE
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 02:32:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 697DC20838
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 02:32:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 697DC20838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18067-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14181 invoked by uid 550); 5 Mar 2020 02:32:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14144 invoked from network); 5 Mar 2020 02:32:50 -0000
Subject: Re: [PATCH v3 3/6] powerpc/fsl_booke/64: implement KASLR for
 fsl_booke64
To: Scott Wood <oss@buserror.net>, <mpe@ellerman.id.au>,
	<linuxppc-dev@lists.ozlabs.org>, <diana.craciun@nxp.com>,
	<christophe.leroy@c-s.fr>, <benh@kernel.crashing.org>, <paulus@samba.org>,
	<npiggin@gmail.com>, <keescook@chromium.org>,
	<kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <zhaohongjiang@huawei.com>
References: <20200206025825.22934-1-yanaijie@huawei.com>
 <20200206025825.22934-4-yanaijie@huawei.com>
 <10913e48efea24c1d217bc5a723d6cd827945de7.camel@buserror.net>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <a4fb67df-b7e3-0e42-0bb3-1d92dc487b98@huawei.com>
Date: Thu, 5 Mar 2020 10:32:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <10913e48efea24c1d217bc5a723d6cd827945de7.camel@buserror.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.221.195]
X-CFilter-Loop: Reflected



在 2020/3/5 5:44, Scott Wood 写道:
> On Thu, 2020-02-06 at 10:58 +0800, Jason Yan wrote:
>> The implementation for Freescale BookE64 is similar as BookE32. One
>> difference is that Freescale BookE64 set up a TLB mapping of 1G during
>> booting. Another difference is that ppc64 needs the kernel to be
>> 64K-aligned. So we can randomize the kernel in this 1G mapping and make
>> it 64K-aligned. This can save some code to creat another TLB map at
>> early boot. The disadvantage is that we only have about 1G/64K = 16384
>> slots to put the kernel in.
>>
>> To support secondary cpu boot up, a variable __kaslr_offset was added in
>> first_256B section. This can help secondary cpu get the kaslr offset
>> before the 1:1 mapping has been setup.
> 
> What specifically requires __kaslr_offset instead of using kernstart_virt_addr
> like 32-bit does?
> 

kernstart_virt_addr is in the data section. At the early boot we only
have a 64M tlb mapping. For the 32-bit I limited the kernel in a
64M-aligned region so that we can always get kernstart_virt_addr. But
for the 64-bit the kernel is bigger and not suitable to limit it in a
64M-aligned region.

So if we use kernstart_virt_addr and the kernel is randomized like below 
, the secondary cpus will not boot up:

+------------+------------+
|  64M       |   64M      |
+------------+------------+
            ^        ^
            | kernel |
                 ^
            kernstart_virt_addr

So I have to put the kernel offset in the first 64K along with the init 
text.

>>   
>> diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
>> index ad79fddb974d..744624140fb8 100644
>> --- a/arch/powerpc/kernel/head_64.S
>> +++ b/arch/powerpc/kernel/head_64.S
>> @@ -104,6 +104,13 @@ __secondary_hold_acknowledge:
>>   	.8byte	0x0
>>   
>>   #ifdef CONFIG_RELOCATABLE
>> +#ifdef CONFIG_RANDOMIZE_BASE
>> +	. = 0x58
>> +	.globl	__kaslr_offset
>> +__kaslr_offset:
>> +DEFINE_FIXED_SYMBOL(__kaslr_offset)
>> +	.long	0
>> +#endif
>>   	/* This flag is set to 1 by a loader if the kernel should run
>>   	 * at the loaded address instead of the linked address.  This
>>   	 * is used by kexec-tools to keep the the kdump kernel in the
> 
> Why does it need to go here at a fixed address?
> 

It does not need to be at a fixed address. I just want to keep 
consistent and stay along with __run_at_load.

> 
>>   
>>   	/* check for a reserved-memory node and record its cell sizes */
>>   	regions.reserved_mem = fdt_path_offset(dt_ptr, "/reserved-memory");
>> @@ -363,6 +374,17 @@ notrace void __init kaslr_early_init(void *dt_ptr,
>> phys_addr_t size)
>>   	unsigned long offset;
>>   	unsigned long kernel_sz;
>>   
>> +#ifdef CONFIG_PPC64
>> +	unsigned int *__kaslr_offset = (unsigned int *)(KERNELBASE + 0x58);
>> +	unsigned int *__run_at_load = (unsigned int *)(KERNELBASE + 0x5c);
> 
> Why are you referencing these by magic offset rather than by symbol?
> 

I'm not sure if relocat works for fixed symbols. I will have a test and 
swith to reference them by symbols if it works fine.

> 
>> +	/* Setup flat device-tree pointer */
>> +	initial_boot_params = dt_ptr;
>> +#endif
> 
> Why does 64-bit need this but 32-bit doesn't?

32-bit called early_get_first_memblock_info() very early which
implicitly setup the device-tree pointer.

> 
> -Scott
> 
> 
> 
> .
> 

