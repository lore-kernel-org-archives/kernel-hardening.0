Return-Path: <SRS0=Fl4W=WE=lists.openwall.com=kernel-hardening-return-16752-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B2AC32751
	for <kernel-hardening@archiver.kernel.org>; Thu,  8 Aug 2019 03:26:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F0E3E21873
	for <kernel-hardening@archiver.kernel.org>; Thu,  8 Aug 2019 03:26:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0E3E21873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16752-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7479 invoked by uid 550); 8 Aug 2019 03:26:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7411 invoked from network); 8 Aug 2019 03:26:16 -0000
Subject: Re: [PATCH v5 01/10] powerpc: unify definition of M_IF_NEEDED
To: Michael Ellerman <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<yebin10@huawei.com>, <thunder.leizhen@huawei.com>,
	<jingxiangfeng@huawei.com>, <fanchengyang@huawei.com>,
	<zhaohongjiang@huawei.com>
References: <20190807065706.11411-1-yanaijie@huawei.com>
 <20190807065706.11411-2-yanaijie@huawei.com>
 <87sgqdt8yc.fsf@concordia.ellerman.id.au>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <bd2f943a-10fb-3473-5611-1a5bb3bedc5b@huawei.com>
Date: Thu, 8 Aug 2019 11:25:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <87sgqdt8yc.fsf@concordia.ellerman.id.au>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.203]
X-CFilter-Loop: Reflected



On 2019/8/7 21:13, Michael Ellerman wrote:
> Jason Yan <yanaijie@huawei.com> writes:
>> M_IF_NEEDED is defined too many times. Move it to a common place.
> 
> The name is not great, can you call it MAS2_M_IF_NEEDED, which at least
> gives a clue what it's for?
> 

OK.

> cheers
> 
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> Cc: Diana Craciun <diana.craciun@nxp.com>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Nicholas Piggin <npiggin@gmail.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
>> Reviewed-by: Diana Craciun <diana.craciun@nxp.com>
>> Tested-by: Diana Craciun <diana.craciun@nxp.com>
>> ---
>>   arch/powerpc/include/asm/nohash/mmu-book3e.h  | 10 ++++++++++
>>   arch/powerpc/kernel/exceptions-64e.S          | 10 ----------
>>   arch/powerpc/kernel/fsl_booke_entry_mapping.S | 10 ----------
>>   arch/powerpc/kernel/misc_64.S                 |  5 -----
>>   4 files changed, 10 insertions(+), 25 deletions(-)
>>
>> diff --git a/arch/powerpc/include/asm/nohash/mmu-book3e.h b/arch/powerpc/include/asm/nohash/mmu-book3e.h
>> index 4c9777d256fb..0877362e48fa 100644
>> --- a/arch/powerpc/include/asm/nohash/mmu-book3e.h
>> +++ b/arch/powerpc/include/asm/nohash/mmu-book3e.h
>> @@ -221,6 +221,16 @@
>>   #define TLBILX_T_CLASS2			6
>>   #define TLBILX_T_CLASS3			7
>>   
>> +/*
>> + * The mapping only needs to be cache-coherent on SMP, except on
>> + * Freescale e500mc derivatives where it's also needed for coherent DMA.
>> + */
>> +#if defined(CONFIG_SMP) || defined(CONFIG_PPC_E500MC)
>> +#define M_IF_NEEDED	MAS2_M
>> +#else
>> +#define M_IF_NEEDED	0
>> +#endif
>> +
>>   #ifndef __ASSEMBLY__
>>   #include <asm/bug.h>
>>   
>> diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
>> index 1cfb3da4a84a..fd49ec07ce4a 100644
>> --- a/arch/powerpc/kernel/exceptions-64e.S
>> +++ b/arch/powerpc/kernel/exceptions-64e.S
>> @@ -1342,16 +1342,6 @@ skpinv:	addi	r6,r6,1				/* Increment */
>>   	sync
>>   	isync
>>   
>> -/*
>> - * The mapping only needs to be cache-coherent on SMP, except on
>> - * Freescale e500mc derivatives where it's also needed for coherent DMA.
>> - */
>> -#if defined(CONFIG_SMP) || defined(CONFIG_PPC_E500MC)
>> -#define M_IF_NEEDED	MAS2_M
>> -#else
>> -#define M_IF_NEEDED	0
>> -#endif
>> -
>>   /* 6. Setup KERNELBASE mapping in TLB[0]
>>    *
>>    * r3 = MAS0 w/TLBSEL & ESEL for the entry we started in
>> diff --git a/arch/powerpc/kernel/fsl_booke_entry_mapping.S b/arch/powerpc/kernel/fsl_booke_entry_mapping.S
>> index ea065282b303..de0980945510 100644
>> --- a/arch/powerpc/kernel/fsl_booke_entry_mapping.S
>> +++ b/arch/powerpc/kernel/fsl_booke_entry_mapping.S
>> @@ -153,16 +153,6 @@ skpinv:	addi	r6,r6,1				/* Increment */
>>   	tlbivax 0,r9
>>   	TLBSYNC
>>   
>> -/*
>> - * The mapping only needs to be cache-coherent on SMP, except on
>> - * Freescale e500mc derivatives where it's also needed for coherent DMA.
>> - */
>> -#if defined(CONFIG_SMP) || defined(CONFIG_PPC_E500MC)
>> -#define M_IF_NEEDED	MAS2_M
>> -#else
>> -#define M_IF_NEEDED	0
>> -#endif
>> -
>>   #if defined(ENTRY_MAPPING_BOOT_SETUP)
>>   
>>   /* 6. Setup KERNELBASE mapping in TLB1[0] */
>> diff --git a/arch/powerpc/kernel/misc_64.S b/arch/powerpc/kernel/misc_64.S
>> index b55a7b4cb543..26074f92d4bc 100644
>> --- a/arch/powerpc/kernel/misc_64.S
>> +++ b/arch/powerpc/kernel/misc_64.S
>> @@ -432,11 +432,6 @@ kexec_create_tlb:
>>   	rlwimi	r9,r10,16,4,15		/* Setup MAS0 = TLBSEL | ESEL(r9) */
>>   
>>   /* Set up a temp identity mapping v:0 to p:0 and return to it. */
>> -#if defined(CONFIG_SMP) || defined(CONFIG_PPC_E500MC)
>> -#define M_IF_NEEDED	MAS2_M
>> -#else
>> -#define M_IF_NEEDED	0
>> -#endif
>>   	mtspr	SPRN_MAS0,r9
>>   
>>   	lis	r9,(MAS1_VALID|MAS1_IPROT)@h
>> -- 
>> 2.17.2
> 
> .
> 

