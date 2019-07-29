Return-Path: <SRS0=3/yJ=V2=lists.openwall.com=kernel-hardening-return-16610-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF278C7618B
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Jul 2019 13:26:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5A2B5206E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Jul 2019 13:26:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A2B5206E0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16610-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7835 invoked by uid 550); 29 Jul 2019 13:26:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7803 invoked from network); 29 Jul 2019 13:26:35 -0000
Subject: Re: [RFC PATCH 04/10] powerpc/fsl_booke/32: introduce
 create_tlb_entry() helper
To: Christophe Leroy <christophe.leroy@c-s.fr>, <mpe@ellerman.id.au>,
	<linuxppc-dev@lists.ozlabs.org>, <diana.craciun@nxp.com>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<yebin10@huawei.com>, <thunder.leizhen@huawei.com>,
	<jingxiangfeng@huawei.com>, <fanchengyang@huawei.com>
References: <20190717080621.40424-1-yanaijie@huawei.com>
 <20190717080621.40424-5-yanaijie@huawei.com>
 <4e6c468d-287b-4bba-675c-8b3f73456500@c-s.fr>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <bf63f6e1-c74f-8494-5f1f-f4c5a1a671fe@huawei.com>
Date: Mon, 29 Jul 2019 21:26:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <4e6c468d-287b-4bba-675c-8b3f73456500@c-s.fr>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.96.203]
X-CFilter-Loop: Reflected


On 2019/7/29 19:05, Christophe Leroy wrote:
> 
> 
> Le 17/07/2019 à 10:06, Jason Yan a écrit :
>> Add a new helper create_tlb_entry() to create a tlb entry by the virtual
>> and physical address. This is a preparation to support boot kernel at a
>> randomized address.
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
>>   arch/powerpc/kernel/head_fsl_booke.S | 30 ++++++++++++++++++++++++++++
>>   arch/powerpc/mm/mmu_decl.h           |  1 +
>>   2 files changed, 31 insertions(+)
>>
>> diff --git a/arch/powerpc/kernel/head_fsl_booke.S 
>> b/arch/powerpc/kernel/head_fsl_booke.S
>> index adf0505dbe02..a57d44638031 100644
>> --- a/arch/powerpc/kernel/head_fsl_booke.S
>> +++ b/arch/powerpc/kernel/head_fsl_booke.S
>> @@ -1114,6 +1114,36 @@ __secondary_hold_acknowledge:
>>       .long    -1
>>   #endif
>> +/*
>> + * Create a 64M tlb by address and entry
>> + * r3/r4 - physical address
>> + * r5 - virtual address
>> + * r6 - entry
>> + */
>> +_GLOBAL(create_tlb_entry)
>> +    lis     r7,0x1000               /* Set MAS0(TLBSEL) = 1 */
>> +    rlwimi  r7,r6,16,4,15           /* Setup MAS0 = TLBSEL | ESEL(r6) */
>> +    mtspr   SPRN_MAS0,r7            /* Write MAS0 */
>> +
>> +    lis     r6,(MAS1_VALID|MAS1_IPROT)@h
>> +    ori     r6,r6,(MAS1_TSIZE(BOOK3E_PAGESZ_64M))@l
>> +    mtspr   SPRN_MAS1,r6            /* Write MAS1 */
>> +
>> +    lis     r6,MAS2_EPN_MASK(BOOK3E_PAGESZ_64M)@h
>> +    ori     r6,r6,MAS2_EPN_MASK(BOOK3E_PAGESZ_64M)@l
>> +    and     r6,r6,r5
>> +    ori    r6,r6,MAS2_M@l
>> +    mtspr   SPRN_MAS2,r6            /* Write MAS2(EPN) */
>> +
>> +    mr      r8,r4
>> +    ori     r8,r8,(MAS3_SW|MAS3_SR|MAS3_SX)
> 
> Could drop the mr r8, r4 and do:
> 
> ori     r8,r4,(MAS3_SW|MAS3_SR|MAS3_SX)
> 

OK, thanks for the suggestion.

>> +    mtspr   SPRN_MAS3,r8            /* Write MAS3(RPN) */
>> +
>> +    tlbwe                           /* Write TLB */
>> +    isync
>> +    sync
>> +    blr
>> +
>>   /*
>>    * Create a tlb entry with the same effective and physical address as
>>    * the tlb entry used by the current running code. But set the TS to 1.
>> diff --git a/arch/powerpc/mm/mmu_decl.h b/arch/powerpc/mm/mmu_decl.h
>> index 32c1a191c28a..d7737cf97cee 100644
>> --- a/arch/powerpc/mm/mmu_decl.h
>> +++ b/arch/powerpc/mm/mmu_decl.h
>> @@ -142,6 +142,7 @@ extern unsigned long calc_cam_sz(unsigned long 
>> ram, unsigned long virt,
>>   extern void adjust_total_lowmem(void);
>>   extern int switch_to_as1(void);
>>   extern void restore_to_as0(int esel, int offset, void *dt_ptr, int 
>> bootcpu);
>> +extern void create_tlb_entry(phys_addr_t phys, unsigned long virt, 
>> int entry);
> 
> Please please do not add new declarations with the useless 'extern' 
> keyword. See checkpatch report: 
> https://openpower.xyz/job/snowpatch/job/snowpatch-linux-checkpatch/8124//artifact/linux/checkpatch.log 
> 

Will drop all useless 'extern' in this and other patches, thanks.

> 
>>   #endif
>>   extern void loadcam_entry(unsigned int index);
>>   extern void loadcam_multi(int first_idx, int num, int tmp_idx);
>>
> 
> .
> 

