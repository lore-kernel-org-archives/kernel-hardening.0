Return-Path: <SRS0=T0Ow=WY=lists.openwall.com=kernel-hardening-return-16809-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 910F3C3A5A1
	for <kernel-hardening@archiver.kernel.org>; Wed, 28 Aug 2019 05:34:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D5BAD2173E
	for <kernel-hardening@archiver.kernel.org>; Wed, 28 Aug 2019 05:34:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5BAD2173E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16809-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9734 invoked by uid 550); 28 Aug 2019 05:34:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9699 invoked from network); 28 Aug 2019 05:34:19 -0000
Subject: Re: [PATCH v6 04/12] powerpc/fsl_booke/32: introduce
 create_tlb_entry() helper
To: Scott Wood <oss@buserror.net>
CC: <wangkefeng.wang@huawei.com>, <keescook@chromium.org>,
	<kernel-hardening@lists.openwall.com>, <thunder.leizhen@huawei.com>,
	<linux-kernel@vger.kernel.org>, <npiggin@gmail.com>,
	<jingxiangfeng@huawei.com>, <diana.craciun@nxp.com>, <paulus@samba.org>,
	<zhaohongjiang@huawei.com>, <fanchengyang@huawei.com>,
	<linuxppc-dev@lists.ozlabs.org>, <yebin10@huawei.com>
References: <20190809100800.5426-1-yanaijie@huawei.com>
 <20190809100800.5426-5-yanaijie@huawei.com>
 <20190827220752.GA17757@home.buserror.net>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <1bfdc7c4-e615-0df2-1c0d-4358edcdb43b@huawei.com>
Date: Wed, 28 Aug 2019 13:33:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190827220752.GA17757@home.buserror.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.203]
X-CFilter-Loop: Reflected

Hi Scott,

Thanks for your reply.

On 2019/8/28 6:07, Scott Wood wrote:
> On Fri, Aug 09, 2019 at 06:07:52PM +0800, Jason Yan wrote:
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
>> Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
>> Reviewed-by: Diana Craciun <diana.craciun@nxp.com>
>> Tested-by: Diana Craciun <diana.craciun@nxp.com>
>> ---
>>   arch/powerpc/kernel/head_fsl_booke.S | 29 ++++++++++++++++++++++++++++
>>   arch/powerpc/mm/mmu_decl.h           |  1 +
>>   2 files changed, 30 insertions(+)
>>
>> diff --git a/arch/powerpc/kernel/head_fsl_booke.S b/arch/powerpc/kernel/head_fsl_booke.S
>> index adf0505dbe02..04d124fee17d 100644
>> --- a/arch/powerpc/kernel/head_fsl_booke.S
>> +++ b/arch/powerpc/kernel/head_fsl_booke.S
>> @@ -1114,6 +1114,35 @@ __secondary_hold_acknowledge:
>>   	.long	-1
>>   #endif
>>   
>> +/*
>> + * Create a 64M tlb by address and entry
>> + * r3/r4 - physical address
>> + * r5 - virtual address
>> + * r6 - entry
>> + */
>> +_GLOBAL(create_tlb_entry)
> 
> This function is broadly named but contains various assumptions about the
> entry being created.  I'd just call it create_kaslr_tlb_entry.
> 

OK.

>> +	lis     r7,0x1000               /* Set MAS0(TLBSEL) = 1 */
>> +	rlwimi  r7,r6,16,4,15           /* Setup MAS0 = TLBSEL | ESEL(r6) */
>> +	mtspr   SPRN_MAS0,r7            /* Write MAS0 */
>> +
>> +	lis     r6,(MAS1_VALID|MAS1_IPROT)@h
>> +	ori     r6,r6,(MAS1_TSIZE(BOOK3E_PAGESZ_64M))@l
>> +	mtspr   SPRN_MAS1,r6            /* Write MAS1 */
>> +
>> +	lis     r6,MAS2_EPN_MASK(BOOK3E_PAGESZ_64M)@h
>> +	ori     r6,r6,MAS2_EPN_MASK(BOOK3E_PAGESZ_64M)@l
>> +	and     r6,r6,r5
>> +	ori	r6,r6,MAS2_M@l
>> +	mtspr   SPRN_MAS2,r6            /* Write MAS2(EPN) */
>> +
>> +	ori     r8,r4,(MAS3_SW|MAS3_SR|MAS3_SX)
>> +	mtspr   SPRN_MAS3,r8            /* Write MAS3(RPN) */
>> +
>> +	tlbwe                           /* Write TLB */
>> +	isync
>> +	sync
>> +	blr
> 
> Should set MAS7 under MMU_FTR_BIG_PHYS (or CONFIG_PHYS_64BIT if it's
> too early for features) -- even if relocatable kernels over 4GiB aren't
> supported (I don't remember if they work or not), MAS7 might be non-zero
> on entry.  And the function claims to take a 64-bit phys addr as input...
> 

Good catch. And I should consider 32-bit phys addr as input too. I will 
fix this in next version. Thanks.

> MAS2_M should be MAS2_M_IF_NEEDED to match other kmem tlb entries.
> 

OK

> -Scott
> 
> .
> 

